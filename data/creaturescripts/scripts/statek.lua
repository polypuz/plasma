local miasta = {
	[1] = Position(1017, 1053, 6), 	--Mirko Town
	[2] = Position(216, 966, 7), 	--Jaszczurze Miasto
	[3] = Position(658, 335, 7),    --Smoki, wyrmy, behemothy
	[4] = Position(847, 370, 6), 	--Kraina Aladyna
	[5] = Position(1900, 380, 6), 	--Amazonia
	[6] = Position(1522, 308, 7), 	--Atlantyda
	[7] = Position(349, 1736, 6),	--Skala Barbarzyncow
	[8] = Position(2069, 1080, 6),	--Puerto de mogan
	[9] = Position(459, 1649, 7),	--Fryst	
	[10] = Position(1506, 738, 6),	--Kolobrzeg
	[11] = Position(1861, 1405, 6), --Opuszczona Kolonia
	[12] = Position(530, 647, 6), 	--Wyspa Horrorow
	[13] = Position(1322, 2012, 7),	--Bagna
	[14] = Position(885, 605, 6)	--Cotopaxi
	
}

local miasta_szmugler = {
	[1] = Position(1016, 1052, 7), 	--Mirko Town
	[2] = Position(175, 1008, 7), 	--Jaszczurze Miasto
	[3] = Position(599, 267, 7),    --Smoki, wyrmy, behemothy
	[4] = Position(850, 376, 7), 	--Kraina Aladyna
	[5] = Position(1900, 380, 7), 	--Amazonia
	[6] = Position(1451, 272, 7), 	--Atlantyda
	[7] = Position(344, 1736, 7),	--Skala Barbarzyncow
	[8] = Position(2069, 1080, 7),	--Puerto de mogan
	[9] = Position(425, 1673, 7),	--Fryst	
	[10] = Position(1506, 738, 7),	--Kolobrzeg
	[11] = Position(1860, 1405, 7),	--Opuszczona Kolonia
	[12] = Position(530, 645, 7), 	--Wyspa Horrorow
	[13] = Position(1294, 1950, 7), 	--Bagna
	[14] = Position(885, 606, 7)	--Cotopaxi
}


function onModalWindow(cid, modalWindowId, buttonId, choiceId, item, position, pos, toPosition, fromPosition, itemEx)
local player = Player(cid)

    if (modalWindowId == 1 and (buttonId == 3)) or (modalWindow == 1 and (player:getSkull() == 3 or player:getSkull() == 4 or player:getSkull() == 5)) then --pomoc //
		player:showTextDialog(2113, "Mozesz plywac miedzy miastami, jezeli masz odpowiednia ilosc pieniadzy przy sobie.\nNie mozesz byc rowniez podejrzany o morderstwo. \nAktualny koszt podrozy to 200gp. \n\nPosiadasz przy sobie "..player:getMoney().." zlota.")
   elseif modalWindowId == 1 and buttonId == 2 then --wybierz//
		if player:removeMoney(200) then
			local pozycja = miasta[choiceId]
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(pozycja)
			pozycja:sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:sendCancelMessage("Nie masz kasy.")
		end
	elseif modalWindowId == 2 and ( buttonId == 3) then
		player:showTextDialog( 2113, "Szmugler pozwoli Ci na podroz miedzy\n kontynentami i wyspami, w momecnie, gdy jestes podejrzany o morderstwo.\nWtedy domyslny przewoznik (Jacek Wrobel)\n odmowi zabrania Cie na poklad.\nWada Szmuglera jest jego koszt - 10000 zlota za jedna podroz. W tym momencie\n posiadasz przy sobie " .. player:getMoney() .. " zlota.")
	elseif modalWindowId == 2 and buttonId == 2 then
		if player:removeMoney( 10000 ) then
			local pozycja = miasta_szmugler[choiceId]
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo( pozycja )
			pozycja:sendMagicEffect( CONST_ME_TELEPORT )
		else
			player:sendCancelMessage("Spadaj zielonko, nie masz monet.")
		end
	
   end
	
	
end