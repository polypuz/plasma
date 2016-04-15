--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 15.04.16
-- Time: 23:24
-- To change this template use File | Settings | File Templates.
--


local function greetCallback(cid)
  -- npcHandler:setMessage(MESSAGE_GREET, msg, cid)
  local p = Player(cid)

  if p:getStorageValue(38150) == -1 then
    npcHandler:setMessage(MESSAGE_GREET, "Witaj, " .. p:getName() .. ". Obecnie jestem zajety. Prowadze wazne {badania}.", cid)
  elseif p:getStorageValue(38150) == 1 then
    npcHandler:setMessage(MESSAGE_GREET, "Witaj, " .. p:getName() .. ". Czy przyniosles mi skladniki, o ktore prosilem?", cid)
  else
    npcHandler:setMessage(MESSAGE_GREET, "...Hm? Co..?", cid)
  end
  return true
end


local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end
  local player = Player(cid)
  local questStep = p:getStorageValue(38150)
  if questStep == -1 then
    if msgcontains(msg, "badania") then
      npcHandler:say("W starozytnych ksiegach wyczytalem o Mirkach ktorzy poslugiwali sie mocami zywiolow za pomoca many. Prowadze eksperymenty na ludziach by moc naladowac ich energia zywiolow potrzebna do uzywania takowych zaklec... Sluchasz Ty mnie w ogole?", cid)
      npcHandler.topic[cid] = 1
    elseif npcHandler.topic[cid] == 1 then
      if msgcontains(msg, "no") or msgcontains(msg, "nie") then
        npcHandler:say("To wroc, gdy zdecydujesz sie na cos przydac.", cid)
        npcHandler:releaseFocus(cid)
        return false
      elseif msgcontains(msg, "yes") or msgcontains(msg, "tak") then
        npcHandler:say({ "Wyobraz sobie, ze walczysz z potworami miotajac kule ognia tak, jak robia to zywiolaki. Obecnie jest to mozliwe, ale tylko przy pomocy run! Moje nowatorskie badania maja szanse to zmienic...", "Stworze rase magow mogacych inwokowac czary runiczne natychmiastowo! To beda... nadludzie. Ech, gdyby tylko to bylo takie {proste}..." }, cid)
      else
        npcHandler:say("Nie rozumiem. Wez sie zdecyduj.", cid)
      end
    elseif msgcontains(msg, "proste") then
      npcHandler:say("Sam jestes prosty! Bez pomocy nic nie jest proste. Mial mi tu {pomoc} moj {uczen}, ale ten woli mieszac ziola i pisac wierszyki, zamiast zglebiac sie w powazne nauki.", cid)
    elseif msgcontains(msg, "uczen") then
      npcHandler:say("Ten bezuzyteczny chlopak zostal przydzielony z ministerstwa... Jak zwykle rzad mysli, ze wie lepiej od naukowcow. Pewnie powolali jakies komisje ekspertow z arcymagiem Antonim na czele, i teraz sa takie {efekty}!", cid)
    elseif msgcontains(msg, "efekty") or msgcontains(msg, "skutki") then
      npcHandler:say({ "Moj uczen, Piotrek Luszczowy, to jakis blokersowy margines.", "Jak tylko dorwal sie do mojego sprzetu, to nawial do dzielnicy magicznej i udaje alchemika, a tak naprawde miesza jakies ziola odurzajace razem z jego kolesiami - Kakofonika? Jakos tak sie nazywaja.", "No... dosc juz tych pierdol. Moze Ty moglbys mi {pomoc}?" }, cid)
    elseif msgcontains(msg, "pomoc") then
      npcHandler:say({ "Pomocnik! Swietnie! Do prowadzenia swoich badan potrzebuje kilka probek zywiolakow, by dowiedziec sie czym sa nasycone i jak tak proste w porownaniu do nas stwory opanowaly tak zaawansowana magie.", "Czy podejmiesz sie tego zadania?" }, cid)
      npcHandler.topic[cid] = 2
    elseif npcHandler.topic[cid] == 2 then
      if msgcontains(msg, "yes") or msgcontains(msg, "tak") then
        npcHandler:say({ "Wspaniale. Bierz sie do roboty, dostarcz mi nastepujace skladniki. Wszystko jest na notatce.", "No, juz, idz!" }, cid)
        npcHandler:releaseFocus(cid)
        player:setStorageValue(38150, 1)
      elseif msgcontains(msg, "no") or msgcontains(msg, "nie") then
        npcHandler:say("To wroc, gdy zdecydujesz sie na cos przydac.", cid)
        npcHandler:releaseFocus(cid)
        return false
      else
        npcHandler:say("Nie rozumiem. Wez sie zdecyduj.", cid)
      end
    else
      npcHandler:say("Nie rozumiem.", cid)
    end
  elseif questStep == 1 then
    -- some further quest progression
    if msgcontains(msg, "tak") or msgcontains(msg, "yes") then
      --quest finishes
    elseif msgcontains(msg, "nie") or msgcontains(msg, "no") then
      npcHandler:say("No to co tu jeszcze robisz? Migusiem!", cid)
      npcHandler:releaseFocus(cid)
      return false
    else
      npcHandler:say("Co...? Nie rozumiem, zdecyduj sie.", cid)
    end
  else
    npcHandler:say("Nie zawracaj mi teraz glowy, jestem zajety.", cid)
    npcHandler:releaseFocus(cid)
    return false
  end
  return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())