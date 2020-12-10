local _G, setmetatable, pairs, type, math    = _G, setmetatable, pairs, type, math
local huge         = math.huge
local TMW         = _G.TMW 
local Action     = _G.Action
local CONST     = Action.Const
local Listener     = Action.Listener
local Create     = Action.Create
local GetToggle    = Action.GetToggle
local GetLatency= Action.GetLatency
local GetGCD    = Action.GetGCD
local GetCurrentGCD= Action.GetCurrentGCD
local ShouldStop= Action.ShouldStop
local BurstIsON    = Action.BurstIsON
local AuraIsValid= Action.AuraIsValid
local InterruptIsValid                            = Action.InterruptIsValid
local DetermineUsableObject                        = Action.DetermineUsableObject
local Utils        = Action.Utils
local BossMods    = Action.BossMods
local TeamCache   = Action.TeamCache
local EnemyTeam    = Action.EnemyTeam
local FriendlyTeam= Action.FriendlyTeam
local LoC         = Action.LossOfControl
local Player    = Action.Player 
local MultiUnits= Action.MultiUnits
local ActiveUnitPlates                            = MultiUnits:GetActiveUnitPlates()
local UnitCooldown= Action.UnitCooldown
local Unit        = Action.Unit 
local IsUnitEnemy= Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local Combat    = Action.Combat
local DisarmIsReady= Action.DisarmIsReady
local Azerite     = LibStub("AzeriteTraits")
local ACTION_CONST_ROGUE_OUTLAW                 = CONST.ROGUE_OUTLAW
local ACTION_CONST_AUTOTARGET                    = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP        = CONST.SPELLID_FREEZING_TRAP
local IsIndoors, UnitIsUnit                        = _G.IsIndoors, _G.UnitIsUnit

Action[ACTION_CONST_ROGUE_OUTLAW] = {
    -- Racial
    ArcaneTorrent     = Create({ Type = "Spell", ID = 50613   }),
    BloodFury         = Create({ Type = "Spell", ID = 20572   }),
    Fireblood       = Create({ Type = "Spell", ID = 265221    }),
    AncestralCall   = Create({ Type = "Spell", ID = 274738    }),
    Berserking        = Create({ Type = "Spell", ID = 26297   }),
    ArcanePulse     = Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm     = Create({ Type = "Spell", ID = 107079    }),
    Haymaker= Create({ Type = "Spell", ID = 287712  }), 
    WarStomp= Create({ Type = "Spell", ID = 20549   }),
    BullRush= Create({ Type = "Spell", ID = 255654  }),    
    BagofTricks       = Create({ Type = "Spell", ID = 312411  }),    
    GiftofNaaru       = Create({ Type = "Spell", ID = 59544   }),
    LightsJudgment  = Create({ Type = "Spell", ID = 255647    }),
    Shadowmeld      = Create({ Type = "Spell", ID = 58984     }), -- usable in Action Core 
    Stoneform       = Create({ Type = "Spell", ID = 20594     }), 
    WilloftheForsaken                               = Create({ Type = "Spell", ID = 7744      }), -- usable in Action Core 
    EscapeArtist      = Create({ Type = "Spell", ID = 20589   }), -- usable in Action Core 
    EveryManforHimself                              = Create({ Type = "Spell", ID = 59752     }), -- usable in Action Core  
    Regeneratin     = Create({ Type = "Spell", ID = 291944    }), -- not usable in APL but user can Queue it
    -- general
    Stealth         = Create({ Type = "Spell", ID = 1784      }),
    InstantPoison   = Create({ Type = "Spell", ID = 315584    }),
    CripplingPoison = Create({ Type = "Spell", ID = 3408      }),
    NumbingPoison   = Create({ Type = "Spell", ID = 5761      }),
    WoundPoison     = Create({ Type = "Spell", ID = 8679      }),
    CrimsonVial     = Create({ Type = "Spell", ID = 185311    }),
    TricksOfTheTrade= Create({ Type = "Spell", ID = 57934     }),
    -- CDS
    AdrenalineRush      = Create({ Type = "Spell", ID = 186286 }),
    RollTheBones    = Create({ Type = "Spell", ID = 193316    }),
    --Covenants
    Sepsis = Create({ Type = "Spell", ID = 328305  }),
    SerratedBoneSpike                               = Create({ Type = "Spell", ID = 328547    }),
    EchoingReprimand= Create({ Type = "Spell", ID = 323547    }),
    Flagellation    = Create({ Type = "Spell", ID = 323654    }),
    ClaimFlagellation                               = Create({ Type = "Spell", ID = 346975, Hidden = true}),
    --rollthebonesbuff
    Broadside        = Create({ Type = "Spell", ID = 193356   }),
    BuriedTreasure  = Create({ Type = "Spell", ID = 199600    }),
    GrandMelee       = Create({ Type = "Spell", ID = 193358   }),
    RuthlessPrecision                               = Create({ Type = "Spell", ID = 193357    }),
    SkullandCrossbones = Create({ Type = "Spell", ID = 199603 }),
    TrueBearing        = Create({ Type = "Spell", ID = 193359 }),
    --Buffs
    SliceAndDice       = Create({ Type = "Spell", ID = 145418 }),
    DeeperStratagem    = Create({ Type = "Spell", ID = 193531                            }),
    Opportunity        = Create({ Type = "Spell", ID = 195627                            }),
    MarkedForDeath     = Create({ Type = "Spell", ID = 137619                           }),
    FlayedwingToxin    = Create({ Type = "Spell", ID = 345545, Hidden = true               }),
    Soulshape= Create({ Type = "Spell", ID = 310143                            }),
    Vanish  = Create({ Type = "Spell", ID = 1856                              }),
    VanishStealth      = Create({ Type = "Spell", ID = 11327, Hidden = true              }),
    SepsisStealth      = Create({ Type = "Spell", ID = 347037, Hidden = true               }),
    Elusiveness       = Create({ Type = "Spell", ID = 79008                              }),
    EchoingReprimandBuff                               = Create({ Type = "Spell", ID = 323558    , Hidden = true        }),        
    --kick
    Kick    = Create({ Type = "Spell", ID = 1766}),
    KickGreen= Create({ Type = "SpellSingleColor", ID = 1766, Hidden = true, Color = "GREEN", QueueForbidden = true        }),
    -- Rotation       
    Shiv   = Create({ Type = "Spell", ID = 5938   }),
    Ambush = Create({ Type = "Spell", ID = 8676   }),
    CheapShot       = Create({ Type = "Spell", ID = 1833   }),
    Dispatch        = Create({ Type = "Spell", ID = 2098   }),
    PistolShot      = Create({ Type = "Spell", ID = 185763 }),
    SinisterStrike  = Create({ Type = "Spell", ID = 1752   }),
    BladeFlurry     = Create({ Type = "Spell", ID = 13877  }),
    GhostlyStrike   = Create({ Type = "Spell", ID = 196937 }),
    KillingSpree    = Create({ Type = "Spell", ID = 51690  }),
    BladeRush       = Create({ Type = "Spell", ID = 271877 }),
    BetweenTheEyes  = Create({ Type = "Spell", ID = 199804 }),
    Gouge = Create({ Type = "Spell", ID = 1776   }),
    Blind 										= Create({ Type = "Spell", ID = 2094   }),
    Feint 										= Create({ Type = "Spell", ID = 1966   }),
    KidneyShot      = Create({ Type = "Spell", ID = 408    }), 
    Evasion         = Create({ Type = "Spell", ID = 5277     }), 
    CloakofShadows                               = Create({ Type = "Spell", ID = 31224      }), 
    
    -- Items
    PotionofUnbridledFury                        = Create({ Type = "Potion",  ID = 169299}), 
    BottledFlayedwingToxin                       = Create({ Type = "Trinket", ID = 178742, Hidden = true}),
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion                     = Create({ Type = "Trinket", ID = 161674}),    
    DreadCombatantsInsignia                      = Create({ Type = "Trinket", ID = 161676}),    
    DreadCombatantsMedallion                     = Create({ Type = "Trinket", ID = 161811, Hidden = true}),    -- Game has something incorrect with displaying this
    DreadGladiatorsBadge                         = Create({ Type = "Trinket", ID = 161902}),    
    DreadAspirantsMedallion                      = Create({ Type = "Trinket", ID = 162897}),    
    DreadAspirantsBadge                          = Create({ Type = "Trinket", ID = 162966}),    
    SinisterGladiatorsMedallion                  = Create({ Type = "Trinket", ID = 165055}),    
    SinisterGladiatorsBadge                      = Create({ Type = "Trinket", ID = 165058}),    
    SinisterAspirantsMedallion                   = Create({ Type = "Trinket", ID = 165220}),    
    SinisterAspirantsBadge                       = Create({ Type = "Trinket", ID = 165223}),    
    NotoriousGladiatorsMedallion                 = Create({ Type = "Trinket", ID = 167377}),    
    NotoriousGladiatorsBadge                     = Create({ Type = "Trinket", ID = 167380}),    
    NotoriousAspirantsMedallion                  = Create({ Type = "Trinket", ID = 167525}),    
    NotoriousAspirantsBadge                      = Create({ Type = "Trinket", ID = 167528}),    
}

Action:CreateEssencesFor(ACTION_CONST_ROGUE_OUTLAW)
local A = setmetatable(Action[ACTION_CONST_ROGUE_OUTLAW], { __index = Action })

local player= "player"
local Temp  = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys                         = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    BerserkerRageLoC                        = {"FEAR", "INCAPACITATE"},
    CastStartTime                            = {},
    IsSlotTrinketBlocked                    = {
        [A.BottledFlayedwingToxin.ID]                = true,    
        
    },
}; do        
    -- Push IsSlotTrinketBlocked
    for key, val in pairs(Action[ACTION_CONST_ROGUE_OUTLAW]) do 
        if type(val) == "table" and val.Type == "Trinket" then 
            Temp.IsSlotTrinketBlocked[val.ID] = true
        end 
    end 
end 

function Action:IsLatenced(delay)
    -- @return boolean 
    return TMW.time - (Temp.CastStartTime[self:Info()] or 0) > (delay or 0.1)
end




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

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unitID) 
    return 
    IsUnitEnemy(unitID) and  
    Unit(unitID):GetRange() <= 20 and 
    Unit(unitID):IsControlAble("stun") and 
    A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    -- if     A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun("target")
    -- then 
    --     return A.StormBoltGreen:Show(icon)         
    -- end                          
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


--[[
local function countInterruptGCD(unitID)
    if not A.Kick:IsReadyByPassCastGCD(unitID) or not A.Kick:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
        return true 
    end 
end 
--]]

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
end

local hasGoneinMelee = false
-- [3] Single Rotation
A[3] = function(icon)
    --local EnemyRotation, FriendlyRotation
    local isMoving             = Player:IsMoving()                          -- @boolean 
    local inCombat             = Unit(player):CombatTime()                  -- @number 
    local useAoE               = GetToggle(2, "AoE")                        -- @boolean 
    local inDisarm             = LoC:Get("DISARM") > 0                      -- @boolean 
    local inMelee              = A.Shiv:IsInRange(unitID)     				-- @boolean 
    local OOCStealth           = GetToggle(2, "OOCStealth")                 -- @boolean
    local NonLethalPoison        = GetToggle(2, "NonLethalPoison")          -- @string
    local LethalPoison            = GetToggle(2, "LethalPoison")            -- @string
    local VanishSetting            = GetToggle(2, "VanishSetting")          -- @boolean
    local Opener                = GetToggle(2, "Opener")                    -- @string
    local isStealthed           = Unit(player):HasBuffs(A.Stealth.ID) ~= 0  -- @boolean 
    local BladeRushRange       = GetToggle(2, "BladeRushRange") 			-- @number
    local MultiUnitsEight       = MultiUnits:GetByRange(8)                  -- @number of units in 8 yards
    local CPMax = (A.DeeperStratagem:IsTalentLearned() and 6 or 5) 			-- @integer 5 or 6
    local CPCurrent = (Player:ComboPoints())                       			-- @integer           
    local isBurst            = BurstIsON(unitID)							-- @boolean
    
    
    --Testing
    
    
    -- Rotations 
    function EnemyRotation(unitID)  
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        if UnitCanAttack(player, unitID) == false then return end
        --Stop Rotation if Vanish is set to off
        if Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0 and VanishSetting == 0 then return end
        if IsMounted() then return end
        
        
        --testing
        
        
        
        --Interrupts  
        -- Non GCD spell check
        local function countInterruptGCD(unitID)
            if not A.Kick:IsReadyByPassCastGCD(unitID) or not A.Kick:AbsentImun(unitID, Temp.TotalAndPhysKick) then
                return true
            end
        end
        
        if A.GetToggle(2, "InterruptList") --uses ryan interrupt table
        then
            useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(unitID, "RyanInterrupts", true, countInterruptGCD(unitID))
        else 
            useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(unitID)
        end    
        if useKick or useCC or useRacial then                     
            -- useKick
            if useKick 
            and castLeft > 0 
			and not notKickAble 
            and A.AbsentImun(nil, unitID, Temp.TotalAndPhysKick) 
            and A.Kick:IsReady(unitID) then 
                return A.Kick:Show(icon)
            end
            -- useCC / useRacial
            if not useKick or notKickAble or A.Kick:GetCooldown() > 0 then 
                if useCC 
                and (Unit(player):HasBuffs(A.Stealth.ID) ~= 0 or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0)
                and A.CheapShot:IsReady(unitID) 
                and A.CheapShot:AbsentImun(unitID, Temp.TotalAndPhysAndCC) 
                and Unit(unitID):GetDR("stun") > 0
                then 
                    return A.CheapShot:Show(icon)       
                end                 
                
                if useCC 
                and A.Gouge:IsReady(unitID) 
                and A.Gouge:AbsentImun(unitID, Temp.TotalAndPhysAndCC) 
                and Player:IsBehind(.3) 
                and  Unit(unitID):GetDR("incapacitate") > 0 
                then 
                    return A.Gouge:Show(icon)       
                end 
                
                if useCC 
                and A.KidneyShot:IsReady(unitID) 
                and A.KidneyShot:AbsentImun(unitID, Temp.TotalAndPhysAndCC) 
                and Player:ComboPoints() >= 1 
                and  Unit(unitID):GetDR("stun") > 0
                then 
                    return A.KidneyShot:Show(icon)       
                end 
                
                if useRacial 
                and A.QuakingPalm:IsReady(unitID) 
                and A.QuakingPalm:AbsentImun(unitID, Temp.TotalAndPhysAndCC)  
                and  Unit(unitID):GetDR("incapacitate") > 0 
                then 
                    return A.QuakingPalm:Show(icon)                    
                end         
                if useCC  
                and A.Blind:IsReady(unitID) and A.Blind:AbsentImun(unitID, Temp.TotalAndPhysAndCC) 
                and Unit(unitID):GetDR("disorient") > 0 
                then 
                    return A.Blind:Show(icon)
                end 
            end
        end
        
        -- kill Explosive Affix
        if Unit(unitID):IsExplosives() and A.SinisterStrike:IsReady(unitID) then
            return A.SinisterStrike:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.PistolShot:IsReady(unitID) and not InMelee(unitID) then
            return A.PistolShot:Show(icon)
        end

        --Shiv Enrages
        if A.Shiv:IsReady(unitID) and Unit(player):HasBuffs(A.NumbingPoison.ID) ~= 0 and Action.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then
            return A.Shiv:Show(icon)
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
        
        local function Defensives()
            --defensives    
            local Evasion = GetToggle(2, "Evasion")
            if Evasion >= 0 and A.Evasion:IsReady(player) and not isStealthed and 
            (( -- Auto 
                    Evasion >= 100 and
                    (
                        -- HP lose per sec >= 20
                        Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 50 or Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.50 or 
                        -- TTD 
                        Unit(player):TimeToDieX(25) < 2 or (A.IsInPvP and Unit(player):HealthPercent() <= 40 and (Unit(player):UseDeff() or (Unit(player, 5):HasFlags() and Unit(player):GetRealTimeDMG() > 0 and Unit(player):IsFocused() )))) and Unit(player):HasBuffs("DeffBuffs", true) == 0) or 
                (   -- Custom
                    Evasion < 100 and Unit(player):HealthPercent() <= Evasion)) 
            then 
                return A.Evasion:Show(icon)
            end
            -- CloakofShadows
            local CloakofShadows = GetToggle(2, "CloakofShadows")
            if CloakofShadows >= 0 and A.CloakofShadows:IsReady(player) and 
            ((     -- Auto 
                    CloakofShadows >= 100 and Unit(player):TimeToDieMagicX(25) < 2 and 
                    -- Magic Damage still appear
                    Unit(player):GetRealTimeDMG(4) > 0 and Unit(player):HasBuffs("DeffBuffsMagic") == 0) or 
                (    -- Custom
                    CloakofShadows < 100 and Unit(player):HealthPercent() <= CloakofShadows)) 
            then 
                return A.CloakofShadows:Show(icon)
            end
            -- Feint
            local Feint = GetToggle(2, "Feint")        
            if Feint >= 0 and A.Feint:IsReady(player) and
            ((    -- Auto
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
            -- Stoneform (Self Dispel)
            if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then 
                return A.Stoneform:Show(icon)
            end
        end
		
        -- [[ Opener ]]
        local function Opener()
            local Opener                = GetToggle(2, "Opener")                     -- @string from ProfileUI
            if Opener == "OFF" then return true end
            if A.MarkedForDeath:IsReady(unitID) 
            and (not GetToggle(1, "BossMods") or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 7))            
            then
                return A.MarkedForDeath:Show(icon)
            end
            if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5 
            and (not GetToggle(1, "BossMods") or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 3))
            then
                return A.SliceAndDice:Show(icon)
            end
            if CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0)) 
            and ((not GetToggle(1, "BossMods") and inMelee) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 1.8))
            then
                return A.RollTheBones:Show(icon)
            end    
            if Opener == "Ambush" then
                if A.Ambush:IsReady(unitID) 
                and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0)
                then
                    return A.Ambush:Show(icon)
                end
            end
	        if Opener == "CheapShot" then
                if A.CheapShot:IsReady(unitID) 
                and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0)
                then		
                return A.CheapShot:Show(icon)
            end
            -- Tricks with boss mods  works ok in raid use only with @focus macro and Boss Timers checked         TODO: Check for IsReady("focus") on Tricks on Focus mounted, range, in party, etc. might spam tricks during pull timer, but wont stop rotation
            if GetToggle(2, "Tricks") and A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2.5)then
                return A.TricksOfTheTrade:Show(icon)
            end    
        end
		
        -- [[ finishers ]]
        local function Finishers() 
            local EchoingBuffCount = Unit(player):HasBuffsStacks(A.EchoingReprimandBuff.ID)
            local Broadside = (Unit(player):HasBuffs(A.Broadside.ID) >= 1) --@boolean
            if (A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) < (1 + CPCurrent * 1.8  )) and ((Player:ComboPointsDeficit() <= 1) or (Broadside and (Player:ComboPointsDeficit() <= 2))) then
                return A.SliceAndDice:Show(icon)
            end
            if A.BetweenTheEyes:IsReady(unitID) and ((Player:ComboPointsDeficit() <= 1 or CPCurrent == EchoingBuffCount) or (Broadside and (Player:ComboPointsDeficit() <= 2))) then
                return A.BetweenTheEyes:Show(icon)
            end
            if A.Dispatch:IsReady(unitID) and ((Player:ComboPointsDeficit() <= 1 or CPCurrent == EchoingBuffCount) or (Broadside and (Player:ComboPointsDeficit() <= 2))) then
                return A.Dispatch:Show(icon)
            end
        end
		
        -- [[ CDs ]]
        local function CDs()
            local EightYardTTD = GetByRangeTTD(MultiUnitsEight,8) --@number average time to die of all targets in 8 yards
            local Item = UseItems(unitID)
            if Item and not isStealthed then --prevent all items in stealth
                return Item:Show(icon)
            end
            if A.Fireblood:IsReady(unitID, true) then
                return A.Fireblood:Show(icon)
            end
            if A.Berserking:IsReady(unitID, true) then
                return A.Berserking:Show(icon)
            end
            if A.BloodFury:IsReady(unitID, true) then
                return A.BloodFury:Show(icon)
            end
            if A.LightsJudgment:IsReady(unitID, true) then
                return A.LightsJudgment:Show(icon)
            end
            if (A.Flagellation:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Flagellation.ID) == 0 and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and not isStealthed)
            or (Unit(unitID):HasDeBuffs(A.Flagellation.ID) > 0 and Unit(unitID):HasDeBuffs(A.Flagellation.ID) <= 2 or Unit(unitID):HasDeBuffsStacks(A.Flagellation.ID) >= 30) then
                return A.Flagellation:Show(icon)
            end
            if A.AdrenalineRush:IsReady(unitID, true) and Unit(player):HasBuffs(A.AdrenalineRush.ID) == 0 and inMelee and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and not isStealthed then
                return A.AdrenalineRush:Show(icon)
            end
            if CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0)) and inMelee and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0)then
                return A.RollTheBones:Show(icon)
            end    
            --AoE (bladeflurry is also in ST(), this is to ensure correct prioitizaion for isBurst on and off. The intent is for useAoE to control bladeflurry, not isBurst.
            if A.BladeFlurry:IsReady(unitID, true) and useAoE and MultiUnitsEight >= 2 and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2 and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) then
                return A.BladeFlurry:Show(icon)
            end            
            if A.MarkedForDeath:IsReady(unitID) 
            and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0)
            then
                return A.MarkedForDeath:Show(icon)
            end
            if A.GhostlyStrike:IsReady(unitID, true) and not isStealthed  then
                return A.GhostlyStrike:Show(icon)
            end
            if A.KillingSpree:IsReady(unitID) and not isStealthed and Player:EnergyTimeToMax() >= 2.5 and ((MultiUnitsEight >= 2 and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0) or MultiUnitsEight <= 1) then
                return A.KillingSpree:Show(icon)
            end
            if A.BladeRush:IsReady(unitID) and not isStealthed and (MultiUnitsEight <= 1 or (MultiUnitsEight >= 2 and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0)) and ((BladeRushRange <= 6 and inMelee) or (BladeRushRange >= 6))then
                return A.BladeRush:Show(icon)
            end
            -- Use Vanish if setting is set to Auto
            if A.Vanish:IsReady(player) and VanishSetting == 2 and A.Ambush:IsInRange(unitID) and Player:Energy() >= 55 and inCombat > 0 and CPMax-CPCurrent >= 2 and Unit(player):HasBuffs(A.SkullandCrossbones.ID) == 0 then
                return A.Vanish:Show(icon) 
            end            
            --Use Ambush from Maunal or Auto Vanish
            if (Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0 or (Action.LastPlayerCastID == 1856 and not isStealthed)) and VanishSetting >=1 and A.Ambush:IsInRange(unitID) then
                return A.Ambush:Show(icon)  
            end
            if (A.SerratedBoneSpike:IsReady(unitID) and not isStealthed and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and (Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID) == 0 or A.SerratedBoneSpike:GetSpellChargesFrac() >= 2.95 )) or (A.SerratedBoneSpike:IsReady("mouseover") and IsUnitEnemy("mouseover") and Unit("mouseover"):HasDeBuffs(A.SerratedBoneSpike.ID) == 0  and EightYardTTD > 4) then
                return A.SerratedBoneSpike:Show(icon)
            end
            if A.Sepsis:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and not isStealthed then
                return A.Sepsis:Show(icon)
            end
            if A.EchoingReprimand:IsReady(unitID) and not isStealthed and (EightYardTTD > 4 or Unit(unitID):IsBoss())  then
                return A.EchoingReprimand:Show(icon)
            end
        end
        
        -- [[ Single Target ]]
        local function ST()
            local CPMax = (A.DeeperStratagem:IsTalentLearned() and 6 or 5) --@integer 5 or 6
            local CPCurrent = (Player:ComboPoints())                       --@integer
            local Broadside = (Unit(player):HasBuffs(A.Broadside.ID) >= 1) --@boolean
            
            --AoE (bladeflurry is also in CD(), this is to ensure correct prioitizaion for Burst on and off. The intent is for useAoE to control bladeflurry, not isBurst.
            if A.BladeFlurry:IsReady(unitID, true) and useAoE and MultiUnitsEight >= 2 and GetByRangeTTD(MultiUnitsEight,8) > 4 and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2 and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) then
                return A.BladeFlurry:Show(icon)
            end
            --Covenant Builders    
            if Unit(player):HasBuffs(A.SepsisStealth.ID) ~= 0 and A.Ambush:IsInRange(unitID) then
                return A.Ambush:Show(icon) 
            end
            --Builders
            if (A.PistolShot:IsReady(unitID, true) and Unit(player):HasBuffs(A.Opportunity.ID) ~= 0) and ((Broadside and CPMax-CPCurrent >= 3) or (not Broadside and CPMax-CPCurrent >= 2))then
                return A.PistolShot:Show(icon)
            end
            if A.SinisterStrike:IsReady(unitID) then
                return A.SinisterStrike:Show(icon)
            end
            --InCombat Ranged GCD filler
            if A.PistolShot:IsReady(unitID) and Player:Energy() >=90 and Unit(unitID):HealthPercent() < 100 and not inMelee  then
                return A.PistolShot:Show(icon)
            end
        end
        --end
        
        --DEFENSIVES
        if Defensives() then    
            return true
        end
        -- OPENER
        if Opener() and isStealthed and Opener ~= "OFF" then
            return true
        end
        -- CDs need to re enable isBurst once fixed
        if CDs() and isBurst then
            return true 
        end
        -- FINISHERS
        if Finishers() and not isStealthed then
            return true
        end
        --Single Target
        if ST() and not isStealthed then
            return true
        end
        
        -- GiftofNaaru
        if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then 
            return A.GiftofNaaru:Show(icon)
        end            
    end   
    
    --Use BottledFlayedwingToxin if out of combat with other poison. before stealth
    if A.BottledFlayedwingToxin:IsReady(unitID, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 and inCombat == 0 and not IsMounted() then
        return A.BottledFlayedwingToxin:Show(icon)
    end
    if OOCStealth and A.Stealth:IsReady(unitID, true) and A.Stealth:IsLatenced(GetGCD() + 0.5) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and Unit(player):HasBuffs(A.VanishStealth.ID) == 0 and Unit(player):HasBuffs(A.Soulshape.ID) == 0 and inCombat == 0 and not IsMounted() then
        return A.Stealth:Show(icon)
    end
    --Poisons use UI settings to check if poison selected is ready, already applied and ooc
    if LethalPoison == "InstantPoison" then
        if A.InstantPoison:IsReady(unitID, true) and A.InstantPoison:IsLatenced(GetGCD() + 0.5)  and Unit(player):HasBuffs(A.InstantPoison.ID) == 0 and inCombat == 0 and not IsMounted() then
            return A.InstantPoison:Show(icon)
        end
    end
    if LethalPoison == "WoundPoison" then
        if A.WoundPoison:IsReady(unitID, true) and A.InstantPoison:IsLatenced(GetGCD() + 0.5)  and Unit(player):HasBuffs(A.WoundPoison.ID) == 0 and inCombat == 0 and not IsMounted() then
            return A.WoundPoison:Show(icon)
        end
    end
    if NonLethalPoison == "NumbingPoison" then
        if A.NumbingPoison:IsReady(unitID, true) and A.InstantPoison:IsLatenced(GetGCD() + 0.5)  and Unit(player):HasBuffs(A.NumbingPoison.ID) == 0 and inCombat == 0 and not IsMounted() then
            return A.NumbingPoison:Show(icon)
        end
    end
    if NonLethalPoison == "CripplingPoison" then
        if A.CripplingPoison:IsReady(unitID, true) and A.InstantPoison:IsLatenced(GetGCD() + 0.5)  and Unit(player):HasBuffs(A.CripplingPoison.ID) == 0 and inCombat == 0 and not IsMounted() then
            return A.CripplingPoison:Show(icon)
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
    local MOExplosive    = GetToggle(2, "MOExplosive")
    local MOTotem        = GetToggle(2, "MOTotem")
    
    if MOExplosive and IsUnitEnemy("mouseover") and Unit("mouseover"):IsExplosives() or MOTotem and IsUnitEnemy("mouseover") and Unit("mouseover"):IsTotem() then 
        return A:Show(icon, ACTION_CONST_LEFT)
    end
end 
A[7] = nil 
A[8] = nil 

