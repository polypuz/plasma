local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	if getPlayerLevel(cid) < 80 then
		npcHandler:say("Odejdz dzieciaku, za cienki w uszach jestes.", cid)
		npcHandler:releaseFocus(cid)
		return false
	end

	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "martwe drzewa") or msgcontains(msg, "drzewa") then
		npcHandler:say("Nie wiem skad o nich wiesz... Lepiej o tym zapomnij. No chyba ze jestes gotowy na {wyzwanie}.", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "wyzwanie") then
		if getPlayerStorageValue(cid, 36900) == 1 then
			npcHandler:say("Wiesz juz co masz robic. Jezeli juz zapomniales, zapytaj o {trening}.", cid)
		elseif getPlayerStorageValue(cid, 36900) == 2 then
			npcHandler:say("Ukonczyles juz trening. Wroc do mnie kiedy pokonasz krysztalowe drzewo.", cid)
			npcHandler:releaseFocus(cid)
		elseif getPlayerStorageValue(cid, 36900) > 2 then
			npcHandler:say("Nie mamy juz o czym rozmawiac.", cid)
			npcHandler:releaseFocus(cid)
		elseif npcHandler.topic[cid] == 1 then
			npcHandler:say("Sluchaj zatem. Na tej wyspie jest kilka tajemniczych drzew. Z pozoru wygladaja jak martwe pnie, ale nie daj sie zwiesc! Zeby ukonczyc szkolenie i pokonac krysztalowy pien musisz potrenowac. Pni jest dokladnie piec. Jezeli w przyszlosci bedziesz chcial sprawdzic swoje umiejetnosci, wroc do mnie i zapytaj o {trening}.", cid)
			setPlayerStorageValue(cid, 36900, 1)
		else
			npcHandler:say("Nie wiem o co ci chodzi.", cid)
			npcHandler:releaseFocus(cid)
		end
	elseif msgcontains(msg, "trening") then
		if getPlayerStorageValue(cid, 36900) == 1 then
			local counter = 0

			if getPlayerStorageValue(cid, 36001) ~= 1 then
				counter = counter + 1
			end
			if getPlayerStorageValue(cid, 36002) ~= 1 then
				counter = counter + 1
			end
			if getPlayerStorageValue(cid, 36003) ~= 1 then
				counter = counter + 1
			end
			if getPlayerStorageValue(cid, 36004) ~= 1 then
				counter = counter + 1
			end
			if getPlayerStorageValue(cid, 36005) ~= 1 then
				counter = counter + 1
			end

			if counter > 0 then
				if counter == 1 then
					string = 'pozostalo tylko jedno drzewo'
				elseif counter == 2 then
					string = 'zostaly ci dwa drzewa'
				elseif counter == 3 then
					string = 'zostaly ci trzy drzewa'
				elseif counter == 4 then
					string = 'zostaly ci cztery drzewa'
				elseif counter == 5 then
					string = 'pozostalo ci az piec drzew'
				else
					string = 'pozostalo ci jeszcze kilka drzew'
				end

				npcHandler:say("Nie ukonczyles jeszcze treningu. Do konca " ..  string .. ". Wroc do mnie kiedy bedziesz gotowy.", cid)
				npcHandler:releaseFocus(cid)
			else
				npcHandler:say("Gratulacje, Twoj trening dobiegl konca! Teraz pora zebys zmierzyl sie z krysztalowym drzewem. Jezeli to zrobisz, bedziesz {gotowy}. Powodzenia!", cid)
				npcHandler:releaseFocus(cid)
				setPlayerStorageValue(cid, 36900, 2)
			end
		elseif getPlayerStorageValue(cid, 36900) > 1 then
			npcHandler:say("Nie mamy juz o czym rozmawiac.", cid)
			npcHandler:releaseFocus(cid)
		else
			npcHandler:say("Nie wiem o czym mowisz. Odejdz.", cid)
			npcHandler:releaseFocus(cid)
		end
	elseif msgcontains(msg, "gotowy") or msgcontains(msg, "gotow") then
		if getPlayerStorageValue(cid, 36006) == 1 then
			npcHandler:say("Czy naprawde pokonales krysztalowe drzewo?", cid)
			npcHandler.topic[cid] = 6
		else
			npcHandler:say("Nie pokonales krysztalowego drzewa! Wroc kiedy tego dokonasz.", cid)
			npcHandler:releaseFocus(cid)
		end
	elseif msgcontains(msg, "tak") or msgcontains(msg, "yes") then
		if getPlayerStorageValue(cid, 36006) == 1 then
			npcHandler:say("Nie wiem jak tego dokonales, ale jestes wielkim wojownikiem. Teraz jestes gotowy by odkrywac tajemnice wyspy! Zegnaj, przyjacielu.", cid)
			setPlayerStorageValue(cid, 36900, 2)
			npcHandler:releaseFocus(cid)
		end
	else
		npcHandler:say("Jezeli nie wiesz o czym chcesz rozmawiac, to odejdz i nie marnuj mojego czasu.", cid)
		npcHandler:releaseFocus(cid)
	end

	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())