local genericItems = { 1988, 2200, 2512, 2643, 2478, 2465, 2460, 2674, 2428, 2417, 2383, 2182, 2190, 2050, 2120  }
function onLogin(player)
	if player:getLastLoginSaved() == 0 then
		for i = 1, #genericItems do
			player:addItem(genericItems[i], 1)
		end
		
		player:addItem(7620, 10) 
		player:addItem(7618, 10)
		player:addItem(2152, 1) 
		player:addItem(2389, 4) 
		
	end
	return true
end
