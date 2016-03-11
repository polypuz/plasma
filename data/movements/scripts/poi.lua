local function getConqueredThrones(player, thrones)
  local thrones_conquered = 0

  for indx, storageKey in ipairs( thrones ) do
    if player:getStorageValue( storageKey ) ~= -1 then
      thrones_conquered = thrones_conquered + 1
    end
  end

  return thrones_conquered
end

local function getThronesLeft(player, thrones)
  local thrones_left = #thrones -- #thrones returns number of elements in array

  for indx, storageKey in ipairs( thrones ) do
    if player:getStorageValue( storageKey ) ~= -1 then
      thrones_left = thrones_left -1
    end
  end

  return thrones_left
end

local function teleportBack(cid, position)
  doTeleportThing(cid, position)
  return true
end

function onStepIn(cid, item, position, fromPosition)
  local player = Player(cid) -- action id used is 37000
  local thrones = { 37001, 37002, 37003, 37004, 37005, 37006, 37007 }
  if isInArray(thrones, item.uid) then -- is it a throne?
    if player:getStorageValue( item.uid ) >= 1 then
      -- you already have conquered this throne
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 'Juz przejales ten tron, pozostalo jeszcze ' .. getThronesLeft(player, thrones) .. '.')
    else
      player:setStorageValue(item.uid, 1)
      -- conquered the throne
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 'Tron zostal przejety. Pozostalo Ci ' .. getThronesLeft( player, thrones ) .. ' tronow.')
    end
  else -- its a gate!
    if getConqueredThrones(player, thrones) == 7 then
      -- ok, go on.
    else
      local string = ""
      local conqueredThrones = getConqueredThrones( player, thrones )

      if conqueredThrones == 0 then
        string = "Nie przejales zadnego z " .. #thrones .. " tronow. Nie jestes godzien, aby przejsc dalej."
      elseif conqueredThrones == 1 then
        string = "Masz przejety 1 z " .. #thrones .. " tronow. Musisz przejac pozostale " .. getThronesLeft(player, thrones) .. " aby przejsc dalej."
      else
        local plural = ""
        if conqueredThrones < 5 then
          plural = "trony"
        else
          plural = "tronow"
        end
        string = "Masz przejete " .. conqueredThrones .. " " .. plural .. ". Musisz przejac pozostale " .. getThronesLeft(player, thrones) .. " aby przejsc."
      end

      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, string)

      teleportBack(cid, fromPosition)
      return false
    end
  end

	return true
end
