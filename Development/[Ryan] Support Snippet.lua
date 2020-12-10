local _G, select, setmetatable                            = _G, select, setmetatable

local TMW                                                 = _G.TMW

local A                                                 = _G.Action

local Unit                                                = A.Unit
local GameLocale                                        = A.FormatGameLocale(_G.GetLocale())
local StdUi                                                = A.StdUi
local Factory                                            = StdUi.Factory
local math_random                                        = math.random
local player                                             = "player"
partyIDs                                                = {
    [1] = "party1",
    [2] = "party2",
}
arenaIDs                                            = {
    [1] = "arena1",
    [2] = "arena2",
    [3] = "arena3",
}


local L                                                = setmetatable(
    {
        ruRU                                         = {InterruptName         = "SLs Mythic+ (by Ryan)",},
        enUS                                         = {InterruptName         = "SLs Mythic+ (by Ryan)",},
    }, 
    { __index = function(t) return t.enUS end })

TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
        local CL = Action.GetCL()
        Category.options[#Category.options + 1] = { text = L[GameLocale].InterruptName, value = "RyanInterrupts" }
        Category:SetOptions(Category.options)
end)




Factory[4].RyanInterrupts = StdUi:tGenerateMinMax({
        [GameLocale] = {
            ISINTERRUPT = true,
            --De Other Side
            [332329] = { useKick = false, useCC = true, useRacial = true    }, --Devoted Sacrifice;         CC
            [332671] = { useKick = false, useCC = true, useRacial = true    }, --Bladestorm;                CC
            [332666] = { useKick = true, useCC = false, useRacial = false   }, --Renew;                     Kick
            [332706] = { useKick = true, useCC = false, useRacial = false   }, --Heal;                      Kick
            [332612] = { useKick = true, useCC = false, useRacial = false   }, --Healing Wave;              Kick
            [331927] = { useKick = false, useCC = false, useRacial = false  }, --Haywire;                   Block
            [332084] = { useKick = true, useCC = false, useRacial = false   }, --Self-Cleaning Cycle;       Kick
            [340026] = { useKick = false, useCC = true, useRacial = true    }, --Wailing Grief;             CC
            [321764] = { useKick = true, useCC = false, useRacial = false   }, --Bark Armor;         		Kick	
            [320008] = { useKick = true, useCC = false, useRacial = false   }, --Frostbolt;         		Kick
            [332608] = { useKick = true, useCC = false, useRacial = false   }, --Lightning Discharge;       Kick	
            [328729] = { useKick = true, useCC = false, useRacial = false   }, --Dark Lotus;         		Kick	
            [332605] = { useKick = true, useCC = true, useRacial = true     }, --Hex;                 		Kick+CC
            -- Halls of Attonement
            [325523] = { useKick = false, useCC = true, useRacial = true    }, --Deadly Thrust;             CC
            [326450] = { useKick = false, useCC = true, useRacial = true    }, --Loyal Beasts;              CC
            [325700] = { useKick = true, useCC = false, useRacial = false   }, --Collect Sins;              Kick
            [325701] = { useKick = true, useCC = true, useRacial = true     }, --Siphon Life;               Kick+CC
            [326607] = { useKick = true, useCC = false, useRacial = false   }, --Turn to Stone;             Kick
            -- Mists of Tirna Scithe
            [322938] = { useKick = true, useCC = false, useRacial = false   }, --Harvest Essence;           Kick
            [322486] = { useKick = false, useCC = true, useRacial = true    }, --Overgrowth;                CC
            [324914] = { useKick = true, useCC = false, useRacial = false   }, --Nourish the Forest;        Kick
            [324776] = { useKick = true, useCC = false, useRacial = false   }, --Bramblethorn Coat;         Kick
            [326046] = { useKick = true, useCC = true, useRacial = true     }, --Stimulate Resistance;      Kick+CC            
            [340544] = { useKick = true, useCC = true, useRacial = true     }, --Stimulate Regeneration;    Kick+CC    
            [337235] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Pacification;    Kick
            [337251] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Incapacitation;  Kick
            [337253] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Domination;      Kick
            -- Necrotic Wake
            [334748] = { useKick = true, useCC = true, useRacial = true     }, --Drain Fluids;              Kick+CC
            [320462] = { useKick = true, useCC = false, useRacial = false   }, --Necrotic Bolt;             Kick            
            [324293] = { useKick = true, useCC = true, useRacial = true     }, --Rasping Scream;            Kick+CC            
            [320170] = { useKick = true, useCC = false, useRacial = false   }, --Necrotic Bolt;             Kick            
            [338353] = { useKick = true, useCC = true, useRacial = true     }, --Goresplatter;                Kick+CC
            [334748] = { useKick = true, useCC = true, useRacial = true     }, --Drain Fluids;                Kick+CC
            --Plaguefall
            [328177] = { useKick = false, useCC = true, useRacial = true    }, --Fungistorm;                CC            
            [330403] = { useKick = false, useCC = true, useRacial = true    }, --Wing Buffet;                CC (need to check)            
            [318949] = { useKick = false, useCC = true, useRacial = true    }, --Festering Belch;            CC            
            [319070] = { useKick = true, useCC = false, useRacial = false   }, --Corrosive Gunk;            Kick            
            [336451] = { useKick = false, useCC = true, useRacial = true    }, --Bulwark of Maldraxxus;     CC            
            [328400] = { useKick = false, useCC = true, useRacial = true    }, --Stealthlings;                CC            
            --Sanguine Depths
            [319654] = { useKick = true, useCC = false, useRacial = false   }, --Hungering Drain;             Kick
            [322433] = { useKick = true, useCC = false, useRacial = false   }, --Stoneskin;                 Kick
            [321038] = { useKick = true, useCC = false, useRacial = false   }, --Wrack Soul;                Kick            
            --Spires of Ascension
            [327413] = { useKick = false, useCC = true, useRacial = true    }, --Rebellious Fist;            CC            
            [317936] = { useKick = true, useCC = false, useRacial = false   }, --Forsworn Doctrine;         Kick            
            [317963] = { useKick = true, useCC = false, useRacial = false   }, --Burden of Knowledge;         Kick
            [328295] = { useKick = true, useCC = true, useRacial = true     }, --Greater Mending;            Kick+CC
            [328137] = { useKick = true, useCC = false, useRacial = false   }, --Dark Pulse;                Kick
            [328331] = { useKick = true, useCC = false, useRacial = false   }, --Forced Confession;            Kick
            --Theater of Pain
            [341902] = { useKick = true, useCC = false, useRacial = false   }, --Unholy Fervor;                Kick            
            [341969] = { useKick = true, useCC = false, useRacial = false   }, --Withering Discharge;      Kick
            [342139] = { useKick = true, useCC = false, useRacial = false   }, --Battle Trance;         Kick        
            [330562] = { useKick = true, useCC = false, useRacial = false   }, --Demoralizing Shout;    Kick
            [330810] = { useKick = true, useCC = true, useRacial = true     }, --Bind Soul;             Kick+CC      
			-- Castle Nathria
            [325590] = { useKick = true, useCC = false, useRacial = false   }, --Scornful Blast;		Kick
            [328254] = { useKick = true, useCC = false, useRacial = false   }, --Shattering Ruby;		Kick
            [333002] = { useKick = true, useCC = false, useRacial = false   }, --Vulgar Brand;			Kick
            [337110] = { useKick = true, useCC = false, useRacial = false   }, --Dreadbolt Volley;		Kick
			
			
			
            --[[ Templates
            [] = { useKick = false, useCC = false, useRacial = false}    , -- Block
            [] = { useKick = true, useCC = true, useRacial = true    }, -- Kick+CC
            [] = { useKick = true, useCC = false, useRacial = false    }, -- Kick
            [] = { useKick = false, useCC = true, useRacial = true    }, -- CC
            --]]
            
        },
    }, 43, 70, math_random(87, 95), true)

