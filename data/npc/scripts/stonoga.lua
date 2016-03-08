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
  
  if msgcontains(msg, "miasto") then
    selfSay('Kiedys nasze miasto bylo wspaniale , kwitly kwiaty i wszedzie bylo zielono, teraz jest ponuro i niebezpiecznie.', cid)
    end
  
  if msgcontains(msg, "wrak") then
    selfSay('Jest tutaj wiele wrakow , pozostawionych po wielkiej {odwilzy}, wiele lat temu moj {dziadek} wyruszyl z ekspedycja do jednego z wrakow, lecz nigdy nie wrocil.', cid)
    npcHandler.topic[cid] = 1
    end

  if msgcontains(msg, "odwilz") and npcHandler.topic[cid] == 1 then
    selfSay(' Jak bylem maly nadeszlo globalne ocieplenie ,topiac lodowce i zalewajac nasza kraine woda, wiele skarbow dotychczas jest pochowanych gdzies w glebinach.', cid)
    npcHandler.topic[cid] = 1
    end
   
  if msgcontains(msg, "dziadek") and npcHandler.topic[cid] == 1 then   
    player:setStorageValue(23021, 1)
    selfSay('Byl on zasluzonym zeglarzem, zawsze na piersi nosil swoj medal, ktory dostal od krola Bialka po bitwie o serwerownie, zapewne dalej lezy tam w glebinach. Jesli uda ci sie go odzyskac, bede bardzo wdzieczny, sam nie jestem wstanie tam dotrzec.', cid)
  npcHandler.topic[cid] = 1
  end     
   
  if msgcontains(msg, "medal") and player:getStorageValue(23021) == 1 and player:getItemCount(ItemType(10140):getId()) < 1 then
    selfSay('Musisz szukac we wraku na zachod od miasta.', cid)
      npcHandler.topic[cid] = 0
    end
     
    if msgcontains(msg, "medal") and player:getStorageValue(23021) == 1 and player:getItemCount(ItemType(10140):getId()) > 0 then -- 10140 - Royal Medal (ze skrzynki)
    player:removeItem(ItemType(10140):getId(), 1)
    selfSay('Dziekuje ci bardzo za odzyskanie tego bezcennego medalu, ja i inni mieszkancy bardzo jestesmy wdzieczni za pomoc.', cid)
  npcHandler.topic[cid] = 0
    end
  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new()) 
