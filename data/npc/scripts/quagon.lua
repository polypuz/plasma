local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)     npcHandler:onCreatureAppear(cid)     end
function onCreatureDisappear(cid)     npcHandler:onCreatureDisappear(cid)     end
function onCreatureSay(cid, type, msg)     npcHandler:onCreatureSay(cid, type, msg)     end
function onThink()     npcHandler:onThink()     end
function  creatureSayCallback(cid, type, msg)
   if(not npcHandler:isFocused(cid)) then
    return false
end

  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

local player = Player(cid)  
  if msgcontains(msg, "miasto")  then
    selfSay('Niegdys bylo to wspaniale miasto, lecz przyszly fale i zalaly miasto niszczac wszystko.', cid)
    end
  
  if msgcontains(msg, "brama")  then
    selfSay('Za brama znajduje się dalsza czesc miasta ,ktora jako jedyna obronila się przed najazdem potworow, tylko {zasluzeni} moga tam wejsc.', cid)
    npcHandler.topic[cid] = 1
    end
   
  if msgcontains(msg, "przysluga") and npcHandler.topic[cid] == 1 then   
    selfSay('Wyszedlem z miasta na to niebezpieczenstwo aby pozbierac troche {perel} z malz, jesli pomozesz mi je zebrac to przeprowadze cie przez brame.', cid)
    talkState[talkUser] = 2
  end     
  if msgcontains(msg, "perly") and player:getStorageValue(23017) ~= 1 and player:getStorageValue(23017) ~= 2 then
     selfSay('Pomoz mi pozbierac perly, szukaj tylko tych zamknietych malz.', cid)
     player:setStorageValue(23017, 1)     
     npcHandler.topic[cid] = 0
  end 
  if msgcontains(msg, "perly") and player:getStorageValue(23017) == 1 and player:getStorageValue(23017) ~= 2 then
     selfSay('Musisz znalezc cos ostrego zeby otworzyc malze', cid)
     npcHandler.topic[cid] = 0
  end
     
    if msgcontains(msg, "perly") and player:getStorageValue(23017) ~= 1 and player:getStorageValue(23017) == 2 then
    selfSay('Dziekuje za pomoc w zbieraniu perel, mozesz powiedziec na bramie ze ja cie przyjalem.', cid)
    npcHandler.topic[cid] = 0
    end
  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new()) 
