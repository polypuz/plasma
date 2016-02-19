--[[local effect_broke = 3
local effect_renew = 28
local wylosowany = 0
local itemy = {
    [9808] = {
        [1] = {id = 2464, name = "Chain Armor", szansa = 33},
        [2] = {id = 2483, name = "Scale Armor", szansa = 25},
        [3] = {id = 2465, name = "Brass Armor", szansa = 10},
        [4] = {id = 2463, name = "Plate Armor", szansa = 2}
    },
    [9809] = {
        [1] = {id = 2464, name = "Chain Armor", szansa = 16},
        [2] = {id = 2465, name = "Brass Armor", szansa = 14},
        [3] = {id = 2483, name = "Scale Armor", szansa = 13},
        [4] = {id = 2463, name = "Plate Armor", szansa = 10},
        [5] = {id = 2476, name = "Knight Armor", szansa = 6},
        [6] = {id = 8891, name = "Paladin Armor", szansa = 3},
        [7] = {id = 2487, name = "Crown Armor", szansa = 1}
    },
    [9810] = {
        [1] = {id = 2464, name = "Chain Armor", szansa = 20},
        [2] = {id = 2465, name = "Brass Armor", szansa = 17},
        [3] = {id = 2483, name = "Scale Armor", szansa = 15},
        [4] = {id = 2463, name = "Plate Armor", szansa = 12},
        [5] = {id = 2476, name = "Knight Armor", szansa = 10},
        [6] = {id = 8891, name = "Paladin Armor", szansa = 5},
        [7] = {id = 2487, name = "Crown Armor", szansa = 4},
        [8] = {id = 2466, name = "Golden Armor", szansa = 2},
        [9] = {id = 2472, name = "Magic Plate Armor", szansa = 1}
    },
    [9811] = {
        [1] = {id = 2468, name = "Studded Legs", szansa = 33},
        [2] = {id = 2648, name = "Chain Legs", szansa = 25},
        [3] = {id = 2478, name = "Brass Legs", szansa = 10},
        [4] = {id = 2647, name = "Plate Legs", szansa = 2}
    },
    [9812] = {
        [1] = {id = 2468, name = "Studded Legs", szansa = 16},
        [2] = {id = 2648, name = "Chain Legs", szansa = 14},
        [3] = {id = 2478, name = "Brass Legs", szansa = 13},
        [4] = {id = 2647, name = "Plate Legs", szansa = 10},
        [5] = {id = 2477, name = "Knight Legs", szansa = 6},
        [7] = {id = 2488, name = "Crown Legs", szansa = 1}
    },
    [9813] = {
        [2] = {id = 2478, name = "Brass Legs", szansa = 17},
        [4] = {id = 2647, name = "Plate Legs", szansa = 12},
        [5] = {id = 2477, name = "Knight Legs", szansa = 10},
        [7] = {id = 2488, name = "Crown Legs", szansa = 4},
        [8] = {id = 2470, name = "Golden Legs", szansa = 2}
    }
}

function onUse(cid, item, frompos, item2, topos)

    local const = item2.itemid
    local pos = getCreaturePosition(cid)

    if itemy[const] then
        local random_item = math.random(1, 100)
       
        for i = 1, #itemy[const] do
            if random_item <= itemy[const][i].szansa then -- this is where the problem was, [i] was missing
                wylosowany = i
            end
        end

        if wylosowany > 0 then
            doSendMagicEffect(topos, effect_renew)
            doTransformItem(item2.uid, itemy[const][wylosowany].id)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Udalo Ci sie oczyscic ".. itemy[const][wylosowany].name .."!")
            doRemoveItem(item.uid, 1)
        else
            doSendMagicEffect(topos, effect_broke)
            doRemoveItem(item2.uid, 1)
            doRemoveItem(item.uid, 1)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Twoj Rusty Remover sie zniszczyl.")
            return false
        end
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Mozesz uzyc tego przedmiotu tylko na zardzewionych zbrojach lub nagolennikach.")
        return false
    end
    return true
end]]

function onUse(cid, item, frompos, item2, topos)
    local effect_renew = 28
    local effect_broke = 3
    local storage = 0
    local const = item2.itemid
    local pos = getCreaturePosition(cid)
    local itemy = {
                    [9808] = {
                                [1] = {id = 2464, name = "Chain Armor", chance = 6966},
                                [2] = {id = 2483, name = "Scale Armor", chance = 3952},
                                [3] = {id = 2465, name = "Brass Armor", chance = 1502},
                                [4] = {id = 2463, name = "Plate Armor", chance = 197}
                            },
                           
                    [9809] = {
                                [1] = {id = 2483, name = "Scale Armor", chance = 6437},                   
                                [2] = {id = 2464, name = "Chain Armor", chance = 4606},
                                [3] = {id = 2465, name = "Brass Armor", chance = 3029},
                                [4] = {id = 2463, name = "Plate Armor", chance = 1559},
                                [5] = {id = 2476, name = "Knight Armor", chance = 595},
                                [6] = {id = 8891, name = "Paladin Armor", chance = 283},
                                [7] = {id = 2487, name = "Crown Armor", chance = 49}
                            },
                           
                    [9810] = {
                                [1] = {id = 2465, name = "Brass Armor", chance = 6681},
                                [2] = {id = 2463, name = "Plate Armor", chance = 3767},
                                [3] = {id = 2476, name = "Knight Armor", chance = 1832},
                                [4] = {id = 2487, name = "Crown Armor", chance = 177},
                                [5] = {id = 8891, name = "Paladin Armor", chance = 31},
                                [6] = {id = 2466, name = "Golden Armor", chance = 10}
                            },
                           
                    [9811] = {
                                [1] = {id = 2648, name = "Chain Legs", chance = 6949},                   
                                [2] = {id = 2468, name = "Studded Legs", chance = 3692},
                                [3] = {id = 2478, name = "Brass Legs", chance = 1307},
                                [4] = {id = 2647, name = "Plate Legs", chance = 133}
                            },
                           
                    [9812] = {
                                [1] = {id = 2468, name = "Studded Legs", chance = 5962},
                                [2] = {id = 2648, name = "Chain Legs", chance = 4037},
                                [3] = {id = 2478, name = "Brass Legs", chance = 2174},
                                [4] = {id = 2647, name = "Plate Legs", chance = 1242},
                                [5] = {id = 2477, name = "Knight Legs", chance = 186},
                            },
                           
                    [9813] = {
                                [1] = {id = 2478, name = "Brass Legs", chance = 6500},
                                [2] = {id = 2647, name = "Plate Legs", chance = 3800},
                                [3] = {id = 2477, name = "Knight Legs", chance = 200},
                                [4] = {id = 2488, name = "Crown Legs", chance = 52},
                                [5] = {id = 2470, name = "Golden Legs", chance = 30}
                            }
                } 

                local random_item = math.random(10000)
    if itemy[const] then
        for i = 1, #itemy[const] do
            if random_item <= itemy[const][i].chance then
                storage = i
            end
        end  
       
        if storage > 0 then
            doSendMagicEffect(topos, effect_renew)
            doTransformItem(item2.uid, itemy[const][storage].id)
            doCreatureSay(cid, "Udalo Ci sie oczyscic ".. itemy[const][storage].name .." !", TALKTYPE_ORANGE_1)
            doRemoveItem(item.uid, 1)
        else
            doSendMagicEffect(topos, effect_broke)
            doRemoveItem(item2.uid, 1)
            doRemoveItem(item.uid, 1)
            doCreatureSay(cid, "Zbroja byla tak zniszczona, ze nie udalo Ci sie jej odratowac - rozpadla sie podczas czyszczenia.", TALKTYPE_ORANGE_1)
            return 0
        end
    else
        return 0
    end
return true
end
