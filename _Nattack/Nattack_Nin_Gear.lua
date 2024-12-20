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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false

    include('natty_helper_functions.lua')
    -- calculate_haste()
    include('Mote-TreasureHunter')

    -- For th_action_check():
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
    include('default_sets.lua')

    state.OffenseMode:options('Normal', 'Acc', 'Crit')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')
    state.IdleMode:options('Normal', 'PDT')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water' }
    state.MagicBurst = M { ['description'] = 'Magic Burst', 'Normal', 'Once', 'Always' }

    gear.default.obi_waist = "Orpheus's Sash"

    -- gear.NormalShuriken = 'Date Shuriken'
    -- gear.SangeShuriken = 'Happo Shuriken'


    --options.ammo_warning_limit = 15

    gear.DayFeet = { name = "Danzo Sune-ate" }
    gear.NightFeet = { name = "Hachiya Kyahan +1" }
    gear.MovementFeet = gear.DayFeet


    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17 * 60 or myTime == 7 * 60) then
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                job_update()
            end
        end
    end)

    --procTime(world.time) -- initial setup of proctime

    send_command('bind numpad7 gs equip sets.weapons.Katana')
    send_command('bind numpad8 gs equip sets.weapons.Sword')
    send_command('bind numpad9 gs equip sets.weapons.Dagger')
    send_command('bind ^numpad7 gs equip sets.weapons.DI')

    send_command('bind !` gs c cycle MagicBurst')

    send_command('bind numpad4 input /nin \"Raiton: San\"')
    send_command('bind numpad5 input /nin \"Doton: San\"')
    send_command('bind numpad6 input /nin \"Huton: San\"')
    send_command('bind numpad1 input /nin \"Hyoton: San\"')
    send_command('bind numpad2 input /nin \"Katon: San\"')
    send_command('bind numpad3 input /nin \"Suiton: San\"')

    send_command('bind numpad0 gs equip sets.resist.death')

    send_command('bind ^- gs c cycle doommode')
    send_command('bind ^= gs c cycle treasuremode')

    init_DW_class()
    select_default_macro_book()
end

function procTime(myTime)
    if isNight() then
        gear.MovementFeet = gear.NightFeet
    else
        gear.MovementFeet = gear.DayFeet
    end
end

function isNight() -- this originally was used a lot more, so I just left it.
    return (world.time >= 17 * 60 or world.time < 7 * 60)
end

function user_unload()
    windower.unregister_event(ticker)
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    sets.weapons = {}
    sets.weapons.Katana = { main = "Heishi Shorinken", sub = "Kunimitsu" }
    sets.weapons.Sword = { main = "Naegling", sub = "Hitaki" }
    sets.weapons.Dagger = { main = "Crepuscular Knife", sub = "Kunimitsu" }
    sets.weapons.DI = { main = "Voluspa Katana", sub = "Voluspa Knife" }

    gear.da_cape = {
        name = "Andartia's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', '"Dbl.Atk."+10', '"Phys. dmg. taken -10"' }
    }
    gear.stp_cape = {
        name = "Andartia's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Store TP"+10', } -- '"Phys. dmg. taken -10"' }
    }
    gear.dw_cape = {
        name = "Andartia's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', '"Dual Wield"+10', }
    } -- '"Phys. dmg. taken -10"' }}
    gear.ws_cape_str = {
        name = "Andartia's Mantle",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', }
    }
    gear.blade_hi_cape = {
        name = "Andartia's Mantle",
        augments = { 'AGI+20', 'Accuracy+20 Attack+20', 'AGI+10', 'Crit.hit rate+10' },
    }

    gear.matk_cape = {
        name = "Andartia's Mantle",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', }
    }
    gear.magic_ws_cape = gear.matk_cape
    gear.SIRDCape = { name = "Andartia's Mantle", augments = { 'Enmity+10', 'Spell interruption rate down-10%', } }
    gear.EnmityCape = gear.SIRDCape
    gear.fc_cape = { name = "Andartia's Mantle", augments = { '"Fast Cast"+10', } }
    gear.idle_cape = "Moonlight Cape"

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
        neck = "Bathy Choker +1",
        body = "Hizamaru Haramaki +2"
    }

    -- Idle sets
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = gear.idle_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = gear.MovementFeet
    }

    sets.idle.Town = {
        range = "Ebisu Fishing Rod +1",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.idle_cape,
        waist = "Blacksmith's Belt",
        legs = "Nyame Flanchard",
        feet = gear.MovementFeet
    }

    sets.idle.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = gear.idle_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = gear.MovementFeet
    }

    sets.idle.Weak = sets.idle

    -- Defense sets
    sets.defense.Evasion = {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        neck = "Bathy Choker +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Eabani Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Ilabrat Ring",
        back = gear.dw_cape,
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shadow Ring",
        back = gear.dw_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.Kiting = { feet = gear.MovementFeet }

    sets.SIRD = {                    -- 5 merit
        ammo = "Staunch Tathlum +1", -- 11
        head = gear.taeon.SIRD.head, -- 10
        neck = "Moonlight Necklace", -- 15
        ear1 = "Halasz Earring",     -- 5
        ear2 = "Magnetic Earring",   -- 8
        body = gear.taeon.SIRD.body,
        -- hands = "Rawhide Gloves",    -- 15
        ring1 = "Evanescence Ring",  -- 5
        ring2 = "Dark Ring",         -- 4
        back = gear.SIRDCape,        -- 10
        waist = "Audumbla Sash",     -- 10
        legs = gear.taeon.SIRD.legs, -- 10
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
        back = gear.EnmityCape,
        waist = "Trance Belt",
        legs = "Zoar Subligar +1",
        feet = "Mochizuki Kyahan +3"
    }

    sets.TreasureHunter = {
        ammo = "Perfect Lucky Egg",
        head = "Volte Cap",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Mijin Gakure'] = { main = "Nagi", ammo = "", legs = "Mochizuki Hakama +3" }
    sets.precast.JA['Futae'] = { legs = "Hattori Tekko +3" }
    sets.precast.JA['Sange'] = { legs = "Mochizuki Chainmail +3" }
    sets.precast.JA['Yonin'] = { head = "Mochizuki Hatsuburi +3" }
    sets.precast.JA['Innin'] = sets.precast.JA['Yonin']

    -- catch all for enmity spells
    sets.precast.JA['Provoke'] = sets.Enmity
    sets.midcast["Divine Magic"] = sets.Enmity
    sets.midcast["Dark Magic"] = sets.Enmity
    sets.midcast["Blue Magic"] = sets.Enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Spiral Ring",
        back = "Iximulew Cape",
        waist = "Caudata Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    -- Uk'uxkaj Cap, Daihanshi Habaki

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = {
        ammo = "Yamarang",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Choreia Earring",
        ear2 = "Crepuscular Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Patricius Ring",
        back = "Sacro Mantle",
        waist = "Chaac Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.precast.Flourish1 = { waist = "Chaac Belt" }

    -- Fast cast sets for spells

    sets.precast.FC = {
        ammo = "Sapience Orb",
        head = gear.herculean.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Kishar Ring",
        back = gear.fc_cape,
        legs = "Gyve Trousers",
    }

    sets.precast.FC.Ninjutsu = set_combine(sets.precast.FC, { ammo = "Impatiens", ring1 = "Lebeche Ring" })

    -- Snapshot for ranged
    sets.precast.RA = {

    }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Lugra Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.TrustRing,
        ring2 = "Epaminondas's Ring",
        back = gear.ws_cape_str,
        waist = "Fotia Belt",
        legs = "Mochizuki Hakama +3",
        feet = "Hattori Kyahan +3"
    }
    sets.precast.MultiHit = {
        ammo = "Seething Bomblet +1",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Lugra Earring +1",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        ring1 = "Epona's Ring",
        ring2 = "Gere Ring",
        back = gear.da_cape,
        waist = "Fotia Belt",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots",
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    sets.precast.WS.Magic = {
        ammo = "Seething Bomblet +1",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Crematio Earring",
        ear2 = "Friomisi Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.magic_ws_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS.Low = set_combine(sets.naked,
        {
            main = "",
            sub = "",
            ammo = "",
            neck = "Fotia Gorget",
            ear1 = "Sherida Earring",
            ear2 = "Crepuscular Earring",
            ring1 = gear.left_chirich,
            ring2 = "Epona's Ring",
            waist = "Fotia belt"
        })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
        ammo = "Yetshila +1",
        head = "Blistering Sallet +1",
        ear1 = "Odr Earring",
        ear2 = "Lugra Earring +1",
        body = "Hattori Ningi +3",
        hands = "Mpaca's Gloves",
        ring1 = "Begrudging Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.blade_hi_cape,
        legs = "Zoar Subligar +1",
        feet = "Mpaca's Boots"
    })

    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS['Blade: Hi'], {
        ear1 = "Odr Earring",
        ear2 = "Lugra Earring +1",
        ring1 = "Begrudging Ring",
        ring2 = gear.right_chirich
    })

    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS.MultiHit, {
        ammo = "Coiste Bodhar",
        neck = "Fotia Gorget",
        head = "Mpaca's Cap",
        ear1 = "Odr Earring",
        ear2 = "Lugra Earring +1",
        hands = "Mpaca's Gloves",
        ring1 = "Epona's Ring",
        ring2 = "Gere Ring",
        waist = "Fotia Belt"
    })

    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {
        ammo = "Seething Bomblet +1",
        neck = "Republican Platinum medal",
        ear1 = "Moonshade Earring",
        hands = "Nyame Gauntlets",
        ring1 = gear.TrustRing,
        ring2 = "Epaminondas's Ring",
        waist = "Sailfi Belt +1",
    })

    sets.precast.WS['Blade: Ku'] = sets.precast.WS['Blade: Shun']
    sets.precast.WS['Blade: Ku'].Low = sets.precast.WS.Low

    sets.precast.WS['Eviscaration'] = sets.precast.WS['Blade: Jin']

    sets.precast.WS['Aeolian Edge'] = {
        ammo = "Seething Bomblet +1",
        head = "Herculean Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Malignance Tabard",
        hands = "Herculean Gloves",
        ring1 = "Dingir Ring",
        ring2 = "Ilabrat Ring",
        back = gear.magic_ws_cape,
        waist = gear.ElementalObi,
        legs = "Herculean Trousers",
        feet = "Malignance Boots"
    }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo = "Seething Bomblet +1",
        neck = "Republican Platinum medal",
        ear1 = "Lugra Earring +1",
        ear2 = "Moonshade Earring",
        waist = "Sailfi Belt +1"
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.Magic,
        { head = 'Pixie Hairpin +1', ring2 = "Archon Ring" })

    -- Magical/Hybrid Weaponskills
    sets.precast.WS['Blade: Teki'] = set_combine(sets.precast.WS.Magic, {})
    sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS.Magic,
        { head = "Pixie Hairpin +1", ring2 = "Archon Ring" })
    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS.Magic, {})
    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS.Magic, {})

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.Trust = sets.SIRD

    sets.midcast.FastRecast = {
        head = "Nyame Helm",
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.midcast["Ninjutsu"] = {
        hands = "Mochizuki Tekko +3"
    }

    sets.midcast["Ninjutsu"].Skill = {
        head = "Hachiya Hatsuburi +2",
        neck = "Incanter's Torque",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        feet = "Mochizuki Kyahan +3"
    }

    sets.midcast.SelfNinjutsu = set_combine(sets.midcast["Ninjutsu"], {})

    sets.midcast.Utsusemi = set_combine(sets.enmity, sets.SIRD,
        {
            hands = "Mochizuki Tekko +3",
            feet = "Hattori Kyahan +3"
        })

    sets.midcast.ElementalNinjutsu = {
        ammo = "Ghastly Tathlum +1",
        head = "Mochizuki Hatsuburi +3",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Crematio Earring",
        body = "Nyame Mail",
        hands = "Hattori Tekko +3",
        ring1 = "Dingir Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.matk_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Mochizuki Kyahan +3"
    }

    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {
        ammo = "Pemphredo Tathlum",
        neck = "Moonlight Necklace",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        ring2 = gear.left_stikini,
        ring1 = "Metamorph Ring +1",
        waist = "Eschan Stone",
    })

    sets.midcast.ElementalNinjutsu.burst = set_combine(sets.midcast.ElementalNinjutsu, {
        neck = "Warder's charm +1",
        body = "Nyame Mail",
        hands = "Hattori Tekko +3",
        ring1 = "Mujin Band",
        legs = "Nyame Flanchard"
    })

    sets.midcast.NinjutsuDebuff = {
        ammo = "Yamarang",
        head = "Hachiya Hatsuburi +2",
        neck = "Moonlight Necklace",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.matk_cape,
        waist = "Eschan Stone",
        legs = "Malignance Tights",
        feet = "Mochizuki Kyahan +3"
    }
    sets.midcast['Kurayami: Ni'] = set_combine(sets.midcast.NinjutsuDebuff, { ring1 = "Archon Ring" })
    sets.midcast['Kurayami: Ichi'] = sets.midcast['Kurayami: Ni']
    sets.midcast['Yurin: Ichi'] = sets.midcast['Kurayami: Ni']

    sets.midcast.NinjutsuBuff = {
        head = "Hachiya Hatsuburi +2",
        neck = "Incanter's Torque",
        hands = "Mochizuki Tekko +3",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        feet = "Mochizuki Kyahan +3"
    }

    sets.midcast.RA = {
        head = "Malignance Chapeau",
        neck = "Iskur Gorget",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Crepuscular Ring",
        ring2 = "Dingir Ring",
        back = "Sacro Mantle",
        waist = "Yemaya Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    -- Hachiya Hakama/Thurandaut Tights +1




    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Date Shuriken",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_chirich,
        ring2 = "Gere Ring",
        back = gear.stp_cape,
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Acc = {
        ammo = "Date Shuriken",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Tatenashi Haramaki +1",
        hands = "Tatenashi Gote +1",
        ring1 = gear.left_chirich,
        ring2 = "Gere Ring",
        back = gear.stp_cape,
        waist = "Reiki Yotai",
        legs = "Tatenashi Haidate +1",
        feet = "Tatenashi Sune-ate +1"
    }
    sets.engaged.Crit = {
        ammo = "Date Shuriken",
        head = "Blistering Sallet +1",
        neck = "Combatant's Torque",
        ear1 = "Odr Earring",
        ear2 = "Brutal Earring",
        body = "Hattori Ningi +3",
        hands = "Mpaca's Gloves",
        ring1 = gear.left_chirich,
        ring2 = "Gere Ring",
        back = gear.blade_hi_cape,
        waist = "Kentarch Belt +1",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots",
    }
    sets.engaged.Evasion = {
        ammo = "Date Shuriken",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Epona's Ring",
        ring2 = "Gere Ring",
        back = gear.stp_cape,
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Acc.Evasion = {
        ammo = "Date Shuriken",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Epona's Ring",
        ring2 = "Gere Ring",
        back = gear.stp_cape,
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.PDT = {
        ammo = "Date Shuriken",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Gere Ring",
        back = gear.stp_cape,
        waist = "Reiki Yotai",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }
    sets.engaged.Acc.PDT = {
        ammo = "Date Shuriken",
        head = "Malignance Chapeau",
        neck = "Loricate Torque +1",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Gere Ring",
        back = gear.stp_cape,
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }


    -- accessories only
    sets.DTDW = { ear2 = "Eabani Earring", ear1 = "Suppanomimi", waist = "Reiki Yotai" }

    -- Elegy, 49 DW needed
    sets.SlowMaxDW = {
        head = "Hattori Zukin +3",       -- 7
        ear1 = "Eabani Earring",         -- 4
        ear2 = "Suppanomimi",            -- 5
        body = "Mochizuki Chainmail +3", -- 9
        back = gear.dw_cape,             -- 10
        waist = "Reiki Yotai",           -- 7
        legs = "Mochizuki Hakama +3"     -- 10
    }
    sets.engaged.SlowMaxDW = set_combine(sets.engaged, sets.SlowMaxDW)
    sets.engaged.SlowMaxDW.Acc = set_combine(sets.engaged.Acc, sets.SlowMaxDW)
    sets.engaged.SlowMaxDW.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.SlowMaxDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.SlowMaxDW.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.SlowMaxDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)

    -- Slow II, about 46 DW needed
    sets.SlowMidDW = {
        ear1 = "Suppanomimi",            -- 5
        ear2 = "Eabani Earring",         -- 4
        body = "Mochizuki Chainmail +3", -- 9
        back = gear.dw_cape,
        waist = "Reiki Yotai",           -- 7
        legs = "Mochizuki Hakama +3",    -- 10
    }
    sets.engaged.SlowMidDW = set_combine(sets.engaged, sets.SlowMidDW)
    sets.engaged.SlowMidDW.Acc = set_combine(sets.engaged.Acc, sets.SlowMidDW)
    sets.engaged.SlowMidDW.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.SlowMidDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.SlowMidDW.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.SlowMidDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)

    -- need 39 DW
    sets.NormalDW = {
        ear1 = "Suppanomimi",
        body = "Mochizuki Chainmail +3",
        waist = "Reiki Yotai",
        back = gear.dw_cape,
        legs = "Mochizuki Hakama +3",
        -- feet = "Hizamaru Sune-ate +2"
    }
    sets.engaged.NormalDW = set_combine(sets.engaged, sets.NormalDW)
    sets.engaged.NormalDW.Acc = set_combine(sets.engaged.Acc, sets.NormalDW)
    sets.engaged.NormalDW.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.NormalDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.NormalDW.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.NormalDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)


    -- need 21 DW
    sets.HasteDW = { ear1 = "Suppanomimi", waist = "Reiki Yotai", legs = "Mochizuki Hakama +3" }
    sets.engaged.HasteDW = set_combine(sets.engaged, sets.HasteDW)
    sets.engaged.HasteDW.Acc = set_combine(sets.engaged.Acc, sets.HasteDW)
    sets.engaged.HasteDW.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.HasteDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.HasteDW.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.HasteDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)


    -- need 1 DW
    sets.HasteMaxDW = { waist = "Kentarch Belt +1" }
    sets.engaged.HasteMaxDW = set_combine(sets.engaged, sets.HasteMaxDW)
    sets.engaged.HasteMaxDW.Acc = set_combine(sets.engaged.Acc, sets.HasteMaxDW)
    sets.engaged.HasteMaxDW.Evasion = set_combine(sets.engaged.Evasion, sets.HasteMaxDW)
    sets.engaged.HasteMaxDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.HasteMaxDW)
    sets.engaged.HasteMaxDW.PDT = set_combine(sets.engaged.PDT, sets.HasteMaxDW)
    sets.engaged.HasteMaxDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.HasteMaxDW)

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.doom = {
        ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau",
        neck = "Nicander's Necklace",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.buff.doom.HolyWater = {
        ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau",
        neck = "Nicander's Necklace",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1",
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots",
    }

    sets.resist = {}
    sets.resist.death = {
        sub = "Odium",
        body = "Samnuha Coat",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }
    sets.buff.Migawari = { body = "Hattori Ningi +3" }
    sets.buff.Yonin = { legs = "Hattori Hakama +3" }
    sets.buff.Innin = { head = "Hattori Zukin +3" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    if S {
            "Katon: San", "Katon: Ni",
            "Hyoton: San", "Hyoton: Ni",
            "Huton: San", "Huton: Ni",
            "Doton: San", "Doton Ni",
            "Raiton: San", "Raiton: Ni",
            "Suiton: San", "Suiton: Ni"
        }:contains(spell.english) then
        local recasts = windower.ffxi.get_spell_recasts()

        if recasts and recasts[spell.id] > 0 then
            -- cancel if spell is counting down and try to cast the next nuke down
            eventArgs.cancel = true

            local nextDown = ""
            if spell.english:endswith("San") then
                nextDown = " Ni"
            elseif spell.english:endswith("Ni") then
                nextDown = " Ichi"
            end

            -- get first element of iterator, which will be the spell name
            local spellBase = ""
            for v in spell.english:gmatch("[^%s]+") do
                spellBase = v
                break
            end
            send_command("input /nin \"" .. spellBase .. nextDown .. "\"" .. spell.target.raw)
        end
    end

    if spell.english:startswith("Utsusemi") then
        cancel_copy_image()
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if buffactive['Yonin'] or spell.english == 'Yonin' then -- if yonin is up, make all abilities combine enmity first
        equip(sets.enmity)
    end

    -- equip ninjutsu with QC if we're not trying to overwrite utsusemi
    if spell.skill == 'Ninjutsu' then
        if spell.name:startswith("Utsusemi") then
            if buffactive["Copy Image"]
                or buffactive["Copy Image (2)"]
                or buffactive["Copy Image (3)"]
                or buffactive["Copy Image (4+)"] then
                equip(sets.precast.FC)
            else
                equip(sets.precast.FC.Ninjutsu)
            end
        else
            equip(sets.precast.FC.Ninjutsu)
        end
    end
end

-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_midcast(spell, action, spellMap, eventArgs)
    if buffactive['Yonin'] then
        equip(sets.enmity)
        eventArgs.handled = false
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- if buffactive['Sange'] and shuriken_check() then
    --     equip({ sets.SangeShuriken })
    -- end
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- function shuriken_check()
--     local shuriken_name = gear.SangeShuriken
--     local available_shuriken = player.inventory[shuriken_name] or player.wardrobe[shuriken_name] or
--         player.wardrobe2[shuriken_name] or player.wardrobe3[shuriken_name] or player.wardrobe4[shuriken_name] or
--         player.wardrobe5[shuriken_name] or player.wardrobe6[shuriken_name] or player.wardrobe7[shuriken_name] or
--         player.wardrobe8[shuriken_name]

--     -- ensure ammo exists
--     if not available_shuriken then
--         windower.add_to_chat(104, 'No Ammo (' .. tostring(shuriken_name) .. ') available for that action.')
--         return false
--     end
--     return true
-- end

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
        -- if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
        --     calculate_haste()
        --     -- set_DW_class()
        --     -- send_command('gs c update')
        if buff == 'charm' then
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
        -- if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
        --     calculate_haste()
        --     send_command('gs c update')
        if buff == 'terror' or buff == 'stun' then
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off')
        elseif buff == 'doom' then
            send_command('input /p Doom off')
            send_command('gs c update')
        end
    end

    attack_speed_update(buff)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
                return 'NinjutsuDebuff'
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    procTime(world.time)
    -- calculate_haste()
    set_DW_class()

    th_update(cmdParams, eventArgs)

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

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function get_copy_image()
    if buffactive['Copy Image'] then
        return 'Copy Image'
    elseif buffactive['Copy Image (1)'] then
        return 'Copy Image (1)'
    elseif buffactive['Copy Image (2)'] then
        return 'Copy Image (2)'
    elseif buffactive['Copy Image (3)'] then
        return 'Copy Image (3)'
    elseif buffactive['Copy Image (4+)'] then
        return 'Copy Image (4+)'
    else
        return nil
    end
end

function has_copy_image()
    return (buffactive['Copy Image'] or buffactive['Copy Image (1)'] or buffactive['Copy Image (2)'] or
        buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] or 0) > 0
end

function cancel_copy_image()
    if has_copy_image() then
        send_command('cancel ' .. get_copy_image())
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

    if state.Buff['Blitzer\'s Roll'] then
        haste = haste + 13
    end

    if buffactive.slow then
        haste = haste - 29.2
    end

    if buffactive.elegy then
        haste = haste - 50
    end

    classes.CustomMeleeGroups:clear()
    if haste <= -50 then
        classes.CustomMeleeGroups:append('SlowMaxDW')
    elseif haste <= -29.2 then
        classes.CustomMeleeGroups:append('SlowMidDW')

        -- equip up to
    elseif haste <= 29 then
        -- equip up to 39 DW
        classes.CustomMeleeGroups:append('NormalDW')
    elseif haste > 29 and haste < 43.75 then
        -- equip up to 21 DW
        classes.CustomMeleeGroups:append('HasteDW')
    elseif haste >= 43.75 then
        -- equip 1 DW
        classes.CustomMeleeGroups:append('HasteMaxDW')
    end
end

function select_weaponskill_ears()
    if world.time >= 17 * 60 or world.time < 7 * 60 then
        gear.WSEar1.name = gear.WSNightEar1
        gear.WSEar2.name = gear.WSNightEar2
    else
        gear.WSEar1.name = gear.WSDayEar1
        gear.WSEar2.name = gear.WSDayEar2
    end
end

-- function display_current_job_state(eventArgs)
--     local msg = 'Melee'

--     msg = msg .. ' (' .. classes.CustomMeleeGroups .. ')'
-- end

function update_combat_form()
    --[[if areas.Adoulin:contains(world.area) and buffactive.ionis then
        state.CombatForm:set('Adoulin')
    --else]]
    state.CombatForm:reset()
    --[[end]]
    --
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(4, 13)
    elseif player.sub_job == 'THF' then
        set_macro_page(5, 13)
    else
        set_macro_page(2, 13)
    end
    send_command("@wait 5;input /lockstyleset 2")
end
