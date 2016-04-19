--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 10.04.16
-- Time: 00:48
-- To change this template use File | Settings | File Templates.
--
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

local function playerCanPass(cid)
  local p = Player(cid)
  if p:getStorageValue(38150) == 3 then
    return true
  end

  return false
end
--[[
--
--1437 1534 5 (od strony dzielnicy)
--1437 1538 5 (od strony miasta
--
 ]]
local city = {x=1437, y=1538, z=5 }
local district = {x=1437, y=1534, z=5}

local function teleportPlayer(cid, pos)
  if not npcHandler:isFocused(cid) then
    return false
  else
    doTeleportThing(cid, pos)
  end
  return true
end

local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end

  if msgcontains(msg, "przejscie") then
    npcHandler:say("Przejscie jest zamkniete - za ta brama znajduje sie zamknieta {Zniszczona Dzielnica}. Czy posiadasz upowaznienie?", cid)
    npcHandler.topic[cid] = 1
  elseif npcHandler.topic[cid] == 1 then
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      if playerCanPass(cid) then
        npcHandler:say("W porzadku, przechodz. Jak bedziesz chcial wrocic do {miasta}, to powiedz po prostu {powrot}. *wyjmuje klucze do bramy*", cid)
        addEvent( teleportPlayer, 1950, cid, district)
      else
        npcHandler:say("Cos mi sie nie wydaje. Spadaj stad, dzieciaku, to nie miejsce dla ciebie.", cid)      \
        npcHandler.topic[cid] = 0
      end
    else
      npcHandler:say("Tak myslalem. Spadaj stad, dzieciaku, to nie miejsce dla ciebie.", cid)
      npcHandler.topic[cid] = 0
    end
  elseif msgcontains(msg, "powrot") or msgcontains(msg, "miasta") or msgcontains(msg, "miasto") then
    npcHandler:say("Juz otwieram. Tylko szybko! *wyjmuje klucze do bramy*", cid)
    addEvent( teleportPlayer, 1600, cid, city)
  else
    npcHandler:say("Nie wiem o co chodzi, obywatelu. Prosze odejsc.", cid)
  end
  return true
end


npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
