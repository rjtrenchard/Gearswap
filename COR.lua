-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off

    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.

    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('natty_helper_functions.lua')
    include('default_sets.lua')

    state.OffenseMode:options('Melee', 'Acc', 'Crit', 'Ranged')
    state.HybridMode:options('Normal', 'PDT')
    state.RangedMode:options('Normal', 'Acc', 'Crit')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    gear.RAbullet = "Eminent Bullet"
    gear.WSbullet = gear.RAbullet
    --gear.WSbullet = "Voluspa Bullet"
    gear.MAbullet = "Orichalcum Bullet"
    gear.QDbullet = "Hauksbok Bullet"

    gear.default.obi_waist = "Orpheus's Sash"

    gear.leaden_cape = {
        name = "Camulus's Mantle",
        augments = { 'AGI+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'AGI+10', 'Weapon skill damage +10%', }
    }

    gear.ws_cape = {
        name = "Camulus's Mantle",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', }
    }

    gear.ranged_ws_cape = {
        name = "Camulus's Mantle",
        augments = { 'AGI+20', 'Rng. Acc+20 Rng. Atk+20', 'AGI+10', 'Weapon skill damage +10%' },
    }

    gear.precast_ranged = {
        name = "Camulus's Mantle",
        augments = { '"Snapshot"+10' }
    }

    gear.ranged_cape = {
        name = "Camulus's Mantle",
        augments = { 'AGI+20', 'Rng. Acc+20 Rng. Atk+20', 'Rng. Acc.+10', 'Critical hit rate +10%',
            'Phys. dmg. taken -10%', }
    }

    gear.quickdraw_cape = {
        name = "Camulus's Mantle",
        augments = { 'AGI+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Magic Accuracy+10', '“Magic Atk. Bonus”+10', }
    }
    gear.quickdraw_acc_cape = gear.quickdraw_cape

    gear.melee_cape = {
        name = "Camulus's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken -10%', }
    }

    -- gear.fc_cape = {}

    -- gear.

    --gear.QDbullet = gear.MAbullet
    options.ammo_warning_limit = 15

    -- Additional local binds
    send_command('bind ^q input /ja "Bolter\'s Roll"')
    send_command('bind !` input /ja "Double-up" <me>')

    send_command('bind numpad7 gs equip sets.weapons.Naegling')
    send_command('bind numpad8 gs equip sets.weapons.Ranged')
    send_command('bind ^numpad8 gs equip sets.weapons.TPBonus')

    send_command('lua l autocor')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('lua u autocor')
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.resist = {}
    sets.resist.death = {
        main = "Odium",
        body = "Samnuha Coat",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    sets.weapons = {}
    sets.weapons.Naegling = { main = 'Naegling', sub = 'Crepuscular Knife' }
    sets.weapons.Ranged = { range = "Compensator", ammo = gear.RAbullet }
    sets.weapons.TPBonus = { range = "Anarchy +2", ammo = "empty" }

    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['Triple Shot'] = { body = "Chasseur's Frac +1" }
    sets.precast.JA['Snake Eye'] = { legs = "Lanun Trews" }
    sets.precast.JA['Wild Card'] = { feet = "Lanun Bottes +3" }
    sets.precast.JA['Random Deal'] = { body = "Lanun Frac +3" }


    sets.precast.CorsairRoll = {
        head = "Lanun Tricorne",
        neck = "Regal Necklace",
        hands = "Chasseur's Gants +1",
        ring1 = "Luzaf's Ring",
        back = "Camulus's Mantle"
    }

    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, { legs = "Chasseur's Culottes +1" })
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, { feet = "Chasseur's Bottes +1" })
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll,
        { head = "Chasseur's Tricorne +1" })
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, { body = "Chasseur's Frac +1" })
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, { hands = "Chasseur's Gants +1" })

    sets.precast.LuzafRing = { ring2 = "Luzaf's Ring" }
    sets.precast.FoldDoubleBust = { hands = "Lanun Gants +1" }


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head = "Malignance Chapeau",
        ear1 = "Handler's Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Ilabrat Ring",
        waist = "Chaac Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.FC = {
        head = "Carmine Mask +1",
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1",
        hands = "Leyline Gloves",
        ring2 = "Rahab Ring",
        ring1 = "Kishar Ring",
        legs = "Limbo Trousers",
        feet = "Carmine Greaves +1",
    }

    -- sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck = "Magoraga Beads" })


    -- base: snapshot+10, rapidshot 30
    sets.precast.RA = {
        ammo = gear.RAbullet,
        head = "Chasseur's Tricorne +1", -- rapid shot +14
        body = "Laksa. Frac +3",         -- rapid shot +20
        hands = "Lanun Gants +1",        -- snapshot +9
        ring1 = "Crepuscular Ring",      -- snapshot +3
        back = gear.precast_ranged,      -- snapshot +10
        waist = "Yemaya Belt",           -- rapid shot +5
        legs = "Adhemar Kecks +1",       -- snapshot +10 rapidshot +13
        feet = "Meghanada Jambeaux +2"   -- Snapshot +10
    }


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Moonshade Earring",
        body = "Laksa. Frac +3",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Ephramad's Ring",
        back = gear.ws_cape,
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Lanun Bottes +3"
    }

    sets.precast.WS.Acc = set_combine(sets.precast.WS,
        {
            head = "Malignance Chapeau",
            ear1 = "Crepuscular Earring",
            body = "Malignance Tabard",
            hands = "Malignance Gloves",
            legs = "Malignance Tights",
            feet = "Malignance Boots"
        })

    sets.precast.WS.Ranged = set_combine(sets.precast.WS,
        { body = "Laksa. Frac +3", ring2 = "Dingir Ring", back = gear.ranged_ws_cape })

    sets.precast.WS.Low = set_combine(sets.naked,
        {
            main = "",
            sub = "",
            range = "",
            ammo = gear.WSbullet,
            head = "Malignance Chapeau",
            body = "Malignance tabard",
            hands = "malignance gloves",
            legs = "malignance tights",
            feet = "malignance boots"
        })


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,
        { ear2 = "Odr Earring", ring1 = "Begrudging Ring", ring2 = "Epona's Ring" })

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS,
        { ear2 = "Odr Earring", ring1 = "Ilabrat Ring", ring2 = "Epona's Ring" })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
        {
            body = "Laksa. Frac +3",
            neck = "Republican Platinum medal",
            waist = "Sailfi Belt +1",
            ring2 = "Regal Ring",
        })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'],
        {})

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Last Stand'] = {
        ammo = gear.WSbullet,
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Chasseur's Earring +1",
        body = "Laksa. Frac +3",
        hands = "Nyame Gauntlets",
        ring2 = "Regal Ring",
        ring1 = "Epaminondas's Ring",
        back = gear.ranged_ws_cape,
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Lanun Bottes +3"
    }

    sets.precast.WS['Last Stand'].Acc = sets.precast.WS['Last Stand']

    sets.precast.WS['Wildfire'] = {
        ammo = gear.MAbullet,
        head = gear.matk_head,
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Crematio Earring",
        body = "Lanun Frac +3",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Dingir Ring",
        back = gear.leaden_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Lanun Bottes +3"
    }
    sets.precast.WS['Wildfire'].Acc = set_combine(sets.precast.WS['Wildfire'],
        {})

    -- sets.precast.WS['Wildfire'].Brew = {
    --     ammo = gear.MAbullet,
    --     head = gear.matk_head,
    --     neck = "Sibyl Scarf",
    --     ear1 = "Friomisi Earring",
    --     ear2 = "Crematio Earring",
    --     body = "Lanun Frac +3",
    --     hands = "Herculean Gloves",
    --     ring1 = "Epaminondas's Ring",
    --     ring2 = "Dingir Ring",
    --     back = gear.leaden_cape,
    --     waist = "Svelt. Gouriz +1",
    --     legs = "Herculean Trousers",
    --     feet = "Lanun Bottes +3"
    -- }

    sets.precast.WS['Leaden Salute'] = set_combine(sets.precast.WS['Wildfire'],
        {
            head = "Pixie Hairpin +1",
            ear2 = "Moonshade Earring",
            ring1 = "Archon Ring",
            ring2 = "Dingir Ring",
            waist = gear.ElementalObi
        })
    sets.precast.WS['Leaden Salute'].Acc = set_combine(sets.precast.WS['Leaden Salute'],
        {})

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {
        ring2 = "Ilabrat Ring",
    })


    -- Sets for ranged WS's
    sets.precast.WS['Hot Shot'] = set_combine(sets.precast.WS,
        { ear1 = "Beyla Earring", ear2 = "Chasseur's Earring +1", ring1 = "Dingir Ring", ring2 = "Epaminondas's Ring" })
    sets.precast.WS['Split Shot'] = sets.precast.WS['Hot Shot']
    sets.precast.WS['Sniper Shot'] = sets.precast.WS['Hot Shot']
    sets.precast.WS['Slug Shot'] = sets.precast.WS['Hot Shot']
    sets.precast.WS['Blast Shot'] = sets.precast.WS['Hot Shot']
    sets.precast.WS['Heavy Shot'] = sets.precast.WS['Hot Shot']
    sets.precast.WS['Detonator'] = sets.precast.WS['Hot Shot']
    sets.precast.WS['Numbing Shot'] = sets.precast.WS['Hot Shot']

    sets.precast.WS['Hot Shot'].Acc = set_combine(sets.precast.WS.Acc,
        {
            body = "Laksa. Frac +3",
            ear1 = "Beyla Earring",
            ear2 = "Chasseur's Earring +1",
            ring1 = "Dingir Ring",
            ring2 = "Epaminondas's Ring"
        })
    sets.precast.WS['Split Shot'].Acc = sets.precast.WS['Hot Shot'].Acc
    sets.precast.WS['Sniper Shot'].Acc = sets.precast.WS['Hot Shot'].Acc
    sets.precast.WS['Slug Shot'].Acc = sets.precast.WS['Hot Shot'].Acc
    sets.precast.WS['Blast Shot'].Acc = sets.precast.WS['Hot Shot'].Acc
    sets.precast.WS['Heavy Shot'].Acc = sets.precast.WS['Hot Shot'].Acc
    sets.precast.WS['Detonator'].Acc = sets.precast.WS['Hot Shot'].Acc
    sets.precast.WS['Numbing Shot'].Acc = sets.precast.WS['Hot Shot'].Acc


    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Nyame Helm",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Kishar Ring",
        ring2 = "Rahab Ring",
        waist = "Sailfi Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {})

    sets.precast.CorsairShot = {
        head = "Blood Mask",
        body = "Mirke Wardecors",
    }


    sets.midcast.CorsairShot = {
        ammo = gear.QDbullet,
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Crematio Earring",
        body = "Lanun Frac +3",
        hands = "Nyame Gauntlets",
        ring1 = "Dingir Ring",
        ring2 = "Ilabrat Ring",
        back = gear.quickdraw_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Lanun Bottes +3"
    }

    sets.midcast.CorsairShot.ElementalBonus = { feet = "Chasseur's Bottes +1" }

    sets.midcast.CorsairShot.Acc = set_combine(sets.midcast.CorsairShot, {
        head = "Malignance Chapeau",
        neck = "Sibyl Scarf",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Metamorph Ring +1",
        ring2 = "Ilabrat Ring",
        back = gear.quickdraw_cape,
        waist = "Eschan Stone",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    })

    sets.midcast.CorsairShot['Light Shot'] = set_combine(sets.midcast.CorsairShot.Acc,
        sets.midcast.CorsairShot.ElementalBonus)

    sets.midcast.CorsairShot['Dark Shot'] = set_combine(sets.midcast.CorsairShot.Acc,
        sets.midcast.CorsairShot.ElementalBonus)


    -- Ranged gear
    sets.midcast.RA = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Iskur Gorget",
        ear1 = "Beyla Earring",
        ear2 = "Chasseur's Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring2 = "Hadjuk Ring +1",
        ring1 = "Cacoethic Ring +1",
        back = gear.ranged_cape,
        waist = "Eschan Stone",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.midcast.RA.Acc = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Iskur Gorget",
        ear1 = "Beyla Earring",
        ear2 = "Chasseur's Earring +1",
        body = "Laksa. Frac +3",
        hands = "Malignance Gloves",
        ring2 = "Dingir Ring",
        ring1 = "Cacoethic Ring +1",
        back = gear.ranged_cape,
        waist = "Eschan Stone",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.midcast.RA.Crit = set_combine(sets.midcast.RA.Acc,
        { ear1 = "Odr Earring", ring1 = "Mummu Ring", ring2 = "Begrudging Ring" })

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1", ring1 = "Gelatinous Ring +1", ring2 = "Paguroidea Ring" }


    -- Idle sets
    sets.idle = {
        ammo = gear.RAbullet,
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.Town = {
        ammo = gear.RAbullet,
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = "Moonlight Cape",
        waist = "Blacksmith's Belt",
        legs = "Carmine Cuisses +1"
    }

    -- Defense sets
    sets.defense.PDT = {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Archon Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = {
        head = "Malignance Chapeau",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Defending Ring",
        ring2 = "Archon Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }


    sets.Kiting = { legs = "Carmine Cuisses +1" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Iskur Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's Ring",
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Samnuha Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Melee = sets.engaged

    sets.engaged.Acc = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Epona's Ring",
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.Defense = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring2 = "Regal Ring",
        ring1 = "Epona's Ring",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.PDT = sets.engaged.Defense
    sets.engaged.MDT = set_combine(sets.engaged.PDT, { ring1 = "Archon Ring" })

    sets.engaged.Mod = set_combine(sets.engaged.Acc,
        { head = "Mummu Bonnet +1", ear2 = "Odr Earring", body = "Meghanada Cuirie +1", hands = "Mummu Wrists +2" })

    sets.engaged.DW = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Iskur Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's Ring",
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Reiki Yotai",
        legs = "Samnuha Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Melee.DW = sets.engaged.DW

    sets.engaged.Acc.DW = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Epona's Ring",
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.DW.Acc = sets.engaged.Acc.DW

    sets.engaged.Defense.DW = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Epona's Ring",
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.PDT.DW = sets.engaged.Defense.DW
    sets.engaged.MDT.DW = set_combine(sets.engaged.PDT.DW, { ring1 = "Archon Ring" })

    sets.engaged.DW.Defense = sets.engaged.Defense.DW
    sets.engaged.DW.PDT = sets.engaged.PDT.DW
    sets.engaged.DW.MDT = sets.engaged.MDT.DW


    sets.engaged.Mod.DW = set_combine(sets.engaged.Acc.DW,
        { head = "Mummu Bonnet +1", ear2 = "Odr Earring", body = "Meghanada Cuirie +1", hands = "Mummu Wrists +2" })

    sets.engaged.Ranged = {
        ammo = gear.RAbullet,
        head = "Malignance Chapeau",
        neck = "Iskur Gorget",
        ear1 = "Beyla Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Dingir Ring",
        ring2 = "Longshot Ring",
        back = "Moonlight Cape",
        waist = "Eschan Stone",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    -- print(spell.type, spell.english)
    if S { 'Anarchy +2', 'Anarchy +3', 'Ataktos' }:contains(player.equipment.range) and S { 'Ranged', 'Hot Shot',
            'Split Shot',
            'Sniper Shot',
            'Slug Shot', 'Blast Shot', 'Heavy Shot', 'Detonator', 'Numbing Shot', 'Last Stand', 'Terminus' }:contains(spell.english) then
        windower.add_to_chat(144, 'INFO: TP Bonus gun equipped')
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end

function update_combat_form()
    if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''

    msg = msg .. 'Off.: ' .. state.OffenseMode.current
    msg = msg .. ', Rng.: ' .. state.RangedMode.current
    msg = msg .. ', WS.: ' .. state.WeaponskillMode.current
    msg = msg .. ', QD.: ' .. state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value .. 'DefenseMode'].current
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' ' .. defMode
    end

    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end

    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: ' .. state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = { lucky = 5, unlucky = 9, bonus = "Experience Points" },
        ["Ninja Roll"]       = { lucky = 4, unlucky = 8, bonus = "Evasion" },
        ["Hunter's Roll"]    = { lucky = 4, unlucky = 8, bonus = "Accuracy" },
        ["Chaos Roll"]       = { lucky = 4, unlucky = 8, bonus = "Attack" },
        ["Magus's Roll"]     = { lucky = 2, unlucky = 6, bonus = "Magic Defense" },
        ["Healer's Roll"]    = { lucky = 3, unlucky = 7, bonus = "Cure Potency Received" },
        ["Puppet Roll"]      = { lucky = 4, unlucky = 8, bonus = "Pet Magic Accuracy/Attack" },
        ["Choral Roll"]      = { lucky = 2, unlucky = 6, bonus = "Spell Interruption Rate" },
        ["Monk's Roll"]      = { lucky = 3, unlucky = 7, bonus = "Subtle Blow" },
        ["Beast Roll"]       = { lucky = 4, unlucky = 8, bonus = "Pet Attack" },
        ["Samurai Roll"]     = { lucky = 2, unlucky = 6, bonus = "Store TP" },
        ["Evoker's Roll"]    = { lucky = 5, unlucky = 9, bonus = "Refresh" },
        ["Rogue's Roll"]     = { lucky = 5, unlucky = 9, bonus = "Critical Hit Rate" },
        ["Warlock's Roll"]   = { lucky = 4, unlucky = 8, bonus = "Magic Accuracy" },
        ["Fighter's Roll"]   = { lucky = 5, unlucky = 9, bonus = "Double Attack Rate" },
        ["Drachen Roll"]     = { lucky = 3, unlucky = 7, bonus = "Pet Accuracy" },
        ["Gallant's Roll"]   = { lucky = 3, unlucky = 7, bonus = "Defense" },
        ["Wizard's Roll"]    = { lucky = 5, unlucky = 9, bonus = "Magic Attack" },
        ["Dancer's Roll"]    = { lucky = 3, unlucky = 7, bonus = "Regen" },
        ["Scholar's Roll"]   = { lucky = 2, unlucky = 6, bonus = "Conserve MP" },
        ["Bolter's Roll"]    = { lucky = 3, unlucky = 9, bonus = "Movement Speed" },
        ["Caster's Roll"]    = { lucky = 2, unlucky = 7, bonus = "Fast Cast" },
        ["Courser's Roll"]   = { lucky = 3, unlucky = 9, bonus = "Snapshot" },
        ["Blitzer's Roll"]   = { lucky = 4, unlucky = 9, bonus = "Attack Delay" },
        ["Tactician's Roll"] = { lucky = 5, unlucky = 8, bonus = "Regain" },
        ["Allies's Roll"]    = { lucky = 3, unlucky = 10, bonus = "Skillchain Damage" },
        ["Miser's Roll"]     = { lucky = 5, unlucky = 7, bonus = "Save TP" },
        ["Companion's Roll"] = { lucky = 2, unlucky = 10, bonus = "Pet Regain and Regen" },
        ["Avenger's Roll"]   = { lucky = 4, unlucky = 8, bonus = "Counter Rate" },
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english .. ' provides a bonus to ' .. rollinfo.bonus .. '.  Roll size: ' .. rollsize)
        add_to_chat(104,
            'Lucky roll is ' .. tostring(rollinfo.lucky) .. ', Unlucky roll is ' .. tostring(rollinfo.unlucky) .. '.')
    end
end

-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1

    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end

    local available_bullets = has_equippable(bullet_name)

    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104,
                'No Quick Draw ammo left.  Using what\'s currently equipped (' .. player.equipment.ammo .. ').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104,
                'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: ' ..
                player.equipment.ammo .. ').')
            return
        else
            add_to_chat(104, 'No ammo (' .. tostring(bullet_name) .. ') available for that action.')
            eventArgs.cancel = true
            return
        end
    end

    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end

    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: ' .. bullet_name .. ' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
--function job_precast(spell, action, spellMap, eventArgs)
--gear.default.obi_back = "Mending Cape"
--end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    if player.sub_job == 'RNG' then
        set_macro_page(6, 17)
    else
        set_macro_page(1, 17)
    end

    send_command("@wait 5;input /lockstyleset 16")
end
