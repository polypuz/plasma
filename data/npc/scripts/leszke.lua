local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	if getPlayerLevel(cid) < 30 then
		npcHandler:say("Nawet pan nie pomysl, kiedykolwiek, ze moglbys podjac sie rozmowy z Walesa. Pomyslenie jest zbrodnia przeciw mnie!", cid)
		npcHandler:releaseFocus(cid)
		return false
	end

	return true
end

local config = {
  storageKey = 36960
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

  if msgcontains(msg, "kiszczakowa") then
    if getPlayerStorageValue(cid, config.storageKey) ~= 1 then
      npcHandler:say("ta, cos sie u niej dzieje... nawet Natanek byl na wizycie. Nic nie pomoglo. Odbija jej szajba. Sluchaj pan, potrzebuje pomocy. Odzyskaj {dokumenty}, a jakos Ci to wynagrodze, w koncu jestem prezydentem mirko... bylym, ale jestem, panie. Tymi rencyma zbudowalem.", cid)
    else
      npcHandler:say("Kiszczakowa mieszka w willi po malzonku, swietej pamieci, gdzies na Bananowie. Dosc bogata posiadlosc, na pewno jej nie ominiesz.", cid)
    end
  elseif msgcontains(msg, "dokumenty") then
    npcHandler:say("Owe dokumenty zawieraja prefabrykowane dowody mojej rzekomej wspolpracy z administracja. To jest oczywiscie falsz i klamstwo, ja nigdy nie dalem sie zlamac. Ja nie chcem, ale muszem dzialac w tej sprawie! Czy zechcesz mi pomoc? Nie zdradzisz mnie?", cid)
    npcHandler.topic[cid] = 1
  elseif (msgcontains(msg, "yes") or msgcontains(msg, "tak")) and npcHandler.topic[cid] == 1 then
    npcHandler:say("To wspaniale! Widac, ze prawdziwy mirkotibijczyk. Odnajdz {Kiszczakowa} i postaraj sie odzyskac te tecz.. dokumenty. Dam Ci co zechcesz, tylko zrob to!", cid)
    setPlayerStorageValue(cid, config.storageKey, 1) -- setting the quest to started
  elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
    npcHandler:say("To spaadaj pan! Ja ani sekunde nie bylem po drugiej stronie, ja walczylem na smierc na zycie, z administracjo.", cid)
    npcHandler:releaseFocus( cid )
  else
    npcHandler:say("...nocna zmiana to falsz, urojenia Kurskiego i popaprancow. A teraz co? {Kiszczakowa} na glowe upada, dokumenty chce ujawniac!!.. Prefabrykowane, oczywiscie...", cid)
  end

	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
