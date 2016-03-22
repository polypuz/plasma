local unique_reward_storage_key = {37011, 37012, 37013}
local generic_reward_storage_key = {37014, 37015, 37016, 37017, 37018}

local function addItem(cid, id, amount, message)
  if doPlayerAddItem(cid,id,amount) then
    doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, message)
    return true
  else
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Cos poszlo nie tak. Zglos to administracji.")
    return false
  end

  return true
end

local function rewardPlayer(cid, uniqueid)
  local itemid = nil
  local amount = nil
  local message = nil

  if Player(cid):getStorageValue(uniqueid) ~= -1 then -- player has got the reward already
    doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Juz otrzymales nagrode.")
    return false
  else
    -- unique rewards (only one can be taken)
    if isInArray(unique_reward_storage_key, uniqueid) then
      for indx, storageKey in ipairs(unique_reward_storage_key) do
        Player(cid):setStorageValue(storageKey, 1) -- set all the values of unique rewards to 1
      end
      if uniqueid == 37011 then
        itemid = 2453
        amount = 1
        message = "Znalazles Arcane Staff."
      elseif uniqueid == 37012 then
        itemid = 6528
        amount = 1
        message = "Znalazles Avenger."
      elseif uniqueid == 37013 then
        itemid = 5803
        amount = 1
        message = "Znalazles Arbalest."
      end
    else
      -- generic rewards - every and each of one can be taken
      if uniqueid == 37014 then
        itemid = 6132
        amount = 1
        message = "Znalazles Pair of Soft Boots."
      elseif uniqueid == 37015 then
        itemid = 5791
        amount = 1
        message = "Znalazles pluszowego smoka."
      elseif uniqueid == 37016 then
        itemid = 2361
        amount = 1
        message = "Znalazles Frozen Starlight."
      elseif uniqueid == 37017 then
        itemid = 2152
        amount = 100
        message = "Znalazles 100 srebrnych monet."
      elseif uniqueid == 37018 then
        itemid = 2365
        amount = 1
        message = "Znalazles Backpack of Holding."
      end
      Player(cid):setStorageValue(uniqueid, 1)
    end
    addItem(cid, itemid, amount, message)
  end
  return true
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
  if rewardPlayer( cid, item.uid ) then
    return true
  else
    return false
  end
end
