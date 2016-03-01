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

local alreadyTensed = false

local function creatureSayCallback(cid, type, msg)
	local storageValGood = 39650 -- zakon 4konserw
  local storageValBad = 39651 -- zakon Neuropy
  --[[
    -1 = haven't taken the quests
    0 = have taken the recruitment quests
    1 = finished the recruitment quest (JOINED) (outfit)
    2 = taken the first rank quest (1000 demonic)
    3 = finished ^
    4 = taken rank 2 quest
    5 = finished ^, rank 2 (addon 2 + shield)
  ]]

  local player = Player( cid )
	if not npcHandler:isFocused(cid) then
		return false
  elseif player:getStorageValue( storageValBad ) ~= -1 then
		if alreadyTensed then
			doTargetCombatHealth(0, cid, 1, player:getHealth() * 0.1 * -1, math.random(0.11, 0.76) * player:getHealth() * -1, 1)
			npcHandler:say("OSTRZEGALEM. ODEJDZ.", cid)
		else
			npcHandler:say("Radze odejsc, " .. player:getName() .. ", nie zwyklem tolerowac neuropejczykow.", cid)
			alreadyTensed = true
			print("Already tensed? " .. tostring(alreadyTensed))
		end
  elseif (msgcontains(msg, "zakon") or msgcontains(msg, "4konserwy") or msgcontains(msg, "4konserw")) and player:getStorageValue( storageValGood ) < 0 then
    npcHandler:say({"Zakon 4konserw jest ostatnimi czasy oslabiony, a z tego co wiem - jestem jedynym ocalalym nauczycielem.", "Kazdy z czlonkow jednak - musi byc pelen cnot, znac i przestrzegac 3 aksjomat, wierzyc w Krula do samego konca.", "Aby dolaczyc do {Zakonu} musisz jednak udowodnic, ze jestes tego warty. Czy jestes zainteresowany, " .. Player(cid):getName() .. "?"}, cid)
    npcHandler.topic[cid] = 1
  elseif (msgcontains(msg, "yes") or msgcontains(msg, "tak")) and npcHandler.topic[cid] == 1 then
    npcHandler:say({"Musze Cie jednak ostrzec: nasi odwieczni przeciwnicy, {Zakon Neuropy} nie beda chcieli z Toba rozmawiac, gdy do nas dolaczysz. Jakikolwiek kontakt, jestem prawie pewny, skonczy sie smiertelna konfrontacja.", "Czy nadal jestes pewny swojej decyzji?"}, cid)
    npcHandler.topic[cid] = 2
  elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
    -- no @ 1
    npcHandler:say({"Rozumiem. W takim razie idz w pokoju."}, cid)
    npcHandler.topic[cid] = 0
  elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 2 then
    npcHandler:say({"W porzadku. Aby jednak udowodnic swoja wartosc, przynies mi 500 {Demonic Essence}. To jest Twoje pierwsze {zadanie}. Zycze powodzenia."}, cid)
    player:setStorageValue( storageValGood, 0 )
    npcHandler.topic[cid] = 0

  elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 2 then
    npcHandler:say({"Rozumiem. W takim razie idz w pokoju."}, cid)
    npcHandler.topic[cid] = 0
  elseif (msgcontains(msg, "zadanie")) and player:getStorageValue(storageValGood) ~= -1 then
    local quests = {0, 2, 4}
    if isInArray(quests, player:getStorageValue( storageValGood )) then
      local zadId = player:getStorageValue( storageValGood )
      if zadId == 0 then
        npcHandler:say("Czy przyniosles mi 500 {Demonic Essence}?", cid)
        npcHandler.topic[cid] = 10
      elseif zadId == 2 then
        npcHandler:say("Czy przyniosles mi 1000 {Demonic Essence}?", cid)
        npcHandler.topic[cid] = 11
      elseif zadId == 4 then
        npcHandler:say("Czy przyniosles mi 1500 {Demonic Essence}?", cid)
        npcHandler.topic[cid] = 12
      end
    else
      if player:getStorageValue(storageValGood) > 4 then
        npcHandler:say("Niestety, ale nie mam dla Ciebie wiecej zadan. Jestes konserwa najwyzszej rangi.", cid)
      else
        if player:getStorageValue(storageValGood) < 0 then
          npcHandler:say("Twoim pierwszym zadaniem bedzie przyniesienie 500 {Demonic Essence}. Gdy to zrobisz, przyjdz do mnie.", cid)
        elseif player:getStorageValue( storageValGood ) < 2 then
          npcHandler:say("Zakon 4konserw potrzebuje duzej ilosci {Demonic Essence}, aby zasilac nasza wiare w Krula. Przynies mi kolejny 1000 {Demonic Essence}, a zostaniesz nagrodzony.", cid)
          player:setStorageValue( storageValGood, 2 )
        elseif player:getStorageValue( storageValGood ) < 4 then
          npcHandler:say("To bedzie Twoje ostatnie zadanie. Po jego wykonaniu - awansujesz na starszego oficera 4konserw. Aby je wykonac, przynies mi 1500 {Demonic Essence}, a bedzie Ci dana relikwia poswiecona przez autora 3 Aksjomatu.", cid)
          player:setStorageValue( storageValGood, 4)
        end
      end
    end
  elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] >= 10 then
    if npcHandler.topic[cid] == 10 then
      if player:removeItem(6500, 500) then
        npcHandler:say({"Niechaj bedzie! W imieniu 4konserw, mianuje Cie rycerzem 3 aksjo, poplecznikiem Krula. Zakon, szkola, strzelnica!", "Przydzielona Ci zostala ta oto zbroja, korzystaj z niej madrze. Kiedy bedziesz gotowy, zglos sie po kolejne {zadanie}."}, cid)

        player:addOutfit(268, 0)
        player:addOutfit(269, 0)

        player:setStorageValue(storageValGood, 1)
      else
        npcHandler:say("Nie masz wymaganych przedmiotow. Ukoncz misje, i dopiero wtedy przyjdz.", cid)
      end
    elseif npcHandler.topic[cid] == 11 then
      if player:removeItem(6500, 1000 ) then
        npcHandler:say({"Niechaj bedzie! Jako mistrz 4konserw, mianuje Cie oficerem pierwszego stopnia.", "Nadany Ci zostaje helmofon, ktory potrafi wykryc neuropejczyka nawet w ciemnosci. Korzystaj z niego madrze."}, cid)
        player:addOutfitAddon(268, 1)
        player:addOutfitAddon(269, 1)

        player:setStorageValue(storageValGood, 3)
      else
        npcHandler:say("Nie masz wymaganych przedmiotow. Ukoncz misje, i dopiero wtedy przyjdz.", cid)
      end
    elseif npcHandler.topic[cid] == 12 then
      if player:removeItem(6500, 1500 ) then
        npcHandler:say({"Niechaj bedzie! Jako mistrzu zakonu 4konserw, mianuje Cie starszym oficerem. Jest to najwyzsze odznaczenie.", "Nadane Ci zostaja ta oto wlocznia i tarcza, z wygrawerowanym 3 aksjomatem na wnetrzu. Niech sluzy Ci dobrze."}, cid)
        player:addOutfitAddon(268, 2)
        player:addOutfitAddon(269, 2)

        if player:addItem(6391, 1, false) then
          -- ...
          player:setStorageValue(storageValGood, 5)
        else
          npcHandler:say("Chyba nie jestes w stanie jej zmiescic w swoim ekwipunku.", cid)
        end
      else
        npcHandler:say("Nie masz wymaganych przedmiotow. Ukoncz misje, i dopiero wtedy przyjdz.", cid)
      end
    else
      npcHandler:say({"Hym... Nie rozumiem. Przyjdz pozniej (a najlepiej, to zglos to administracji...)"}, cid)
    end
    npcHandler.topic[cid] = 0
  elseif (msgcontains(msg, "nie") or msgcontains(msg, "nie")) and npcHandler.topic[cid] >= 10 then
    npcHandler:say({"To po cholere tu przychodzisz i zawracasz mi glowe?!"}, cid)
    npcHandler.topic[cid] = 0
	else
		npcHandler:say("Badz pozdrowiony, jestem mistrzem {Zakonu 4konserw}. Jak moge Ci pomoc?", cid)
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
