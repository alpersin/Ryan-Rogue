local _G, setmetatable, pairs, type, math = _G, setmetatable, pairs, type, math
local huge = math.huge
local TMW = _G.TMW 
local Action = _G.Action
local CONST = Action.Const
local Listener = Action.Listener
local Create = Action.Create
local GetToggle = Action.GetToggle
local GetLatency = Action.GetLatency
local GetGCD = Action.GetGCD
local GetCurrentGCD = Action.GetCurrentGCD
local ShouldStop = Action.ShouldStop
local BurstIsON = Action.BurstIsON
local AuraIsValid = Action.AuraIsValid
local InterruptIsValid = Action.InterruptIsValid
local DetermineUsableObject = Action.DetermineUsableObject
local Utils = Action.Utils
local BossMods = Action.BossMods
local TeamCache = Action.TeamCache
local EnemyTeam = Action.EnemyTeam
local FriendlyTeam = Action.FriendlyTeam
local LoC = Action.LossOfControl
local Player = Action.Player 
local MultiUnits = Action.MultiUnits
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local UnitCooldown = Action.UnitCooldown
local Unit = Action.Unit
local Covenant = _G.LibStub("Covenant")
local IsUnitEnemy = Action.IsUnitEnemy
local IsUnitFriendly = Action.IsUnitFriendly
local Combat = Action.Combat
local DisarmIsReady = Action.DisarmIsReady
local LastPlayerCastID = Action.LastPlayerCastID
local Azerite = LibStub("AzeriteTraits")
local ACTION_CONST_ROGUE_OUTLAW = CONST.ROGUE_OUTLAW
local ACTION_CONST_AUTOTARGET = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP = CONST.SPELLID_FREEZING_TRAP
local IsIndoors, UnitIsUnit = _G.IsIndoors, _G.UnitIsUnit

Action[ACTION_CONST_ROGUE_OUTLAW] = {
    -- Racial
    ArcaneTorrent = Create({ Type = "Spell", ID = 50613}),
    BloodFury = Create({ Type = "Spell", ID = 20572}),
    Fireblood = Create({ Type = "Spell", ID = 265221}),
    AncestralCall = Create({ Type = "Spell", ID = 274738}),
    Berserking = Create({ Type = "Spell", ID = 26297}),
    ArcanePulse = Create({ Type = "Spell", ID = 260364}),
    QuakingPalm = Create({ Type = "Spell", ID = 107079}),
    Haymaker = Create({ Type = "Spell", ID = 287712}), 
    WarStomp = Create({ Type = "Spell", ID = 20549}),
    BullRush = Create({ Type = "Spell", ID = 255654}), 
    BagofTricks = Create({ Type = "Spell", ID = 312411}), 
    GiftofNaaru = Create({ Type = "Spell", ID = 59544 }),
    LightsJudgment = Create({ Type = "Spell", ID = 255647}),
    Shadowmeld = Create({ Type = "Spell", ID = 58984}), -- usable in Action Core 
    Stoneform = Create({ Type = "Spell", ID = 20594}), 
    WilloftheForsaken = Create({ Type = "Spell", ID = 7744}), -- usable in Action Core 
    EscapeArtist = Create({ Type = "Spell", ID = 20589}), -- usable in Action Core 
    EveryManforHimself = Create({ Type = "Spell", ID = 59752}), -- usable in Action Core 
    Regeneratin = Create({ Type = "Spell", ID = 291944}), -- not usable in APL but user can Queue it
    --Talents
    QuickDraw = Create({ Type = "Spell", ID = 196938}),
    -- general
    Stealth = Create({ Type = "Spell", ID = 1784}),
    InstantPoison = Create({ Type = "Spell", ID = 315584}),
    CripplingPoison = Create({ Type = "Spell", ID = 3408}),
    NumbingPoison = Create({ Type = "Spell", ID = 5761}),
    WoundPoison = Create({ Type = "Spell", ID = 8679}),
    CrimsonVial = Create({ Type = "Spell", ID = 185311}),
    TricksOfTheTrade = Create({ Type = "Spell", ID = 57934}),
    PoolResource = Create({ Type = "Spell", ID = 97238,Hidden = true}),
    ShroudOfConcealment = Create({ Type = "Spell", ID = 114018}), 
    -- CDS
    AdrenalineRush = Create({ Type = "Spell", ID = 186286}),
    RollTheBones = Create({ Type = "Spell", ID = 315508}),
    --Covenants
    Sepsis = Create({ Type = "Spell", ID = 328305}),
    SerratedBoneSpike = Create({ Type = "Spell", ID = 328547}),
    EchoingReprimand = Create({ Type = "Spell", ID = 323547}),
    Flagellation = Create({ Type = "Spell", ID = 323654}),
    ClaimFlagellation = Create({ Type = "Spell", ID = 346975,Hidden = true}),
    --PhialofSerenity = Create({ Type = "Spell", ID = 177278}),
	SummonSteward = Create({ Type = "Spell", ID = 324739}), 
    --Conduits
    TripleThreat = Create({ Type = "Spell", ID = 341540}),
    --rollthebonesbuff
    Broadside = Create({ Type = "Spell", ID = 193356}),
    BuriedTreasure = Create({ Type = "Spell", ID = 199600}),
    GrandMelee = Create({ Type = "Spell", ID = 193358}),
    RuthlessPrecision = Create({ Type = "Spell", ID = 193357}),
    SkullandCrossbones = Create({ Type = "Spell", ID = 199603}),
    TrueBearing = Create({ Type = "Spell", ID = 193359}),
    --Buffs
    SliceAndDice = Create({ Type = "Spell", ID = 145418}),
    DeeperStratagem = Create({ Type = "Spell", ID = 193531}),
    Opportunity = Create({ Type = "Spell", ID = 195627}),
    MarkedForDeath = Create({ Type = "Spell", ID = 137619}),
    FlayedwingToxin = Create({ Type = "Spell", ID = 345545,Hidden = true}),
    Soulshape = Create({ Type = "Spell", ID = 310143}),
    Vanish = Create({ Type = "Spell", ID = 1856}),
    VanishStealth = Create({ Type = "Spell", ID = 11327,Hidden = true}),
    SepsisStealth = Create({ Type = "Spell", ID = 347037,Hidden = true}),
    Elusiveness = Create({ Type = "Spell", ID = 79008}),
    EchoingReprimandBuff = Create({ Type = "Spell", ID = 323558,Hidden = true}),
    MasterAssassinsMark = Create({ Type = "Spell", ID = 340094,Hidden = true}),
	StolenShadehound = Create({ Type = "Spell", ID = 338659,Hidden = true}),
    --kick
    Kick = Create({ Type = "Spell", ID = 1766}),
    KickGreen = Create({ Type = "SpellSingleColor",ID = 1766,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    GougeGreen = Create({ Type = "SpellSingleColor",ID = 1776,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    BlindGreen = Create({ Type = "SpellSingleColor",ID = 2094,Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    KidneyShotGreen = Create({ Type = "SpellSingleColor",ID = 408,Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    CheapShotGreen = Create({ Type = "SpellSingleColor",ID = 1833,Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    -- Rotation 
    Shiv = Create({ Type = "Spell", ID = 5938}),
    Ambush = Create({ Type = "Spell", ID = 8676}),
    CheapShot = Create({ Type = "Spell", ID = 1833}),
    Dispatch = Create({ Type = "Spell", ID = 2098}),
    PistolShot = Create({ Type = "Spell", ID = 185763}),
    SinisterStrike = Create({ Type = "Spell", ID = 1752}),
    BladeFlurry = Create({ Type = "Spell", ID = 13877}),
    GhostlyStrike = Create({ Type = "Spell", ID = 196937}),
    KillingSpree = Create({ Type = "Spell", ID = 51690}),
    BladeRush = Create({ Type = "Spell", ID = 271877}),
    BetweenTheEyes = Create({ Type = "Spell", ID = 199804}),
    Gouge = Create({ Type = "Spell", ID = 1776}),
    Blind = Create({ Type = "Spell", ID = 2094}),
    Feint = Create({ Type = "Spell", ID = 1966}),
    KidneyShot = Create({ Type = "Spell", ID = 408}), 
    Evasion = Create({ Type = "Spell", ID = 5277}), 
    CloakofShadows = Create({ Type = "Spell", ID = 31224}), 
    -- Items
    PotionofUnbridledFury = Create({ Type = "Potion", ID = 169299}), 
    BottledFlayedwingToxin = Create({ Type = "Trinket", ID = 178742,Hidden = true}),
    InscrutableQuantumDevice = Create({ Type = "Trinket", ID = 179350,Hidden = true}),
    
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion = Create({ Type = "Trinket", ID = 161674}), 
    DreadCombatantsInsignia = Create({ Type = "Trinket", ID = 161676}), 
    DreadCombatantsMedallion = Create({ Type = "Trinket", ID = 161811,Hidden = true}), -- Game has something incorrect with displaying this
    DreadGladiatorsBadge = Create({ Type = "Trinket", ID = 161902}), 
    DreadAspirantsMedallion = Create({ Type = "Trinket", ID = 162897}), 
    DreadAspirantsBadge = Create({ Type = "Trinket", ID = 162966}), 
    SinisterGladiatorsMedallion = Create({ Type = "Trinket", ID = 165055}), 
    SinisterGladiatorsBadge = Create({ Type = "Trinket", ID = 165058}), 
    SinisterAspirantsMedallion = Create({ Type = "Trinket", ID = 165220}), 
    SinisterAspirantsBadge = Create({ Type = "Trinket", ID = 165223}), 
    NotoriousGladiatorsMedallion = Create({ Type = "Trinket", ID = 167377}), 
    NotoriousGladiatorsBadge = Create({ Type = "Trinket", ID = 167380}), 
    NotoriousAspirantsMedallion = Create({ Type = "Trinket", ID = 167525}), 
    NotoriousAspirantsBadge = Create({ Type = "Trinket", ID = 167528}), 
}

Action:CreateEssencesFor(ACTION_CONST_ROGUE_OUTLAW)
local A = setmetatable(Action[ACTION_CONST_ROGUE_OUTLAW], { __index = Action })

local player= "player"
local Temp = {
    TotalAndPhys = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    BerserkerRageLoC = {"FEAR", "INCAPACITATE"},
    CastStartTime = {},
    IsSlotTrinketBlocked = {
        [A.BottledFlayedwingToxin.ID] = true,
        [A.InscrutableQuantumDevice.ID] = true, 
        
    },
}; do 
    -- Push IsSlotTrinketBlocked
    for key, val in pairs(Action[ACTION_CONST_ROGUE_OUTLAW]) do 
        if type(val) == "table" and val.Type == "Trinket" then 
            Temp.IsSlotTrinketBlocked[val.ID] = true
        end 
    end 
end 

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unitID) 
    return 
    IsUnitEnemy(unitID) and 
    Unit(unitID):GetRange() <= 20 and 
    Unit(unitID):IsControlAble("stun") and 
    A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) 
end 
A[1] = function(icon) 
    -- if A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun("target")
    -- then 
    -- return A.StormBoltGreen:Show(icon) 
    -- end 
    local useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid("target") 
    if useKick or useCC or useRacial then 
        -- useCC / useRacial
        if not useKick or notKickAble or A.Kick:GetCooldown() > 0 then 
            if useCC 
            and (Unit(player):HasBuffs(A.Stealth.ID) ~= 0 or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0) and A.CheapShot:IsReady("target") and A.CheapShot:AbsentImun("target", Temp.TotalAndPhysAndCC) and Unit("target"):GetDR("stun") > 0 and not Unit("target"):IsBoss() then 
                return A.CheapShotGreen:Show(icon) 
            end 
            
            if useCC and A.Gouge:IsReady("target") and A.Gouge:AbsentImun("target", Temp.TotalAndPhysAndCC) and Player:IsBehind(.3) and Unit("target"):GetDR("incapacitate") > 0 and not Unit("target"):IsBoss() then 
                return A.GougeGreen:Show(icon) 
            end 
            
            if useCC and A.KidneyShot:IsReady("target") and A.KidneyShot:AbsentImun("target", Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit("target"):GetDR("stun") > 0 and not Unit("target"):IsBoss() then 
                return A.KidneyShotGreen:Show(icon) 
            end 
            
            if useCC and A.Blind:IsReady("target") and A.Blind:AbsentImun("target", Temp.TotalAndPhysAndCC) and Unit("target"):GetDR("disorient") > 0 and not Unit("target"):IsBoss() then 
                return A.BlindGreen:Show(icon)
            end 
        end
    end
end
-- [2] Kick AntiFake Rotation
A[2] = function(icon) 
    local unitID
    if IsUnitEnemy("mouseover") then 
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then 
        unitID = "target"
    end 
    
    if unitID then 
        local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
        if castLeft > 0 then 
            if not notKickAble and A.Kick:IsReady(unitID, nil, nil, true) and A.Kick:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.KickGreen:Show(icon) 
            end 
        end 
    end 
end

function Action:IsLatenced(delay)
    -- @return boolean 
    return TMW.time - (Temp.CastStartTime[self:Info()] or 0) > (delay or 0.1)
end


--[[
local function GetByRangeTTD(count, range)
    -- @return number
    local total, total_ttd = 0, 0
    for unitID in pairs(ActiveUnitPlates) do 
        if not range or Unit(unitID):CanInterract(range) then 
            total = total + 1
            total_ttd = total_ttd + Unit(unitID):TimeToDie()
        end 
        
        if count and total >= count then 
            break 
        end 
    end 
    
    if total > 0 then 
        return total_ttd / total 
    else 
        return 10000
    end
end 
--]]


local function InscrutableQuantumDeviceCheck()
    --@boolean true - Trinket will DPS or give stat buff, false - Trinket will heal or restore mana
    for GUIDs, v in pairs(TeamCache.Friendly.GUIDs) do
        if Unit(v):HealthPercent() <= 30 then 
            return false 
        end 
        if Unit(v):PowerType() == "MANA" then
            if Unit(v):PowerPercent() <= 20 then 
                return false
            end 
        end 
    end
    return true
end

-- Use Items (function call includes stealth prevention)
local function UseItems(unitID)
    if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket1
    end 
    if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket2
    end 
    -- use BottledFlayedwingToxin if Brez'd or Buff drops in fight
    if A.BottledFlayedwingToxin:IsReady(unitID, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 then
        return A.BottledFlayedwingToxin
    end
    if A.InscrutableQuantumDevice:IsReady(unitID) and InscrutableQuantumDeviceCheck() then
        return A.InscrutableQuantumDevice
    end
end

-- [3] Single Rotation
A[3] = function(icon) 
    --local inDisarm = LoC:Get("DISARM") > 0 -- @boolean --not used by Ryan
	
	-- stop rotation if stolen shademount
	if Unit(player):HasBuffs(A.StolenShadehound.ID) ~= 0 then return end
	
    --Testing

	
	
	
    -- Rotations 
    function EnemyRotation(unitID) 
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        if UnitCanAttack(player, unitID) == false then return end
        --Stop Rotation if Vanish is set to off
        if Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0 and GetToggle(2, "VanishSetting") == 0 then return end		
        if IsMounted() then return end
        local isBurst = BurstIsON(unitID) -- @boolean
        
        --testing
        
        
        --Stealth with target enemy
        if IsUnitEnemy(unitID) and A.Stealth:IsReady(unitID, true) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and Unit(player):HasBuffs(A.VanishStealth.ID) == 0 and Unit(player):HasBuffs(A.Soulshape.ID) == 0 and not IsMounted() then
            return A.Stealth:Show(icon)
        end
        -- kill Explosive Affix
        if Unit(unitID):IsExplosives() and A.SinisterStrike:IsReady(unitID) then
            return A.SinisterStrike:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.PistolShot:IsReady(unitID) and not A.Shiv:IsInRange(unitID) then
            return A.PistolShot:Show(icon)
        end
        --Shiv Enrages
        if A.Shiv:IsReady(unitID) and Unit(player):HasBuffs(A.NumbingPoison.ID) ~= 0 and Action.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then
            return A.Shiv:Show(icon)
        end 
        --Spiteful Shade
        if Unit(unitID):Name() == "Spiteful Shade" and Unit(unitID):HasDeBuffs({"Stuned", "Disoriented", "PhysStuned"}) == 0 then
            --Evasion tank
            if Unit("targettarget"):Name() == Unit(player):Name() and A.Shiv:IsInRange(unitID) and A.Evasion:IsReady(player) then
                return A.Evasion:Show(icon)
            end
            --Stun
            if Unit("targettarget"):Name() == Unit(player):Name() and Player:ComboPoints() >= 2 and A.KidneyShot:IsReady(unitID) and Unit(player):HasBuffs(A.Evasion.ID) == 0 then
                return A.KidneyShot:Show(icon) 
            end
            --Slow 
            if Unit(unitID):HasDeBuffs(A.PistolShot.ID) == 0 and A.PistolShot:IsReady(unitID) and not A.Shiv:IsInRange(unitID) then
                return A.PistolShot:Show(icon)
            end
        end
        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then 
            return A.ArcaneTorrent:Show(icon)
        end 
        -- Check RtB
        local function CheckBuffCountRB() 
            local count = 0
            if Unit(player):HasBuffs(A.Broadside.ID) ~= 0 then
                count = count + 1
            end
            if Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 then
                count = count + 1
            end
            if Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 then
                count = count + 1
            end
            if Unit(player):HasBuffs(A.RuthlessPrecision.ID) ~= 0 then
                count = count + 1
            end
            if Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0 then
                count = count + 1
            end
            if Unit(player):HasBuffs(A.SkullandCrossbones.ID) ~= 0 then
                count = count + 1
            end
            return count
        end
        
        local function Interrupts()
            if A.GetToggle(2, "InterruptList") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) --uses ryan interrupt table
            then
                useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(unitID, "RyanInterrupts", true)
            else 
                useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(unitID)
            end 
            if useKick or useCC or useRacial then 
                -- useKick
                if useKick and castLeft > 0 and not notKickAble  and A.AbsentImun(nil, unitID, Temp.TotalAndPhysKick) and A.Kick:IsReady(unitID) then 
                    return A.Kick:Show(icon)
                end
                -- useCC / useRacial
                if not useKick or notKickAble or A.Kick:GetCooldown() > 0 then 
                    if useCC and (Unit(player):HasBuffs(A.Stealth.ID) ~= 0 or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0) and A.CheapShot:IsReady(unitID) and A.CheapShot:AbsentImun(unitID, Temp.TotalAndPhysAndCC) and Unit(unitID):GetDR("stun") > 0 and not Unit(unitID):IsBoss() then 
                        return A.CheapShot:Show(icon) 
                    end 
                    
                    if useCC and A.Gouge:IsReady(unitID) and A.Gouge:AbsentImun(unitID, Temp.TotalAndPhysAndCC) and Player:IsBehind(.3) and Unit(unitID):GetDR("incapacitate") > 0 and not Unit(unitID):IsBoss() then 
                        return A.Gouge:Show(icon) 
                    end 
                    
                    if useCC and A.KidneyShot:IsReady(unitID) and A.KidneyShot:AbsentImun(unitID, Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit(unitID):GetDR("stun") > 0 and not Unit(unitID):IsBoss() then 
                        return A.KidneyShot:Show(icon) 
                    end 
                    
                    if useRacial and A.QuakingPalm:IsReady(unitID) and A.QuakingPalm:AbsentImun(unitID, Temp.TotalAndPhysAndCC) and Unit(unitID):GetDR("incapacitate") > 0 and not Unit(unitID):IsBoss() then 
                        return A.QuakingPalm:Show(icon) 
                    end 
                    if useCC 
                    and A.Blind:IsReady(unitID) and A.Blind:AbsentImun(unitID, Temp.TotalAndPhysAndCC) 
                    and Unit(unitID):GetDR("disorient") > 0
                    and not Unit(unitID):IsBoss()
                    then 
                        return A.Blind:Show(icon)
                    end 
                end
            end
        end
        
        local function Defensives()
            --defensives 
            local Evasion = GetToggle(2, "Evasion")
            if Evasion >= 0 and A.Evasion:IsReady(player) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and 
            (( -- Auto 
                    Evasion >= 100 and
                    (
                        -- HP lose per sec >= 20
                        Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 50 or Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.50 or 
                        -- TTD 
                        Unit(player):TimeToDieX(25) < 2 or (A.IsInPvP and Unit(player):HealthPercent() <= 40 and (Unit(player):UseDeff() or (Unit(player, 5):HasFlags() and Unit(player):GetRealTimeDMG() > 0 and Unit(player):IsFocused() )))) and Unit(player):HasBuffs("DeffBuffs", true) == 0) or 
                ( -- Custom
                    Evasion < 100 and Unit(player):HealthPercent() <= Evasion)) 
            then 
                return A.Evasion:Show(icon)
            end
            -- CloakofShadows
            local CloakofShadows = GetToggle(2, "CloakofShadows")
            if CloakofShadows >= 0 and A.CloakofShadows:IsReady(player) and 
            (( -- Auto 
                    CloakofShadows >= 100 and Unit(player):TimeToDieMagicX(25) < 2 and 
                    -- Magic Damage still appear
                    Unit(player):GetRealTimeDMG(4) > 0 and Unit(player):HasBuffs("DeffBuffsMagic") == 0) or 
                ( -- Custom
                    CloakofShadows < 100 and Unit(player):HealthPercent() <= CloakofShadows)) 
            then 
                return A.CloakofShadows:Show(icon)
            end
            -- Feint
            local Feint = GetToggle(2, "Feint") 
            if Feint >= 0 and A.Feint:IsReady(player) and
            (( -- Auto
                    Feint >= 100 and (Unit(player):IsTankingAoE(16) or A.Elusiveness:IsSpellLearned()) and Unit(player):GetRealTimeDMG() > 0 and
                    (Unit(player):TimeToDieX(60) < 2 or
                        (A.IsInPvP and Unit(player):HealthPercent() < 80 and Unit(player):IsFocused(nil, true)))
                ) or -- Custom
                (Feint < 100 and Unit(player):HealthPercent() < Feint))
            then 
                return A.Feint:Show(icon)
            end
            -- CrimsonVial 
            local CrimsonVial = GetToggle(2, "CrimsonVial")
            if CrimsonVial >= 0 and A.CrimsonVial:IsReady(player) and Unit(player):HealthPercent() <= CrimsonVial then
                return A.CrimsonVial:Show(icon)
            end
            -- PhialofSerenity 
            -- local CrimsonVial = GetToggle(2, "CrimsonVial")
            -- if CrimsonVial >= 0 and A.PhialofSerenity:IsReady(player) and Unit(player):HealthPercent() <= CrimsonVial-10 then
            -- return A.PhialofSerenity:Show(icon)
            -- end
            -- Stoneform (Self Dispel)
            if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then 
                return A.Stoneform:Show(icon)
            end
        end
        
        -- [[ Opener ]]
        local function Opener()
            if A.MarkedForDeath:IsReady(unitID) 
            and (not GetToggle(1, "BossMods") or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 7)) and not Unit(unitID):IsTotem() 
            then
                return A.MarkedForDeath:Show(icon)
            end
            
            if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5 
            and (not GetToggle(1, "BossMods") or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 3))
            then
                return A.SliceAndDice:Show(icon)
            end
            if CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0)) 
            and ((not GetToggle(1, "BossMods") and A.Shiv:IsInRange(unitID)) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 1.8)) then
                
                return A.RollTheBones:Show(icon)
            end 
            if GetToggle(2, "Opener") == "Ambush" then
                if A.Ambush:IsReady(unitID) 
                and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0)
                then
                    return A.Ambush:Show(icon)
                end
            end
            if GetToggle(2, "Opener") == "CheapShot" then
                if A.CheapShot:IsReady(unitID) and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0)then
                    return A.CheapShot:Show(icon)
                end
            end
            -- Tricks with boss mods works ok in raid use only with @focus macro and Boss Timers checked TODO: Check for IsReady("focus") on Tricks on Focus mounted, range, in party, etc. might spam tricks during pull timer, but wont stop rotation
            if A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2.5) then
                return A.TricksOfTheTrade:Show(icon)
            end 
            if A.ShroudOfConcealment:IsReady(player) and IsInRaid() and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 6) then
                return A.ShroudOfConcealment:Show(icon)
            end
        end
        
        local function StealthCDs()
            --RtB is not a cooldown, it is here to ensure correct prioirty with Burst on
            if CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0)) and A.Shiv:IsInRange(unitID) then
                return A.RollTheBones:Show(icon)
            end 
            --MfD is also in ST() it is a CD that resets on death and is used with burst off as well
            if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 and not Unit(unitID):IsTotem() then
                return A.MarkedForDeath:Show(icon)
            end
            --Use Ambush from Maunal or Auto Vanish
            if GetToggle(2, "VanishSetting") >=1 then
                if A.Ambush:IsReady(unitID) then
                    return A.Ambush:Show(icon) 
                end
                if Player:Energy() <= 51 then 
                    return A.PoolResource:Show(icon)
                end 
            end
            
        end
        -- [[ CDs ]]
        local function CDs() -- indented fucntions are used from stealth/vanish
            local EightYardTTD = A.MultiUnits:GetByRangeAreaTTD(8) --@number average time to die of all targets in 8 yards
			
			
			
            local Item = UseItems(unitID)
            if Item and A.Shiv:IsInRange(unitID) then --prevent all items in stealth
                return Item:Show(icon)
            end
            if A.Fireblood:IsReady(unitID, true) and A.Shiv:IsInRange(unitID) and Player:Energy() < 44 then
                return A.Fireblood:Show(icon)
            end
            if A.Berserking:IsReady(unitID, true) and A.Shiv:IsInRange(unitID) and Player:Energy() <44 then
                return A.Berserking:Show(icon)
            end
            if A.BloodFury:IsReady(unitID, true) and A.Shiv:IsInRange(unitID) and Player:Energy() <44 then
                return A.BloodFury:Show(icon)
            end
            if A.LightsJudgment:IsReady(unitID) and Player:Energy() <44 then
                return A.LightsJudgment:Show(icon)
            end
            if A.BagofTricks:IsReady(player) and A.Shiv:IsInRange(unitID) and Player:Energy() <44 then 
                return A.BagofTricks:Show(icon)
            end
            if A.AncestralCall:IsReady(player) and A.Shiv:IsInRange(unitID) and Player:Energy() <44 then 
                return A.AncestralCall:Show(icon)
            end 
            if ((A.Flagellation:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) == 0 and (EightYardTTD > 4 or Unit(unitID):IsBoss())) or (Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) <= 2 or Unit(unitID):HasDeBuffsStacks(A.Flagellation.ID, true) >= 30)) then
                return A.Flagellation:Show(icon)
            end
            if A.AdrenalineRush:IsReady(unitID, true) and Unit(player):HasBuffs(A.AdrenalineRush.ID) == 0 and A.Shiv:IsInRange(unitID) and (EightYardTTD > 8 or Unit(unitID):IsBoss()) and (GetToggle(2, "Adrenaline") <= MultiUnits:GetByRange(8) or Unit(unitID):IsBoss()) then
                return A.AdrenalineRush:Show(icon)
            end
            --RtB is not a cooldown, it is here to ensure correct prioirty with Burst on
            if CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0)) and A.Shiv:IsInRange(unitID) and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) then
                return A.RollTheBones:Show(icon)
            end 
            --AoE (bladeflurry is also in ST(), this is to ensure correct prioitizaion for isBurst on and off. The intent is for GetToggle(2, "AoE") to control bladeflurry, not isBurst.
            if A.BladeFlurry:IsReady(unitID, true) and GetToggle(2, "AoE") and MultiUnits:GetByRange(8) >= 2 and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2 and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) then
                return A.BladeFlurry:Show(icon)
            end 
            --MfD is also in ST() it is a CD that resets on death and is used with burst off as well
            if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) and not Unit(unitID):IsTotem() then
                return A.MarkedForDeath:Show(icon)
            end
            if A.GhostlyStrike:IsReady(unitID) then
                return A.GhostlyStrike:Show(icon)
            end
            if A.KillingSpree:IsReady(unitID) and Player:EnergyTimeToMax() >= 2.5 and ((MultiUnits:GetByRange(8) >= 2 and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0) or MultiUnits:GetByRange(8) <= 1) then
                return A.KillingSpree:Show(icon)
            end
            if A.BladeRush:IsReady(unitID) and Unit(unitID):Name() ~= "Spiteful Shade" and (MultiUnits:GetByRange(8) <= 1 or (MultiUnits:GetByRange(8) >= 2 and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0)) and ((GetToggle(2, "BladeRushRange") <= 6 and Unit(unitID):GetRange() <=5) or (GetToggle(2, "BladeRushRange") >= 6))then
                return A.BladeRush:Show(icon)
            end
            -- Use Vanish if setting is set to Auto
            if A.Vanish:IsReady(player) and GetToggle(2, "VanishSetting") == 2 and A.Shiv:IsInRange(unitID) and Unit(player):CombatTime() > 0 and Player:ComboPointsDeficit() >= 2 and Unit(player):HasBuffs(A.SkullandCrossbones.ID) == 0 and Unit(player):HasBuffs(A.MasterAssassinsMark) == 0 and Player:GCDRemains() <= 0.2 then
                if Player:Energy() <= 51 then 
                    return A.PoolResource:Show(icon)
                else
                    return A.Vanish:Show(icon) 
                end
            end 
            -- Multiunits checks for the number of dots and allows using it if we will gain 3 or less CP, after +3 CP gained per use we can waste the extra generated. Highly unlikley that 3+ targets will live long enough to gain enough dots to generate >4 CP per use. 
            if (A.SerratedBoneSpike:IsReady(unitID) and MultiUnits:GetByRangeAppliedDoTs(15, 2, A.SerratedBoneSpike.ID)+1 >= Player:ComboPointsDeficit() and ((Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID) == 0 or (A.SerratedBoneSpike:GetSpellChargesFrac() >= 2.95) )) or (A.SerratedBoneSpike:IsReady("mouseover") and IsUnitEnemy("mouseover") and Unit("mouseover"):HasDeBuffs(A.SerratedBoneSpike.ID) == 0)) then
                return A.SerratedBoneSpike:Show(icon)
            end
            if A.Sepsis:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) then
                return A.Sepsis:Show(icon)
            end
            if A.EchoingReprimand:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Player:ComboPointsDeficit() >= 2 then
                return A.EchoingReprimand:Show(icon)
            end
        end
        
        
        -- [[ finishers ]]
        local function Finishers() 
            if (A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) < (1 + (Player:ComboPoints()) * 1.8 ) and Unit(player):HasBuffs(A.MasterAssassinsMark) == 0 and Unit(player):HasBuffs(A.VanishStealth.ID) == 0) and ((Player:ComboPointsDeficit() == 0) or (Unit(player):HasBuffs(A.Broadside.ID) >= 1 and (Player:ComboPointsDeficit() <= 1))) then
                return A.SliceAndDice:Show(icon)
            end
            if A.BetweenTheEyes:IsReady(unitID) and ((Player:ComboPointsDeficit() == 0 or (Player:ComboPoints()) == Unit(player):HasBuffsStacks(A.EchoingReprimandBuff.ID)) or (Unit(player):HasBuffs(A.Broadside.ID) >= 1 and (Player:ComboPointsDeficit() <= 1))) then
                return A.BetweenTheEyes:Show(icon)
            end
            if A.Dispatch:IsReady(unitID) and ((Player:ComboPointsDeficit() == 0 or (Player:ComboPoints()) == Unit(player):HasBuffsStacks(A.EchoingReprimandBuff.ID)) or (Unit(player):HasBuffs(A.Broadside.ID) >= 1 and (Player:ComboPointsDeficit() <= 1))) then
                return A.Dispatch:Show(icon)
            end
        end
        
        -- [[ Single Target ]]
        local function ST()
            --RtB is not a cooldown, it is here to ensure use when Burst is off
            if not isBurst and CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0)) and A.Shiv:IsInRange(unitID) and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) and Unit(player):HasBuffs(A.VanishStealth.ID) == 0 then
                return A.RollTheBones:Show(icon)
            end 
            --AoE (bladeflurry is also in CD(), this is to ensure correct prioitizaion for Burst on and off. The intent is for GetToggle(2, "AoE") to control bladeflurry, not isBurst.
            if A.BladeFlurry:IsReady(unitID, true) and GetToggle(2, "AoE") and MultiUnits:GetByRange(8) >= 2 and A.MultiUnits:GetByRangeAreaTTD(8) > 4 and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2 and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) then
                return A.BladeFlurry:Show(icon)
            end
            --MfD is a CD that resets if the target dies, no need to hold based on Burst setting, Can not be used on Totems
            if A.MarkedForDeath:IsReady(unitID) and not isBurst and Player:ComboPointsDeficit() >=4 and(not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) and not Unit(unitID):IsTotem()
            then
                return A.MarkedForDeath:Show(icon)
            end
            --Covenant Builders
            --Use Spesis Stealth buff on Ambush, Pool energy for Ambush
            if Unit(player):HasBuffs(A.SepsisStealth.ID) ~= 0 and A.Ambush:IsInRange(unitID) and Player:ComboPointsDeficit() >= 1 then
                if A.Ambush:IsReady(unitID) then
                    return A.Ambush:Show(icon) 
                end
                --pool energy for Ambush with Sepsis Buff
                if Player:Energy() <= 51 then 
                    return A.PoolResource:Show(icon)
                end
            end
            --Builders
            -- there are rumors that Triple Threat Conduit may make PistolShot with Opportunity obselete, this will check if that conduit is active if needed
            -- in the future (C_Soulbinds.IsConduitInstalledInSoulbind(C_Soulbinds.GetActiveSoulbindID(), 241)) --@boolean 
            -- if QuickDraw Talent (Opportunity generates 2 CP)
            if (A.PistolShot:IsReady(unitID, true) and Unit(player):HasBuffs(A.Opportunity.ID) ~= 0) and A.QuickDraw:IsTalentLearned() and 
            ((Unit(player):HasBuffs(A.Broadside.ID) >= 1 and Player:ComboPointsDeficit() >= 3) --QD +OP + BS = 3 CP
                or (Unit(player):HasBuffs(A.Broadside.ID) == 0 and Player:ComboPointsDeficit() >= 2)) --QD + BS = 2 CP
            then
                return A.PistolShot:Show(icon)
            end    
            -- If not QuickDraw Talent (Opportunity generates 1 CP)
            if (A.PistolShot:IsReady(unitID, true) and Unit(player):HasBuffs(A.Opportunity.ID) ~= 0) and not A.QuickDraw:IsTalentLearned() and 
            ((Unit(player):HasBuffs(A.Broadside.ID) >= 1 and Player:ComboPointsDeficit() >= 2) --OP + BS = 2 CP
                or (Unit(player):HasBuffs(A.Broadside.ID) == 0 and Player:ComboPointsDeficit() >= 1)) --OP = 1 CP
            then
                return A.PistolShot:Show(icon)                
            end
            if A.SinisterStrike:IsReady(unitID) then
                return A.SinisterStrike:Show(icon)
            end
            --In combat ranged GCD filler
            if A.PistolShot:IsReady(unitID) and Player:Energy() >=90 and Unit(unitID):HealthPercent() < 100 and not A.Shiv:IsInRange(unitID) then
                return A.PistolShot:Show(icon)
            end
        end
        
		

		
		
		
        --INTERRUPTS
        if Interrupts() then
            return true
        end
        --DEFENSIVES
        if Defensives() then 
            return true
        end
        -- OPENER
        if Opener() and Unit(player):HasBuffs(A.Stealth.ID) ~= 0 and GetToggle(2, "Opener") ~= "OFF" then
            return true
        end
        --StealthCDs
        if StealthCDs() and isBurst 
        --TODO: review "or" here : the intent is for vanish to allow for in combat stealth CDs (RtB, MfD, and Ambush) but if vanish lasts so long you gain the stealth buff, we will just reopen instead which will also use stealth CDs based on user Opener Settings
        and (Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0 or (LastPlayerCastID == 1856 and Unit(player):HasBuffs(A.Stealth.ID) == 0)) then
            return true 
        end
        
        if Unit(player):HasBuffs(A.Stealth.ID) == 0 then
            -- CDs
            if CDs() and isBurst then
                return true 
            end
            -- FINISHERS
            if Finishers() then
                return true
            end
            --Single Target
            if ST() and LastPlayerCastID ~= 1856 then
                return true
            end
            -- GiftofNaaru
            if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then 
                return A.GiftofNaaru:Show(icon)
            end
        end 
    end 
    
	
	
	
	
    
    --Use BottledFlayedwingToxin if out of combat with other poisons. before stealth
    if A.BottledFlayedwingToxin:IsReady(unitID, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then
        return A.BottledFlayedwingToxin:Show(icon)
    end
    if GetToggle(2, "OOCStealth") and A.Stealth:IsReady(unitID, true) and A.Stealth:IsLatenced(GetGCD() + 0.5) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and Unit(player):HasBuffs(A.VanishStealth.ID) == 0 and Unit(player):HasBuffs(A.Soulshape.ID) == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then
        return A.Stealth:Show(icon)
    end
    
	
	
    --Poisons use UI settings to check if poison selected is ready, already applied and ooc
    if Unit(player):CombatTime() == 0 and not IsMounted() and not Player:IsMoving() then
        if GetToggle(2, "LethalPoison") == "InstantPoison" then
            if A.InstantPoison:IsReady(unitID, true) 
            and A.InstantPoison:IsLatenced(GetGCD() + 0.5) 
            and Unit(player):HasBuffs(A.InstantPoison.ID) == 0 then
                return A.InstantPoison:Show(icon)
            end
        end
        if GetToggle(2, "LethalPoison") == "WoundPoison" then
            if A.WoundPoison:IsReady(unitID, true) 
            and A.WoundPoison:IsLatenced(GetGCD() + 0.5) 
            and Unit(player):HasBuffs(A.WoundPoison.ID) == 0 then
                return A.WoundPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "NumbingPoison" then
            if A.NumbingPoison:IsReady(unitID, true)
            and A.NumbingPoison:IsLatenced(GetGCD() + 0.5) 
            and Unit(player):HasBuffs(A.NumbingPoison.ID) == 0 then
                return A.NumbingPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "CripplingPoison" then
            if A.CripplingPoison:IsReady(unitID, true) 
            and A.CripplingPoison:IsLatenced(GetGCD() + 0.5) 
            and Unit(player):HasBuffs(A.CripplingPoison.ID) == 0 then
                return A.CripplingPoison:Show(icon)
            end
        end 
    end
    
    -- Target 
    if IsUnitEnemy("target") and EnemyRotation("target") then 
        return true 
    end
end 


A[4] = nil
A[5] = nil 
A[6] = function(icon) 
    local MOExplosive = GetToggle(2, "MOExplosive")
    local MOTotem = GetToggle(2, "MOTotem")
    
    if MOExplosive and IsUnitEnemy("mouseover") and Unit("mouseover"):IsExplosives() or MOTotem and IsUnitEnemy("mouseover") and Unit("mouseover"):IsTotem() then 
        return A:Show(icon, ACTION_CONST_LEFT)
    end
end 
A[7] = nil 
A[8] = nil 

