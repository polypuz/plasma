local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function getTitles(cid)
  local res = db.storeQuery("SELECT `title_id` FROM `player_titles` WHERE `account_id`=" .. Player(cid):getAccountId())
  local titleIdArr = {}
  local titleId = nil
  if res ~= -1 then
    repeat
      titleId = result.getDataInt(res, "title_id")
      table.insert(titleIdArr, {id = titleId, title=getTitle(titleId)} )
      print("Got title: " .. getTitle(titleId))
    until not result.next(res)
    result.free(res)
  end
  if titleIdArr == {} then
    titleIdArr = nil
  end
  return titleIdArr
end

local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end

  if msgcontains(msg, "tytuly") or msgcontains(msg, "titles") then
    local titleString = "Aktualnie masz dostepne nastepujace tytuly:"
    local titles = getTitles(cid)

    for k, v in ipairs(titles) do
      titleString = titleString .. " {" .. v.title .. "}"
    end

    titleString = titleString .. "."
    npcHandler:say(titleString, cid)

    npcHandler.topic[cid] = 1
  elseif msgcontains(msg, "tytul") or msgcontains(msg, "title") then
    npcHandler:say({"Tytuly nadawane sa za otrzymanie osiagniecia, ukonczenie wyjatkowo trudnego zadania lub za uczestniczenie w wydarzeniach serwera.", "Jesli chcesz zobaczyc swoje tytuly i zmienic tytul dla swojej postaci, napisz {tytuly}."}, cid)
  else
    npcHandler:say("Nie rozumiem. Moge wytlumaczyc Ci jak zdobyc {tytul}, albo powiedziec jakie {tytuly} juz zdobyles.", cid)
    npcHandler.topic[cid] = 0
  end

  return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())