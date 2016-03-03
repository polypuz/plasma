function onUse(cid, item, fromPosition, itemEx, toPosition)
	local queststatus = getPlayerStorageValue(cid,30016)
    if item.uid == 30201 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles Glacial Rod.")
         doPlayerAddItem(cid,18412,1) -- glacial rod
         setPlayerStorageValue(cid,30016,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 30202 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles Ornate Mace.")
         doPlayerAddItem(cid,15414,1) -- 15414 ornate mace
         setPlayerStorageValue(cid,30016,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 30203 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles Crystal Crossbow.")
         doPlayerAddItem(cid, 18453, 1) -- Crystal Crossbow
         setPlayerStorageValue(cid,30016,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
     elseif item.uid == 30204 then
       if queststatus == -1 then
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Znalazles... prezent!")
         local present = doPlayerAddItem(cid,1990,1)
		     doAddContainerItem( present, 2644, 1 )
         setPlayerStorageValue(cid,30016,1)
       else
         doPlayerSendTextMessage(cid,MESSAGE_INFO_DESCR, "Ta skrzynia jest pusta - juz dostales nagrode.")
       end
   end
     return 1
end
