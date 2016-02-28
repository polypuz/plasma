local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	return true
end

local function teleportPlayer( cid, dest )
	Player(cid):teleportTo(Position(dest["x"], dest["y"], dest["z"]))
	return true
end

local function creatureSayCallback(cid, type, msg)
	local destination = {}
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "transport") or msgcontains(msg, "przebujac") or msgcontains(msg, "przebujac sie") then
		npcHandler:say("Moge przebujac sie z Toba miedzy {Suwalkami} a {Lodowa Wyspa}, jak chcesz.", cid)
	elseif msgcontains(msg, "suwalki") or msgcontains(msg, "suwalkami") then
			npcHandler:say("Jestes pewny, ze chcesz plynac do Suwalek?", cid)
			npcHandler.topic[cid] = 1
	elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 1 then
		destination = {x = 885, y = 2045, z = 7}
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		--doTeleportThing(cid, destination)
		teleportPlayer(cid, destination)
		doSendMagicEffect(destination, CONST_ME_TELEPORT)
	elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
		npcHandler:say("To sie psia mac zdecyduj.", cid)
	elseif msgcontains(msg, "lodowa wyspa") or msgcontains(msg, "wyspa") then
		npcHandler:say("W porzadku, moge zabrac Cie na wyspe, jesli tego naprawde chcesz. To co, wskakujesz?", cid)
		npcHandler.topic[cid] = 2
	elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 2 then
		destination = { x = 945, y = 2076, z = 7 }
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		--doTeleportThing(cid, destination)
		teleportPlayer(cid, destination)
		doSendMagicEffect(destination, CONST_ME_TELEPORT)
	elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 2 then
		npcHandler:say("To sie psia mac zdecyduj.", cid)
	else
		npcHandler:say("Mozemy sie razem {przebujac}, jak chcesz.", cid)
	end

	return true
end
--[[
local function onAddFocus(cid)
	-- town[cid] = 0
	-- vocation[cid] = 0
	-- destination[cid] = 0
end

local function onReleaseFocus(cid)
	-- town[cid] = nil
	-- vocation[cid] = nil
	-- destination[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
]]
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
