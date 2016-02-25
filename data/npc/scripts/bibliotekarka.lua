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
	else
		if msgcontains(msg, "jonasz") then
			npcHandler:say("Cholerny ekoterrorysta, stary wariat. Ciagle powtarzal tylko \"{martwe drzewa}, {martwe drzewa}\"... Pewnego dnia zamknal sie w swojej {chacie} i nikt go wiecej nie widzial.", cid)
			npcHandler.topic[cid] = 1
		elseif msgcontains(msg, "martwe drzewa") then
			if npcHandler.topic[cid] == 1 then
				npcHandler:say("Niestety nie wiem o co chodzi. Trzeba by go zapytac.", cid)
			else
				npcHandler:say("Tak... {Jonasz} ciagle to powtarzal. Stary glupiec.", cid)
			end
		elseif msgcontains(msg, "chata") or msgcontains(msg, "chacie") then
			npcHandler:say("A, tak. Niestety, ale nie ma do niej dostepu. Kiedys mozna bylo do niej dojsc idac po zamarznietym lodzie, ale gdy przyszly roztopy - nas i jego wysepke oddziela morze.", cid)
			npcHandler.topic[cid] = 1
		end
	end

	return true
end

local function onAddFocus(cid)
	-- town[cid] = 0
	-- vocation[cid] = 0
	-- destination[cid] = 0
end

local function onReleaseFocus(cid)
	-- town[cid] = nil
	-- vocation[cid] = nil
	-- destination[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())