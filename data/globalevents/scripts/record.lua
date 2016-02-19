function onRecord(current, old)
	addEvent(broadcastMessage, 150, "Nowy rekord: " .. current .. " graczy jest zalogowanych.", MESSAGE_STATUS_WARNING)
	return true
end
