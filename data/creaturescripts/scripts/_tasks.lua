-- Monster Tasks by kajakpt
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)  npcHandler:onCreatureAppear(cid)  end
function onCreatureDisappear(cid)  npcHandler:onCreatureDisappear(cid)  end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()  npcHandler:onThink()  end

local currentTask = 65000


local tasks = {
	{
	 	questStarted = 65001, -- czy zadanie rozpoczete
	 	questKills = 65002, -- liczba ubitych potworow
	 	questFinished = 65003, -- ile gracz ukoczyl zadan
	 	killsRequired = 300, -- liczba potworow do zabicia
	 	raceName = "Elfs", -- nazwa taska
	 	creatures = {
	 		"Elf", "Elf Scout", "Elf Arcanist" -- potwory do zabicia
	 	}, 
	 	minLevel = 1, -- minimalny poziom
	 	maxLevel = 999, -- maksymalny poziom
	 	vocation = { 1, 2, 3, 4, 5, 6, 7, 8 }, -- ktore profesje moga zadanie
	 	repeatable = false, -- czy moze ukonczyc wiele razy
		rewards = { -- nagrody
			{
				enable = true,
				type = "exp",
				values = 200000
			},{
				enable = true,
				type = "money",
				values = 300 -- platinum coins
			},
			{
				enable = true,
				type = "points",
				values = 1
			},{
				enable = true,
				type = "item",
				values = {
					{ 2789, 200 }
				}
			},{
				enable = true,
				bossKilled = 65003, -- 0 - tak, 1 - nie
				type = "boss",
	 			maxPlayers = 1, -- ile graczy moze wejsc
				teleport = {
					x = 1000, y = 1000, z = 7
				},
				creature = {
					'orshabaal'
				},
				text = 'Potwor miesci sie pod depo' -- opis lokalizacji bossa
			}
		}
	},
	{
	 	questStarted = 65011, -- czy zadanie rozpoczete
	 	questKills = 65012, -- liczba ubitych potworow
	 	questFinished = 65013, -- ile gracz ukoczyl zadan
	 	killsRequired = 2, -- liczba potworow do zabicia
	 	raceName = "Rotworms", -- nazwa taska
	 	creatures = {
	 		"Rotworm" -- potwory do zabicia
	 	}, 
	 	minLevel = 1, -- minimalny poziom
	 	maxLevel = 999, -- maksymalny poziom
	 	vocation = { 1, 2, 3, 4, 5, 6, 7, 8 }, -- ktore profesje moga zadanie
	 	repeatable = false, -- czy moze ukonczyc wiele razy
		rewards = { -- nagrody
			{
				enable = true,
				type = "exp",
				values = 20000000000000
			},{
				enable = true,
				type = "money",
				values = 10000 -- platinum coins
			},
			{
				enable = true,
				type = "points",
				values = 1
			},{
				enable = true,
				type = "item",
				values = {
					{ 2390, 1 }
				}
			},{
				enable = true,
				bossKilled = 65003, -- 0 - tak, 1 - nie
				type = "boss",
	 			maxPlayers = 1, -- ile graczy moze wejsc
				teleport = {
					x = 1000, y = 1000, z = 7
				},
				creature = {
					'orshabaal'
				},
				text = 'Potwor miesci sie pod depo' -- opis lokalizacji bossa
			}
		}
	}
}

local function creatureSayCallback(cid, type, msg)
	local currentTask = cid:getStorageValue(currentTask)
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "zadania") or msgcontains(msg, "zadanie") then
		for k, x in pairs(tasks) do
			if cid:getLevel() >= x.minLevel and cid:getLevel() <= x.maxLevel and isInArray(x.vocation, cid:getVocation()) then
		    	text = text .. ", "
		    	text = text .. "".. x.killsRequired .." {".. x.raceName .."}"
			end
		end
        if currentTask == -1 then -- gracz nie wziął jeszcze zadania
			npcHandler:say("Mam dla ciebie nastepujace zadania: " .. text, cid)
            npcHandler.topic[cid] = 1
		elseif currentTask == 1 then
			for k, x in pairs(tasks) do
				if cid:getStorageValue(x.questStarted) == 1 then
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
             	cid:setStorageValue(currentTask, k)
			end
		end
	elseif msgcontains(msg, "tak") and npcHandler.topic[cid] == 20 then -- ukonczenie taska
		local x = tasks[currentTask]
		if cid:getStorageValue(x.questKills) >= x.killsRequired then
			text = ''
			for k, r in pairs(x.rewards) do
				if r.enable == true then
					if r.type == 'exp' then
						doPlayerAddExp(cid, r.values)
						text = text .. r.values .. ' doswiadczenia, '
					elseif r.type == 'money' then
						if r.values > 100 then
							cid:addItem(ITEM_CRYSTAL_COIN, math.floor(r.values) / 100)
							cid:addItem(ITEM_PLATINUM_COIN, r.values % 100)
						else 
							cid:addItem(ITEM_PLATINUM_COIN, r.values / 100)
						end
						text = text .. r.values .. ' zlotych monet, '
					elseif r.type == 'points' then -- dodajemy graczowi 1 punkt
             			cid:setStorageValue(x.questFinished, cid:getStorageValue(x.questFinished) + 1)
						text = text .. ' 1 punkt tasku ' .. x.raceName .. ', '
					elseif r.type == 'item' then -- dodajemy itemy
						for item in r.values do
							cid:addItem(item[0], item[1])
						end
						text = text .. ' itemy, '
					elseif r.type == 'boss' then
						cid:setStorageValue(r.bossKilled, 0)
						text = text .. ' i mozliwosc zabicia bossa. '
					end
				end
			end

			npcHandler:say("Dziekuje, ze zabiles te straszne potwory. W nagrode otrzymujesz  ".. text, cid)
			npcHandler:say(x.text, cid)
		else 
			npcHandler:say("Nie zabiles jeszcze wszystkich potworow Musisz jeszcze zabic ".. x.killsRequired - (cid:getStorageValue(x.mstorage) + 1).." ".. table.concat(c.creatures, ', ') ..". Wroc kiedy skonczysz!", cid)
		end
	end

	return true
end

function onKill(cid, target)
	local currentTask = cid:getStorageValue(currentTask)
	local task = tasks[currentTask]
	local monster = false
	for k, x in pairs(task.creatures) do
		if target:getName():lower() == x:lower() then
			monster = false
		end
	end
	if target:isPlayer() or not monster or target:getMaster() or currentTask == 0 or currendTask == nil then
		return true
	end
	local questKills = cid:getStorageValue(task.questKills) + 1
	if questKills < task.killsRequired then
		if ( questKills == (0) or questKills == (-1) ) then
			questKills = 1
		end

    	cid:setStorageValue(task.questKills, questKills)
    	cid:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Pozostalo Ci '..(task.killsRequired - (questKills)) .. ' ' .. table.concat(task.creatures, ', ') .. ' do zabicia.')
  	elseif questKills == task.killsRequired then
    	cid:sendTextMessage(MESSAGE_INFO_DESCR, 'Gratulacje, udalo Ci sie zabic ' .. (questKills) .. ' ' .. table.concat(task.creatures, ', ') .. ' i ukonczyc zadanie.')
    	cid:setStorageValue(task.questKills, questKills + 1)
  	end
  	return true
end




