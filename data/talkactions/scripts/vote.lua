----------------- CONFIG ---------------------

local reqLevel = 50
local reqCreationDate = 1454194800

----------------- CONFIG ---------------------

local function playerMsg(player, msg)
	doPlayerSendTextMessage( player.uid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
end

local function playerBroadcast(player, msg)
	doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, msg)
end

local function ipVoted( player )
	local val = db.storeQuery("SELECT * FROM `vote` WHERE `ip`=( SELECT `lastip` FROM `players` WHERE `id`=" .. player:getGuid() .. ") OR `ip`=" .. player:getIp())
	print("checking ip: " .. player:getIp() )
	if val then
		playerMsg(player, "Glosowales juz z tego adresu IP. Nie oszukuj! :(")
		return true
	else
		return false
	end
	playerMsg( player, "Wystapil problem z polaczeniem do bazy. Zglos administratorowi ten kod bledu: 2137.")
	return true
end

local function accountCreatedAfterBroadcast( player, reqCreationDate )

	print( "Got: " .. tostring( reqCreationDate) .. " as reqCreationDate")
	local val = db.storeQuery("SELECT `creation` FROM `accounts` WHERE `id`=( SELECT `account_id` FROM `players` WHERE `id`=" .. player:getGuid() .. ")")
	local accCreationTimestamp = result.getDataInt( val, "creation" )
	
	print( "Creation got: " .. tostring( accCreationTimestamp ) )
	if accCreationTimestamp and accCreationTimestamp > 0 then
		if accCreationTimestamp <= reqCreationDate then
			return false
		else
			playerMsg( player, "Twoje konto zostalo utworzone po 31 stycznia. Nie mozesz wziac udzialu w glosowaniu.")
			return true
		end
	else
		playerMsg( player, "Wystapil problem z pobraniem daty utworzenia Twojego konta. Zglos to administracji.")
		return true
	end
	return true
end

local function accountVoted( player )
	local val = db.storeQuery("SELECT * FROM `vote` WHERE `account_id`=( SELECT `account_id` FROM `players` WHERE `id`=" .. player:getGuid() .. ") OR `player_id`=" .. player:getGuid())
	if val then
		playerMsg(player, "Glosowales juz z tego konta. Nie oszukuj! :(")
		return true
	else
		return false
	end
	playerMsg( player, "Wystapil problem z polaczeniem z baza danych. Zglos administratorowi nastepujacy kod: 2138.")
	return true
end

local function playerHasAppropriateLevel( player, reqLevel )
	if player:getLevel() >= reqLevel then
		return true
	else
		playerMsg( player, "Masz zbyt niski poziom, aby wziac udzial w tym glosowaniu.")
		return false
	end
	playerMsg( player, "Wystapil blad. Zglos administracji nastepujacy kod bledu: 2139.")
	return false
end

function addRecord( player, option )

	local query = "INSERT INTO `vote` (`id` ,`option_id` ,`player_id` ,`account_id`, `ip`) VALUES (NULL,  ".. tostring( option ) .. ", " .. tostring( player:getGuid() ) .. ", " .. tostring( player:getAccountId() ) .. ", " .. tostring( player:getIp() ) .. ");"
	
	if db.query( query ) then
		return true
	else
		return false
	end

	return false
end

local function vote( player, option )
	if not accountVoted( player ) and not ipVoted( player ) and not accountCreatedAfterBroadcast( player, reqCreationDate ) then
		if playerHasAppropriateLevel( player, reqLevel ) then
			print(player:getName() .. " (" .. player:getGuid() .. ") voted " .. tostring(option))
			if addRecord( player, option ) then
				playerMsg( player, "Glos na opcje numer " .. tostring( option ) .. " zapisany pomyslnie.")
				return true
			else
				--playerMsg( player, "Wystapil blad przy zapisywaniu Twojego glosu. Zglos to administracji, najlepiej wraz z godzina.")
				return false
			end			
		else
			--playerBroadcast( player, "Nie masz adekwatnego poziomu (50). Przeloguj sie na postac o wyzszym poziomie.") 
			return false
		end
	else
		--playerBroadcast(player, "Juz glosowales.")
		return false
	end
	
	return false
end

function onSay(player, words, param)
	local level = player:getLevel()
	
	
	local options = { 
		[1] = "Kompletny reset.",
		[2] = "Reset z zachowanymi outfitami i addonami",
		[3] = "Reset z zachowanymi outfitami, addonami i mountami"
	}
	
	-- doPlayerSendTextMessage(cid,MESSAGE_STATUS_CONSOLE_BLUE, "...")
	local split = param:split(" ")
	
	if split[1] == " " or split[1] == nil then
		playerMsg( player, "Glosowanie ws. resetu postaci - dostepne opcje: ")
		local msg = ""
		for k, v in ipairs( options ) do
			msg = "[" .. tostring(k) .. "] " .. tostring(v)
			playerMsg( player, msg )
		end
		playerMsg(player, "Glosowac mozesz za pomoca komendy /glosuj opcja, wiec np. /glosuj 1, /glosuj 2, /glosuj 3.")
		playerMsg(player, "Zaglosowac moze kazde konto, z postaci o poziomie 50 lub wyzszym, ktore zostalo utworzone przed 31 stycznia 2016.")
	else
		if tonumber(split[1])>0 and tonumber(split[1])<4 then
			if vote( player, tonumber(split[1]) ) then
				playerBroadcast(player, "Oddano glos na opcje " .. split[1] )
			else
				playerBroadcast( player, "Niestety, ale Twoje konto nie spelnia wymogow glosowania (wiecej informacji na czacie).")
			end
		else
			playerBroadcast( player, "Nie ma takiej opcji w glosowaniu.")
		end
	end
	
	return false
end
