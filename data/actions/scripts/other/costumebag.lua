local common = {"orc warrior", "pirate cutthroat", "dworc voodoomaster", "dwarf guard", "minotaur mage"}
local uncommon = {"quara hydromancer", "diabolical imp", "banshee", "frost giant", "lich"}
local deluxe = {"serpent spawn", "demon", "juggernaut", "behemoth", "rahemos"}
local duration = 18000 --the time the outfit will last
function onUse(cid, item, fromPosition, itemEx, toPosition)
        if item.itemid == 7737 then
                doSetMonsterOutfit(cid,common[math.random(#common)],duration*1000)
        elseif item.itemid == 9076 then
                doSetMonsterOutfit(cid,uncommon[math.random(#uncommon)],duration*1000)
        elseif item.itemid == 7739 then
                doSetMonsterOutfit(cid,deluxe[math.random(#deluxe)],duration*1000)
        end
        doRemoveItem(item.uid,1)
        doSendMagicEffect(fromPosition,CONST_ME_MAGIC_BLUE)
        return TRUE
end
