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
	print("teleporting player to: " .. tostring( dest ) )
	Player(cid):teleportTo( Position( dest["x"], dest["y"], dest["z"] ) )
	return true
end

local function creatureSayCallback(cid, type, msg)
	local destination = {}
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "transport") then
		npcHandler:say("Kursuje miedzy {Mirko Town} a {Suwalkami}. Jak chcesz, to moge Cie zabrac ze soba.", cid)
	elseif msgcontains(msg, "mirko town") then
			npcHandler:say("Jestes pewny, ze chcesz plynac do Mirko Town?", cid)
			npcHandler.topic[cid] = 1
	elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 1 then
		destination = {x = 1011, y = 1022, z = 6}
		npcHandler:releaseFocus(cid)
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		--doTeleportThing(cid, destination)
		teleportPlayer(cid, destination)
		doSendMagicEffect(destination, CONST_ME_TELEPORT)
	elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
		npcHandler:say("To sie psia mac zdecyduj.", cid)
	elseif msgcontains(msg, "suwalki") or msgcontains(msg, "suwalkami") then
		npcHandler:say("Na pewno chcesz plynac do Suwalek? *usmiecha sie* Ta nazwa nie jest przypadkowa.", cid)
		npcHandler.topic[cid] = 2
	elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 2 then
		destination = { x = 901, y = 2122, z = 6 }
		npcHandler:releaseFocus(cid)
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		--doTeleportThing(cid, destination)
		teleportPlayer(cid, destination)
		doSendMagicEffect(destination, CONST_ME_TELEPORT)
	elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 2 then
		npcHandler:say("To sie psia mac zdecyduj.", cid)
	else
		npcHandler:say("Moge zaoferowac Ci {transport}.", cid)
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