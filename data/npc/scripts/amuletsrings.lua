local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function onPlayerEndTrade(cid) npcHandler:onPlayerEndTrade(cid) end
function onPlayerCloseChannel(cid) npcHandler:onPlayerCloseChannel(cid) end


local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)



local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)

	if isInArray({"life crystal", "life ring", "life"}, msg) then
		npcHandler:say("Moge wytworzyc pierscien z {life crystal}, nauczyla mnie tego mama. Czy chcesz, abym sprobowal zrobic to z Twoim krysztalem?", cid)
		npcHandler.topic[cid] = 1
	elseif isInArray({"yes", "tak"}, msg) and npcHandler.topic[cid] == 1 then
		if player:removeItem( 2177, 1) then
			player:addItem( 2168, 1 )
			npcHandler:say("Prosze bardzo, oto Twoj pierscionek.", cid)
		else
			npcHandler:say("Sorry, ale nie masz tego krysztalu ze soba. Tylko {life crystal} nadaje sie do wytworzenia tego pierscienia.", cid)
		end
		npcHandler.topic[cid] = 0
	elseif isInArray({"no", "nie"}, msg ) and npcHandler.topic[cid] == 1 then
		npcHandler:say("Nie to nie, spadaj!", cid)
		npcHandler.topic[cid] = 0
	end
end

shopModule:addBuyableItem({'wedding ring'}, 2121, 990,'wedding ring')
shopModule:addBuyableItem({'Golden Amulet'}, 2130, 6600,'Golden Amulet')
shopModule:addBuyableItem({'Scarf'}, 2661, 15,'Scarf')
shopModule:addBuyableItem({'Ruby Necklace'}, 2133, 3560,'Ruby Necklace')


shopModule:addSellableItem({'crystal of balance'}, 9942, 1000,'crystal of balance')
shopModule:addSellableItem({'crystal of focus'}, 9941, 2000,'crystal of focus')
shopModule:addSellableItem({'crystal of power'}, 9980, 3000,'crystal of power')

shopModule:addSellableItem({'Small Sapphire'}, 2146, 250,'Small Sapphire')
shopModule:addSellableItem({'Small Diamond'}, 2145, 300,'Small Diamond')
shopModule:addSellableItem({'Black Pearl'}, 2144, 280,'Black pearl')
shopModule:addSellableItem({'Gold ingot'}, 9971, 5000,'Gold ingot')
shopModule:addSellableItem({'Scarab coin'}, 2159, 100,'Scarab coin')
shopModule:addSellableItem({'Small Amethyst'}, 2150, 200,'Small Amethyst')
shopModule:addSellableItem({'Small Emerald'}, 2149, 250,'Small Emerald')
shopModule:addSellableItem({'Small Ruby'}, 2147, 250,'Small Ruby')
shopModule:addSellableItem({'Small Topaz'}, 9970, 200,'Small Topaz')
shopModule:addSellableItem({'White Pearl'}, 2143, 160,'White Pearl')
shopModule:addSellableItem({'Blue Gem'}, 2158, 5000,'Blue Gem')
shopModule:addSellableItem({'Green Gem'}, 2155, 5000,'Green Gem')
shopModule:addSellableItem({'Red Gem'}, 2156, 1000,'Red Gem')
shopModule:addSellableItem({'Violet Gem'}, 2153, 10000,'Violet Gem')
shopModule:addSellableItem({'Yellow Gem'}, 2154, 1000,'Yellow Gem')

shopModule:addSellableItem({'Wolf Tooth Chain'}, 2129, 100,'Wolf Tooth Chain')
shopModule:addSellableItem({'Amulet of loss'}, 2173, 25000,'Amulet of loss')



npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
