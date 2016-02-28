local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function bless(player)
	for i = 1,5 do
		player:addBlessing(i)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if isInArray({"pomoc", "pomocy", "help", "tak", "yes"}, msg) and npcHandler.topic[cid] == 0 then
		npcHandler:say({"Znajdujesz sie w swiatyni miasta. Jezeli chcesz, moge {uleczyc} Twoje rany, {poblogoslawic} Cie lub {zaznaczyc} na mapie najwazniejszych NPC.",
		"Przeprowadzam takze obrzed zawarcia {malzenstwa}.",
		"Moge tez sprzedac Ci swojego bolca - {wooden stake}. Slyszalem, ze #bolecnaboku jest ostatnio dosc popularny..."}, cid)--[[
		npcHandler.topic[cid] = 0
	elseif  isInArray({"zadanie", "quest", "misja", "mission"}, msg) then
		npcHandler.topic[cid] = 1
		npcHandler:say("Cos sie dzieje. Zapytaj mnie za kilka dni, powinienem miec cos dla ciebie.", cid)
		]]
	elseif  isInArray({"mark", "zaznacz", "map", "zaznaczyc"}, msg) then
		npcHandler.topic[cid] = 0
		npcHandler:say("Prosze bardzo. Zagladnij do mnie za jakis czas, mozliwe ze pojawia sie nowi NPC.", cid)
	elseif isInArray({"bless","blessy","blessing","blessings","blogoslawienstwo","blogoslawienstwa","blogoslaw","poblogoslawic", "poblogoslaw"}, msg ) then
		if player:hasBlessing(5) then
			npcHandler:say("Juz Cie poblogoslawilem. Odezwij sie, gdy stracisz moja moc.", cid)
			npcHandler.topic[cid] = 0
		else
			npcHandler:say("Blogoslawienstwo kosztuje 70 000 zlota (na nowy konfesjonal!) i chroni Cie przed utrata ekwipunku, jak i zmniejsza kare za smierc. Czy chcesz, abym Cie poblogoslawil?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif isInArray({"tak", "yes"}, msg ) and npcHandler.topic[cid] == 1 then
		if ( player:removeItem(2160, 7) or player:removeItem(2152, 700) or player:removeItem(2148, 70000) ) then
			npcHandler:say("W imie Ojca, i Syna, i Ducha Swietego... strzez sie przed Harrym Potterem i innymi wcieleniami Szatana!", cid)
			bless( player )
			npcHandler:say("Dzieki Ci za ofiare. Idz w pokoju i badz blogoslawiony!", cid)
		else
			npcHandler:say("Wybacz, ale abym Cie poblogoslawil musisz wpierw zlozyc ofiare na tace... skromne 70 000 sztuk zlota. Akurat na nowy konfesjonal!", cid)
		end
		local configMarks = {
			{mark = "tools", position = Position(897, 1109, 7), markId = 7, description = "Sklep z narzedziami"},
			{mark = "fluids", position = Position(911, 1108, 7), markId = 3, description = "Zaopatrzenie magiczne"},
			{mark = "depo", position = Position(930, 1112, 7), markId = 10, description = "Depo"},
			{mark = "post", position = Position(930, 1112, 6), markId = 9, description = "Poczta"},
			{mark = "arm", position = Position(889, 1112, 7), markId = 8, description = "Skup uzbrojenia"},
			{mark = "jewelry", position = Position(888, 1126, 7), markId = 6, description = "Jubiler"},
			{mark = "creatureproducts", position = Position(878, 1126, 7), markId = 11, description = "Sprzedaz creatureproducts"},
			{mark = "paladinshop", position = Position(901, 1125, 7), markId = 11, description = "Zaopatrzenie dla lucznikow"},
			{mark = "bank", position = Position(930, 1106, 7), markId = 13, description = "Bank"},
			{mark = "shophouse", position = Position(877, 1111, 7), markId = 11, description = "Wyposazenie domu"},
			{mark = "food", position = Position(911, 1124, 7), markId = 11, description = "Sklep z jedzeniem"}
		}

		for i = 1, #configMarks do
			mark = configMarks[i]
			player:addMapMark(mark.position, mark.markId, mark.description)
		end

	elseif isInArray({"rany", "lecz", "ulecz", "heal", "uleczyc"}, msg) then
		npcHandler.topic[cid] = 0
		player:addHealth(9999)
		npcHandler:say("Zostales uzdrowiony.", cid)
		local conditions = { CONDITION_POISON, CONDITION_FIRE, CONDITION_ENERGY, CONDITION_BLEEDING, CONDITION_PARALYZE, CONDITION_DROWN, CONDITION_FREEZING, CONDITION_DAZZLED, CONDITION_CURSED }
		for i = 1, #conditions do
			player:removeCondition(conditions[i])

		end
    elseif msgcontains(msg, "malzenstwo") or msgcontains(msg, "malzenstwa") or msgcontains(msg, "marriage") then
        local playerStatus = getPlayerMarriageStatus(player:getGuid())
        local playerSpouse = getPlayerSpouse(player:getGuid())
        if (playerStatus == MARRIED_STATUS) then
            msg = ' Z moich kronik wynika, ze jestes w zwiazku malzenskim. Co Cie tu sprowadza? Czyzby {rozwod}?'
        elseif (playerStatus == PROPOSED_STATUS) then
            msg = '{' .. (getPlayerNameById(playerSpouse)) .. '} dalej nie odpowiada na oswiadczyny. Czy chcesz je {anulowac}?'
        else
            msg = ' Aby wziac {slub}, powiedz wprost!'
        end
        npcHandler:say(msg,cid)
        --selfSay(msg,cid)
        npcHandler:addFocus(cid)
        return false
	elseif msgcontains(msg, "wedding") or msgcontains(msg, "slub") then
        local playerStatus = getPlayerMarriageStatus(player:getGuid())
        local playerSpouse = getPlayerSpouse(player:getGuid())
        if (playerStatus == MARRIED_STATUS) then
            msg = msg .. ' Widze ten pierscionek na palcu. Co Cie tu sprowadza? Czyzby {rozwod}?'
        elseif (playerStatus == PROPOSED_STATUS) then
            msg = msg .. ' Nadal oczekujesz na akceptacje przez {' .. (getPlayerNameById(playerSpouse)) .. '}. Czy chcesz ja {anulowac}? ({anuluj})'
        else
            msg = 'Aaach, to swietnie! Czyli chcesz kogos {poslub}ic?'
        end
        npcHandler:say(msg,cid)
        --selfSay(msg,cid)
        npcHandler:addFocus(cid)
        return false
	elseif msgcontains(msg, "stroj") or msgcontains(msg, "pierscien") or msgcontains(msg, "pierscionek") then
		npcHandler:say("{Pierscionek} mozesz odkupic od innego gracza, lub w sklepie lokalnego jubilera, tudziez kupca z blyskotkami. {Stroj} natomiast jest dostepny w sklepie WWW, prosto od Piroga.", cid)
        npcHandler:addFocus(cid)
	elseif isInArray({"wooden stake", "bolec", "bolec na boku", "blessed wooden stake", "blessed stake", "blessed wooden"}, msg) then
		npcHandler:say("Bolec kosztuje 5000. Prawie niesmigany. To co, chcesz? ({tak} / {nie})", cid)
		npcHandler.topic[cid] = 2
	elseif isInArray({"poblogoslawiony bolec na boku", "poblogoslawiony bolec"}, msg) then
		--npcHandler:say("Musisz poczekac az Jedyny Prawilny Imperator, zwany tez Marahinem, doda aktualizacje. Nastepnym razem.", cid)
		--npcHandler.topic[cid] = 0
		local playerHasBolec = player:getItemById( 5941, true )
		if playerHasBolec then
			local val = player:getStorageValue(5000)
			if val > 0 then
				if val == 1 then
					npcHandler:say("Galganie, nie skonczyles zadania. Zabij 100 wampirow i dopiero wtedy tutaj przyjdz.", cid)
				else
					if player:removeItem( 5941 ) then
						npcHandler:say("Wiec udalo Ci sie, amen. Oto Twoj bolec na boku.", cid)
						player:addItem(5942, 1)
					else
						npcHandler:say("Udalo Ci sie, to swietnie. Przynies mi bolec, a go poblogoslawie.", cid)
					end
				end
			else
				npcHandler:say("Moge poblogoslawic Twojego bolca, ale nie bez przyslugi. Aby bolec nabral mocy, musisz wybic 100 wampirow, ktore ostatnio panosza sie po naszym swiecie. Gdy juz to zrobisz, odezwij sie do mnie.", cid)
					player:setStorageValue( 5000, 1 ) --5001 is the storageKey for natanek's task
				end
		else
			npcHandler:say("Abym mogl poblogoslawic Twojego bolca, najpierw musisz go miec. Moge Ci sprzedac swojego, za 5000 zlota - wspomnij tylko o {wooden stake} albo po prostu - {bolec}.", cid)
		end
		npcHandler.topic[cid] = 0
	elseif isInArray({"yes", "tak"}, msg) and npcHandler.topic[cid] == 2 then
		if player:removeMoney( 5000 ) then
			npcHandler:say("OK. Opiekuj sie nim dobrze. Jak chcesz, to moge tez zrobic z niego {poblogoslawiony bolec na boku}.", cid)
			player:addItem(5941, 1)
		else
			npcHandler:say("Pff! Moj #bolecnaboku nawet nie zechcialby kogos, kogo na niego nie stac. Spadaj.", cid)
		end
		npcHandler.topic[cid] = 0
	elseif isInArray({"no", "nie"}, msg) then
		npcHandler:say("Nie to nie, sam sie przebolcuje...", cid)
		npcHandler.topic[cid] = 0
    end
    return true
end

local function tryEngage(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local player = Player(cid)

    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local playerSpouse = getPlayerSpouse(player:getGuid())
    if playerStatus == MARRIED_STATUS then -- check if the player is already married
        npcHandler:say('Juz poslubiles {' .. getPlayerNameById(playerSpouse) .. '}.', cid)
    elseif playerStatus == PROPOSED_STATUS then --check if the player already made a proposal to some1 else
        npcHandler:say('Jestes w trakcie oswiadczyn wobec {' .. getPlayerNameById(playerSpouse) .. '}. Zawsze mozesz {anulowac} swoja propozycje.', cid)
    else
        local candidate = getPlayerGUIDByName(message)
        if candidate == 0 then -- check if there is actually a player called like this
            npcHandler:say('Ktos taki nie istnieje w moich ksiegach.', cid)
        elseif candidate == player:getGuid() then -- if it's himself, cannot marry
            npcHandler:say('Stulejo, badz powazna.', cid)
        else
            if player:getItemCount(ITEM_WEDDING_RING) == 0 or player:getItemCount(10503) == 0 then -- check for items (wedding ring and outfit box)
                npcHandler:say('Najpierw musisz miec {stroj} i {pierscionek}. Dopiero wtedy mozemy przejsc do konkretow!', cid)
            else
                local candidateStatus = getPlayerMarriageStatus(candidate)
                local candidateSpouse = getPlayerSpouse(candidate)
                if candidateStatus == MARRIED_STATUS then -- if the player you want to marry is already married and to whom
                    npcHandler:say('{' .. getPlayerNameById(candidate) .. '} jest w zwiazku z {' .. getPlayerNameById(candidateSpouse) .. '}, przykro mi.', cid)
        elseif candidateStatus == PROPACCEPT_STATUS then -- if the player you want to marry is already going to marry some1 else
                    npcHandler:say('{' .. getPlayerNameById(candidate) .. '} jest w narzeczenstwie z {' .. getPlayerNameById(candidateSpouse) .. '}, i - miejmy nadzieje - niedlugo dopelnia formalnosci.', cid)
        elseif candidateStatus == PROPOSED_STATUS then -- if he/she already made a proposal to some1
                    if candidateSpouse == player:getGuid() then -- if this someone is you.
            npcHandler:say('W zwiazku z tym, ze wola jest obustronna - przygotujcie sie. A gdy bedziecie gotowi, zawolajcie mnie, a {ceremonia} sie rozpocznie!',cid)
                        player:removeItem(ITEM_WEDDING_RING,1)
                        player:removeItem(10503,1) -- wedding outfit box
            player:addOutfit(329) --Wife
            player:addOutfit(328) --Husb
                        setPlayerMarriageStatus(player:getGuid(), PROPACCEPT_STATUS)
                        setPlayerMarriageStatus(candidate, PROPACCEPT_STATUS)
            setPlayerSpouse(player:getGuid(), candidate)
            local player = Player(getPlayerNameById(candidate))
            player:addOutfit(329)
            player:addOutfit(328)
           else -- if this some1 is not you
                        npcHandler:say('{' .. getPlayerNameById(candidate) .. '} jest w trakcie oswiadczyn z {' .. getPlayerNameById(candidateSpouse) .. '}.', cid)
                    end
                else -- if the player i want to propose doesn't have other proposal
                    npcHandler:say('Fantastycznie. Teraz musimy poczekac i zobaczyc, czy {' ..  getPlayerNameById(candidate) .. '} zaakceptuje Twoja propozycje. Pamietaj, ze w kazdej chwili mozesz ja {anulowac}.', cid)
                    player:removeItem(ITEM_WEDDING_RING,1)
                    player:removeItem(10503,1)
                    setPlayerMarriageStatus(player:getGuid(), PROPOSED_STATUS)
                    setPlayerSpouse(player:getGuid(), candidate)
                end
            end
        end
    end
    keywordHandler:moveUp(1)
    return false
end

local function confirmWedding(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local player = Player(cid)
    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local candidate = getPlayerSpouse(player:getGuid())
    if playerStatus == PROPACCEPT_STATUS then
        --local item3 = Item(doPlayerAddItem(cid,ITEM_Meluna_Ticket,2))
        setPlayerMarriageStatus(player:getGuid(), MARRIED_STATUS)
        setPlayerMarriageStatus(candidate, MARRIED_STATUS)
        setPlayerSpouse(player:getGuid(), candidate)
        setPlayerSpouse(candidate, player:getGuid())
		--[[
        delayedSay('Dear friends and family, we are gathered here today to witness and celebrate the union of ' .. getPlayerNameById(candidate) .. ' and ' .. player:getName() .. ' in marriage.')
        delayedSay('Through their time together, they have come to realize that their personal dreams, hopes, and goals are more attainable and more meaningful through the combined effort and mutual support provided in love, commitment, and family;',5000)
        delayedSay('and so they have decided to live together as husband and wife. And now, by the power vested in me by the Gods of Tibia, I hereby pronounce you husband and wife.',15000)
        delayedSay('*After a whispered blessing opens an hand towards ' .. player:getName() .. '* Take these two engraved wedding rings and give one of them to your spouse.',22000)
        delayedSay('You may now kiss your bride.',28000)
		]]
        delayedSay('Kochane Mirki i Mirabelki, zebralismy sie dzis, aby uczcic zawarcie zwiazku malzenskiego pomiedzy ' .. getPlayerNameById(candidate) .. ' i ' .. player:getName() .. '.')
        delayedSay('Poprzez podroze, rozmowy i gre zrozumieli, ze czas wyjsc z #tfwnogf i #tfwnobf, najwyzsza pora odwinac stulejke i zaczac grac na powaznie.',5000)
        delayedSay('W zwiazku z tym dzisiaj zostana polaczeni wiezami malzenstwa na MirkOTS, a wiec pozostana solidarni w huncie, w pekowaniu, w biedzie i w rollbackach serwera.',15000)
        delayedSay('*szepczac cos o #nocnazmiana i #neuropa, wyciaga dlon z pierscionkami ku ' .. player:getName() .. '* Wez te grawerowane pierscienie, a jeden przekaz swojej drugiej, Mirkowej polowce.',22000)
        delayedSay('Mozesz zaplusowac swojego oficjalnego, Mirkowego #rozowypasek.',28000)
        local item1 = Item(doPlayerAddItem(cid,ITEM_ENGRAVED_WEDDING_RING,1))
        local item2 = Item(doPlayerAddItem(cid,ITEM_ENGRAVED_WEDDING_RING,1))
		local trophy1 = Item( doPlayerAddItem(cid, 7370, 1) )
		local trophy2 = Item( doPlayerAddItem(cid, 7370, 1) )

		trophy1:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "To trofeum nalezy do "..player:getName()..", nadane przez Ks. Natanka, za zawarcie zwiazku malzenskiego.")
		trophy2:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "To trofeum nalezy do "..getPlayerNameById( candidate )..", nadane przez Ks. Natanka, za zawarcie zwiazku malzenskiego.")

        item1:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, player:getName() .. ' & ' .. getPlayerNameById(candidate) .. ', dopoki tagi na Wykopie nie zostana naprawione, od ' .. os.date('%B %d, %Y.'))
        item2:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, player:getName() .. ' & ' .. getPlayerNameById(candidate) .. ', dopoki tagi na Wykopie nie zostana naprawione, od ' .. os.date('%B %d, %Y.'))
    else
        npcHandler:say('Twoj partner nie zaakceptowal propozycji, przynajmniej narazie.', cid)
    end
    return true
end

local function confirmRemoveEngage(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local player = Player(cid)
    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local playerSpouse = getPlayerSpouse(player:getGuid())
    if playerStatus == PROPOSED_STATUS then
        npcHandler:say('Czy na pewno chcesz zrezygnowac z oswiadczyn wobec {' .. getPlayerNameById(playerSpouse) .. '}? ({tak} / {nie})', cid)
        node:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 3, text = 'Okej, w takim razie nic nie zmieniamy.'})

        local function removeEngage(cid, message, keywords, parameters, node)
            doPlayerAddItem(cid,ITEM_WEDDING_RING,1)
			doPlayerAddItem(cid,10503,1)
            setPlayerMarriageStatus(player:getGuid(), 0)
            setPlayerSpouse(player:getGuid(), -1)
            npcHandler:say(parameters.text, cid)
            keywordHandler:moveUp(parameters.moveup)
        end
        node:addChildKeyword({'tak'}, removeEngage, {moveup = 3, text = 'OK. Twoje oswiadczyny zostaly anulowane. Oto Twoj {pierscionek}, ktory dales wczesniej.'})
    else
        npcHandler:say('Nie oswiadczyles sie nikomu.', cid)
        keywordHandler:moveUp(2)
    end
    return true
end

local function confirmDivorce(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local player = Player(cid)
    local playerStatus = getPlayerMarriageStatus(player:getGuid())
    local playerSpouse = getPlayerSpouse(player:getGuid())
    if playerStatus == MARRIED_STATUS then
        npcHandler:say('A wiec chcesz rozwiesc sie z {' .. getPlayerNameById(playerSpouse) .. '}? ({tak} / {nie})', cid)
        node:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 3, text = 'To dobrze. Gardze rozwodami.'})

        local function divorce(cid, message, keywords, parameters, node)
            local player = Player(cid)
            local spouse = getPlayerSpouse(player:getGuid())
            setPlayerMarriageStatus(player:getGuid(), 0)
            setPlayerSpouse(player:getGuid(), -1)
            setPlayerMarriageStatus(spouse, 0)
            setPlayerSpouse(spouse, -1)
            npcHandler:say(parameters.text, cid)
            keywordHandler:moveUp(parameters.moveup)
        end
        node:addChildKeyword({'tak'}, divorce, {moveup = 3, text = 'W porzadku. Nie jestescie juz razem. Jestem pewny, ze {' .. getPlayerNameById(playerSpouse) .. '} ciezko to przezyje.'})
    else
        npcHandler:say('Nie masz malzonka, wiec nie mozesz sie rozwiesc. Smiesznie, nie?', cid)
        keywordHandler:moveUp(2)
    end
    return true
end

local node1 = keywordHandler:addKeyword({'poslub'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Aby wziac slub, musisz posiadac trzy rzeczy: partnera, oczywiscie, oraz odpowiedni {stroj} oraz {pierscionek}. Czy jestes gotowy? ({tak} / {nie})'})
node1:addChildKeyword({"nie"}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 1, text = 'W porzadku. Wroc jak wszystko skompletujesz.'})
local node2 = node1:addChildKeyword({"tak"}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'To swietnie. A kogo chcesz poslubic?'})
node2:addChildKeyword({'[%w]'}, tryEngage, {})

local node3 = keywordHandler:addKeyword({'ceremonia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'A wiec mozemy zaczynac. Czy swiadkowie i goscie sa na miejscu? ({tak} / {nie})'})
node3:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, moveup = 1, text = 'W takim razie po co mnie wolasz?! Sciagnij ich tu!'})
local node4 = node3:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Pieknie! {Rozpocznijmy}, dajcie tylko znak.'}) --, confirmWedding, {})
node4:addChildKeyword({'rozpocznijmy'}, confirmWedding, {})


keywordHandler:addKeyword({'anuluj'}, confirmRemoveEngage, {})

keywordHandler:addKeyword({'rozwod'}, confirmDivorce, {})
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
