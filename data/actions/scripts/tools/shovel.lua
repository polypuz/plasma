local holes = {468, 481, 483}
local correct_graves = {23031 ,23037, 23042, 23045, 23055}
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x == CONTAINER_POSITION then
		return false
	end

	local tile = Tile(toPosition)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if not ground then
		return false
	end

	local groundId = ground:getId()
	if isInArray(holes, groundId) then
		ground:transform(groundId + 1)
		ground:decay()

		toPosition.z = toPosition.z + 1
		tile:relocateTo(toPosition)
	elseif groundId == 231 then
		local randomValue = math.random(1, 100)
		if randomValue == 1 then
			Game.createItem(2159, 1, toPosition)
		elseif randomValue > 95 then
			Game.createMonster("Scarab", toPosition)
		end
      ------ czesc do questa z podwodnym miastem
        ------ jak uzyty na grobie i id grobu miedzy 23030 i 23058 i aktywowany klest
	elseif target.itemid == 1406 and target:getUniqueId() > 23030 and target:getUniqueId() < 23058 and cid:getStorageValue(23030) > 0 then
    if isInArray(correct_graves,target:getUniqueId()) and cid:getStorageValue(target:getUniqueId()) < 1 then -- jesli zawiera sie w tych prawidlowych grobach
      cid:setStorageValue(target:getUniqueId(), 1)
      doCreatureSay(cid, '*aaaaaaaaaoooooouoouo* - to chyba dzwiek uciekajacych duszy', TALKTYPE_ORANGE_1)
      CheckIfAllGhostsGone(cid)
    else -- jesli nie jeden z dobrych grobow 
      if math.random() < 0.2 then
        Game.createMonster("Feversleep",toPosition) -- spawn feversleepa
      end
      if math.random() < 0.2 then
        Game.createMonster("Terrorsleep",toPosition) -- spawn terrorSleepa
      end
    end
	end   
		toPosition:sendMagicEffect(CONST_ME_POFF)
	else
		return false
	end

	return true
end
