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

-- Setup vars that are user-dependent.
function user_setup()
    include('augments.lua')
    include('natty_helper_functions.lua')
    include('default_sets.lua')

    state.OffenseMode:options('Normal', 'Acc', 'Crit')
    state.HybridMode:options('Normal', 'PDT', 'MDT')
    state.DefenseMode:options('None', 'Physical', 'Magical', 'Reraise')
    state.PhysicalDefenseMode:options('None', 'Physical', 'Magical', 'Reraise', 'Regain')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.IdleMode:options('Normal', 'PDT', 'Regain')

    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    gear.default.obi_waist = "Orpheus's Sash"

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    gear.WSDayEar1 = "Schere Earring"
    gear.WSDayEar2 = "Crepuscular Earring"
    gear.WSNightEar1 = "Lugra Earring +1"
    gear.WSNightEar2 = "Lugra Earring"

    gear.tp_neck_regular = { name = "War. Beads +2" }
    gear.tp_neck_vim = { name = "War. Beads +2" }
    gear.tp_neck = gear.tp_neck_vim

    send_command('bind numpad4 gs c equip Sword')
    send_command('bind !numpad4 gs c equip Ridill')
    send_command('bind numpad5 gs c equip Club')
    send_command('bind ^numpad5 gs c equip Dagger')
    send_command('bind numpad6 gs c equip Axe')

    send_command('bind numpad7 gs c equip GAxe')
    send_command('bind numpad8 gs c equip Spear')
    send_command('bind numpad9 gs c equip Staff')
    send_command('bind ^numpad9 gs c equip Fists')

    send_command('bind ^f11 gs c set DefenseMode Reraise')

    send_command('bind ^- gs c cycle DoomMode')
    send_command('bind ^= gs c cycle treasuremode')

    send_command('bind ^numpad1 input /item "Panacea" <me>')
    send_command('bind ^numpad2 input /item "Remedy" <me>')
    send_command('bind ^numpad3 input /item "Holy Water" <me>')

    send_command('bind ^space tc nearest')


    info.magic_ws = S {
        'Aeolian Edge',
        'Cyclone',
        'Gust Slash',
        'Catacylsm',
        'Spirit Taker',
        'Sunburst',
        'Starburst',
        'Earth Crusher',
        'Sanguine Blade',
        'Seraph Blade',
        'Shining Blade',
        'Red Lotus Blade',
        'Burning Blade',
        'Freezebite',
        'Frostbite',
        'Cloudsplitter',
        'Shadow of Death',
        'Dark Harvest',
        'Infernal Scythe',
        'Raiden Thrust',
        'Thunder Thrust',
        'Seraph Strike',
        'Shining Strike',
        'Flash Nova',
    }

    update_combat_form()
    select_default_macro_book()
end

function procTime(myTime)
    if isNight() then
        --     gear.WSEarBrutal.name = gear.WSNightEar1
        --     gear.MovementFeet = gear.NightFeet
        -- else
        --     gear.WSEarBrutal.name = gear.WSDayEar1
        --     gear.MovementFeet = gear.DayFeet
    end
end

function isNight()
    return (world.time >= 17 * 60 or world.time < 7 * 60)
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    -- windower.unregister_event(ticker)

    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    gear.melee_cape = {
        name = "Cichol's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', }
    }
    gear.ws_cape_str = {
        name = "Cichol's Mantle",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%', },
    }
    gear.magic_ws_cape = {
        name = "Cichol's Mantle",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Weapon skill damage +10%', }
    }
    gear.multi_ws_cape = gear.ws_cape_str

    gear.crit_cape = gear.ws_cape_str

    sets.weapons = {}
    sets.weapons.Sword = { main = "Naegling", sub = "Blurred Shield +1" }
    sets.weapons.Ridill = { main = "Ridill", sub = "Blurred Shield +1" }
    sets.weapons.Dagger = { main = "Crepuscular Knife", sub = "Blurred Shield +1" }
    sets.weapons.Club = { main = "Loxotic Mace +1", sub = "Blurred Shield +1" }
    sets.weapons.GAxe = { main = "Chango", sub = "Utu Grip" }
    sets.weapons.Spear = { main = "Shining One", sub = "Utu Grip" }
    sets.weapons.Staff = { main = "Xoanon", sub = "Utu Grip" }
    sets.weapons.Fists = { main = "Karambit" }
    sets.weapons.Axe = { main = "Ikenga's Axe", sub = "Blurred Shield +1" }


    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Halitus Helm",
        neck = "Moonlight Necklace",
        ear1 = "Cryptic Earring",
        ear2 = "Trux Earring",
        body = "Obviation Cuirass +1",
        hands = "Macabre Gauntlets +1",
        ring1 = "Supershear Ring",
        ring2 = "Eihwaz Ring",
        waist = "Trance Belt",
        legs = "Zoar Subligar +1",
        feet = gear.yorium.enmity.feet
    }

    sets.phalanx = {
        legs = "Sakpata's Cuisses"
    }

    sets.SIRD = {
        ammo = "Staunch Tathlum +1",  -- 11
        head = gear.acro.SIRD.head,   -- 10
        neck = "Moonlight Necklace",  -- 15
        ear2 = "Magnetic Earring",    -- 8
        hands = gear.acro.SIRD.hands, -- 10
        legs = "Founder's Hose",      -- 30
        feet = "Odyssean Greaves"     -- 20
    }

    sets.precast.FC = {
        ammo = "Sapience Orb",
        head = "Sakpata's Helm",
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Sacro Breastplate",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Rahab Ring",
        legs = "Limbo Trousers",
        feet = gear.odyssean.fc.feet
    }

    sets.FullTP = {
        ammo = "Aurgelmir Orb +1",
        head = "Flamma Zucchetto +2",
        neck = "Vim Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Dedition Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Kentarch Belt +1",
        legs = "Volte Tights",
        feet = "Flamma Gambieras +2"
    }
    sets.Volte = set_combine(sets.FullTP, { body = "Volte Harness" })

    sets.Sleeping = { neck = "Vim Torque +1" }

    sets.buff.doom = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Nicander's Necklace",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        back = gear.DDCape,
        waist = "Gishdubar Sash",
        legs = "Shabti Cuisses +1",
        feet = "Nyame Sollerets"
    }

    sets.buff.doom.HolyWater = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Nicander's Necklace",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1",
        back = gear.DDCape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
    }

    sets.buff['Retaliation'] = {
        hands = "Boii Mufflers +3"
    }

    sets.buff['Brazen Rush'] = {
        head = "Sakpata's Helm",
        legs = "Agoge Cuisses +3",
    }

    sets.buff['Mighty Strikes'] = {
        ammo = "Yetshila +1",
        feet = "Boii Calligae +3"
    }

    sets.resist = {}
    sets.resist.death = {
        main = "Odium",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    -- Precast Sets

    sets.precast.RA = { range = "Grudge" }
    sets.midcast.RA = sets.precast.RA

    -- Precast sets to enhance JAs
    sets.precast.JA['Provoke'] = sets.enmity
    sets.precast.JA['Berserk'] = { body = "Pummeler's Lorica +3", back = gear.melee_cape, feet = "Agoge Calligae +3" }
    sets.precast.JA['Warcry'] = { head = "Agoge Mask +3" }
    sets.precast.JA['Aggressor'] = { head = "Pummeler's Mask +1", body = "Agoge Lorica +1" }
    sets.precast.JA['Retaliation'] = { hands = "Pummeler's Mufflers +1", legs = "Boii Calligae +3" }
    sets.precast.JA['Warrior\'s Charge'] = { legs = "Agoge Cuisses +3" }
    sets.precast.JA['Tomahawk'] = { ammo = "Throwing Tomahawk", feet = "Agoge Calligae +3" }
    sets.precast.JA['Restraint'] = { hands = "Boii Mufflers +3" }
    sets.precast.JA['Blood Rage'] = { body = "Boii Lorica +3" }
    sets.precast.JA['Mighty Strikes'] = { hands = "Agoge Mufflers +1" }


    sets.precast.JA['Jump'] = {
        ammo = "Coiste Bodhar",
        head = "Flamma Zucchetto +2",
        neck = "Vim Torque +1",
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Boii Lorica +3",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Kentarch Belt +1",
        legs = "Tatenashi Haidate +1",
        feet = "Tatenashi Sune-ate +1"
    }
    sets.precast.JA['High Jump'] = sets.precast.JA['Jump']


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Knobkierrie",
        head = "Agoge Mask +3",
        neck = "Fotia Gorget",
        ear1 = "Thrud Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Boii Mufflers +3",
        ring1 = "Epaminondas's Ring",
        ring2 = "Ephramad's Ring",
        back = gear.ws_cape_str,
        waist = "Fotia Belt",
        legs = "Boii Cuisses +3",
        feet = "Nyame Sollerets",
    }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo = "Seething Bomblet +1",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Telos Earring",
        ear2 = "Dignitary Earring",
        body = "Boii Lorica +3",
        hands = "Boii Mufflers +3",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.ws_cape_str,
        waist = "Fotia Belt",
        legs = "Boii Cuisses +3",
        feet = "Boii Calligae +3"
    })

    sets.precast.WS.MultiHit = {
        ammo = "Crepuscular Pebble",
        head = "Sakpata's Helm",
        neck = "Fotia Gorget",
        ear1 = "Schere Earring",
        ear2 = "Moonshade Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Ephramad's ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Fotia Belt",
        legs = "Agoge Cuisses +3",
        feet = "Sakpata's Leggings"
    }

    sets.precast.WS.Crit = {
        ammo = "Yetshila +1",
        head = "Boii Mask +3",
        neck = "Fotia Gorget",
        ear1 = "Schere Earring",
        ear2 = "Moonshade Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Begrudging Ring",
        ring2 = "Hetairoi Ring",
        back = gear.ws_cape_str,
        waist = "Gerdr Belt +1",
        legs = "Zoar Subligar +1",
        feet = "Boii Calligae +3"
    }

    sets.precast.WS.Magic = {
        ammo = "Knobkierrie",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Lugra Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.magic_ws_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Greataxe
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.MultiHit, {
        ear1 = "Schere Earring",
    })
    sets.precast.WS['Upheaval']['Mighty Strikes'] = {
        ammo = "Yetshila +1",
        feet = "Boii Calligae +3"
    }

    sets.precast.WS['Full Break'] = set_combine(sets.precast.WS, {
        ear1 = "Crepuscular Earring",
        ear2 = "Boii Earring +1",
    })

    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS)

    -- Sword
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck = "Warrior's Bead Necklace +2",
        waist = "Sailfi Belt +1",
        legs = "Boii Cuisses +3",
    })
    sets.precast.WS['Savage Blade'].MaxTP = { ear2 = "Lugra Earring +1" }
    sets.precast.WS['Savage Blade']['Mighty Strikes'] = {
        ammo = "Yetshila +1",
        feet = "Boii Calligae +3"
    }

    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit)



    -- Axe
    sets.precast.WS['Calamity'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Mistral Axe'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Decimation'] = sets.precast.WS.MultiHit

    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS.Crit)

    sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS.Magic)

    -- Spear
    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS['Savage Blade'], {
        ammo = "Yetshila +1",
        head = "Boii Mask +3",
        ear1 = "Moonshade Earring",
        ear2 = "Boii Earring +1",
        body = "Hjarrandi Breastplate",
        ring1 = "Begrudging Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.crit_cape,
        waist = "Gerdr Belt +1",
        feet = "Boii Calligae +3"
    })
    sets.precast.WS['Impulse Drive'].FullTP = {
        ear1 = "Thrud Earring"
    }

    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS['Upheaval'],
        {
            ammo = "Yetshila",
            head = "Boii Mask +3",
            ring1 = "Begrudging Ring",
            ring2 = "Niqmaddu Ring",
            back = gear.crit_cape,
            waist = "Gerdr Belt +1",
        })

    -- Club
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Savage Blade'], { ring2 = "Regal Ring" })

    sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS['Upheaval'],
        { ring1 = "Ephramad's Ring", ring2 = "Metamorph Ring +1" })

    sets.precast.WS['True Strike'] = set_combine(
        sets.precast.WS['Impulse Drive'],
        { legs = "Nyame Flanchard" }
    )



    -- Staff
    sets.precast.WS['Retribution'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Shattersoul'] = sets.precast.WS.MultiHit

    sets.precast.WS['Cataclysm'] = {
        ammo = "Knobkierrie",
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Lugra Earring +1",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Archon Ring",
        back = gear.ws_cape_str,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
    }
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Cataclysm'], { back = gear.ws_cape_str })

    -- H2H?
    sets.precast.WS['Asuran Fists'] = sets.precast.WS.Acc
    sets.precast.WS['Asuran Fists']['Mighty Strikes'] = {
        ammo = "Yetshila +1",
        feet = "Boii Calligae +3"
    }

    -- Dagger
    sets.precast.WS['Aeolian Edge'] = {
        ammo = "Knobkierrie",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Regal Ring",
        back = gear.magic_ws_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }
    sets.precast.WS['Eviscaration'] = sets.precast.WS.Crit

    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Sakpata's Helm",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Rahab Ring",
        ring2 = "Rahab Ring",
        legs = "Sakpata's Cuisses",
        feet = gear.odyssean.fc.feet
    }

    sets.midcast.Trust = set_combine(sets.midcast.FastRecast, sets.SIRD)
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, sets.SIRD)


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1", ring2 = gear.right_moonlight }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = {
        ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Blacksmith's Belt",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.idle.Field = set_combine({}, {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Brachyura Earring",
        ear2 = "Odnowa Earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    })

    sets.idle.Weak = {
        ammo = "Staunch Tathlum +1",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.idle.PDT = set_combine(sets.idle.Field, {
        head = "Sakpata's Helm",
        body = "Adamantite Armor",
    })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Reraise = sets.idle.Weak

    sets.idle.Regain = set_combine(sets.idle.Field, {
        head = "Valorous Mask",
        neck = "Republican Platinum medal",
        ring1 = "Roller's Ring",
    })
    sets.idle.Field.Regain = sets.idle.Regain

    -- Defense sets
    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto earring",
        ear2 = "Odnowa Earring +1",
        body = "Adamantite Armor",
        hands = "Sakpata's Gauntlets",
        ring2 = "Gelatinous Ring +1",
        ring1 = gear.left_moonlight,
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.defense.Reraise = {
        ammo = "Staunch Tathlum +1",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring2 = "Gelatinous Ring +1",
        ring1 = gear.left_moonlight,
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuitso Earring",
        ear2 = "Odnowa Earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Shadow Ring",
        ring2 = gear.right_moonlight,
        back = "Moonlight Cape",
        waist = "Engraved Belt",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.defense.Regain = {
        ammo = "Aurgelmir Orb +1",
        head = "Malignance Chapeau",
        neck = "Republican Platinum medal",
        ear1 = "Sherida Earring",
        ear2 = "Dedition Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Roller's Ring",
        ring2 = gear.right_chirich,
        back = gear.stp_cape,
        waist = "Gerdr Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.Kiting = { feet = "Hermes' Sandals" }

    sets.Reraise = { head = "Crepuscular Helm", body = "Crepuscular Mail" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm", -- 7
        neck = gear.tp_neck,
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Boii Lorica +3",       -- 13
        hands = "Sakpata's Gauntlets", -- 8
        ring1 = gear.left_moonlight,   -- 5
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,        -- 10
        waist = "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",    -- 9
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Acc = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = gear.tp_neck,
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Boii Lorica +3",
        hands = "Boii Mufflers +3",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Boii Cuisses +3",
        feet = "Tatenashi Sune-ate +1",
    }
    sets.engaged.Crit = {
        ammo = "Yetshila +1",
        head = "Boii Mask +3",
        neck = gear.tp_neck,
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Tatenashi Haramaki +1",
        hands = "Flamma Manopolas +2",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.crit_cape,
        waist = "Sailfi Belt +1",
        legs = "Zoar Subligar +1",
        feet = "Thereoid Greaves"
    }
    sets.engaged.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = gear.tp_neck,
        ear1 = "Telos Earring",
        ear2 = "Boii earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Acc.PDT = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Boii earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.engaged.Acc.Reraise = {
        ammo = "Seething bomblet +1",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Schere Earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.MDT = set_combine(sets.engaged, {
        neck = "Warder's Charm +1",
        body = "Sakpata's Plate",
    })

    sets.engaged.DW = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = gear.tp_neck,
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Boii Lorica +3",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Windbuffet Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.DW.Acc = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = gear.tp_neck,
        ear1 = "Telos Earring",
        ear2 = "Boii earring +1",
        body = "Boii Lorica +3",
        hands = "Boii Mufflers +3",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings",
    }
    sets.engaged.DW.Crit = {
        ammo = "Yetshila +1",
        head = "Boii Mask +3",
        neck = gear.tp_neck,
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Tatenashi Haramaki +1",
        hands = "Flamma Manopolas +2",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.crit_cape,
        waist = "Sailfi Belt +1",
        legs = "Zoar Subligar +1",
        feet = "Thereoid Greaves"
    }
    sets.engaged.DW.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = gear.tp_neck,
        ear1 = "Schere Earring",
        ear2 = "Boii earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Kentarch Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Tatenashi Sune-Ate +1"
    }
    sets.engaged.DW.Acc.PDT = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Boii earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.DW.Reraise = {
        ammo = "Coiste Bodhar",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Schere Earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Reiki Yotai",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.DW.Acc.Reraise = {
        ammo = "Seething bomblet +1",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Schere Earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    -- weapon agnostic remap
    if spell.type == 'WeaponSkill' then
        local main = player.equipment.main
        if spell.english == 'Upheaval' then
            if main == 'Naegling' then
                send_command('input /ws "Savage Blade" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Loxotic Mace +1' then
                send_command('input /ws "Judgment" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Ikenga\'s Axe' then
                send_command('input /ws "Calamity" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Shining One' then
                send_command('input /ws "Impulse Drive" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Xoanon' then
                send_command('input /ws "Retribution" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Karambit' then
                send_command('input /ws "Asuran Fists" ' .. spell.target.raw)
                cancel_spell()
            end
        elseif spell.english == "Steel Cyclone" then
            if main == 'Shining One' then
                send_command('input /ws "Stardiver" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Ikenga\'s Axe' then
                send_command('input /ws "Mistral Axe" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Loxotic Mace +1' then
                send_command('input /ws "Black Halo" ' .. spell.target.raw)
                cancel_spell()
            end
        elseif spell.english == "Fell Cleave" then
            if main == "Shining One" then
                send_command('input /ws "Sonic Thrust" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Xoanon' then
                send_command('input /ws "Cataclysm" ' .. spell.target.raw)
                cancel_spell()
            elseif main == 'Crepuscular Knife' then
                send_command('input /ws "Aeolian Edge" ' .. spell.target.raw)
                cancel_spell()
            end
        end
    elseif spell.type == 'JobAbility' and player.sub_job_level ~= 0 then
        if player.sub_job == 'DRG' then
            if spell.english == 'Hasso' then
                cancel_spell()
                send_command('input /ja "High Jump" ' .. spell.target.raw)
            elseif spell.english == 'Sekkanoki' then
                cancel_spell()
                send_command('input /ja "Super Jump" ' .. spell.target.raw)
            end
        elseif player.sub_job == 'NIN' then
            cancel_spell()
            if spell.english == 'Hasso' then
                send_command('input /ma "Utsusemi: Ni" <me>')
            elseif spell.english == 'Sekkanoki' then
                cancel_spell()
                send_command('input /ma "Utsusemi: Ichi" <me>')
            end
        elseif player.sub_job == 'SAM' then
            if spell.english == "Jump" then
                cancel_spell()
                send_command('input /ja "Hasso"')
            elseif spell.english == "High Jump" then
                cancel_spell()
                send_command('input /ja "Meditate"')
            elseif spell.english == "Super Jump" then
                cancel_spell()
                send_command('input /ja "Sekkanoki"')
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if buffactive['Warcry'] and (spell.english == 'Warcry' or spell.english == 'Blood Rage') then
        windower.add_to_chat(36, 'Cancelled: Warcry is active.')
        eventArgs.cancel = true
    end

    if spell.english == "Provoke" and spell.target and spell.target.distance ~= nil and spell.target.distance > 17 then
        cancel_spell()
        send_command("input /ra " .. spell.target.raw)
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if player.tp == 3000 then
            if sets.precast.WS[spell.english] then
                if sets.precast.WS[spell.english].MaxTP then
                    equip(sets.precast.WS[spell.english].MaxTP)
                end
            end
        end
        if buffactive['Mighty Strikes'] and not info.magic_ws:contains(spell.english) then
            equip(sets.buff['Mighty Strikes'])
        end
        if buffactive['Brazen Rush'] and not info.magic_ws:contains(spell.english) then
            equip(sets.buff['Brazen Rush'])
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end

    if state.TreasureMode.value == 'Tag' and S { 'Poisonga', 'Poison', 'Diaga', 'Cyclone' }:contains(spell.english) then
        equip(sets.TreasureHunter)
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if buffactive['Mighty Strikes'] and player.status == 'Engaged' then
        equip(sets.buff['Mighty Strikes'])
    end
    if buffactive['Brazen Rush'] and player.status == 'Engaged' then
        equip(sets.buff['Brazen Rush'])
    end
    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end
    if spell.english == 'Tomahawk' and not spell.interrupted then
        local tomahawk_timer = calculate_tomahawk_duration()
        send_command('input /p Tomahawk on :: ' .. tomahawk_timer .. ' seconds')
        send_command('timers c Tomahawk ' .. tomahawk_timer .. ' down')
    end
end

function job_buff_change(buff, gain)
    -- when gaining a buff
    if gain then
        if buff == 'sleep' and player.hp > 50 then
            if not buffactive['charm'] then
                equip(sets.Sleeping)
            end
            send_command('cancel stoneskin')
        elseif buff == 'doom' then
            if state.DoomMode.value == 'Cursna' then
                equip(sets.buff.doom)
            elseif state.DoomMode.value == 'Holy Water' then
                equip(sets.buff.doom.HolyWater)
            end
        elseif buff == 'charm' then
            local function count_slip_debuffs()
                local erase_dots = 0
                if buffactive.poison then
                    erase_dots = erase_dots + 1
                end
                if buffactive.dia then
                    erase_dots = erase_dots + 1
                end
                if buffactive.bio then
                    erase_dots = erase_dots + 1
                end
                if buffactive.burn then
                    erase_dots = erase_dots + 1
                end
                if buffactive.choke then
                    erase_dots = erase_dots + 1
                end
                if buffactive.shock then
                    erase_dots = erase_dots + 1
                end
                if buffactive.drown then
                    erase_dots = erase_dots + 1
                end
                if buffactive.rasp then
                    erase_dots = erase_dots + 1
                end
                if buffactive.frost then
                    erase_dots = erase_dots + 1
                end
                if buffactive.helix then
                    erase_dots = erase_dots + 1
                end
                return erase_dots
            end

            local debuffs = count_slip_debuffs()
            if debuffs > 0 then
                send_command('input /p Charmed and I cannot be slept.')
            else
                send_command('input /p Charmed.')
            end
        elseif S { 'Aftermath', 'Aftermath: Lv.1', 'Aftermath: Lv.2', 'Aftermath: Lv.3' }:contains(buff) then
            -- update_combat_form()
        elseif buff == 'Max HP Down' then
            send_command('input /item "Panacea" <me>')
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

function calculate_tomahawk_duration()
    local player = windower.ffxi.get_player()

    local tomahawk_lv = player['merits'].tomahawk or 0

    local tomahawk_duration = (tomahawk_lv > 0 and (30 + (tomahawk_lv * 15 - 15))) or 0

    return tomahawk_duration
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    -- update_combat_form()

    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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

-------

function update_combat_form()
    -- state.CombatForm:reset()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 1)
    else
        set_macro_page(1, 1)
    end
    send_command("@wait 2; input /lockstyleset 6")
end

-- windower.register_event('hpp change', function(new_hpp, old_hpp)
--     -- print(new_hpp, old_hpp)
--     if buffactive.sleep and new_hpp > 10 then return end
--     if new_hpp < 80 and old_hpp >= 80 then
--         gear.tp_neck.name = gear.tp_neck_regular.name
--         -- send_command('gs c update')
--     elseif new_hpp > 80 and old_hpp <= 80 then
--         gear.tp_neck.name = gear.tp_neck_vim.name
--         -- send_command('gs c update')
--     end
--     if player.status == 'Engaged' then
--         send_command('gs c update')
--     end
-- end)
