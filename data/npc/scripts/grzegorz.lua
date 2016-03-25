local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

  if msgcontains(msg, "problemy") or msgcontains(msg, "problems") or msgcontains(msg, "problemow") then
    npcHandler:say("Problemy, problemy... co by duzo nie mowic. Wokol miasta wciaz rasuje wataha wilkow, a ostatnio mielismy plage samobojcow. Pod drzewami pietrzyly sie zwloki tych nieszczesnikow...", cid)
    Player(cid):setStorageValue(38004, 1)
  else
    npcHandler:say("Nie wiem o czym mowisz. Idz stad, mam wystarczajaco duzo {problemow}.", cid)
  end

	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
