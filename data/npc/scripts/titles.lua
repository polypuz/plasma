local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

--[[
--getTitles()
--setPlayerTitle()
--getPlayerTitle(cid)
-- can all be found in data/global.lua as global functions
 ]]

local function creatureSayCallback(cid, type, msg)
  if not npcHandler:isFocused(cid) then
    return false
  end
  local titles = getTitles(cid)
  if msgcontains(msg, "tytuly") or msgcontains(msg, "titles") then
    if titles == nil then
      npcHandler:say("Aktualnie nie masz zadnych dostepnych tytulow.", cid)
    else
      local titleString = "Aktualnie masz dostepne nastepujace tytuly:"
      for k, v in ipairs(titles) do
        if k ~= 1 then
          titleString = titleString .. ","
        end
        titleString = titleString .. " [{" .. k .. "}] " .. v.title .. ""
      end
      titleString = titleString .. "."
      npcHandler:say({titleString, "Aby zmienic tytul, napisz ktory konkretnie Cie interesuje (np. {1})."}, cid)
     npcHandler.topic[cid] = 1
    end
  elseif msgcontains(msg, "tytul") or msgcontains(msg, "title") then
    npcHandler:say({"Tytuly nadawane sa za otrzymanie osiagniecia, ukonczenie wyjatkowo trudnego zadania lub za uczestniczenie w wydarzeniach serwera.", "Jesli chcesz zobaczyc swoje tytuly i zmienic tytul dla swojej postaci, napisz {tytuly}."}, cid)
  elseif npcHandler.topic[cid] == 1 then
    local titleId = tonumber(msg)
    if titleId == nil then
      npcHandler:say("He? Nie ma takiej opcji wsrod Twoich tytulow. Zapytaj mnie o {tytuly}, jesli nie jestes pewny jak to dziala.", cid)
      npcHandler.topic[cid] = 0
    else
      local found = false
      for k,v in ipairs(titles) do
        if k == titleId then
          found = true
          titleId = v.id
          break
        end
      end
      if found then
        if setPlayerTitle(cid, titleId) then
          if titleId == 0 then
            npcHandler:say("W porzadku, " .. Player(cid):getName() .. ", od teraz nie przedstawiasz sie zadnym tytulem.", cid)
          else
            npcHandler:say("W porzadku, " .. Player(cid):getName() .. ", od teraz Twoim przydomkiem jest " .. getPlayerTitle(Player(cid):getGuid()) .. ".", cid)
          end
        else
          npcHandler:say("Cos poszlo nie tak.", cid)
        end
      else
        npcHandler:say("Niestety, nie znalazlem takiego tytulu w Twoich zasobach.", cid)
      end
    end
  else
    npcHandler:say("Nie rozumiem. Moge wytlumaczyc Ci jak zdobyc {tytul}, albo powiedziec jakie {tytuly} juz zdobyles.", cid)
    npcHandler.topic[cid] = 0
  end

  return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())