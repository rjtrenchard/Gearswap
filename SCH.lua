-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
        Custom commands:

        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.

                                        Light Arts              Dark Arts

        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    gear.default.obi_waist = "Sacro Cord"
    gear.default.cure_waist = "Shinjutsu-no-obi +1"
    info.addendumNukes = S { "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V" }

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    update_active_strategems()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')
    include('natty_helper_functions.lua')
    state.OffenseMode:options('None', 'Normal')
    state.HybridMode:options('Normal')
    state.CastingMode:options('Normal', 'Low')
    state.RangedMode:options('None')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')


    state.MagicBurst = M { ['description'] = "Magic Burst", "Normal", "Always" }
    state.SkillchainMode = M { ['description'] = 'Skillchain', 'Normal', 'Skillchain' }
    state.RegenMode = M { ['description'] = 'Regen', 'Duration', 'Potency' }
    state.HelixMode = M { ['description'] = 'Helices', 'Normal', 'Helix' } -- if helix is set, next standard elemental magic will be

    info.helices = T {
        ['None'] = nil,
        ['Light'] = "Luminohelix II",
        ['Dark'] = "Noctohelix II",
        ['Fire'] = "Pyrohelix II",
        ['Earth'] = "Geohelix II",
        ['Water'] = "Hydrohelix II",
        ['Wind'] = "Anemohelix II",
        ['Ice'] = "Cryohelix II",
        ['Lightning'] = "Ionohelix II"
    }

    info.helix_base = T {
        ['None'] = nil,
        ['Banish'] = "Luminohelix",
        ['Comet'] = "Noctohelix",
        ['Fire'] = "Pyrohelix",
        ['Stone'] = "Geohelix",
        ['Water'] = "Hydrohelix",
        ['Aero'] = "Anemohelix",
        ['Blizzard'] = "Cryohelix",
        ['Thunder'] = "Ionohelix"
    }

    info.low_nukes = S { "Stone", "Water", "Aero", "Fire", "Blizzard", "Thunder" }
    info.mid_nukes = S { "Stone II", "Water II", "Aero II", "Fire II", "Blizzard II", "Thunder II",
        "Stone III", "Water III", "Aero III", "Fire III", "Blizzard III", "Thunder III",
        "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV", }
    info.high_nukes = S { "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V" }

    send_command('bind ` input /ja "Sublimation" <me>')

    -- send_command('bind numpad1 input /ma Stun <t>')
    send_command('bind !` gs c cycle MagicBurst')

    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^- gs c cycle DoomMode')

    send_command('bind numpad. gs c returnmacro')

    send_command('bind numpad1 input /ma "Cure IV" <t>')
    send_command('bind ^numpad1 gs c cycle RegenMode')
    send_command('bind numpad2 gs c helix')
    send_command('bind numpad3 input /ja "Focalization" <me>')
    send_command('bind ^numpad3 input /ja "Alacrity" <me>')

    send_command('bind numpad4 input /ja "Accession" <me>')
    send_command('bind numpad5 input /ja "Immanence" <me>')
    send_command('bind !numpad5 input /ja "Immanence" <me>; gs c helix_on_dark_arts true')
    send_command('bind ^numpad5 input /ja "Immanence" <me>; gs c helix_on_dark_arts')
    -- send_command('bind ^numpad5 gs c cycle SkillchainMode')
    send_command('bind numpad6 input /ja "Ebullience" <me>')
    send_command('bind !numpad6 input /ja "Ebullience" <me>; gs c helix_on_dark_arts true')
    send_command('bind ^numpad6 input /ja "Ebullience" <me>; gs c helix_on_dark_arts')
    send_command('bind ~numpad6 gs c cycle HelixMode')

    send_command('bind numpad7 gs equip sets.weapons.Malignance')
    send_command('bind ^numpad7 gs equip sets.weapons.Malignance.DD')
    send_command('bind numpad8 gs equip sets.weapons.Xoanon')
    send_command('bind ^numpad8 gs equip sets.weapons.Xoanon.DD')
    send_command('bind numpad9 gs equip sets.weapons.Musa')
    send_command('bind ^numpad9 gs equip sets.weapons.Musa.DD')
    send_command('bind !numpad9 gs equip sets.weapons.Mpaca')

    select_default_macro_book()
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
        name = "Lugh's Cape",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', }
    }

    gear.idle_cape = {
        name = "Lugh's Cape",
        augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Phys. dmg. taken-10%' }
    }

    -- Misc sets
    sets.weapons = {}
    -- sets.weapons.Malignance = { main = "Malignance Pole", sub = "Oneiros Grip" }
    -- sets.weapons.Malignance.DD = { main = "Malignance Pole", sub = "Khonsu" }
    sets.weapons.Xoanon = { main = "Xoanon", sub = "Oneiros Grip" }
    sets.weapons.Xoanon.DD = { main = "Xoanon", sub = "Khonsu" }
    sets.weapons.Musa = { main = "Musa", sub = "Oneiros Grip" }
    sets.weapons.Musa.DD = { main = "Musa", sub = "Khonsu" }
    sets.weapons.Mpaca = { main = "Mpaca's Staff", sub = "Oneiros Grip" }


    sets.SIRD = {
        ammo = "Staunch Tathlum +1", -- 11
        head = "Agwu's Cap",         -- 10
        neck = "Loricate Torque +1", -- 5
        ear1 = "Halasz Earring",     -- 5
        ear2 = "Magnetic Earring",   -- 8
        body = "Rosette Jaseran +1", -- 25
        hands = "Chironic Gloves",   -- 15
        ring1 = "Freke Ring",        -- 10
        ring2 = "Evanescence Ring",  -- 5
        waist = "Emphatikos Rope",   -- 12
        -- legs = "Lengo Pants", -- 10
        -- feet = "Amalric Nails +1", -- 15
    }

    sets.Empyrean = {
        head = "Arbatel Bonnet +2",
        body = "Arbatel Gown +1",
        hands = "Arbatel Bracers +3",
        legs = "Arbatel Pants +2",
        feet = "Arbatel Loafers +2"
    }

    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['Tabula Rasa'] = { legs = "Pedagogy Pants +3" }


    -- Weaponskill precast sets
    sets.precast.WS = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Shukuyu Ring",
        back = "Aurist's Cape +1",
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS['Retribution'] = set_combine(sets.precast.WS,
        { neck = "Republican Platinum Medal", waist = "Cornelia's Belt" })

    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ring2 = "Archon Ring",
        back = "Aurist's Cape +1",
        waist = gear.ElementalObi,
    })

    sets.precast.WS['Omniscience'] = set_combine(sets.precast.WS['Cataclysm'], { neck = "Argute Stole +2" })

    sets.precast.WS['Myrkr'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Kaykaus Mitra +1",
        neck = "Orunmila's Torque",
        ear1 = "Nehalennia earring",
        ear2 = "Etiolation Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = "Metamorph Ring +1",
        ring2 = "Mephitas's Ring +1",
        back = "Aurist's Cape +1",
        waist = "Shinjutsu-no-obi +1",
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus boots +1",
    }

    sets.precast.WS['Shattersoul'] = set_combine(sets.precast.WS, {
        neck = "Argute Stole +2",
        ear1 = "Regal Earring",
        ear2 = "Brutal Earring",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
    })

    sets.precast.WS['Spirit Taker'] = sets.precast.WS['Shattersoul']

    sets.precast.WS['Sunburst'] = set_combine(sets.precast.WS['Cataclysm'], {})
    sets.precast.WS['Starburst'] = sets.precast.WS['Sunburst']
    sets.precast.WS['Earth Crusher'] = set_combine(sets.precast.WS['Cataclysm'],
        { head = "Nyame Helm", ring2 = "Freke Ring" })


    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Earth Crusher'], {})
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Flash Nova']
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Shining Strike']

    sets.precast.WS['Moonlight'] = { neck = "Combatant's Torque", ear2 = "Moonshade Earring" }
    sets.precast.WS['Starlight'] = sets.precast.WS['Moonlight']


    -- Fast cast sets for spells

    sets.precast.FC = {
        main = "Musa",                -- 11
        sub = "Khonsu",
        ammo = "Impatiens",           -- +2QC
        head = gear.merlinic.fc.head, -- 15
        neck = "Orunmila's Torque",   -- 5
        ear1 = "Malignance Earring",  -- 4
        ear2 = "Etiolation Earring",
        -- ear2 = "Loquacious Earring",    -- 2
        body = gear.merlinic.fc.body, -- 13
        -- hands = "Gendewitha Gages +1",  -- 7
        ring1 = "Kishar Ring",        -- 6
        ring2 = "Medada's Ring",      -- 10
        back = { name = "Moonlight Cape", priority = 10 },
        waist = "Embla Sash",         -- 5
        legs = "Kaykaus Tights +1",   -- 7
        feet = "Pedagogy Loafers +3"  -- 8
    }

    sets.precast.FC.WithArts = set_combine(sets.precast.FC,
        { head = "Pedagogy Mortarboard +3", ring2 = "Medada's Ring", feet = "Academic's Loafers +3" }) -- need 70 FC
    sets.precast.FC.AgainstArts = set_combine(sets.precast.FC,
        { ear2 = "Loquacious Earring", ring2 = "Medada's Ring", back = "Fi Follet Cape +1", })         -- need 90 FC

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, { waist = "Siegel Sash" })

    sets.precast.FC.Impact = set_combine(sets.precast.FC,
        { head = empty, body = "Crepuscular Cloak", ring2 = "Medada's Ring", back = "Fi Follet Cape +1" })
    sets.precast.Impact = sets.precast.FC.Impact

    sets.precast.FC.SubRDM = {
        -- +15 FC
        main = "Musa",               -- 11
        ammo = "Impatiens",
        neck = "Orunmila's Torque",  -- 5
        ear1 = "Malignance Earring", -- 4
        -- ear2 = "Loquacious Earring", -- 2
        ear2 = "Etiolation Earring",
        body = gear.merlinic.fc.body, -- 13
        -- hands = "Gendewitha Gages +1",  -- 7
        ring1 = "Kishar Ring",        -- 6
        ring2 = "Medada's Ring",
        back = "Perimede Cape",
        waist = "Embla Sash",        -- 5
        legs = "Kaykaus Tights +1",  -- 7
        feet = "Pedagogy Loafers +3" -- 8
    }
    sets.precast.FC.SubRDM.WithArts = set_combine(sets.precast.FC.SubRDM,
        { head = "Pedagogy Mortarboard +3", feet = "Academic's Loafers +3" })
    sets.precast.FC.SubRDM.AgainstArts = set_combine(sets.precast.FC.SubRDM,
        { head = gear.merlinic.fc.head, ring2 = "Medada's Ring", })
    sets.precast.FC.SubRDM['Enhancing Magic'] = set_combine(sets.precast.FC.SubRDM, { waist = "Siegel Sash" })
    sets.precast.FC.SubRDM['Enhancing Magic'].WithArts = {
        head = "Pedagogy Mortarboard +3",
        ear2 = "Etiolation Earring",
        waist = "Siegel Sash",
        feet = "Academic's Loafers +3"
    }
    sets.precast.FC.SubRDM['Enhancing Magic'].AgainstArts = { waist = "Siegel Sash" }

    sets.precast.FC.SubRDM['Impact'] = sets.precast.FC.Impact

    sets.precast.FC.SubRDM.NoQC = {
        -- +15 FC
        main = "Musa",
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = gear.merlinic.fc.body,
        hands = "Gendewitha Gages +1",
        ring1 = "Kishar Ring",
        ring2 = "Rahab Ring",
        waist = "Embla Sash",
        legs = "Kaykaus Tights +1",
        feet = gear.merlinic.fc.feet
    }

    sets.precast.FC.NoQC = {
        main = "Musa",
        head = gear.merlinic.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = gear.merlinic.fc.body,
        hands = "Gendewitha Gages +1",
        ring1 = "Kishar Ring",
        ring2 = "Rahab Ring",
        waist = "Embla Sash",
        legs = "Kaykaus Tights +1",
        feet = gear.merlinic.fc.feet
    }

    sets.precast.FC['Dispelga'] = set_combine(sets.precast.FC, { main = "Daybreak", sub = "Ammurapi Shield" })
    sets.precast.Dispelga = sets.precast.FC['Dispelga']

    -- Midcast Sets

    sets.midcast.FastRecast = {
        ammo = "Sapience Orb",
        head = "Agwu's Cap",
        ear2 = "Loquacious Earring",
        body = "Agwu's Robe",
        hands = "Gendewitha Gages +1",
        ring2 = "Kishar Ring",
        back = "Fi Follet Cape +1",
        waist = "Cornelia's Belt",
        legs = "Kaykaus Tights +1",
        feet = "Academic's Loafers +1"
    }

    sets.midcast.FastRecast.NoDMG = {
        main = empty,
        sub = empty,
        ammo = "Sapience Orb",
        head = empty,
        neck = "Orunmila's Torque",
        ear1 = "Loquacious Earring",
        ear2 = "Enchanter's Earring",
        body = empty,
        hands = empty,
        ring1 = empty,
        ring2 = empty,
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = empty,
        feet = empty
    }

    sets.midcast['Healing Magic'] = {
        main = "Musa",
        sub = "Khonsu",
        head = "Kaykaus Mitra +1",
        neck = "Incanter's Torque",
        ear1 = "Beatific Earring",
        ear2 = "Meili Earring",
        body = "Pedagogy Gown +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = { name = "Moonlight Cape", priority = 10 },
        feet = "Pedagogy Loafers +3"
    }

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], {
        main = "Musa",
        sub = "Khonsu",
        ammo = "Staunch Tathlum +1",
        head = "Kaykaus Mitra +1",
        neck = "Loricate Torque +1",
        ear1 = { name = "Etiolation Earring", priority = 9 },
        ear2 = "Magnetic Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = { name = "Gelatinous Ring +1", priority = 8 },
        ring2 = "Medada's Ring",
        back = gear.idle_cape,
        waist = "Platinum Moogle Belt",
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus Boots +1"
    })

    sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, { waist = "Hachirin-no-obi" })

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast['Enhancing Magic'] = {
        main = "Musa",
        sub = "Khonsu",
        ammo = "Savant's Treatise",
        head = "Arbatel Bonnet +2",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Pedagogy Gown +3",
        hands = "Chironic Gloves",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = { name = "Moonlight Cape", priority = 10 },
        waist = "Embla Sash",
        legs = "Shedir Seraweels",
        feet = "Kaykaus Boots +1",
    }

    sets.midcast['Enhancing Magic'].Duration = set_combine(sets.midcast['Enhancing Magic'], {
        main = "Musa",
        sub = "Khonsu",
        head = gear.telchine.enh_dur.head,
        body = "Pedagogy Gown +3",
        hands = gear.telchine.enh_dur.hands,
        ring2 = "Mephitas's Ring +1",
        waist = "Embla Sash",
        legs = gear.telchine.enh_dur.legs,
        feet = gear.telchine.enh_dur.feet
    })

    sets.midcast['Enhancing Magic'].Duration.NoSkill = set_combine(
        gear.telchine.enh_dur,
        { waist = "Embla Sash" })

    sets.midcast.RegenPotency = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        main = "Musa",
        sub = "Khonsu",
        head = "Arbatel Bonnet +2",
        body = gear.telchine.regen.body,
        hands = gear.telchine.regen.hands,
        waist = "Embla Sash",
        legs = gear.telchine.regen.legs,
        feet = gear.telchine.regen.feet
    })

    sets.midcast.RegenDuration = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        main = "Musa",
        sub = "Khonsu",
        head = "Arbatel Bonnet +2",
        body = "Pedagogy Gown +3",
        hands = gear.telchine.enh_dur.hands,
        waist = "Embla Sash",
        legs = gear.telchine.enh_dur.legs,
        feet = gear.telchine.enh_dur.feet
    })

    sets.midcast.Regen = sets.midcast.RegenDuration

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'].Duration, { head = "Amalric Coif +1", })

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        back = "Oretania's Cape +1",
        feet = "Gendewitha Galoshes +1",
    })

    -- set requires 4 mlvls before it works
    sets.midcast.Embrava = {
        main = "Musa",                       -- duration+20%
        sub = "Khonsu",
        ammo = "Arbatel Treatise",           -- 4
        head = gear.telchine.enh_dur.head,   -- duration+10%
        neck = "Incanter's Torque",          -- 10
        ear1 = "Andoaa Earring",             -- 5
        ear2 = "Mimir Earring",              -- 10
        body = "Pedagogy Gown +3",           -- 19, duration+12%
        hands = gear.telchine.enh_dur.hands, -- duration+10%
        ring1 = gear.left_stikini,           -- 8
        ring2 = gear.right_stikini,          -- 8
        back = "Fi Follet Cape +1",          -- 9
        waist = "Embla Sash",                -- duration+10%
        legs = gear.telchine.enh_dur.legs,   -- duration+10%
        feet = gear.telchine.enh_dur.feet,   -- duration+10%
    }

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'].Duration.NoSkill, {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    })

    sets.midcast.Blink = set_combine(sets.midcast['Enhancing Magic'].Duration)

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, sets.SIRD,
        { back = "Fi Follet Cape +1", head = "Amalric Coif +1", waist = "Emphatikos Rope" })

    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'].Duration, {})

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'].Duration, { ear1 = "Brachyura Earring" })
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell


    sets.midcast['Enfeebling Magic'] = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        ammo = "Pemphredo Tathlum",
        head = "Agwu's Cap",
        neck = "Argute Stole +2",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        hands = "Agwu's Gages",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Obstinate Sash",
        legs = "Arbatel Pants +2",
        feet = "Arbatel Loafers +2"
    }

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {
        main = "Contemplator +1",
        sub = "Khonsu",
        ammo = "Pemphredo Tathlum",
        head = "Agwu's Cap",
        neck = "Argute Stole +2",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        hands = "Agwu's Gages",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Obstinate Sash",
        legs = "Arbatel Pants +2",
        feet = "Arbatel Loafers +2"
    }

    sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], {
        back = { name = "Moonlight Cape", priorit = 10 },
    })

    sets.midcast.IntEnfeebles = sets.midcast.MndEnfeebles

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], { main = "Daybreak", sub = "Ammurapi Shield" })

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dark Magic'] = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        neck = "Incanter's Torque",
        ear1 = "Mani Earring",
        ear2 = "Dark Earring",
        hands = "Agwu's Gages",
        ring1 = gear.left_stikini,
        ring2 = "Evanescence Ring",
        waist = gear.ElementalObi,
        legs = "Pedagogy Pants +3",
    }

    sets.midcast.Kaustra = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = "Pixie Hairpin +1",
        neck = "Argute Stole +2",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring2 = "Medada's Ring",
        ring1 = "Metamorph Ring +1",
        back = gear.int_cape,
        waist = gear.ElementalObi,
        legs = "Agwu's Slops",
        feet = "Arbatel Loafers +2"
    }

    sets.midcast.Drain = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ear2 = "Dark Earring",
        body = "Agwu's Robe",
        hands = "Gendewitha Gages +1",
        ring1 = "Evanescence Ring",
        ring2 = "Archon Ring",
        back = "Merciful Cape",
        waist = gear.DrainWaist,
        legs = "Pedagogy Pants +3",
        feet = "Academic's Loafers +1"
    }

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        ammo = "Sapience Orb",
        head = "Agwu's Cap",
        neck = "Erra Pendant",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Agwu's Robe",
        hands = "Gendewitha Gages +1",
        ring1 = "Evanescence Ring",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Witful Belt",
        legs = "Pedagogy Pants +3",
        feet = "Academic's Loafers +1"
    }

    sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun, {})


    -- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = "Arbatel Bonnet +2",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Arbatel Gown +2",
        hands = "Arbatel Bracers +3",
        ring1 = "Freke Ring",
        ring2 = "Medada's Ring",
        back = gear.int_cape,
        waist = gear.ElementalObi,
        legs = "Arbatel Pants +2",
        feet = "Arbatel Loafers +2"
    }

    sets.midcast['Elemental Magic'].Resistant = {
        main = "Contemplator +1",
        sub = "Khonsu",
        ammo = "Pemphredo Tathlum",
        head = "Arbatel Bonnet +2",
        neck = "Argute Stole +2",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Arbatel Gown +2",
        hands = "Arbetel Bracers +2",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = gear.ElementalObi,
        legs = "Arbatel Pants +2",
        feet = "Arbatel Loafers +2"
    }

    sets.midcast['Elemental Magic'].Low = {
        main = empty,
        sub = empty,
        ammo = empty,
        head = empty,
        neck = empty,
        ear1 = "Loquacious earring",
        ear2 = "Enchanter's Earring +1",
        body = empty,
        hands = empty,
        ring1 = empty,
        ring2 = empty,
        back = empty,
        waist = empty,
        legs = empty,
        feet = empty
    }

    sets.midcast.MagicBurst = {
        head = "Pedagogy Mortarboard +3",
        neck = "Argute Stole +2",
        body = "Agwu's Robe",
        hands = "Arbatel Bracers +3",
        ring2 = "Mujin Band",
        legs = "Agwu's Slops",
        feet = "Arbatel Loafers +2"

    }

    sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'],
        { neck = "Argute Stole +2", back = "Bookworm's Cape", waist = "Sacro Cord" })

    sets.midcast.Helix.Resistant = set_combine(sets.midcast['Elemental Magic'].Resistant,
        { { neck = "Argute Stole +2", back = "Bookworm's Cape", waist = "Acuity Belt +1" } })

    sets.midcast['Elemental Magic'].Wind = set_combine(
        { main = "Marin Staff +1", sub = "Enki Strap" })

    sets.midcast['Elemental Magic'].Dark = set_combine(
        { head = "Pixie Hairpin +1", ring1 = "Archon Ring" })

    -- Custom refinements for certain nuke tiers
    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast['Elemental Magic'].HighTierNuke.Resistant = set_combine(sets.midcast['Elemental Magic'].Resistant, {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        main = "Contemplator +1",
        sub = "Enki Strap",
        head = empty,
        body = "Crepuscular Cloak",
    })


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        -- main = "Daybreak",
        -- sub = "Ammurapi Shield",
        head = "Nefer Khat +1",
        neck = "Bathy Choker +1",
        body = "Gendewitha Bliault +1",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Austerity Belt +1",
        legs = "Agwu's Slops",
        feet = "Serpentes Sabots"
    }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle.Town = {
        -- main = "Malignance Pole",
        -- sub = "Ammurapi Shield",
        ammo = "Homiliary",
        head = "Shaded Specs.",
        neck = "Smithy's Torque",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Blacksmith's Belt",
        legs = "Assiduity Pants +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.Field = {
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Lugalbanda Earring",
        body = "Arbatel Gown +2",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring +1",
        back = gear.idle_cape,
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Field.PDT = {
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Field.Refresh = {
        main = "Mpaca's Staff",
        sub = "Oneiros Grip",
        ammo = "Homiliary",
        head = "Befouled Crown",
        neck = "Sibyl Scarf",
        body = "Arbatel Gown +2",
        hands = gear.chironic.refresh.hands,
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring +1",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.Field.Stun = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Arbatel Gown +2",
        hands = "Gendewitha Gages +1",
        ring1 = "Medada's Ring",
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Cornelia's Belt",
        legs = "Agwu's Slops",
        feet = "Academic's Loafers +1"
    }

    sets.idle.Weak = {
        -- main = "Malignance Pole",
        -- sub = "Khonsu",
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Arbatel Gown +2",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Defense sets

    sets.defense.PDT = {
        -- main = "Malignance Pole",
        -- sub = "Enki Strap",
        ammo = "Sapience Orb",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Shinjutsu-no-obi +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = {
        -- main = "Malignance Pole",
        -- sub = "Enki Strap",
        ammo = "Sapience Orb",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring2 = "Shadow Ring",
        ring1 = "Gelatinous ring +1",
        back = "Moonlight Cape",
        waist = "Shinjutsu-no-obi +1",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.Kiting = { ring2 = "Shneddick Ring +1" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }


    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Nyame Mail",
        hands = "Gazu Bracelets +1",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        waist = "Windbuffet Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Ebullience'] = { head = "Arbatel Bonnet +2" }
    sets.buff['Rapture'] = { head = "Arbatel Bonnet +2" }
    sets.buff['Perpetuance'] = { hands = "Arbatel Bracers +3" }
    sets.buff['Immanence'] = { hands = "Arbatel Bracers +3" }
    sets.buff['Penury'] = { legs = "Arbatel Pants +2" }
    sets.buff['Parsimony'] = { legs = "Arbatel Pants +2" }
    sets.buff['Celerity'] = { feet = "Pedagogy Loafers +3" }
    sets.buff['Alacrity'] = { feet = "Pedagogy Loafers +3" }
    sets.buff['Tranquility'] = { hands = "Pedagogy Bracers +2" }
    sets.buff['Equanimity'] = sets.buff['Tranquility']

    sets.buff['Klimaform'] = { feet = "Arbatel Loafers +2" }

    sets.buff.FullSublimation = {
        head = "Academic's Mortarboard +3",
        ear1 = "Savant's Earring",
        body = "Pedagogy Gown +3",
        waist = "Embla Sash"
    }
    sets.buff.PDTSublimation = {
        head = "Academic's Mortarboard +3",
        ear1 = "Savant's Earring",
        waist = "Embla sash"
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    -- when casting in helix mode, remap comet and banish to helixes
    if (spell.english:contains('Banish') or spell.english == 'Comet')
        and state.HelixMode.value == 'Helix' then
        cancel_spell()
        local spell_remap = info.helix_base[get_spell_base(spell)]

        if state.CastingMode.value == 'Low' or
            (buffactive['Immanence'] and not buffactive['Ebullience']) then
            send_command('input /ma "' .. spell_remap .. '" ' .. spell.target.raw)
        else
            send_command('input /ma "' .. spell_remap .. ' II" ' .. spell.target.raw)
        end
    end

    local light_stratagems = S { "Penury", "Addendum: White", "Celerity",
        "Accession", "Rapture", "Altruism", "Tranquility", "Perpetuance", }

    local dark_stratagems = S { "Parsimony", "Addendum: Black", "Manifestation",
        "Alacrity", "Ebullience", "Focalization", "Equanimity", "Immanence", }

    local stratagems = light_stratagems + dark_stratagems

    local book_arts = (buffactive['Dark Arts'] or buffactive['Light Arts'] or buffactive['Addendum: Black'] or buffactive['Addendum: White'])

    if S { 'Light Arts', 'Dark Arts' }:contains(spell.english) then
        return_to_macro()
    end

    -- make arts-agnostic stratagems
    -- check if we're in a book, open appropriate book if not.
    if stratagems:contains(spell.english) and book_arts then
        cancel_spell()
    elseif stratagems:contains(spell.english) and not book_arts then
        cancel_spell()
        if light_stratagems:contains(spell.english) then
            send_command('input /ja "Light Arts" <me>')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    end

    if buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
        if spell.english == "Penury" then
            send_command('input /ja "Parsimony <me>')
        elseif spell.english == "Addendum: White" then
            send_command('input /ja "Addendum: Black" <me>')
        elseif spell.english == "Celerity" then
            send_command('input /ja "Alacrity" <me>')
        elseif spell.english == "Accession" then
            send_command('input /ja "Manifestation" <me>')
        elseif spell.english == "Rapture" then
            send_command('input /ja "Ebullience" <me>')
        elseif spell.english == "Altruism" then
            send_command('input /ja "Focalization" <me>')
        elseif spell.english == "Tranquility" then
            send_command('input /ja "Equanimity" <me>')
        elseif spell.english == "Perpetuance" then
            send_command('input /ja "Immanence" <me>')
        end
    elseif buffactive['Light Arts'] or buffactive['Addendum: White'] then
        if spell.english == "Parsimony" then
            send_command('input /ja "Penury" <me>')
        elseif spell.english == "Alacrity" then
            send_command('input /ja "Celerity" <me>')
        elseif spell.english == "Addendum: Black" then
            send_command('input /ja "Addendum: White" <me>')
        elseif spell.english == "Manifestation" then
            send_command('input /ja "Accession" <me>')
        elseif spell.english == "Ebullience" then
            send_command('input /ja "Rapture" <me>')
        elseif spell.english == "Focalization" then
            send_command('input /ja "Altruism" <me>')
        elseif spell.english == "Equanimity" then
            send_command('input /ja "Tranquility" <me>')
        elseif spell.english == "Immanence" then
            send_command('input /ja "Perpetuance" <me>')
        end
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    -- use low tier nukes when in low+skillchain mode//gs
    if S { 'Elemental Magic' }:contains(spell.skill)
        and buffactive['Immanence']
        and (state.MagicBurst.value == 'Normal' or not buffactive['Ebullience']) then
        if (spell.english:endswith('II') and not string.find(spell.english, 'helix')) then
            windower.add_to_chat(144, 'INFO: Remapping to low tier nuke')
            local spellBase = get_spell_base(spell)
            eventArgs.cancel = true
            if state.HelixMode.value == 'Helix' then
                send_command('input /ma "' .. info.helix_base[spellBase] .. '" ' .. spell.target.raw)
            else
                send_command('input /ma "' .. spellBase .. '" ' .. spell.target.raw)
            end
            return
        end
    end

    -- remap spell to helix when in helix modes
    if S { 'Elemental Magic' }:contains(spell.skill) and state.HelixMode.value == 'Helix' and not spell.english:find('helix') then
        local spellBase = get_spell_base(spell)
        send_command('input /ma "' .. info.helix_base[spellBase] .. ' II" ' .. spell.target.raw)
        eventArgs.cancel = true
        return
    end

    -- prepop immanence when in skillchain mode
    if spell.skill == 'Elemental Magic' and state.SkillchainMode.value == 'Skillchain' then
        if not (buffactive['Dark Arts'] or buffactive['Addendum: Black']) then
            windower.add_to_chat(144, 'Error: Skillchain mode but not in Dark Arts!')
            eventArgs.cancel = true
            return
        elseif not buffactive['Immanence'] then
            windower.add_to_chat(144, 'INFO: Skillchain mode')
            eventArgs.cancel = true
            send_command('input /ja "Immanence" <me>')
            return
        end
    end

    local info_msg = ""
    if not buffactive['Reraise'] and not spell.english:contains('Reraise') then
        info_msg = info_msg .. "Reraise not active! "
    end

    if (buffactive['Dark Arts'] or buffactive['Addendum: Black'])
        and not buffactive['Klimaform'] then
        info_msg = info_msg .. "Klimaform not active! "
    end

    if not (buffactive['Sublimation: Activated'] or buffactive['Sublimation: Complete']) and spell.name ~= "Sublimation" then
        local recasts = windower.ffxi.get_ability_recasts() or T {}
        local sublimation_recast = recasts[234] or 0
        if sublimation_recast <= 0.2 then
            info_msg = info_msg .. "Sublimation not active! "
        end
    end

    if not (buffactive['Light Arts'] or buffactive['Dark Arts'] or buffactive['Addendum: White'] or buffactive['Addendum: Black']) and not string.find(spell.english, ' Arts') and spell.action_type == 'Magic' then
        info_msg = info_msg .. "No book active! "
    end

    if info_msg ~= "" then
        windower.add_to_chat(144, "INFO: " .. info_msg)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type ~= 'WeaponSkill' then set_recast() end

    -- handle lightarts/darkarts fast cast correction
    if spell.action_type == 'Magic' then
        local withOrAgainst = is_with_arts(spell)

        if withOrAgainst ~= 'NA' then
            if player.sub_job == 'RDM' and player.sub_job_level >= 35 then
                if S { 'Sneak', 'Invisible', 'Deodorize', 'Stoneskin' }:contains(spell.english) then
                    equip(sets.precast.FC.SubRDM.NoQC)
                elseif spell.skill == 'Enhancing Magic' then
                    equip(sets.precast.FC.SubRDM[withOrAgainst], sets.precast.FC['Enhancing Magic'][withOrAgainst])
                elseif spell.english == "Impact" then
                    equip(sets.precast.FC[withOrAgainst], sets.precast.FC.Impact.SubRDM)
                else
                    equip(sets.precast.FC.SubRDM[withOrAgainst])
                end
            else
                if S { 'Sneak', 'Invisible', 'Deodorize', 'Stoneskin' }:contains(spell.english) then
                    equip(sets.precast.FC.NoQC)
                elseif spell.skill == 'Enhancing Magic' then
                    equip(sets.precast.FC[withOrAgainst], sets.precast.FC['Enhancing Magic'][withOrAgainst])
                elseif spell.english == "Impact" then
                    equip(sets.precast.FC[withOrAgainst], sets.precast.FC.Impact)
                else
                    equip(sets.precast.FC[withOrAgainst])
                end
            end
        elseif spell.action_type == 'Magic' and player.sub_job == 'RDM' and player.sub_job_level >= 35 and not spell == 'Impact' then
            equip(sets.precast.FC.SubRDM)
        end

        if spell.english == 'Impact' then
            equip(sets.precast.Impact)
        elseif spell.english == 'Dispelga' then
            equip(sets.precast.Dispelga)
        end


        -- if spell.action_type == 'Magic' then
        --     local withOrAgainst = nil

        --     if (spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive['Addendum: White']))
        --         or (spell.type == "BlackMagic" and (buffactive['Dark Arts'] or buffactive['Addendum: Black'])) then
        --         withOrAgainst = "WithArts"
        --     elseif (spell.type == "WhiteMagic" and (buffactive['Dark Arts'] or buffactive['Addendum: Black']))
        --         or (spell.type == "BlackMagic" and (buffactive["Light Arts"] or buffactive['Addendum: White'])) then
        --         withOrAgainst = "AgainstArts"
        --     end

        --     -- print(withOrAgainst, spell.type, player.sub_job, player.sub_job_level)

        --     if withOrAgainst and spell.action_type == 'Magic' then
        --         -- eventArgs.handled = true
        --         if player.sub_job == 'RDM' and player.sub_job_level >= 35 then
        --             if S { 'Sneak', 'Invisible', 'Deodorize', 'Stoneskin' }:contains(spell.english) then
        --                 equip(sets.precast.FC.SubRDM.NoQC)
        --             elseif spell.skill == 'Enhancing Magic' then
        --                 equip(sets.precast.FC.SubRDM[withOrAgainst], sets.precast.FC['Enhancing Magic'][withOrAgainst])
        --             elseif spell.english == "Impact" then
        --                 equip(sets.precast.FC[withOrAgainst], sets.precast.FC.Impact.SubRDM)
        --             else
        --                 equip(sets.precast.FC.SubRDM[withOrAgainst])
        --             end
        --         else
        --             if S { 'Sneak', 'Invisible', 'Deodorize', 'Stoneskin' }:contains(spell.english) then
        --                 equip(sets.precast.FC.NoQC)
        --             elseif spell.skill == 'Enhancing Magic' then
        --                 equip(sets.precast.FC[withOrAgainst], sets.precast.FC['Enhancing Magic'][withOrAgainst])
        --             elseif spell.english == "Impact" then
        --                 equip(sets.precast.FC[withOrAgainst], sets.precast.FC.Impact)
        --             else
        --                 equip(sets.precast.FC[withOrAgainst])
        --             end
        --         end
        --     elseif spell.action_type == 'Magic' and player.sub_job == 'RDM' and player.sub_job_level >= 35 and not spell == 'Impact' then
        --         equip(sets.precast.FC.SubRDM)
        --         -- eventArgs.handled = true
        --     end
    end
end

-- function job_midcast(spell, action, spellMap, evtargs)

-- end

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enhancing Magic' then
        if spell.english:endswith('storm') or spell.english:endswith('storm II')
            or spell.english:startswith('Shell')
            or spell.english:startswith('Protect')
            or S { 'Haste', 'Sneak', 'Invisible', 'Deodorize' }:contains(spell.english)
            or spell.english:startswith("Animus")
        then
            equip(sets.midcast['Enhancing Magic'].Duration)
        elseif spell.english:startswith('Regen') then
            equip(sets.midcast.Regen)
        elseif sets.midcast[spell.english] then
            equip(sets.midcast[spell.english])
        else
            equip(sets.midcast['Enhancing Magic'].Duration)
        end
        -- eventArgs.handled = true
    else
        -- if spell.skill == 'Elemental Magic' or spell.skill == 'Dark Magic' or spell.skill ==  then end
        -- if low and not a helix spell, cast in low nukes
        if spell.skill == 'Elemental Magic'
            and state.CastingMode.value == 'Low'
            and not spell.english:endswith('helix II') then
            -- and not state.MagicBurst.value == "Once" then

            -- set helix mode to normal after a single low cast
            windower.add_to_chat(144, "INFO: Magic casting is in low mode")
            equip(sets.midcast.FastRecast.NoDMG)
            eventArgs.handled = true
        elseif spell.skill == 'Elemental Magic' and spell.element == 'Wind' then
            equip(sets.midcast['Elemental Magic'].Wind)
        elseif spell.skill == 'Elemental Magic' and spell.element == 'Dark' then
            equip(sets.midcast['Elemental Magic'].Dark)
        end

        if S { 'Elemental Magic', 'Dark Magic', 'Divine Magic' }:contains(spell.skill) and S { 'Once', 'Always' }:contains(state.MagicBurst.value) then
            windower.add_to_chat(144, "INFO: Magic burst: " .. state.MagicBurst.value)
            equip(sets.midcast.MagicBurst)
            if state.MagicBurst.value == 'Once' then
                state.MagicBurst:reset()
            end
        end

        if spell.english == 'Impact' then
            equip(sets.midcast.Impact)
            -- eventArgs.handled = false
        elseif spell.english == 'Dispelga' then
            equip(sets.midcast.Dispelga)
            -- eventArgs.handled = false
        end
    end

    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end

    -- prevent blinks on immanence
    if buffactive['Immanence'] and state.CastingMode.value == 'Low' then
        equip({ main = "", sub = "" })
    end

    state.HelixMode:set('Normal')
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    equip_recast()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end

    if gain then
        if buff == 'Light Arts' then
            set_macro_page(6, 20)
            state.HelixMode:set('Normal')
        elseif buff == 'Dark Arts' then
            set_macro_page(7, 20)
        end
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    -- if stateField == 'Offense Mode' then
    --     if newValue == 'Normal' then
    --         disable('main', 'sub', 'range')
    --     else
    --         enable('main', 'sub', 'range')
    --     end
    -- end
    -- print(stateField)
    if stateField == 'Regen' then
        if newValue == 'Duration' then
            sets.midcast.Regen = sets.midcast.RegenDuration
        elseif newValue == 'Potency' then
            sets.midcast.Regen = sets.midcast.RegenPotency
        end
    elseif stateField == 'Magic Burst' then
        if oldValue == 'Always' and newValue == 'Once' then
            state.MagicBurst:set('Always')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'Normal' then
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        end
    end

    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not (buffactive['light arts'] or buffactive['dark arts'] or
            buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'returnmacro' then
        windower.add_to_chat(144, 'INFO: returning to default arts macro page')
        return_to_macro()
    elseif cmdParams[1]:lower() == 'helix' then
        local element = world.weather_element ~= 'None' and world.weather_element or world.day_element

        send_command('input /ma ' .. info.helices[element] .. ' <t>')
    elseif cmdParams[1]:lower() == 'sixstep' then
        --Custom 6 step skillchain macro w/o Tabula Rasa

        send_command(table.concat({
            'input /ja "Immanence" <me>',
            'wait 35',
            'input /ma "Aero" <t>',
            'wait 7',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 6.7',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Aero" <t>',
            'wait 6',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 4.6',
            'input /ja "Immanence" <me>',
            'wait 1.9',
            'input /ma "Aero" <t>',
            'wait 4.2',
            'input /ja "Immanence" <me>',
            'wait 1.9',
            'input /ma "Stone" <t>',
            'wait 3.4',
            'input /ja "Immanence" <me>',
            'wait 1.8',
            'input /ma "Aero" <t>',
        }, ';'))
    elseif cmdParams[1]:lower() == 'sixsteptabula' then
        --Custom 6 step skillchain macro using Tabula Rasa
        windower.send_command(table.concat({
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ja "Tabula Rasa" <me>',
            'wait 4',
            'input /ma "Aero" <t>',
            'wait 4',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 4',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Aero" <t>',
            'wait 4',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 4',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Aero" <t>',
            'wait 4',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 4',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Aero" <t>',
        }, ';'))
    elseif cmdParams[1]:lower() == 'fourstep' then
        windower.send_command(table.concat({
            'input /ja "Immanence" <me>',
            'wait 35',
            'input /ma "Aero" <t>',
            'wait 7',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 6.7',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Aero" <t>',
            'wait 6',
            'input /ja "Immanence" <me>',
            'wait 2',
            'input /ma "Stone" <t>',
            'wait 4.6',
            'input /ja "Immanence" <me>',
            'wait 1.9',
            'input /ma "Aero" <t>',
        }, ';'))
    elseif cmdParams[1]:lower() == 'helix_on_dark_arts' then
        helix_if_in_dark_arts(cmdParams[2])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function helix_if_in_dark_arts(use_helix)
    if buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
        if use_helix then
            send_command('gs c set HelixMode Helix')
        else
            send_command('gs c set HelixMode Normal')
        end
    end
end

function return_to_macro()
    local function l_set_macro_page(page, book)
        page = page or 6
        windower.send_command('input /macro set ' .. page)
        -- coroutine.sleep(.5)
        -- windower.send_command('input /macro set ' .. page)
    end

    if buffactive['Light Arts'] or buffactive['Addendum: White'] then
        page = 6
    elseif buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
        page = 7
    end
    l_set_macro_page(page, book)
end

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type == 'WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence and state.CastingMode.value ~= 'Low' then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123, 'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122, 'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122, 'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122, 'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123, 'Error: Unknown strategem [' .. strategem .. ']')
        end
    elseif buffactive['dark arts'] or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122, 'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123, 'Error: Unknown strategem [' .. strategem .. ']')
        end
    else
        add_to_chat(123, 'No arts has been activated yet.')
    end
end

-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4 * 60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(6, 20)
    send_command("@wait 5;input /lockstyleset 11")
end
