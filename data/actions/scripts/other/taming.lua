--[[
   The 'CHANCE' values that I'm not sure about have been defaulted to 40%
   TODO: Get real FAIL_MSG and SUCCESS_MSG for some of the tammings
   Info:
     [xxxxx]     = tamming itemid
     NAME       = name of the creature tamming item is used on
     ID         = mount id for storage (check out data/XML/mounts.xml)
     TYPE       = type of creature taming item is used on (TYPE_MONSTER/TYPE_NPC/TYPE_ACTION/TYPE_UNIQUE)
     CHANCE       = X/100%
     FAIL_MSG     = { {action (ACTION_RUN/ACTION_BREAK/ACTION_NONE/ACTION_ALL), "message"} }
     SUCCESS_MSG  = "message"

local ACTION_RUN, ACTION_BREAK, ACTION_NONE, ACTION_ALL = 1, 2, 3, 4
local TYPE_MONSTER, TYPE_NPC, TYPE_ACTION, TYPE_UNIQUE = 1, 2, 3, 4
local config = {
   [5907] =    {NAME = 'Bear',          ID = 3,    TYPE = TYPE_MONSTER,    CHANCE = 20,    FAIL_MSG = { {1, "The bear ran away."}, {2, "Oh no! The slingshot broke."}, {3, "The bear is trying to hit you with its claws."} }, SUCCESS_MSG = "You tamed the bear."},
   [8301] =    {NAME = 'Lightbringer',      ID = 9,    TYPE = TYPE_MONSTER,    CHANCE = 70,    FAIL_MSG = { {1, "After pouring dust over the Lightbringer, it disappeared."}, {2, "You used entire dust, but it had no effect."}, {3, "The Lightbringer was confused for a while, but nothing happend."} }, SUCCESS_MSG = "The Lightbringer decided to follow you in your adventure."},
   [13295] =    {NAME = 'Black Sheep',        ID = 4,    TYPE = TYPE_MONSTER,    CHANCE = 25,    FAIL_MSG = { {1, "The black sheep ran away."}, {2, "Oh no! The reins were torn."}, {3, "The black sheep is trying to run away."} }, SUCCESS_MSG = "You tamed the sheep."},
   [13293] =    {NAME = 'Midnight Panther',    ID = 5,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The panther has escaped."}, {2, "The whip broke."} }, SUCCESS_MSG = "You tamed the panther."},
   [13298] =    {NAME = 'Terror Bird',        ID = 2,    TYPE = TYPE_MONSTER,    CHANCE = 15,    FAIL_MSG = { {1, "The bird ran away."}, {3, "The terror bird is pecking you."} }, SUCCESS_MSG = "You tamed the bird."},
   [13247] =    {NAME = 'Boar',          ID = 10,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The boar ran away."}, {3, "The boar attacks you."} }, SUCCESS_MSG = "You tamed the boar."},
   [13305] =    {NAME = 'Crustacea Gigantica',    ID = 7,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The crustacea ran away."}, {2, "The crustacea ate the shrimp."} }, SUCCESS_MSG = "You tamed the crustacea."},
   [13291] =    {NAME = 'Undead Cavebear',      ID = 12,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The undead bear ran away."} }, SUCCESS_MSG = "You tamed the skeleton."},
   [13307] =    {NAME = 'Wailing Widow',      ID = 1,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The widow ran away."}, {2, "The widow has eaten the sweet bait."} }, SUCCESS_MSG = "You tamed the widow."},
   [13292] =    {NAME = 'Tin Lizzard',        ID = 8,    TYPE = TYPE_NPC,      CHANCE = 40,    FAIL_MSG = { {2, "The key broke inside."} }, SUCCESS_MSG = "You have started the Tin Lizzard!"},
   [13294] =    {NAME = 'Draptor',          ID = 6,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The draptor ran away."}, {3, "The draptor has fled."} }, SUCCESS_MSG = "You tamed the draptor."},
   [13536] =    {NAME = 'Crystal Wolf',      ID = 16,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The wolf ran away."} }, SUCCESS_MSG = "You tamed the wolf."},
   [13539] =    {NAME = 'White Deer',        ID = 18,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {2, "The cone broke."}, {3, "The deer has fled in fear."} }, SUCCESS_MSG = "You tamed the deer."},
   [13538] =    {NAME = 'Panda',          ID = 19,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {4, "Panda ate the leaves and ran away."} }, SUCCESS_MSG = "You tamed the panda."},
   [13535] =    {NAME = 'Dromedary',        ID = 20,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Dromedary ran away."} }, SUCCESS_MSG = "You tamed the dromedary."},
   [13498] =    {NAME = 'Sandstone Scorpion',      ID = 21,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The scorpion has vanished."}, {2, "Scorpion broken the sceptre."} }, SUCCESS_MSG = "You tamed the scorpion"},
   [13537] =    {NAME = 'Donkey',          ID = 13,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The witch has escaped!"} }, SUCCESS_MSG = "You tamed the mule."},
   [13938] =    {NAME = 'Uniwheel',        ID = 15,    TYPE = TYPE_NPC,      CHANCE = 40,    FAIL_MSG = { {2, "The oil is having no effect."} }, SUCCESS_MSG = "You have found an Uniwheel."},
   [13508] =    {NAME = 'Slug',          ID = 14,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The slug ran away."}, {3, "The drug had no effect."} }, SUCCESS_MSG = "You tamed the slug."},
   [13939] =    {NAME = 'War Horse',        ID = 23,    TYPE = TYPE_MONSTER,    CHANCE = 15,    FAIL_MSG = { {1, "The horse runs away."}, {2, "The horse ate the oats."} }, SUCCESS_MSG = "You tamed the horse."},
   [15545] = {NAME = 'Manta Ray',        ID = 28,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The manta ray fled."}, {3, "The manta ray is trying to escape."} }, SUCCESS_MSG = "You tamed the manta ray."},
   [15546] = {NAME = 'Ladybug',          ID = 27,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The ladybug got scared and ran away."}, {3, "The ladybug is trying to nibble."} }, SUCCESS_MSG = "You tamed a ladybug."},
   [18447] = {NAME = 'Ironblight',          ID = 29,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The ironblight ran away."} }, SUCCESS_MSG = "You tamed the ironblight."},
   [18448] = {NAME = 'Magma Crawler',          ID = 30,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The magma crawler ran away."} }, SUCCESS_MSG = "You tamed the magma crawler."},
   [18449] = {NAME = 'Dragonling',          ID = 31,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The dragonling ran away."} }, SUCCESS_MSG = "You tamed the dragonling."},
   [18516] = {NAME = 'Gnarlhound',          ID = 32,    TYPE = TYPE_MONSTER,    CHANCE = 90,    FAIL_MSG = { {2, "The wrench broke."} }, SUCCESS_MSG = "You tamed the modified gnarlhound."},
   [20138] = {NAME = 'Water Buffalo',          ID = 35,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The water buffalo flees."}, {2, "The leech slipped through your fingers and is now following the call of nature."}, {3, "The water buffalo ignores you."} }, SUCCESS_MSG = "The leech appeased the water buffalo and your taming was successful."},
   [21452] = {NAME = 'Gravedigger',          ID = 39,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {2, "The gravedigger destroyed your case."}, {3, "The gravedigger avoided your nails."} }, SUCCESS_MSG = "You caught the gravedigger."}
}
local function doFailAction(cid, mount, pos, item, itemEx)
   local action, effect = mount.FAIL_MSG[math.random(1, table.maxn(mount.FAIL_MSG))], CONST_ME_POFF
   if(action[1] == ACTION_RUN) then
     doRemoveCreature(itemEx.uid)
   elseif(action[1] == ACTION_BREAK) then
     effect = CONST_ME_BLOCKHIT
     doRemoveItem(item.uid, 1)
   elseif(action[1] == ACTION_ALL) then
     doRemoveCreature(itemEx.uid)
     doRemoveItem(item.uid, 1)
   end
   doSendMagicEffect(pos, effect)
   doCreatureSay(cid, action[2], TALKTYPE_MONSTER_SAY)
   return action
end
function onUse(cid, item, fromPosition, itemEx, toPosition)
   local mount = config[item.itemid]
   if(mount == nil or getPlayerMount(cid, mount.ID)) then
     return false
   end
   local rand = math.random(1, 100)
   --Monster Mount
   if(isMonster(itemEx.uid) and not isSummon(itemEx.uid) and mount.TYPE == TYPE_MONSTER) then
     if(mount.NAME == getCreatureName(itemEx.uid)) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doRemoveCreature(itemEx.uid)
       doSendMagicEffect(toPosition, CONST_ME_POFF)
       doRemoveItem(item.uid, 1)
       return true
     end
   --NPC Mount
   elseif(isNpc(itemEx.uid) and mount.TYPE == TYPE_NPC) then
     if(mount.NAME == getCreatureName(itemEx.uid)) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
       doRemoveItem(item.uid, 1)
       return true
     end
   --Action Mount
   elseif(itemEx.actionid > 0 and mount.TYPE == TYPE_ACTION) then
     if(mount.NAME == itemEx.actionid) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
       doRemoveItem(item.uid, 1)
       return true
     end
   --Unique Mount
   elseif(itemEx.uid <= 65535 and mount.TYPE == TYPE_UNIQUE) then
     if(mount.NAME == itemEx.uid) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
       doRemoveItem(item.uid, 1)
       return true
     end
   end
   return false
end
]]

--[[
   The 'CHANCE' values that I'm not sure about have been defaulted to 40%
   TODO: Get real FAIL_MSG and SUCCESS_MSG for some of the tammings
   Info:
     [xxxxx]     = tamming itemid
     NAME       = name of the creature tamming item is used on
     ID         = mount id for storage (check out data/XML/mounts.xml)
     TYPE       = type of creature taming item is used on (TYPE_MONSTER/TYPE_NPC/TYPE_ACTION/TYPE_UNIQUE)
     CHANCE       = X/100%
     FAIL_MSG     = { {action (ACTION_RUN/ACTION_BREAK/ACTION_NONE/ACTION_ALL), "message"} }
     SUCCESS_MSG  = "message"
]]
local ACTION_RUN, ACTION_BREAK, ACTION_NONE, ACTION_ALL = 1, 2, 3, 4
local TYPE_MONSTER, TYPE_NPC, TYPE_ACTION, TYPE_UNIQUE = 1, 2, 3, 4
local config = {
   [5907] =    {NAME = 'Bear',          ID = 3,    TYPE = TYPE_MONSTER,    CHANCE = 20,    FAIL_MSG = { {1, "Niedzwiedz uciekl!"}, {2, "O nie! Zniszczyles swojego slingshota!"}, {3, "Niedzwiedz probuje uderzyc cie swoimi lapami."} }, SUCCESS_MSG = "Oswoiles niedzwiedzia."},
   [8301] =    {NAME = 'Lightbringer',      ID = 9,    TYPE = TYPE_MONSTER,    CHANCE = 70,    FAIL_MSG = { {1, "Po posypaniu pylem Lightbringera, stwor zniknal."}, {2, "Uzyles proszku, ale bez zadnego rezultatu."}, {3, "Lightbringer na chwile sie zacial, ale juz dziala. Bialek psuje."} }, SUCCESS_MSG = "Lightbringer zdecydowal sie podrozowac razem z Toba.."},
   [13295] =    {NAME = 'Black Sheep',        ID = 4,    TYPE = TYPE_MONSTER,    CHANCE = 25,    FAIL_MSG = { {1, "Owca uciekla..."}, {2, "O nie! Lejce sie popsuly!."}, {3, "Owca ucieka!"} }, SUCCESS_MSG = "Oswoiles owce."},
   [13293] =    {NAME = 'Midnight Panther',    ID = 5,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Pantera uciekla."}, {2, "Bat sie zniszczyl."} }, SUCCESS_MSG = "Oswoiles pantere."},
   [13298] =    {NAME = 'Terror Bird',        ID = 2,    TYPE = TYPE_MONSTER,    CHANCE = 15,    FAIL_MSG = { {1, "Ptak uciekl."}, {3, "Ptak zaczal cie dziobac."} }, SUCCESS_MSG = "Oswoiles ptaka."},
   [13247] =    {NAME = 'Boar',          ID = 10,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Dzik uciekl."}, {3, "Dzik zaczal cie atakowac."} }, SUCCESS_MSG = "Oswoiles dzika."},
   [13305] =    {NAME = 'Crustacea Gigantica',    ID = 7,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Skorupiak uciekl."}, {2, "Skorupiak zjadl krewetke."} }, SUCCESS_MSG = "Oswoiles skorupiaka."},
   [13291] =    {NAME = 'Undead Cavebear',      ID = 12,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Nieumarly niedzwiedz uciekl."} }, SUCCESS_MSG = "Oswoiles go!"},
   [13307] =    {NAME = 'Wailing Widow',      ID = 1,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Wdowa uciekla."}, {2, "Wdowa zjadla twoja zarzutke."} }, SUCCESS_MSG = "Oswoiles wdowe."},
   [13292] =    {NAME = 'Tin Lizzard',        ID = 8,    TYPE = TYPE_NPC,      CHANCE = 40,    FAIL_MSG = { {2, "Klucz sie zniszczyl."} }, SUCCESS_MSG = "Oswoiles go!"},
   [13294] =    {NAME = 'Draptor',          ID = 6,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Draptor ucieka."}, {3, "Draptor czmychnal!"} }, SUCCESS_MSG = "Oswoiles Draptora."},
   [13536] =    {NAME = 'Crystal Wolf',      ID = 16,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Wilk ucieka."} }, SUCCESS_MSG = "Oswoiles wilka."},
   [13539] =    {NAME = 'White Deer',        ID = 18,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {2, "Szyszka byla do nieczego..."}, {3, "Sarna uciekla ze stracuh."} }, SUCCESS_MSG = "Oswoiles sarne."},
   [13538] =    {NAME = 'Panda',          ID = 19,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {4, "Panda zjadla liscie i uciekla."} }, SUCCESS_MSG = "Oswoiles pande."},
   [13535] =    {NAME = 'Dromedary',        ID = 20,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Dromader uciekl."} }, SUCCESS_MSG = "Oswoiles dromadera."},
   [13498] =    {NAME = 'Sandstone Scorpion',      ID = 21,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Skorpion uciekl."}, {2, "Skorpion zniszczyl berlo."} }, SUCCESS_MSG = "Oswoiles skorpiona"},
   [13537] =    {NAME = 'Donkey',          ID = 13,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Osiolek uciekl!"} }, SUCCESS_MSG = "Oswoiles osiolka!"},
   [13938] =    {NAME = 'Uniwheel',        ID = 15,    TYPE = TYPE_NPC,      CHANCE = 40,    FAIL_MSG = { {2, "Olej nie dal zadnego efektu."} }, SUCCESS_MSG = "Udalo ci sie!"},
   [13508] =    {NAME = 'Slug',          ID = 14,    TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "Slimak uciekl."}, {3, "Ten mefedron nie dziala, slaby diler..."} }, SUCCESS_MSG = "Oswoiles slimaka."},
   [13939] =    {NAME = 'War Horse',        ID = 23,    TYPE = TYPE_MONSTER,    CHANCE = 15,    FAIL_MSG = { {1, "Kon uciekl."}, {2, "Kon wszystko zjadl."} }, SUCCESS_MSG = "Oswoiles konia."},
   [15545] = {NAME = 'Manta Ray',        ID = 28,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "Manta uciekla."}, {3, "Manta probuje uciec."} }, SUCCESS_MSG = "Oswoiles ja!."},
   [15546] = {NAME = 'Ladybug',          ID = 27,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "Biedronka przestraszyla sie i uciekla."}, {3, "Biedronka - niskie ceny... a nie, to nie to. Probuje cie skubac."} }, SUCCESS_MSG = "Oswoiles Biedronke, od teraz masz w niej niskie ceny."},
   [18447] = {NAME = 'Ironblight',          ID = 29,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "Uciekl, trudno go zlapac."} }, SUCCESS_MSG = "Oswoiles go!"},
   [18448] = {NAME = 'Magma Crawler',          ID = 30,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "Zbigniew Stonoga uciekl zlozyc zawiadomienie do prokuratury!"} }, SUCCESS_MSG = "Stonoga mysli, ze to te polskie kurwa glupie spoleczenstwo go oswoilo. Nie myli sie."},
   [18449] = {NAME = 'Dragonling',          ID = 31,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "Ten dziwny stwor... uciekl..."} }, SUCCESS_MSG = "Oswoiles go!"},
   [18516] = {NAME = 'Gnarlhound',          ID = 32,    TYPE = TYPE_MONSTER,    CHANCE = 90,    FAIL_MSG = { {2, "Klucz sie popsul."} }, SUCCESS_MSG = "Oswoiles go!"},
   [20138] = {NAME = 'Water Buffalo',          ID = 35,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "Byk uciekl."}, {2, "Nie udalo sie..."}, {3, "Byk cie ignoruje."} }, SUCCESS_MSG = "Brawo! Udalo ci sie!"},
   [21452] = {NAME = 'Gravedigger',          ID = 39,    TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {2, "Grabarz rozwalil Twoja skrzynke."}, {3, "Grabarz sie schowal. Hehe. Pochowal."} }, SUCCESS_MSG = "Zlapales go!"}
}
local function doFailAction(cid, mount, pos, item, itemEx)
   local action, effect = mount.FAIL_MSG[math.random(1, table.maxn(mount.FAIL_MSG))], CONST_ME_POFF
   if(action[1] == ACTION_RUN) then
     doRemoveCreature(itemEx.uid)
   elseif(action[1] == ACTION_BREAK) then
     effect = CONST_ME_BLOCKHIT
     doRemoveItem(item.uid, 1)
   elseif(action[1] == ACTION_ALL) then
     doRemoveCreature(itemEx.uid)
     doRemoveItem(item.uid, 1)
   end
   doSendMagicEffect(pos, effect)
   doCreatureSay(cid, action[2], TALKTYPE_MONSTER_SAY)
   return action
end
function onUse(cid, item, fromPosition, itemEx, toPosition)
   local mount = config[item.itemid]
   if(mount == nil or getPlayerMount(cid, mount.ID)) then
     return false
   end
   local rand = math.random(1, 100)
   --Monster Mount
   if(isMonster(itemEx.uid) and not isSummon(itemEx.uid) and mount.TYPE == TYPE_MONSTER) then
     if(mount.NAME == getCreatureName(itemEx.uid)) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doRemoveCreature(itemEx.uid)
       doSendMagicEffect(toPosition, CONST_ME_POFF)
       doRemoveItem(item.uid, 1)
       return true
     end
   --NPC Mount
   elseif(isNpc(itemEx.uid) and mount.TYPE == TYPE_NPC) then
     if(mount.NAME == getCreatureName(itemEx.uid)) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
       doRemoveItem(item.uid, 1)
       return true
     end
   --Action Mount
   elseif(itemEx.actionid > 0 and mount.TYPE == TYPE_ACTION) then
     if(mount.NAME == itemEx.actionid) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
       doRemoveItem(item.uid, 1)
       return true
     end
   --Unique Mount
   elseif(itemEx.uid <= 65535 and mount.TYPE == TYPE_UNIQUE) then
     if(mount.NAME == itemEx.uid) then
       if(rand > mount.CHANCE) then
         doFailAction(cid, mount, toPosition, item, itemEx)
         return true
       end
       doPlayerAddMount(cid, mount.ID)
       doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, mount.SUCCESS_MSG)
       doCreatureSay(cid, mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
       doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
       doRemoveItem(item.uid, 1)
       return true
     end
   end
   return false
end