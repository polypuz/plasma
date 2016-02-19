function onUse(cid, item, fromPosition, itemEx, toPosition)
	local queststatus = getPlayerStorageValue(cid,30015)
    if item.uid == 30101 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles Demon Armor.")
         doPlayerAddItem(cid,2494,1)
         setPlayerStorageValue(cid,30015,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 30102 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles Magic Sword.")
         doPlayerAddItem(cid,2400,1)
         setPlayerStorageValue(cid,30015,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 30103 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles Stonecutter Axe.")
         doPlayerAddItem(cid,2431,1)
         setPlayerStorageValue(cid,30015,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
     end
     elseif item.uid == 30104 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles... prezent!")
         local present = doPlayerAddItem(cid,1990,1)
		 doAddContainerItem( present, 2326, 1 )
         setPlayerStorageValue(cid,30015,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
   end
     return 1
end