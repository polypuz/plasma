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
	if not npcHandler:isFocused(cid) then
		return false
	end

  if msgcontains(msg, "inquisitor") or msgcontains(msg, "inq") or msgcontains(msg, "inkwizycja") then
    npcHandler:say("Instytucja kosciola swietego Krula powierzyla mi zadanie poprowadzenia zadania: trudnego, ale i o szczytnym celu. Tym zadaniem jest {inkwizycja}. Zbieram wspolwierzacych, ludzi lojalnych krulowi, ktorzy chca {dolaczyc} do {inkwizycji} i wspolnie walczyc o dobro krolestwa Mirko.", cid)
    npcHandler.topic[cid] = 1
  elseif npcHandler.topic[cid] == 1 and ( msgcontains(msg, "dolacz") or msgcontains(msg, "join") ) then
    npcHandler:say("A wiec chcesz dolaczyc do {inkwizycji}?", cid)
  elseif npcHandler.topic[cid] == 1 and ( msgcontains(msg, "tak") or msgcontains(msg, "yes") ) then
    npcHandler:say("Niechaj tak bedzie. Jestes czlonkiem {Inkwizycji}. Jesli chcesz sie wykazac, moge od razu nadac Ci {misje}.", cid)
  elseif msgcontains(msg, "misja") or msgcontains(msg, "mission") or msgcontains(msg, "misje") then
    if Player(cid):getStorageValue(38001) ~= -1 then
      npcHandler:say("Otrzymales juz wytyczne.", cid)
    else
      npcHandler:say("Wykaz sie. Przejdz sie po miastach krainy Mirko, porozmawiaj z lokalnymi wladzami. Musimy wiedziec na czym stoimy, zanim rozpoczniemy nasze dzialania.", cid)
      Player(cid):setStorageValue(38001, 1)
    end
    npcHandler.topic[cid] = 0
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
