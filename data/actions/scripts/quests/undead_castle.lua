function onUse( cid, item, fromPosition, itemEx, toPosition )
	local storageKey = 21370
	local chest_pairs = { 
		{ uid = 21371, item = 8903 },
		{ uid = 21372, item = 8855 },
		{ uid = 21373, item = 8889 }
	}
	local queststatus = getPlayerStorageValue(cid, storageKey)
    if item.uid == 21371 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles przedmiot!")
         doPlayerAddItem(cid,8903,1)
         setPlayerStorageValue(cid,21370,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 21372 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles przedmiot!")
         doPlayerAddItem(cid,8855,1)
         setPlayerStorageValue(cid,21370,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 21373 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles przedmiot!")
         doPlayerAddItem(cid,8889,1)
         setPlayerStorageValue(cid,21370,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
	   end
	end
     return 1
end
