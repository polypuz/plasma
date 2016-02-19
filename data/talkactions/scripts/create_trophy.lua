function createTrophy(player, type, descr)
	-- b = bronze = id 7371
	-- s = silver = id 7370
	-- g = golden = id 7369
	if type == "b" then
		type = 7371
	elseif type == "s" then
		type = 7370
	elseif type == "g" then
		type = 7369
	else
		type = nil
	end
	
	if descr == nil then
		descr = ""
	end
	
	if type >= 7369 and type <= 7371 then
		if player:addItem( type, 1, false, 1):setAttribute( ITEM_ATTRIBUTE_DESCRIPTION, descr) then
			return true
		else
			return false
		end
	end	
	return false
end

function onSay(player, words, param)
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		player:sendCancelMessage("Ic stont trolu.")
		return false
	else
		local params = param:split(",")
		local type = params[1]
		local descr = params[2]
		if type == nil or type == " " or type == "" then
			player:sendCancelMessage("Nie podano typu trofeum (b - brazowe, s - srebrne, g - zlote)")
			return false
		else
			if type == "b" or type == "g" or type == "s" then
				if createTrophy(player, type, descr) then
					return true
				else
					player:sendCancelMessage("Cos poszlo nie tak.")
					return false
				end
			else
				player:sendCancelMessage("Nie rozpoznano typu trofeum (b/s/g - braz, srebro, zloto)")
				return false
			end
		end
	end
	return false
end
