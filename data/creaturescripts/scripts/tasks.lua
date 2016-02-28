local config = {
    --[[
    ['monster_name'] = { amount (of monsters killed), storage (we store amount killed), storage key (describing whether we started the task or not), startvalue (value to check if we started the task))}
    ]]

    --[[ bolec na boku task ]]
  ['vampire'] = {amount = 100, storage = 19000, startstorage = 5000, startvalue = 1}
    --[[ end of bolec na boku task ]]
}

function onKill(player, target)
  local monster = config[target:getName():lower()]
  if target:isPlayer() or not monster or target:getMaster() then
    return true
  end
  local stor = player:getStorageValue(monster.storage)+1
  if stor < monster.amount and player:getStorageValue(monster.startstorage) >= monster.startvalue then
    if ( stor == (0) or stor == (-1) ) then
      stor = 1
    end

    player:setStorageValue(monster.storage, stor)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Zadanie: pozostalo '..(monster.amount - (stor)) .. ' ' .. target:getName() .. ' do zabicia.')
  elseif stor >= monster.amount then
    --player:sendTextMessage(MESSAGE_INFO_DESCR, 'Congratulations, you have killed '..(stor +1)..' '..target:getName()..'s and completed the '..target:getName()..'s mission.')
    player:sendTextMessage(MESSAGE_INFO_DESCR, 'Gratulacje, udalo Ci sie zabic ' .. (stor) .. ' ' .. target:getName() .. ' i ukonczyc zadanie.')
    player:setStorageValue(monster.storage, stor +1)
    player:setStorageValue(monster.startstorage, 2)
  end
  return true
end
