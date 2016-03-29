local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
 
local Topic, count, transfer = {}, {}, {}
 
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
 
local function getCount(s)
        local b, e = s:find('%d+')
        return b and e and math.min(4294967295, tonumber(s:sub(b, e))) or -1
end
 
local function findPlayer(name)
        local q = db.storeQuery('SELECT name FROM players WHERE name=' .. db.escapeString(name) .. ' LIMIT 1'), nil
        if q:getID() == -1 then
                return
        end
        local r = q:getDataString('name')
        q:free()
        return r
end
 
function greet(cid)
        Topic[cid], count[cid], transfer[cid] = nil, nil, nil
        return true
end
 
function creatureSayCallback(cid, type, msg)
		local player = Player( cid )

        if not npcHandler:isFocused(cid) then
                return false
        elseif msgcontains(msg, 'stan konta') or msgcontains(msg, 'balance') then
                npcHandler:say('Stan twojego konta wynosi ' .. getPlayerBalance(cid) .. ' zlota.', cid)
                Topic[cid] = nil

        elseif msgcontains(msg, 'deposit') and msgcontains(msg, 'all') then
                if getPlayerMoney(cid) == 0 then
                        npcHandler:say('Nie masz przy sobie zadnego zlota..', cid)
                        Topic[cid] = nil
                else
                        count[cid] = getPlayerMoney(cid)
                        npcHandler:say('Chcesz wplacic wszystko? Hm, przeliczmy... Wychodzi ' .. count[cid] .. ' zlota, zgadza sie?', cid)
                        Topic[cid] = 2
                end
        elseif msgcontains(msg, 'deposit') then
                if getCount(msg) == 0 then
                        npcHandler:say('Zartujesz, tak?', cid)
                        Topic[cid] = nil
                elseif getCount(msg) ~= -1 then
                        if getPlayerMoney(cid) >= getCount(msg) then
                                count[cid] = getCount(msg)
                                npcHandler:say('Czy na pewno chcesz wplacic ' .. count[cid] .. ' sztuk zlota?', cid)
                                Topic[cid] = 2
                        else
                                npcHandler:say('Nie masz wystarczajacej ilosci sztuk zlota.', cid)
                                Topic[cid] = nil
                        end
                elseif getPlayerMoney(cid) == 0 then
                        npcHandler:say('Nie masz tyle zlota przy sobie.', cid)
                        Topic[cid] = nil
                else
                        npcHandler:say('Powiedz mi, ile zlota chcialbys wplacic.', cid)
                        Topic[cid] = 1
                end
        elseif Topic[cid] == 1 then
                if getCount(msg) == -1 then
                        npcHandler:say('Powiedz mi, ile zlota chcialbys wplacic.', cid)
                        Topic[cid] = 1
                elseif getPlayerMoney(cid) >= getCount(msg) then
                        count[cid] = getCount(msg)
                        npcHandler:say('Na pewno chcesz wplacic ' .. count[cid] .. ' sztuk zlota?', cid)
                        Topic[cid] = 2
                else
                        npcHandler:say('Nie masz tylu sztuk zlota.', cid)
                        Topic[cid] = nil
                end
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'tak')) and Topic[cid] == 2 then
                if doPlayerRemoveMoney(cid, count[cid]) then
                        doPlayerSetBalance(cid, getPlayerBalance(cid) + count[cid])
                        npcHandler:say('Dobrze, wplacilismy ' .. count[cid] .. ' sztuk zlota na twoje konto. Mozesz je wyplacic w kazdym momencie.', cid)
                else
                        npcHandler:say('Obawiam sie, ze Twoje zloto gdzies ucieklo. Powodzenia w odszukiwaniu go. ', cid)
                end
                Topic[cid] = nil
        elseif msgcontains(msg, 'no') or msgcontains(msg, 'nie') and Topic[cid] == 2 then
                npcHandler:say('Prosze bardzo. Jest jeszcze cos, co moge dla ciebie zrobic?', cid)
                Topic[cid] = nil

        elseif msgcontains(msg, 'withdraw') or msgcontains(msg, 'wyplac') then
                if getCount(msg) == 0 then
                        npcHandler:say('Mam neoliberalne poglady - zazadales 0 zlota, wiec prosze bardzo: oto Twoje 0 zlota! Nie wydaj na glupoty.', cid)
                        Topic[cid] = nil
                elseif getCount(msg) ~= -1 then
                        if getPlayerBalance(cid) >= getCount(msg) then
                                count[cid] = getCount(msg)
                                npcHandler:say('Jestes pewny ze chcesz wyplacic ' .. count[cid] .. ' sztuk zlota z twojego konta?', cid)
                                Topic[cid] = 4
                        else
                                npcHandler:say('Nie ma tylu sztuk zlota na twoim koncie.', cid)
                                Topic[cid] = nil
                        end
                elseif getPlayerBalance(cid) == 0 then
                        npcHandler:say('Nie posiadasz tylu sztuk zlota.', cid)
                        Topic[cid] = nil
                else
                        npcHandler:say('Ile zlota chcialbys wyplacic?', cid)
                        Topic[cid] = 3
                end
        elseif Topic[cid] == 3 then
                if getCount(msg) == -1 then
                        npcHandler:say('Powiedz mi, prosze, ile zlota chcesz wyplacic.', cid)
                        Topic[cid] = 3
                elseif getPlayerBalance(cid) >= getCount(msg) then
                        count[cid] = getCount(msg)
						if ( getCount( msg ) < 1) then
							npcHandler:say('Nie mozesz wyplacic mniej niz 1 sztuke zlota.', cid)
							Topic[cid] = nil
						else
							npcHandler:say('Na pewno chcesz wyplacic ' .. count[cid] .. ' sztuk zlota z twojego konta bankowego?', cid)
							Topic[cid] = 4
						end
                else
                        npcHandler:say('Na twoim koncie bankowym nie ma odpowiedniej ilosci sztuk zlota.', cid)
                        Topic[cid] = nil
                end
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'tak')) and Topic[cid] == 4 then
                if getPlayerBalance(cid) >= count[cid] and count[cid] > 0 then
                        doPlayerAddMoney(cid, count[cid])
                        doPlayerSetBalance(cid, getPlayerBalance(cid) - count[cid])
                        npcHandler:say('Prosze bardzo, to twoje ' .. count[cid] .. ' sztuk zlota. Poinformuj mnie gdy bede mogl dla ciebie zrobic cos jeszcze.', cid)
                else
                        npcHandler:say('Nie posiadasz odpowiedniej ilosci sztuk zlota na swoim koncie.', cid)
                end
                Topic[cid] = nil
        elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nie')) and Topic[cid] == 4 then
                npcHandler:say('Klient nasz pan! Wroc gdy bedziesz potrzebowal jeszcze czegos!', cid)
                Topic[cid] = nil
        elseif msgcontains(msg, 'transfer') or msgcontains(msg, 'przelew') then
			npcHandler:say('Tak jak mowilem, moj bank zostal przejety przez ABWehre, nie bardzo moge teraz w jakikolwiek sposob zarzadzac pieniedzmi. Przyjdz pozniej.', cid)
			Topic[cid] = nil--[[
                if getCount(msg) == 0 then
                        npcHandler:say('Prosze o tym pomyslec, dobrze?', cid)
                        Topic[cid] = nil
                elseif getCount(msg) ~= -1 then
                        count[cid] = getCount(msg)
                        if getPlayerBalance(cid) >= count[cid] then
                                npcHandler:say('Do kogo chcialbys wyslac ' .. count[cid] .. ' sztuk zlota?', cid)
                                Topic[cid] = 6
                        else
                                npcHandler:say('Nie masz wystarczajacej ilosci zlota na swoim koncie.', cid)
                                Topic[cid] = nil
                        end
                else
                        npcHandler:say('Prosze, powiedz, ile zlota chcialbys przelac.', cid)
                        Topic[cid] = 5
                end
        elseif Topic[cid] == 5 then
                if getCount(msg) == -1 then
                        npcHandler:say('Prosze, powiedz jaka ilosc sztuk zlota chcialbys przelac.', cid)
                        Topic[cid] = 5
                else
                        count[cid] = getCount(msg)
                        if getPlayerBalance(cid) >= count[cid] then
                                npcHandler:say('Do kogo chcesz przelac ' .. count[cid] .. ' sztuk zlota', cid)
                                Topic[cid] = 6
                        else
                                npcHandler:say('Nie masz wystarczajacej ilosci sztuk zlota.', cid)
                                Topic[cid] = nil
                        end
                end
        elseif Topic[cid] == 6 then
                local v = getPlayerByName(msg)
                if getPlayerBalance(cid) >= count[cid] then
                        if v then
                                transfer[cid] = msg
                                npcHandler:say('Na pewno chcesz przelac ' .. count[cid] .. ' sztuk zlota do ' .. getPlayerName(v) .. '?', cid)
                                Topic[cid] = 7
                        elseif findPlayer(msg):lower() == msg:lower() then
                                transfer[cid] = msg
                                npcHandler:say('Na pewno chcesz wyslac ' .. count[cid] .. ' sztuk zlota do ' .. findPlayer(msg) .. '?', cid)
                                Topic[cid] = 7
                        else
                                npcHandler:say('Taki mirek nie istnieje.', cid)
                                Topic[cid] = nil
                        end
                else
                        npcHandler:say('Nie masz wystarczajacej ilosci sztuk zlota.', cid)
                        Topic[cid] = nil
                end
        elseif Topic[cid] == 7 and msgcontains(msg, 'yes') then
                if getPlayerBalance(cid) >= count[cid] then
                        local v = getPlayerByName(transfer[cid])
                        if v then
                                doPlayerSetBalance(cid, getPlayerBalance(cid) - count[cid])
                                doPlayerSetBalance(v, getPlayerBalance(v) + count[cid])
                                npcHandler:say('Bardzo dobrze, ' .. count[cid] .. ' sztuk zlota zostalo wyslane do gracza ' .. getPlayerName(v) .. '.', cid)
                        elseif findPlayer(transfer[cid]):lower() == transfer[cid]:lower() then
                                doPlayerSetBalance(cid, getPlayerBalance(cid) - count[cid])
                                db.executeQuery('UPDATE players SET balance=balance+' .. count[cid] .. ' WHERE name=' .. db.escapeString(transfer[cid]) .. ' LIMIT 1')
                                npcHandler:say('Dobrze, przelalismy' .. count[cid] .. ' sztuk zlota do ' .. findPlayer(transfer[cid]) .. '.', cid)
                        else
                                npcHandler:say('Taki gracz nie istnieje.', cid)
                        end
                else
                        npcHandler:say('Nie masz wystarczajacej ilosci sztuk zlota.', cid)
                end
                Topic[cid] = nil
				]]
        elseif Topic[cid] == 7 and (msgcontains(msg, 'no') or msgcontains(msg, 'nie')) then
                npcHandler:say('Czy moglbym jeszcze cos dla ciebie zrobic?', cid)
                Topic[cid] = nil
        elseif msgcontains(msg, 'bank') then
                npcHandler:say('Mozesz u nas wyplacic pieniadze oraz zarzadzac swoim kontem bankowym.', cid)
                Topic[cid] = nil
        end
        return true
end
 
npcHandler:setCallback(CALLBACK_GREET, greet)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())