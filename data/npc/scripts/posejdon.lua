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
  
  if msgcontains(msg, "postrach") and player:getStorageValue(23080) < 1 then
    selfSay('Tak, od czasu zatopienia miasta, przyplynal razem z fala postrach glebin, nawiedzajac nasze miasto i zadajac zlota, dałbym wszystko aby sie go {pozbyc}.', cid)
    npcHandler.topic[cid] = 1
    end
  
  if msgcontains(msg, "pozbyc") and npcHandler.topic[cid] == 1 and player:getStorageValue(23080) ~= 1 then
    selfSay('W najglebszej czesci oceanu znajduje sie jego zamek, nikt zywy jeszcze z niego nie wrocil. Wroc z jego glowa , a obdaruje cie skarbami.', cid)
    player:setStorageValue(23080,1)
    player:setStorageValue(23083,1)    
    npcHandler.topic[cid] = 1
    end
    -- 15621 - trophy of jaul 
  if msgcontains(msg, "postrach") and player:getStorageValue(23080) == 1 and player:getItemCount(ItemType(15621):getId()) < 1 then
    selfSay('Zabij go , a zostaniesz obdarowany.', cid)
    npcHandler.topic[cid] = 0
    end
    
  if msgcontains(msg, "postrach") and player:getStorageValue(23080) == 1 and player:getItemCount(ItemType(15621):getId()) > 0 then
    selfSay('Udalo ci sie, nawet nie wiem jak ci dziekowac. Zaraz powiem swojemu sekretarzowi ,zeby ci dal dostep do skarbca, gdzie wezmiesz tyle ile bedziesz mogl uniesc.', cid)
    player:removeItem(ItemType(15621):getId(), 1)
    player:setStorageValue(23081,1)
    npcHandler.topic[cid] = 0
    end

  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new()) 
