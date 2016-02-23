local function playerMsg(player, msg)
	doPlayerSendTextMessage( player.uid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
end

local function playerBroadcast(player, msg)
	doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, msg)
end

function onLogin(player)
	local loginStr = "Witaj na " .. configManager.getString(configKeys.SERVER_NAME) .. "!"
	player:openChannel(3) --czat mirko
	player:openChannel(5) --czat wymiana
	player:openChannel(7) --czat pomoc
	
	--Shop items
	local values = db.storeQuery("SELECT * FROM `unprocessed_orders` WHERE `player_id`=".. player:getGuid() .." LIMIT 1")
	local order_type = result.getDataInt(values, "order_type")
	local order_id = result.getDataInt(values, "order_id")
	local item_id = result.getDataInt(values, "item_id")
	local count = result.getDataInt(values, "count") -- used as number of addons for the outfits
	local parcel_created = false
	local donationTrophyValue = 97944
	while values do
		print('[$$$] GRACZ ' .. player:getName() .. ' WLASNIE COS KUPIL --')
		
		if order_type == 5 then
			-- bought some addons & outfits
			local outfit = { female = item_id, male = item_id+1 }
			if player:hasOutfit(outfit.female, count) or player:hasOutfit(outfit.male, count) then
				-- he shouldnt have them, so we abort and drop good info on it
				player:sendTextMessage(MESSAGE_STATUS_DESCR, "Kupiles stroj, ktory juz posiadasz. Prosimy o kontakt z administracja.")
			else
				player:addOutfit( outfit.female, count )
				player:addOutfit( outfit.male, count)
				if player:hasOutfit(outfit.female, count) or player:hasOutfit(outfit.male, count) then
					-- good job
					player:sendTextMessage(MESSAGE_STATUS_DESCR, "Zakupiony przez Ciebie stroj zostal dodany. Milej gry!")
					local outfit_done = true
				else
					-- something went wrong
					player:sendTextMessage(MESSAGE_STATUS_DESCR, "Cos poszlo nie tak przy dodawaniu stroju. Prosimy o kontakt z administracja.")
					break
				end
			end			
		else -- bought some items
			--Lets check if player have slot or cape left. Else send to player inbox
			local parcel = player:getInbox():addItem(2596, 1, false, 1)
			if not parcel then --If not being able to create parcel we stop the script and retry again.
				print('[ERROR Shop] = Error on creating a parcel.')
				parcel_created = false
			else
				local letter = parcel:addItem(2598, 1, false, 1)
				if player:getStorageValue( donationTrophyValue ) == -1 then
					letter:setAttribute(ITEM_ATTRIBUTE_TEXT, 'Dziekujemy za wsparcie serwera - otrzymales swoj przedmiot!\nDzieki takim jak Ty ten serwer sie utrzymuje.\nW dodatku, za to, ze jest to Twoj pierwszy zakup - dostajesz symboliczny prezent!\n\nPowodzenia w grze.\nEkipa MirkOTS')
					--ITEM_ATTRIBUTE_DESCRIPTION
					parcel:addItem(7369, 1, false, 1):setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "To trofeum nalezy do "..player:getName()..", nadane przez ekipe MirkOTS. Zdobyl je pomagajac w utrzymaniu serwera.")
					player:setStorageValue( donationTrophyValue, 1 )
				else
					letter:setAttribute(ITEM_ATTRIBUTE_TEXT, 'Dziekujemy za wsparcie serwera - otrzymales swoj przedmiot!\nDzieki takim jak Ty ten serwer sie utrzymuje.\nPowodzenia w grze!\nEkipa MirkOTS')
				end
				parcel:addItem(item_id, count or 1, false, 1)
				parcel_created = true
			end
		

		end			
		if parcel_created or outfit_done then
			db.query("DELETE FROM `unprocessed_orders` WHERE `order_id`=" .. order_id .. " AND `player_id`=" .. player:getGuid() )
			db.query("INSERT INTO `completed_orders` (`order_type`, `order_id`, `player_id`, `item_id`, `count`) VALUES (" .. order_type .. ", " .. order_id .. ", " .. player:getGuid() .. ", " .. item_id .. ", " .. (count or 1) .. ")")
			player:sendTextMessage(MESSAGE_STATUS_DESCR, "Przedmioty ze sklepu zostaly dodane do Twojej postaci lub wyslane poczta. Dziekujemy za wsparcie!")

		end
		
		values = db.storeQuery("SELECT * FROM `unprocessed_orders` WHERE `player_id`=".. player:getGuid() .." LIMIT 1")
		item_id = result.getDataInt(values, "item_id")
		order_id = result.getDataInt(values, "order_id")
		order_type = result.getDataInt( values, "order_type")
		count = result.getDataInt(values, "count")
		parcel_created = false
		outfit_done = false
	end
	
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Ubierz sie jak Ci sie podoba."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format("Twoja ostatnia wizyta byla %s.", os.date("%a %b %d %X %Y", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	-- event
	local event = false
	
	local eventStorageKey = 15000
	local eventItemCap = 15
	local eventItemId = 16007
	local eventItemCount = 1
	local eventDescr = "Z okazji zalogowania sie miedzy 26.01 a 27.01 dostajesz wyjatkowy plecak upamietniajacy 15 dzien dzialania serwera! Milej gry!"
	local eventDescrFailed = "Oczekuje na Ciebie prezent! Zwolnij jeden slot w ekwipunku i 15 cap, a potem przeloguj sie, aby go otrzymac."
	local eventstatus = player:getStorageValue( eventStorageKey )
	if event then
		if eventstatus == -1 then
			if player:getFreeCapacity() >= eventItemCap then
				if not player:getItemById(eventItemId, true, -1) then
					player:addItem(eventItemId, eventItemCount, false, CONST_SLOT_WHEREEVER )
					player:sendTextMessage( MESSAGE_INFO_DESCR, eventDescr )
					player:setStorageValue(eventStorageKey, 1)
				end
			else
				player:sendTextMessage(MESSAGE_INFO_DESCR, eventDescrFailed)
			end	
		end
	end
	
	-- Stamina
	nextUseStaminaTime[player.uid] = 0

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local value = player:getStorageValue(STORAGEVALUE_PROMOTION)
		if not promotion and value ~= 1 then
			player:setStorageValue(STORAGEVALUE_PROMOTION, 1)
		elseif value == 1 then
			player:setVocation(promotion)
		end
	elseif not promotion then
		player:setVocation(vocation:getDemotion())
	end
	
	-- player:showTextDialog(2523, "Witaj na MirkOTS!\nMirkOTS to serwer zrobiony dla spolecznosci Wykop.pl.\nPrzestrzegaj regulaminu znajdujacego sie na stronie:\nhttp://mirkots.gimb.us/\nJesli masz sugestie lub buga, wrzuc je na Forum, zamiast pisac na Pomocy / na PRIV do GMa.\nKorzystaj z kanalu Pomoc!\nMilego dnia i udanych lowow!")

	-- Events
	player:registerEvent("addon")
	player:registerEvent("statek")
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	local poziom=player:getLevel()
	local bank= player:getBankBalance()
	
	
			if poziom >= 15 and player:getStorageValue(3015) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 15 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+2000)
				player:setStorageValue(3015, 1)
				
			elseif poziom >= 30 and player:getStorageValue(3030) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 30 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+4000)
				player:setStorageValue(3030, 1)
			
			elseif poziom >= 50 and player:getStorageValue(3050) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 50 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+10000)
				player:setStorageValue(3050, 1)
			
			elseif poziom >= 75 and player:getStorageValue(3075) < 1 then			
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 75 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+15000)
				player:setStorageValue(3075, 1)
			
			elseif poziom >= 100 and player:getStorageValue(3100) < 1 then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'Otrzymales nagrode za osiagniecie 100 poziomu. Sprawdz bank. ')
				player:setBankBalance(bank+30000)
				player:setStorageValue(3100, 1)
				
			end
	
	return true
end