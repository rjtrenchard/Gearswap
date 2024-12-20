-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    autofood              = 'Miso Ramen'

    buff_spell_lists      = {
        Auto = { --Options for When are: Always, Engaged, Idle, OutOfCombat, Combat
            { Name = 'Reraise III', Buff = 'Reraise', SpellID = 848, When = 'Always' },
            --{Name='Aurorastorm',	Buff='Aurorastorm',	SpellID=119,	When='Always'},
        },
    }

    state.AutoDefenseMode = M(false, 'AutoDefenseMode')
    state.AutoSubMode     = M(false, 'Auto Sublimation Mode')
    state.OffenseMode:options('Normal')
    state.CastingMode:options('Normal', 'Proc') --'Resistant','Proc','OccultAcumen','9k')
    state.IdleMode:options('Normal', 'PDT')
    state.HybridMode:options('Normal', 'PDT')
    state.Weapons:options('None', 'Akademos', 'Khatvanga')
    state.ElementalMode = M { ['description'] = 'Elemental Mode', 'Fire', 'Ice', 'Earth', 'Water', 'Lightning', 'Wind', 'Light', 'Dark' }

    gear.nuke_jse_back = {
        name = "Lugh's Cape",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', }
    }

    gear.idle_cape = {
        name = "Lugh's Cape",
        augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Phys. dmg. taken-10%' }
    }
    -- Additional local binds
    send_command('bind !` gs c cycle RecoverMode')

    send_command('bind ^` gs c cycle ElementalMode')
    send_command('bind ^escape gs c cycleback ElementalMode')
    --	send_command('bind !` gs c scholar power')
    --	send_command('bind @` gs c cycle MagicBurstMode')




    send_command('bind @^` input /ja "Parsimony" <me>')
    send_command('bind @backspace gs c scholar aoe')

    send_command('bind ^\\\\ input /ma "Protect V" <t>')
    send_command('bind @\\\\ input /ma "Shell V" <t>')
    send_command('bind !\\\\ input /ma "Reraise III" <me>')


    send_command('bind @` gs c cycle CastingMode')
    send_command('bind @1 input /ma "Cure IV" <st>')
    send_command('bind @2 input /ma "Aquaveil" <st>')
    send_command('bind @3 input /ma Stoneskin <me>')
    send_command('bind @4 input /ma Phalanx <me>')
    send_command('bind @a input /ja Accession <me>')
    send_command('bind @s input /ja Perpetuance <me>')
    send_command('bind @i input /ja Immanence <me>')
    send_command('bind @e input /ja Ebullience <me>')
    send_command('bind @m input /ja Manifestation <me>')
    --send_command('bind !l input /ja "Libra" <t>')

    send_command('bind ^@!t input /ja "Tabula Rasa" <me>')
    send_command('bind ^@!c input /ja "Caper Emissarius" <stpc>')

    --send_command('bind ^@z input /ja "Light Arts" <me>;wait 2;input /ja "Addendum: White" <me>')
    --send_command('bind ^@x input /ja "Dark Arts" <me>;wait 2;input /ja "Addendum: Black" <me>')

    send_command('bind @z input /ja "Light Arts" <me>')
    send_command('bind @x input /ja "Dark Arts" <me>')

    --send_command('gs c set AutoSubMode on') --Automatically uses sublimation and Myrkr.
    send_command('gs c set unlockweapons true')
    send_command('wait 2; input /lockstyleset 23')
    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    include('Augments.lua')

    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['Tabula Rasa'] = { legs = "Peda. Pants +3" }
    sets.precast.JA['Enlightenment'] = {} --body="Peda. Gown +1"

    -- Fast cast sets for spells

    sets.precast.FC = {
        main = "Musa",                -- 11
        sub = "Khonsu",
        ammo = "Sapience Orb",        -- +2QC
        head = gear.merlinic.fc.head, -- 15
        neck = "Orunmila's Torque",   -- 5
        ear1 = "Malignance Earring",  -- 4
        ear2 = "Loquacious Earring",
        -- ear2 = "Loquacious Earring",    -- 2
        body = gear.merlinic.fc.body,   -- 13
        -- hands = "Gendewitha Gages +1",  -- 7
        hands = gear.merlinic.fc.hands, -- 7
        ring1 = "Kishar Ring",          -- 4
        ring2 = "Rahab Ring",           -- 2
        back = "Fi Follet Cape +1",     -- 10
        waist = "Embla Sash",           -- 5
        legs = "Kaykaus Tights +1",     -- 7
        -- feet = "Pedagogy Loafers +3", -- 8 +AWWW
        feet = "Acad. Loafers +3",
    }

    sets.precast.FC.Arts = {
        -- head = "Peda. M.Board +3",
        feet = "Acad. Loafers +3",
    }

    -- sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, { waist = "Siegel Sash" })

    -- sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, { ear1 = "Malignance Earring" })

    -- sets.precast.FC.Cure = set_combine(sets.precast.FC, {
    --     --main="Serenity",
    --     --sub="Clerisy Strap +1",
    --     --body="Heka's Kalasiris"
    -- })

    -- sets.precast.FC.Curaga = sets.precast.FC.Cure

    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], { head = empty, body = "Crepuscular Cloak" })
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, { main = "Daybreak", sub = "Genmei Shield" })

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS['Myrkr'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Pixie Hairpin +1",
        neck = "Sanctity Necklace",
        ear1 = "Evans Earring",
        --ear2="Etiolation Earring",
        body = "Amalric Doublet +1",
        hands = "Regal Cuffs",
        ring1 = "Mephitas's Ring +1",
        ring2 = "Mephitas's Ring",
        back = "Aurist's Cape +1",
        waist = "Luminary Sash",
        legs = "Psycloth Lappas",
        feet = "Kaykaus Boots",
    }

    -- Midcast Sets

    sets.TreasureHunter = set_combine(sets.TreasureHunter, {})

    -- Gear that converts elemental damage done to recover MP.	
    sets.RecoverMP = { body = "Seidr Cotehardie" }

    -- Gear for specific elemental nukes.
    -- sets.element.Dark = { head = "Pixie Hairpin +1", ring2 = "Archon Ring" }

    sets.midcast.FastRecast = {
        main = { name = "Musa", augments = { 'Path: C', } }, --11%
        ammo = "Staunch Tathlum +1",
        head = gear.merlinic.fc.head,                        --15%
        body = gear.merlinic.fc.body,                        --15%
        hands = gear.merlinic.fc.hands,                      --7%
        legs = "Kaykaus Tights +1",                          --13%
        feet = gear.merlinic.fc.feet,
        neck = "Orunmila's Torque",                          --4%
        waist = "Embla Sash",                                --5%
        left_ear = "Malignance Earring",                     --4%
        right_ear = "Loquac. Earring",                       --2%
        left_ring = "Kishar Ring",                           --4%
        right_ring = "Prolix Ring",                          --2%
        back = "Fi Follet Cape +1",                          --10
    }

    sets.midcast.Cure = {
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = "Kaykaus Mitra +1",
        --head="Nyame Helm",
        body = "Nyame Mail",
        --body="Pinga Tunic +1", --15%
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus Boots +1",
        --legs="Pinga Pants +1", --13%
        --feet={ name="Nyame Sollerets", augments={'Path: B',}},		
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        waist = "Carrier's Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Tuisto Earring",
        left_ring = { name = "Gelatinous Ring +1", augments = { 'Path: A', } },
        right_ring = "Defending Ring",
        back = gear.nuke_jse_back,
    }


    --body={ name="Nyame Mail", augments={'Path: B',}},
    --hands={ name="Nyame Gauntlets", augments={'Path: B',}},




    sets.midcast.LightWeatherCure = {
        --main="Chatoyant Staff",sub="Curatio Grip",
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Kaykaus Mitra +1", augments = { 'MP+80', '"Cure" spellcasting time -7%', 'Enmity-6', } },
        body = { name = "Kaykaus Bliaut +1", augments = { 'MP+80', '"Cure" potency +6%', '"Conserve MP"+7', } },
        hands = { name = "Kaykaus Cuffs +1", augments = { 'MP+80', 'MND+12', 'Mag. Acc.+20', } },
        legs = { name = "Kaykaus Tights +1", augments = { 'MP+80', '"Cure" spellcasting time -7%', 'Enmity-6', } },
        feet = { name = "Kaykaus Boots +1", augments = { 'MP+80', '"Cure" spellcasting time -7%', 'Enmity-6', } },
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        waist = "Luminary Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Tuisto Earring",
        left_ring = { name = "Gelatinous Ring +1", augments = { 'Path: A', } },
        right_ring = "Defending Ring",
        back = gear.nuke_jse_back,
    }

    sets.midcast.LightDayCure = {
        --main="Serenity",sub="Curatio Grip",
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Kaykaus Mitra +1", augments = { 'MP+80', '"Cure" spellcasting time -7%', 'Enmity-6', } },
        body = { name = "Kaykaus Bliaut +1", augments = { 'MP+80', '"Cure" potency +6%', '"Conserve MP"+7', } },
        hands = { name = "Kaykaus Cuffs +1", augments = { 'MP+80', 'MND+12', 'Mag. Acc.+20', } },
        legs = { name = "Kaykaus Tights +1", augments = { 'MP+80', '"Cure" spellcasting time -7%', 'Enmity-6', } },
        feet = { name = "Kaykaus Boots +1", augments = { 'MP+80', '"Cure" spellcasting time -7%', 'Enmity-6', } },
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        waist = "Luminary Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Tuisto Earring",
        left_ring = { name = "Gelatinous Ring +1", augments = { 'Path: A', } },
        right_ring = "Defending Ring",
        back = gear.nuke_jse_back,
    }

    sets.midcast.Curaga = sets.midcast.Cure

    sets.Self_Healing = {
        --neck="Phalaina Locket",ring1="Kunaji Ring",ring2="Asklepian Ring",
        waist = "Gishdubar Sash"
    }
    sets.Cure_Received = {
        --neck="Phalaina Locket",ring1="Kunaji Ring",ring2="Asklepian Ring",
        waist = "Gishdubar Sash"
    }
    sets.Self_Refresh = {
        --back="Grapevine Cape",
        waist = "Gishdubar Sash",
        --feet="Inspirited Boots"
    }

    sets.midcast.Cursna = {
        main = "Musa",
        sub = "Clemency Grip",
        ammo = "Hasty Pinion +1",
        head = "Amalric Coif +1",
        neck = "Debilis Medallion",
        ear2 = "Meili Earring",
        ear1 = "Malignance Earring",
        body = "Zendik Robe",
        hands = "Hieros Mittens",
        ring1 = "Haoma's Ring",
        ring2 = "Menelaus's Ring",
        back = "Oretan. Cape +1",
        waist = "Witful Belt",
        legs = "Psycloth Lappas",
        feet = "Vanya Clogs",
    }

    sets.midcast.StatusRemoval = set_combine(sets.midcast.FastRecast, {
        main = "Musa",
        --sub="Clemency Grip"
    })

    sets.midcast['Enhancing Magic'] = {
        main = { name = "Musa", augments = { 'Path: C', } }, --10%
        sub = "Khonsu",
        ammo = "Sapience Orb",                               --2%
        head = { name = "Telchine Cap", augments = { 'Enh. Mag. eff. dur. +10', } },
        body = { name = "Telchine Chas.", augments = { 'Enh. Mag. eff. dur. +10', } },
        hands = { name = "Telchine Gloves", augments = { 'Enh. Mag. eff. dur. +10', } },
        legs = { name = "Telchine Braconi", augments = { 'Enh. Mag. eff. dur. +10', } },
        feet = { name = "Telchine Pigaches", augments = { 'Enh. Mag. eff. dur. +10', } },
        neck = "",
        waist = "Embla Sash",        --5%
        ear1 = "Malignance Earring", --4%
        ear2 = "Loquac. Earring",    --2%
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = "Fi follet cape +1", --10%
    }



    sets.midcast.Regen = { --set_combine(sets.midcast['Enhancing Magic'], {
        main = "Musa",
        sub = "Khonsu",
        head = "Arbatel Bonnet +3",
        --head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
        body = { name = "Telchine Chas.", augments = { 'Enh. Mag. eff. dur. +10', } },
        hands = { name = "Telchine Gloves", augments = { 'Enh. Mag. eff. dur. +10', } },
        legs = { name = "Telchine Braconi", augments = { 'Enh. Mag. eff. dur. +10', } },
        feet = { name = "Telchine Pigaches", augments = { 'Enh. Mag. eff. dur. +10', } },
        neck = "Incanter's Torque",
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Tuisto Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = gear.nuke_jse_back
    }

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck = "Nodens Gorget",
        --ear2="Earthcry Earring",
        waist = "Siegel Sash",
        --legs="Shedir Seraweels"
    })

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], { head = "Amalric Coif +1" })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
        --	main="Vadose Rod",
        --	sub="Genmei Shield",
        --	head="Amalric Coif +1",
        --	hands="Regal Cuffs",
        --	waist="Emphatikos Rope",
        --	legs="Shedir Seraweels"
    })

    sets.midcast.BarElement = set_combine(sets.precast.FC['Enhancing Magic'], {
        --legs="Shedir Seraweels"
    })

    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {
        --feet="Peda. Loafers +1"
    })

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], { ring2 = "Sheltered Ring" })
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'], { ring2 = "Sheltered Ring" })
    sets.midcast.Shellra = sets.midcast.Shell


    -- Custom spell classes

    sets.midcast['Enfeebling Magic'] = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Acad. Mortar. +3",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = "Regal Cuffs",
        legs = "Arbatel Pants +3",
        feet = "Arbatel Loafers +3",
        neck = "Erra Pendant",
        --ear1="Regal Earring",
        ear1 = "Malignance Earring",
        ear2 = "Arbatel Earring +2",
        ring1 = "Kishar Ring",
        ring2 = "Stikini Ring +1",
        back = gear.nuke_jse_back,
        waist = "Obstin. Sash",
    }

    sets.midcast['Enfeebling Magic'].Resistant = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Acad. Mortar. +3",
        neck = "Erra Pendant",
        ear2 = "Regal Earring",
        --ear1="Regal Earring",
        ear1 = "Malignance Earring",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = "Regal Cuffs",
        ring1 = "Kishar Ring",
        ring2 = "Stikini Ring +1",
        back = gear.nuke_jse_back,
        waist = "Obstin. Sash",
        legs = "Arbatel Pants +3",
        feet = "Arbatel Loafers +3",
    }

    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {
        --head="Amalric Coif +1",
        waist = "Acuity Belt +1"
    })
    sets.midcast.ElementalEnfeeble.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {
        --head="Amalric Coif +1",
        waist = "Acuity Belt +1"
    })

    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {
        --head="Amalric Coif +1",
        waist = "Acuity Belt +1"
    })
    sets.midcast.IntEnfeebles.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {
        --	head="Amalric Coif +1",
        waist = "Acuity Belt +1",
    })

    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {})
    sets.midcast.MndEnfeebles.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {})

    sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
    sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
    sets.midcast['Dia II'] = sets.midcast['Enfeebling Magic']
    sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
    sets.midcast['Bio II'] = sets.midcast['Enfeebling Magic']

    sets.midcast['Divine Magic'] = set_combine(sets.midcast['Enfeebling Magic'],
        { ring2 = "Stikini Ring +1", feet = gear.chironic_nuke_feet })

    sets.midcast['Dark Magic'] = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Amalric Coif +1",
        neck = "Incanter's Torque",
        ear2 = "Regal Earring",
        ear1 = "Malignance Earring",
        --  body="Chironic Doublet",
        -- hands = "Acad. Bracers +3",
        ring1 = "Stikini Ring +1",
        ring2 = "Stikini Ring +1",
        back = gear.nuke_jse_back,
        waist = "Acuity Belt +1",
        legs = "Arbatel Pants +2",
        --	feet=gear.merlinic_aspir_feet
        body = "Agwu's Robe",
        feet = "Arbatel Loafers +3",
    }

    sets.midcast.Kaustra = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = "Arbatel Bonnet +3",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        --ear1="Regal Earring",
        ear1 = "Regal Earring",
        ear2 = "Arbatel Earring +2",
        ring1 = "Freke Ring",
        ring2 = "Archon Ring",
        waist = "Anrin Obi",
        back = gear.nuke_jse_back,
    }

    sets.midcast.Kaustra.Resistant = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Agwu's Pigaches",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        --ear1="Regal Earring",
        ear2 = "Regal Earring",
        ear1 = "Malignance Earring",
        ring1 = "Freke Ring",
        ring2 = "Archon Ring",
        waist = "Refoccilation Stone",
        back = gear.nuke_jse_back,
    }

    sets.midcast.Drain = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        --ear1="Regal Earring",
        ear2 = "Regal Earring",
        ear1 = "Malignance Earring",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        --hands="Acad. Bracers +3",
        ring1 = "Evanescence Ring",
        ring2 = "Archon Ring",
        back = gear.nuke_jse_back,
        waist = "Fucho-no-obi",
        legs = "Arbatel Pants +3",
        feet = "Agwu's Pigaches",
    }

    sets.midcast.Drain.Resistant = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        --ear1="Regal Earring",
        ear2 = "Regal Earring",
        ear1 = "Malignance Earring",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        --hands="Acad. Bracers +3",
        ring1 = "Evanescence Ring",
        ring2 = "Archon Ring",
        back = gear.nuke_jse_back,
        waist = "Fucho-no-obi",
        legs = "Arbatel Pants +3",
        feet = "Agwu's Pigaches",
    }

    sets.midcast.Aspir = sets.midcast.Drain
    sets.midcast.Aspir.Resistant = sets.midcast.Drain.Resistant

    sets.midcast.Stun = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        neck = "Voltsurge Torque",
        ear2 = "Enchntr. Earring +1",
        ear1 = "Malignance Earring",
        head = "Acad. Mortar. +3",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        --body="Zendik Robe",
        --hands="Acad. Bracers +3",
        ring1 = "Metamor. Ring +1",
        ring2 = "Stikini Ring +1",
        back = gear.nuke_jse_back,
        waist = "Witful Belt",
        legs = "Arbatel Pants +3",
        feet = "Agwu's Pigaches",
    }

    sets.midcast.Stun.Resistant = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Acad. Mortar. +3",
        neck = "Erra Pendant",
        --ear1="Regal Earring",
        ear2 = "Regal Earring",
        ear1 = "Malignance Earring",
        --body="Zendik Robe",
        --hands="Acad. Bracers +3",
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        ring1 = "Metamor. Ring +1",
        ring2 = "Stikini Ring +1",
        back = gear.nuke_jse_back,
        waist = "Acuity Belt +1",
        legs = "Arbatel Pants +3",
        feet = "Agwu's Pigaches",
    }

    -- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        --ear1="Regal Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }

    sets.midcast['Elemental Magic'].Resistant = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        --ear1="Regal Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }

    sets.midcast['Elemental Magic']['9k'] = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        --	ear2="Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }

    sets.midcast['Elemental Magic'].Proc = {
        main = "Ternion Dagger +1", -- 9
        ammo = "Tengu-no-hane",     -- 3
        head = gear.merlinic.fc.head,
        body = gear.merlinic.fc.body,
        hands = gear.merlinic.fc.hands,
        legs = "Kaykaus Tights +1",
        feet = gear.merlinic.fc.feet,
        neck = "Bathy Choker +1",         -- 11
        waist = "Embla Sash",
        left_ear = "Dignitary's Earring", -- 3
        right_ear = "Assuage Earring",    -- 3
        left_ring = gear.left_chirich,    -- 10
        right_ring = gear.right_chirich,  -- 10
        back = "Fi follet cape +1",
    }

    sets.midcast['Elemental Magic'].OccultAcumen = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        --ear2="Regal Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }

    -- Gear for Magic Burst mode.
    sets.MagicBurst = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }

    sets.HelixBurst = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = { name = "Bookworm's Cape", augments = { 'INT+1', 'MND+1', 'Helix eff. dur. +20', } },
    }

    sets.ResistantHelixBurst = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = { name = "Bookworm's Cape", augments = { 'INT+1', 'MND+1', 'Helix eff. dur. +20', } },
    }

    -- Custom refinements for certain nuke tiers
    sets.midcast['Elemental Magic'].HighTierNuke = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }



    sets.midcast['Elemental Magic'].HighTierNuke.Resistant = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = gear.nuke_jse_back,
    }

    sets.midcast.Helix = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = "Bookworm's Cape"
    }

    sets.midcast.Helix.Resistant = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = { name = "Agwu's Cap", augments = { 'Path: A', } },
        body = { name = "Agwu's Robe", augments = { 'Path: A', } },
        hands = { name = "Agwu's Gages", augments = { 'Path: A', } },
        legs = { name = "Agwu's Slops", augments = { 'Path: A', } },
        feet = "Arbatel Loafers +3",
        neck = { name = "Argute Stole +2", augments = { 'Path: A', } },
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1",
        back = { name = "Bookworm's Cape", augments = { 'INT+1', 'MND+1', 'Helix eff. dur. +20', } },
    }

    sets.midcast.Helix.Proc = {
        main = "Musa",
        ammo = "Sapience Orb",
        head = "Amalric Coif +1",
        body = "Seidr Cotehardie",
        hands = gear.telchine.enh_dur.hands,
        legs = "Kaykaus Tights +1",
        feet = gear.merlinic.fc.feet,
        neck = "Orunmila's Torque",
        waist = "Embla Sash",
        left_ear = "Enchntr. Earring +1",
        right_ear = "Loquacious Earring",
        left_ring = "Chirich Ring +1",
        right_ring = "Chirich Ring +1",
        back = "Fi Follet Cape +1"
    }

    sets.midcast.Impact = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = empty,
        neck = "Erra Pendant",
        --ear1="Regal Earring",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Crepuscular Cloak",
        hands = "Acad. Bracers +3",
        ring1 = "Metamor. Ring +1",
        ring2 = "Stikini Ring +1",
        back = gear.nuke_jse_back,
        waist = "Acuity Belt +1",
        legs = "Merlinic Shalwar",
        feet = "Amalric Nails +1"
    }

    sets.midcast.Impact.OccultAcumen = set_combine(sets.midcast['Elemental Magic'].OccultAcumen,
        { head = empty, body = "Crepuscular Cloak" })


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        main = "Chatoyant Staff",
        sub = "Oneiros Grip",
        ammo = "Homiliary",
        head = "Befouled Crown",
        neck = "Chrys. Torque",
        --ear1="Etiolation Earring",
        ear2 = "Ethereal Earring",
        body = "Amalric Doublet +1",
        hands = gear.merlinic_refresh_hands,
        ring1 = "Defending Ring",
        ring2 = "Dark Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Assid. Pants +1",
        feet = gear.chironic_refresh_feet
    }

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
        main = "Musa",
        sub = "Khonsu",
        ammo = "Brigantia Pebble",
        --	ammo="Staunch Tathlum +1",
        head = "Nyame Helm",
        body = "Arbatel Gown +3",
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Arbatel Pants +2",
        feet = { name = "Nyame Sollerets", augments = { 'Path: B', } },
        neck = { name = "Loricate Torque +1", augments = { 'Path: A', } },
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Tuisto Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Shneddick Ring +1",
        --back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
        back = gear.nuke_jse_back,
    }

    sets.idle.PDT = {
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = "Arbatel Gown +3",
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Arbatel Pants +3",
        feet = { name = "Nyame Sollerets", augments = { 'Path: B', } },
        neck = { name = "Loricate Torque +1", augments = { 'Path: A', } },
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Etiolation Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = { name = "Lugh's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Phys. dmg. taken-10%', } },
    }

    sets.idle.Hippo = set_combine(sets.idle.PDT, { feet = "Hippo. Socks +1" })

    sets.idle.Weak = {
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = "Arbatel Gown +3",
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Arbatel Pants +3",
        feet = { name = "Nyame Sollerets", augments = { 'Path: B', } },
        neck = { name = "Loricate Torque +1", augments = { 'Path: A', } },
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Etiolation Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = { name = "Lugh's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Phys. dmg. taken-10%', } },
    }

    -- Defense sets

    sets.defense.PDT = {
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = "Arbatel Gown +3",
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Arbatel Pants +3",
        feet = { name = "Nyame Sollerets", augments = { 'Path: B', } },
        neck = { name = "Loricate Torque +1", augments = { 'Path: A', } },
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Etiolation Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = { name = "Lugh's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Phys. dmg. taken-10%', } },
    }

    sets.defense.MDT = {
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = "Arbatel Gown +3",
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Arbatel Pants +3",
        feet = { name = "Nyame Sollerets", augments = { 'Path: B', } },
        neck = { name = "Loricate Torque +1", augments = { 'Path: A', } },
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Etiolation Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = { name = "Lugh's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Phys. dmg. taken-10%', } },
    }

    sets.defense.MEVA = {
        main = "Daybreak",
        sub = "Genmei Shield",
        ammo = "Staunch Tathlum +1",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = "Arbatel Gown +3",
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Arbatel Pants +3",
        feet = { name = "Nyame Sollerets", augments = { 'Path: B', } },
        neck = { name = "Loricate Torque +1", augments = { 'Path: A', } },
        waist = "Embla Sash",
        left_ear = { name = "Odnowa Earring +1", augments = { 'Path: A', } },
        right_ear = "Etiolation Earring",
        left_ring = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back = { name = "Lugh's Cape", augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', 'Phys. dmg. taken-10%', } },
    }

    sets.Kiting = { right_ring = "Shneddick Ring +1" }
    sets.latent_refresh = { waist = "Fucho-no-obi" }
    sets.latent_refresh_grip = { sub = "Oneiros Grip" }
    sets.TPEat = { neck = "Chrys. Torque" }
    sets.DayIdle = {}
    sets.NightIdle = {}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Crepuscular Pebble",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = { name = "Nyame Mail", augments = { 'Path: B', } },
        hands = "Gazu Bracelets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Sanctity Necklace",
        waist = "Windbuffet Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Chirich Ring +1",
        right_ring = "Petrov Ring",
        back = "Aurist's Cape +1",
    }

    sets.engaged.PDT = {
        ammo = "Crepuscular Pebble",
        head = { name = "Nyame Helm", augments = { 'Path: B', } },
        body = { name = "Nyame Mail", augments = { 'Path: B', } },
        hands = { name = "Nyame Gauntlets", augments = { 'Path: B', } },
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
        neck = "Sanctity Necklace",
        waist = "Windbuffet Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Chirich Ring +1",
        right_ring = "Petrov Ring",
    }

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    -- sets.buff['Ebullience'] = { head = "Arbatel Bonnet +3" }
    sets.buff['Rapture'] = { head = "Arbatel Bonnet +3" }
    sets.buff['Perpetuance'] = { hands = "Arbatel Bracers +3" }
    sets.buff['Immanence'] = {
        -- main = empty,
        -- sub = empty,
        -- ammo = "Sapience Orb",
        -- head = empty,
        -- neck = empty,
        -- ear1 = "Enchanter's Earring +1",
        -- ear2 = "Loquacious Earring",
        -- body = empty,
        -- ring1 = "Chirich Ring +1",
        -- ring2 = "Chirich Ring +1",
        -- back = "Fi Follet Cape +1",
        -- waist = "Embla Sash",
        -- legs = empty,
        -- feet = empty,

        -- hands = "Arbatel Bracers +3",
    }
    sets.buff['Penury'] = { legs = "Arbatel Pants +3" }
    sets.buff['Parsimony'] = { legs = "Arbatel Pants +3" }
    sets.buff['Celerity'] = { feet = "Peda. Loafers +3" }
    sets.buff['Alacrity'] = { feet = "Peda. Loafers +3" }
    -- sets.buff['Klimaform'] = { feet = "Arbatel Loafers +3" }

    sets.HPDown = {
        head = "Pixie Hairpin +1",
        ear1 = "Mendicant's Earring",
        ear2 = "Evans Earring",
        waist = "Carrier's Sash",
    }

    sets.HPCure = {
        main = "Daybreak",
        sub = "Sors Shield",
        range = empty,
        --ammo="Hasty Pinion +1",
        -- head="Gende. Caubeen +1",
        neck = "Unmoving Collar +1",
        ear1 = "Gifted Earring",
        ear2 = "Mendi. Earring",
        body = "Kaykaus Bliaut",
        hands = "Kaykaus Cuffs",
        ring1 = "Gelatinous Ring +1",
        --ring2="Meridian Ring",
        back = "Moonlight Cape",
        waist = "Luminary Sash",
        --legs="Carmine Cuisses +1",
        feet = "Kaykaus Boots"
    }

    sets.buff.Doom = set_combine(sets.buff.Doom, {})
    sets.buff['Light Arts'] = {} --legs="Academic's Pants +3"
    sets.buff['Dark Arts'] = {}  --body="Academic's Gown +3"

    sets.buff.Sublimation = {
        --head="Acad. Mortar. +2",
        waist = "Embla Sash",
    }
    sets.buff.DTSublimation = { waist = "Embla Sash" }

    -- Weapons sets
    sets.weapons.Akademos = { main = "Malignance Pole", sub = "Enki Strap" }
    sets.weapons.Khatvanga = { main = "Khatvanga", sub = "Bloodrain Strap" }
end

-- Select default macro book on initial load or subjob change.
-- Default macro set/book
function select_default_macro_book()
    if player.sub_job == 'RDM' then
        set_macro_page(1, 17)
    elseif player.sub_job == 'BLM' then
        set_macro_page(1, 17)
    elseif player.sub_job == 'WHM' then
        set_macro_page(1, 17)
    else
        set_macro_page(1, 17)
    end
end

function job_tick()
    if check_arts() then return true end
    if check_buff() then return true end
    if check_buffup() then return true end
    if check_sub() then return true end
    return false
end

function handle_elemental(cmdParams)
    -- cmdParams[1] == 'elemental'
    -- cmdParams[2] == ability to use

    if not cmdParams[2] then
        add_to_chat(123, 'Error: No elemental command given.')
        return
    end
    local command = cmdParams[2]:lower()


    local immactive = 0

    if state.Buff['Immanence'] then
        immactive = 1
    end

    if command == 'spikes' then
        windower.chat.input('/ma "' .. data.elements.spikes_of[state.ElementalMode.value] .. ' Spikes" <me>')
        return
    elseif command == 'enspell' then
        windower.chat.input('/ma "En' .. data.elements.enspell_of[state.ElementalMode.value] .. '" <me>')
        return
        --Leave out target, let shortcuts auto-determine it.
    elseif command == 'weather' then
        local spell_recasts = windower.ffxi.get_spell_recasts()

        if (player.target.type == 'SELF' or not player.target.in_party) and buffactive[data.elements.storm_of[state.ElementalMode.value]] and not state.Buff.Klimaform and spell_recasts[287] < spell_latency then
            windower.chat.input('/ma "Klimaform" <me>')
        elseif player.job_points[(res.jobs[player.main_job_id].ens):lower()].jp_spent > 99 then
            windower.chat.input('/ma "' .. data.elements.storm_of[state.ElementalMode.value] .. ' II"')
        else
            windower.chat.input('/ma "' .. data.elements.storm_of[state.ElementalMode.value] .. '"')
        end
        return
    end

    local target = '<t>'
    if cmdParams[3] then
        if tonumber(cmdParams[3]) then
            target = tonumber(cmdParams[3])
        else
            target = table.concat(cmdParams, ' ', 3)
            target = get_closest_mob_id_by_name(target) or '<t>'
        end
    end

    if command == 'nuke' then
        local spell_recasts = windower.ffxi.get_spell_recasts()

        if state.ElementalMode.value == 'Light' then
            if spell_recasts[29] < spell_latency and actual_cost(get_spell_table_by_name('Banish II')) < player.mp then
                windower.chat.input('/ma "Banish II" ' .. target .. '')
            elseif spell_recasts[28] < spell_latency and actual_cost(get_spell_table_by_name('Banish')) < player.mp then
                windower.chat.input('/ma "Banish" ' .. target .. '')
            else
                add_to_chat(123, 'Abort: Banishes on cooldown or not enough MP.')
            end
        else
            local tiers = { ' V', ' IV', ' III', ' II', '' }
            for k in ipairs(tiers) do
                if spell_recasts[get_spell_table_by_name(data.elements.nuke_of[state.ElementalMode.value] .. '' .. tiers[k] .. '').id] < spell_latency and actual_cost(get_spell_table_by_name(data.elements.nuke_of[state.ElementalMode.value] .. '' .. tiers[k] .. '')) < player.mp and (state.Buff['Addendum: Black'] or not tiers[k]:endswith('V')) then
                    windower.chat.input('/ma "' ..
                        data.elements.nuke_of[state.ElementalMode.value] .. '' .. tiers[k] .. '" ' .. target .. '')
                    return
                end
            end
            add_to_chat(123,
                'Abort: All ' ..
                data.elements.nuke_of[state.ElementalMode.value] .. ' nukes on cooldown or or not enough MP.')
        end
    elseif command == 'ninjutsu' then
        windower.chat.input('/ma "' .. data.elements.ninjutsu_nuke_of[state.ElementalMode.value] .. ': Ni" ' ..
            target .. '')
    elseif command == 'smallnuke' then
        local spell_recasts = windower.ffxi.get_spell_recasts()

        local tiers = { ' II', '' }
        for k in ipairs(tiers) do
            if spell_recasts[get_spell_table_by_name(data.elements.nuke_of[state.ElementalMode.value] .. '' .. tiers[k] .. '').id] < spell_latency and actual_cost(get_spell_table_by_name(data.elements.nuke_of[state.ElementalMode.value] .. '' .. tiers[k] .. '')) < player.mp then
                windower.chat.input('/ma "' ..
                    data.elements.nuke_of[state.ElementalMode.value] .. '' .. tiers[k] .. '" ' .. target .. '')
                return
            end
        end
        add_to_chat(123,
            'Abort: All ' .. data.elements.nuke_of[state.ElementalMode.value] ..
            ' nukes on cooldown or or not enough MP.')
    elseif command:contains('tier') then
        local tierlist = {
            ['tier1'] = '',
            ['tier2'] = ' II',
            ['tier3'] = ' III',
            ['tier4'] = ' IV',
            ['tier5'] = ' V',
            ['tier6'] = ' VI'
        }

        windower.chat.input('/ma "' ..
            data.elements.nuke_of[state.ElementalMode.value] .. tierlist[command] .. '" ' .. target .. '')
    elseif command == 'ara' then
        windower.chat.input('/ma "' .. data.elements.nukera_of[state.ElementalMode.value] .. 'ra" ' .. target .. '')
    elseif command == 'aga' then
        windower.chat.input('/ma "' .. data.elements.nukega_of[state.ElementalMode.value] .. 'ga" ' .. target .. '')
    elseif command == 'helix' then
        if player.job_points[(res.jobs[player.main_job_id].ens):lower()].jp_spent > 1199 then
            windower.chat.input('/ma "' .. data.elements.helix_of[state.ElementalMode.value] .. 'helix II" ' ..
                target .. '')
        else
            windower.chat.input('/ma "' .. data.elements.helix_of[state.ElementalMode.value] .. 'helix" ' .. target .. '')
        end
    elseif command == 'enfeeble' then
        windower.chat.input('/ma "' .. data.elements.elemental_enfeeble_of[state.ElementalMode.value] .. '" ' ..
            target .. '')
    elseif command == 'bardsong' then
        windower.chat.input('/ma "' .. data.elements.threnody_of[state.ElementalMode.value] .. ' Threnody" ' ..
            target .. '')
    elseif command == 'skillchain1' then
        send_command('gs c set AutoSubMode false')

        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 2 then
            add_to_chat(123, 'Abort: You have less than two stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        elseif state.ElementalMode.value ~= nil then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end

            if state.ElementalMode.value == 'Fire' then
                windower.chat.input('/p ' ..
                    auto_translate('Liquefaction') .. ' -<t>- MB: ' .. auto_translate('Fire') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Stone" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' .. auto_translate('Liquefaction') .. ' -<t>- MB: ' ..
                    auto_translate('Fire') .. ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[281] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Pyrohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Fire" <t>')
                end
            elseif state.ElementalMode.value == 'Wind' then
                windower.chat.input('/p ' ..
                    auto_translate('Detonation') .. ' -<t>- MB: ' .. auto_translate('wind') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Stone" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' .. auto_translate('Detonation') .. ' -<t>- MB: ' .. auto_translate('wind') ..
                    ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[280] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Anemohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Aero" <t>')
                end
            elseif state.ElementalMode.value == 'Lightning' then
                windower.chat.input('/p ' ..
                    auto_translate('Impaction') .. ' -<t>- MB: ' .. auto_translate('Thunder') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Water" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' .. auto_translate('Impaction') .. ' -<t>- MB: ' ..
                    auto_translate('Thunder') .. ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[283] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Ionohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Thunder" <t>')
                end
            elseif state.ElementalMode.value == 'Light' then
                local spell_recasts = windower.ffxi.get_spell_recasts()
                if spell_recasts[284] > spell_latency or spell_recasts[285] > spell_latency + 7 then
                    add_to_chat(123, 'Abort: Noctohelix or Luminohelix on cooldown.')
                else
                    windower.chat.input('/p ' ..
                        auto_translate('Transfixion') .. ' -<t>- MB: ' .. auto_translate('Light') .. ' <scall21> OPEN!')
                    windower.chat.input:schedule(1.3, '/ma "Noctohelix" <t>')
                    windower.chat.input:schedule(6.6, '/ja "Immanence" <me>')
                    windower.chat.input:schedule(7.9,
                        '/p ' ..
                        auto_translate('Transfixion') .. ' -<t>- MB: ' .. auto_translate('Light') .. ' <scall21> CLOSE!')
                    windower.chat.input:schedule(7.9, '/ma "Luminohelix" <t>')
                end
            elseif state.ElementalMode.value == 'Earth' then
                windower.chat.input('/p ' ..
                    auto_translate('Scission') .. ' -<t>- MB: ' .. auto_translate('earth') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Fire" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' .. auto_translate('Scission') .. ' -<t>- MB: ' .. auto_translate('earth') ..
                    ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[278] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Geohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Stone" <t>')
                end
            elseif state.ElementalMode.value == 'Ice' then
                windower.chat.input('/p ' ..
                    auto_translate('Induration') .. ' -<t>- MB: ' .. auto_translate('ice') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Water" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' .. auto_translate('Induration') .. ' -<t>- MB: ' .. auto_translate('ice') ..
                    ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[282] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Cryohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Blizzard" <t>')
                end
            elseif state.ElementalMode.value == 'Water' then
                windower.chat.input('/p ' ..
                    auto_translate('Reverberation') .. ' -<t>- MB: ' .. auto_translate('Water') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Stone" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' .. auto_translate('Reverberation') ..
                    ' -<t>- MB: ' .. auto_translate('Water') .. ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[279] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Hydrohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Water" <t>')
                end
            elseif state.ElementalMode.value == 'Dark' then
                if windower.ffxi.get_spell_recasts()[284] > (spell_latency + 6) then
                    add_to_chat(123, 'Abort: Noctohelix on cooldown.')
                else
                    windower.chat.input('/p ' ..
                        auto_translate('Compression') ..
                        ' -<t>- MB: ' .. auto_translate('Darkness') .. ' <scall21> OPEN!')
                    windower.chat.input:schedule(1.3, '/ma "Blizzard" <t>')
                    windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                    windower.chat.input:schedule(6.9,
                        '/p ' ..
                        auto_translate('Compression') .. ' -<t>- MB: ' .. auto_translate('Darkness') ..
                        ' <scall21> CLOSE!')
                    windower.chat.input:schedule(6.9, '/ma "Noctohelix" <t>')
                end
            else
                add_to_chat(123,
                    'Abort: ' .. state.ElementalMode.value .. ' is not an Elemental Mode with a skillchain1 command!')
            end
        end
    elseif command == 'skillchain2' then
        send_command('gs c set AutoSubMode false')
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 2 then
            add_to_chat(123, 'Abort: You have less than two stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        elseif state.ElementalMode.value ~= nil then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end

            if state.ElementalMode.value == 'Fire' or state.ElementalMode.value == 'Light' then
                windower.chat.input('/p ' ..
                    auto_translate('Fusion') ..
                    ' -<t>- MB: ' .. auto_translate('Fire') .. ' ' .. auto_translate('Light') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Fire" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' ..
                    auto_translate('Fusion') ..
                    ' -<t>- MB: ' .. auto_translate('Fire') .. ' ' .. auto_translate('Light') .. ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[283] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Ionohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Thunder" <t>')
                end
            elseif state.ElementalMode.value == 'Wind' or state.ElementalMode.value == 'Lightning' then
                windower.chat.input('/p ' ..
                    auto_translate('Fragmentation') ..
                    ' -<t>- MB: ' .. auto_translate('wind') .. ' ' .. auto_translate('Thunder') .. ' <scall21> OPEN!')
                windower.chat.input:schedule(1.3, '/ma "Blizzard" <t>')
                windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6.9,
                    '/p ' ..
                    auto_translate('Fragmentation') ..
                    ' -<t>- MB: ' .. auto_translate('wind') .. ' ' .. auto_translate('Thunder') .. ' <scall21> CLOSE!')
                if windower.ffxi.get_spell_recasts()[279] < (spell_latency + 6) then
                    windower.chat.input:schedule(6.9, '/ma "Hydrohelix" <t>')
                else
                    windower.chat.input:schedule(6.9, '/ma "Water" <t>')
                end
            elseif state.ElementalMode.value == 'Earth' or state.ElementalMode.value == 'Dark' then
                if windower.ffxi.get_spell_recasts()[284] > (spell_latency + 6) then
                    add_to_chat(123, 'Abort: Noctohelix on cooldown.')
                else
                    windower.chat.input('/p ' ..
                        auto_translate('Gravitation') ..
                        ' -<t>- MB: ' ..
                        auto_translate('earth') .. ' ' .. auto_translate('Darkness') .. ' <scall21> OPEN!')
                    windower.chat.input:schedule(1.3, '/ma "Aero" <t>')
                    windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
                    windower.chat.input:schedule(6.9,
                        '/p ' ..
                        auto_translate('Gravitation') ..
                        ' -<t>- MB: ' .. auto_translate('earth') .. ' ' ..
                        auto_translate('Darkness') .. ' <scall21> CLOSE!')
                    send_command('gs c set CastingMode Proc')
                    windower.chat.input:schedule(6.9, '/ma "Noctohelix" <t>')
                end
            elseif state.ElementalMode.value == 'Ice' or state.ElementalMode.value == 'Water' then
                if windower.ffxi.get_spell_recasts()[285] > spell_latency then
                    add_to_chat(123, 'Abort: Luminohelix on cooldown.')
                else
                    windower.chat.input('/p ' ..
                        auto_translate('Distortion') ..
                        ' -<t>- MB: ' .. auto_translate('ice') .. ' ' .. auto_translate('Water') .. ' <scall21> OPEN!')
                    send_command('gs c set CastingMode Proc')
                    windower.chat.input:schedule(1.3, '/ma "Luminohelix" <t>')
                    windower.chat.input:schedule(6.6, '/ja "Immanence" <me>')
                    windower.chat.input:schedule(7.9,
                        '/p ' ..
                        auto_translate('Distortion') ..
                        ' -<t>- MB: ' .. auto_translate('ice') .. ' ' .. auto_translate('Water') .. ' <scall21> CLOSE!')
                    if windower.ffxi.get_spell_recasts()[278] < (spell_latency + 6) then
                        send_command('gs c set CastingMode Proc')
                        windower.chat.input:schedule(7.9, '/ma "Geohelix" <t>')
                    else
                        windower.chat.input:schedule(7.9, '/ma "Stone" <t>')
                    end
                end
            else
                add_to_chat(123,
                    'Abort: ' .. state.ElementalMode.value .. ' is not an Elemental Mode with a skillchain1 command!')
            end
        end
    elseif command == 'skillchain3' then
        send_command('gs c set AutoSubMode false')
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 3 then
            add_to_chat(123, 'Abort: You have less than three stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        elseif state.ElementalMode.value == 'Fire' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input('/p ' ..
                auto_translate('Liquefaction') .. ' -<t>- MB: ' .. auto_translate('Fire') .. ' <scall21> OPEN!')
            windower.chat.input:schedule(1.3, '/ma "Stone" <t>')
            windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6.9,
                '/p ' .. auto_translate('Liquefaction') .. ' -<t>- MB: ' .. auto_translate('Fire') .. ' <scall21> CLOSE!')
            -----------------------------------------------------------
            windower.chat.input:schedule(6.9, '/ma "Pyrohelix" <t>')
            windower.chat.input:schedule(15.1, '/ja "Immanence" <me>') --13
            windower.chat.input:schedule(17.0,
                '/p ' ..
                auto_translate('Fusion') ..
                ' -<t>- MB: ' ..
                auto_translate('Fire') .. ' ' .. auto_translate('Light') .. ' <scall21> CLOSE! <recast=stratagems>') --14.3
            --	windower.chat.input:schedule(6.9,'/ma "Fire" <t>')
            --	windower.chat.input:schedule(13,'/ja "Immanence" <me>')
            --	windower.chat.input:schedule(14.3,'/p '..auto_translate('Fusion')..' -<t>- MB: '..auto_translate('Fire')..' '..auto_translate('Light')..' <scall21> CLOSE!')
            if windower.ffxi.get_spell_recasts()[283] < (spell_latency + 12) then
                windower.chat.input:schedule(17.0, '/ma "Ionohelix" <t>') --14.3
                --windower.chat.input:schedule(14.3,'/ma "Ionohelix" <t>')
            else
                windower.chat.input:schedule(17.0, '/ma "Thunder" <t>') --14.3
                --windower.chat.input:schedule(14.3,'/ma "Thunder" <t>')
            end
        else
            add_to_chat(123, 'Abort: Fire is the only element with a consecutive 3-step skillchain.')
        end
    elseif command == 'skillchain4' then
        send_command('gs c set AutoSubMode false')
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 4 then
            add_to_chat(123, 'Abort: You have less than four stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        else
            state.CastingMode:set('Proc')
            if state.DisplayMode.value then update_job_states() end
            windower.chat.input('/p <call14> Starting 4-Step ' .. auto_translate('Skillchain') .. ' -<t>-')
            if not state.Buff['Immanence'] then
                windower.chat.input('/ja "Immanence" <me>')
            end
            windower.chat.input:schedule(1.3, '/ma "Water" <t>')        --step1
            windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6.9, '/ma "Thunder" <t>')      --step2
            windower.chat.input:schedule(9.7, '/ja "Divine Seal" <me>') --tabula
            windower.chat.input:schedule(11.2, '/ja "Immanence" <me>')
            windower.chat.input:schedule(12.5, '/ma "Aero" <t>')        --step3
            windower.chat.input:schedule(17.5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(18.8,
                '/p ' ..
                auto_translate('Noctohelix') ..
                ' -<t>- ' .. auto_translate('Chain Affinity') .. ' ' .. auto_translate('Skillchain') ..
                ' <scall21> next!')
            windower.chat.input:schedule(18.8, '/ma "Noctohelix" <t>') --step4

            --	windower.chat.input:schedule(17.8,'/ja "Immanence" <me>')
            --	windower.chat.input:schedule(19.1,'/ma "Noctohelix" <t>') 	 --step4
        end
    elseif command == 'skillchain4tab' then
        send_command('gs c set AutoSubMode false')
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis or not buffactive['Klimaform'] then
            add_to_chat(123, 'You are silenced, muted, paralyzed, or un-klimaformed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 4 then
            add_to_chat(123, 'Abort: You have less than four stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        else
            state.CastingMode:set('Proc')
            if state.DisplayMode.value then update_job_states() end
            windower.chat.input('/p <call14> Starting 4-Step ' .. auto_translate('Skillchain') .. ' -<t>-')
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3, '/ma "Water" <t>')         --step1
            windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6.9, '/ma "Thunder" <t>')       --step2
            windower.chat.input:schedule(11.2, '/ja "Tabula Rasa" <me>') --tabula
            windower.chat.input:schedule(12.5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(13.8, '/ma "Aero" <t>')         --step3
            windower.chat.input:schedule(18.1, '/ja "Immanence" <me>')
            windower.chat.input:schedule(19.4,
                '/p ' ..
                auto_translate('Noctohelix') ..
                ' -<t>- ' .. auto_translate('Chain Affinity') .. ' ' .. auto_translate('Skillchain') ..
                ' <scall21> next!')
            windower.chat.input:schedule(19.4, '/ma "Noctohelix" <t>') --step4
        end
    elseif command == 'skillchain4bumba' then
        send_command('gs c set AutoSubMode false')
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis or not buffactive['Klimaform'] then
            add_to_chat(123, 'You are silenced, muted, paralyzed, or un-klimaformed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 4 then
            add_to_chat(123, 'Abort: You have less than four stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        else
            state.CastingMode:set('Proc')
            if state.DisplayMode.value then update_job_states() end
            windower.chat.input('/p Starting 4-Step ' .. auto_translate('Skillchain') .. ' -<t>-')
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3, '/ma "Water" <t>')   --step1
            windower.chat.input:schedule(5.6, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6.9, '/ma "Thunder" <t>') --step2
            windower.chat.input:schedule(11.2, '/ja "Immanence" <me>')
            windower.chat.input:schedule(12.5, '/ma "Aero" <t>')   --step3
            windower.chat.input:schedule(16.8, '/ja "Immanence" <me>')
            windower.chat.input:schedule(18.1,
                '/p ' ..
                auto_translate('Noctohelix') ..
                ' -<t>- ' .. auto_translate('Chain Affinity') .. ' ' .. auto_translate('Skillchain') ..
                ' <scall21> next!')
            windower.chat.input:schedule(18.1, '/ma "Noctohelix" <t>') --step4
        end
    elseif command == 'skillchain6' then
        send_command('gs c set AutoSubMode false')
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif get_current_stratagem_count() < 5 then
            add_to_chat(123, 'Abort: You have less than five stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        elseif not state.Buff['Immanence'] then
            add_to_chat(123, 'Immanence not active, wait for stratagem cooldown. - Activating Immanence.')
            windower.chat.input('/ja "Immanence" <me>')
        else
            state.CastingMode:set('Proc')
            if state.DisplayMode.value then update_job_states() end
            windower.chat.input('/p Starting 6-Step ' .. auto_translate('Skillchain') .. ' -<t>-')
            windower.chat.input('/ma "Aero" <t>')
            windower.chat.input:schedule(4.3, '/ja "Immanence" <me>')
            windower.chat.input:schedule(5.6, '/ma "Stone" <t>')
            windower.chat.input:schedule(9.9, '/ja "Immanence" <me>')
            windower.chat.input:schedule(11.2, '/ma "Water" <t>')
            windower.chat.input:schedule(15.5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(16.8, '/ma "Thunder" <t>')
            windower.chat.input:schedule(21.1, '/ja "Immanence" <me>')
            windower.chat.input:schedule(22.4, '/ma "Fire" <t>')
            windower.chat.input:schedule(26.7, '/ja "Immanence" <me>')
            windower.chat.input:schedule(28, '/ma "Thunder" <t>')
        end
    elseif command == 'wsskillchain' then
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif player.tp < 1000 then
            add_to_chat(123, 'Abort: You don\'t have enough TP for this skillchain.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif (get_current_stratagem_count() + immactive) < 1 then
            add_to_chat(123, 'Abort: You have less than one stratagems available.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        elseif state.ElementalMode.value == 'Fire' then
            windower.chat.input('/p ' ..
                auto_translate('Liquefaction') .. ' -<t>- MB: ' .. auto_translate('Fire') .. ' <scall21> OPEN!')
            windower.chat.input('/ws "Rock Crusher" <t>')
            windower.chat.input:schedule(5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6,
                '/p ' .. auto_translate('Liquefaction') .. ' -<t>- MB: ' .. auto_translate('Fire') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(6, '/ma "Fire" <t>')
        elseif state.ElementalMode.value == 'Wind' then
            windower.chat.input('/p ' ..
                auto_translate('Detonation') .. ' -<t>- MB: ' .. auto_translate('wind') .. ' <scall21> OPEN!')
            windower.chat.input('/ws "Rock Crusher" <t>')
            windower.chat.input:schedule(5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6,
                '/p ' .. auto_translate('Detonation') .. ' -<t>- MB: ' .. auto_translate('wind') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(6, '/ma "Aero" <t>')
        elseif state.ElementalMode.value == 'Lightning' then
            windower.chat.input('/p ' ..
                auto_translate('Impaction') .. ' -<t>- MB: ' .. auto_translate('Thunder') .. ' <scall21> OPEN!')
            windower.chat.input('/ws "Starburst" <t>')
            windower.chat.input:schedule(5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6,
                '/p ' .. auto_translate('Impaction') .. ' -<t>- MB: ' .. auto_translate('Thunder') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(6, '/ma "Thunder" <t>')
        elseif state.ElementalMode.value == 'Light' then
            windower.chat.input('/p ' ..
                auto_translate('Transfixion') .. ' -<t>- MB: ' .. auto_translate('Light') .. ' <scall21> OPEN!')
            windower.chat.input('/ws "Starburst" <t>')
            windower.chat.input:schedule(5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6,
                '/p ' .. auto_translate('Transfixion') .. ' -<t>- MB: ' .. auto_translate('Light') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(6, '/ma "Luminohelix" <t>')
        elseif state.ElementalMode.value == 'Earth' then
            if player.sub_job == 'WHM' then
                windower.chat.input('/p ' ..
                    auto_translate('Scission') .. ' -<t>- MB: ' .. auto_translate('earth') .. ' <scall21> OPEN!')
                windower.chat.input('/ws "Earth Crusher" <t>')
                windower.chat.input:schedule(5, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6,
                    '/p ' .. auto_translate('Scission') .. ' -<t>- MB: ' .. auto_translate('earth') ..
                    ' <scall21> CLOSE!')
                windower.chat.input:schedule(6, '/ma "Stone" <t>')
            else
                windower.chat.input('/p ' ..
                    auto_translate('Scission') .. ' -<t>- MB: ' .. auto_translate('earth') .. ' <scall21> OPEN!')
                windower.chat.input('/ws "Shell Crusher" <t>')
                windower.chat.input:schedule(5, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6,
                    '/p ' .. auto_translate('Scission') .. ' -<t>- MB: ' .. auto_translate('earth') ..
                    ' <scall21> CLOSE!')
                windower.chat.input:schedule(6, '/ma "Stone" <t>')
            end
        elseif state.ElementalMode.value == 'Ice' then
            windower.chat.input('/p ' ..
                auto_translate('Induration') .. ' -<t>- MB: ' .. auto_translate('ice') .. ' <scall21> OPEN!')
            windower.chat.input('/ws "Starburst" <t>')
            windower.chat.input:schedule(5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6,
                '/p ' .. auto_translate('Induration') .. ' -<t>- MB: ' .. auto_translate('ice') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(6, '/ma "Blizzard" <t>')
        elseif state.ElementalMode.value == 'Water' then
            windower.chat.input('/p ' ..
                auto_translate('Reverberation') .. ' -<t>- MB: ' .. auto_translate('Water') .. ' <scall21> OPEN!')
            windower.chat.input('/ws "Omniscience" <t>')
            windower.chat.input:schedule(5, '/ja "Immanence" <me>')
            windower.chat.input:schedule(6,
                '/p ' .. auto_translate('Reverberation') .. ' -<t>- MB: ' .. auto_translate('Water') ..
                ' <scall21> CLOSE!')
            windower.chat.input:schedule(6, '/ma "Water" <t>')
        elseif state.ElementalMode.value == 'Dark' then
            if player.sub_job == 'WHM' then
                windower.chat.input('/p ' ..
                    auto_translate('Gravitation') ..
                    ' -<t>- MB: ' .. auto_translate('earth') .. ' ' .. auto_translate('Darkness') .. ' <scall21> OPEN!')
                windower.chat.input('/ws "Earth Crusher" <t>')
                windower.chat.input:schedule(5, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6,
                    '/p ' ..
                    auto_translate('Gravitation') ..
                    ' -<t>- MB: ' .. auto_translate('earth') .. ' ' .. auto_translate('Darkness') .. ' <scall21> CLOSE!')
                windower.chat.input:schedule(6, '/ma "Noctohelix" <t>')
            else
                windower.chat.input('/p ' ..
                    auto_translate('Compression') .. ' -<t>- MB: ' .. auto_translate('Darkness') .. ' <scall21> OPEN!')
                windower.chat.input('/ws "Omniscience" <t>')
                windower.chat.input:schedule(5, '/ja "Immanence" <me>')
                windower.chat.input:schedule(6,
                    '/p ' ..
                    auto_translate('Compression') .. ' -<t>- MB: ' .. auto_translate('Darkness') .. ' <scall21> CLOSE!')
                windower.chat.input:schedule(6, '/ma "Noctohelix" <t>')
            end
        end
    elseif command == 'endskillchain' then
        if player.target.type ~= "MONSTER" then
            add_to_chat(123, 'Abort: You are not targeting a monster.')
        elseif buffactive.silence or buffactive.mute or buffactive.paralysis then
            add_to_chat(123, 'You are silenced, muted, or paralyzed, cancelling skillchain.')
        elseif not (state.Buff['Dark Arts'] or state.Buff['Addendum: Black']) then
            add_to_chat(123, 'Can\'t use elemental skillchain commands without Dark Arts - Activating.')
            windower.chat.input('/ja "Dark Arts" <me>')
        elseif state.ElementalMode.value == 'Fire' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('Fire') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Fire" <t>')
        elseif state.ElementalMode.value == 'Wind' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('wind') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Aero" <t>')
        elseif state.ElementalMode.value == 'Lightning' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('Thunder') ..
                ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Thunder" <t>')
        elseif state.ElementalMode.value == 'Light' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('Light') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Luminohelix" <t>')
        elseif state.ElementalMode.value == 'Earth' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('earth') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Stone" <t>')
        elseif state.ElementalMode.value == 'Ice' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('ice') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Blizzard" <t>')
        elseif state.ElementalMode.value == 'Water' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('Water') .. ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Water" <t>')
        elseif state.ElementalMode.value == 'Dark' then
            if not state.Buff['Immanence'] then windower.chat.input('/ja "Immanence" <me>') end
            windower.chat.input:schedule(1.3,
                '/p ' .. auto_translate('Skillchain') .. ' -<t>- MB: ' .. auto_translate('Darkness') ..
                ' <scall21> CLOSE!')
            windower.chat.input:schedule(1.3, '/ma "Noctohelix" <t>')
        end
    else
        add_to_chat(123, 'Unrecognized elemental command.')
    end
end
