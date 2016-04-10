--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 05.04.16
-- Time: 00:33
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
  if Player(cid):getStorageValue(38100) <= 1 then
    npcHandler:setMessage(MESSAGE_GREET, "Kim jestes?! Kto cie przyslal?!", cid)
  elseif Player(cid):getStorageValue(38100) == 2 then
    npcHandler:setMessage(MESSAGE_GREET, "Przyniosles to, o co prosilem?", cid)
  else
    npcHandler:setMessage(MESSAGE_GREET, "Dzieki, brachu! Czekam teraz na ekipe i spadam stad...", cid)
  end
  return true
end

local function checkIfShirtHasKey(cid)
  local p = Player(cid)
  if p:removeItem(6095, 1) then -- removing pirate shirt
    local rand = math.random(0, 1)
    if rand <= 0.65 then
      return true
    else
      return false
    end
  end
end


local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end
  if msgcontains(msg, "Pintel") or msgcontains(msg, "brat") then
    npcHandler:say("Moj braciszek sie o mnie martwi?", cid)
    npcHandler.topic[cid] = 1
  elseif msgcontains(msg, "nikt") then
    npcHandler:say({"Hm... dobra, mniejsza. Sluchaj, jest sprawa - chcesz mi pomoc? Te mendy mnie tu zamknely... Nie wiem jakie maja plany.", "Potrzebny nam {klucz}. Widzisz, klodeczka.."}, cid)
    npcHandler.topic[cid] = 1
  elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 1 then
    npcHandler:say("Dobrze, ze Cie przyslal. Musisz mnie uwolnic. Potrzebny nam {klucz}, widzisz, klodeczka...", cid)
  elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
    npcHandler:say({"Przestan sie ze mna droczyc... na pewno sie martwi...", "A Ty bezbekowy smieszku lepiej #usunkonto. Uwolnij mnie. Do tego potrzebujesz {klucza}, widzisz ta klodke..?"}, cid)
  elseif msgcontains(msg, "klucz") then
    npcHandler:say("Widzialem, jak ktorys z korsarzy chowa go w kieszeni swojej koszuli. Przynies kilka szmat, przeszukam je.", cid)
    if Player(cid):getStorageValue(38100) < 2 then
      Player(cid):setStorageValue(38100, 2)
    end
  else
    if ( msgcontains(msg, "tak") or msgcontains(msg, "yes") ) and Player(cid):getStorageValue(38100) > 1 then
      if getPlayerItemCount(cid, 6095) >= 1 then
        if checkIfShirtHasKey(cid) then
          npcHandler:say({"Swietnie! Sluchaj teraz uwaznie: musisz isc do mojego brata i powiedziec mu, zeby tu przyszedl. Nie moge tak po prostu odejsc, bo piraci sie zorientuja i zaatakuja port.", "Powiedz mu, zeby przyszedl z odsiecza. Pospiesz sie, ja tu poczekam."}, cid)
          if Player(cid):getStorageValue(38100) == 2 then
            Player(cid):setStorageValue(38100, 3)
          end
        else
          npcHandler:say("No niestety, brak szczescia. Sprobuj dorwac inna.", cid)
        end
      else
        npcHandler:say("Nie wziales ze soba koszuli! Rusz dupsko!", cid)
      end
    elseif msgcontains(msg, "nie") or msgcontains(msg, "no") then
      npcHandler:say("No to zapindalaj dalej! Chcesz, zebym tu zgnil?!", cid)
    else
      npcHandler:say("Przestan gadac glupoty i wyciagnij mnie stad, do jasnej cholery!", cid)
    end
    npcHandler.topic[cid] = 0
  end

  return true

end


npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
