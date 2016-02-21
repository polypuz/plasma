local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local destination = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "transport") then
		npcHandler:say("Kursuje miedzy {Mirko Town} a {Suwalkami}. Jak chcesz, to moge Cie zabrac ze soba.", cid)
	elseif npcHandler.topic[cid] == 0 then
		if msgcontains(msg, "mirko town") then
			town[cid] = 1
			destination[cid] = {x = 1011, y = 1022, z = 6}
			npcHandler:say("Jestes pewny, ze chcesz plynac do Mirko Town?", cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say("Moge zaoferowac Ci {transport}.", cid)
		end
	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
			local destination = destination[cid]
			npcHandler:releaseFocus(cid)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
			doTeleportThing(cid, destination)
			doSendMagicEffect(destination, CONST_ME_TELEPORT)
		else
			npcHandler:say("To sie psia mac zdecyduj.", cid)
		end
	elseif msgcontains(msg, "suwalki") or msgcontains(msg, "suwalkami") then
		destination[cid] = { x= 901, y = 2122, z = 6 }
		npcHandler:say("Na pewno chcesz plynac do Suwalek? *usmiecha sie* Ta nazwa nie jest przypadkowa.", cid)
		npcHandler.topic[cid] = 2
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
			local destination = destination[cid]
			npcHandler:releaseFocus(cid)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
			doTeleportThing(cid, destination)
			doSendMagicEffect(destination, CONST_ME_TELEPORT)
		else
			npcHandler:say("To sie psia mac zdecyduj.", cid)
		end
	end

	return true
end

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

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())