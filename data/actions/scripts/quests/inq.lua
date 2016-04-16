--
-- Created by IntelliJ IDEA.
-- User: marahin
-- Date: 31.03.16
-- Time: 00:56
-- To change this template use File | Settings | File Templates.
--


function onUse(cid, item, fromPosition, itemEx, toPosition)
  -- uniqueid is the mission segment of Henryk's INQ
  -- 38002 means 2nd mission segment.
  --
  -- +10 to the storageValue is the storageKey for
  -- storing if the user has already picked up the reward / item
  -- ex. 38002 mission --> 38012 storageKey for the chest.

  if item.uid == 38002 then
    if Player(cid):getStorageValue(38012) ~= -1 then
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Ksiegi nie ma - musiales juz ja podniesc.")
      return false
    else
      if doPlayerAddItem(cid, 8702, 1) then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Znalazles ksiege magii, nalezaca do lokalnych wiedzm.")
        Player(cid):setStorageValue(38012, 1)
      else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Cos poszlo nie tak. Zglos to administracji.")
        return false
      end
    end
  end
  return true
end
