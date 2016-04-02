--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 02.04.16
-- Time: 18:50
-- To change this template use File | Settings | File Templates.
--

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function getTitles( cid )
  local resultQuery = db.storeQuery("SELECT `title_id` FROM `player_titles` WHERE `account_id`=" .. Player(cid):getAccountId() )
  print( tostring( resultQuery ))

  return -1
end

local function setTitle(cid, title_id)
end

local function creatureSayCallback(cid, type, msg)
  if msgcontains(msg, "tytul") or msgcontains(msg, "title") then
    npcHandler:say({"Zarzadzam tytulami. Tytuly zdobywasz za rozne osiagniecia; zabijanie graczy, konkretnych potworow, ukonczenie jakiegos wyjatkowo trudnego zadania, czy za uczestniczenie w beta testach.", "Aby zobaczyc, jakie masz aktualnie tytuly, napisz {tytuly}."}, cid)
  elseif msgcontains(msg, "tytuly") or msgcontains(msg, "titles") then
    getTitles(cid)
  else
    npcHandler:say({"Nie rozumiem."}, cid)
  end

  return true
end
