function onUse(cid, item, fromPosition, itemEx, toPosition)
	local r = ''	
	if getPlayerBlessing(cid, 5) then
		r = "Masz pelne blogoslawienstwo."
	end
	
	return doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, r == '' and 'Nie jestes poblogoslawiony.' or r)
end