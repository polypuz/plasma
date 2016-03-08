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
  
  if msgcontains(msg, "wladca") then
    selfSay('Nie kazdy jest {godzien} o audiencje u samego wladcy podwodnego miasta.', cid)
    npcHandler.topic[cid] = 1
    end
  
  if msgcontains(msg, "godzien") and npcHandler.topic[cid] == 1 then
    selfSay('Nie jestem w stanie cie wpuscic do niego, ale wiem, ze od wielu lat szuka osoby ktora odzyska jego {skarb}, ktory lezy we wraku na dnie oceanu, moze wtedy zgodzi sie cie przyjac.', cid)
    player:setStorageValue(23060,1)
    npcHandler.topic[cid] = 1
    end

  if msgcontains(msg, "godzien") and player:getStorageValue(23060) ~= 1 and player:getStorageValue(23060) == 2 then
    selfSay('Wladca czeka na ciebie.', cid)
    player:setStorageValue(23063,1)
    npcHandler.topic[cid] = 1
    end
    
  if msgcontains(msg, "skarb" and npcHandler.topic[cid] == 1 and player:getStorageValue(23060) == 1  then
    selfSay(player:getStorageValue(23060),cid)
    selfSay('Skarb lezy gdzies gleboko na dnie oceanu ', cid)
    npcHandler.topic[cid] = 1
    end   
    
   if msgcontains(msg, "skarb" and player:getStorageValue(23060) ~= 1 and player:getStorageValue(23060) == 2 then
    selfSay('Naprawde tego dokonales, sadze ,ze teraz zgodzi sie cie przyjac do siebie.', cid)
    player:setStorageValue(23063,1)
    npcHandler.topic[cid] = 1
    end     
  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new()) 
