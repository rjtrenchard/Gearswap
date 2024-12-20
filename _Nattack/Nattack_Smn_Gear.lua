-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Also, you'll need the Shortcuts addon to handle the auto-targetting of the custom pact commands.

--[[
    Custom commands:

    gs c petweather
        Automatically casts the storm appropriate for the current avatar, if possible.

    gs c siphon
        Automatically run the process to: dismiss the current avatar; cast appropriate
        weather; summon the appropriate spirit; Elemental Siphon; release the spirit;
        and re-summon the avatar.

        Will not cast weather you do not have access to.
        Will not re-summon the avatar if one was not out in the first place.
        Will not release the spirit if it was out before the command was issued.

    gs c pact [PactType]
        Attempts to use the indicated pact type for the current avatar.
        PactType can be one of:
            cure
            curaga
            buffOffense
            buffDefense
            buffSpecial
            debuff1
            debuff2
            sleep
            nuke2
            nuke4
            bp70
            bp75 (merits and lvl 75-80 pacts)
            astralflow

--]]
-- res = include('resources.lua')

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false
    state.Buff["Astral Flow"] = buffactive["Astral Flow"] or false
    state.Buff["Apogee"] = buffactive["Apogee"] or false
    state.Buff["Mana Cede"] = buffactive["Mana Cede"] or false

    spirits = S { "LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit",
        "ThunderSpirit" }
    avatars = S { "Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin",
        "Alexander", "Cait Sith", "Siren" }

    magicalRagePacts = S {
        'Inferno', 'Earthen Fury', 'Tidal Wave', 'Aerial Blast', 'Diamond Dust', 'Judgment Bolt', 'Searing Light',
        'Howling Moon', 'Ruinous Omen',
        'Fire II', 'Stone II', 'Water II', 'Aero II', 'Blizzard II', 'Thunder II',
        'Fire IV', 'Stone IV', 'Water IV', 'Aero IV', 'Blizzard IV', 'Thunder IV',
        'Thunderspark', 'Meteorite', 'Nether Blast',
        'Meteor Strike', 'Heavenly Strike', 'Wind Blade', 'Geocrush', 'Grand Fall', 'Thunderstorm',
        'Holy Mist', 'Lunar Bay', 'Night Terror', 'Level ? Holy', 'Tornado II', 'Sonic Buffet'
    }

    hybridRagePacts = S {
        'Burning Strike', 'Flaming Crush',
    }


    pacts = {}
    pacts.cure = { ['Carbuncle'] = 'Healing Ruby' }
    pacts.curaga = { ['Carbuncle'] = 'Healing Ruby II', ['Garuda'] = 'Whispering Wind', ['Leviathan'] = 'Spring Water' }
    pacts.buffoffense = {
        ['Carbuncle'] = 'Glittering Ruby',
        ['Ifrit'] = 'Crimson Howl',
        ['Garuda'] = 'Hastega',
        ['Ramuh'] = 'Rolling Thunder',
        ['Fenrir'] = 'Ecliptic Growl',
        ['Siren'] = 'Katabatic Blades'
    }
    pacts.buffdefense = {
        ['Carbuncle'] = 'Shining Ruby',
        ['Shiva'] = 'Frost Armor',
        ['Garuda'] = 'Aerial Armor',
        ['Titan'] = 'Earthen Ward',
        ['Ramuh'] = 'Lightning Armor',
        ['Fenrir'] = 'Ecliptic Howl',
        ['Diabolos'] = 'Noctoshield',
        ['Cait Sith'] = 'Reraise II',
        ['Siren'] = 'Chinook'
    }
    pacts.buffspecial = {
        ['Ifrit'] = 'Inferno Howl',
        ['Garuda'] = 'Fleet Wind',
        ['Titan'] = 'Earthen Armor',
        ['Diabolos'] = 'Dream Shroud',
        ['Carbuncle'] = 'Soothing Ruby',
        ['Fenrir'] = 'Heavenward Howl',
        ['Cait Sith'] = 'Raise II',
        ['Siren'] = "Wind's Blessing"
    }
    pacts.debuff1 = {
        ['Shiva'] = 'Diamond Storm',
        ['Ramuh'] = 'Shock Squall',
        ['Leviathan'] = 'Tidal Roar',
        ['Fenrir'] = 'Lunar Cry',
        ['Diabolos'] = 'Pavor Nocturnus',
        ['Cait Sith'] = 'Eerie Eye',
        ['Siren'] = 'Lunatic Voice'
    }
    pacts.debuff2 = {
        ['Shiva'] = 'Sleepga',
        ['Leviathan'] = 'Slowga',
        ['Fenrir'] = 'Lunar Roar',
        ['Diabolos'] = 'Somnolence',
        ['Siren'] = 'Bitter Elegy'
    }
    pacts.sleep = { ['Shiva'] = 'Sleepga', ['Diabolos'] = 'Nightmare', ['Cait Sith'] = 'Mewing Lullaby' }
    pacts.nuke2 = {
        ['Ifrit'] = 'Fire II',
        ['Shiva'] = 'Blizzard II',
        ['Garuda'] = 'Aero II',
        ['Titan'] = 'Stone II',
        ['Ramuh'] = 'Thunder II',
        ['Leviathan'] = 'Water II'
    }
    pacts.nuke4 = {
        ['Ifrit'] = 'Fire IV',
        ['Shiva'] = 'Blizzard IV',
        ['Garuda'] = 'Aero IV',
        ['Titan'] = 'Stone IV',
        ['Ramuh'] = 'Thunder IV',
        ['Leviathan'] = 'Water IV'
    }
    pacts.bp70 = {
        ['Ifrit'] = 'Flaming Crush',
        ['Shiva'] = 'Rush',
        ['Garuda'] = 'Predator Claws',
        ['Titan'] = 'Mountain Buster',
        ['Ramuh'] = 'Chaotic Strike',
        ['Leviathan'] = 'Spinning Dive',
        ['Carbuncle'] = 'Meteorite',
        ['Fenrir'] = 'Eclipse Bite',
        ['Diabolos'] = 'Nether Blast',
        ['Cait Sith'] = 'Regal Scratch',
        ['Siren'] = 'Hysteric Assault',
    }
    pacts.bp75 = {
        ['Ifrit'] = 'Meteor Strike',
        ['Shiva'] = 'Heavenly Strike',
        ['Garuda'] = 'Wind Blade',
        ['Titan'] = 'Geocrush',
        ['Ramuh'] = 'Thunderstorm',
        ['Leviathan'] = 'Grand Fall',
        ['Carbuncle'] = 'Holy Mist',
        ['Fenrir'] = 'Lunar Bay',
        ['Diabolos'] = 'Night Terror',
        ['Cait Sith'] = 'Level ? Holy',
        ['Siren'] = "Tornado II"
    }
    pacts.astralflow = {
        ['Ifrit'] = 'Inferno',
        ['Shiva'] = 'Diamond Dust',
        ['Garuda'] = 'Aerial Blast',
        ['Titan'] = 'Earthen Fury',
        ['Ramuh'] = 'Judgment Bolt',
        ['Leviathan'] = 'Tidal Wave',
        ['Carbuncle'] = 'Searing Light',
        ['Fenrir'] = 'Howling Moon',
        ['Diabolos'] = 'Ruinous Omen',
        ['Cait Sith'] = "Altana's Favor",
        ['Siren'] = "Clarsach Call"
    }

    -- Wards table for creating custom timers
    wards = {}
    -- Base duration for ward pacts.
    wards.durations = {
        ['Crimson Howl'] = 60,
        ['Earthen Armor'] = 60,
        ['Inferno Howl'] = 60,
        ['Heavenward Howl'] = 60,
        ['Rolling Thunder'] = 120,
        ['Fleet Wind'] = 120,
        ['Shining Ruby'] = 180,
        ['Frost Armor'] = 180,
        ['Lightning Armor'] = 180,
        ['Ecliptic Growl'] = 180,
        ['Glittering Ruby'] = 180,
        ['Hastega'] = 180,
        ['Noctoshield'] = 180,
        ['Ecliptic Howl'] = 180,
        ['Dream Shroud'] = 180,
        ['Reraise II'] = 3600
    }
    -- Icons to use when creating the custom timer.
    wards.icons = {
        ['Earthen Armor']   = 'spells/00299.png',    -- 00299 for Titan
        ['Shining Ruby']    = 'spells/00043.png',    -- 00043 for Protect
        ['Dream Shroud']    = 'spells/00304.png',    -- 00304 for Diabolos
        ['Noctoshield']     = 'spells/00106.png',    -- 00106 for Phalanx
        ['Inferno Howl']    = 'spells/00298.png',    -- 00298 for Ifrit
        ['Hastega']         = 'spells/00358.png',    -- 00358 for Hastega
        ['Rolling Thunder'] = 'spells/00104.png',    -- 00358 for Enthunder
        ['Frost Armor']     = 'spells/00250.png',    -- 00250 for Ice Spikes
        ['Lightning Armor'] = 'spells/00251.png',    -- 00251 for Shock Spikes
        ['Reraise II']      = 'spells/00135.png',    -- 00135 for Reraise
        ['Fleet Wind']      = 'abilities/00074.png', --
    }
    -- Flags for code to get around the issue of slow skill updates.
    wards.flag = false
    wards.spell = ''

    -- If you don't like command-agnostic avatars, set their macro page/book here
    macro_sets = {}
    macro_sets.default = { page = 1, book = 16 }
    macro_sets['Carbuncle'] = { page = 10, book = 16 }
    macro_sets['Fenrir'] = { page = 7, book = 16 }
    macro_sets['Diabolos'] = { page = 10, book = 17 }
    macro_sets['Ifrit'] = { page = 7, book = 16 }
    macro_sets['Titan'] = { page = 5, book = 16 }
    macro_sets['Leviathan'] = { page = 6, book = 16 }
    macro_sets['Garuda'] = { page = 2, book = 16 }
    macro_sets['Shiva'] = { page = 8, book = 16 }
    macro_sets['Ramuh'] = { page = 9, book = 16 }
    macro_sets['Odin'] = { page = 8, book = 17 }
    macro_sets['Alexander'] = { page = 8, book = 17 }
    macro_sets['Cait Sith'] = { page = 9, book = 17 }
    macro_sets['Siren'] = { page = 3, book = 16 }
    macro_sets['Atomos'] = { page = 8, book = 17 }

    -- All spirits are the same page/book for siphoning.
    macro_sets.spirit = { page = 8, book = 17 }

    -- lua doesnt allow chaining equality in any sane way?
    macro_sets['LightSpirit'], macro_sets['DarkSpirit'], macro_sets['FireSpirit'], macro_sets['EarthSpirit'],
    macro_sets['WaterSpirit'], macro_sets['AirSpirit'], macro_sets['IceSpirit'], macro_sets['ThunderSpirit'] = macro_sets
        .spirit, macro_sets.spirit, macro_sets.spirit, macro_sets.spirit,
        macro_sets.spirit, macro_sets.spirit, macro_sets.spirit, macro_sets.spirit
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('natty_helper_functions.lua')
    include('default_sets.lua')

    state.OffenseMode:options('None', 'Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    gear.perp_staff = { name = "Gridarvor" }

    gear.avatar_melee_cape = {
        name = "Campestres's Cape",
        augments = { 'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20', 'Pet: Haste+7', }
    }
    gear.avatar_magic_cape = { name = "Campestres's Cape", augments = { 'Pet: M.Acc.+3 Pet: M.Dmg.+3', } }

    send_command(
        "bind numpad7 gs enable all; gs equip sets.midcast.Pet.PhysicalBloodPactRage; gs disable all; print 'Physical BP'")
    send_command(
        "bind numpad8 gs enable all; gs equip sets.midcast.Pet.MagicalBloodPactRage; gs disable all; print 'Magical BP'")
    send_command(
        "bind numpad9 gs enable all; gs equip sets.midcast.Pet.HybridBloodPactRage; gs disable all; ; print 'Hybrid BP'")
    send_command("bind numpad1 gs enable all")

    send_command("bind numpad3 /ja Convert <me>")

    select_default_macro_book()
end

function user_unload()
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast Sets
    --------------------------------------


    sets.precast['Summoning Magic'] = {
        ammo = "Vox Grip",
        head = "Convoker's Horn +2",
        neck = "Incanter's Torque",
        ear1 = "Lodurr Earring",
        ear2 = "Cath Palug Earring",
        body = "Beckoner's Doublet +1",
        hands = "Glyphic Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Conveyance Cape",
        waist = "Kobo Obi",
        legs = "Beckoner's Spats +1",
        feet = "Baayami Sabots +1"
    }

    -- Precast sets to enhance JAs
    sets.precast.JA['Astral Flow'] = { head = "Glyphic Horn +1" }

    sets.precast.JA['Elemental Siphon'] = set_combine(sets.midcast['Summoning Magic'],
        {
            main = "Soulscourge",
            sub = "Vox Grip",
            head = gear.telchine.enh_dur.head,
            body = gear.telchine.enh_dur.body,
            hands = gear.telchine.enh_dur.hands,
            ring1 = gear.left_stikini,
            ring2 = gear.right_stikini,
            back = "Conveyance Cape",
            waist = "Kobo Obi",
            legs = gear.telchine.enh_dur.legs,
            feet = "Beckoner's Pigaches +1"
        })

    sets.precast.JA['Mana Cede'] = { hands = "Caller's Bracers +1" }

    -- Pact delay reduction gear
    sets.precast.BloodPactWard = set_combine(sets.midcast['Summoning Magic'],
        {
            main = "Espiritus",
            ammo = "Sancus Sachet +1",
            body = "Convoker's Doublet +2",
            hands = "Glyphic Bracers +1",
            back = "Conveyance Cape",
            waist = "Kobo Obi",
            legs = "Glyphic Spats +1",
            feet = "Glyphic Pigaches +1"
        })

    sets.precast.BloodPactRage = sets.precast.BloodPactWard

    -- Fast cast sets for spells

    sets.precast.FC = {
        -- main = gear.grioavolr.fc,
        ammo = "Impatiens",
        head = gear.merlinic.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2",
        hands = gear.merlinic.fc.hands,
        ring1 = "Rahab Ring",
        ring2 = "Kishar Ring",
        back = "Perimede Cape",
        waist = "Embla Belt",
        legs = "Lengo Pants",
        feet = gear.merlinic.fc.feet
    }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, { waist = "Embla Sash" })

    sets.midcast['Enhancing Magic'] = { ear2 = "Mimir earring", waist = "Embla Sash" }

    sets.midcast.Refresh = sets.midcast['Enhancing Magic']

    sets.midcast['Enfeebling Magic'] = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        ammo = "Pemphredo Tathlum",
        head = "Bunzi's Hat",
        neck = "Incanter's Torque",
        ear1 = "Dignitary Earring",
        ear2 = "Crepuscular Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head = "Bunzi's Hat",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Crepuscular Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = "Rajas Ring",
        ring2 = "Ephramad's Ring",
        back = "Pahtli Cape",
        waist = "Fotia Belt",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

    sets.precast.WS.Elemental = {
        head = "Cath Palug Crown",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Friomisi Earring",
        body = "Amalric Doublet +1",
        hands = "Amalric Gages +1",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        back = "",
        waist = "Orpheus's Sash",
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1"
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Myrkr'] = {
        head = "Amalric Coif +1",
        neck = "Fotia Gorget",
        ear1 = "Evans Earring",
        ear2 = "Moonshade Earring",
        body = "Convoker's Doublet +2",
        hands = "Caller's Bracers +2",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Pahtli Cape",
        waist = "Fucho-no-Obi",
        legs = "Assiduity Pants +1",
        feet = "Chelona Boots +1"
    }




    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        ammo = "Staunch Tathlum +1",
        head = "Cath Palug Crown",
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = "Merlinic Jubbah",
        hands = "Bunzi's Gloves",
        ring1 = "Rahab Ring",
        back = "Fi Follet Cape +1",
        waist = "Embla Belt",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

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
        back = "Oretania's Cape +1"
    })

    sets.midcast.Cure = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Staunch Tathlum +1",
        head = "Vanya Hood",
        neck = "Nodens Gorget",
        ear2 = "Loquacious Earring",
        body = "Gendewitha Bliaut +1",
        hands = "Telchine Gloves",
        ring2 = "Rahab Ring",
        back = "Oretania's Cape +1",
        waist = "Embla Belt",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

    sets.midcast['Summoning Magic'] = {
        ammo = "Vox Grip",
        head = "Convoker's Horn +2",
        neck = "Incanter's Torque",
        ear1 = "Cath Palug Earring",
        ear2 = "Lodurr Earring",
        body = "Beckoner's Doublet",
        hands = "Glyphic Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Conveyance Cape",
        waist = "Kobo Obi",
        legs = "Beckoner's Spats",
        feet = "Baayami Sabots"
    }

    sets.midcast.Stoneskin = {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    }

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, {
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

    -- Avatar pact sets.  All pacts are Ability type.

    sets.midcast.Pet.BloodPactWard = {
        main = "Soulscourge",
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Incanter Torque",
        ear1 = "Evans Earring",
        body = "Caller's Doublet +2",
        hands = "Glyphic Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Diabolos's Rope",
        legs = "Marduk's Shalwar +1"
    }

    sets.midcast.Pet.DebuffBloodPactWard = {
        main = "Soulscourge",
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Incanter Torque",
        body = "Caller's Doublet +2",
        hands = "Glyphic Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Diabolos's Rope",
        legs = "Marduk's Shalwar +1"
    }

    sets.midcast.Pet.DebuffBloodPactWard.Acc = sets.midcast.Pet.DebuffBloodPactWard

    sets.midcast.Pet.PhysicalBloodPactRage = {
        main = "Gridarvor",
        sub = "Elan Strap +1",
        ammo = "Sancus Sachet +1",
        head = gear.helios.physicalbp.head,
        neck = "Shulmanu Collar",
        ear1 = "Lugalbanda Earring",
        ear2 = "Gelos Earring",
        body = "Glyphic Doublet +3",
        hands = gear.merlinic.bp_physical.hands,
        ring1 = "Varar Ring +1",
        ring2 = "Varar Ring +1",
        back = gear.avatar_melee_cape,
        waist = "Incarnation Sash",
        legs = "Apogee Slacks +1",
        feet = gear.helios.physicalbp.feet
    }

    sets.midcast.Pet.PhysicalBloodPactRage.Acc = sets.midcast.Pet.PhysicalBloodPactRage

    sets.midcast.Pet.MagicalBloodPactRage = {
        main = gear.grioavolr.bp,
        sub = "Elan Strap +1",
        ammo = "Sancus Sachet +1",
        head = "Cath Palug Crown",
        neck = "Adad Amulet",
        ear1 = "Lugalbanda Earring",
        ear2 = "Gelos Earring",
        body = "Convoker's Doublet +2",
        hands = gear.merlinic.bp_magical.hands,
        ring1 = "Varar Ring +1",
        ring2 = "Varar Ring +1",
        back = gear.avatar_magic_cape,
        waist = "Regal Belt",
        legs = "Enticer's Pants",
        feet = "Apogee Pumps +1"
    }

    sets.midcast.Pet.MagicalBloodPactRage.Acc = sets.midcast.Pet.MagicalBloodPactRage

    sets.midcast.Pet.HybridBloodPactRage = set_combine(sets.midcast.Pet.MagicalBloodPactRage,
        { waist = "Incarnation Sash" })


    -- Spirits cast magic spells, which can be identified in standard ways.

    sets.midcast.Pet.WhiteMagic = { legs = "Summoner's Spats +2" }

    sets.midcast.Pet['Elemental Magic'] = set_combine(sets.midcast.Pet.BloodPactRage, { legs = "Summoner's Spats +2" })

    sets.midcast.Pet['Elemental Magic'].Resistant = {}


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
        main = gear.Staff.HMP,
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Bathy Choker +1",
        ear1 = "Evans Earring",
        ear2 = "Cath Palug Earring",
        body = "Bunzi's Robe",
        hands = "Serpentes Cuffs",
        ring1 = "Sheltered Ring",
        ring2 = "Shadow Ring",
        back = "Pahtli Cape",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = "Chelona Boots +1"
    }

    -- Idle sets
    sets.idle = {
        -- main = "Malignance Pole",
        -- sub = "Oneiros Grip",
        ammo = "Sancus Sachet +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Evans Earring",
        ear2 = "Cath Palug Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring +1",
        back = "Umbra Cape",
        waist = "Platinum Moogle Belt",
        legs = "Assiduity Pants +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.PDT = {
        main = gear.Staff.PDT,
        sub = "Enki Strap",
        ammo = "Sancus Sachet +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Cath Palug Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Defending Ring",
        ring2 = gear.right_stikini,
        back = "Umbra Cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- perp costs:
    -- spirits: 7
    -- carby: 11 (5 with mitts)
    -- fenrir: 13
    -- others: 15
    -- avatar's favor: -4/tick

    -- Max useful -perp gear is 1 less than the perp cost (can't be reduced below 1)
    -- Aim for -14 perp, and refresh in other slots.

    -- -perp gear:
    -- Gridarvor: -5
    -- Glyphic Horn: -4
    -- Caller's Doublet +2/Glyphic Doublet: -4
    -- Stikini Ring +1: -1
    -- Convoker's Pigaches: -4
    -- total: -18

    -- Can make due without either the head or the body, and use +refresh items in those slots.

    sets.idle.Avatar = {
        main = "Gridarvor",
        sub = "Oneiros Grip",
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Shulmanu Collar",
        ear1 = "Enmerkar Earring",
        ear2 = "Cath Palug Earring",
        body = "Shomonjijoe +1",
        hands = "Caller's Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Campestres's Cape",
        waist = "Kobo Obi",
        legs = "Assiduity Pants +1",
        feet = "Apogee Pumps +1"
    }

    sets.idle.PDT.Avatar = {
        main = "Gridarvor",
        sub = "Oneiros Grip",
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Shulmanu Collar",
        ear1 = "Enmerkar Earring",
        ear2 = "Cath Palug Earring",
        body = "Shomonjijoe +1",
        hands = "Caller's Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = "Defending Ring",
        back = "Campestres's Cape",
        waist = "Kobo Obi",
        legs = "Assiduity Pants +1",
        feet = "Apogee Pumps +1"
    }

    sets.idle.Spirit = {
        main = "Gridarvor",
        sub = "Vox Grip",
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Incanter Torque",
        ear1 = "Enmerkar Earring",
        ear2 = "Cath Palug Earring",
        body = "Shomonjijoe +1",
        hands = "Caller's Bracers +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Conveyance Cape",
        waist = "Kobo Obi",
        legs = "Assiduity Pants +1",
        feet = "Apogee Pumps +1"
    }

    sets.idle.Town = {
        -- main = "Malignance Pole",
        -- sub = "Oneiros Grip",
        ammo = "Sancus Sachet +1",
        head = "Convoker's Horn +2",
        neck = "Bathy Choker +1",
        ear1 = "Enmerkar Earring",
        ear2 = "Cath Palug Earring",
        body = "Shomonjijoe +1",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Umbra Cape",
        waist = "Fucho-no-Obi",
        legs = "Assiduity Pants +1",
        feet = "Crier's Gaiters"
    }

    -- Favor uses Caller's Horn instead of Convoker's Horn for refresh
    sets.idle.Avatar.Favor = { head = "Beckoner's horn +1" } --{head="Beckoner's Horn"}
    sets.idle.Avatar.Melee = {
        neck = "Shulmanu Collar",
        ear1 = "Enmerkar Earring",
        ear2 = "Cath Palug Earring",
        body = "Shomonjijoe +1",
        hands = "Convoker's Bracers +2",
        ring1 = "Varar Ring +1",
        ring2 = "Cath Palug Ring",
        back = "Campestres's Cape",
        waist = "Klouskap Sash +1",
        legs = "Convoker's Spats",
        feet = "Apogee Pumps +1"
    }

    sets.perp = {}
    -- Caller's Bracer's halve the perp cost after other costs are accounted for.
    -- Using -10 (Gridavor, ring, Conv.feet), standard avatars would then cost 5, halved to 2.
    -- We can then use Bunzi's Robe and end up with the same net MP cost, but significantly better defense.
    -- Weather is the same, but we can also use the latent on the pendant to negate the last point lost.
    sets.perp.Day = {}     --{hands="Caller's Bracers +1"}
    sets.perp.Weather = {} --neck="Caller's Pendant",
    --hands="Caller's Bracers +1"}
    -- Carby: Mitts+Conv.feet = 1/tick perp.  Everything else should be +refresh
    sets.perp.Carbuncle = { --main="Bolelabunga",sub="Ammurapi Shield",
        head = "Convoker's Horn", hands = "", }
    sets.perp['Cait Sith'] = {}
    -- Diabolos's Rope doesn't gain us anything at this time
    --sets.perp.Diabolos = {waist="Diabolos's Rope"}
    sets.perp.Alexander = sets.midcast.Pet.BloodPactWard

    sets.perp.staff_and_grip = { main = gear.perp_staff, sub = "Enki Strap" }

    -- Defense sets
    sets.defense.PDT = {
        main = gear.Staff.PDT,
        head = "Bunzi's Hat",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Cath Palug Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = "Defending Ring",
        ring2 = gear.right_stikini,
        back = "Umbra Cape",
        waist = "Fucho-no-Obi",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

    sets.defense.MDT = {
        head = "Bunzi's Hat",
        neck = "Loricate Torque +1",
        ear1 = "Evans Earring",
        ear2 = "Loquacious Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = "Defending Ring",
        ring2 = "Archon Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-Obi",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

    sets.Kiting = { feet = "Crier's Gaiters" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Normal melee group
    --[[sets.engaged = {ammo="Sancus Sachet +1",
        head="Zelus Tiara",neck="Combatant's Torque",ear1="Crepuscular Earring",ear2="Brutal Earring",
        body="Bunzi's Robe",hands="Bunzi's Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Umbra Cape",waist="Cornelia's Belt",legs="Bunzi's Pants",feet="Bunzi's Sabots"}]]
    sets.engaged = set_combine(sets.idle.Avatar, {})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- function filtered_action(spell)
--     print(spell.id)
-- end

function job_pretarget(spell, action, spellMap, eventArgs)
    -- print(spell.type)
    -- when AFAC, auto convert when out of MP
    if (buffactive['Astral Flow'] and buffactive['Astral Conduit'] and player.sub_job == 'RDM') then
        if player.mp < spell.mp_cost and player.mp > 0 then
            eventArgs.cancel = true
            send_command('input /ja "Convert" <me>')
        end
        -- When AF up and AC down, auto Apogee
    elseif (buffactive['Astral Flow'] and not buffactive['Astral Conduit']) and spell.type == 'BloodPactRage' or spell.type == 'BloodPactWard' then
        if windower.ffxi.get_ability_recasts()[108] == 0 then
            eventArgs.cancel = true
            send_command('input /ja Apogee <me>')
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if pet_midaction() or spell.type == "Item" then
        -- windower.add_to_chat(144,'Midaction')
        return
    end

    if state.Buff['Astral Conduit'] or state.Buff['Apogee'] then
        -- windower.add_to_chat(144,'AC or apogee active')
        eventArgs.useMidcastGear = true
    end
end

-- function job_midcast(spell, action, spellMap, eventArgs)
-- end

-- function job_post_midcast(spell,action,spellMap,eventArgs)
-- end

-- Runs when pet completes an action.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.type == 'BloodPactWard' and spellMap ~= 'DebuffBloodPactWard' then
        wards.flag = true
        wards.spell = spell.english
        send_command('wait 4; gs c reset_ward_flag')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    elseif storms:contains(buff) then
        handle_equipping_gear(player.status)
    end

    if buff == 'Astral Conduit' and not gain then
        send_command('gs enable all')
    end

    if buff == 'Weakness' and gain then
        send_command('wait 2; input macro set 1')
    end
end

-- Called when the player's pet's status changes.
-- This is also called after pet_change after a pet is released.  Check for pet validity.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if pet.isvalid and not midaction() and not pet_midaction() and (newStatus == 'Engaged' or oldStatus == 'Engaged') then
        handle_equipping_gear(player.status, newStatus)
    end
end

-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    classes.CustomIdleGroups:clear()
    if gain then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end

        choose_pet_macro_book(pet.name)
    else
        select_default_macro_book('reset')
    end
end

-- change macro book to corresponding pet name
function choose_pet_macro_book(pet)
    if spirits:contains(pet) then
        set_macro_page(macro_sets.spirit.page, macro_sets.spirit.book)
    elseif avatars:contains(pet) then
        set_macro_page(macro_sets[pet].page, macro_sets[pet].book)
    else
        add_to_chat(123, 'Error: Unable to change macro, unknown Avatar.')
        set_macro_page(macro_sets.default.page, macro_sets.default.book)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell)
    if spell.type == 'BloodPactRage' then
        if magicalRagePacts:contains(spell.english) then
            return 'MagicalBloodPactRage'
        elseif hybridRagePacts:contains(spell.english) then
            return 'HybridBloodPactRage'
        else
            return 'PhysicalBloodPactRage'
        end
    elseif spell.type == 'BloodPactWard' and spell.target.type == 'MONSTER' then
        return 'DebuffBloodPactWard'
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if pet.isvalid then
        if pet.element == world.day_element then
            idleSet = set_combine(idleSet, sets.perp.Day)
        end
        if pet.element == world.weather_element then
            idleSet = set_combine(idleSet, sets.perp.Weather)
        end
        if sets.perp[pet.name] then
            idleSet = set_combine(idleSet, sets.perp[pet.name])
        end
        gear.perp_staff.name = elements.perpetuance_staff_of[pet.element]
        if gear.perp_staff.name and (player.inventory[gear.perp_staff.name] or player.wardrobe[gear.perp_staff.name]) then
            idleSet = set_combine(idleSet, sets.perp.staff_and_grip)
        end
        if state.Buff["Avatar's Favor"] and avatars:contains(pet.name) then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Favor)
        end
        if pet.status == 'Engaged' then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Melee)
        end
    end

    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
        choose_pet_macro_book(pet.name)
    else
        set_macro_page(macro_sets.default.page, macro_sets.default.book)
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'petweather' then
        handle_petweather()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'siphon' then
        handle_siphoning()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'pact' then
        handle_pacts(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1] == 'reset_ward_flag' then
        wards.flag = false
        wards.spell = ''
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Cast the appopriate storm for the currently summoned avatar, if possible.
function handle_petweather()
    if player.sub_job ~= 'SCH' then
        add_to_chat(122, "You can not cast storm spells")
        return
    end

    if not pet.isvalid then
        add_to_chat(122, "You do not have an active avatar.")
        return
    end

    local element = pet.element
    if element == 'Thunder' then
        element = 'Lightning'
    end

    if S { 'Light', 'Dark', 'Lightning' }:contains(element) then
        add_to_chat(122, 'You do not have access to ' .. elements.storm_of[element] .. '.')
        return
    end

    local storm = elements.storm_of[element]

    if storm then
        send_command('@input /ma "' .. elements.storm_of[element] .. '" <me>')
    else
        add_to_chat(123, 'Error: Unknown element (' .. tostring(element) .. ')')
    end
end

-- Custom uber-handling of Elemental Siphon
function handle_siphoning()
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'Cannot use Elemental Siphon in a city area.')
        return
    end

    local siphonElement
    local stormElementToUse
    local releasedAvatar
    local dontRelease

    -- If we already have a spirit out, just use that.
    if pet.isvalid and spirits:contains(pet.name) then
        siphonElement = pet.element
        dontRelease = true
        -- If current weather doesn't match the spirit, but the spirit matches the day, try to cast the storm.
        if player.sub_job == 'SCH' and pet.element == world.day_element and pet.element ~= world.weather_element then
            if not S { 'Light', 'Dark', 'Lightning' }:contains(pet.element) then
                stormElementToUse = pet.element
            end
        end
        -- If we're subbing /sch, there are some conditions where we want to make sure specific weather is up.
        -- If current (single) weather is opposed by the current day, we want to change the weather to match
        -- the current day, if possible.
    elseif player.sub_job == 'SCH' and world.weather_element ~= 'None' then
        -- We can override single-intensity weather; leave double weather alone, since even if
        -- it's partially countered by the day, it's not worth changing.
        if get_weather_intensity() == 1 then
            -- If current weather is weak to the current day, it cancels the benefits for
            -- siphon.  Change it to the day's weather if possible (+0 to +20%), or any non-weak
            -- weather if not.
            -- If the current weather matches the current avatar's element (being used to reduce
            -- perpetuation), don't change it; just accept the penalty on Siphon.
            if world.weather_element == elements.weak_to[world.day_element] and
                (not pet.isvalid or world.weather_element ~= pet.element) then
                -- We can't cast lightning/dark/light weather, so use a neutral element
                if S { 'Light', 'Dark', 'Lightning' }:contains(world.day_element) then
                    stormElementToUse = 'Wind'
                else
                    stormElementToUse = world.day_element
                end
            end
        end
    end

    -- If we decided to use a storm, set that as the spirit element to cast.
    if stormElementToUse then
        siphonElement = stormElementToUse
    elseif world.weather_element ~= 'None' and
        (get_weather_intensity() == 2 or world.weather_element ~= elements.weak_to[world.day_element]) then
        siphonElement = world.weather_element
    else
        siphonElement = world.day_element
    end

    local command = ''
    local releaseWait = 0

    if pet.isvalid and avatars:contains(pet.name) then
        command = command .. 'input /pet "Release" <me>;wait 1.1;'
        releasedAvatar = pet.name
        releaseWait = 10
    end

    if stormElementToUse then
        command = command .. 'input /ma "' .. elements.storm_of[stormElementToUse] .. '" <me>;wait 4;'
        releaseWait = releaseWait - 4
    end

    if not (pet.isvalid and spirits:contains(pet.name)) then
        command = command .. 'input /ma "' .. elements.spirit_of[siphonElement] .. '" <me>;wait 4;'
        releaseWait = releaseWait - 4
    end

    command = command .. 'input /ja "Elemental Siphon" <me>;'
    releaseWait = releaseWait - 1
    releaseWait = releaseWait + 0.1

    if not dontRelease then
        if releaseWait > 0 then
            command = command .. 'wait ' .. tostring(releaseWait) .. ';'
        else
            command = command .. 'wait 1.1;'
        end

        command = command .. 'input /pet "Release" <me>;'
    end

    if releasedAvatar then
        command = command .. 'wait 1.1;input /ma "' .. releasedAvatar .. '" <me>'
    end

    send_command(command)
end

-- Handles executing blood pacts in a generic, avatar-agnostic way.
-- cmdParams is the split of the self-command.
-- gs c [pact] [pacttype]
function handle_pacts(cmdParams)
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'You cannot use pacts in town.')
        return
    end

    if not pet.isvalid then
        add_to_chat(122, 'No avatar currently available. Returning to default macro set.')
        select_default_macro_book('reset')
        return
    end

    if spirits:contains(pet.name) then
        add_to_chat(122, 'Cannot use pacts with spirits.')
        return
    end

    if not cmdParams[2] then
        add_to_chat(123, 'No pact type given.')
        return
    end

    local pact = cmdParams[2]:lower()

    if not pacts[pact] then
        add_to_chat(123, 'Unknown pact type: ' .. tostring(pact))
        return
    end

    if pacts[pact][pet.name] then
        if pact == 'astralflow' and not buffactive['astral flow'] then
            add_to_chat(122, 'Cannot use Astral Flow pacts at this time.')
            return
        end

        -- Leave out target; let Shortcuts auto-determine it.
        send_command('@input /pet "' .. pacts[pact][pet.name] .. '"')
    else
        add_to_chat(122, pet.name .. ' does not have a pact of type [' .. pact .. '].')
    end
end

-- Event handler for updates to player skill, since we can't rely on skill being
-- correct at pet_aftercast for the creation of custom timers.
windower.raw_register_event('incoming chunk',
    function(id)
        if id == 0x62 then
            if wards.flag then
                create_pact_timer(wards.spell)
                wards.flag = false
                wards.spell = ''
            end
        end
    end)

-- Function to create custom timers using the Timers addon.  Calculates ward duration
-- based on player skill and base pact duration (defined in job_setup).
function create_pact_timer(spell_name)
    -- Create custom timers for ward pacts.
    if wards.durations[spell_name] then
        local ward_duration = wards.durations[spell_name]
        if ward_duration < 181 then
            local skill = player.skills.summoning_magic
            if skill > 300 then
                skill = skill - 300
                if skill > 200 then skill = 200 end
                ward_duration = ward_duration + skill
            end
        end

        local timer_cmd = 'timers c "' .. spell_name .. '" ' .. tostring(ward_duration) .. ' down'

        if wards.icons[spell_name] then
            timer_cmd = timer_cmd .. ' ' .. wards.icons[spell_name]
        end

        send_command(timer_cmd)
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book(reset)
    if reset == 'reset' then
        -- lost pet, or tried to use pact when pet is gone
        set_macro_page(macro_sets.default.page, macro_sets.default.book)
    else
        -- Default macro set/book
        if (pet.isvalid) then
            job_update()
        else
            set_macro_page(macro_sets.default.page, macro_sets.default.book)
        end

        send_command("@wait 5;input /lockstyleset 12")
    end
end
