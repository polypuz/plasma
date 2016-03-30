--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 31.03.16
-- Time: 00:25
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
  return true
end


local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end
  if npcHandler.topic[cid] == 1 then
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      if Player(cid):removeItem(5905, 20) then
        npcHandler:say("W porzadku, dzieki. Gdy bedziesz gotowy, zawolaj o kolejna {misje}. Tym razem ta bedzie trudniejsza.", cid)
        Player(cid):setStorageValue(38002, 2)
      else
        npcHandler:say("Nie masz 20 {Vampire Dust}. Wroc, gdy je zdobedziesz.", cid)
      end
    elseif msgcontains(msg, "nie") or msgcontains(msg, "no") then
      npcHandler:say("To po cholere zawracasz mi glowe?!", cid)
      npcHandler.topic[cid] = 0
    else
      npcHandler:say("Nie rozumiem.", cid)
      npcHandler.topic[cid] = 0
    end
  elseif npcHandler.topic[cid] == 2 then
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      if Player(cid):removeItem(8752, 1) then
        npcHandler:say("Cholera jasna, udalo Ci sie! Gratulacje, " .. Player(cid):getName() .. ". Wracaj do Henryka, zdaj mu relacje, powiedz, ze przeszedles probe.", cid)
        Player(cid):setStorageValue(38002, 4)
      else
        npcHandler:say("Nie masz jego sygnetu... Sluchaj, kmiocie, to nienajlepszy czas na zarty.", cid)
        npcHandler.topic[cid] = 0
      end
    elseif msgcontains(msg, "nie") or msgcontains(msg, "no") then
      npcHandler:say("To po cholere zawracasz mi glowe?! Ta maszkara to nie zart, kmiocie!", cid)
      npcHandler.topic[cid] = 0
    else
      npcHandler:say("Nie rozumiem.", cid)
      npcHandler.topic[cid] = 0
    end
  elseif Player(cid):getStorageValue(38001) == 5 then
    if msgcontains(msg, "misja") or msgcontains(msg, "mission") or msgcontains(msg, "misje") or msgcontains(msg, "misji") then
      if Player(cid):getStorageValue(38002) ~= -1 then
        if Player(cid):getStorageValue(38002) == 1 then
          npcHandler:say({"Wiec mowisz, ze masz ze soba 20 {Vampire Dust}? Pokazesz?"}, cid)
          npcHandler.topic[cid] = 1
        elseif Player(cid):getStorageValue(38002) == 2 then
          -- boss mission
          npcHandler:say({"Jestes calkiem dobry, widac to od razu. Posluchaj, ostatnio znalazlem siedlisko pewnej nieprzyjemnej istoty... Takiej, ktora zamienia inne istoty w wampiry. Buduje armie.", "Powstrzymaj go. Mowia na niego {The Count}, a znalezc go mozesz w Kolobrzeskich kryptach. Uwazaj..."})
          Player(cid):setStorageValue(38002, 3)
          npcHandler.topic[cid] = 0
        elseif Player(cid):getStorageValue(38002) == 3 then
          npcHandler:say("Wiec mowisz, ze zabiles {The Count}? Masz jego sygnet?", cid)
          npcHandler.topic[cid] = 2
        elseif Player(cid):getStorageValue(38002) == 4 then
          npcHandler:say("Przeszedles moja probe. Zglos sie u Henryka.", cid)
          npcHandler.topic[cid] = 0
        end
      else
        npcHandler:say({"W porzadku, wiec mowisz, ze przyslal Cie Henryk. A czy ten stary piernik powiedzial Ci, po co Cie tu przyslal...? Otoz tak, jestem lowca wampirow.", "Ostatnio jest ich coraz wiecej, wiem rowniez, ze Henryk nakazal Natankowi nawolywanie w parafii Mirko do walki z tymi potworami. Co moge powiedziec - przyda sie kazda pomoc. Na start przynies mi 20 {Vampire Dust}, wtedy pomyslimy."}, cid)
        Player(cid):setStorageValue(38002, 1)
      end
    else
      npcHandler:say("Nie zajmuj mi glowy, mlokosie, chyba, ze chcesz pomoc w {misji}.", cid)
    end
  else
    npcHandler:say("Nie rozumiem i nie chce rozumiec, o co mnie pytasz. Spadaj, jestem zajety.", cid)
    npcHandler.topic[cid] = 0
  end
  return true
end

