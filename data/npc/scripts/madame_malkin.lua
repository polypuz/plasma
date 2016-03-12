local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function onPlayerEndTrade(cid) npcHandler:onPlayerEndTrade(cid) end
function onPlayerCloseChannel(cid) npcHandler:onPlayerCloseChannel(cid) end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local price = 5 -- amount
	local crystalCoinsId = 2160 -- crystal coin
	local softBootsId = 2640 -- soft boots
	local wornSoftBootsId = 10021 -- worn soft boots
	local crystalCoins = player:getItemCount(crystalCoinsId)
	local wornSoftBoots = player:getItemCount(wornSoftBootsId)

	if isInArray({"soft boots"}, msg) then
		npcHandler:say("Chcesz zamienic worn {soft boots}? Koszt przywrocenia tych butow do stanu uzywalnosci to 50k.", cid)
		npcHandler.topic[cid] = 1
	elseif isInArray({"yes", "tak"}, msg) and npcHandler.topic[cid] == 1 then
		if wornSoftBoots > 0 and crystalCoins >= price then
			player:removeItem(crystalCoinsId, price)
			player:removeItem(wornSoftBootsId, 1)
			player:addItem(softBootsId, 1)
			npcHandler:say("Prosze bardzo, oto Twoje buty.", cid)
		else
			npcHandler:say("Sorry, ale nie masz zuzytych butow. Tylko worn {soft boots} moge naprawic.", cid)
		end
		npcHandler.topic[cid] = 0
	elseif isInArray({"no", "nie"}, msg ) and npcHandler.topic[cid] == 1 then
		npcHandler:say("Nie to nie, spadaj!", cid)
		npcHandler.topic[cid] = 0
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
