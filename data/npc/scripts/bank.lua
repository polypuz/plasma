local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Local variable
local conversations = {}

-- Utilities
local function resetConversation(cid)
  conversations[cid] = {
    topic = 0,
    moneyCount = 0,
    transferPlayerRealName = nil
  }
end

local function getCount(msg)
  local b, e = msg:find('%d+')
  return b and e and math.min(4294967295, tonumber(msg:sub(b, e))) or -1
end

function msgContainsOneOf(msg, keyphrases)
  if not type(keyphrases) == "table" then
    return false
  end

  for idx, phrase in pairs(keyphrases) do
    if msgcontains(msg, phrase) then
      return true
    end
  end

  return false
end

function msgContainsAllOf(msg, keyphrases)
  if not type(keyphrases) == "table" then
    return false
  end

  for idx, phrase in pairs(keyphrases) do
    if not msgcontains(msg, phrase) then
      return false
    end
  end

  return true
end
--

-- Online-status agnostic player functions
local function updatePlayersBalance(playerName, differenceValue)
  local player = Player(playerName) -- Works when player is online

  if player then
    return player:setBankBalance(player:getBankBalance() + differenceValue)
  else
    local playerGUID = getPlayerGUIDByName(playerName) -- Get offline player's GUID

    local query =
      "UPDATE `players` SET `balance` = `balance` + " ..
      db.escapeString(differenceValue) ..
      " WHERE `id` = " ..
      db.escapeString(playerGUID) ..
      " LIMIT 1"
    local queryResult = db.query(query)

    return queryResult
  end
end

local function getPlayerRealName(playerName)
  local player = Player(playerName) -- Works when player is online

  if player then
    return player:getName()
  else
    local playerGUID = getPlayerGUIDByName(playerName) -- Get offline player's GUID

    local playerName = getPlayerNameById(playerGUID)

    if playerName == 0 then
      return nil
    end

    return playerName
  end
end

-- Setup handlers
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function greetCallback(cid)
  resetConversation(cid)
  return true
end

-- Main conversation logic
function creatureSayCallback(cid, type, msg)
  local player = Player(cid)

  -- Topics:
  -- 1  - [Deposit] Player said he wants to deposit
  -- 2  - [Deposit] Player said how much he wants to deposit
  -- 3  - [Withdraw] Player said he wants to withdraw
  -- 4  - [Withdraw] Player said how much he wants to withdraw
  -- 5  - [Transfer] Player said he wants to transfer
  -- 6  - [Transfer] Player said how much he wants to transfer
  -- 7  - [Transfer] Player said who should be the recipient of the transfer

  if not npcHandler:isFocused(cid) then
    return false
  end

  -- Info
  if msgContainsOneOf(msg, { 'bank' }) then
    npcHandler:say(
      'Mozesz u nas wyplacic pieniadze oraz zarzadzac swoim kontem bankowym.',
      cid
    )

    return false
  end

  -- Bank balance
  if msgContainsOneOf(msg, { 'stan konta', 'balance' }) then
    npcHandler:say(
      'Stan twojego konta wynosi ' .. getPlayerBalance(cid) .. ' zlota.',
      cid
    )

    return false
  end

  -- Depositing
  if msgContainsOneOf(msg, { 'deposit', 'wplac' }) or conversations[cid].topic == 1 then
    local msgMoneyCount = getCount(msg)
    local playerMoneyCount = getPlayerMoney(cid)

    if playerMoneyCount == 0 then
      npcHandler:say('Nie masz przy sobie zadnego zlota.', cid)

      conversations[cid].topic = 0
    elseif msgContainsOneOf(msg, { 'all', 'wszystko' }) then
      conversations[cid].moneyCount = playerMoneyCount
      conversations[cid].topic = 2

      npcHandler:say(
        'Chcesz wplacic wszystko? Hm, przeliczmy... Wychodzi ' .. playerMoneyCount .. ' zlota, zgadza sie?',
        cid
      )
    elseif msgMoneyCount == -1 then
      npcHandler:say('Powiedz mi, ile zlota chcialbys wplacic.', cid)

      conversations[cid].topic = 1
    elseif msgMoneyCount == 0 then
      npcHandler:say('Zartujesz, tak?', cid)

      conversations[cid].topic = 0
    else
      if msgMoneyCount > playerMoneyCount then
        npcHandler:say('Nie masz wystarczajacej ilosci sztuk zlota.', cid)

        conversations[cid].topic = 0
      else
        conversations[cid].moneyCount = msgMoneyCount
        conversations[cid].topic = 2

        npcHandler:say(
          'Czy na pewno chcesz wplacic ' .. conversations[cid].moneyCount .. ' sztuk zlota?',
          cid
        )
      end
    end
  elseif conversations[cid].topic == 2 then
    local msgMoneyCount = conversations[cid].moneyCount

    if msgContainsOneOf(msg, { 'tak', 'yes' }) then
      -- Deposit
      local removeResult = doPlayerRemoveMoney(cid, msgMoneyCount)

      if removeResult then
        local updateBalanceResult = doPlayerSetBalance(cid, getPlayerBalance(cid) + msgMoneyCount)

        if updateBalanceResult then
          -- Everything's fine...
          npcHandler:say(
            'Dobrze, wplacilismy ' .. msgMoneyCount .. ' sztuk zlota na twoje konto. Mozesz je wyplacic w kazdym momencie.',
            cid
          )
        else
          -- Problem (fatal)?
          npcHandler:say(
            'Cos poszlo nie tak, zglos sie do administracji...',
            cid
          )
        end
      else
        -- Problem (warning)?
        npcHandler:say(
          'Obawiam sie, ze Twoje zloto gdzies ucieklo. Powodzenia w odszukiwaniu go.',
          cid
        )
      end

      conversations[cid].topic = 0
    elseif msgContainsOneOf(msg, { 'nie', 'no' }) then
      -- Drop depositing
      npcHandler:say('Prosze bardzo. Jest jeszcze cos, co moge dla ciebie zrobic?', cid)

      conversations[cid].topic = 0
    else
      -- Confirm deposition once again
      npcHandler:say(
        'Czy na pewno chcesz wplacic ' .. msgMoneyCount .. ' sztuk zlota?',
        cid
      )

      -- No topic change
    end
  end

  -- Withdrawing
  if msgContainsOneOf(msg, { 'withdraw', 'wyplac' }) or conversations[cid].topic == 3 then
    local msgMoneyCount = getCount(msg)
    local playerBalanceCount = getPlayerBalance(cid)

    if playerBalanceCount == 0 then
      npcHandler:say('Twoje konto jest puste.', cid)

      conversations[cid].topic = 0
    elseif msgContainsOneOf(msg, { 'all', 'wszystko' }) then
      conversations[cid].moneyCount = playerBalanceCount
      conversations[cid].topic = 4

      npcHandler:say(
        'Chcesz wyplacic wszystko? Hm, przeliczmy... Wychodzi ' .. conversations[cid].moneyCount .. ' zlota, zgadza sie?',
        cid
      )
    elseif msgMoneyCount == -1 then
      npcHandler:say('Ile zlota chcialbys wyplacic?', cid)

      conversations[cid].topic = 3
    elseif msgMoneyCount == 0 then
      npcHandler:say('Mam neoliberalne poglady - zazadales 0 zlota, wiec prosze bardzo: oto Twoje 0 zlota! Nie wydaj na glupoty.', cid)

      conversations[cid].topic = 0
    else
      if msgMoneyCount > playerBalanceCount then
        npcHandler:say('Nie ma tylu sztuk zlota na twoim koncie.', cid)

        conversations[cid].topic = 0
      else
        conversations[cid].moneyCount = msgMoneyCount
        conversations[cid].topic = 4

        npcHandler:say(
          'Jestes pewny ze chcesz wyplacic ' .. conversations[cid].moneyCount .. ' sztuk zlota z twojego konta?',
          cid
        )
      end
    end
  elseif conversations[cid].topic == 4 then
    local msgMoneyCount = conversations[cid].moneyCount

    if msgContainsOneOf(msg, { 'tak', 'yes' }) then
      -- Withdraw
      local updateBalanceResult = doPlayerSetBalance(cid, getPlayerBalance(cid) - msgMoneyCount)

      if updateBalanceResult then
        local addResult = doPlayerAddMoney(cid, msgMoneyCount)

        if addResult then
          -- Everything's fine...
          npcHandler:say(
            'Prosze bardzo, to twoje ' .. msgMoneyCount .. ' sztuk zlota. Poinformuj mnie gdy bede mogl dla ciebie zrobic cos jeszcze.',
            cid
          )
        else
          -- Problem (fatal)?
          npcHandler:say(
            'Cos poszlo nie tak, zglos sie do administracji...',
            cid
          )
        end
      else
        -- Problem (fatal)?
        npcHandler:say(
          'Cos poszlo nie tak, zglos sie do administracji...',
          cid
        )
      end

      conversations[cid].topic = 0
    elseif msgContainsOneOf(msg, { 'nie', 'no' }) then
      -- Drop depositing
      npcHandler:say('Klient nasz pan! Wroc gdy bedziesz potrzebowal jeszcze czegos!', cid)

      conversations[cid].topic = 0
    else
      -- Confirm withdraw once again
      npcHandler:say(
        'Czy na pewno chcesz wyplacic ' .. msgMoneyCount .. ' sztuk zlota?',
        cid
      )

      -- No topic change
    end
  end

  -- Transfer
  if msgContainsOneOf(msg, { 'transfer', 'przelew' }) then
    local playerBalanceCount = getPlayerBalance(cid)

    if playerBalanceCount == 0 then
      npcHandler:say('Twoje konto jest puste.', cid)

      conversations[cid].topic = 0
    else
      npcHandler:say('Ile zlota chcialbys przelac?', cid)

      conversations[cid].topic = 5
    end
  elseif conversations[cid].topic == 5 then
    local msgMoneyCount = getCount(msg)
    local playerBalanceCount = getPlayerBalance(cid)

    if msgContainsOneOf(msg, { 'all', 'wszystko' }) then
      conversations[cid].moneyCount = playerBalanceCount
      conversations[cid].topic = 6

      npcHandler:say(
        'Chcesz przelac wszystko? Hm, przeliczmy... Wychodzi ' .. conversations[cid].moneyCount .. ' zlota. Do kogo chcesz przelac te pieniadze?',
        cid
      )
    elseif msgMoneyCount == -1 then
      npcHandler:say('Ile zlota chcialbys przelac?', cid)

      conversations[cid].topic = 5
    elseif msgMoneyCount == 0 then
      npcHandler:say('Mysle ze nikomu nie przyda sie twoje zero zlota...', cid)

      conversations[cid].topic = 0
    else
      if msgMoneyCount > playerBalanceCount then
        npcHandler:say('Nie ma tylu sztuk zlota na twoim koncie.', cid)

        conversations[cid].topic = 0
      else
        conversations[cid].moneyCount = msgMoneyCount
        conversations[cid].topic = 6

        npcHandler:say(
          'A wiec chcesz przelac ' .. conversations[cid].moneyCount .. ' sztuk zlota. Do kogo chcesz przelac te pieniadze?',
          cid
        )
      end
    end
  elseif conversations[cid].topic == 6 then
    local otherPlayerGUID = getPlayerGUIDByName(msg)

    if otherPlayerGUID == -1 then
      npcHandler:say('Taki mirek nie istnieje.', cid)

      conversations[cid].topic = 0
    else
      local otherPlayerRealName = getPlayerRealName(msg)

      conversations[cid].transferPlayerRealName = otherPlayerRealName
      conversations[cid].topic = 7

      npcHandler:say(
        'Na pewno chcesz przelac ' .. conversations[cid].moneyCount .. ' sztuk zlota do ' .. otherPlayerRealName .. '?',
        cid
      )
    end
  elseif conversations[cid].topic == 7 then
    local msgMoneyCount = conversations[cid].moneyCount
    local otherPlayerRealName = conversations[cid].transferPlayerRealName

    if msgContainsOneOf(msg, { 'tak', 'yes' }) then
      -- Transfer
      local updateOwnBalanceResult = doPlayerSetBalance(cid, getPlayerBalance(cid) - msgMoneyCount)

      if updateOwnBalanceResult then
        local updateOtherBalanceResult = updatePlayersBalance(otherPlayerRealName, msgMoneyCount)

        if updateOtherBalanceResult then
          -- Everything's fine...
          npcHandler:say(
            'Bardzo dobrze, ' .. msgMoneyCount .. ' sztuk zlota zostalo wyslane do gracza ' .. otherPlayerRealName .. '.',
            cid
          )
        else
          -- Problem (fatal)?
          npcHandler:say(
            'Cos poszlo nie tak, zglos sie do administracji...',
            cid
          )
        end
      else
        -- Problem (fatal)?
        npcHandler:say(
          'Cos poszlo nie tak, zglos sie do administracji...',
          cid
        )
      end

      conversations[cid].topic = 0
    elseif msgContainsOneOf(msg, { 'nie', 'no' }) then
      -- Drop depositing
      npcHandler:say('Czy moglbym jeszcze cos dla ciebie zrobic?', cid)

      conversations[cid].topic = 0
    else
      -- Confirm withdraw once again
      npcHandler:say(
        'Na pewno chcesz przelac ' .. conversations[cid].moneyCount .. ' sztuk zlota do ' .. otherPlayerRealName .. '?',
        cid
      )

      -- No topic change
    end
  end
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
