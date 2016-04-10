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
  if p:getStorageValue(38100) == 4 then
    return true
  end

  return false
end
--[[
--
--1352 1683 6 (od strony dzielnicy)
--1356 1683 6 (od strony miasta
--
 ]]
local city = {x=1356, y=1683, z=6 }
local district = {x=1352, y=1683, z=6}


local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end

  if msgcontains(msg, "przejscie") then
    npcHandler:say("Przejscie jest zamkniete - za ta brama znajduje sie zamknieta {dzielnica Zywiolakow}. Czy posiadasz upowaznienie?", cid)
    npcHandler.topic[cid] = 1
  elseif npcHandler.topic[cid] == 1 then
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      if playerCanPass(cid) then
        npcHandler:say("Hymm... Znasz moze Pintala?", cid)
        npcHandler.topic[cid] = 2
      else
        npcHandler:say("Cos mi sie nie wydaje. Spadaj stad.", cid)
        npcHandler.topic[cid] = 0
      end
    else
      npcHandler:say("Tak myslalem. Spadaj stad, dzieciaku, to nie miejsce dla ciebie.", cid)
      npcHandler.topic[cid] = 0
    end
  elseif npcHandler.topic[cid] == 2 then
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      npcHandler:say({"Tak myslalem. Wspominal mi, glupek jeden...", "Dobra, przelaz. Tylko nikomu ani slowa, bo mnie wyleja, a niedawno zniesiono ustawe 500+, nie bedzie mial kto mlodych utrzymac. Jak bedziesz chcial wrocic do {miasta}, to powiedz po prostu {powrot}."}, cid)
      doTeleportThing(cid, district)
    else
      npcHandler:say("Niewazne. Spadaj, jestem na warcie.", cid)
    end
  elseif msgcontains(msg, "powrot") or msgcontains(msg, "miasta") or msgcontains(msg, "miasto") then
    doTeleportThing(cid, city)
  else
    npcHandler:say("Nie wiem o co chodzi, obywatelu. Prosze odejsc.", cid)
  end

  return true

end


npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
