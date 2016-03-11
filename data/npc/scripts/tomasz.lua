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
		npcHandler:say("Moge Cie przeniesc na {Bezludna Wyspa}, lub do {Mirko Town}, za oplata 200 sztuk zlota.", cid)
	elseif msgcontains(msg, "bezludna wyspa") or msgcontains(msg, "wyspa") then
			npcHandler:say("Jestes pewny, ze chcesz plynac na Bezludna Wyspe?", cid)
			npcHandler.topic[cid] = 1
	elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 1 then
    if Player(cid):removeMoney(200) then
		    destination = {x = 581, y = 894, z = 6}
		    doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		    --doTeleportThing(cid, destination)
		    teleportPlayer(cid, destination)
		    doSendMagicEffect(destination, CONST_ME_TELEPORT)
    else
      npcHandler:say("Nie masz tylu pieniedzy.", cid)
      npcHandler.topic[cid] = 0
    end
	elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
		npcHandler:say("To sie psia mac zdecyduj.", cid)
	elseif msgcontains(msg, "mirko town") or msgcontains(msg, "mirko") then
		npcHandler:say("W porzadku, moge zabrac Cie do Mirko Town. Chcesz wyruszyc teraz?", cid)
		npcHandler.topic[cid] = 2
	elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 2 then
		destination = { x = 1104, y = 1314, z = 6 }
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		--doTeleportThing(cid, destination)
		teleportPlayer(cid, destination)
		doSendMagicEffect(destination, CONST_ME_TELEPORT)
	elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 2 then
		npcHandler:say("To sie psia mac zdecyduj.", cid)
	else
		npcHandler:say("Moge Cie {transport}owac, jesli tego zapragniesz.", cid)
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
