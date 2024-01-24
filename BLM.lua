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

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')
    include('helper_functions.lua')

    state.CastingMode:options('Normal', 'Resistant', 'Low')
    state.OffenseMode:options('None', 'Normal')
    state.IdleMode:options('Normal', 'PDT')

    state.MagicBurst = M(false, 'Magic Burst')
    state.MPReturn = M(false, 'MP Return')

    lowTierNukes = S { 'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II' }

    gear.default.obi_waist = "Sacro Cord"
    gear.default.drain_waist = "Fucho-no-obi"
    gear.default.cure_waist = "Shinjutsu-no-obi +1"


    send_command('bind !numpad8 gs equip sets.weapons.Mpaca')
    send_command('bind ^numpad8 gs equip sets.weapons.Mpaca.refresh')
    send_command('bind numpad8 gs equip sets.weapons.Mpaca.casting')
    send_command('bind !numpad9 gs equip sets.weapons.Xoanon')
    send_command('bind ^numpad9 gs equip sets.weapons.Xoanon.refresh')
    send_command('bind numpad9 gs equip sets.weapons.Xoanon.casting')
    send_command('bind numpad7 gs equip sets.weapons.Bunzi.casting')
    send_command('bind !numpad7 gs equip sets.weapons.Bunzi.refresh')
    send_command('bind ^numpad7 gs equip sets.weapons.Bunzi')

    send_command('bind f9 gs c cycle CastingMode')
    send_command('bind ^f11 gs c cycle OffenseMode')

    send_command('bind numpad6 input /ja "Cascade"')
    send_command('bind numpad5 input /ma "Aspir III" <t>')
    send_command('bind numpad4 input /ma "Stun" <t>')
    send_command('bind numpad2 input /ma "Sleep II" <t>')
    send_command('bind numpad1 input /ma "Sleepga II" <t>')
    send_command('bind numpad3 input /ma "Breakga" <t>')

    define_spell_priority()

    -- Additional local binds
    send_command('bind !` gs c cycle MagicBurst')
    send_command('bind ` gs c cycle MPReturn')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.weapons = {}
    sets.weapons.Mpaca = {
        main = "Mpaca's Staff",
        sub = "Khonsu"
    }
    sets.weapons.Mpaca.refresh = {
        main = "Mpaca's Staff",
        sub = "Oneiros Grip"
    }
    sets.weapons.Mpaca.casting = {
        main = "Mpaca's Staff",
        sub = "Enki Strap"
    }

    sets.weapons.Malignance = {
        main = "Malignance Pole",
        sub = "Khonsu"
    }
    sets.weapons.Malignance.refresh = {
        main = "Malignance Pole",
        sub = "Oneiros Grip"
    }
    sets.weapons.Malignance.casting = {
        main = "Malignance Pole",
        sub = "Enki Strap"
    }

    sets.weapons.Xoanon = {
        main = "Xoanon",
        sub = "Khonsu"
    }
    sets.weapons.Xoanon.refresh = {
        main = "Xoanon",
        sub = "Oneiros Grip"
    }
    sets.weapons.Xoanon.casting = {
        main = "Xoanon",
        sub = "Enki Strap"
    }

    sets.weapons.Bunzi = {
        main = "Bunzi's Rod",
        sub = "Genmei Shield",
    }
    sets.weapons.Bunzi.refresh = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
    }
    sets.weapons.Bunzi.casting = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
    }

    gear.casting_cape = { name = "Taranus's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', } }

    sets.ConserveMP = {
        ammo = "Pemphredo Tathlum",
        head = "Ipoca Beret",
        ear1 = "Magnetic Earring",
        ear2 = "Mendicant's Earring",
        body = "Amalric Doublet +1",
        hands = "Wicce Gloves +2",
        ring1 = "Mephitas's Ring +1",
        ring2 = "Medada's Ring",
        back = "Fi Follet Cape +1",
        waist = "Shinjutsu-no-obi+1",
        legs = "Lengo Pants",
        feet = "Wicce Sabots +2",
    }

    sets.SIRD = {
        ammo = "Staunch Tathlum +1", -- 11
        -- head = "Agwu's Cap",         -- 10
        ear1 = "Magnetic Earring",   -- 8
        ear2 = "Halasz Earring",     -- 5
        body = "Rosette Jaseran +1", -- 25
        hands = "Amalric Gages +1",  -- 11
        ring1 = "Freke Ring",        -- 10
        ring2 = "Evanescence Ring",  -- 5
        waist = "Emphatikos Rope",   -- 12
        back = "Fi Follet Cape +1",  -- 10
        -- legs = "Lengo Pants",        -- 10
        feet = "Amalric Nails +1",   -- 16
    }

    ---- Precast Sets ----

    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = { feet = "Wicce Sabots +2" }

    sets.precast.JA.Manafont = { body = "Archmage's Coat +1" }

    -- equip to maximize HP (for Tarus) and minimize MP loss before using convert
    sets.precast.JA.Convert = {}

    -- Fast cast sets for spells
    -- FC 80, QC 8
    sets.precast.FC = {
        -- main = gear.grioavolr.fc,       -- 12
        ammo = "Impatiens",
        head = gear.merlinic.fc.head,                     -- 15
        neck = "Orunmila's Torque",                       -- 5
        ear1 = "Malignance Earring",                      -- 4
        ear2 = "Loquacious Earring",                      -- 2
        body = gear.merlinic.fc.body,                     -- 13
        hands = "Agwu's Gages",                           -- 6
        ring1 = "Weatherspoon Ring +1",                   -- 6
        ring2 = "Medada's Ring",                          -- 10
        back = { name = "Moonlight Cape", priority = 9 }, -- 0
        waist = { name = "Platinum Moogle Belt", priority = 10 },
        legs = "Agwu's Slops",                            -- 7
        feet = gear.merlinic.fc.feet                      -- 12
    }

    --
    sets.precast.FC['Elemental Magic'] = {
        -- elemental celerity           -- 38
        ammo = "Impatiens",
        head = "Wicce Petasos +2",      -- 16
        body = "Wicce Coat +2",         -- 15
        hands = "Agwu's Gages",         -- 6
        ring1 = "Weatherspoon Ring +1", -- 6
        ring2 = { name = "Gelatinous Ring +1", priority = 9 },
        back = "Perimede Cape",
        waist = { name = "Platinum Moogle Belt", priority = 10 },
        -- legs = "Agwu's Slops", -- 7
    }

    sets.precast.FC['Dispelga'] = set_combine(sets.precast.FC, { main = "Daybreak", sub = "Ammurapi Shield" })
    sets.precast.Dispelga = sets.precast.FC['Dispelga']

    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'],
        {

            head = empty,
            body = "Crepuscular Cloak",
            feet = gear.merlinic.fc.feet --12
        }
    )

    sets.precast.FC['Death'] = {
        ammo = { name = "Ghastly Tathlum +1", priority = 7 },
        head = gear.merlinic.fc.head,                        -- 15
        neck = "Orunmila's Torque",                          -- 5
        ear1 = "Etiolation Earring",                         -- 1
        ear2 = "Loquacious Earring",                         -- 2
        body = gear.merlinic.fc.body,                        -- 13
        hands = "Agwu's Gages",                              -- 6
        ring1 = "Weatherspoon Ring +1",                      -- 6
        ring2 = "Medada's Ring",                             -- 10
        back = { name = "Fi Follet Cape +1", priority = 9 }, -- 10
        waist = { name = "Shinjutsu-no-obi +1", priority = 10 },
        legs = { name = "Spaekona's Tonban +3", priority = 8 },
        feet = gear.merlinic.fc.feet -- 12
    }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame mail",
        hands = "Nyame gauntlets",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = "Aurist's Cape +1",
        waist = "Cornelia's Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame sollerets"
    }

    sets.precast.WS.Magical = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Medada's Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.casting_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"

    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Vidohunir'] = set_combine(sets.precast.WS.Magical, {
        ammo = "Ghastly Tathlum +1",
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Archon Ring",
        ring2 = "Epaminondas's Ring",
        back = "Aurist's Cape +1",
        waist = gear.ElementalObi,
    })

    sets.precast.WS['Cataclysm'] = sets.precast.WS['Vidohunir']

    sets.precast.WS['Shining Strike'] = set_combine(sets.precast.WS.Magical, {
        ring1 = "Weatherspoon Ring +1",
    })

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        waist = "Cornelia's Belt",
        ring1 = "Metamorph Ring +1",
        ring2 = "Epaminondas's Ring"
    })


    ---- Midcast Sets ----

    sets.midcast.FastRecast = {
        head = "Agwu's Cap",
        ear2 = "Loquacious Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Medada's Ring",
        back = "Fi Follet Cape +1",
        waist = "Cornelia's Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.Cure = {
        head = "Ipoca Beret",
        neck = "Incanter's Torque",
        ear1 = "Mendicant's Earring",
        ear2 = "Meili Earring",
        hands = "Agwu's Gages",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Oretania's Cape +1",
        waist = gear.CureWaist,
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.CureSelf = {
        hands = "Agwu's Gages",
        ring2 = "Kunaji Ring",
    }

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Cursna = set_combine({
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        feet = "Gendewitha Galoshes +1"
    })

    sets.midcast['Enhancing Magic'] = {
        head = gear.telchine.enh_dur.head,
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = gear.telchine.enh_dur.body,
        hands = gear.telchine.enh_dur.hands,
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = gear.telchine.enh_dur.legs,
        feet = gear.telchine.enh_dur.feet
    }

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        head = "Amalric Coif +1"
    })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], sets.SIRD,
        { head = "Amalric Coif +1", waist = "Emphatikos Rope", legs = "Shedir Seraweels" })

    sets.midcast.Stoneskin = set_combine(sets.midcast["Enhancing Magic"], {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    })

    sets.midcast.Regen = sets.midcast['Enhancing Magic']

    sets.midcast.Haste = sets.midcast['Enhancing Magic']

    sets.midcast['Enfeebling Magic'] = {
        ammo = "Pemphredo Tathlum",
        head = "Befouled Crown",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Spaekona's Coat +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Luminary Sash",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }
    sets.midcast['Enfeebling Magic'].weapon = {
        main = "Contemplator +1",
        sub = "Enki Strap",
    }
    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], { main = "Daybreak", sub = "Ammurapi Shield" })

    sets.midcast.Dia = {
        ammo = "Perfect Lucky egg",
        head = "Volte cap",
        waist = "Chaac belt",
        feet = "Volte Boots"
    }
    sets.midcast.Diaga = sets.midcast.Dia

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], { main = "Daybreak", sub = "Ammurapi Shield" })

    sets.midcast['Dark Magic'] = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Incanter's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        back = "Aurist's Cape +1",
        waist = "Casso Sash",
        legs = "Spaekona's Tonban +3",
        feet = "Wicce Sabots +2"
    }

    sets.midcast.Drain = {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        ear1 = "Dark Earring",
        ear2 = "Mani Earring",
        body = "Agwu's Robe",
        hands = "Archmage's Gloves +3",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        back = "Perimede Cape",
        waist = gear.DrainWaist,
        legs = "Spaekona's Tonban +3",
        feet = "Agwu's Pigaches"
    }
    sets.midcast.Drain.weapon = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
    }

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
        -- main = "Rubicundity",
        -- sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Agwu's Cap",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }
    sets.midcast.Death = {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Wicce Coat +2",
        hands = "Wicce Gloves +2",
        ring1 = "Archon Ring",
        ring2 = "Medada's Ring",
        back = gear.casting_cape,
        waist = gear.ElementalObi,
        legs = "Wicce Chausses +2",
        feet = "Wicce Sabots +2"
    }

    -- Elemental Magic sets
    sets.midcast['Elemental Magic'] = {
        ammo = "Pemphredo Tathlum",
        head = "Wicce Petasos +2",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Wicce Coat +2",
        hands = "Wicce Gloves +2",
        ring1 = "Freke Ring",
        ring2 = "Medada's Ring",
        back = gear.casting_cape,
        waist = gear.ElementalObi,
        legs = "Wicce Chausses +2",
        feet = "Wicce Sabots +2"
    }
    sets.midcast['Elemental Magic'].weapon = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
    }
    sets.midcast.Death.weapon = sets.midcast['Elemental Magic'].weapon
    sets.midcast.MPReturn = { body = "Spaekona's Coat +3" }

    -- sets.midcast['Elemental Magic'] = {
    --     main = "Mpaca's Staff",
    --     sub = "Enki Strap",
    --     ammo = "Pemphredo Tathlum",
    --     head = "Wicce Petasos +2",
    --     neck = "Sibyl Scarf",
    --     ear1 = "Malignance Earring",
    --     ear2 = "Regal Earring",
    --     body = "Wicce Coat +2",
    --     hands = "Wicce Gloves +2",
    --     ring1 = "Freke Ring",
    --     ring2 = "Medada's Ring",
    --     back = gear.casting_cape,
    --     waist = gear.ElementalObi,
    --     legs = "Wicce Chausses +2",
    --     feet = "Wicce Sabots +2"
    -- }

    sets.midcast['Elemental Magic'].Resistant = {
        main = "Contemplator +1",
        sub = "Khonsu Strap",
        ammo = "Ghastly Tathlum +1",
        head = "Wicce Petasos +2",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Wicce Coat +2",
        hands = "Amalric Gages +1",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Wicce Chausses +2",
        feet = "Wicce Sabots +2"
    }

    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})
    sets.midcast['Elemental Magic'].HighTierNuke.Resistant = set_combine(sets.midcast['Elemental Magic'],
        {})

    sets.midcast['Elemental Magic'].LowTierNuke = set_combine(sets.midcast['Elemental Magic'], {
        ammo = "Ghastly Tathlum +1",
    })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], { head = empty, body = "Crepuscular Cloak" })

    sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], {
        -- TODO?
    })

    sets.midcast['Elemental Magic'].Wind = { weapon = { main = "Marin Staff +1", sub = "Enki Strap" } }

    sets.midcast['Elemental Magic'].Light = {
        weapon = { main = "Daybreak", sub = "Ammurapi Shield" },
        ring2 =
        "Weatherspoon Ring +1"
    }
    sets.midcast['Elemental Magic'].Dark = { head = "Pixie Hairpin +1", ring2 = "Archon Ring" }

    -- high int spell
    sets.midcast.ElementalEnfeeble = {
        ammo = "Ghastly Tathlum +1",
        head = "Wicce Petasos +2",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Wicce Coat +2",
        hands = "Wicce Gloves +2",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Archmage's Tonban +3",
        feet = "Archmage's Sabots +3"
    }
    sets.midcast.ElementalEnfeeble.weapon = {
        main = "Xoanon",
        sub = "Enki Strap"
    }
    sets.midcast.AreaOfEffect = set_combine(sets.midcast['Elemental Magic'], {
        body = "Spaekona's Coat +3"
    })
    sets.midcast.CumulativeMagic = set_combine(sets.midcast['Elemental Magic'], {
        legs = "Wicce Chausses +2" })
    sets.midcast.AncientMagic = set_combine(sets.midcast['Elemental Magic'], {
        -- head = "Achmage's Petasos +3",
    })

    -- Minimal damage gear for Lows.
    sets.midcast['Elemental Magic'].Low = {
        ammo = "Staunch Tathlum +1",
        head = "Volte Cap",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Spaekona's Coat +3",
        hands = "Gazu Bracelets +1",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Kishar Ring",
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        head = "Befouled Crown",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Austerity Belt +1",
        legs = "Agwu's Slops",
        feet = "Serpentes Sabots"
    }


    -- Idle sets

    -- Normal refresh idle set
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Infused Earring",
        ear2 = "Etiolation Earring",
        body = "Shamash Robe",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Moonlight Cape",
        waist = "Fucho-no-obi",
        legs = "Nyame Flanchard",
        feet = "Crier's Gaiters"
    }

    -- Idle mode that keeps PDT gear on, but doesn't prevent normal gear swaps for precast/etc.
    sets.idle.PDT = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Crier's Gaiters"
    }

    -- Idle mode scopes:
    -- Idle mode when weak.
    sets.idle.Weak = sets.idle.PDT

    -- Town gear.
    sets.idle.Town = {
        ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Infused Earring",
        ear2 = "Etiolation Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.TankCape,
        waist = "Blacksmith's Belt",
        legs = "Nyame Flanchard",
        feet = "Crier's Gaiters"
    }

    sets.idle.Refresh = {
        head = "Befouled Crown",
        neck = "Sibyl Scarf",
        body = "Jhakri Robe +2",
        hands = gear.chironic.refresh.hands,
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = gear.chironic.refresh.feet
    }

    -- Defense sets

    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Archon Ring",
        ring2 = "Shadow Ring",
        back = "Aurist's Cape +1",
        waist = "Platinum Moogle Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.Kiting = { feet = "Crier's Gaiters" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.

    sets.buff['Mana Wall'] = { feet = "Wicce Sabots +2" }

    sets.magic_burst = {
        head = "Eat Hat +1",
        neck = "Mizukage-no-Kubikazari",
        body = "Wicce Coat +2",
        hands = "Archmage's Gloves +3",
        ring1 = "Mujin Band",
    }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Oshasha's Treatise",
        head = "Blistering Sallet +1",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = "Aurist's Cape +1",
        waist = "Windbuffet Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function filtered_action(spell)
    if spell.type == 'Weaponskill' then
        local main = player.equipment.main
        if spell.english == "Vidohunir" then
            if S { "Daybreak", "Bunzi's Rod" }:contains(main) then
                send_command('input /ws "Shining Strike" ' .. spell.target.raw)
            elseif main == 'Maxentius' then
                send_command('input /ws "Black Halo" ' .. spell.target.raw)
            end
        elseif spell.english == 'Shattersoul' then
            if S { "Daybreak", "Bunzi's Rod" }:contains(main) then
                send_command('input /ws "Black Halo" ' .. spell.target.raw)
            elseif main == 'Maxentius' then
                send_command('input /ws "Shining Strike" ' .. spell.target.raw)
            end
        elseif spell.english == 'Myrkr' then
            if S { "Daybreak", "Bunzi's Rod", "Maxentius" }:contains(main) then
                send_command('input /ws "Starlight" ' .. spell.target.raw)
            end
        elseif spell.english == "Retribution" then
            if S { "Daybreak", "Bunzi's Rod", "Maxentius" }:contains(main) then
                send_command('input /ws "Realmrazer" ' .. spell.target.raw)
            end
        end
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.skill ~= 'Weaponskill' then
        if spell.type ~= 'WeaponSkill' then
            set_recast()
        end
    end

    if spell.skill == 'Elemental Magic' and not is_spell_ready(spell) then
        if is_mapped_st_spell(spell) then
            send_command('input /ma "' .. downgrade_st_spell(spell, eventArgs) .. '" ' .. spell.target.raw)
        elseif is_mapped_aoe_spell(spell) then
            send_command('input /ma "' .. downgrade_aoe_spell(spell, eventArgs) .. '" ' .. spell.target.raw)
        end
    elseif spell.skill == 'Dark Magic' then
        if spell.english:startswith("Aspir") and not is_spell_ready(spell) then
            send_downgraded_spell_tier(spell, eventArgs)
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type ~= "WeaponSkill" then set_recast() end
    if spell.english == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    -- print(spell.element)
    local spell_class = job_get_spell_map(spell)

    if spell_class and sets.midcast[spell_class] then
        equip(sets.midcast[spell_class])
        if state.OffenseMode.value == 'None' and sets.midcast[spell_class].weapon then
            equip(sets.midcast[spell_class].weapon)
        end
    elseif state.OffenseMode.value == 'None' then
        if sets.midcast[spell.skill] and sets.midcast[spell.skill].weapon then
            equip(sets.midcast[spell.skill], sets.midcast[spell.skill].weapon)
        end
        if sets.midcast[spell.english] and sets.midcast[spell.english].weapon then
            equip(sets.midcast[spell.english], sets.midcast[spell.english].weapon)
        end
    end

    if spell.english == 'Impact' then
        equip(sets.midcast.Impact)
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
                equip(sets.midcast['Elemental Magic'].Wind)
                if state.OffenseMode.value == 'None' then
                    equip(sets.midcast['Elemental Magic'].Wind.weapon)
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
            if state.MagicBurst.value and job_get_spell_map(spell) ~= "ElementalEnfeeble" then
                equip(sets.magic_burst)
            end
            if state.CastingMode.value == 'Low' then
                equip(sets.midcast['Elemental Magic'].Low)
            end
            if state.MPReturn.value
                and (not job_get_spell_map(spell) or S { 'AreaOfEffect', 'CumulativeMagic', 'LowTierNuke' }:contains(job_get_spell_map(spell))) then
                equip(sets.midcast.MPReturn)
            end
        elseif spell.skill == 'Dark Magic' then
            if state.MagicBurst.value then
                equip(sets.magic_burst)
            end
        end
    end
    if spell.english == 'Impact' then
        equip(sets.midcast.Impact)
    end

    if spell.english == 'Sleepga' then
        equip(sets.SIRD)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    -- if we changed weapons, change back.
    equip_recast()

    if buffactive.doom then
        equip(sets.buff.doom)
    end

    if not spell.interrupted then
        if spell.english == 'Mana Wall' then
            enable('feet')
            equip(sets.buff['Mana Wall'])
            disable('feet')
        elseif spell.skill == 'Elemental Magic' then
            if state.MagicBurst.value == 'Once' then
                state.MagicBurst:reset()
            end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock feet when Mana Wall buff is lost.
    if buff == "Mana Wall" and not gain then
        enable('feet')
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        -- if newValue == 'Normal' then
        --     disable('main', 'sub', 'range')
        -- else
        --     enable('main', 'sub', 'range')
        -- end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' then
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        elseif spell.english:endswith('ja') or spell.english == 'Comet' then
            return 'CumulativeMagic'
        elseif S { 'Flare', 'Tornado', 'Burst', 'Quake', 'Freeze', 'Flood', 'Flare II', 'Tornado II', 'Burst II', 'Quake II', 'Freeze II', 'Flood II' }:contains(get_spell_base(spell)) then
            return 'AncientMagic'
        elseif S { 'Drown', 'Rasp', 'Frost', 'Burn', 'Shock', 'Choke' }:contains(spell.english) then
            return 'ElementalEnfeeble'
        elseif spell.english:contains('aga') then
            return 'AreaOfEffect'
        end
    end
end

-- traverses the spell priority tree
function downgrade_st_spell(spell, eventArgs)
    if is_mapped_st_spell(spell) then
        eventArgs.cancel = true
        for i, v in pairs(st_spell_priority[spell.element]) do
            if spell.english == v then
                -- return the next element in the array
                return st_spell_priority[spell.element][i + 1]
                    -- or if it exceeds the length, return the last element of the array
                    or st_spell_priority[spell.element][st_spell_priority[spell.element]:length()]
            end
        end
    end
end

-- traverses the spell priority tree
function downgrade_aoe_spell(spell, eventArgs)
    if is_mapped_aoe_spell(spell) then
        eventArgs.cancel = true
        for i, v in pairs(aoe_spell_priority[spell.element]) do
            if spell.english == v then
                -- return the next element in the array
                return aoe_spell_priority[spell.element][i + 1]
                    -- or if it exceeds the length, return the last element of the array
                    or aoe_spell_priority[spell.element][aoe_spell_priority[spell.element]:length()]
            end
        end
    end
end

function is_mapped_st_spell(spell)
    return st_spell_priority and st_spell_priority[spell.element]:contains(spell.english)
end

function is_mapped_aoe_spell(spell)
    return aoe_spell_priority and aoe_spell_priority[spell.element]:contains(spell.english)
end

-- Spell priority for elemental nukes
function define_spell_priority()
    st_spell_priority = T {
        ["Fire"] = T {
            "Fire VI",
            "Fire V",
            "Flare II",
            "Fire IV",
            "Fire III",
            "Fire"
        },
        ['Water'] = T {
            "Water VI",
            "Water V",
            "Flood II",
            "Water IV",
            "Water III",
            "Water"
        },
        ['Earth'] = T {
            "Stone VI",
            "Stone V",
            "Quake II",
            "Stone IV",
            "Stone III",
            "Stone"
        },
        ['Lightning'] = T {
            "Thunder VI",
            "Thunder V",
            "Burst II",
            "Thunder IV",
            "Thunder III",
            "Thunder"
        },
        ['Ice'] = T {
            "Blizzard VI",
            "Blizzard V",
            "Freeze II",
            "Blizzard IV",
            "Blizzard III",
            "Blizzard"
        },
        ['Wind'] = T {
            "Aero VI",
            "Aero V",
            "Tornado II",
            "Aero IV",
            "Aero III",
            "Aero"
        }
    }

    aoe_spell_priority = T {
        ["Fire"] = T {
            "Firaga III",
            "Firaja",
            "Firaga II",
            "Firaga",
        },
        ['Water'] = T {
            "Waterga III",
            "Waterja",
            "Waterga II",
            "Waterga",
        },
        ['Earth'] = T {
            "Stonega III",
            "Stoneja",
            "Stonega II",
            "Stonega",
        },
        ['Lightning'] = T {
            "Thundaga III",
            "Thundaja",
            "Thundaga II",
            "Thundaga",
        },
        ['Ice'] = T {
            "Blizzaga III",
            "Blizzaja",
            "Blizzaga II",
            "Blizzaga",
        },
        ['Wind'] = T {
            "Aeroga III",
            "Aeroja",
            "Aeroga II",
            "Aeroga",
        }
    }
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 22)

    send_command("@wait 5;input /lockstyleset 26")
end
