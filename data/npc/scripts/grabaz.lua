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
  
  if msgcontains(msg, "cmentarz") then
    selfSay('NIEEE! Nie idz tam, one sa wszedzie, {duchy} poleglych strasza!!', cid)
    end
  
  if msgcontains(msg, "duchy") and player:getStorageValue(23030) ~= 1 then
    selfSay('Tak, wszyscy ktorzy zgineli, nie moga sie z tym pogodzic, dlatego cmentarz stoi zaniedbany od dawien dawna. Chcialbym znalezc jakis sposob aby {przegonic} je ze swiata zywych.', cid)
    npcHandler.topic[cid] = 1
    end

  if msgcontains(msg, "duchy") and player:getStorageValue(23030) == 1 and player:getStorageValue(23030) ~= 2 then
    selfSay('Dalej je slysze, prosze zrob cos z tym !', cid)
    npcHandler.topic[cid] = 0
    end
    
  if msgcontains(msg, "duchy") and player:getStorageValue(23030) ~= 1 and player:getStorageValue(23030) == 2 then
    selfSay('ODESZLY!!! Nawet nie wiem jak ci dziekowac, biegne powiedziec wladcy o tym!', cid)
    npcHandler.topic[cid] = 0
    end   

  if msgcontains(msg, "przegonic") and npcHandler.topic[cid] == 1 then
    selfSay('Jesli uda ci sie jakos tego dokonac, wszyscy mieszkancy beda mogli w koncu spac spokojnie.', cid)
    player:setStorageValue(23030, 1)
    npcHandler.topic[cid] = 1
    end
   
  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new()) 
