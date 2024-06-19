---------------------
-- Required files: --
---------------------
--
--  Motes files
--
--  natty_helper_functions.lua
--  natty_includes.lua
--  natty_helper_data.lua
--  Augments.lua
--  default_sets.lua

-------------------
-- Default Binds --
-------------------
--
-- F9       Cycle OffenseMode
-- Ctrl+F9  Cycle HybridMode
-- F10      Enable PDT DefenseMode
-- F11      Enable MDT DefenseMode
-- Ctrl+F11 Cycle CastingMode
-- Alt+F12  Disable DefenseMode
-- Ctrl+F12 Cycle IdleMode
-- F12      Update gear
-- Ctrl+-   Cycle Doom Mode
-- Ctrl+=   Cycle TreasureHunter
-- Alt+`    Toggle MagicBurst

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

res = require('resources')

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Saboteur = buffactive.saboteur or false

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S { 35, 204 }
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S { 201, 202, 203, 205, 207 }

    include('Mote-TreasureHunter')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')
    include('natty_helper_functions.lua')

    state.OffenseMode:options('Normal', 'Acc', 'Enspell', 'EnspellMax', 'Magic')
    state.HybridMode:options('Normal', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.RangedMode:options('None', 'Normal')
    state.IdleMode:options('Normal', 'PDT', 'MDT', 'Refresh', 'Regain')

    state.ImpactMode = M { ['description'] = 'Impact Mode', 'Normal', 'Occult Acumen' }
    state.MagicBurstMode = M { ['description'] = 'Magic Burst', 'Normal', "Always" }
    state.TPMode = M { ['description'] = 'TP Mode', 'Expend', 'Preserve', 'Preserve > 1000' }
    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }
    -- state.DWMode = M { ['description'] = 'Dual Wield Mode', '30%', 'Capped' }
    state.UseCustomTimers = M(false, 'Use Custom Timers')

    info.JobPoints = {}
    info.JobPoints.EnhancingDuration = 20
    info.JobPoints.EnhancingMerits = 5

    info.enspell_weapons = S { 'Crocea Mors', 'Demersal Degen +1', 'Pukulatmuj +1' }

    gear.default.obi_waist = "Orpheus's Sash"
    gear.default.drain_waist = "Fucho-no-Obi"
    gear.default.cure_waist = "Shinjutsu-no-obi +1"


    enhancing_skill_magic = S { 'Temper', 'Temper II', 'Aquaveil' }

    custom_timers = {}

    if player.sub_job == 'DRK' and player.sub_job_level > 0 then
        state.ImpactMode:set('Occult Acumen')
        state.IdleMode:set('Regain')
    end

    select_default_macro_book()

    -- send_command('bind numpad4 gs c equip Enspell; gs c update')
    send_command('bind numpad9 gs c equip Maxentius; gs c update')
    send_command('bind numpad7 gs c equip CroceaMors; gs c update')
    send_command('bind numpad8 gs c equip Naegling; gs c update')
    send_command('bind numpad6 gs c equip Dagger; gs c update')
    send_command('bind !numpad6 gs c equip DaggerLow; gs c update')
    send_command('bind ^numpad6 gs c equip AeolianEdge; gs c update')

    send_command('bind numpad0 gs equip sets.resist.death')

    -- send_command('bind ^- gs c cycle TPMode')
    send_command('bind !` gs c cycle MagicBurstMode')
    send_command('bind != gs c set OffenseMode Magic')
    send_command('bind ^numpad5 gs c cycle ImpactMode')
    -- send_command('bind numpad5 input ')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^- gs c cycle DoomMode')

    send_command('bind numpad1 input /ma Silence <t>')
    send_command('bind numpad2 input /ma "Dispel" <t>')
    send_command('bind numpad3 input /ma "Sleep II" <t>')
    send_command('bind numpad4 input /ja Accession <me>')

    send_command('bind ^f5 gs equip sets.FullTP; input /item "Icarus Wing" <me>')
    send_command('bind ^f6 gs equip sets.Volte; input /echo Volte equipped')

    send_command('bind ^numpad1 input /item "Panacea" <me>')
    send_command('bind ^numpad2 input /item "Remedy" <me>')
    send_command('bind ^numpad3 input /item "Holy Water" <me>')
end

function user_unload()
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Augmented gear
    gear.int_cape = {
        name = "Sucellos's Cape",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', }
    }
    gear.mnd_cape = {
        name = "Sucellos's Cape",
        augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'MND+10', 'Weapon skill damage +10%', }
    }
    gear.melee_cape = {
        name = "Sucellos's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', }
    }
    gear.stp_cape = {
        name = "Sucellos's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Store TP"+10', 'Phys. dmg. taken-10%', }
    }
    gear.dw_cape = {
        name = "Sucellos's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+5', '"Dual Wield"+10', 'Phys. dmg. taken-10%', }
    }
    gear.ws_cape = {
        name = "Sucellos's Cape",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%' },
    }




    gear.int_ws_cape = gear.ws_cape
    gear.idle_cape = "Moonlight Cape"

    gear.default_ranged = "Ullr"
    gear.default_ranged_ammo = "Chapuli Arrow"


    -- Misc sets

    -- make HP low, but still armoured.
    sets.LowHP = {
        head = "Taeon Chapeau",
        body = "Taeon Tabard",
        hands = "Taeon Gloves",
        ring1 = "Jhakri Ring",
        legs = "Taeon Tights",
        feet = "Taeon boots"
    }

    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Halitus Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Trux Earring",
        ear2 = "Cryptic Earring",
        body = "Emet Harness +1",
        ring1 = "Supershear Ring",
        ring2 = "Eihwaz Ring",
        waist = "Trance Belt",
        legs = "Zoar Subligar +1"
    }

    sets.ConserveMP = {
        ammo = "Pemphredo Tathlum",
        head = "Ipoca Beret",
        ear2 = "Magnetic Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring2 = "Mephitas's Ring +1",
        back = "Fi Follet Cape +1",
        waist = "Shinjutsu-no-obi +1",
        legs = "Lengo Pants",
        feet = "Kaykaus Boots +1"
    }

    -- Precast Sets
    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    sets.FullTP = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Ainia Collar",
        ear1 = "Sherida Earring",
        ear2 = "Dedition Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.stp_cape,
        waist = "Kentarch Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.Volte = set_combine(sets.FullTP, {
        body = "Volte Harness"
    })

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = { body = "Vitiation Tabard +3" }
    sets.precast.JA['Saboteur'] = { hands = "Lethargy Gantherots +3" } -- how long have I been forgetting this?


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.RA = {
        hands = "Carmine Finger Gauntlets +1",
        ring1 = "Crepuscular Ring",
        ring2 = "Haverton Ring +1",
        waist = "Yemaya Belt"
    }

    -- Fast cast sets for spells

    -- 90% Fast Cast (including trait) for all spells, 10% Quick Magic, retain 285 HP
    sets.precast.FC = {
        -- traits:                      -- 38
        -- main = "Crocea Mors",
        ammo = "Impatiens",
        head = gear.merlinic.fc.head, -- 15
        neck = { name = "Unmoving Collar +1", priority = 10 },
        ear1 = { name = "Eabani Earring", priority = 9 },
        ear2 = { name = "Etiolation Earring", priority = 8 },
        ring1 = "Lebeche Ring",      -- 0
        ring2 = "Medada's Ring",     -- 10
        back = "Perimede Cape",      -- 4
        waist = "Embla Sash",        -- 5
        -- legs = "",
        feet = gear.merlinic.fc.feet -- 12
    }

    -- for when we cast spells that can't overwrite themselves, and the buff is active
    -- includes +90FC to account for potential opposing arts
    sets.precast.FC.NoQC = {
        -- main = "Crocea Mors",
        head = gear.merlinic.fc.head,
        neck = { name = "Unmoving Collar +1", priority = 10 },
        ear1 = { name = "Etiolation Earring", priority = 9 },
        ear2 = "Malignance Earring",
        hands = "Leyline Gloves",
        ring1 = "Kishar Ring",
        ring2 = "Rahab Ring",
        back = "Moonlight Cape",
        waist = "Embla Sash",
        legs = "Kaykaus Tights +1",
        feet = gear.merlinic.fc.feet
    }

    sets.precast['Dispelga'] = set_combine(sets.precast.FC, {
        main = { name = "Daybreak", priority = 10 },
        sub = { name = "Ammurapi Shield", priority = 9 },
        hands = "Leyline Gloves",
        feet = "Carmine Greaves +1"
    })
    sets.precast.Dispelga.pretarget = { sub = "Ammurapi Shield" }
    sets.precast.FC.Dispelga = sets.precast.Dispelga

    sets.precast['Impact'] = set_combine(sets.precast.FC,
        {
            -- main = "Crocea Mors",
            -- sub = "Ammurapi Shield",
            head = empty,
            body = "Crepuscular Cloak",
            hands = "Leyline Gloves",
            waist = "Embla Sash",
            legs = "Kaykaus Tights +1",
            feet = "Carmine Greaves +1"
        })
    sets.precast.FC['Impact'] = sets.precast['Impact']

    sets.precast.FC['Utsusemi'] = sets.precast.FC

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Crepuscular Pebble",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Lethargy Earring +2",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Sroda Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.ws_cape,
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Lethargy Houseaux +3"
    }

    sets.precast.WS.Crit = {
        ammo = "Yetshila +1",
        head = "Blistering Sallet +1",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Lethargy Earring +2",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring2 = "Hetairoi Ring",
        ring1 = "Begrudging Ring",
        back = gear.ws_cape,
        waist = "Fotia Belt",
        legs = "Zoar Subligar +1",
        feet = "Thereoid Greaves"
    }

    sets.precast.WS.Acc = {
        ammo = 'Crepuscular Pebble',
        head = 'Nyame Helm',
        neck = 'Fotia Gorget',
        ear1 = 'Telos Earring',
        ear2 = 'Lethargy Earring +2',
        body = "Nyame Mail",
        hands = 'Nyame Gauntlets',
        ring1 = 'Epaminondas\'s Ring',
        ring2 = gear.right_chirich,
        back = gear.ws_cape,
        waist = 'Fotia Gorget',
        legs = 'Nyame Flanchard',
        feet = 'Lethargy Houseaux +2'
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        ammo = "Regal Gem",
        ear1 = "Sherida Earring",
        ear2 = "Regal Earring",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape,
    })

    sets.precast.WS['Sanguine Blade'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Archon Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.mnd_cape,
        waist = gear.ElementalObi,
        -- legs = "Nyame Flanchard",
        legs = "Nyame Flanchard",
        feet = "Lethargy Houseaux +3"
    }

    sets.precast.WS['Aeolian Edge'] = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Medada's Ring",
        back = gear.int_ws_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Lethargy Houseaux +3"
    }

    -- sets.precast.WS['Aeolian Edge'] = {
    --     ammo = "Oshasha's Treatise",
    --     head = "Nyame Helm",
    --     neck = "Sibyl Scarf",
    --     ear1 = "Regal Earring",
    --     ear2 = "Malignance Earring",
    --     body = "Nyame Mail",
    --     hands = "Nyame Gauntlets",
    --     ring1 = "Epaminondas's Ring",
    --     ring2 = "Medada's Ring",
    --     back = gear.int_ws_cape,
    --     waist = gear.ElementalObi,
    --     legs = "Nyame Flanchard",
    --     feet = "Lethargy Houseaux +3"
    -- }

    sets.precast.WS['Seraph Blade'] = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Moonshade Earring",
        ear2 = "Regal Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Medada's Ring",
        back = gear.mnd_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Lethargy Houseaux +3"
    }
    sets.precast.WS['Seraph Blade'].MaxTP = { ear1 = "Malignance Earring" }

    sets.precast.WS['Red Lotus Blade'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Medada's ring",
        back = gear.ws_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Lethargy Houseaux +3"
    }

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS.Crit, {
        ammo = "Yetshila +1",
        head = "Blistering Sallet +1",
        legs = "Zoar Subligar +1",
    })
    sets.precast.WS['Chant du Cygne'].MaxTP = { ear2 = "Brutal Earring" }

    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit, { ring2 = "Begrudging Ring" })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
        { ammo = "Coiste Bodhar", neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.Acc,
        {
            ammo = "Crepuscular Pebble",
            head = "Malignance Chapeau",
            neck = "Republican Platinum medal",
            body = "Malignance Tabard",
            hands = "Malignance Gloves",
            waist = "Sailfi Belt +1",
            legs = "Malignance Tights",
            feet = "Lethargy Houseaux +3"
        })
    sets.precast.WS['Savage Blade'].MaxTP = { ear1 = "Sherida Earring" }

    sets.precast.WS['Death Blossom'] = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.Crit, { ring1 = "Hetairoi Ring" })

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Duelist's Torque +2",
        ear1 = "Moonshade Earring",
        ear2 = "Regal Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape,
        waist = "Sailfi Belt +1",
        legs = "Nyame Flanchard",
        feet = "Lethargy Houseaux +3"
    })
    sets.precast.WS['Black Halo'].MaxTP = { ear1 = "Malignance Earring" }

    sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['True Strike'] = sets.precast.WS.Crit

    sets.precast.WS['Empyreal Arrow'] = set_combine(sets.precast.WS.Acc, { range = nil, ammo = gear.ranged_ws_ammo })


    -- Midcast Sets
    sets.SIRD = {
        ammo = "Staunch Tathlum +1",
        body = "Rosette jaseran +1",
        ring2 = "Freke Ring",
        waist = "Emphatikos Rope",
        legs = "Carmine Cuisses +1",
        feet = "Amalric Nails +1"
    }

    sets.midcast.RA = {
        head = "Malignance Chapeau",
        neck = "Marked gorget",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Crepuscular Ring",
        ring2 = "Cacoethic Ring +1",
        waist = "Yemaya Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.midcast.FastRecast = set_combine(sets.ConserveMP, {
        ammo = "Staunch Tathlum +1",
        head = gear.merlinic.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Loquacious Earring",
        ear2 = "Malignance Earring",
        body = "Vitiation Tabard +3",
        hands = "Leyline gloves",
        ring1 = "Kishar Ring",
        ring2 = "Medada's Ring",
        back = "Fi Follet Cape +1",
        waist = "Shinjutsu-no-obi +1",
        legs = "Lethargy Fuseau +3",
        feet = gear.merlinic.fc.feet
    })

    sets.midcast.OccultAcumen = set_combine(sets.FullTP, {
        hands = gear.merlinic.occultacumen.hands,
        waist = "Oneiros Rope",
        legs = "Perdition Slops",
        feet = gear.merlinic.occultacumen.feet
    })

    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, sets.SIRD)

    -- aims for 500 skill (476 base, 24 needed)
    sets.midcast['Enhancing Magic'] = {
        neck = "Duelist's Torque +2",
        ear2 = "Lethargy Earring +2",
        body = "Vitiation Tabard +3",
        hands = "Atrophy Gloves +3",
        back = "Ghostfyre Cape",
        waist = "Embla Sash",
        feet = "Lethargy Houseaux +3"
    }

    -- uncapped skills
    sets.midcast['Enhancing Magic'].PureSkill = {
        head = "Befouled Crown",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Vitiation Tabard +3",
        hands = "Vitiation Gloves +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Ghostfyre Cape",
        waist = "Olympus Sash",
        legs = "Atrophy Tights +3",
        feet = "Lethargy Houseaux +3"
    }


    sets.midcast['Enhancing Magic'].Weapon = { main = "Pukulatmuj +1", sub = "Forfend +1" }
    sets.midcast['Enhancing Magic'].DW = sets.midcast['Enhancing Magic'].Weapon
    sets.midcast['Enhancing Magic'].None = {}

    -- Enhancing magic skill duration, no regard for skill
    sets.midcast['Enhancing Magic'].Duration = set_combine(sets.ConserveMP, sets.midcast.FastRecast, {
        neck = "Duelist's Torque +2",
        ear2 = "Lethargy Earring +2",
        body = "Vitiation tabard +3",
        hands = "Atrophy Gloves +3",
        back = "Ghostfyre Cape",
        feet = "Lethargy Houseaux +3"
    })
    sets.midcast['Enhancing Magic'].Duration.Weapon = {
        main = gear.colada.enh_dur,
        sub = { name = "Ammurapi Shield", priority = 10 }
    }
    sets.midcast['Enhancing Magic'].Duration.DW = sets.midcast['Enhancing Magic'].Duration.Weapon
    sets.midcast['Enhancing Magic'].Duration.None = {}

    -- Phalanx for self
    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
        head = gear.merlinic.phalanx.head,
        neck = "Duelist's Torque +2",
        ear1 = "Andoaa Earring",
        body = gear.taeon.phalanx.body,
        hands = gear.taeon.phalanx.hands,
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Ghostfyre Cape",
        waist = "Embla Sash",
        legs = gear.taeon.phalanx.legs,
        feet = gear.taeon.phalanx.feet
    })
    sets.midcast.Phalanx.Weapon = { main = "Sakpata's Sword", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast.Phalanx.DW = { main = "Sakpata's Sword", sub = "Egeking" }
    sets.midcast.Phalanx.None = {}

    sets.midcast.Regen = {
        -- main = "Bolelabunga",
        head = gear.telchine.regen.head,
        body = gear.telchine.regen.body,
        hands = gear.telchine.regen.hands,
        legs = gear.telchine.regen.legs,
        feet = gear.telchine.regen.feet
    }

    sets.midcast.Refresh = {
        head = "Amalric Coif +1",
        body = "Atrophy Tabard +3",
        legs = "Lethargy Fuseau +3"
    }
    sets.midcast.Gishdubar = { waist = "Gishdubar Sash" }

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        ammo = "Staunch Tathlum +1",
        head = "Amalric Coif +1",
        body = "Rosette Jaseran +1",
        hands = "Amalric Gages +1",
        ring1 = "Evanescence Ring",
        ring2 = "Freke Ring",
        back = gear.int_cape,
        waist = "Emphatikos Rope",
        legs = "Shedir Seraweels",
        feet = "Amalric Nails +1"
    })

    -- Stoneskin +125 (425 HP absorbed)
    sets.midcast.Stoneskin = {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        hands = "Stone Mufflers",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    }

    sets.midcast.BarElement = { legs = "Shedir Seraweels" }
    sets.midcast.BarStatus = set_combine(sets.midcast.BarElement, { neck = "Sroda Necklace" })

    sets.midcast.GainStat = { hands = "Viti. gloves +3" }

    sets.midcast.ProShell = {}
    sets.midcast.ProShell.Self = set_combine(sets.midcast.ProShell, { ear1 = "Brachyura Earring" })

    sets.midcast['Divine Magic'] = {
        neck = "Incanter's Torque",
        ear2 = "Saxnot Earring",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1"
    }
    sets.midcast['Divine Magic'].Weapon = { main = "Daybreak", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Divine Magic'].DW = { main = "Crocea Mors", sub = "Daybreak" }
    sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'],
        {
            head = "Ipoca Beret",
            neck = "Jokushu Chain",
            ring2 = "Medada's Ring",
            ring1 = "Fenian Ring",
            back = "Disperser's Cape"
        })

    sets.midcast['Healing Magic'] = {
        head = "Kaykaus Mitra +1",
        neck = "Incanter's Torque",
        ear1 = "Beatific Earring",
        ear2 = "Meili Earring",
        body = "Vitiation Tabard +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Altruistic Cape",
        waist = "Bishop's Sash",
        legs = "Carmine Cuisses +1",
        feet = "Vanya Clogs"
    }

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], {
        ammo = "Staunch Tathlum +1",
        head = "Kaykaus Mitra +1",
        neck = "Duelist's Torque +2",
        ear1 = "Magnetic Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = gear.CureWaist,
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus Boots +1"
    })

    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, sets.midcast.Gishdubar)

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {
        main = "Prelatic Pole",
        sub = "Curatio Grip",
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        back = "Oretania's Cape +1",
        feet = "Gendewitha Galoshes +1"
    })
    sets.midcast.CursnaSelf = set_combine(sets.midcast.Cursna, { waist = "Gishdubar Sash" })

    sets.midcast.Raise = set_combine(sets.SIRD, sets.ConserveMP)
    sets.midcast.Reraise = set_combine(sets.SIRD, sets.ConserveMP)



    sets.midcast['Enfeebling Magic'] = {
        ammo = "Regal Gem",
        head = "Vitiation Chapeau +3",
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ear2 = "Regal Earring",
        body = "Lethargy Sayon +3",
        hands = "Atrophy Gloves +3",
        ring1 = "Kishar Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape,
        waist = "Obstinate Sash",
        legs = "Lethargy Fuseau +3",
        feet = "Vitiation boots +3"
    }
    sets.midcast['Enfeebling Magic'].Weapon = { main = "Contemplator +1", sub = "Enki Strap" }
    sets.midcast['Enfeebling Magic'].DW = { main = "Crocea Mors", sub = "Daybreak" }

    sets.midcast['Enfeebling Magic'].Acc = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        range = "Ullr",
        head = empty,
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ear2 = "Malignance Earring",
        body = "Cohort Cloak +1",
        hands = "Lethargy Gantherots +3",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Obstinate Sash",
        legs = "Lethargy Fuseau +3",
        feet = "Vitiation boots +3"
    }

    -- purely skill/mnd based spells
    sets.midcast['Enfeebling Magic'].PureSkill = {
        ammo = "Regal Gem",
        head = "Vitiation Chapeau +3",
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ear2 = "Vor Earring",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = gear.mnd_cape,
        waist = "Obstinate Sash",
        legs = "Psycloth Lappas",
        feet = "Vitiation Boots +3"
    }

    sets.midcast['Enfeebling Magic'].HighSkill = {
        ammo = "Regal Gem",
        head = "Vitiation Chapeau +3",
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ear2 = "Vor Earring",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = gear.mnd_cape,
        waist = "Obstinate Sash",
        legs = "Lethargy Fuseau +3",
        feet = "Vitiation Boots +3"
    }

    -- dMND spells (Paralyze, Slow, Addle)
    sets.midcast['Enfeebling Magic'].dMND = {
        ammo = "Regal Gem",
        head = "Vitiation Chapeau +3",
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ear2 = "Regal Earring",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape,
        waist = "Luminary Sash",
        legs = "Chironic Hose",
        feet = "Vitiation Boots +3"
    }

    sets.midcast['Enfeebling Magic'].dMND.Weapon = {
        main = "Daybreak", sub = { name = "Ammurapi Shield", priority = 10 }
    }
    sets.midcast['Enfeebling Magic'].dMND.DW = sets.midcast['Enfeebling Magic'].dMND.Weapon

    sets.midcast['Enfeebling Magic'].Immunobreak = { legs = "Chironic Hose" }

    sets.midcast['Enfeebling Magic'].Duration = {
        head = "Vitiation Chapeau +3",
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ring1 = "Kishar Ring",
        waist = "Obistnate Sash",
    }

    sets.midcast['Dispel'] = {
        ammo = "Regal Gem",
        head = "Lethargy Chappel +3",
        neck = "Duelist's Torque +2",
        ear1 = "Snotra Earring",
        ear2 = "Lethargy Earring +2",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Obstinate Sash",
        legs = "Lethargy Fuseau +3",
        feet = "Lethargy Houseaux +3",
    }
    sets.midcast['Dispelga'] = set_combine(sets.midcast.Dispel, { main = "Daybreak", sub = "Ammurapi Shield" })
    sets.midcast['Dispel'].Acc = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        range = "Ullr",
        ammo = empty
    }

    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'],
        { ammo = "Regal Gem", back = gear.mnd_cape })
    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'],
        { ammo = "Regal Gem", back = gear.mnd_cape })

    sets.midcast['Poison'] = set_combine(sets.midcast['Enfeebling Magic'], { head = "Volte Cap", waist = "Chaac Belt" })
    sets.midcast['Diaga'] = sets.midcast['Poison']
    sets.midcast['Poison II'] = set_combine(sets.midcast['Enfeebling Magic'].PureSkill,
        { main = "Contemplator +1", sub = "Mephitis Grip", back = gear.mnd_cape })
    sets.midcast['Gravity'] = set_combine(sets.midcast['Enfeebling Magic'],
        {
            main = "Contemplator +1",
            sub = "Enki Strap",
            ring1 = "Metamorph Ring +1",
        })
    sets.midcast['Gravity II'] = sets.midcast['Gravity']


    sets.midcast['Frazzle II'] = set_combine(sets.midcast['Enfeebling Magic'].Acc,
        {
            main = "Contemplator +1",
            sub = "Enki Strap",
            range = "Ullr",
            ammo = empty,
            head = empty,
            body = "Cohort Cloak +1",
            back = gear.mnd_cape
        })

    sets.midcast['Elemental Magic'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Lethargy Chappel +3",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        ring1 = "Freke Ring",
        ring2 = "Medada's Ring",
        back = gear.int_cape,
        waist = gear.ElementalObi,
        legs = "Lethargy Fuseau +3",
        feet = "Lethargy Houseaux +3"
    }
    sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {
        head = "Lethargy Chappel +3",
        neck = "Duelist's Torque +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Malignance Earring",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Lethargy Fuseau +3",
        feet = "Lethargy Houseaux +3"
    })
    sets.midcast['Elemental Magic'].Acc.weapon = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        range = "Ullr",
        ammo = empty,
    }

    sets.midcast['Elemental Magic'].Weapon = { main = "Bunzi's Rod", sub = { name = "Ammurapi Shield", priority = 10 } }

    sets.midcast['Elemental Magic'].DW = { main = "Bunzi's Rod", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Elemental Magic'].Weapon.Wind = { main = "Marin Staff +1", sub = "Enki Strap" }
    -- sets.midcast['Elemental Magic'].DW = {}

    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'].Acc,
        {
            head = empty,
            body = "Crepuscular Cloak",
        }
    )

    sets.ImpactOnly = {
        head = empty,
        body = "Crepuscular Cloak"
    }

    sets.midcast.MagicBurst = set_combine(sets.midcast["Elemental Magic"], {

        ammo = "Ghastly Tathlum +1",
        head = "Ea Hat +1",              -- 7    +7
        neck = "Mizukage-no-kubikazari", -- 10
        hands = "Bunzi's Gloves",        -- 8
        ring1 = "Mujin Band",            --      +5
        legs = "Lethargy Fuseau +3",     -- 15

    })

    sets.midcast['Dark Magic'] = {
        ammo = "Regal Gem",
        head = "Lethargy Chappel +3",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ear2 = "Dark Earring",
        body = "Carmine Scale Mail +1",
        hands = "Lethargy Gantherots +3",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        back = gear.int_cape,
        waist = "Casso Sash",
        legs = "Lethargy Fuseau +3",
        feet = "Lethargy Houseaux +3"
    }
    sets.midcast['Dark Magic'].Weapon = { main = "Rubicundity", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Dark Magic'].DW = sets.midcast['Dark Magic'].Weapon

    sets.midcast['Absorb-TP'] = set_combine(sets.midcast['Dark Magic'], sets.midcast.FastRecast, {
        waist = "Sailfi Belt +1",
        ring2 = "Medada's Ring",
    })

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        back = gear.int_cape,
        waist = gear.DrainWaist
    })
    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.buff.ComposureOther = {
        head = "Lethargy Chappel +3",
        body = "Lethargy Sayon +3",
        hands = "Atrophy Gloves +3",
        legs = "Lethargy Fuseau +3",
        feet = "Lethargy Houseaux +3"
    }

    sets.buff.Composure = {
        head = "Lethargy Chappel +3",
        body = "Lethargy Sayon +3",
        hands = "Lethargy Gantherots +3",
        legs = "Lethargy Fuseau +3",
        feet = "Lethargy Houseaux +3"
    }

    sets.buff.Saboteur = { hands = "Lethargy Gantherots +3" }

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        ammo = "Homiliary",
        head = "Vitiation Chapeau +3",
        neck = "Bathy Choker +1",
        body = "Jhakri Robe +2",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Fucho-no-obi",
    }


    -- Idle sets
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Bathy Choker +1",
        ear1 = "Infused Earring",
        ear2 = "Etiolation Earring",
        body = "Lethargy Sayon +3",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring +1",
        back = gear.idle_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Town = {
        ammo = "Homiliary",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Infused Earring",
        ear2 = "Etiolation Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Shneddick Ring +1",
        back = gear.idle_cape,
        waist = "Blacksmith's Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Weak = {
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Infused Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring +1",
        back = gear.idle_cape,
        waist = "Fucho-no-obi",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = gear.idle_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.MDT = set_combine(sets.idle.PDT, {
        ammo = "Staunch Tathlum +1",
        body = "Nyame Mail",
        ring1 = "Shadow Ring",
        ring2 = "Archon Ring",
        waist = "Platinum Moogle Belt"
    })

    sets.idle.Refresh = set_combine(sets.idle.PDT, {
        ammo = "Homiliary",
        head = "Vitiation Chapeau +3",
        neck = "Sibyl Scarf",
        body = "Lethargy Sayon +3",
        hands = gear.chironic.refresh.hands,
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Fucho-no-obi",
        legs = "Carmine Cuisses +1",
        feet = gear.chironic.refresh.feet
    })

    sets.idle.Regain = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Republican Platinum medal",
        ear1 = "Sherida Earring",
        ear2 = "Dedition Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Roller's ring",
        ring2 = "Shneddick Ring +1",
        back = gear.stp_cape,
        waist = "Kentarch Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots",
    }

    sets.base = {}
    sets.base.idle = sets.idle
    sets.base.idle.Town = sets.idle.Town
    sets.base.idle.Weak = sets.idle.Weak
    sets.base.idle.PDT = sets.idle.PDT
    sets.base.idle.MDT = sets.idle.PDT
    sets.base.Refresh = sets.idle.Refresh

    sets.resist = {}
    sets.resist.death = {
        main = "Odium",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    sets.buff.doom = set_combine(sets.idle.PDT, {
        neck = "Nicander's Necklace",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash"
    })

    sets.buff.doom.HolyWater = set_combine(sets.idle.PDT, {
        neck = "Nicander's Necklace",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1"
    })

    -- Defense sets
    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = gear.idle_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = set_combine(sets.defense.PDT,
        { ammo = "Staunch Tathlum +1", ring1 = "Shadow Ring", ring2 = "Archon Ring", waist = "Platinum Moogle Belt" })

    sets.Kiting = { legs = "Carmine Cuisses +1" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.weapons = {}
    sets.weapons.Naegling = { main = "Naegling", sub = "Genmei Shield" }
    sets.weapons.Naegling.DW = { main = "Naegling", sub = "Thibron" }
    sets.weapons.Enspell = { main = "Aern Dagger", sub = "Sacro Bulwark" }
    sets.weapons.Enspell.DW = { main = "Aern Dagger", sub = "Aern Dagger II" }
    sets.weapons.CroceaMors = { main = "Crocea Mors", sub = "Sacro Bulwark" }
    sets.weapons.CroceaMors.DW = { main = "Crocea Mors", sub = "Daybreak" }
    sets.weapons.Maxentius = { main = "Maxentius", sub = "Genmei Shield" }
    sets.weapons.Maxentius.DW = { main = "Maxentius", sub = "Thibron" }
    sets.weapons.AeolianEdge = { main = "Tauret", sub = "Ammurapi Shield" }
    sets.weapons.AeolianEdge.DW = { main = "Tauret", sub = "Thibron" }
    sets.weapons.Dagger = { main = "Tauret", sub = "Sacro Bulwark" }
    sets.weapons.Dagger.DW = { main = "Tauret", sub = "Crepuscular Knife" }
    sets.weapons.DaggerLow = { main = "Tauret", sub = "Sacro Bulwark" }
    sets.weapons.DaggerLow.DW = { main = "Aern Dagger", sub = "Aern Dagger II" }

    sets.EnspellDamage = {
        hands = "Ayanmo Manopolas +2"
    }

    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Anu Torque",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring2 = gear.right_chirich,
        ring1 = gear.left_chirich,
        back = gear.melee_cape,
        waist = "Windbuffet Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.Acc = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring2 = gear.right_chirich,
        ring1 = gear.left_chirich,
        back = gear.melee_cape,
        waist = "Kentarch Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- crocea mors, for example
    sets.engaged.Enspell = set_combine(sets.engaged, { hands = "Ayanmo Manopolas +2" })

    -- for 0dmg enspell situations, for example
    sets.engaged.EnspellMax = set_combine(sets.engaged.Acc, {
        main = "Aern Dagger",
        sub = "Aern Dagger II",
        range = "Ullr",
        ammo = empty,
        neck = "Duelist's Torque +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        hands = "Ayanmo Manopolas +2",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.melee_cape,
        waist = "Orpheus's Sash"
    })

    sets.engaged.Crit = {
        ammo = "Yetshila +1",
        head = "Blistering Sallet +1",
        neck = "Anu Torque",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Hetairoi Ring",
        ring2 = "Begrudging Ring",
        back = gear.melee_cape,
        waist = "Reiki Yotai",
        legs = "Zoar Subligar +1",
        feet = "Ayanmo Gambieras +2"
    }

    sets.engaged.Defense = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Loricate Torque +1",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Gelatinous Ring +1",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.PDT = sets.engaged.Defense
    sets.engaged.MDT = set_combine(sets.engaged.PDT, { ring2 = "Archon Ring" })


    sets.engaged.DW = set_combine(sets.engaged,
        { waist = "Reiki Yotai" })
    sets.engaged.NormalDW = set_combine(sets.engaged.DW,
        {
            ear1 = "Eabani Earring",
            ear2 = "Suppanomimi",
            back = gear.dw_cape,
            waist = "Reiki Yotai",
            legs = "Carmine cuisses +1"
        })
    sets.engaged.Enspell.NormalDW = set_combine(sets.engaged.NormalDW, sets.EnspellDamage)

    sets.engaged.SlowDW = sets.engaged.NormalDW
    sets.engaged.Enspell.SlowDW = set_combine(sets.engaged.SlowDW, sets.EnspellDamage)

    sets.engaged.SlowMaxDW = sets.engaged.NormalDW
    sets.engaged.Enspell.SlowMaxDW = set_combine(sets.engaged.SlowMaxDW, sets.EnspellDamage)

    sets.engaged.HasteDW = set_combine(sets.engaged.DW,
        {
            ear2 = "Suppanomimi",
            back = gear.dw_cape,
            waist = "Reiki Yotai",
            legs = "Carmine Cuisses +1",
        })
    sets.engaged.Enspell.HasteDW = set_combine(sets.engaged.HasteDW, sets.EnspellDamage)

    sets.engaged.HasteMaxDW = set_combine(sets.engaged.DW, {
        ear2 = "Suppanomimi",
        waist = "Reiki Yotai"
    })
    sets.engaged.Enspell.HasteMaxDW = set_combine(sets.engaged.HasteMaxDW, sets.EnspellDamage)

    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc,
        { waist = "Reiki Yotai", legs = "Carmine Cuisses +1" })

    sets.engaged.Defense.DW = set_combine(sets.engaged.Defense, { waist = "Sailfi Belt +1", })
    sets.engaged.DW.Defense = sets.engaged.Defense.DW
    sets.engaged.DW.PDT = sets.engaged.Defense.DW
    sets.engaged.DW.MDT = set_combine(sets.engaged.PDT.DW, { ring2 = "Archon Ring" })

    sets.engaged.DW.Enspell = set_combine(sets.engaged.DW,
        { hands = "Ayanmo Manopolas +2" }
    )

    sets.engaged.DW.EnspellMax = set_combine(sets.engaged.EnspellMax, {
        range = "Ullr",
        ammo = empty,
        neck = "Duelist's Torque +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        hands = "Ayanmo Manopolas +2",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.dw_cape,
        waist = "Orpheus's Sash"
    })
    sets.engaged.EnspellMax.DW = sets.engaged.DW.EnspellMax
    sets.engaged.EnspellMax.HasteMaxDW = sets.engaged.DW.EnspellMax
    sets.engaged.EnspellMax.HasteDW = sets.engaged.DW.EnspellMax
    sets.engaged.EnspellMax.NormalDW = sets.engaged.DW.EnspellMax




    -- define idle sets

    -- Default offense mode based on subjob
    if S { 'BRD', 'COR', 'WHM', 'BLM', 'SCH', 'SMN', 'DRK', 'PLD' }:contains(player.sub_job) then
        state.OffenseMode:set('Magic')
    else
        state.TPMode:set('Expend')
    end


    -- if S { 'Normal', 'Acc', 'Enspell' }:contains(state.OffenseMode.value) then
    --     sets.idle = sets.base.idle
    --     sets.idle.Town = sets.base.idle.Town
    --     sets.idle.PDT = sets.base.idle.PDT
    --     sets.idle.Weak = sets.base.idle.Weak
    -- else
    --     sets.idle = set_combine(sets.idle, sets.idle.Weapon)
    --     sets.idle.Town = set_combine(sets.idle, sets.idle.Weapon)
    --     sets.idle.PDT = set_combine(sets.idle, sets.idle.Weapon)
    --     sets.idle.Weak = set_combine(sets.idle, sets.idle.Weapon)
    -- end
    -- sets.idle.MDT = sets.idle.PDT
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    if spell.type == 'WeaponSkill' then
        local main = player.equipment.main
        if spell.english == 'Seraph Blade' then
            if main == 'Maxentius' then
                cancel_spell()
                send_command('input /ws "Black Halo" ' .. spell.target.raw)
                return
            elseif main == 'Tauret' then
                cancel_spell()
                send_command('input /ws "Evisceration" ' .. spell.target.raw)
                return
            end
        elseif spell.english == 'Savage Blade' then
            if main == 'Tauret' then
                cancel_spell()
                send_command('input /ws "Aeolian Edge" ' .. spell.target.raw)
                return
            end
        end
    elseif spell.type == 'Scholar' then
        if player.sub_job == 'SCH' then
            agnostic_stratagems(spell)
        elseif player.sub_job == 'DRK' then
            cancel_spell()
            send_command('input /ma "Absorb-TP" ' .. spell.target.raw)
            -- elseif player.sub_job == "NIN" then
        end
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.english == 'Silence' and spell.target.in_party and not spell.target.charmed then
        cancel_spell()
        send_command("input /ma \"Cure IV\" " .. spell.target.raw)
        return
    end

    if buffactive.terror or buffactive.stun then
        eventArgs.cancel = true
        return
    end

    if spell.type ~= "WeaponSkill" then
        set_recast()
    end

    if spell.english == "Phalanx" and player.target.in_party and player.target.type ~= 'SELF' then
        eventArgs.cancel = true
        send_command('input /ma "Phalanx II" ' .. player.target.name)
        return
    elseif spell.english == "Phalanx II" and player.target.type == 'SELF' then
        eventArgs.cancel = true
        send_command("input /ma Phalanx")
        return
    elseif spell.english == 'Dispelga' then
        if player.equipment.sub == 'Daybreak' then
            cancel_spell()
            send_command("gs equip sets.precast.Dispelga.pretarget; input /ma Dispelga " .. spell.target.raw)
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArts)
    if spell.type == 'WeaponSkill' and player.tp == 3000 then
        if sets.precast.WS[spell.english] then
            if sets.precast.WS[spell.english].MaxTP then
                equip(sets.precast.WS[spell.english].MaxTP)
            end
        end
    elseif S { 'Stoneskin', 'Blink' }:contains(spell.english) then
        if buffactive[spell.english] then
            equip(sets.precast.FC.NoQC)
        end
    elseif spell.english:startswith('Utsusemi') then
        if buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or
            buffactive['Copy Image (4+)'] then
            equip(sets.precast.FC.NoQC)
        end
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and buffactive.composure then equip(sets.buff.Composure) end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    local save_TP = (state.TPMode.value == 'Preserve > 1000' and player.tp > 1000) or (state.TPMode.value == 'Preserve')

    -- handle occult acumen
    if state.ImpactMode.value == 'Occult Acumen' and spell.english == 'Impact' then
        equip(sets.midcast.OccultAcumen, sets.ImpactOnly)
        return
    end

    if spell.skill == 'Enfeebling Magic' then
        -- equip composure base if active

        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end

        if S { 'Poison II' }:contains(spell.english) then
            equip(sets.midcast['Poison II'])
        elseif S { 'Frazzle III' }:contains(spell.english) then
            equip(sets.midcast['Enfeebling Magic'].dMND,
                set_combine(sets.midcast['Enfeebling Magic'].dMND.weapon, sets.midcast['Enfeebling Magic'].HighSkill))
        elseif S { 'Distract III' }:contains(spell.english) then
            equip(sets.midcast['Enfeebling Magic'].dMND, sets.midcast['Enfeebling Magic'].HighSkill)
        elseif S { 'Paralyze II', 'Slow II', 'Addle II' }:contains(spell.english) then
            equip(sets.midcast['Enfeebling Magic'].dMND)
            if can_DW() then
                -- equip(sets.midcast['Enfeebling Magic'].DW)
                equip(sets.midcast['Enfeebling Magic'].dMND.DW)
            else
                equip(sets.midcast['Enfeebling Magic'].dMND.Weapon)
            end
        end

        -- spells that cannot get stronger with enfeebling effect+
        if S { 'Silence', 'Bind', 'Break', 'Breakga', 'Sleep', 'Sleep II', 'Sleepga', 'Sleepga II', }:contains(spell.english) then
            equip(sets.midcast['Enfeebling Magic'])
            if spell.english == 'Silence' then
                equip(sets.midcast['Enfeebling Magic'].Duration)
                if buffactive.composure then
                    equip(sets.buff.Composure)
                end
            else
                if buffactive.composure then
                    equip(sets.buff.Composure)
                end
                equip(sets.midcast['Enfeebling Magic'].Duration)
            end
            if state.CastingMode.value == 'Resistant' or not can_DW() then
                equip(sets.midcast['Enfeebling Magic']
                    .Weapon)
            end
        end

        -- Immunobreakable spells
        if S { 'Slow', 'Slow II', 'Paralyze', 'Paralyze II', 'Addle', 'Addle II', 'Poison II', 'Blind', 'Blind II',
                'Gravity', 'Gravity II', 'Bind', 'Break', 'Sleep', 'Sleep II', 'Sleepga', 'Sleepga II', 'Silence' }:contains(spell
                .english) and not (buffactive.Stymie or buffactive['Elemental Seal']) then
            equip(sets.midcast['Enfeebling Magic'].Immunobreak)
        end

        if (spell.english == 'Dispel' or spell.english == 'Dispelga') and state.CastingMode.value == 'Resistant' then
            equip(sets.midcast['Dispel'].Acc)
        end
        if spell.english == 'Dispelga' then
            equip(sets.midcast.Dispelga)
        end
    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast['Enhancing Magic'])
        local weapon_set = nil

        if can_DW() and not save_TP then
            weapon_set = 'DW'
        elseif not save_TP then
            weapon_set = 'Weapon'
        else
            weapon_set = 'None'
        end

        -- skill independant but special gear
        if spell.english:startswith('Refresh') then
            if spell.target.type ~= 'SELF' then
                equip(set_combine(sets.midcast['Enhancing Magic'].Duration, sets.midcast.Refresh))
            else
                equip(sets.midcast.Refresh)
                equip(sets.midcast.Gishdubar)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        elseif spell.english:startswith('Regen') then
            equip(sets.midcast['Enhancing Magic'].Duration, sets.midcast['Enhancing Magic'].Duration[weapon_set])
            if spell.target.type ~= 'SELF' then
                equip(set_combine(sets.midcast.Regen, sets.midcast['Enhancing Magic'].Duration, sets.buff.ComposureOther))
            else
                equip(sets.midcast.Regen)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        elseif spell.english:startswith('Protect') or spell.english:startswith('Shell') then
            if spell.target.type ~= 'SELF' then
                equip(sets.buff.ComposureOther)
            else
                equip(set_combine(sets.midcast['Enhancing Magic'].Duration, sets.midcast.ProShell.Self))
            end

            -- pure skill enhancing magic
        elseif spell.english:startswith('Temper') then
            equip(set_combine(sets.midcast['Enhancing Magic'].PureSkill, sets.midcast['Enhancing Magic'][weapon_set]))
        elseif spellMap == 'Enspell' then
            equip(set_combine(sets.midcast['Enhancing Magic'].PureSkill, sets.midcast['Enhancing Magic'][weapon_set]))

            -- caps at 500 skill
        elseif spellMap == 'BarElement' then
            if spell.target.type ~= 'SELF' then
                equip(sets.buff.ComposureOther, sets.midcast.BarElement)
            else
                equip(sets.midcast.BarElement)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        elseif spellMap == 'BarStatus' then
            equip(set_combine(sets.buff.ComposureOther, sets.midcast.BarStatus,
                sets.midcast['Enhancing Magic'].Duration[weapon_set]))
        elseif spellMap == 'GainStat' then
            equip(set_combine(sets.midcast['Enhancing Magic'].GainStat,
                sets.midcast['Enhancing Magic'].Duration[weapon_set]))
            -- skill enhancing, but has other factors that influence it
        elseif spell.english == 'Phalanx' and spell.target.type == 'SELF' then
            equip(set_combine(sets.midcast.Phalanx, sets.midcast.Phalanx[weapon_set]))
            -- because of their potential high usage and ease of capping,
            -- stoneskin, aquaveil, and blink won't change weapons
        elseif S { 'Stoneskin', 'Aquaveil' }:contains(spell.english) then
            equip(sets.midcast[spell.english])
        elseif spell.english == 'Blink' then
            equip(sets.midcast['Enhancing Magic'].Duration)
        elseif S { 'Invisible', 'Sneak', 'Deodorize' }:contains(spell.english) then
            equip(sets.midcast['Enhancing Magic'].Duration)
        else
            -- if unknown/undef, just go with duration
            -- equip(sets.midcast['Enhancing Magic'].Duration)
            if buffactive.composure then
                if spell.target.type ~= 'SELF' then
                    equip(sets.buff.ComposureOther)
                else
                    equip(sets.buff.Composure)
                    equip(sets.midcast['Enhancing Magic'].Duration)
                end
                equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
            end
        end

        adjust_timers_enhancing(spell, spellMap)
    elseif spell.skill == 'Healing Magic' then
        if spell.english:startswith('Cure') and spell.target.type == 'SELF' then
            equip(sets.midcast.CureSelf)
        elseif spell.english == 'Cursna' and spell.target.type == 'SELF' then
            equip(sets.midcast.CursnaSelf)
        end
    elseif spell.skill == 'Divine Magic' then
        if spell.english:startswith('Banish') then
            equip(sets.midcast.Banish)
        end
    elseif spell.skill == 'Elemental Magic' then
        if not save_TP and (numeral_to_digit(get_spell_tier(spell)) > 1) then
            if spell.element:lower() == 'wind' then
                equip(sets.midcast['Elemental Magic'].Weapon.Wind)
                -- equip(sets.midcast['Elemental Magic'].Weapon)
            elseif can_DW() then
                equip(sets.midcast['Elemental Magic'].DW)
            else
                equip(sets.midcast['Elemental Magic'].Weapon)
            end
        end
    end

    if spell_burstable:contains(spell.english) and (state.MagicBurstMode.value == 'Always' or state.MagicBurstMode.value == 'Once') then
        equip(sets.midcast.MagicBurst)
        if state.MagicBurstMode.value == 'Once' then
            state.MagicBurstMode:set('Normal')
            windower.add_to_chat(122, 'Magic Bursting. State reset')
        end
    end

    -- Treasure Hunter handling
    if state.TreasureMode.value == 'Tag' and S { 'Poisonga', 'Poison', 'Diaga' }:contains(spell.english) then
        equip(sets.TreasureHunter)
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.RangedMode.value == 'Normal' then
        equip({ range = gear.default_ranged, ammo = gear.default_ranged_ammo })
    end

    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end

    -- handle enspell damage
    handle_enspell_equip()
    equip_recast()

    -- go here
    -- equip(sets.weapons.CroceaMors.DW)

    if state.OffenseMode.value == "EnspellMax" then
        equip(sets.engaged.EnspellMax)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == "Offense Mode" then
        if S { 'Normal', 'Acc', 'Enspell' }:contains(newValue) then
            sets.idle = sets.base.idle
            sets.idle.Town = sets.base.idle.Town
            sets.idle.PDT = sets.base.idle.PDT
            sets.idle.Weak = sets.base.idle.Weak
        else
            sets.idle = set_combine(sets.idle, sets.idle.Weapon)
            sets.idle.Town = set_combine(sets.idle, sets.idle.Weapon)
            sets.idle.PDT = set_combine(sets.idle, sets.idle.Weapon)
            sets.idle.Weak = set_combine(sets.idle, sets.idle.Weapon)
        end
        sets.idle.MDT = sets.idle.PDT
    elseif stateField == 'Ranged Mode' then
        if newValue == 'Normal' then
            equip({ range = gear.default_ranged, ammo = gear.default_ranged_ammo })
            disable('range', 'ammo')
        else
            enable('range', 'ammo')
        end
    end
    --[[elseif stateField == 'Magic Burst' then
        if state.MagicBurstMode.value then
            add_to_chat(122, 'Magic Burst enabled')
        else
            add_to_chat(122, 'Magic Burst disabled')
        end]]
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = 'Melee'

    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end

    msg = msg .. melee_groups_to_string()

    msg = msg .. ': '

    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value

    -- if state.Kiting.value == true then
    --     msg = msg .. ', Kiting'
    -- end

    -- if state.PCTargetMode.value ~= 'default' then
    --     msg = msg .. ', Target PC: ' .. state.PCTargetMode.value
    -- end

    -- if state.SelectNPCTargets.value == true then
    --     msg = msg .. ', Target NPCs'
    -- end

    if state.MagicBurstMode.value == 'Magic Burst' then
        msg = msg .. ', Magic Burst'
    end

    windower.add_to_chat(122, msg)
    -- display_current_caster_state()
    eventArgs.handled = true
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            -- if spell.type == 'WhiteMagic' then
            return 'MndEnfeebles'
            -- else
            --     return 'IntEnfeebles'
            -- end
            --[[elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end]]
        end
    end
end

function job_buff_change(buff, gain)
    if gain then
        if S { 'haste', 'march', 'embrava', 'haste samba', 'slow', 'elegy' }:contains(buff:lower()) then
            update_combat_form()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('gs equip sets.idle.PDT')
            send_command('input /p Charmed')
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs equip sets.idle.PDT')
        elseif buff == 'sleep' then
            if buffactive['Stoneskin'] and has_poison_debuff(buffactive) then send_command('cancel stoneskin') end
        elseif buff == 'Level Restriction' then
            bind_weapons()
        elseif buff:startswith('En') then
            update_combat_form()
        end
    else
        if S { 'haste', 'march', 'embrava', 'haste samba', 'slow', 'elegy' }:contains(buff:lower()) then
            update_combat_form()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off')
        elseif buff == 'doom' then
            send_command('input /p Doom off')
            send_command('gs c update')
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs c update')
        elseif buff == 'Level Restriction' then
            bind_weapons()
        elseif buff:startswith('En') then
            update_combat_form()
        end
    end
    if buff:lower():contains('defense down') then
        if gain then
            windower.add_to_chat(144, "Defense down gained!")
        end
    elseif buff:lower():contains('max hp down') then
        if gain then
            windower.add_to_chat(144, "Max HP down!")
        end
    end
end

function job_update(cmdParams, eventArgs)
    update_combat_form()
    -- set_DW_class()

    th_update(cmdParams, eventArgs)

    if is_stunned() then
        send_command('gs equip sets.idle.PDT')
    elseif buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            send_command('gs equip sets.buff.doom')
        elseif state.DoomMode.value == 'Holy Water' then
            send_command('gs equip sets.buff.doom.HolyWater')
        end
    end
end

function update_combat_form()
    determine_melee_groups()
    if has_enspell_effect() and info.enspell_weapons:contains(player.equipment.main) then
        classes.CustomMeleeGroups:append('Enspell')
    end
end

function bind_weapons()

end

-- for use in buff/gain-
function handle_enspell()
    update_combat_form()
    if info.enspell_weapons:contains(player.equipment.main) and has_enspell_effect() and player.status == 'Engaged' then
        send_command('gs equip sets.EnspellDamage')
    elseif has_enspell_effect() then
        send_command('gs c update')
    end
end

-- for use in aftercast
function handle_enspell_equip()
    update_combat_form()
    if info.enspell_weapons:contains(next_recast_weapon()) and has_enspell_effect() and player.status == 'Engaged' then
        equip(sets.EnspellDamage)
    end
end

function has_enspell_effect()
    return buffactive
        and ((buffactive['Enfire'] or false)
            or (buffactive['Enfire II'] or false)
            or (buffactive['Enwater'] or false)
            or (buffactive['Enwater II'] or false)
            or (buffactive['Enstone'] or false)
            or (buffactive['Enstone II'] or false)
            or (buffactive['Enaero'] or false)
            or (buffactive['Enaero II'] or false)
            or (buffactive['Enthunder'] or false)
            or (buffactive['Enthunder II'] or false)
            or (buffactive['Enblizzard'] or false)
            or (buffactive['Enblizzard II'] or false)
            or (buffactive['Enlight'] or false) -- just in case, ygnas can grant enlight - but it sucks
            or (buffactive['Enlight II'] or false)
            or (buffactive['Endark'] or false)
            or (buffactive['Endark II'] or false)
        )
end

function adjust_timers_enhancing(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end

    local current_time = os.time()

    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.

    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for spell_name, expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[spell_name] = true
        end
    end
    for spell_name, expires in pairs(temp_timer_list) do
        custom_timers[spell_name] = nil
        custom_timers.basetime[spell_name] = nil
    end

    local dur = calculate_duration_enhancing(spell.name, spellMap)
    if custom_timers[spell.name] then
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "' .. spell.name .. '"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
        end
    else
        send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers_enhancing(), which is only called on aftercast().
function calculate_duration_enhancing(spellName, spellMap)
    local mult = 1
    local base_duration = 0

    if spellName.english:startswith('Bar') then base_duration = 8 * 60 end
    if spellName.english:startswith('Protect') then base_duration = 30 * 60 end
    if spellName.english:startswith('Shell') then base_duration = 30 * 60 end
    if spellName.english 'Aquaveil' then base_duration = 10 * 60 end
    if spellName.english:startswith('En') then base_duration = 3 * 60 end
    if spellName.english 'Blaze Spikes' then base_duration = 3 * 60 end
    if spellName.english 'Ice Spikes' then base_duration = 3 * 60 end
    if spellName.english 'Shock Spikes' then base_duration = 3 * 60 end
    if spellName.english 'Regen' then base_duration = 75 end
    if spellName.english 'Regen II' then base_duration = 60 end
    if spellName.english 'Blink' then base_duration = 5 * 60 end
    if spellName.english 'Phalanx' then base_duration = 180 end
    if spellName.english 'Phalanx II' then base_duration = 240 end
    if spellName.english 'Stoneskin' then base_duration = 5 * 60 end
    if spellName.english 'Refresh' then base_duration = 150 end
    if spellName.english 'Refresh II' then base_duration = 150 end
    if spellName.english 'Refresh III' then base_duration = 150 end
    if spellName.english 'Flurry' then base_duration = 3 * 60 end
    if spellName.english 'Flurry II' then base_duration = 3 * 60 end
    if spellName.english 'Haste' then base_duration = 3 * 60 end
    if spellName.english 'Haste II' then base_duration = 3 * 60 end
    if spellName.english:startswith('Gain-') then base_duration = 5 * 60 end
    if spellName.english 'Temper' then base_duration = 3 * 60 end
    if spellName.english 'Temper II' then base_duration = 180 end
    if spellName.english:endswith('storm') then base_duration = 3 * 60 end

    -- get equipment bonuses
    if player.equipment.body == 'Vitiation Tabard +2' then mult = mult + 0.1 end
    if player.equipment.body == 'Vitiation Tabard +3' then mult = mult + 0.15 end
    if player.equipment.hands == 'Atrophy Gloves' then mult = mult + 0.15 end
    if player.equipment.hands == 'Atrophy Gloves +1' then mult = mult + 0.16 end
    if player.equipment.hands == 'Atrophy Gloves +2' then mult = mult + 0.18 end
    if player.equipment.hands == 'Atrophy Gloves +3' then mult = mult + 0.2 end
    if player.equipment.back == "Sucellos's Cape" then mult = mult + 0.2 end
    if player.equipment.waist == "Embla Sash" then mult = mult + 0.1 end
    if player.equipment.feet == 'Lethargy Houseaux' then mult = mult + 0.25 end
    if player.equipment.feet == 'Leth. Houseaux +1' then mult = mult + 0.30 end
    if player.equipment.feet == 'Leth. Houseaux +2' then mult = mult + 0.35 end
    if player.equipment.feet == 'Leth. Houseaux +3' then mult = mult + 0.40 end
    if player.equipment.sub == 'Ammurapi Shield' then mult = mult + 0.16 end
    if player.equipment.main == 'Oranyan' then mult = mult + 0.1 end

    -- get composure bonus
    local composure_count = 0

    if player.equipment.feet:startswith('Leth') or player.equipment.feet == 'Estq. Houseaux +2' then
        composure_count = composure_count
            + 1
    end

    if player.equipment.head:startswith('Lethargy') or player.equipment.head == 'Estq. Chappel +2' then
        composure_count = composure_count
            + 1
    end
    if player.equipment.body:startswith('Lethargy') or player.equipment.body == 'Estq. Sayon +2' then
        composure_count = composure_count
            + 1
    end
    if player.equipment.hands:startswith('Lethargy') or player.equipment.hands == 'Estq. Gantherots +2' then
        composure_count = composure_count
            + 1
    end
    if player.equipment.legs:startswith('Lethargy') or player.equipment.legs == 'Estq. Fuseau +2' then
        composure_count = composure_count
            + 1
    end

    if buffactive.composure then
        if spellName.target.name == player.name then
            mult = mult * 3
        else
            if composure_count == 5 then
                mult = mult + 0.5
            elseif composure_count == 4 then
                mult = mult + 0.35
            elseif composure_count == 3 then
                mult = mult + 0.2
            elseif composure_count == 2 then
                mult = mult + 0.1
            end
        end
    end

    if S { "Duelist's Gloves +2", 'Vitiation Gloves', 'Vitiation Gloves +1', 'Vitiation Gloves +2', 'Vitiation Gloves +3' }
        :contains(player.equipment.hands) then
        base_duration = base_duration + (info.JobPoints.EnhancingMerits * 9)
    else
        base_duration = base_duration + (info.JobPoints.EnhancingMerits * 6)
    end
    base_duration = base_duration + info.JobPoints.EnhancingDuration

    local totalDuration = math.floor(mult * base_duration)

    return totalDuration
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or                                            -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or                         -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
    then
        return true
    end
end

-- check if there is something in the sub slot
function procSub()
    local currentWeapon = player.equipment.main
    if player.equipment.sub == 'empty' then
        if info.Weapons.Twohanded:contains(info.Weapons.Type[currentWeapon]) then
            equip(sets.TwoHand_OH)
        else
            equip(sets.OneHand_OH)
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    local command = cmdParams[1]:lower()

    local function second_arg(cmdParams)
        t = T {}
        for k, v in pairs(cmdParams) do
            -- print(k, v)
            if k ~= 1 then t:append(v) end
        end
        if t:length() < 1 then return nil else return t end
    end

    local arg = second_arg(cmdParams) or nil
    if arg then arg = arg:sconcat() end

    -- call with:
    -- gs c cb "Bubbly Broth"
    -- or in a macro
    -- /console gs c cb "Bubbly Broth"
    if false then
    elseif command == 'equip' then
        -- print(arg)
        job_custom_weapon_equip(arg)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(9, 4)
    elseif player.sub_job == 'NIN' then
        set_macro_page(6, 4)
    elseif player.sub_job == 'WHM' then
        set_macro_page(2, 4)
    elseif player.sub_job == 'BLM' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'SCH' then
        set_macro_page(2, 4)
    else
        set_macro_page(1, 4)
    end

    if S { 'DNC', 'NIN' }:contains(player.sub_job) then
        send_command("@wait 5;input /lockstyleset 14")
    elseif player.sub_job == 'DRK' then
        send_command("@wait 5;input /lockstyleset 10")
    else
        send_command("@wait 5;input /lockstyleset 9")
    end
end
