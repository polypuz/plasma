/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2016  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "raids.h"

#include "pugicast.h"

#include "game.h"
#include "configmanager.h"
#include "scheduler.h"
#include "monster.h"

#include "database.h"
#include "databasetasks.h"


extern Game g_game;
extern ConfigManager g_config;

Raids::Raids()
	: scriptInterface("Raid Interface")
{
	loaded = false;
	started = false;
	running = nullptr;
	lastRaidEnd = 0;
	checkRaidsEvent = 0;

	scriptInterface.initState();
}

Raids::~Raids()
{
	for (Raid* raid : raidList) {
		delete raid;
	}
}


bool Raids::loadFromDatabase()
{
	std::ostringstream query;
	query << "SELECT *,UNIX_TIMESTAMP(lastExecuted) AS lastExec FROM `raids` WHERE active != 0;";
	DBResult_ptr result = Database::getInstance()->storeQuery(query.str());
	if (!result) {
		std::cout << "Raids :: There are no raids in database!";
		return false;
	}
	do
	{
		uint16_t id = result->getNumber<uint16_t>("raidId");
		std::string name = result->getString("name");
		uint32_t interval = result->getNumber<uint32_t>("timeinterval");
		uint32_t margin = result->getNumber<uint32_t>("timeMargin");
		uint64_t lastExecDate = result->getNumber<uint64_t>("lastExec");
		bool repeat = result->getNumber<int>("repeatable") != 0;
		Raid* newRaid = new Raid(id, name, lastExecDate, interval, margin, repeat);
		if (newRaid->loadFromDatabase(id)) {
			raidList.push_back(newRaid);
		} else {
			std::cout << "[Error - Raids::loadFromDatabase] Failed to load raid: " << name << std::endl;
			delete newRaid;
		}


	} while (result->next());
	loaded = true;
	return true;
}


#define MAX_RAND_RANGE 10000000

bool Raids::startup()
{
	if (!isLoaded() || isStarted()) {
		return false;
	}

	setLastRaidEnd(OTSYS_TIME());

	checkRaidsEvent = g_scheduler.addEvent(createSchedulerTask(CHECK_RAIDS_INTERVAL * 1000, std::bind(&Raids::checkRaids, this)));

	started = true;
	return started;
}

void Raids::checkRaids()
{
	if (!getRunning()) {
		uint64_t now = OTSYS_TIME()/1000; // to hide difference between nextRaidStart (10^3)
		uint32_t nextRaidStart; 
		for (auto it = raidList.begin(), end = raidList.end(); it != end; ++it) {
			Raid* raid = *it;
			nextRaidStart = raid->getLastExecDate() + raid->getInterval()*60 + static_cast<uint32_t>(uniform_random(0, raid->getMargin()*60));
			if (now >= nextRaidStart) {
				setRunning(raid);
				raid->startRaid();
				if (!raid->canBeRepeated()) {
					raidList.erase(it);
				}
				break;
			}
		}
	}

	checkRaidsEvent = g_scheduler.addEvent(createSchedulerTask(CHECK_RAIDS_INTERVAL * 1000, std::bind(&Raids::checkRaids, this)));
}

void Raids::clear()
{
	g_scheduler.stopEvent(checkRaidsEvent);
	checkRaidsEvent = 0;

	for (Raid* raid : raidList) {
		raid->stopEvents();
		delete raid;
	}
	raidList.clear();

	loaded = false;
	started = false;
	running = nullptr;
	lastRaidEnd = 0;

	scriptInterface.reInitState();
}

bool Raids::reload()
{
	clear();
	return loadFromDatabase();
}

Raid* Raids::getRaidByName(const std::string& name)
{
	for (Raid* raid : raidList) {
		if (strcasecmp(raid->getName().c_str(), name.c_str()) == 0) {
			return raid;
		}
	}
	return nullptr;
}

Raid::~Raid()
{
	for (RaidEvent* raidEvent : raidEvents) {
		delete raidEvent;
	}
}

bool Raid::loadFromDatabase(const uint16_t id)
{
	if (isLoaded()) {
		return true;
	}
	std::ostringstream eventsQuery, spawnsQuery, scriptsQuery;
	eventsQuery << "SELECT * FROM `raids_announce`  a INNER JOIN `raids` e ON a.raidId = e.raidId WHERE a.raidId ="<< id;
	DBResult_ptr result = Database::getInstance()->storeQuery(eventsQuery.str());
	RaidEvent* event;	
	if(result!=nullptr)
	{	
		//at first add announcements
		do
		{
			event = new AnnounceEvent();
			if (event->configureRaidEvent(result)) {
				raidEvents.push_back(event);
			} else {
				delete event;
			}
		} while (result->next());
	}
	//then take care of spawns actions
	spawnsQuery << "SELECT * FROM `raids_spawn` a" 
		<< " INNER JOIN `raids` e ON a.raidId = e.raidId"
		<< " INNER JOIN `raids_spawntype` f ON a.spawnTypeId = f.spawnTypeId"
		<<" WHERE a.raidId = " <<id;

	result = Database::getInstance()->storeQuery(spawnsQuery.str());
	if(result != nullptr)
	{
		do
		{
			std::string tmpName = result->getString("name");
			if (strcasecmp(tmpName.c_str(), "single") == 0) {
				event = new SingleSpawnEvent();
			} else if (strcasecmp(tmpName.c_str(), "radius") == 0 || strcasecmp(tmpName.c_str(), "fromto") == 0) {
				event = new AreaSpawnEvent();
			} else if (strcasecmp(tmpName.c_str(), "script") == 0) {
				event = new ScriptEvent(&g_game.raids.getScriptInterface());
			} else {
				continue;
			}
			if(event->configureRaidEvent(result))
			{
				raidEvents.push_back(event);
			}	
		} while (result->next());
	}
	scriptsQuery << "SELECT * FROM `raids_script`  a INNER JOIN `raids` e ON a.raidId = e.raidId WHERE a.raidId ="<< id;
	
	result = Database::getInstance()->storeQuery(scriptsQuery.str());
	//at last add scripts
	if(result != nullptr)
	{
		do
		{
			event = new ScriptEvent(&g_game.raids.getScriptInterface());
			if (event->configureRaidEvent(result)) {
				raidEvents.push_back(event);
			} else {
				delete event;
			}
		} while (result->next());
	}
	//sort by delay time
	std::sort(raidEvents.begin(), raidEvents.end(), RaidEvent::compareEvents);

	loaded = true;
	return true;
}

void Raid::startRaid()
{
	RaidEvent* raidEvent = getNextRaidEvent();
	if (raidEvent) {
		state = RAIDSTATE_EXECUTING;
		nextEventEvent = g_scheduler.addEvent(createSchedulerTask(raidEvent->getDelay(), std::bind(&Raid::executeRaidEvent, this, raidEvent)));
	}
}

void Raid::executeRaidEvent(RaidEvent* raidEvent)
{
	if (raidEvent->executeEvent()) {
		nextEvent++;
		RaidEvent* newRaidEvent = getNextRaidEvent();

		if (newRaidEvent) {
			uint32_t ticks = static_cast<uint32_t>(std::max<int32_t>(RAID_MINTICKS, newRaidEvent->getDelay() - raidEvent->getDelay()));
			nextEventEvent = g_scheduler.addEvent(createSchedulerTask(ticks, std::bind(&Raid::executeRaidEvent, this, newRaidEvent)));
		} else {
			resetRaid();
		}
	} else {
		resetRaid();
	}
}

void Raid::resetRaid()
{
	nextEvent = 0;
	state = RAIDSTATE_IDLE;
	g_game.raids.setRunning(nullptr);
	uint64_t now = OTSYS_TIME();
	g_game.raids.setLastRaidEnd(now);
	std::ostringstream updateQuery;

	//would be nice to deactivate raid if repeatable = 0
	std::string deactivate = repeat?"":", active=0";
	updateQuery << "UPDATE `raids` SET lastExecuted=now()"<< deactivate <<" WHERE raidId="<< getId();

	Database::getInstance()->executeQuery(updateQuery.str());
	lastExecDate = now/1000;//just to be up-to-date with format (10^3 difference with database timestamp	
}

void Raid::stopEvents()
{
	if (nextEventEvent != 0) {
		g_scheduler.stopEvent(nextEventEvent);
		nextEventEvent = 0;
	}
}

RaidEvent* Raid::getNextRaidEvent()
{
	if (nextEvent < raidEvents.size()) {
		return raidEvents[nextEvent];
	} else {
		return nullptr;
	}
}

bool RaidEvent::configureRaidEvent(DBResult_ptr result)
{
	uint32_t resultDelay = result->getNumber<uint32_t>("delay");
	delay = std::max<uint32_t>(RAID_MINTICKS, resultDelay);
	return true;
}

bool AnnounceEvent::configureRaidEvent(DBResult_ptr result) 
{
	if (!RaidEvent::configureRaidEvent(result)) {
		return false;
	}
	message = result->getString("message");

	std::string tmpStrValue = asLowerCaseString(result->getString("type"));
	if (tmpStrValue == "warning") {
		messageType = MESSAGE_STATUS_WARNING;
	} else if (tmpStrValue == "event") {
		messageType = MESSAGE_EVENT_ADVANCE;
	} else if (tmpStrValue == "default") {
		messageType = MESSAGE_EVENT_DEFAULT;
	} else if (tmpStrValue == "description") {
		messageType = MESSAGE_INFO_DESCR;
	} else if (tmpStrValue == "smallstatus") {
		messageType = MESSAGE_STATUS_SMALL;
	} else if (tmpStrValue == "blueconsole") {
		messageType = MESSAGE_STATUS_CONSOLE_BLUE;
	} else if (tmpStrValue == "redconsole") {
		messageType = MESSAGE_STATUS_CONSOLE_RED;
	} else {
		std::cout << "[Notice] Raid: Unknown type tag missing for announce event. Using default: " << static_cast<uint32_t>(messageType) << std::endl;
	}
	return true;
}

bool AnnounceEvent::executeEvent()
{
	g_game.broadcastMessage(message, messageType);
	return true;
}

bool SingleSpawnEvent::configureRaidEvent(DBResult_ptr result)
{
	if (!RaidEvent::configureRaidEvent(result)) {
		return false;
	}

	monsterName = result->getString("monsterName");
	position.x = result->getNumber<uint16_t>("x");
	position.y = result->getNumber<uint16_t>("y");
	position.z = result->getNumber<uint16_t>("z");

	return true;
}

bool SingleSpawnEvent::executeEvent()
{
	Monster* monster = Monster::createMonster(monsterName);
	if (!monster) {
		std::cout << "[Error] Raids: Cant create monster " << monsterName << std::endl;
		return false;
	}

	if (!g_game.placeCreature(monster, position, false, true)) {
		delete monster;
		std::cout << "[Error] Raids: Cant place monster " << monsterName << std::endl;
		return false;
	}
	return true;
}

bool AreaSpawnEvent::configureRaidEvent(DBResult_ptr result)
{
	if (!RaidEvent::configureRaidEvent(result)) {
		return false;
	}
	int32_t radius;
	Position centerPos;		 
	int spawnTypeId;
	spawnTypeId = result->getNumber<int>("spawnTypeId");
	if(spawnTypeId == 2)
	{	 //in reference to db - radius
		radius = result->getNumber<uint32_t>("radius");
		centerPos.x = result->getNumber<uint32_t>("x");
		centerPos.y = result->getNumber<uint32_t>("y");
		centerPos.z = result->getNumber<uint32_t>("z");
		fromPos.x = std::max<int32_t>(0, centerPos.getX() - radius);
		fromPos.y = std::max<int32_t>(0, centerPos.getY() - radius);
		fromPos.z = centerPos.z;
		toPos.x = std::min<int32_t>(0xFFFF, centerPos.getX() + radius);
		toPos.y = std::min<int32_t>(0xFFFF, centerPos.getY() + radius);
		toPos.z = centerPos.z;
	}else{
		 //if not 2 then it must be 3 :) (fromto)
		fromPos.x = result->getNumber<uint32_t>("x");
		fromPos.y = result->getNumber<uint32_t>("y");
		fromPos.z = result->getNumber<uint32_t>("z");
		toPos.x = result->getNumber<uint32_t>("tox");
		toPos.y = result->getNumber<uint32_t>("toy");
		toPos.z = result->getNumber<uint32_t>("toz");
	}
	uint32_t amount = result->getNumber<uint32_t>("amount");
	uint32_t minAmount;
	uint32_t maxAmount;
	if(amount>0)
	{
		minAmount = maxAmount = amount;
	}else
	{
		minAmount = result->getNumber<uint32_t>("minamount");
		maxAmount = result->getNumber<uint32_t>("maxamount");
	}
	const char* name = result->getString("monsterName").c_str();
	spawnList.emplace_back(name, minAmount, maxAmount);
	return true;
}

bool AreaSpawnEvent::executeEvent()
{
	for (const MonsterSpawn& spawn : spawnList) {
		uint32_t amount = uniform_random(spawn.minAmount, spawn.maxAmount);
		for (uint32_t i = 0; i < amount; ++i) {
		
			Monster* monster = Monster::createMonster(spawn.name);
			if (!monster) {
				std::cout << "[Error - AreaSpawnEvent::executeEvent] Can't create monster " << spawn.name << std::endl;
				return false;
			}

			bool success = false;
			for (int32_t tries = 0; tries < MAXIMUM_TRIES_PER_MONSTER; tries++) {
				Tile* tile = g_game.map.getTile(uniform_random(fromPos.x, toPos.x), uniform_random(fromPos.y, toPos.y), uniform_random(fromPos.z, toPos.z));
				if (tile && !tile->isMoveableBlocking() && !tile->hasFlag(TILESTATE_PROTECTIONZONE) && tile->getTopCreature() == nullptr && g_game.placeCreature(monster, tile->getPosition(), false, true)) {
					success = true;
					break;
				}
			}

			if (!success) {
				delete monster;
			}
		}
	}
	return true;
}

ScriptEvent::ScriptEvent(LuaScriptInterface* _interface) :
	Event(_interface)
{
}

bool ScriptEvent::configureRaidEvent(DBResult_ptr result)
{
	if (!RaidEvent::configureRaidEvent(result)) {
		return false;
	}

	std::string scriptAttribute = result->getString("name");

	if (!loadScript("data/raids/scripts/" + scriptAttribute)) {
		std::cout << "Error: [ScriptEvent::configureRaidEvent] Can not load raid script." << std::endl;
		return false;
	}
	return true;
}

std::string ScriptEvent::getScriptEventName() const
{
	return "onRaid";
}

bool ScriptEvent::executeEvent()
{
	//onRaid()
	if (!m_scriptInterface->reserveScriptEnv()) {
		std::cout << "[Error - ScriptEvent::onRaid] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = m_scriptInterface->getScriptEnv();
	env->setScriptId(m_scriptId, m_scriptInterface);

	m_scriptInterface->pushFunction(m_scriptId);

	return m_scriptInterface->callFunction(0);
}
