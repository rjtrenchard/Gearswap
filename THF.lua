-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false

    include('Mote-TreasureHunter')

    -- For herculean.th.action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S { 35, 204 }
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S { 201, 202, 203, 205, 207 }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    state.OffenseMode:options('Normal', 'Acc', 'Crit')
    state.HybridMode:options('Normal', 'PDT', 'MDT', 'Evasion')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^- gs c cycle DoomMode')

    send_command('bind numpad7 gs equip sets.Weapons.Daggers')
    send_command('bind numpad8 gs equip sets.Weapons.Naegling')
    send_command('bind numpad9 gs equip sets.Weapons.Tauret')
    send_command('bind numpad4 gs equip sets.Weapons.DI')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
    send_command('unbind numpad6')
    send_command('unbind numpad7')
    send_command('unbind numpad8')
    send_command('unbind numpad9')
    send_command('unbind !`')
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind ^-')
    send_command('unbind ^`')
    send_command('unbind ^=')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Augmented Gear definitions
    --------------------------------------
    gear.melee_cape = { name = "Toutatis's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+1', '"Store TP"+10', 'Phys. dmg. taken-10%', } }

    gear.crit_cape = { name = "Toutatis's Cape",
        augments = { 'DEX+3', 'Accuracy+20 Attack+20', 'Crit.hit rate+7', 'DEX+4' } }
    gear.dex_ws_cape = { name = "Toutatis's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Weapon skill damage +10%', } }
    -- gear.agi_ws_cape = { name = "Toutatis's Cape",
    --     augments = { 'AGI+20', 'Accuracy+20 Attack+20', 'Weapon skill damage +10%', 'AGI+10' } }
    gear.str_ws_cape = gear.dex_ws_cape

    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1", }

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = { ammo = "Yamarang",
        head = "Nyame Helm", neck = "Bathy Choker +1", ear1 = "Odnowa Earring +1", ear2 = "Etiolation Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Skadi's Jambeaux +1" }

    sets.idle.Town = { ammo = "Yamarang",
        head = "Shaded Spectacles", neck = "Smithy's Torque", ear1 = "Odnowa Earring +1", ear2 = "Etiolation Earring",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Skadi's Jambeaux +1" }

    sets.idle.Weak = sets.idle


    -- Defense sets

    sets.defense.Evasion = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Bathy Choker +1", ear1 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Turms Mittens +1", ring1 = "Moonlight ring", ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Turms Leggings +1" }

    sets.defense.PDT = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Nyame Sollerets" }

    sets.defense.MDT = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Eabani Earring", ear2 = "Crepuscular Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Archon Ring", ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Sailfi Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = { ammo = "Perfect Lucky Egg",
        head = gear.herculean.th.head, neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1",
        ear2 = "Etiolation Earring",
        body = gear.herculean.th.body, hands = "Plunderer's Armlets +3", ring1 = "Moonlight Ring",
        ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Chaac Belt", legs = gear.herculean.th.legs, feet = "Skulker's Poulaines +1" }
    sets.TreasureHunterTag = { ammo = "Perfect Lucky Egg", hands = "Plunderer's Armlets +3" }
    sets.ExtraRegen = {}
    sets.Kiting = { feet = "Skadi's Jambeaux +1" }

    --sets.buff['Feint'] = {legs="Plunderer's Culottes"}

    -- Normal melee group
    sets.Weapons = {}
    sets.Weapons.Naegling = { main = "Naegling", sub = "Centovente" }
    sets.Weapons.Daggers = { main = "Aeneas", sub = "Crepuscular Knife" }
    sets.Weapons.Tauret = { main = "Tauret", sub = "Crepuscular Knife" }
    sets.Weapons.DI = { main = "Voluspa Knife", sub = "Crepuscular Knife" }

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter

    sets.buff['Sneak Attack'] = { ammo = "Cath Palug Stone",
        head = "Adhemar Bonnet +1", neck = "Combatant's Torque", ear1 = "Sherida Earring", ear2 = "Odr Earring",
        body = "Pillager's Vest +2", hands = "Skulker's Armlets +1", ring1 = "Regal Ring", ring2 = "Ilabrat Ring",
        back = gear.melee_cape, waist = "Chaac Belt", legs = "Pillager's Culottes +1", feet = "Plunderer's Poulaines +3" }

    sets.buff['Trick Attack'] = { ammo = "Cath Palug Stone",
        head = "Adhemar Bonnet +1", neck = "Combatant's Torque", ear1 = "Sherida Earring",
        body = "Pillager's Vest +2", hands = "Pillager's armlets +1", ring1 = "Regal Ring", ring2 = "Ilabrat Ring",
        back = gear.melee_cape, waist = "Chaac Belt", legs = "Pillager's Culottes +1", feet = "Plunderer's Poulaines +3" }

    sets.buff.doom = set_combine(sets.defense.PDT,
        { neck = "Nicander's Necklace", ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring", waist = "Gishdubar Sash" })
    sets.buff.doom.HolyWater = set_combine(sets.defense.PDT,
        { neck = "Nicander's Necklace", ring1 = "Blenmot's Ring +1", ring2 = "Blenmot's Ring +1" })

    sets.resist = {}
    sets.resist.death = { main = "Odium",
        body = "Samnuha Coat", ring1 = "Shadow Ring", ring2 = "Eihwaz Ring"
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = { head = "Skulker's Bonnet" }
    sets.precast.JA['Accomplice'] = { head = "Skulker's Bonnet" }
    sets.precast.JA['Flee'] = { feet = "Pillager's Poulaines +2" }
    sets.precast.JA['Hide'] = { body = "Pillager's Vest +2" }
    sets.precast.JA['Conspirator'] = { body = "Skulker's Vest" }
    sets.precast.JA['Steal'] = { ammo = "barathrum",
        head = "Plunderer's Bonnet", hands = "Pillager's Armlets +1",
        legs = "Pillager's Culottes +1", feet = "Pillager's Poulaines +2" }
    sets.precast.JA['Despoil'] = set_combine(sets.precast.JA['Steal'],
        { ammo = "Barathrum", legs = "Skulker's Culottes", feet = "Skulker's poulaines +1" })
    sets.precast.JA['Mug'] = { ammo = "Cath Palug Stone",
        head = "Blistering Sallet +1", neck = "Republican Platinum medal", ear1 = "Shedir Earring", ear2 = "Odr Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Regal Ring", ring2 = "Ilabrat Ring",
        back = "Sacro Mantle", waist = "Chaac belt", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.precast.JA['Perfect Dodge'] = { hands = "Plunderer's Armlets +3" }
    sets.precast.JA['Feint'] = { legs = "Plunderer's Culottes" } -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head = "Gleti's Mask",
        body = "Gleti's Cuirass", hands = "Plunderer's Armlets +3",
        back = gear.crit_cape, waist = "Chaac Belt", legs = "Malignance Tights", feet = "Plunderer's Poulaines +3"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = { ammo = "Sapience Orb",
        head = gear.herculean.fc.head, neck = "Orunmila's Torque", ear1 = "Loquacious Earring",
        ear2 = "Enchanter's Earring +1",
        body = "Adhemar Jacket +1", hands = "Leyline Gloves", ring1 = "Weatherspoon Ring +1", ring2 = "Rahab Ring",
        legs = "Enif Cosciales"
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck = "Magoraga Beads" })

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Seething Bomblet +1",
        head = "Adhemar Bonnet +1", neck = "Fotia Gorget", ear1 = "Sherida Earring", ear2 = "Moonshade Earring",
        body = "Gleti's Cuirass", hands = "Meghanada Gloves +2", ring1 = "Regal Ring", ring2 = "Epaminondas's Ring",
        back = gear.str_ws_cape, waist = "Fotia Belt", legs = "Samnuha Tights", feet = "Plunderer's poulaines +3" }
    sets.precast.WS.Crit = set_combine(sets.precast.WS, { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", ear1 = "Odr Earring",
        body = "Pillager's Vest +2", hands = "Gleti's Gauntlets", ring1 = "Begrudging Ring", ring2 = "Hetairoi Ring",
        back = gear.crit_cape, legs = "Gleti's Breeches", feet = "Gleti's Boots", })

    sets.precast.WS.SingleHit = set_combine(sets.precast.WS, {
        head = "Nyame Helm",
        body = "Nyame Mail", hands = "Meghanada Gloves +2",
        legs = "Nyame Flanchard", feet = "Nyame Sollerets",
    })
    sets.precast.WS.Acc = set_combine(sets.precast.WS, { ammo = "Cath Palug Stone" })
    sets.precast.WS.Low = set_combine(sets.naked,
        { main = "", sub = "", range = "", head = "Malignance Chapeau", neck = "Fotia Gorget",
            body = "Malignance Tabard", hands = "Malignance Gloves", waist = "Fotia Belt", legs = "Malignance Tights",
            feet = "Malignance Boots" })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS,
        { ammo = "Cath Palug Stone", ear2 = "Skulker's Earring +1", hands = "Adhemar Wristbands +1", ring2 = "Gere Ring" })
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].Att = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Att, {})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Att, {})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Att, {})
    sets.precast.WS['Exenterator'].Low = sets.precast.WS.Low
    sets.precast.WS['Exenterator'].MaxTP = { ear2 = "Brutal Earring" }

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, { ring1 = "Regal Ring", legs = "Samnuha Tights" })
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Att = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Att, {})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Att, {})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Att, {})
    sets.precast.WS['Dancing Edge'].Low = sets.precast.WS.Low

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.Crit,
        { ear1 = "Odr Earring", ear2 = "Skulker's Earring +1" })
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].Att = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Att, {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Att, {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Att, {})
    sets.precast.WS['Evisceration'].Low = sets.precast.WS.Low

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, { ammo = "Oshasha's Treatise",
        head = "Nyame Helm", neck = "Caro Necklace", ear1 = "Ishvara Earring",
        ear2 = "Moonshade Earring",
        body = "Pillager's Vest +2",
        back = gear.dex_ws_cape, waist = "Kentarch Belt +1" })
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].Att = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Att,
        { head = "Pillager's Bonnet +3", ammo = "Yetshila +1", body = "Pillager's Vest +2" })
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Att,
        { head = "Pillager's Bonnet +3", ammo = "Yetshila +1", body = "Pillager's Vest +2" })

    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Att,
        { head = "Pillager's Bonnet +3", ammo = "Yetshila +1", body = "Pillager's Vest +2" })

    sets.precast.WS["Rudra's Storm"].Low = sets.precast.WS.Low
    sets.precast.WS["Rudra's Storm"].MaxTP = { ear1 = "Sherida Earring", ear2 = "Ishvara Earring" }

    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS["Rudra\'s Storm"],
        { head = "Pillager's Bonnet +3", ear2 = "Moonshade Earring", ring1 = "Epona's Ring" })
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'],
        { ammo = "Honed Tathlum", back = gear.dex_ws_cape })
    sets.precast.WS['Shark Bite'].Att = set_combine(sets.precast.WS['Shark Bite'], { ring2 = "Ilabrat Ring" })
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Att, { ammo = "Yetshila +1",
        body = "Pillager's Vest +2", legs = "Pillager's Culottes +1" })
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Att, { ammo = "Yetshila +1",
        body = "Pillager's Vest +2", legs = "Pillager's Culottes +1" })
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Att, { ammo = "Yetshila +1",
        body = "Pillager's Vest +2", legs = "Pillager's Culottes +1" })
    sets.precast.WS['Shark Bite'].Low = sets.precast.WS.Low

    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS['Rudra\'s Storm'],
        { head = "Pillager's Bonnet +3", ear2 = "Moonshade Earring" })
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {})
    sets.precast.WS['Mandalic Stab'].Att = set_combine(sets.precast.WS['Mandalic Stab'], {})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Att, { ammo = "Yetshila +1",
        body = "Pillager's Vest +2", legs = "Pillager's Culottes +1" })
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Att, { ammo = "Yetshila +1",
        body = "Pillager's Vest +2", legs = "Pillager's Culottes +1" })
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Att, { ammo = "Yetshila +1",
        body = "Pillager's Vest +2", legs = "Pillager's Culottes +1" })
    sets.precast.WS['Mandalic Stab'].Low = sets.precast.WS.Low
    sets.precast.WS['Mandalic Stab'].MaxTP = { ear1 = "Sherida Earring", ear2 = "Ishvara Earring" }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { ammo = "Seething Bomblet +1",
        head = "Pillager's Bonnet +3", neck = "Republican Platinum medal", ear1 = "Ishvara Earring",
        back = gear.str_ws_cape, waist = "Sailfi Belt +1",
    })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Savage Blade'].Att = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Savage Blade'].SA = set_combine(sets.precast.WS['Savage Blade'], { ammo = "Yetshila +1" })
    sets.precast.WS['Savage Blade'].TA = set_combine(sets.precast.WS['Savage Blade'], { ammo = "Yetshila +1" })
    sets.precast.WS['Savage Blade'].SATA = set_combine(sets.precast.WS['Savage Blade'], { ammo = "Yetshila +1" })
    sets.precast.WS['Savage Blade'].Low = sets.precast.WS.Low
    sets.precast.WS['Savage Blade'].MaxTP = { ear1 = "Sherida Earring", ear2 = "Ishvara Earring" }

    sets.precast.WS['Aeolian Edge'] = { ammo = "Seething Bomblet +1",
        head = "Herculean Helm", neck = "Baetyl Pendant", ear1 = "Hecate's Earring", ear2 = "Friomisi Earring",
        body = "Malignance Tabard", hands = "Herculean Gloves", ring1 = "Dingir Ring", ring2 = "Ilabrat Ring",
        back = gear.dex_ws_cape, waist = "Eschan Stone", legs = gear.herculean.ws.legs, feet = "Malignance Boots" }


    --sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

    sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunterTag)

    sets.precast.WS['Energy Drain'] = set_combine(sets.precast.WS['Aeolian Edge'],
        { head = "Pixie Hairpin +1", ring2 = "Archon Ring" })
    sets.precast.WS['Energy Steal'] = sets.precast.WS['Energy Drain']


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head = "Malignance Chapeau", ear1 = "Enchanter's Earring +1", ear2 = "Loquacious Earring",
        body = "Malignance Tabard", hands = "Weatherspoon Ring +1", ring1 = "Rahab Ring",
        waist = "Sailfi Belt +1", legs = "Malignance Tights", feet = "Malignance Boots"
    }

    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, { neck = "Magoraga Bead Necklace" })

    sets.midcast.FC = set_combine(sets.midcast.FastRecast, {})
    sets.midcast.FC['Poisonga'] = set_combine(sets.precast.FC, sets.TreasureHunterTag)
    sets.midcast['Poisonga'] = set_combine(sets.midcast.FC['Poisonga'], sets.TreasureHunterTag)
    sets.midcast['Poison'] = sets.midcast['Poisonga']
    sets.midcast['Poison'].FC = sets.midcast['Poisonga']

    -- Ranged gear

    sets.precast.RA = {
        hands = "Alruna's Gloves +1", ring1 = "Crepuscular Ring",
        waist = "Yemaya Belt", legs = "Adhemar Kecks +1", feet = "Meghanada Jambeaux +2"
    }

    sets.midcast.RA = {
        head = "Malignance Chapeau", neck = "Iskur Gorget", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Crepuscular Ring", ring2 = "Dingir Ring",
        waist = "Yemaya Belt", legs = "Malignance Tights", feet = "Malignance Boots"
    }


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = { ammo = "Coiste Bodhar",
        head = "Adhemar Bonnet +1", neck = "Anu Torque", ear1 = "Sherida Earring", ear2 = "Skulker's Earring +1",
        body = "Gleti's Cuirass", hands = "Adhemar Wristbands +1", ring1 = "Gere Ring", ring2 = "Hetairoi Ring",
        back = gear.melee_cape, waist = "Reiki Yotai", legs = "Samnuha Tights", feet = "Plunderer's Poulaines +3" }
    sets.engaged.Acc = { ammo = "Seething Bomblet +1",
        head = "Malignance Chapeau", neck = "Anu Torque", ear1 = "Telos Earring", ear2 = "Skulker's Earring +1",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Gere Ring", ring2 = "Hetairoi Ring",
        back = gear.melee_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Plunderer's Poulaines +3" }

    sets.engaged.MaxDW = set_combine(sets.engaged,
        { ear1 = "Eabani Earring", ear2 = "Suppanomimi", waist = "Reiki Yotai" })
    sets.engaged.MidDW = set_combine(sets.engaged, { ear2 = "Suppanomimi", waist = "Reiki Yotai" })
    sets.engaged.MinDW = set_combine(sets.engaged, { waist = "Reiki Yotai" })

    sets.engaged.Acc.MaxDW = set_combine(sets.engaged,
        { ear1 = "Eabani Earring", ear2 = "Suppanomimi", waist = "Reiki Yotai" })
    sets.engaged.Acc.MidDW = set_combine(sets.engaged, { ear2 = "Suppanomimi", waist = "Reiki Yotai" })
    sets.engaged.Acc.MinDW = set_combine(sets.engaged, { waist = "Reiki Yotai" })


    -- Mod set for behind mob
    sets.engaged.Mod = set_combine(sets.engaged, { body = "Plunderer's Vest" })

    -- Mod set for Crits
    sets.engaged.Crit = set_combine(sets.engaged, { ammo = "Yetshila +1",
        head = "Blistering sallet +1", ear1 = "Sherida Earring", ear2 = "Odr Earring",
        legs = "Gleti's Breeches" })

    sets.engaged.Evasion = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Bathy Choker +1", ear1 = "Eabani Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Moonlight Ring", ring2 = "Epona's Ring",
        back = gear.melee_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.Acc.Evasion = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Bathy Choker +1", ear1 = "Eabani Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Moonlight Ring", ring2 = "Regal Ring",
        back = gear.melee_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.engaged.PDT = { ammo = "Coiste Bodhar",
        head = "Malignance Chapeau", neck = "Anu Torque", ear1 = "Suppanomimi", ear2 = "Skulker's Earring +1",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Moonlight Ring", ring2 = "Gere Ring",
        back = gear.melee_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.Acc.PDT = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Sherida Earring", ear2 = "Skulker's Earring +1",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Regal Ring", ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.engaged.MDT = set_combine(sets.engaged.PDT,
        { ammo = "Yamarang", ear2 = "Eabani Earring", ring1 = "Archon Ring", ring2 = "Shadow Ring" })
    sets.engaged.Acc.MDT = set_combine(sets.engaged.MDT, {})

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    -- remap Evisceration to Savage Blade when holding Naegling.
    if spell.english == 'Evisceration' and player.equipment.main == 'Naegling' then
        eventArgs.cancel = true
        windower.send_command('input /ws "Savage Blade <t>"')
    end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)

    if spell.type == 'WeaponSkill' and player.tp == 3000 then
        if sets.precast.WS[spell.english] then
            if sets.precast.WS[spell.english].MaxTP then
                equip(sets.precast.WS[spell.english].MaxTP)
            end
        end
    end

    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english == 'Sneak Attack' or spell.english == 'Trick Attack' then --or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
-- function job_post_midcast(spell, action, spellMap, eventArgs)
--     if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
--         --equip(sets.TreasureHunter)
--     end
-- end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

    if gain then
        if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
            calculate_haste()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charmed')
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs equip sets.defense.PDT')
        end
    else
        if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
            calculate_haste()
            send_command('gs c update')
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off')
        elseif buff == 'doom' then
            send_command('input /p Doom off')
            send_command('gs c update')
        end
    end
end

function calculate_haste()
    local haste = 0
    if buffactive.march == 1 then
        -- assume honor march for single march song
        haste = haste + 16.99
    elseif buffactive.march == 2 then
        haste = 43.75
    end

    if buffactive.haste == 1 then
        -- assume haste II
        haste = haste + 30
    elseif buffactive.haste == 2 then
        -- cornelia active
        haste = 43.75
    end

    if buffactive.embrava then
        haste = haste + 25.9
    end

    if state.Buff['Haste Samba'] then
        haste = haste + 5
    end

    if state.Buff['Mighty Guard'] then
        haste = haste + 15
    end

    classes.CustomMeleeGroups:clear()
    if haste <= 29 then
        -- equip up to 64 DW
        classes.CustomMeleeGroups:append('MaxDW')
    elseif haste > 29 and haste < 43.75 then
        -- equip up to 31 DW
        classes.CustomMeleeGroups:append('MidDW')
    elseif haste >= 43.75 then
        -- equip 11 DW
        classes.CustomMeleeGroups:append('MinDW')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end

function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    herculean.th.update(cmdParams, eventArgs)

    if buffactive.terror or buffactive.stun then
        send_command('gs equip sets.defense.PDT')
    elseif buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            send_command('gs equip sets.buff.doom')
        elseif state.DoomMode.value == 'Holy Water' then
            send_command('gs equip sets.buff.doom.HolyWater')
        end
    end
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'

    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end

    msg = msg .. ': '

    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value

    if state.DefenseMode.value ~= 'None' then
        msg = msg ..
            ', ' ..
            'Defense: ' ..
            state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: ' .. state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function herculean.th.action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
    then return true
    end
end

-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book

    if player.sub_job == 'DNC' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'WAR' then
        set_macro_page(3, 6)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 6)
    else
        set_macro_page(4, 6)
    end
    send_command("@wait 5;input /lockstyleset 1")
end
