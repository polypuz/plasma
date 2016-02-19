function doCreatureSayWithDistance(cid, position, text, type) 
    --oldPosX = setPlayerStorageValue(cid, 10000, getCreaturePosition(cid).x) 
    --oldPosY = setPlayerStorageValue(cid, 10001, getCreaturePosition(cid).y) 
    --oldPosZ = setPlayerStorageValue(cid, 10002, getCreaturePosition(cid).z) 
    --oldPos = { x = getPlayerStorageValue(cid, 10000), y = getPlayerStorageValue(cid, 10001), z = getPlayerStorageValue(cid, 10002) } 
    --doTeleportThing(cid, position, 0) 
    doCreatureSay(cid, text, type) 
    --return doTeleportThing(cid, oldPos, 0) 
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
countSound = math.random(1,5)
    if fromPosition.x then
        if countSound == 1 then
            doCreatureSayWithDistance(cid, fromPosition, "Fchhhhhh!", TALKTYPE_ORANGE_1)
        elseif countSound == 2 then
            doCreatureSayWithDistance(cid, fromPosition, "Zchhhhhh!", TALKTYPE_ORANGE_1)
        elseif countSound == 3 then
            doCreatureSayWithDistance(cid, fromPosition, "Grooaaaaar *achu, achu*", TALKTYPE_ORANGE_1)
        elseif countSound == 4 then
            doCreatureSayWithDistance(cid, fromPosition, "Aaa... psik!", TALKTYPE_ORANGE_1)
        elseif countSound == 5 then
            doCreatureSayWithDistance(cid, fromPosition, "Zaraz... splooniesz!", TALKTYPE_ORANGE_1)
        end
    end
return TRUE
end  