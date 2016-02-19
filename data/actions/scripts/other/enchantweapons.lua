local spikeSwords = {2383, 7854, 7869, 7744, 7763} -- normal, earth, energy, fire, ice
local relicSwords = {7383, 7855, 7870, 7745, 7764} -- normal, earth, energy, fire, ice
local mysticBlades = {7384, 7856, 7871, 7746, 7765} -- normal, earth, energy, fire, ice
local blacksteelSwords = {7406, 7857, 7872, 7747, 7766} -- normal, earth, energy, fire, ice
local dragonSlayers = {7402, 7858, 7873, 7748, 7767} -- normal, earth, energy, fire, ice
local barbarianAxes = {2429, 7859, 7874, 7749, 7768} -- normal, earth, energy, fire, ice
local knightAxes = {2430, 7860, 7875, 7750, 7769} -- normal, earth, energy, fire, ice
local heroicAxes = {7389, 7861, 7876, 7751, 7770} -- normal, earth, energy, fire, ice
local headChoppers = {7380, 7862, 7877, 7752, 7771} -- normal, earth, energy, fire, ice
local warAxes = {2454, 7863, 7878, 7753, 7772} -- normal, earth, energy, fire, ice
local clericalMaces = {2423, 7864, 7879, 7754, 7773} -- normal, earth, energy, fire, ice
local crystalMaces = {2445, 7865, 7880, 7755, 7774} -- normal, earth, energy, fire, ice
local cranialBashers = {7415, 7866, 7881, 7756, 7775} -- normal, earth, energy, fire, ice
local orcishMauls = {7392, 7867, 7882, 7757, 7776} -- normal, earth, energy, fire, ice
local warHammers = {2391, 7868, 7883, 7758, 7777} -- normal, earth, energy, fire, ice

function onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Earth Enchants
    if item.itemid == 7761 then -- earth gem
        -- Earth Swords
        if isInArray(spikeSwords, itemEx.itemid) == TRUE then -- spike sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7854, 1000)
            return TRUE
        elseif isInArray(relicSwords, itemEx.itemid) == TRUE then -- relic sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7855, 1000)
            return TRUE
        elseif isInArray(mysticBlades, itemEx.itemid) == TRUE then -- mystic blade
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7856, 1000)
            return TRUE
        elseif isInArray(blacksteelSwords, itemEx.itemid) == TRUE then -- blacksteel sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7857, 1000)
            return TRUE
        elseif isInArray(dragonSlayers, itemEx.itemid) == TRUE then -- dragon slayer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7858, 1000)
            return TRUE
        -- Earth Axes    
        elseif isInArray(barbarianAxes, itemEx.itemid) == TRUE then -- barbarian axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7859, 1000)
            return TRUE
        elseif isInArray(knightAxes, itemEx.itemid) == TRUE then -- knight axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7860, 1000)
            return TRUE
        elseif isInArray(heroicAxes, itemEx.itemid) == TRUE then -- heroic axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7861, 1000)
            return TRUE
        elseif isInArray(headChoppers, itemEx.itemid) == TRUE then -- headchopper
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7862, 1000)
            return TRUE
        elseif isInArray(warAxes, itemEx.itemid) == TRUE then -- war axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7863, 1000)
            return TRUE
        -- Earth Clubs
        elseif isInArray(clericalMaces, itemEx.itemid) == TRUE then -- clerical mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7864, 1000)
            return TRUE
        elseif isInArray(crystalMaces, itemEx.itemid) == TRUE then -- crystal mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7865, 1000)
            return TRUE
        elseif isInArray(cranialBashers, itemEx.itemid) == TRUE then -- cranial basher
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7866, 1000)
            return TRUE
        elseif isInArray(orcishMauls, itemEx.itemid) == TRUE then -- orcish maul
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7867, 1000)
            return TRUE
        elseif isInArray(warHammers, itemEx.itemid) == TRUE then -- war hammer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7868, 1000)
            return TRUE
        end
    elseif item.itemid == 7762 then -- energy gem
        -- Energy Swords
        if isInArray(spikeSwords, itemEx.itemid) == TRUE then -- spike sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7869, 1000)
            return TRUE
        elseif isInArray(relicSwords, itemEx.itemid) == TRUE then -- relic sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7870, 1000)
            return TRUE
        elseif isInArray(mysticBlades, itemEx.itemid) == TRUE then -- mystic blade
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7871, 1000)
            return TRUE
        elseif isInArray(blacksteelSwords, itemEx.itemid) == TRUE then -- blacksteel sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7872, 1000)
            return TRUE
        elseif isInArray(dragonSlayers, itemEx.itemid) == TRUE then -- dragon slayer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7873, 1000)
            return TRUE
        -- Energy Axes    
        elseif isInArray(barbarianAxes, itemEx.itemid) == TRUE then -- barbarian axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7874, 1000)
            return TRUE
        elseif isInArray(knightAxes, itemEx.itemid) == TRUE then -- knight axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7875, 1000)
            return TRUE
        elseif isInArray(heroicAxes, itemEx.itemid) == TRUE then -- heroic axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7876, 1000)
            return TRUE
        elseif isInArray(headChoppers, itemEx.itemid) == TRUE then -- headchopper
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7877, 1000)
            return TRUE
        elseif isInArray(warAxes, itemEx.itemid) == TRUE then -- war axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7878, 1000)
            return TRUE
        -- Energy Clubs
        elseif isInArray(clericalMaces, itemEx.itemid) == TRUE then -- clerical mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7879, 1000)
            return TRUE
        elseif isInArray(crystalMaces, itemEx.itemid) == TRUE then -- crystal mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7880, 1000)
            return TRUE
        elseif isInArray(cranialBashers, itemEx.itemid) == TRUE then -- cranial basher
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7881, 1000)
            return TRUE
        elseif isInArray(orcishMauls, itemEx.itemid) == TRUE then -- orcish maul
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7882, 1000)
            return TRUE
        elseif isInArray(warHammers, itemEx.itemid) == TRUE then -- war hammer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7883, 1000)
            return TRUE
        end
    elseif item.itemid == 7760 then -- fire gem
        -- Energy Swords
        if isInArray(spikeSwords, itemEx.itemid) == TRUE then -- spike sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7744, 1000)
            return TRUE
        elseif isInArray(relicSwords, itemEx.itemid) == TRUE then -- relic sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7745, 1000)
            return TRUE
        elseif isInArray(mysticBlades, itemEx.itemid) == TRUE then -- mystic blade
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7746, 1000)
            return TRUE
        elseif isInArray(blacksteelSwords, itemEx.itemid) == TRUE then -- blacksteel sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7747, 1000)
            return TRUE
        elseif isInArray(dragonSlayers, itemEx.itemid) == TRUE then -- dragon slayer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7748, 1000)
            return TRUE
        -- Energy Axes    
        elseif isInArray(barbarianAxes, itemEx.itemid) == TRUE then -- barbarian axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7749, 1000)
            return TRUE
        elseif isInArray(knightAxes, itemEx.itemid) == TRUE then -- knight axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7750, 1000)
            return TRUE
        elseif isInArray(heroicAxes, itemEx.itemid) == TRUE then -- heroic axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7751, 1000)
            return TRUE
        elseif isInArray(headChoppers, itemEx.itemid) == TRUE then -- headchopper
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7752, 1000)
            return TRUE
        elseif isInArray(warAxes, itemEx.itemid) == TRUE then -- war axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7753, 1000)
            return TRUE
        -- Energy Clubs
        elseif isInArray(clericalMaces, itemEx.itemid) == TRUE then -- clerical mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7754, 1000)
            return TRUE
        elseif isInArray(crystalMaces, itemEx.itemid) == TRUE then -- crystal mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7755, 1000)
            return TRUE
        elseif isInArray(cranialBashers, itemEx.itemid) == TRUE then -- cranial basher
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7756, 1000)
            return TRUE
        elseif isInArray(orcishMauls, itemEx.itemid) == TRUE then -- orcish maul
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7757, 1000)
            return TRUE
        elseif isInArray(warHammers, itemEx.itemid) == TRUE then -- war hammer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7758, 1000)
            return TRUE
        end
    elseif item.itemid == 7759 then -- ice gem
        -- Ice Swords
        if isInArray(spikeSwords, itemEx.itemid) == TRUE then -- spike sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7763, 1000)
            return TRUE
        elseif isInArray(relicSwords, itemEx.itemid) == TRUE then -- relic sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7764, 1000)
            return TRUE
        elseif isInArray(mysticBlades, itemEx.itemid) == TRUE then -- mystic blade
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7765, 1000)
            return TRUE
        elseif isInArray(blacksteelSwords, itemEx.itemid) == TRUE then -- blacksteel sword
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7766, 1000)
            return TRUE
        elseif isInArray(dragonSlayers, itemEx.itemid) == TRUE then -- dragon slayer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7767, 1000)
            return TRUE
        -- Ice Axes    
        elseif isInArray(barbarianAxes, itemEx.itemid) == TRUE then -- barbarian axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7768, 1000)
            return TRUE
        elseif isInArray(knightAxes, itemEx.itemid) == TRUE then -- knight axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7769, 1000)
            return TRUE
        elseif isInArray(heroicAxes, itemEx.itemid) == TRUE then -- heroic axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7770, 1000)
            return TRUE
        elseif isInArray(headChoppers, itemEx.itemid) == TRUE then -- headchopper
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7771, 1000)
            return TRUE
        elseif isInArray(warAxes, itemEx.itemid) == TRUE then -- war axe
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7772, 1000)
            return TRUE
        -- Ice Clubs
        elseif isInArray(clericalMaces, itemEx.itemid) == TRUE then -- clerical mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7773, 1000)
            return TRUE
        elseif isInArray(crystalMaces, itemEx.itemid) == TRUE then -- crystal mace
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7774, 1000)
            return TRUE
        elseif isInArray(cranialBashers, itemEx.itemid) == TRUE then -- cranial basher
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7775, 1000)
            return TRUE
        elseif isInArray(orcishMauls, itemEx.itemid) == TRUE then -- orcish maul
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7776, 1000)
            return TRUE
        elseif isInArray(warHammers, itemEx.itemid) == TRUE then -- war hammer
            doRemoveItem(item.uid, 1)
            doRemoveItem(itemEx.uid, 1)
            doPlayerAddItem(cid, 7777, 1000)
            return TRUE
        end
    else
        doPlayerSendCancel(cid, "Sorry, not possible.")
    end
    return FALSE
end