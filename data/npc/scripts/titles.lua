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


local function creatureSayCallback(cid, type, msg)
  npcHandler:say("penis", cid)

  return true
end
