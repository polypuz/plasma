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

local function hasTalkedWithAllNpcs(cid)
  --[[
    38002 - first NPC, Tadeusz
    38003 - Krzysztof
    38004 - Grzegorz
    38005 - Miroslaw
    38006 - Waldemar
  ]]
	local npcStorageKeys = {38002, 38003, 38004, 38005, 38006}
	for k,v in ipairs( npcStorageKeys ) do
		if Player(cid):getStorageValue(v) ~= 1 then
			return false
		end
	end

  return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

  if msgcontains(msg, "inquisitor") or msgcontains(msg, "inq") or msgcontains(msg, "inkwizycja") or msgcontains(msg, "inkwizycji") then
    npcHandler:say("Instytucja kosciola swietego Krula powierzyla mi zadanie poprowadzenia zadania: trudnego, ale i o szczytnym celu. Tym zadaniem jest {inkwizycja}. Zbieram wspolwierzacych, ludzi lojalnych krulowi, ktorzy chca {dolaczyc} do {inkwizycji} i wspolnie walczyc o dobro krolestwa Mirko.", cid)
    npcHandler.topic[cid] = 1
  elseif npcHandler.topic[cid] == 1 and ( msgcontains(msg, "dolacz") or msgcontains(msg, "join") ) then
    npcHandler:say("A wiec chcesz dolaczyc do {inkwizycji}?", cid)
  elseif npcHandler.topic[cid] == 1 and ( msgcontains(msg, "tak") or msgcontains(msg, "yes") ) then
    npcHandler:say("Niechaj tak bedzie. Jestes czlonkiem {Inkwizycji}. Jesli chcesz sie wykazac, moge od razu nadac Ci {misje}.", cid)
  elseif msgcontains(msg, "misja") or msgcontains(msg, "mission") or msgcontains(msg, "misje") then
    if Player(cid):getStorageValue(38001) ~= -1 then
			if Player(cid):getStorageValue(38001) == 1 then
				npcHandler:say("Otrzymales juz wytyczne. Czy zebrales informacje od lokalnych wladz?", cid)
				npcHandler.topic[cid] = 2
			else
				npcHandler:say("Zglos sie niedlugo, teraz nie ma dostepnej nowej misji.", cid)
				npcHandler.topic[cid] = 0
			end
    else
      npcHandler:say("Wykaz sie. Przejdz sie po miastach krainy Mirko, porozmawiaj z lokalnymi wladzami, zapytaj jakie maja {problemy}. Musimy wiedziec na czym stoimy, zanim rozpoczniemy nasze dzialania.", cid)
      Player(cid):setStorageValue(38001, 1)
    end
	elseif npcHandler.topic[cid] == 2 and ( msgcontains(msg, "yes") or msgcontains(msg, "tak") ) then
		if hasTalkedWithAllNpcs(cid) then
			npcHandler:say({"Hm... tak, to potwierdza dane od innych informatorow. Oczywiscie spodziewalem sie, ze tak bedzie. To byl tylko test...", "Coz, skoro juz pokazales ze co nieco potrafisz, moge nadac Ci kolejna {misje}. Zobaczymy, czy bedac w polu poradzisz sobie tak samo dobrze."}, cid)
			Player(cid):setStorageValue(38001, 2)
		else
			npcHandler:say("Nie udalo Ci sie zebrac jeszcze wszystkich informacji. Pamietaj, musisz porozmawiac z Waldemarem, Tomaszem, Miroslawem, Grzegorzem i Krzysztofem. Sa przedstawicielami lokalnych wladz w roznych miastach krainy Mirko. Gdy to zrobisz, wroc do mnie i zdaj mi sprawozdanie.", cid)
		end
	elseif npcHandler.topic[cid] == 2 then
		npcHandler:say("Nie zebrales wszystkich informacji?! Nie zawracaj mi glowy, pacanie!", cid)
  else
    npcHandler:say("Nie wiem o czym mowisz.", cid)
  end

	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
