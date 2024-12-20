-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    indi_timer = ''
    indi_duration = 180

    -- Event driven functions
    ticker = windower.register_event('time change', function(myTime)
        if isMainChanged() then
            -- procSub()
            -- if state.AutoMacro.value then
            --     weapon_macro_book()
            -- end
            determine_combat_weapon()
        end
    end)

    info = info or {}
    info.offensive_bubbles = S { "Vex", "Torpor", "Slow", "Slip", "Poison", "Paralysis", "Malaise", "Languor", "Gravity", "Frailty", "Fade", "Wilt" }
end

function update_combat_form()
    determine_combat_weapon()
    check_FullTP()
    if buffactive['Aftermath'] then
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.1'] then
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.2'] then
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.3'] then
        classes.CustomMeleeGroups:append('AM3')
    end
    reset_combat_form()
end

function determine_combat_weapon()
    -- if a weapon has a specific combat form, switch to that
    if info.Weapons.REMA:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
        echo('CombatWeapon: ' .. player.equipment.main .. ' set', 1)
    else
        state.CombatWeapon:reset()
        echo('CombatWeapon: Normal set', 1)
    end
    echo('CombatWeapon mode: ' .. state.CombatWeapon.value, 1)
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')
    include('natty_includes.lua')

    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant', 'Low')
    state.IdleMode:options('Normal', 'PDT')

    state.MagicBurst = M(false, 'Magic Burst')
    state.OccultAcumen = M(false, 'Occult Acumen')

    if player.sub_job == 'DRK' then
        state.OccultAcumen:set(true)
    end

    send_command('bind f9 gs c cycle CastingMode')
    send_command('bind ^f11 gs c cycle OffenseMode')

    send_command('bind numpad7 gs equip sets.weapons.Idris')
    send_command('bind numpad8 gs equip sets.weapons.Maxentius')

    send_command('bind numpad1 input /ma "Cure IV" <t>')

    send_command('bind numpad4 input /ja "Blaze of Glory"')
    send_command('bind numpad5 input /ja "Ecliptic Attrition"')
    send_command('bind numpad6 input /ja "Life Cycle"')


    send_command('bind !` gs c cycle MagicBurst')

    select_default_macro_book()
end

function user_unload()
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.default.weaponskill_waist = "Cornelia's Belt"
    gear.default.obi_waist = "Orpheus's Sash"
    gear.default.drain_waist = "Fucho-no-Obi"
    gear.default.cure_waist = "Embla Sash"

    gear.int_cape = { name = "Nantosuelta's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', '"Mag.Atk.Bns."+10', 'Phys. dmg. taken-10%', } }
    gear.luopan_cape = { name = "Nantosuelta's Cape", augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Pet: "Regen"+10', 'Pet: "Regen"+5' } }
    gear.mnd_ws_cape = { name = "Nantosuelta's Cape", augments = { 'MND+20', 'Accuracy+20 Attack+20', 'MND+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%' } }
    gear.melee_cape = { name = "Nantosuelta's Cape", augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }
    gear.tp_cape = { name = "Nantosuelta's Cape", augments = { 'DEX+20', 'Accuracy+20 Attack+20', '"Store TP"+10', 'Phys. dmg. taken-10%', } }

    sets.weapons = {}
    sets.weapons.Idris = { main = "Idris", sub = "Genmei Shield" }
    sets.weapons.Maxentius = { main = "Maxentius", sub = "Genmei Shield" }


    --------------------------------------
    -- Misc sets
    --------------------------------------
    sets.SIRD = {                    -- 5
        -- Aquaveil head
        head = "Agwu's Hat",         -- 10
        neck = "Loricate Torque +1", -- 5
        ear1 = "Magnetic Earring",   -- 8
        ear2 = "Hasalz Earring",     -- 5
        body = "Rosette jaseran +1", -- 25
        hands = "Amalric Gages +1",  -- 11
        ring1 = "Evanescence Ring",  -- 5
        ring2 = "Freke Ring",        -- 10
        back = "Fi Follet Cape +1",  -- 10 -- wait not really? needs to be a special cape
        waist = "Emphatikos rope",   -- 12
        legs = "Geomancy Pants +1",  -- 20
        feet = "Amalric Nails +1"    -- 16
    }

    -- full = 142
    -- aquaveil set = 101
    -- indi set = 96
    -- geo set = 137

    sets.FullTP = {
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Dedition Earring",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.tp_cape,
        waist = "Oneiros Rope",
        legs = "Jhakri Slops +2",

    }

    sets.ConserveMP = {
        ammo = "Pemphredo Tathlum",
        head = "Ipoca Beret",
        ear1 = "Magnetic Earring",
        ear2 = "Mendicant's Earring",
        body = "Amalric Doublet +1",
        -- hands = "Wicce Gloves +2",
        ring1 = "Mephitas's Ring +1",
        ring2 = "Freke Ring",
        back = "Fi Follet Cape +1",
        waist = "Shinjutsu-no-obi+1",
        legs = "Lengo Pants",
        -- feet = "Wicce Sabots +2",
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    sets.buff['Entrust'] = {
        main = gear.gada.indi
    }

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = { body = "Bagua Tunic +1" }
    sets.precast.JA['Life cycle'] = { body = "Geomancy Tunic +1", back = "Nantosuelta's Cape" }
    sets.precast.JA['Primeval Zeal'] = { head = "Bagua Galero +1" }
    sets.precast.JA['Curative Recantation'] = { hands = "Bagua Mitaines +1" }
    sets.precast.JA['Mending Halation'] = { legs = "Bagua Pants +1" }
    sets.precast.JA['Radial Arcana'] = { feet = "Bagua Sandals +3" }
    sets.precast.JA['Concentric Pulse'] = { head = "Bagua Galero +1" }

    -- Fast cast sets for spells
    sets.precast.FC = {
        -- gear.grioavolr.fc,
        -- range = "Dunna",              -- 3
        head = gear.merlinic.fc.head,   -- 15
        neck = "Orunmila's Torque",     -- 5
        ear1 = "Malignance Earring",    -- 4
        ear2 = "Loquacious Earring",    -- 2
        body = gear.merlinic.fc.body,   -- 13
        hands = gear.merlinic.fc.hands, -- 7
        ring1 = "Kishar Ring",          -- 6
        ring2 = "Rahab Ring",           -- 10
        back = "Perimede Cape",
        waist = "Shinjutsu-no-obi +1",  -- 5
        -- waist = { name = "Platinum Moogle belt", priority = 10 },
        -- legs = "Geomancy Pants +1",  -- 11
        legs = "Agwu's Slops",       -- 7
        feet = gear.merlinic.fc.feet -- 12
    }
    sets.precast.Geomancy = set_combine(sets.precast.FC, { range = "Dunna" })

    sets.precast['Dispelga'] = set_combine(sets.precast.FC,
        { main = { name = "Daybreak", priority = 9 }, sub = { name = "Ammurapi Shield", priority = 10 } })

    sets.precast['Impact'] = set_combine(sets.precast.FC, { head = empty, body = "Crepuscular Cloak" })
    sets.precast.FC['Impact'] = set_combine(sets.precast.FC, { head = empty, body = "Crepuscular Cloak" })


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.ws_cape,
        waist = "Acuity Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
        waist = "Luminary Sash"
    })

    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum Medal",
        waist = "Prosilio Belt +1",
    })

    sets.precast.WS['Starlight'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Moonlight'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Exudation'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Hexastrike'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Retribution'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {})

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        ear1 = "Malignance earring",
        ear2 = "Loquacious Earring",
        hands = "Telchine Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Kishar Ring",
    }

    sets.midcast.Geomancy = {
        main = "Idris",
        range = "Dunna",
        head = "Azimuth Hood +3",
        neck = "Bagua Charm +2",
        body = "Bagua Tunic +1",
        hands = "Geomancy Mitaines +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini
    }
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        back = "Lifestream Cape",
        legs = "Bagua Pants +1",
        feet = "Azimuth Gaiters +3"
    })

    sets.midcast['Elemental Magic'] = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = "Azimuth Hood +3",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Azimuth Coat +3",
        hands = "Azimuth Gloves +2",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.int_cape,
        waist = gear.ElementalObi,
        legs = "Azimuth Tights +3",
        feet = "Azimuth Gaiters +3"
    }
    sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {
        head = empty,
        neck = "Incanter's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Malignance Earring",
        ring1 = "Metamorph Ring +1",
        waist = "Acuity Belt +1"
    })
    sets.midcast['Elemental Magic'].Low = {
        main = "Caduceus",
        sub = "Sm. Escutcheon",
        head = "Azimuth Hood +3",
        neck = "Loricate Torque +1",
        ear1 = "Handler's Earring +1",
        ear2 = "Rimeice Earring",
        body = "Seidr Cotehardie",
        hands = "Geomancy Mitaines +3",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shadow Ring",
        back = "Moonlight Cape",
        waist = "Platinum Moogle belt",
        legs = "Bagua Pants +1",
        feet = "Bagua Sandals +3",
    }

    sets.midcast['Elemental Magic'].Dark = {
        head = "Pixie Hairpin +1",
        ring1 = "Archon Ring",
    }

    sets.magic_burst = {
        head = "Ea Hat +1",              -- 7
        neck = "Mizukage-no-kubikazari", -- 10
        body = "Azimuth Coat +3",
        hands = "Agwu's Gages",
        -- ring1 = "Mujin Band",
        legs = "Azimuth Tights +3",
        feet = "Agwu's Pigaches",
    }

    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'].Acc, {
        head = empty,
        body = "Crepuscular Cloak",
        ring1 = "Archon Ring"
    })
    sets.midcast['Impact'].Occult = set_combine(sets.FullTP, gear.merlinic.occultacumen,
        { head = empty, body = "Crepuscular Cloak" })

    sets.midcast['Dark Magic'] = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = "Cath Palug Crown",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ear2 = "Dark Earring",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        waist = "Casso Sash",
    }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        head = "Bagua Galero +1",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        waist = gear.DrainWaist
    })
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        head = "Cath Palug Crown",
        neck = "Erra Pendant",
        ring2 = "Kishar Ring",
    })

    sets.midcast['Enhancing Magic'] = {
        main = "Grioavolr",
        head = "Befouled Crown",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Telchine Chasuble",
        hands = "Ayao's Gages",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = "Shedir Seraweels",
        feet = gear.telchine.enh_dur.feet
    }

    sets.midcast.Aquaveil = set_combine({
        ammo = "Staunch Tathlum +1", -- 11
        head = "Amalric Coif +1",    --         2
        neck = "Loricate Torque +1", -- 5
        ear1 = "Magnetic Earring",   -- 8
        ear2 = "Halasz Earring",     -- 5
        body = "Rosette Jaseran +1", -- 25
        hands = "Regal Cuffs",       --         2
        ring1 = "Evanescence Ring",  -- 5
        ring2 = "Freke Ring",        -- 10
        waist = "Emphatikos Rope",   -- 12      1
        legs = "Shedir Seraweels",   --         1
        feet = "Amalric Nails +1"    -- 16
    })
    sets.midcast.Stoneskin = set_combine(sets.SIRD, {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    })

    sets.midcast.Refresh = {
        head = "Amalric Coif +1",
        waist = "Gishdubar Sash"
    }


    sets.midcast['Enfeebling Magic'] = {
        -- main = "Contemplator +1",
        -- sub = "Enki Strap",
        -- ammo = "Pemphredo Tathlum",
        head = "Agwu's Cap",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Dignitary's Earring",
        body = "Agwu's robe",
        hands = "Agwu's Gages",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = gear.chironic.enfeebling.legs,
        feet = "Agwu's Pigaches",
    }
    sets.midcast['Dispelga'] = set_combine(sets.midcast['Enfeebling Magic'], { main = "Daybreak" })

    sets.midcast.Poison = set_combine(sets.midcast['Enfeebling Magic'], {
        neck = "Incanter's Torque",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Casso Sash",
        legs = "Chironic Hose",
    })
    sets.midcast['Poison II'] = sets.midcast.Poison

    sets.midcast['Healing Magic'] = {
        neck = "Incanter's Torque",
        ear1 = "Beatific Earring",
        ear2 = "Meili Earring",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini
    }

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        back = "Oretania's Cape +1",
    })

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        -- head = "Vanya Hood",
        neck = "Nodens Gorget",
        body = "Gendewitha Bliault +1",
        hands = "Telchine Gloves",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    })

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Protectra = { ring1 = "Sheltered Ring", waist = "Embla Sash" }

    sets.midcast.Shellra = { ring1 = "Sheltered Ring", waist = "Embla Sash" }


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
        head = "Nefer Khat +1",
        neck = "Bathy Choker +1",
        body = "Gendewitha Bliault +1",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Austerity Belt +1",
        legs = "Agwu's Slops",
        feet = "Chelona Boots +1"
    }


    -- Idle sets

    sets.idle = {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Azimuth Coat +3",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Fucho-no-obi",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.PDT = {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Fucho-no-obi",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = {
        range = "Dunna",
        head = "Azimuth Hood +3",
        neck = "Bagua Charm +2",
        ear1 = "Handler's Earring +1",
        ear2 = "Rimeice Earring",
        body = "Nyame Mail",
        hands = "Geomancy Mitaines +3",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = gear.luopan_cape,
        waist = "Isa Belt",
        legs = "Nyame Flanchard",
        feet = "Bagua Sandals +3"
    }

    sets.idle.PDT.Pet = {
        range = "Dunna",
        head = "Nyame Helm",
        neck = "Bagua Charm +2",
        ear1 = "Handler's Earring +1",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = "Moonlight Cape",
        waist = "Isa Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, {})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {})
    sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {})
    sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {})

    sets.idle.Town = set_combine(sets.idle, {
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Infused Earring",
        ear2 = "Brachyura Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Shneddick Ring +1",
        waist = "Blacksmith's Belt",
    })

    -- sets.idle.Weak = {
    --     head = "Nefer Khat +1",
    --     neck = "Bathy Choker +1",
    --     ear1 = "Lugalbanda Earring",
    --     ear2 = "Etiolation Earring",
    --     body = "Jhakri Robe +2",
    --     hands = "Serpentes Cuffs",
    --     ring1 = "Gelatinous Ring +1",
    --     ring2 = "Shneddick Ring +1",
    --     back = "Umbra Cape",
    --     waist = "Fucho-no-obi",
    --     legs = "Agwu's Slops",
    --     feet = "Nyame Sollerets"
    -- }

    -- Defense sets

    sets.defense.PDT = {
        range = "Dunna",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = {
        range = "Dunna",
        head = "Agwu's Cap",
        neck = "Warder's Charm +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Shadow Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Aurist's Cape +1",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.Kiting = { feet = "Geomancy Sandals +1" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Amar Cluster",
        head = "Nyame Helm",
        neck = "Bagua Charm +2",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Nyame Mail",
        hands = "Gazu Bracelets +1",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Grunfeld Rope",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.engaged.Idris = sets.engaged

    sets.engaged.Idris.AM3 = set_combine({
        back = gear.tp_cape, ear2 = "Crepusclar Earring"
    })

    --------------------------------------
    -- Custom buff sets
    --------------------------------------
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    print(spell.target, spell.english)
end

entrustflag = false
function job_pretarget(spell, action, spellMap, eventArgs)
    -- remap to entrust if targeting a party member
    if spell.skill == 'Geomancy'
        and spell.english:startswith('Indi-')
        and player.target.in_party
        and player.target.type ~= 'SELF'
        and (windower.ffxi.get_ability_recasts()[93] == 0) then
        eventArgs.cancel = true
        windower.add_to_chat(36, "Remapping to Entrust for targeted party member.")
        send_command("input /ja 'Entrust' <me>")
        entrustflag = true
        -- remap indi spell to self if entrust is not active and not targeting self
    elseif spell.skill == 'Geomancy'
        and spell.english:startswith('Indi-')
        and not buffactive['Entrust']
        and not entrustflag
        and spell.target.type ~= 'SELF' then
        eventArgs.cancel = true
        windower.add_to_chat(36, "Retargeting self for Indi spell.")
        send_command("input /ma \"" .. spell.english .. "\" <me>")
    elseif spell.skill == 'Geomancy'
        and spell.english:startswith('Geo-')
        and pet.isvalid then
        eventArgs.cancel = true
        send_command('input /ja "Full Circle"')
    elseif spell.english == 'Full Circle' and not pet.isvalid then
        cancel_spell()
        local bubble = get_last_bubble()
        send_command('input /ja "' .. bubble.spell .. '" ' .. bubble.target)
    end
    -- print(spell.english)
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type ~= "WeaponSkill" then set_recast() end

    if spell.english:startswith('Indi-') and entrustflag then entrustflag = false end

    -- print(spell.type)


    if spell.english == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english:startswith('Warp') or spell.english == 'Retrace' or spell.english == "Escape" or spell.english:startswith('Teleport') then
        equip(sets.ConserveMP)
        return
    elseif spell.english:startswith('Cure') and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end

    if spell.type:endswith('Magic') and spell.target.type == 'MONSTER' then
        if spell.skill == 'Elemental Magic' then
            if S { 'Meteor' }:contains(spell.english) then
                equip(sets.midcast['Elemental Magic'].Skill)
            elseif S { 'Drown', 'Shock', 'Rasp', 'Choke', 'Burn', 'Frost' }:contains(spell.english) then
                equip(sets.midcast.ElementalEnfeeble)
            elseif spell.element:lower() == 'wind' then
                equip(sets.midcast['Elemental Magic'])
                if state.OffenseMode.value == 'None' then
                    equip(sets.midcast['Elemental Magic'])
                end
            elseif spell.element:lower() == 'light' then
                equip(sets.midcast['Elemental Magic'].Light)
                if state.OffenseMode.value == 'None' then
                    equip(sets.midcast['Elemental Magic'].Light.weapon)
                end
            elseif spell.element:lower() == 'dark' then
                equip(sets.midcast['Elemental Magic'].Dark)
                if state.OffenseMode.value == 'None' then
                    equip(sets.midcast['Elemental Magic'].Dark.weapon)
                end
            end
            if state.MagicBurst.value then
                equip(sets.magic_burst)
            end
            if state.CastingMode.value == 'Low' then
                equip(sets.midcast['Elemental Magic'].Low)
            end
            -- if state.MPReturn.value
            --     and (not job_get_spell_map(spell) or S { 'AreaOfEffect', 'CumulativeMagic', 'LowTierNuke' }:contains(job_get_spell_map(spell))) then
            --     equip(sets.midcast.MPReturn)
            -- end
        elseif spell.skill == 'Dark Magic' then
            if state.MagicBurst.value then
                equip(sets.magic_burst)
            end
        end
    end



    if spell.english == 'Impact' then
        if state.OccultAcumen.value then
            equip(sets.midcast.Impact.Occult)
        else
            equip(sets.midcast.Impact)
        end
    end

    if spell.english == 'Sleepga' then
        equip(sets.SIRD)
    end

    if spell.english == 'Cure' then
        equip({ main = "", sub = "", range = "", ammo = "" })
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
        elseif spell.english:startswith('Geo') then
            set_last_bubble(spell)
        end
        --     send_command('@timers d "' .. indi_timer .. '"')
        --     indi_timer = spell.english
        --     send_command('@timers c "' .. indi_timer .. '" ' .. indi_duration .. ' down spells/00136.png')
        -- elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
        --     send_command('@timers c "' .. spell.english .. ' [' .. spell.target.name .. ']" 60 down spells/00220.png')
        -- elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
        --     send_command('@timers c "' .. spell.english .. ' [' .. spell.target.name .. ']" 90 down spells/00220.png')
        -- end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end

    equip_recast()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi') then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
    -- if stateField == 'Offense Mode' then
    --     if newValue == 'Normal' then
    --         disable('main', 'sub', 'range')
    --     else
    --         enable('main', 'sub', 'range')
    --     end
    -- end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            -- if spell.type == 'WhiteMagic' then
            --     return 'MndEnfeebles'
            -- else
            --     return 'IntEnfeebles'
            -- end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

function get_last_bubble()
    info.bubble = info.bubble or { spell = "Geo-Frailty", target = "<stnpc>" }
    return info.bubble
end

function set_last_bubble(spell)
    if not spell then return end
    if not spell.type == 'Geomancy' then return end
    if not spell.english:startswith('Geo-') then return end
    geo_spell = spell.english or "Geo-Frailty"
    target = info.offensive_bubbles:contains(spell.english:gsub("Geo-", "")) and "<stnpc>" or "<stpt>"

    info.bubble = { spell = geo_spell, target = spell.target.raw or '<stnpc>' }
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- if the mainhand weapon changes, update it so callbacks can tell.
function isMainChanged()
    if info.lastWeapon == player.equipment.main then
        return false
    end

    info.lastWeapon = player.equipment.main
    return true
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 15)
    send_command("@wait 5;input /lockstyleset 25")
end
