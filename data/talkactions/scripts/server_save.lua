function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    broadcastMessage("Zapisywanie stanu gry...", MESSAGE_EVENT_ADVANCE)
    saveServer()

    return false
end
