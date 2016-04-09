--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 06.04.16
-- Time: 22:35
-- To change this template use File | Settings | File Templates.
--

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
  if Player(cid):getStorageValue(38100) ~= -1 then
    npcHandler:setMessage(MESSAGE_GREET, "Czy odnalazles juz mojego {brata}?", cid)
  elseif Player(cid):getStorageValue(38100) == 2 then
    npcHandler:setMessage(MESSAGE_GREET, "Uwolniles Ragettiego?", cid)
  elseif Player(cid):getStorageValue(38100) == 4 then
    npcHandler:say("Twoje zaslugi nie zostana zapomniane.", cid)
    return false
  else
    npcHandler:setMessage(MESSAGE_GREET, "Biada, zgroza, co za {nieszczescie}!", cid)
  end
  return true
end

local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end

  local questStep = Player(cid):getStorageValue(38100)

  if msgcontains(msg, "nieszczescie") then
    npcHandler:say("Panie! Przyrodniego {brata} mi porwali, {szuje} jedne. {Ojciec} nigdy by do tego nie dopuscil!", cid)
  elseif msgcontains(msg, "brat") or msgcontains(msg, "brata") then
    npcHandler:say("Bekart jeden, {ojciec} zawsze byl rozwiazly, teraz ja sie nim opiekuje... przynajmniej do niedawna. Teraz porwali go {piraci}, musisz mi {pomoc}!", cid)
  elseif msgcontains(msg, "piraci") or msgcontains(msg, "szuje") or msgcontains(msg, "piratow") then
    npcHandler:say("Biada, biada. Nie dosc, ze {ojca} ubili, to jeszcze {brata} porwali! {Pomoz} mi, prosze!", cid)
  elseif msgcontains(msg, "ojciec") or msgcontains(msg, "ojca") then
    npcHandler:say("Nasz ojciec nie zyje od dawna. Zabili go {piraci}, teraz ja przejalem jego biznes i jeszcze musze sie bratem opiekowac. A jego {matka}.. coz, tez sie gdzies ulotnila.", cid)
  elseif msgcontains(msg, "matka") then
    npcHandler:say("Jestem pewny, ze maczala palce w morderstwie {ojca}.", cid)
  elseif msgcontains(msg, "pomoc") or msgcontains(msg, "pomoz") then
    npcHandler:say("Szybko! Nie ma czasu do stracenia. Nie wiadomo, do czego sa zdolni. Odszukaj mojego {brata}, odbij go z rak {piratow}, a na pewno sie {odwdziecze}.", cid)
    Player(cid):setStorageValue(38100, 1)
  elseif msgcontains(msg, "yes") or msgcontains(msg, "tak") then
    if questStep == 2 then
      npcHandler:say("Ech? No to idz mu pomoz! Zaraz Was dogonie, uwolnij go, a przybede z chlopakami.", cid)
    elseif questStep == 3 then
      npcHandler:say({"Swietnie, dziekuje Ci bardzo. Jestes odwazniejszy niz wygladasz.", "Mialem takiego przyjaciela, zeglarz. Ciezko myslal, ale zabawny byl. Nieraz, jak sie popilismy rumu, pojawialy sie burdy. Mial wtedy w zwyczaju mowic: \"ZROBIMY IM DOMINANDO JAK NA GUNZO...\"costam. No, wiec zaraz tak bedzie.", "Teraz czas, abym Ci sie {odwdzieczyl}."}, cid)
      Player(cid):setStorageValue(38100, 4) -- quest finished
      npcHandler.topic[cid] = 2
    end
  elseif msgcontains(msg, "no") or msgcontains(msg, "nie") then
    npcHandler:say("To na co jeszcze czekasz?!", cid)
  elseif npcHandler.topic[cid] == 2 and (msgcontains(msg, "nagroda") or msgcontains(msg, "odwdzieczyl")) then
    npcHandler:say("Jako wlasciciel jednej z glownych flot handlowych, mam tutaj kilku przyjaciol. Wsrod nich jest pewien straznik, strzegacy bramy do Dzielnicy Zywiolakow. Szepne o Tobie kilka dobrych slow - podobno poszukiwacze przygod moga dobrze sie oblowic z odnalezionych tam artefaktow.", cid)
  elseif msgcontains(msg, "odwdziecze") then
    npcHandler:say("Najpierw znajdz mojego brata, wtedy porozmawiamy!", cid)
  else
    npcHandler:say("Hm? Sluchales w ogole, co do Ciebie mowilem?", cid)
  end
  return true

end


npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
