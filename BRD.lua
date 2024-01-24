-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    ExtraSongsMode may take one of three values: None, Dummy, FullLength

    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy

    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.


    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>

    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.ExtraSongsMode = M { ['description'] = 'Extra Songs', 'None', 'Dummy' } --'FullLength' }
    state.LowSongsMode = M { ['description'] = 'Low Songs', 'None', 'Dummy' }

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
    include('Mote-TreasureHunter')

    -- For tracking current recast timers via the Timers plugin.
    custom_timers = {}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')
    include('helper_functions.lua')
    state.OffenseMode:options('Normal', 'Acc', 'Crit')
    state.HybridMode:options('Normal', 'PDT', 'SubtleBlow')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    state.LullabyMode = M { ['description'] = 'Lullaby Mode', 'Range', 'Potency' }
    state.EnmityMode = M { ['description'] = 'Enmity Mode', 'Normal', 'Enmity' }

    state.DisableState = M { ['description'] = 'Disable State', 'Disabled', 'Enabled' }

    -- AutoDummy will automatically cast songs in dummy mode if less than the maximum songs are counted
    -- state.AutoDummy = M { ['description'] = 'AutoDummy Mode', 'Disabled', 'Enabled' }
    state.AutoDummy = M { ['description'] = 'AutoDummy Mode', 'Enabled', 'Disabled' }
    -- AutoPianissimo will automatically use Pianissimo if you try to cast a song on someone else
    -- Strict will prevent the song from being cast unless you are targeting yourself OR pianissimo is active
    state.AutoPianissimo = M { ['description'] = 'AutoPianissimo Mode', 'Disabled', 'Enabled', 'Strict' }

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    -- information about your job points
    info.JobPoints = {}
    info.JobPoints.Marcato = 20
    info.JobPoints.Tenuto = 20
    info.JobPoints.DurationGift = true

    -- Adjust this if using the Terpander (new +song instrument)
    info.LowInstrument = "Horn +1"
    info.ExtraSongInstrument = 'Daurdabla'
    info.HonorMarch = 'Marsyas'
    info.AriaOfPassion = 'Loughnashade'

    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 2

    -- Set this to false if you don't want to use custom timers.
    state.UseCustomTimers = M(true, 'Use Custom Timers')

    info.DWsubs = S { 'NIN', 'DNC' }

    -- Additional local binds
    --send_command('bind ^` gs c cycle ExtraSongsMode')
    gear.left_idle_ear = { name = "Tuisto Earring" }
    gear.right_idle_ear = { name = "Odnowa Earring +1" }
    gear.left_idle_ring = gear.left_moonlight

    if is_healer_role() then
        gear.left_idle_ear = { name = "Etiolation Earring" }
        gear.right_idle_ear = { name = "Infused Earring" }
        gear.left_idle_ring = gear.left_stikini
    end

    send_command('bind numpad7 gs c equip Carnwenhan; gs c update')
    send_command('bind ^numpad7 gs c equip Dagger; gs c update')
    send_command('bind ^numpad8 gs c equip AccSword; gs c update')
    send_command('bind numpad8 gs c equip Sword; gs c update')
    send_command('bind !numpad8 gs c equip Critical; gs c update')
    send_command('bind numpad9 gs c equip Staff; gs c update')
    send_command('bind ^numpad9 gs c equip Club; gs c update')

    send_command('bind numpad1 input /ma "Horde Lullaby II" <t>')
    send_command('bind numpad2 input /ma "Foe Lullaby II" <t>')
    send_command('bind ^numpad1 gs c cycle LullabyMode')

    send_command('bind ^numpad2 gs c cycle AutoPianissimo')

    send_command('bind numpad3 input /ma "Carnage Elegy" <t>')
    send_command('bind ^numpad3 gs c cycle EnmityMode')

    send_command('bind numpad4 gs c cycle ExtraSongsMode')
    send_command('bind ^numpad4 gs c cycle AutoDummy')
    send_command('bind numpad5 gs c cycle LowSongsMode')

    send_command('bind ^numpad5 gs c cycle DisableState')

    send_command('bind ^` input /ja Pianissimo <me>')
    send_command('bind !` input /ja Pianissimo <me>')
    send_command('bind ^q input /ma "Chocobo Mazurka"')
    send_command('bind !- gs c cycle OffenseMode')

    send_command('bind ^- gs c cycle DoomMode')
    send_command('bind ^= gs c cycle treasuremode')

    gear.default.cure_waist = "Shinjutsu-no-obi +1"
    gear.default.obi_waist = "Eschan Stone"

    info.songs_casted = 0

    update_weapon_mode()

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    unbind_numpad()
    send_command('unbind ^`')
    send_command('unbind !`')

    send_command('unbind !`')
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind ^-')
end

function bind_weapons()
    if can_DW() then
        send_command('bind numpad7 gs equip sets.weapons.Carnwenhan.DW; gs c update')
        send_command('bind ^numpad7 gs equip sets.weapons.Dagger.DW; gs c update')
        send_command('bind ^numpad8 gs equip sets.weapons.AccSword.DW; gs c update')
        send_command('bind numpad8 gs equip sets.weapons.Sword.DW; gs c update')
        send_command('bind !numpad8 gs equip sets.weapons.Critical.DW; gs c update')
        send_command('bind numpad9 gs equip sets.weapons.Staff; gs c update')
        send_command('bind ^numpad9 gs equip sets.weapons.Club.DW; gs c update')
    else
        send_command('bind numpad7 gs equip sets.weapons.Carnwenhan; gs c update')
        send_command('bind ^numpad7 gs equip sets.weapons.Dagger; gs c update')
        send_command('bind ^numpad8 gs equip sets.weapons.AccSword; gs c update')
        send_command('bind numpad8 gs equip sets.weapons.Sword; gs c update')
        send_command('bind !numpad8 gs equip sets.weapons.Critical; gs c update')
        send_command('bind numpad9 gs equip sets.weapons.Staff; gs c update')
        send_command('bind ^numpad9 gs equip sets.weapons.Club; gs c update')
    end
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.weapons = {}
    sets.weapons['Sword'] = { main = "Naegling", sub = "Genmei Shield" }
    sets.weapons['Dagger'] = { main = "Aeneas", sub = "Genmei Shield" }
    sets.weapons['Tauret'] = { main = "Tauret", sub = "Genmei Shield" }
    sets.weapons['Carnwenhan'] = { main = "Carnwenhan", sub = "Genmei Shield" }
    sets.weapons['Critical'] = { main = "Gleti's Knife", sub = "Genmei Shield" }
    sets.weapons['Club'] = { main = "Daybreak", sub = "Genmei Shield" }
    sets.weapons['AccSword'] = { main = "Naegling", sub = "Genmei Shield" }
    sets.weapons['Sword'].DW = { main = "Naegling", sub = "Centovente" }
    sets.weapons['Dagger'].DW = { main = "Aeneas", sub = "Crepuscular Knife" }
    sets.weapons['Tauret'].DW = { main = "Tauret", sub = "Crepuscular Knife" }
    sets.weapons['Carnwenhan'].DW = { main = "Carnwenhan", sub = "Crepuscular Knife" }
    sets.weapons['Critical'].DW = { main = "Gleti's Knife", sub = "Crepuscular Knife" }
    sets.weapons['Club'].DW = { main = "Daybreak", sub = "Centovente" }
    sets.weapons['Staff'] = { main = "Xoanon", sub = "Bloodrain Strap" }
    sets.weapons['AccSword'].DW = { main = "Naegling", sub = "Crepuscular Knife" }

    -- Augmented Gear

    gear.IdleInstrument = { name = "Linos", augments = { 'DEF+15', '"Regen"+2', 'VIT+8', } }
    gear.MeleeInstrument = { name = "Linos", augments = { 'Accuracy+20', '"Store TP"+4', 'Quadruple Attack +3', } }
    gear.WSInstrument = { name = "Linos", augments = { 'Accuracy+15 Attack+15', 'Weapon skill damage +3%', 'STR+8' } }
    gear.MordantInstrument = { name = "Linos", augments = { 'Attack+19', 'Weapon skill damage +3%', 'STR+6 CHR+6', } }
    gear.FCInstrument = { name = "Linos", augments = { 'Mag. Acc.+15', '"Fast Cast"+5', 'INT+6 MND+6', } }
    gear.MaccInstrument = gear.FCInstrument
    gear.CritInstrument = {
        name = "Linos",
        augments = { 'Accuracy+14 Attack+14', 'Crit.hit rate+3',
            'Quadruple Attack +3', }
    }
    gear.MatkInstrument = { name = "Linos", augments = { '"Mag.Atk.Bns."+15', 'Weapon skill damage +2%', 'INT+8', } }

    gear.CastingCape = {
        name = "Intarabus's Cape",
        augments = { 'CHR+20', 'Mag. Acc.+10', '"Fast Cast"+10%', 'Mag. Acc.+20/Mag. Dmg.+20' }
    }
    gear.WSCape = {
        name = "Intarabus's Cape",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', }
    }
    gear.MeleeCape = {
        name = "Intarabus's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Store TP"+10', 'Phys. dmg. taken-10%', }
    }
    gear.DWCape = gear.MeleeCape


    gear.MordantCape = {
        name = "Intarabus's Cape",
        augments = { 'CHR+20', 'Accuracy+20 Attack+20', 'CHR+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%', }
    }

    gear.MatkCape = gear.WSCape

    gear.CritCape = {
        name = "Intarabus's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'DEX+10', 'Crit.hit rate+10%', 'Phys. dmg. taken-10%', }
    }



    sets.SIRD = {

        neck = "Loricate Torque +1", -- 5
        ear1 = "Magnetic Earring",   -- 8
        ear2 = "Halasz Earring",     -- 5
        body = "Rosette Jaseran +1", -- 25
        hands = "Chironic Gloves",   -- 15
        ring1 = "Evanescence Ring",  -- 5
        ring2 = gear.dark_ring.SIRD, -- 4
        waist = "Emphatikos Rope",   -- 12
        legs = "Bunzi's Pants"       -- 20
    }

    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    sets.enmity = {
        head = "Halitus Helm",       -- 8
        neck = "Unmoving Collar +1", -- 10
        ear1 = "Trux Earring",       -- 5
        ear2 = "Cryptic Earring",    -- 4
        body = "Emet Harness +1",    -- 10
        ring1 = "Supershear Ring",   -- 5
        ring2 = "Eihwaz Ring",       -- 5
        waist = "Trance Belt",       -- 4
        legs = "Zoar Subligar +1"    -- 6
    }

    sets.StoreTP = {
        range = gear.MeleeInstrument,
        neck = "Bard's Charm +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Ashera Harness",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Kentarch Belt +1",
    }

    sets.Empyrean = {
        head = "Fili Calot +2",
        body = "Fili Hongreline +3",
        hands = "Fili Manchettes +2",
        legs = "Fili Rhingrave +2",
        feet = "Fili Cothurnes +2"
    }

    sets.resist = {}
    sets.resist.death = {
        main = "Odium",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    sets.buff.doom = set_combine(sets.defense.PDT, {
        neck = "Nicander's Necklace",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash"
    })

    sets.buff.doom.HolyWater = set_combine(sets.buff.doom, {
        neck = "Nicander's Necklace",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1"
    })

    sets.ConserveMP = {
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

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        head = "Befouled Crown",
        neck = "Bathy Choker +1",
        body = "Gendewitha Bliaut +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        legs = "Assiduity Pants +1"
    }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        range = gear.IdleInstrument,
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Brachyura Earring",
        ear2 = "Infused Earring",
        -- ear1 = gear.left_idle_ear,
        -- ear2 = gear.right_idle_ear,
        body = "Fili Hongreline +3",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.MeleeCape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Fili Cothurnes +2"
    }

    sets.idle.PDT = {
        range = gear.IdleInstrument,
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring2 = gear.right_moonlight,
        ring1 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Fili Cothurnes +2"
    }

    sets.idle.Evasion = {
        range = gear.IdleInstrument,
        head = "Nyame Helm",
        neck = "Bathy Choker +1",
        ear2 = "Eabani Earring",
        ear1 = "Infused Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        -- back="",
        waist = "Svelt. Gouriz +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- sets.idle.Town = { range = gear.IdleInstrument,
    sets.idle.Town = {
        range = gear.IdleInstrument,
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = "Moonlight Cape",
        waist = "Blacksmith's Belt",
        legs = "Nyame Flanchard",
        feet = "Fili Cothurnes +2"
    }

    -- sets.idle.Weak = sets.idle.PDT

    sets.idle.Refresh = {
        sub = "Ammurapi Shield",
        range = gear.IdleInstrument,
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        body = "Kaykaus Bliaut +1",
        hands = gear.chironic.refresh.hands,
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Moonlight Cape",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = gear.chironic.refresh.feet
    }

    sets.idle.Regen = set_combine(sets.idle.PDT, {
        neck = "Bathy Choker +1", ear2 = "Infused Earring", ring1 = gear.left_chirich, ring2 = "Paguroidea Ring",

    })

    -- Defense sets

    sets.defense.PDT = {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Archon Ring",
        ring2 = "Shadow Ring",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.Kiting = { feet = "Fili Cothurnes +2" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {
        range = gear.FCInstrument,  -- 5
        head = "Bunzi's Hat",       -- 10
        neck = "Orunmila's Torque", -- 5
        -- ear1 = "Enchanter's Earring +1", -- 2
        -- ear2 = "Loquac. Earring",        -- 2
        body = "Inyanga Jubbah +2",     -- 14
        hands = "Leyline Gloves",       -- 8
        ring1 = "Weatherspoon Ring +1", -- 6
        ring2 = "Lebeche Ring",
        -- ring2 = "Medada's Ring",         -- 10
        back = "Fi Follet Cape +1", -- 10
        waist = "Embla Sash",       -- 5
        legs = "Kaykaus Tights +1", -- 7
        feet = "Fili Cothurnes +2"  -- 10
    }

    sets.precast.FC.BardSong = {
        range = gear.FCInstrument,  -- 5
        head = "Fili Calot +2",     -- 15
        neck = "Orunmila's Torque", -- 5
        -- ear1 = "Enchanter's Earring +1", -- 2
        -- ear2 = "Loquac. Earring", -- 2
        body = { name = "Brioso Justaucorps +3", priority = 9 }, -- 15
        hands = "Leyline Gloves",                                -- 8
        ring1 = "Weatherspoon Ring +1",                          -- 6
        ring2 = "Medada's Ring",                                 -- 10
        back = { name = "Moonlight Cape", priority = 10 },       -- 0
        waist = { name = "Platinum Moogle Belt", priority = 8 }, -- 0
        legs = "Kaykaus Tights +1",                              -- 7
        feet = "Fili Cothurnes +2"                               -- 10
    }

    sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, { range = info.ExtraSongInstrument })

    sets.precast['Honor March'] = set_combine(sets.precast.FC.BardSong,
        { range = info.HonorMarch, back = "Fi Follet Cape +1" })
    sets.precast.FC['Honor March'] = sets.precast['Honor March']

    sets.precast['Aria of Passion'] = set_combine(sets.precast.FC.BardSong,
        { range = info.AriaOfPassion, back = "Fi Follet Cape +1" })
    sets.precast.FC['Aria of Passion'] = sets.precast['Aria of Passion']


    -- Precast sets to enhance JAs

    sets.precast.JA.Nightingale = { feet = "Bihu Slippers +1" }
    sets.precast.JA.Troubadour = { body = "Bihu Justaucorps +3" }
    sets.precast.JA['Soul Voice'] = { legs = "Bihu Cannions +2" }
    sets.precast.JA['Con Brio'] = { hands = "Bihu Cuffs +2" }
    sets.precast.JA['Con Anima'] = { head = "Bihu Roundlet +2" }

    sets.precast.JA['Military Parade'] = { body = "Bihu Justaucorps +3" }
    sets.precast.JA['Courtly Measure'] = { legs = "Bihu Cannions +2" }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        range = "Gjallarhorn",
        head = "Brioso Roundlet +3",
        neck = "Moonbow Whistle +1",
        ear1 = "Regal Earring",
        ear2 = "Handler's Earring +1",
        body = "Brioso Justaucorps +3",
        hands = "Brioso Cuffs +3",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Metamorph Ring +1",
        back = gear.CastingCape,
        legs = "Brioso Cannions +2",
        feet = "Brioso Slippers +3"
    }


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        range = gear.WSInstrument,
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Ishvara Earring",
        ear2 = "Moonshade Earring",
        body = "Bihu Justaucorps +3",
        hands = "Nyame Gauntlets",
        ring1 = "Shukuyu Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.WSCape,
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        range = gear.CritInstrument,
        head = "Blistering Sallet +1",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        ring1 = "Hetairoi Ring",
        ring2 = "Begrudging Ring",
        back = gear.CritCape,
        legs = "Zoar Subligar +1",
        feet = "Ayanmo Gambieras +2"
    })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        neck = "Bard's Charm +2", ring1 = "Ilabrat Ring", waist = "Kentarch Belt +1"
    })
    sets.precast.WS['Rudra\'s Storm'].FullTP = { ear2 = "Brutal Earring" }

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS,
        { range = gear.MeleeInstrument, ring2 = "Ilabrat Ring" })

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS, {
        range = gear.MordantInstrument,
        neck = "Bard's Charm +2",
        ear2 = "Regal Earring",
        ring1 = "Metamorph Ring +1",
        back = gear.MordantCape
    })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        range = gear.MatkInstrument,
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Moonshade Earring",
        ring1 = "Medada's Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.MatkCape,
        waist = gear.ElementalObi
    })
    sets.precast.WS['Aeolian Edge'].FullTP = { ear2 = "Friomisi Earring" }
    sets.precast.WS['Cyclone'] = sets.precast.WS['Aeolian Edge']
    sets.precast.WS['Gust Slash'] = sets.precast.WS['Aeolian Edge']
    sets.precast.WS['Burning Blade'] = sets.precast.WS['Aeolian Edge']
    sets.precast.WS['Shining Blade'] = sets.precast.WS['Aeolian Edge']

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
        {
            neck = "Bard's Charm +2",
            waist = "Kentarch belt +1",
        })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        neck = "Bard's Charm +2",
        ear1 = "Moonshade Earring",
        ear2 = "Telos Earring",
        hands = "Gazu Bracelets +1",
        waist = "Kentarch Belt +1",
    })
    sets.precast.WS['Savage Blade'].FullTP = { ear1 = "Ishvara Earring", ear2 = "Telos Earring" }

    sets.precast.WS['Shattersoul'] = set_combine(sets.precast.WS, {
        ear1 = "Regal Earring",
        ear2 = "Brutal Earring",
        ring1 = "Metamorph Ring +1",
        ring2 = "Shukuyu Ring",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
    })

    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
        range = gear.MatkInstrument,
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Moonshade Earring",
        ring1 = "Medada's Ring",
        ring2 = "Archon Ring",
        back = gear.MatkCape,
        waist = gear.ElementalObi
    })

    sets.precast.WS['Retribution'] = set_combine(sets.precast.WS, {
        range = gear.WSInstrument,
        neck = "Republican Platinum medal",
        waist = "Sailfi Belt +1",
        ring1 = "Metamorph Ring +1",
        back = gear.WSCape
    })
    sets.precast.WS['Shell Crusher'] = set_combine(sets.precast.WS, {
        range = gear.WSInstrument,
        neck = "Republican Platinum medal",
        waist = "Sailfi Belt +1",
        ring1 = "Shukuyu Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.WSCape
    })


    -- Midcast Sets

    -- General set for recast times.
    sets.midcast.FastRecast = set_combine(sets.precast.FC, {
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2",
        hands = "Gazu Bracelets +1",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Medada's Ring",
        back = gear.CastingCape,
        waist = "Sailfi Belt +1",
    })

    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, sets.SIRD)

    -- Gear to enhance certain classes of songs.  No instruments added here since Gjallarhorn is being used.
    sets.midcast.Ballad = { legs = "Fili Rhingrave +2" }
    sets.midcast.Lullaby = { hands = "Brioso Cuffs +3" }
    sets.midcast.Madrigal = { head = "Fili Calot +2", back = "Intarabus's Cape" }
    sets.midcast.Prelude = { back = "Intarabus's Cape" }
    sets.midcast.March = { hands = "Fili Manchettes +2" }
    sets.midcast.Minuet = { body = "Fili Hongreline +3" }
    sets.midcast.Minne = {}
    sets.midcast.Paeon = { head = "Brioso Roundlet +3" }
    sets.midcast.Carol = {
        head = "Fili Calot +2",
        body = "Fili Hongreline +3",
        hands = "Fili Manchettes +2",
        legs = "Fili Rhingrave +2",
        feet = "Fili Cothurnes +2"
    }
    sets.midcast["Sentinel's Scherzo"] = { feet = "Fili Cothurnes +2" }
    sets.midcast['Magic Finale'] = { legs = "Fili Rhingrave +2" }
    sets.midcast['Honor March'] = set_combine(sets.midcast.SongEffect, { range = info.HonorMarch })
    sets.midcast['Aria of Passion'] = set_combine(sets.midcast.SongEffect, { range = info.AriaOfPassion })

    sets.midcast['Horde Lullaby'] = set_combine(sets.midcast.Lullaby, { range = "Daurdabla" })
    sets.midcast['Horde Lullaby II'] = sets.midcast['Horde Lullaby']

    sets.midcast.Mazurka = { range = info.ExtraSongInstrument }


    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEffect = {
        main = "Carnwenhan",
        range = "Gjallarhorn",
        head = "Fili Calot +2",
        neck = "Moonbow whistle +1",
        ear1 = { name = "Etiolation Earring", priority = 8 },
        ear2 = { name = "Eabani Earring", priority = 7 },
        body = "Fili Hongreline +3",
        hands = "Fili Manchettes +2",
        ring1 = gear.left_moonlight,
        ring2 = { name = "Gelatinous Ring +1", priority = 10 },
        waist = { name = "Platinum Moogle Belt", priority = 6 },
        back = gear.CastingCape,
        legs = "Inyanga Shalwar +2",
        feet = "Brioso Slippers +3"
    }




    -- For song debuffs (duration primary, accuracy secondary)
    sets.midcast.SongDebuff = {
        weapon = {
            main = "Carnwenhan",
            sub = "Ammurapi Shield",
        },
        range = "Gjallarhorn",
        head = "Brioso Roundlet +3",
        neck = "Moonbow Whistle +1",
        ear1 = "Regal Earring",
        ear2 = "Crepuscular Earring",
        body = "Fili Hongreline +3",
        hands = "Brioso Cuffs +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = gear.CastingCape,
        waist = "Acuity Belt +1",
        legs = "Inyanga Shalwar +2",
        feet = "Brioso Slippers +3"
    }
    -- when dual wielding
    sets.midcast.SongDebuffDW = set_combine(sets.midcast.SongDebuff, {})
    sets.midcast.OnTPLoss = { sub = "Ammurapi Shield" }

    -- For song debuffs (accuracy primary, duration secondary)
    sets.midcast.ResistantSongDebuff = {
        main = "Carnwenhan",
        sub = "Ammurapi Shield",
        range = "Gjallarhorn",
        head = "Brioso Roundlet +3",
        neck = "Moonbow Whistle +1",
        ear1 = "Regal Earring",
        ear2 = "Crepuscular Earring",
        body = "Brioso Justaucorps +3",
        hands = "Brioso Cuffs +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = gear.CastingCape,
        waist = "Acuity Belt +1",
        legs = "Brioso Cannions +2",
        feet = "Brioso Slippers +3"
    }

    -- Song-specific recast reduction
    sets.midcast.SongRecast = {
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Kishar Ring",
        waist = "Embla Sash",
        feet = "Fili Cothurnes +2"
    }

    sets.midcast.Daurdabla = set_combine(sets.midcast.FastRecast, sets.midcast.SongRecast,
        { range = info.ExtraSongInstrument })

    -- Cast spell with normal gear, except using Daurdabla instead
    sets.midcast.Daurdabla = { range = info.ExtraSongInstrument }

    sets.Lullaby = {}
    sets.Lullaby.potency = { range = "Gjallarhorn" }
    sets.Lullaby.range = { range = gear.ExtraSongInstrument }

    -- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
    sets.midcast.DaurdablaDummy = {
        range = info.ExtraSongInstrument,
        head = "Bunzi's Hat",
        neck = "Orunmila's Torque",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Inyanga Jubbah +2",
        hands = "Leyline Gloves",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Medada's Ring",
        back = { name = "Moonlight Cape", priority = 10 },
        waist = "Embla Sash",
        legs = "Kaykaus Tights +1",
        feet = "Fili Cothurnes +2"
    }

    sets.midcast.LowSongs = set_combine(
        sets.midcast.DaurdablaDummy,
        sets.weapons.Staff,
        { range = info.LowInstrument }
    )

    -- Other general spells and classes.
    sets.midcast['Healing Magic'] = {
        head = "Kaykaus Mitra +1",
        neck = "Incanter's Torque",
        ear1 = "Beatific Earring",
        ear2 = "Meili Earring",
        hands = "Inyanga Dastanas +2",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Oretania's Cape +1",
        waist = "Bishop's Sash",
    }

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        head = "Kaykaus Mitra +1",
        neck = { name = "Unmoving Collar +1", priority = 9 },
        ear1 = "Regal Earring",
        ear2 = "Magnetic Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = { name = "Moonlight Cape", priority = 10 },
        waist = gear.CureWaist,
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus Boots +1"
    })

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        back = "Oretania's Cape +1",
        feet = "Gendewitha Galoshes +1"
    })

    sets.midcast.Raise = sets.ConserveMP

    sets.midcast['Enhancing Magic'] = {
        main = "Pukulatmuj +1",
        sub = "Ammurapi Shield",
        head = "Umuthi Hat",
        neck = "Incanter's Torque",
        ear1 = "Mimir Earring",
        ear2 = "Andoaa Earring",
        body = "Anhur Robe",
        hands = "Inyanga Dastanas +2",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = "Shedir Seraweels",
        feet = gear.EnhancingFeet
    }

    sets.midcast.Regen = gear.telchine.regen

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], { legs = 'Shedir Seraweels' })
    sets.midcast.BarStatus = sets.midcast.BarElement

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], sets.midcast["Enhancing Magic"].Duration, {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], sets.midcast["Enhancing Magic"].Duration,
        { waist = "Emphatikos Rope" })

    sets.midcast['Enhancing Magic'].Duration = gear.telchine.enh_dur

    sets.midcast['Enfeebling Magic'] = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        range = gear.MaccInstrument,
        head = "Brioso Roundlet +3",
        neck = "Moonbow Whistle +1",
        ear1 = "Regal Earring",
        ear2 = "Crepuscular Earring",
        body = "Brioso Justaucorps +3",
        hands = "Brioso Cuffs +3",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Brioso Cannions +2",
        feet = "Brioso Slippers +3"
    }

    sets.midcast.Banish = set_combine(sets.midcast['Enfeebling Magic'], {
        head = "Ipoca Beret",
        neck = "Jokushu Chain",
        back = "Disperser's Cape"
    })

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    -- sets.weapons = { main = gear.MainHand, sub = gear.SubHand }

    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
        range = gear.MeleeInstrument,
        head = "Bunzi's Hat",
        neck = "Bard's Charm +2",
        ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Ashera Harness",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.MeleeCape,
        waist = "Windbuffet Belt +1",
        legs = "Volte Tights",
        feet = "Nyame Sollerets"
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        hands = "Gazu Bracelets +1",
    })

    sets.engaged.PDT = set_combine(sets.engaged,
        {
            head = "Nyame Helm",
            neck = "Loricate Torque +1",
            ear1 = "Tuisto Earring",
            ear2 = "Odnowa Earring +1",
            legs = "Volte Tights",
            body = "Nyame Mail",
        })

    sets.engaged.Crit = set_combine(sets.engaged, {
        range = gear.CritInstrument,
        head = "Blistering Sallet +1",
        legs = "Zoar Subligar +1",
        feet = "Ayanmo Gambieras +2",
        back = gear.CritCape
    })

    sets.engaged.Acc.PDT = set_combine(sets.engaged.PDT, { hands = "Gazu Bracelets +1" })

    sets.engaged.SubtleBlow = set_combine(sets.engaged, {
        neck = "Bathy Choker +1", ring2 = gear.right_chirich,
    })

    sets.engaged.Xoanon = {
        range = gear.MeleeInstrument,
        head = "Bunzi's Hat",
        neck = "Bard's Charm +2",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Ashera Harness",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.MeleeCape,
        waist = "Sailfi Belt +1",
        legs = "Volte Tights",
        feet = "Nyame Sollerets"
    }

    sets.engaged.Xoanon.Acc = set_combine(sets.engaged, {
        hands = "Gazu Bracelets +1",
    })

    sets.engaged.Xoanon.PDT = set_combine(sets.engaged,
        {
            head = "Nyame Helm",
            neck = "Loricate Torque +1",
            ear1 = "Tuisto Earring",
            ear2 = "Odnowa Earring +1",
            body = "Nyame Mail",
        })

    sets.engaged.Xoanon.Crit = set_combine(sets.engaged, {
        range = gear.CritInstrument,
        head = "Blistering Sallet +1",
        legs = "Zoar Subligar +1",
        feet = "Ayanmo Gambieras +2",
        back = gear.CritCape
    })

    sets.engaged.Xoanon.Acc.PDT = set_combine(sets.engaged.PDT, { hands = "Gazu Bracelets +1" })

    sets.engaged.Xoanon.SubtleBlow = set_combine(sets.engaged, {
        neck = "Bathy Choker +1", ring2 = gear.right_chirich,
    })

    -- Set if dual-wielding
    sets.engaged.DW = {
        range = gear.MeleeInstrument,
        head = "Bunzi's Hat",
        neck = "Bard's Charm +2",
        ear1 = "Telos Earring",
        -- ear2 = "Eabani Earring",
        ear2 = "Suppanomimi",
        body = "Ashera Harness",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.MeleeCape,
        waist = "Reiki Yotai",
        legs = "Volte Tights",
        feet = "Nyame Sollerets"
    }

    sets.engaged.DW.Acc = set_combine(sets.engaged.DW, {
        hands = "Gazu Bracelets +1"
    })

    sets.engaged.DW.Crit = set_combine(sets.engaged.DW, {
        range = gear.CritInstrument,
        head = "Blistering Sallet +1",
        legs = "Zoar Subligar +1",
        feet = "Ayanmo Gambieras +2",
        back = gear.CritCape
    })

    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        ring2 = gear.right_moonlight,
    })

    sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.PDT, { hands = "Gazu Bracelets +1" })

    sets.engaged.DW.SubtleBlow = set_combine(sets.engaged, {
        neck = "Bathy Choker +1", ring2 = gear.right_chirich
    })
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    if spell.type == 'WeaponSkill' then
        local main = player.equipment.main
        cancel_spell()
        if main == 'Naegling' then
            if spell.english == 'Mordant Rime' then
                send_command('input /ws "Savage Blade" ' .. spell.target.raw)
            end
        elseif main == 'Xoanon' then
            if spell.english == "Mordant Rime" then
                send_command('input /ws "Retribution" ' .. spell.target.raw)
            elseif spell.english == "Evisceration" then
                send_command('input /ws "Shattersoul" ' .. spell.target.raw)
            elseif spell.english == "Rudra's Storm" then
                send_command('input /ws "Shell Crusher" ' .. spell.target.raw)
            elseif spell.english == 'Exenterator' then
                send_command('input /ws "Cataclysm" ' .. spell.target.raw)
            end
        end
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    -- deleteme later
    if state.DisableState.value == 'Enabled'
        and (S { "SongDebuff", "SongDebuffDW" }:contains(get_song_class(spell)) or spell.english == 'Mordant Rime')
        and (buffactive['Nightingale'] and buffactive['Troubadour'])
        and info.songs_casted < 4 then
        eventArgs.cancel = true
        windower.add_to_chat(144, 'Not enough songs casted: songs_casted: ' .. info.songs_casted)
        return
    end

    if spell.type == 'BardSong' then
        if spell.english == 'Honor March' or spell.english == 'Aria of Passion' or spell.english == 'Marcato' then
            state.ExtraSongsMode:reset()
        elseif spell.english == 'Foe Lullaby II' or spell.english == 'Horde Lullaby II' then
            local recasts = windower.ffxi.get_spell_recasts()
            if recasts and recasts[spell.id] > 0 then
                eventArgs.cancel = true

                local spell_base = ""
                for v in spell.english:gmatch("[^%s]+") do
                    spell_base = v
                    break
                end
                send_command("input /song \"" .. spell_base .. " Lullaby\" " .. spell.target.raw)
            end
        elseif spell.english:startswith('Mages')
            and spell.target.type == 'SELF'
            and buffactive['Pianissimo']
            and (S { 'NIN', 'DNC', 'WAR', 'SAM' }:contains(player.sub_job) or player.sub_job_level < 10) then
            eventArgs.cancel = true
            send_command('input /ma ' .. spell.english .. ' <stpt>')
        end

        if state.AutoPianissimo.value == 'Enabled'
            and S { 'SongEffect', 'DaurdablaDummy' }:contains(get_song_class(spell))
            and player.target.in_party
            and player.target.type ~= 'SELF'
            and (not player.target.charmed or player.target.type == 'NPC')
            and not buffactive['Pianissimo']
        then
            eventArgs.cancel = true
            send_command('input /ja "Pianissimo" <me>')
            -- disallow casting of songs when not targeting self in strict pianissmo mode
        elseif state.AutoPianissimo.value == 'Strict'
            and S { 'SongEffect', 'DaurdablaDummy' }:contains(get_song_class(spell))
            and player.target.in_party
            and player.target.type ~= 'SELF'
            and (not player.target.charmed or player.target.type == 'NPC')
            and not buffactive['Pianissimo']
        then
            eventArgs.cancel = true
            windower.add_to_chat(36, 'Error: Not targeting self and in strict pianissimo mode')
        end
    end

    -- local recasts = windower.ffxi.get_ability_recasts()
    -- print(recasts[spell.recast_id])
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
-- function job_precast(spell, action, spellMap, eventArgs)
-- check_engaged()
-- if spell.type == 'BardSong' then
-- Auto-Pianissimo
--[[if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then

            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end]]
-- end
-- end


function job_precast(spell, action, spellMap, eventArgs)
    if spell.type ~= 'WeaponSkill' then
        set_recast('range')
    end

    if spell.type == 'BardSong' and state.ExtraSongsMode.value == "Dummy" then
        windower.add_to_chat(144, "INFO: Dummy songs mode enabled")
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill'
        and sets.precast.WS[spell.english]
        and sets.precast.WS[spell.english].FullTP
        and player.tp == 3000 then
        equip(sets.precast.WS[spell.english].FullTP)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    -- if spell.action_type == 'Magic' then
    if spell.type == 'BardSong' then
        -- layer general gear on first, then let default handler add song-specific gear.
        local generalClass = get_song_class(spell)
        if generalClass and sets.midcast[generalClass] then
            equip(sets.midcast[generalClass])
            -- equip tploss weapons if the main is going to change
            -- if player.equipment.main ~= "Carnwenhan" then
            --     equip(sets.midcast.OnTPLoss)
            -- end
        end
    elseif spell.skill == 'Enhancing Magic' then
        if spellMap == 'BarElement' then
            equip(sets.midcast.BarElement)
        elseif spellMap == 'BarStatus' then
            equip(sets.midcast.BarStatus)
        elseif S { 'Haste', 'Refresh' }:contains(spell.english) then
            equip(sets.midcast['Enhancing Magic'].Duration)
        elseif spell.english:startswith("Regen") then
            equip(sets.midcast.Regen)
        end
    end

    -- end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if spell.english == 'Honor March' then
            equip(sets.midcast['Honor March'])
        else
            if state.ExtraSongsMode.value == 'FullLength' then
                equip(sets.midcast.Daurdabla)
            end
            if spell.english:startswith('Horde Lullaby') then
                if state.LullabyMode.value == 'Range' then
                    equip(sets.Lullaby.range)
                elseif state.LullabyMode.value == 'Potency' then
                    equip(sets.Lullaby.potency)
                end

                if state.TreasureMode.value == "Tag" then
                    equip(sets.TreasureHunter)
                end
            end

            -- if state.EnmityMode.value == 'Enmity' and get_song_class(spell):contains('Debuff') then
            if state.EnmityMode.value == 'Enmity' and S { 'Carnage Elegy', 'Horde Lullaby', 'Horde Lullaby II' }:contains(spell.english) then
                equip(sets.enmity)
            end
            -- if spell.english == 'Horde Lullaby' and state.TreasureMode.value == "Tag" then
            --     equip(sets.TreasureHunter)
            -- end
        end

        -- autodummy
        if state.AutoDummy.value == 'Enabled'
            and get_song_class(spell) == 'SongEffect'
            and not S { 'Honor March', 'Aria of Passion' }:contains(spell.english)
            and not buffactive['Pianissimo'] then
            local casted_songs = get_buff_song_count()
            local total_songs = 4
            local base_songs = 2

            if buffactive['Clarion Call'] then
                total_songs = 5
                base_songs = 3
            end

            if casted_songs >= base_songs and casted_songs < total_songs then
                equip(sets.midcast.DaurdablaDummy)
            end
        end

        -- state.ExtraSongsMode:reset()
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
    end
    -- check_engaged()
    eventArgs.handled = false
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- if we changed weapons, change back.
    equip_recast()
    --[[if state.OffenseMode.value == 'Magic' then
        equip(sets.idle.Weap+
        on)
    end]]
    if buffactive.doom then
        eventArgs.handled = true
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end

    -- deleteme
    if state.DisableState.value == 'Enabled'
        and spell.type == 'BardSong'
        and S { 'Honor March', 'Victory March', 'Advancing March', 'Valor Minuet IV', 'Valor Minuet V' }:contains(spell.english)
        and (buffactive['Nightingale'] and buffactive['Troubadour'])
        and not spell.interrupted
    then
        info.songs_casted = info.songs_casted + 1
        windower.add_to_chat(144,
            'Songs casted: ' .. info.songs_casted .. ' Spell: ' .. spell.type .. ' ' .. spell.english)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
    -- when gaining a buff
    if gain then
        if buff == 'sleep' and player.hp > 50 then
            if not buffactive['charm'] then
                equip(sets.Sleeping)
            end
        elseif buff == 'doom' then
            if state.DoomMode.value == 'Cursna' then
                equip(sets.buff.doom)
            elseif state.DoomMode.value == 'Holy Water' then
                equip(sets.buff.doom.HolyWater)
            end
        elseif buff == 'charm' then
            if has_poison_debuff(buffactive) then
                send_command('input /p Charmed and I cannot be slept.')
            else
                send_command('input /p Charmed.')
            end
        elseif S { 'Aftermath', 'Aftermath: Lv.1', 'Aftermath: Lv.2', 'Aftermath: Lv.3' }:contains(buff) then
            -- update_combat_form()
        elseif buff == 'Soul Voice' then
            info.songs_casted = 0
        elseif buff == 'Level Restriction' then
            bind_weapons()
        end

        -- when losing a buff
    else
        if buff == 'doom' then
            send_command('input /p Doom off.')
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off.')
        elseif buff == 'sleep' then
            send_command('gs c update')
        elseif S { 'Aftermath' }:contains(buff) then
            info.AM.level = 0
            update_combat_form()
            send_command('gs c update')
        elseif buff == 'Nightingale' or buff == 'Troubadour' then
            info.songs_casted = 0
        elseif buff == 'Level Restriction' then
            bind_weapons()
        end
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Weapon Mode' then
        -- update_weapon_mode()
        job_update()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function check_engaged()
    -- if state.OffenseMode.value == 'SaveTP' then
    --     if player.status == 'Engaged' then
    --         disable('main','sub')
    --     else
    --         enable('main','sub')
    --     end
    -- else
    --     enable('main', 'sub')
    -- end
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_weapon_mode()
    -- update_idle_gear()



    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 and is_healer_role() then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

function update_idle_gear()
    if is_healer_role() then
        gear.left_idle_ear = { name = "Etiolation Earring", priority = 9 }
        gear.right_idle_ear = { name = "Infused Earring", priority = 8 }
        gear.left_idle_ring = gear.left_stikini
    else
        gear.left_idle_ear = { name = "Tuisto Earring", priority = 9 }
        gear.right_idle_ear = { name = "Odnowa Earring +1", priority = 8 }
        gear.left_idle_ring = gear.left_moonlight
    end
end

function is_healer_role()
    return S { 'WHM', 'RDM', 'SCH' }:contains(player.sub_job) and player.sub_job_level > 0
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function get_buff_song_count()
    return (buffactive['March'] or 0)
        + (buffactive['Minuet'] or 0)
        + (buffactive['Minne'] or 0)
        + (buffactive['Ballad'] or 0)
        + (buffactive['Madrigal'] or 0)
        + (buffactive['Prelude'] or 0)
        + (buffactive['Paeon'] or 0)
        + (buffactive['Etude'] or 0)
        + (buffactive['Carol'] or 0)
        + (buffactive['Sirvente'] or 0)
        + (buffactive['Dirge'] or 0)
        + (buffactive['Scherzo'] or 0)
        + (buffactive['Mambo'] or 0)
        + (buffactive['Aubade'] or 0)
        + (buffactive['Pastoral'] or 0)
        + (buffactive['Hum'] or 0)
        + (buffactive['Fantasia'] or 0)
        + (buffactive['Operetta'] or 0)
        + (buffactive['Capriccio'] or 0)
        + (buffactive['Serenade'] or 0)
        + (buffactive['Round'] or 0)
        + (buffactive['Gavotte'] or 0)
        + (buffactive['Fugue'] or 0)
        + (buffactive['Rhapsody'] or 0)
        + (buffactive['Aria'] or 0)
        + (buffactive['Hymnus'] or 0)
    -- + (buffactive['Mazurka'] or 0) -- do not count mazurka as it falls off too easily and can cause discrepancy
end

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            if can_DW() then
                return 'SongDebuffDW'
            else
                return 'SongDebuff'
            end
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        -- print(get_buff_song_count())
        if get_buff_song_count() >= 2 then
            return 'DaurdablaDummy'
        else
            return 'SongEffect'
        end
    elseif state.LowSongsMode.value == 'Dummy' then
        return 'LowSongs'
    else
        return 'SongEffect'
    end
end

-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end

    local current_time = os.time()

    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.

    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name, expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name, expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end

    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).

        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "' .. spell.name .. '"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end

        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
        else
            local rep, repsong
            for song_name, expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "' .. repsong .. '"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    local amt_added = 0

    if player.equipment.range == "Miracle Cheer" then
        if S { 'Ballad', 'Paeon', 'Madrigal', 'Ballad', 'Minuet', 'Minne', 'March', 'Scherzo', 'Mazurka' }:contains(spellMap) then
            return math.floor(15 * 60)
        else
            mult = mult + 0.3
        end
    end

    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end       -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end     -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Marsyas" then mult = mult + 0.5 end         -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Blurred Harp" then mult = mult + 0.1 end    -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Blurred Harp +1" then mult = mult + 0.2 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Homestead Flute" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall

    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end       -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.main == "Carnwenhan" then mult = mult + 0.05 end
    if player.equipment.sub == "Carnwenhan" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.neck == "Moonbow Whistle" then mult = mult + 0.2 end
    if player.equipment.neck == "Moonbow Whistle +1" then mult = mult + 0.3 end
    if player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if player.equipment.body == "Fili Hongreline" then mult = mult + 0.11 end
    if player.equipment.body == "Fili Hongreline +3" then mult = mult + 0.12 end
    if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
    if player.equipment.legs == "Inyanga Shalwar" then mult = mult + 0.12 end
    if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
    if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.13 end
    if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end

    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +2" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +3" then mult = mult + 0.2 end
    if spellMap == 'Madrigal' and player.equipment.head == "Fili Calot" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Fili Calot +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Fili Hongreline" then mult = mult + 0.11 end
    if spellMap == 'Minuet' and player.equipment.body == "Fili Hongreline +3" then mult = mult + 0.12 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Fili Manchettes +2' then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Fili Manchettes +2 +1' then mult = mult + 0.1 end
    if spellMap == 'Lullaby' and player.equipment.range == "Blurred Harp" then mult = mult + 0.2 end
    if spellMap == 'Ballad' and player.equipment.range == "Blurred Harp +1" then mult = mult + 0.2 end
    if spellMap == 'Ballad' and player.equipment.legs == "Fili Rhingrave +2" then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Fili Rhingrave +2 +1" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Fili Cothurnes" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Fili Cothurnes +2" then mult = mult + 0.1 end

    if buffactive.Troubadour then
        mult = mult * 2
    end
    if S { "Sentinel's Scherzo", "Goddess's Hymnus", "Raptor Mazurka", "Chocobo Mazurka" }:contains(spellName) then
        if buffactive['Soul Voice'] then
            mult = mult * 2
        elseif buffactive['Marcato'] then
            mult = mult * 1.5
        end
    end

    if info.JobPoints.DurationGift then mult = mult + 0.05 end

    if buffactive.Marcato and not buffactive["Soul Voice"] then
        amt_added = amt_added + info.JobPoints.Marcato * 1
    end

    if buffactive.Tenuto and not buffactive.pianissimo then
        amt_added = amt_added + info.JobPoints.Tenuto * 2
    end

    local totalDuration = math.floor(mult * (120 + amt_added))

    return totalDuration
end

function update_weapon_mode(w_state)
    if player.equipment.main == 'Xoanon' then
        state.CombatForm:reset()
        state.CombatWeapon:set('Xoanon')
    elseif check_DW() then
        state.CombatWeapon:reset()
        state.CombatForm:set('DW')
    else
        state.CombatWeapon:reset()
        state.CombatForm:reset()
    end
    -- overwrite weapons and equip
    update_sets()
    --equip(sets.weapons)
end

function update_sets()

end

function check_DW()
    return T(windower.ffxi.get_abilities().job_traits):contains(18)
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
        job_custom_weapon_equip(arg)
    end
end

-- Function to reset timers.
function reset_timers()
    for i, v in pairs(custom_timers) do
        send_command('timers delete "' .. i .. '"')
    end
    custom_timers = {}
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
    send_command("@wait 5;input /lockstyleset 13")
end

windower.raw_register_event('zone change', reset_timers)
windower.raw_register_event('logout', reset_timers)
