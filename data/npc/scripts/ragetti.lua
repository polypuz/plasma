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
  else
    npcHandler:setMessage(MESSAGE_GREET, "Przyniosles to, o co prosilem?", cid)
  end
  return true
end

local function removePirateItems(cid)
  --                pirate shirt x1       hook x3                 peg leg x3            eye patch x3
  pirateItems = {{id = 6095, amount=1}, {id=6097, amount=3}, {id=6126, amount=3}, {id=6098, amount=3} }

  local p = Player(cid)
  local hasItems = true
  for k, v in ipairs(pirateItems) do
    if not p:hasItem(v.id, v.amount) then
      hasItems = false
    end
  end

  if hasItems then
    for k, v in ipairs(pirateItems) do
      p:removeItem(v.id, v.amount)
    end
  end

  return hasItems
end



local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end
  print("dbg: topic[cid] = " .. tostring(npcHandler.topic[cid]))
  if msgcontains(msg, "Pintel") or msgcontains(msg, "brat") then
    npcHandler:say("Moj braciszek sie o mnie martwi?", cid)
    npcHandler.topic[cid] = 1
  elseif msgcontains(msg, "nikt") then
    npcHandler:say({"Hm... dobra, mniejsza. Sluchaj, jest sprawa - chcesz mi pomoc? Te mendy mnie tu zamknely... Nie wiem jakie maja plany.", "Potrzebny nam {klucz}. Widzisz, klodeczka.."}, cid)
  elseif (msgcontains(msg, "tak") or msgcontains(msg, "yes")) and npcHandler.topic[cid] == 1 then
    npcHandler:say("Dobrze, ze Cie przyslal. Musisz mnie uwolnic. Potrzebny nam {klucz}, widzisz, klodeczka...", cid)
  elseif (msgcontains(msg, "nie") or msgcontains(msg, "no")) and npcHandler.topic[cid] == 1 then
    npcHandler:say({"Przestan sie ze mna droczyc... na pewno sie martwi...", "A Ty bezbekowy smieszku lepiej #usunkonto. Uwolnij mnie. Do tego potrzebujesz {klucza}, widzisz ta klodke..?"}, cid)
  elseif msgcontains(msg, "klucz") then
    npcHandler:say("Widzialem, jak ktorys z korsarzy chowa go w swoich rzeczach. Przeszukaj ich, w sposob dla Ciebie dogodniejszy, i przynies mi ich rzeczy - powinien sie gdzies znalezc.", cid)
    Player(cid):setStorageValue(38100, 2)
  else
    if ( msgcontains(msg, "tak") or msgcontains(msg, "yes") ) and Player(cid):getStorageValue(38100) > 1 then
      if removePirateItems(cid) then
        npcHandler:say({"Swietnie! Sluchaj teraz uwaznie: musisz isc do mojego brata i powiedziec mu, zeby tu przyszedl. Nie moge tak po prostu odejsc, bo piraci sie zorientuja i zaatakuja port.", "Powiedz mu, zeby przyszedl z odsiecza. Pospiesz sie, ja tu poczekam."}, cid)
        Player(cid):setStorageValue(38100, 3)
      else
        npcHandler:say("Nigdzie nie ma klucza! Szukaj dalej, pospiesz sie!", cid)
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
