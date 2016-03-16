-- Monster Tasks by kajakpt
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)  npcHandler:onCreatureAppear(cid)  end
function onCreatureDisappear(cid)  npcHandler:onCreatureDisappear(cid)  end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()  npcHandler:onThink()  end

local function greetCallback(cid)
	return true
end

local currentTask = CURRENT_TASK

local tasks = PLAYER_TASKS

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local currentTask = player:getStorageValue(currentTask)
	if not npcHandler:isFocused(cid) then
		return false
		elseif msgcontains(msg, "zadania") or msgcontains(msg, "zadanie") then
			for k, x in pairs(tasks) do
				if player:getLevel() >= x.minLevel and player:getLevel() <= x.maxLevel and isInArray(x.vocation, player:getVocation()) then
					text = text .. ", "
					text = text .. "".. x.killsRequired .." {".. x.raceName .."}"
				end
			end
		if currentTask == -1 then -- gracz nie wziął jeszcze zadania
			npcHandler:say("Mam dla ciebie nastepujace zadania: " .. text, cid)
			npcHandler.topic[cid] = 1
			elseif currentTask == 1 then
				for k, x in pairs(tasks) do
					if player:getStorageValue(x.questStarted) == 1 then
						npcHandler:say("Czy zabiles juz ".. x.killsRequired .." ".. table.concat(c.creatures, ', ') .."?", cid)
						npcHandler.topic[cid] = 20
					end
				end
			end
	elseif npcHandler.topic[cid] == 1 then -- wziecie zadania
		for k, x in pairs(tasks) do
			if msgcontains(msg, x.raceName) then
				npcHandler:say("Jestes pewny, ze chcesz zabic " .. x.killsRequired .." ".. table.concat(c.creatures, ', ') .."?", cid)
				npcHandler.topic[cid] = x.questStarted
			end
		end
	elseif msgcontains(msg, "tak") and npcHandler.topic[cid] > 1000 then -- potwierdzenie wziecia nowego zadania
		for k, x in pairs(tasks) do
			if x.questStarted == npcHandler.topic[cid] then
				npcHandler:say("Powodzenia. Wroc kiedy zabijesz wszystkie potwory.", cid)
				player:setStorageValue(currentTask, k)
			end
		end
	elseif msgcontains(msg, "tak") and npcHandler.topic[cid] == 20 then -- ukonczenie taska
		local x = tasks[currentTask]
		if player:getStorageValue(x.questKills) >= x.killsRequired then
			text = ''
			for k, r in pairs(x.rewards) do
				if r.enable == true then
					if r.type == 'exp' then
						doPlayerAddExp(cid, r.values)
						text = text .. r.values .. ' doswiadczenia, '
						elseif r.type == 'money' then
							if r.values > 100 then
								player:addItem(ITEM_CRYSTAL_COIN, math.floor(r.values) / 100)
								player:addItem(ITEM_PLATINUM_COIN, r.values % 100)
							else 
								player:addItem(ITEM_PLATINUM_COIN, r.values / 100)
							end
							text = text .. r.values .. ' zlotych monet, '
					elseif r.type == 'points' then -- dodajemy graczowi 1 punkt
						player:setStorageValue(x.questFinished, player:getStorageValue(x.questFinished) + 1)
						text = text .. ' 1 punkt tasku ' .. x.raceName .. ', '
					elseif r.type == 'item' then -- dodajemy itemy
						for item in r.values do
							player:addItem(item[0], item[1])
						end
						text = text .. ' itemy, '
						elseif r.type == 'boss' then
							player:setStorageValue(r.bossKilled, 0)
							text = text .. ' i mozliwosc zabicia bossa. '
						end
					end
				end

				npcHandler:say("Dziekuje, ze zabiles te straszne potwory. W nagrode otrzymujesz  ".. text, cid)
				npcHandler:say(x.text, cid)
			else 
				npcHandler:say("Nie zabiles jeszcze wszystkich potworow Musisz jeszcze zabic ".. x.killsRequired - (player:getStorageValue(x.mstorage) + 1).." ".. table.concat(c.creatures, ', ') ..". Wroc kiedy skonczysz!", cid)
			end
		end

		return true
	end
	npcHandler:setCallback(CALLBACK_GREET, greetCallback)
	npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
	npcHandler:addModule(FocusModule:new())
