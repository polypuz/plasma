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

local function creatureSayCallback(cid, type, msg)
	local storageValGood = 39651 -- zakon 4konserw
  local storageValBad = 39650 -- zakon Neuropy

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
    npcHandler:say("ODEJDZ, " .. player:getName() .. ", CHYBA, ZE CHCESZ POSLUCHAC O MARKSIE.", cid)
  elseif (msgcontains(msg, "zakon") or msgcontains(msg, "neuropa") or msgcontains(msg, "neuropy")) and player:getStorageValue( storageValGood ) < 0 then
    npcHandler:say({"Zakon Neuropy jest silnym stowarzyszeniem, ktore ma na celu promowanie wspoldzielenia dachow w Mirko Town, wspoldzielenia zlota i pobierania podatku od najmozniejszych u Rysia, szerzenia serwera MirkOTS na OTServlist.", "Kazdy z czlonkow jednak - musi byc krewnym Klejnotu Nilu, miec pochodzenie wlascicieli kamienicy, albo chociaz byc gejem, stylista, afroamerykaninem albo feminista. No i nie mozesz byc fashysta.", "Aby dolaczyc do {Zakonu} musisz udowodnic, ze jestes tego warty. Bynajmniej nie chodzi o szekle. Czy jestes zainteresowany, " .. Player(cid):getName() .. "?"}, cid)
    npcHandler.topic[cid] = 1
  elseif (msgcontains(msg, "yes") or msgcontains(msg, "tak")) and npcHandler.topic[cid] == 1 then
    npcHandler:say({"Musze Cie jednak ostrzec: nasi odwieczni przeciwnicy, {Zakon 4konserw}, nie beda chcieli z Toba rozmawiac, gdy do nas dolaczysz. Jakikolwiek kontakt, jestem prawie pewny, skonczy sie smiertelna konfrontacja.", "Czy nadal jestes pewny swojej decyzji?"}, cid)
    npcHandler.topic[cid] = 2
  elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
    -- no @ 1
    npcHandler:say({"Rozumiem. W takim razie idz w wuj, fashysto."}, cid)
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
        npcHandler:say("Niestety, ale nie mam dla Ciebie wiecej zadan. Jestes neuropkiem najwyzszej rangi.", cid)
      else
        if player:getStorageValue(storageValGood) < 0 then
          npcHandler:say("Twoim pierwszym zadaniem bedzie przyniesienie 500 {Demonic Essence}. Gdy to zrobisz, przyjdz do mnie.", cid)
        elseif player:getStorageValue( storageValGood ) < 2 then
          npcHandler:say("Zakon Neuropy potrzebuje duzej ilosci {Demonic Essence}, zeby miec czym grzac na squotach. Przynies mi kolejne 1000 {Demonic Essence}, a zostaniesz nagrodzony.", cid)
          player:setStorageValue( storageValGood, 2 )
        elseif player:getStorageValue( storageValGood ) < 4 then
          npcHandler:say("To bedzie Twoje ostatnie zadanie. Po jego wykonaniu - awansujesz na starszego szeklomajstra. Aby je wykonac, przynies mi 1500 {Demonic Essence}, a bedzie Ci dana tarcza antyfashysty, potrzebna do zwalczania zlych konserw.", cid)
          player:setStorageValue( storageValGood, 4)
        end
      end
    end
  elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] >= 10 then
    if npcHandler.topic[cid] == 10 then
      if player:removeItem(6500, 500) then
        npcHandler:say({"No spoko, jako mistrz tego squatu oficjalnie mianuje Cie neuropkiem-antyfashysta.", "Masz tutaj troche lachmanow, przydadza Ci sie zebys wygladal jak reszta dobrych chlopakow. Kiedy bedziesz gotowy, zglos sie po kolejne {zadanie}."}, cid)

        player:addOutfit(279, 0)
        player:addOutfit(278, 0)

        player:setStorageValue(storageValGood, 1)
      else
        npcHandler:say("Nie masz wymaganych przedmiotow. Ukoncz misje, i dopiero wtedy przyjdz.", cid)
      end
    elseif npcHandler.topic[cid] == 11 then
      if player:removeItem(6500, 1000 ) then
        npcHandler:say({"Gratulacje. Masz ta koske, prosto z izraela, przyda Ci sie do wyjasniania konserwek i lokalnych patriotow w Mirko Town."}, cid)
        player:addOutfitAddon(278, 1)
        player:addOutfitAddon(279, 1)

        player:setStorageValue(storageValGood, 3)
      else
        npcHandler:say("Nie masz wymaganych przedmiotow. Ukoncz misje, i dopiero wtedy przyjdz.", cid)
      end
    elseif npcHandler.topic[cid] == 12 then
      if player:removeItem(6500, 1500 ) then
        npcHandler:say({"No sponio, masz tutaj doczepiany kaptur - dzieki temu straznicy nie beda w stanie Cie rozpoznac, gdy bedziesz szczal pod depo.", "Dodatkowo, daje Ci swoja tarcze, podpisana przez mojego idola. Przyda Ci sie gdy wlasciciel bedzie chcial odzyskac naszego squata."}, cid)
        player:addOutfitAddon(278, 2)
        player:addOutfitAddon(279, 2)

        if player:addItem(6433, 1, false) then
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
		npcHandler:say("No elo colego, jestem mistrzem {Zakonu Neuropy}. Nie jestes z moderacji, co? Jak moge pomoc?", cid)
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
