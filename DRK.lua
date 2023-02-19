--[[
    f9      F9          cycle OffenseMode
    ^f9     CTRL+F9     cycle HybridMode
    !f9     ALT+F9      cycle RangedMode
    @f9     WIN+F9      cycle WeaponskillMode
    f10     F10         DefenseMode Physical
    ^f10    CTRL+F10    cycle PhysicalDefenseMode
    !f10    ALT+F10     toggle Kiting
    f11     F11         set DefenseMode Magical
    ^f11    CTRL+F11    cycle CastingMode
    f12     F12         update user
    ^f12    CTRL+F12    cycle IdleMode
    !f12    ALT+F12     reset DefenseMode

    bind ^- gs c toggle selectnpctargets')
    send_command('bind ^= gs c cycle pctargetmode')
]]
--TODO: fix macro changing function so it stops freaking out when you change to an undefined weapon.

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
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Souleater = buffactive.Souleater or false

    state.Buff.Berserk = buffactive.Berserk or false
    state.Buff.Warcry = buffactive.Warcry or false
    state.Buff.Aggressor = buffactive.Aggressor or false

    state.Buff['Dread Spikes'] = buffactive['Dread Spikes'] or false
    state.Buff['Endark'] = buffactive['Endark'] or false
    state.Buff['Endark II'] = buffactive['Endark II'] or false

    state.Buff['Arcane Circle'] = buffactive['Arcane Circle'] or false
    state.Buff['Consume Mana'] = buffactive['Consume Mana'] or false
    state.Buff['Soul Enslavement'] = buffactive['Soul Enslavement'] or false
    state.Buff['Scarlet Delirium'] = buffactive['Scarlet Delirium'] or false
    state.Buff['Nether Void'] = buffactive['Nether Void'] or false
    state.Buff['Last Resort'] = buffactive['Last Resort'] or false
    state.Buff['Diabolic Eye'] = buffactive['Diabolic Eye'] or false
    state.Buff['Dark Seal'] = buffactive['Dark Seal'] or false
    state.Buff['Blood Weapon'] = buffactive['Blood Weapon'] or false

    state.Buff['Aftermath'] = (
        buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3'] or
        buffactive['Aftermath']) or false


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
    job_helper()

    state.OffenseMode:options('Normal', 'Acc', 'SubtleBlow')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.DefenseMode:options('None', 'Physical', 'Magical', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'AccHigh', 'Low')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    state.StunMode = M { ['description'] = 'Stun Mode', 'default', 'Enmity' }
    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }
    state.SIRDMode = M { ['description'] = 'SIRD Mode', 'disabled', 'enabled', 'one-time' }
    state.WeaponMode = M { ['description'] = 'Weapon Mode', 'greatsword', 'scythe', 'greataxe', 'sword', 'club' }
    state.Verbose = M { ['description'] = 'Verbosity', 'Normal', 'Verbose', 'Debug' }
    state.UseCustomTimers = M(false, 'Use Custom Timers')
    state.AutoMacro = M(true, 'Use automatic macro books')

    state.AutoMacro:set(false);


    -- Player merit and job points
    -- set these to match your own
    info.JobPoints = {}

    -- how many Dark Seal merits do you have?
    info.JobPoints.DarkSealMerits = 5

    -- Do you have the JP gift dread spikes bonus?
    info.JobPoints.DreadSpikesBonus = true

    -- Additional local binds
    send_command('bind ^` gs c set SIRDMode one-time; input /ma "Dread Spikes"')
    send_command('bind !` input /ja "Scarlet Delirium"')
    send_command('bind ^- gs c cycle doommode')
    send_command('bind ^= gs c cycle treasuremode')

    send_command('bind numpad0 gs equip sets.resist.death')

    send_command('bind numpad7 gs equip sets.Weapons.greatsword')
    send_command('bind numpad8 gs equip sets.Weapons.scythe')
    send_command('bind numpad9 gs equip sets.Weapons.greataxe')
    send_command('bind ^numpad9 gs equip sets.Weapons.greataxe.hepatizon')
    send_command('bind numpad4 gs equip sets.Weapons.sword')
    send_command('bind numpad5 gs equip sets.Weapons.crepuscular')
    send_command('bind numpad6 gs equip sets.Weapons.club')
    send_command('bind numpad1 input /ma stun <t>')
    send_command('bind numpad. gs equip sets.HP_High')
    send_command('bind ^numpad1 gs c cycle StunMode')
    send_command('bind ^f11 gs c set DefenseMode Reraise')


    gear.Moonshade = {}
    gear.Moonshade.name = 'Moonshade Earring'
    gear.default.Moonshade = 'Ishvara Earring'

    info.lastWeapon = nil
    initRecast()



    -- Event driven functions
    ticker = windower.register_event('time change', function(myTime)
        if isMainChanged() then
            procSub()
            if state.AutoMacro.value then
                weapon_macro_book()
            end
            determine_combat_weapon()
        end
        if (myTime == 17 * 60 or myTime == 7 * 60) then
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    custom_timers = {}

    info.AM = {}
    info.AM.potential = 0
    info.AM.level = 0
    info.TP = {}
    info.TP.old = 0
    info.TP.new = 0

    tp_ticker = windower.register_event('tp change', function(new_tp, old_tp)
        if old_tp == 3000 or new_tp == 3000 then
            info.AM.potential = 3
        elseif (new_tp >= 2000 or new_tp < 3000) or (old_tp >= 2000 or old_tp < 3000) then
            info.AM.potential = 2
        elseif (new_tp >= 1000 or new_tp < 2000) or (old_tp >= 1000 or old_tp < 2000) then
            info.AM.potential = 1
        else
            info.AM.potential = 0
        end
        info.TP.old = old_tp
        info.TP.new = new_tp
        echo('new: ' .. new_tp .. ' old: ' .. old_tp, 2)
    end)

    echo('Job:' .. player.main_job .. '/' .. player.sub_job .. '.', 2)

    state.HybridMode:set('PDT')
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    windower.unregister_event(ticker)
    windower.unregister_event(tp_ticker)
    send_command('unbind ^`')
    send_command('unbind !-')
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
    send_command('unbind numpad6')
    send_command('unbind numpad7')
    send_command('unbind numpad8')
    send_command('unbind numpad9')
end

function job_helper()
    info.TP_scaling_ws = S {
        'Spinning Scythe', 'Spiral Hell', 'Cross Reaper', 'Entropy',
        'Spinning Slash', 'Ground Strike', 'Torcleaver', 'Resolution',
        'Upheaval', 'Steel Cyclone', 'Savage Blade', 'Judgment'
    }
    info.Weapons = {}
    info.Weapons.Type = {
        ['Aern Dagger'] = 'dagger',
        ['Aern Dagger II'] = 'dagger',
        ['Naegling'] = 'sword',
        ['Ridill'] = 'sword',
        ['Zulfiqar'] = 'greatsword',
        ['Caladbolg'] = 'greatsword',
        ['Lycurgos'] = 'greataxe',
        ['Kaja Axe'] = 'axe',
        ['Dolichenus'] = 'axe',
        ['Apocalypse'] = 'scythe',
        ['Father Time'] = 'scythe',
        ['Liberator'] = 'scythe',
        ['Redemption'] = 'scythe',
        ['Anguta'] = 'scythe',
        ['Dacnomania'] = 'scythe',
        ['Misanthropy'] = 'scythe',
        ['Woeborn'] = 'scythe',
        ['Crepuscular Scythe'] = 'scythe',
        ['Loxotic Mace +1'] = 'club',
        ['Loxotic Mace'] = 'club',
        ['Warp Cudgel'] = 'club',
        ['Caduceus'] = 'club',
        ['empty'] = 'handtohand',
        ['Blurred Shield'] = 'shield',
        ['Blurred Shield +1'] = 'shield',
        ['Adapa Shield'] = 'shield',
        ["Smythe's Aspis"] = 'shield',
        ["Smyth's Ecu"] = 'shield',
        ["Smythe's Scutum"] = 'shield',
        ["Smythe's Shield"] = 'shield',
        ["Smythe's Escutcheon"] = "Shield",
        ['Utu Grip'] = 'grip',
        ['Caecus Grip'] = 'grip'
    }
    info.Weapons.REMA = S { 'Apocalypse', 'Ragnarok', 'Caladbolg', 'Redemption', 'Liberator', 'Anguta', 'Father Time' }
    info.Weapons.REMA.Type = {
        ['Apocalypse'] = 'relic',
        ['Ragnarok'] = 'relic',
        ['Caladbolg'] = 'empyrean',
        ['Redemption'] = 'empyrean',
        ['Liberator'] = 'mythic',
        ['Anguta'] = 'aeonic',
    }
    info.Weapons.Delay = {
        ['Naegling'] = 240,
        ['Zulfiqar'] = 504,
        ['Caladbolg'] = 430,
        ['Lycurgos'] = 508,
        ['Apocalypse'] = 513,
        ['Father Time'] = 513,
        ['Liberator'] = 528,
        ['Redemption'] = 502,
        ['Anguta'] = 528,
        ['Loxotic Mace +1'] = 334,
    }
    info.Weapons.TPBonus = {
        ['Anguta'] = 500,
        ['Lycurgos'] = 1,
    }
    info.Weapons.Fencer = {
        ['Blurred Shield +1'] = 0
    }
    info.Fencer = {}
    info.Fencer[0] = 0
    info.Fencer[1] = 200
    info.Fencer[2] = 300
    info.Fencer[3] = 400
    info.Fencer[4] = 450
    info.Fencer[5] = 500
    info.Fencer[6] = 550
    info.Fencer[7] = 600
    info.Fencer[8] = 630
    info.Fencer.JPGift = {}
    info.Fencer.JPGift = { bonus = 230, active = false }
    --list of weapon types
    info.Weapons.Twohanded = S { 'greatsword', 'greataxe', 'scythe', 'staff', 'greatkatana', 'polearm' }
    info.Weapons.Onehanded = S { 'sword', 'club', 'katana', 'dagger', 'axe' }
    info.Weapons.HandtoHand = S { 'handtohand' }
    info.Weapons.Ranged = S { 'throwing', 'archery', 'marksmanship' }
    info.Weapons.Shields = S { 'shield' }

    -- macro book locations
    info.macro_sets = {}
    info.macro_sets.subjobs = S { 'SAM', 'NIN', 'WAR', 'DRG' }
    info.macro_sets['greatsword'] = {
        ['SAM'] = { book = 8, page = 2 },
        ['NIN'] = { book = 8, page = 4 },
        ['WAR'] = { book = 8, page = 6 },
        ['DRG'] = { book = 8, page = 10 }
    }

    info.macro_sets['scythe'] = {
        ['SAM'] = { book = 8, page = 1 },
        ['NIN'] = { book = 8, page = 3 },
        ['WAR'] = { book = 8, page = 5 },
        ['DRG'] = { book = 8, page = 9 }
    }

    info.macro_sets['greataxe'] = {
        ['SAM'] = { book = 8, page = 8 },
        ['NIN'] = { book = 8, page = 8 },
        ['WAR'] = { book = 8, page = 8 },
        ['DRG'] = { book = 8, page = 8 }
    }

    info.macro_sets['sword'] = {
        ['SAM'] = { book = 8, page = 7 },
        ['NIN'] = { book = 8, page = 7 },
        ['WAR'] = { book = 8, page = 7 },
        ['DRG'] = { book = 8, page = 7 }
    }

    info.macro_sets['axe'] = info.macro_sets['sword']
    info.macro_sets['club'] = info.macro_sets['sword']
end

-- found in gear_name/DRK.lua
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Ambuscade capes
    gear.melee_cape = {
        name = "Ankou's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', }
    }
    gear.ws_cape = {
        name = "Ankou's Mantle",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'Weapon skill damage +10%' }
    }
    gear.torcleaver_cape = {
        name = "Ankou's Mantle",
        augments = { 'VIT+20', 'Accuracy+20 Attack+20', 'VIT+10', 'Weapon skill damage +10%', }
    }
    gear.casting_cape = {
        name = "Ankou's Mantle",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', '"Fast Cast"+10', 'Spell interruption rate down-10%', }
    }
    gear.SIRD_cape = gear.casting_cape

    -- Mainhand Sets
    sets.Weapons = {}
    sets.Weapons.greatsword = { main = "Caladbolg", sub = "Utu Grip" }
    sets.Weapons.scythe = { main = "Apocalypse", sub = "Utu Grip" }
    sets.Weapons.greataxe = { main = "Lycurgos", sub = "Utu Grip" }
    sets.Weapons.greataxe.hepatizon = { main = "Hepatizon Axe +1", sub = "Utu Grip" }
    sets.Weapons.sword = { main = "Naegling", sub = "Blurred Shield +1" }
    sets.Weapons.club = { main = "Loxotic Mace +1", sub = "Blurred Shield +1" }
    sets.Weapons.ridill = { main = "Ridill", sub = "Blurred Shield +1" }
    sets.Weapons.crepuscular = { main = "Crepuscular Scythe", sub = "Utu Grip" }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Arcane Circle'] = { feet = "Ignominy Sollerets +1" }
    sets.precast.JA['Weapon Bash'] = { hands = "Ignominy Gauntlets +2" }
    sets.precast.JA['Blood Weapon'] = { body = "Fallen's Cuirass" }
    sets.precast.JA['Dark Seal'] = { head = "Fallen's Burgeonet +3" }
    sets.precast.JA['Diabolic Eye'] = { hands = "Fallen's Finger Gauntlets +3" }
    sets.precast.JA['Souleater'] = { head = "Ignominy Burgonet +3", legs = "Fallen's Flanchard +3" }
    sets.precast.JA['Nether Void'] = { legs = "Heathen's Flanchard +2" }
    sets.precast.JA['Provoke'] = sets.enmity

    -------------------------------------------------------------------------------------------------------------------
    -- Miscellaneous Sets
    -------------------------------------------------------------------------------------------------------------------
    sets.HP_High = {
        head = "Ratri sallet +1",
        neck = "Unmoving Collar +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Ignominy Cuirass +3",
        hands = "Rat. Gadlings +1",
        ring1 = "Moonlight Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Reiki Cloak",
        waist = "Eschan Stone",
        legs = "Sakpata's Cuisses",
        feet = { name = "Ratri Sollerets +1", priority = 10 },
    }
    sets.HP_Low = set_combine(sets.naked, { main = gear.MainHand, sub = gear.SubHand, range = "", })

    sets.resist = {}
    sets.resist.death = {
        main = "Malfeasance +1",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Loess Barbuta +1",
        neck = "Unmoving Collar +1",
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
    sets.enmity.Weapon = {}
    -- sets.enmity.Weapon = { main = "Voay Sword +1", sub = "Camaraderie Shield" }


    sets.SIRD = {
        ammo = "Staunch Tathlum +1",
        head = gear.acro.SIRD.head,
        ear2 = "Magnetic Earring",
        hands = gear.acro.SIRD.hands,
        ring2 = "Evanescence Ring",
        back = gear.SIRD_cape,
        legs = "Founder's Hose",
        feet = "Odyssean Greaves"
    }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    sets.TreasureHunter = {
        ammo = "Perfect Lucky Egg",
        head = "Volte Cap",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    sets.buff.sleep = { neck = "Vim Torque +1" }

    sets.buff.doom = set_combine(sets.defense.PDT, {
        neck = "Nicander's Necklace",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash",
        legs = "Shabti Cuisses +1"
    })

    sets.buff.doom.HolyWater = set_combine(sets.buff.doom, {
        neck = "Nicander's Necklace",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1",
    })


    -------------------------------------------------------------------------------------------------------------------
    -- Weaponskill sets
    -------------------------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Knobkierrie",
        head = "Nyame Helm",
        neck = "Abyss Beads +2",
        ear1 = "Thrud Earring",
        ear2 = "Moonshade Earring",
        body = "Ignominy Cuirass +3",
        hands = "Sakpata's Gauntlets",
        ring1 = "Regal Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.ws_cape,
        waist = "Fotia Belt",
        legs = "Fallen's Flanchard +3",
        feet = "Heathen's Sollerets +2"
    }
    sets.precast.WS.FullTP = { ear2 = "Lugra Earring +1" }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        head = "Nyame Helm",
        ear1 = "Telos Earring",
        waist = "Fotia Belt"
    })

    sets.precast.WS.SingleHit = set_combine(sets.precast.WS, { neck = "Abyssal Beads +2", waist = "Sailfi Belt +1" })

    sets.precast.WS.MultiHit = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Abyss Beads +2",
        ear1 = "Schere Earring",
        ear2 = "Lugra Earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Regal Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.multi_cape,
        waist = "Fotia Belt",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }

    sets.precast.WS.Magic = {
        ammo = "Knobkierrie",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Malignance Earring",
        body = "Ignominy Cuirass +3",
        hands = "Fallen's Finger Gauntlets +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Epaminondas's Ring",
        back = gear.ws_cape,
        waist = "Eschan Stone",
        legs = "Fallen's Flanchard +3",
        feet = "Heathen's Sollerets +2"
    }

    sets.precast.WS.Crit = {
        ammo = "Yetshila +1",
        head = "Blistering Sallet +1",
        neck = "Fotia Gorget",
        ear1 = gear.WSEarThrud,
        ear2 = "Moonshade Earring",
        body = "Hjarrandi Breastplate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Regal Ring",
        ring2 = "Begrudging Ring",
        back = gear.ws_cape,
        waist = "Fotia Belt",
        legs = "Zoar Subligar +1",
        feet = "Heathen's Sollerets +2"
    }

    sets.precast.WS.Low = {
        ammo = "Seething Bomblet +1",
        head = "",
        neck = "Fotia Gorget",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "",
        hands = "",
        ring1 = "Moonlight Ring",
        ring2 = "Epaminondas's Ring",
        back = gear.melee_cape,
        waist = "Fotia Belt",
        legs = "Carmine Cuisses +1",
        feet = ""
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    -- Scythe Weaponskills
    sets.precast.WS['Spinning Scythe'] = set_combine(sets.precast.WS.SingleHit,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })
    sets.precast.WS['Spinning Scythe'].Acc = set_combine(sets.precast.WS.Acc,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })
    sets.precast.WS['Spinning Scythe'].Mod = set_combine(sets.precast.WS['Spinning Scythe'],
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })

    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS.SingleHit,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS.Acc,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })
    sets.precast.WS['Spiral Hell'].Mod = set_combine(sets.precast.WS['Spiral Hell'],
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })

    sets.precast.WS['Entropy'] = set_combine(sets.precast.WS.MultiHit, {
        ammo = "Ghastly Tathlum +1",
        head = "Ratri Sallet +1",
        ear1 = "Lugra Earring +1",
        ear2 = "Moonshade Earring",
        body = "Sakpata's breastplate",
        hands = "Fallen's Finger gauntlets +3",
        ring1 = "Metamorph Ring +1",
        back = gear.ws_cape,
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    })
    sets.precast.WS['Entropy'].Acc = set_combine(sets.precast.WS.Acc, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Entropy'].Mod = set_combine(sets.precast.WS['Entropy'], { ear2 = "Moonshade Earring" })
    sets.precast.WS['Entropy'].FullTP = { ear2 = "Malignance Earring" }

    sets.precast.WS['Quietus'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Ratri Sallet +1",
            hands = "Ratri Gadlings +1",
            feet = { name = "Ratri Sollerets +1", priority = 10 },
            ear2 = "Lugra Earring +1"
        })
    sets.precast.WS['Quietus'].Acc = set_combine(sets.precast.WS.Acc,
        {
            head = "Ratri Sallet +1",
            hands = "Ratri Gadlings +1",
            feet = { name = "Ratri Sollerets +1", priority = 10 },
            ear2 = "Lugra Earring +1"
        })
    sets.precast.WS['Quietus'].Mod = set_combine(sets.precast.WS['Quietus'],
        {
            head = "Ratri Sallet +1",
            hands = "Ratri Gadlings +1",
            feet = { name = "Ratri Sollerets +1", priority = 10 },
            ear2 = "Lugra Earring +1"
        })

    sets.precast.WS['Guillotine'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Guillotine'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Guillotine'].Mod = set_combine(sets.precast.WS['Guillotine'], {})

    sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Ratri Sallet +1",
            hands = "Ratri Gadlings +1",
            neck = "Abyssal Beads +2",
            waist = "Sailfi Belt +1",
            feet = { name = "Ratri Sollerets +1", priority = 10 }
        })
    sets.precast.WS['Cross Reaper'].Acc = set_combine(sets.precast.WS.Acc,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })
    sets.precast.WS['Cross Reaper'].Mod = set_combine(sets.precast.WS,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })

    sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Insurgency'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Insurgency'].Mod = set_combine(sets.precast.WS['Insurgency'], {})

    sets.precast.WS['Catastrophe'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Ratri Sallet +1",
            neck = "Abyssal Beads +2",
            hands = "Ratri Gadlings +1",
            waist = "Sailfi Belt +1",
            ear2 = "Lugra Earring +1",
            feet = { name = "Ratri Sollerets +1", priority = 10 }
        })
    sets.precast.WS['Catastrophe'].Acc = set_combine(sets.precast.WS.Acc,
        {
            head = "Ratri Sallet +1",
            ear2 = "Lugra Earring +1",
            hands = "Ratri Gadlings +1",
            feet = { name = "Ratri Sollerets +1", priority = 10 }
        })
    sets.precast.WS['Catastrophe'].Mod = set_combine(sets.precast.WS['Catastrophe'],
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })

    sets.precast.WS['Nightmare Scythe'] = set_combine(sets.precast.WS.Low, {})
    sets.precast.WS['Nightmare Scythe'].Acc = set_combine(sets.precast.WS.Low, {})
    sets.precast.WS['Nightmare Scythe'].Mod = set_combine(sets.precast.WS.Low, {})

    -- Greatsword WS's
    sets.precast.WS['Shockwave'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Shockwave'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Shockwave'].Mod = set_combine(sets.precast.WS['Shockwave'], {})

    sets.precast.WS['Spinning Slash'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Spinning Slash'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Spinning Slash'].Mod = set_combine(sets.precast.WS['Spinning Slash'], {})

    sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Ground Strike'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ground Strike'].Mod = set_combine(sets.precast.WS['Ground Strike'], {})

    sets.precast.WS['Torcleaver'] = set_combine(sets.precast.WS.SingleHit, {
        neck = "Abyssal Beads +2",
        hands = "Sakpata's Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.torcleaver_cape,
        waist = "Fotia Belt"
    })
    sets.precast.WS['Torcleaver'].Acc = set_combine(sets.precast.WS.Acc,
        { hands = "Sakpata's Gauntlets", back = gear.torcleaver_cape, waist = "Fotia Belt" })
    sets.precast.WS['Torcleaver'].Mod = set_combine(sets.precast.WS['Torcleaver'],
        { head = gear.torcleaver_helm, back = gear.torcleaver_cape })

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS.MultiHit, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Resolution'].Mod = set_combine(sets.precast.WS['Resolution'], {})

    -- Greataxe WS's
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.MultiHit, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS.Acc, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Upheaval'].Mod = set_combine(sets.precast.WS['Upheaval'], { ear2 = "Moonshade Earring" })

    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS.SingleHit,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Fell Cleave'].Acc = set_combine(sets.precast.WS.Acc,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Fell Cleave'].Mod = set_combine(sets.precast.WS['Fell Cleave'],
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })

    sets.precast.WS['Full Break'] = set_combine(sets.precast.WS.SingleHit, {
        head = "Heathen's Burgeonet +2",
        neck = "Abyssal Beads +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary Earring",
        body = "Heathen's Cuirass +2",
        hands = "Heathen's Gauntlets +2",
        ring1 = "Chirich Ring +1",
        ring2 = "Moonlight Ring",
        back = gear.melee_cape,
        waist = "Fotia Belt",
        legs = "Heathen's Flanchard +2",
        feet = "Heathen's Sollerets +2"
    })
    sets.precast.WS['Armor Break'] = sets.precast.WS['Full Break']

    sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS.SingleHit,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Steel Cyclone'].Acc = set_combine(sets.precast.WS.Acc,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Steel Cyclone'].Mod = set_combine(sets.precast.WS['Steel Cyclone'],
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })

    sets.precast.WS['Keen Edge'] = set_combine(sets.precast.WS.Low, {})
    sets.precast.WS['Keen Edge'].Acc = set_combine(sets.precast.WS.Low, {})
    sets.precast.WS['Keen Edge'].Mod = set_combine(sets.precast.WS.Low, {})

    -- Axe WS's
    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS.Crit, {})
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Rampage'].Mod = set_combine(sets.precast.WS.Mod, {})

    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Decimation'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Decimation'].Mod = set_combine(sets.precast.WS.Mod, {})

    sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Bora Axe'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Bora Axe'].Mod = set_combine(sets.precast.WS.Mod, {})

    sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Ruinator'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ruinator'].Mod = set_combine(sets.precast.WS.Mod, {})

    -- Sword WS's
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit, {})

    -- Club WS's
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS.SingleHit, {})

    -- Magical Weaponskills
    sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS.Magic,
        { head = "Pixie Hairpin +1", ring1 = "Archon Ring" })
    sets.precast.WS['Infernal Scythe'] = set_combine(sets.precast.WS['Shadow of Death'], {
        ammo = "Pemphredo Tathlum",
        head = "Heathen's Burgeonet +2",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Crepuscular Earring",
        body = "Heathen's Cuirass +2",
        hands = "Heathen's Gauntlets +2",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heathen's Flanchard +2",
        feet = "Heathen's Sollerets +2",
    })

    sets.precast.WS['Gale Axe'] = sets.precast.WS.Magic

    sets.precast.WS['Burning Blade'] = sets.precast.WS.Low
    sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Burning Blade']
    sets.precast.WS['Shining Blade'] = sets.precast.WS['Burning Blade']
    sets.precast.WS['Seraph Blade'] = sets.precast.WS['Burning Blade']
    sets.precast.WS['Sanguine Blade'] = sets.precast.WS['Shadow of Death']

    sets.precast.WS['Frostbite'] = sets.precast.WS.Magic
    sets.precast.WS['Freezebite'] = sets.precast.WS['Frostbite']

    sets.precast.WS['Shining Strike'] = sets.precast.WS.Magic
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Shining Strike']
    sets.precast.WS['Flash Nova'] = sets.precast.WS['Shining Strike']


    -- Sets to return to when not performing an action.

    -------------------------------------------------------------------------------------------------------------------
    -- Resting sets
    -------------------------------------------------------------------------------------------------------------------
    sets.resting = {
        neck = "Bathy Choker +1",
        body = "Lugra Cloak +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Austerity belt +1"
    }

    -------------------------------------------------------------------------------------------------------------------
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    -------------------------------------------------------------------------------------------------------------------

    sets.idle.Town = {
        ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.melee_cape,
        waist = "Blacksmith's Belt",
        legs = "Carmine Cuisses +1",
        feet = "Sakpata's Leggings"
    }

    sets.idle.Field = set_combine({}, {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Defending Ring",
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Sakpata's Leggings"
    })

    sets.idle.Weak = {
        ammo = "Staunch Tathlum +1",
        head = empty,
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Lugra Cloak +1",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Sakpata's Leggings"
    }

    sets.idle.PDT = set_combine(sets.idle.Field, {
        ammo = "Brigantia Pebble",
        head = "Sakpata's Helm",
        bodywa = "Sakpata's Plate"
    })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Reraise = sets.idle.Weak

    sets.idle.Refresh = set_combine(sets.idle.Field,
        { body = "Lugra Cloak +1", ring1 = gear.left_stikini, ring2 = gear.right_stikini })

    -------------------------------------------------------------------------------------------------------------------
    -- Defense sets
    -------------------------------------------------------------------------------------------------------------------
    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Gelatinous Ring +1",
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.defense.Reraise = {
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Moonlight Ring",
        back = gear.melee_cape,
        waist = "Flume Belt0 +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Archon Ring",
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.Kiting = { head = "Sakpata's Helm", body = "Sakpata's Plate", feet = "Carmine Cuisses +1" }

    sets.Reraise = { head = "Crepuscular Helm", body = "Crepuscular Mail" }


    -------------------------------------------------------------------------------------------------------------------
    -- Precast Sets
    -------------------------------------------------------------------------------------------------------------------

    -- 80 FC, 6 QC
    sets.precast.FC = {
        ammo = "Sapience Orb",
        head = "Carmine Mask +1",
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = { name = "Sacro Breastplate", priority = 10 },
        hands = "Leyline Gloves",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Lebeche Ring",
        back = gear.casting_cape,
        legs = "Enif Cosciales",
        feet = "Odyssean Greaves"
    }

    -- if hasso is active, you would need FC130
    -- this is but a humble 85, not worth using until a lot more gear is available
    sets.precast.FC.Hasso = {
        ammo = "Sapience Orb",
        head = "Carmine Mask +1",
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = "Odyssean Chestplate",
        hands = "Leyline Gloves",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Kishar Ring",
        back = gear.casting_cape,
        legs = "Enif Cosciales",
        feet = "Odyssean Greaves"
    }

    sets.precast['Impact'] = set_combine(sets.precast.FC['Elemental Magic'], {
        head = empty, body = "Crepuscular cloak", ring2 = "Kishar Ring"
    })
    sets.precast.FC['Impact'] = sets.precast.Impact

    sets.precast.FC['Dark Magic'] = sets.precast.FC
    sets.precast.FC['Drain III'] = set_combine(sets.precast.FC['Dark Magic'], { neck = "Unmoving Collar +1", })
    sets.precast.FC['Drain II'] = sets.precast.FC['Drain III']
    sets.precast.FC['Drain'] = sets.precast.FC['Drain III']

    -------------------------------------------------------------------------------------------------------------------
    -- Midcast Sets
    -------------------------------------------------------------------------------------------------------------------
    sets.midcast.FastRecast = {
        ammo = "Sapience Orb",
        head = "Carmine Mask +1",
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = "Sacro Breastplate",
        hands = "Leyline Gloves",
        ring1 = "Kishar Ring",
        ring2 = "Rahab Ring",
        back = gear.casting_cape,
        waist = "Sailfi Belt +1",
        legs = "Limbo Trousers",
        feet = "Carmine Greaves +1"
    }

    sets.midcast.Trust = sets.SIRD

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast.FastRecast, {
        head = "Carmine Mask +1",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Vor Earring",
        body = "Heathen's Cuirass +2",
        hands = "Heathen's Gauntlets +2",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heathen's Flanchard +2",
        feet = "Heathen's Sollerets +2"
    })


    sets.midcast['Dark Magic'] = {
        ammo = "Pemphredo Tathlum",
        head = "Ignominy Burgonet +3",
        neck = "Incanter's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Carm. Sc. Mail +1",
        hands = "Fallen's Finger Gauntlets +3",
        ring1 = "Evanescence Ring",
        ring2 = "Archon Ring",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heathen's Flanchard +2",
        feet = { name = "Ratri Sollerets +1", priority = 10 }
    }
    sets.midcast['Dark Magic'].DarkSeal = set_combine(sets.midcast['Dark Magic'], { head = "Fallen's Burgeonet +3" })
    sets.midcast['Dark Magic'].Weapon = { main = "Void Scythe", sub = "Caecus Grip" }

    sets.midcast['Endark'] = set_combine(sets.midcast['Dark Magic'],
        {
            back = "Niht Mantle",
            ear1 = "Dark Earring",
            legs = "Heathen's Flanchard +2",
            ring2 = gear.right_stikini,
            waist = "Casso Sash"
        })
    sets.midcast['Endark II'] = sets.midcast['Endark']
    sets.midcast['Endark'].Weapon = { main = "Void Scythe", sub = "Caecus Grip" }

    sets.midcast['Endark'].DarkSeal = set_combine(sets.midcast['Endark'], { head = "Fallen's Burgeonet +3" })
    sets.midcast['Endark II'].DarkSeal = sets.midcast['Endark'].DarkSeal

    sets.midcast['Drain'] = set_combine(sets.midcast['Dark Magic'], {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        ear1 = "Hirudinea earring",
        ear2 = "Mani Earring",
        body = "Carmine Scale Mail +1",
        hands = "Fallen's Finger Gauntlets +3",
        back = "Niht Mantle",
        waist = gear.DrainWaist,
        feet = gear.yorium.drain.feet
    })
    sets.midcast['Drain II'] = sets.midcast['Drain']
    sets.midcast['Drain III'] = set_combine(sets.midcast['Dark Magic'], {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        ear1 = "Hirudinea earring",
        ear2 = "Nehalennia Earring",
        body = "Carmine Scale Mail +1",
        hands = "Fallen's Finger Gauntlets +3",
        back = "Niht Mantle",
        waist = gear.DrainWaist,
        feet = { name = "Ratri Sollerets +1", priority = 10 }
    })
    sets.midcast['Drain III'].DarkSeal = set_combine(sets.midcast['Drain III'], { head = "Fallen's Burgeonet +3" })
    sets.midcast['Aspir'] = sets.midcast.Drain
    sets.midcast['Aspir II'] = sets.midcast.Aspir
    sets.midcast['Drain'].Weapon = { main = "Dacnomania", sub = "Dark Grip" }

    sets.midcast.Stun = {
        ammo = "Pemphredo Tathlum",
        head = "Ignominy Burgonet +3",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Carmine Scale Mail +1",
        hands = "Fallen's Finger Gauntlets +3",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heathen's Flanchard +2",
        feet = "Ratri Sollerets +1",
    }

    sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'],
        { head = "Ignominy Burgonet +3", back = gear.casting_cape, ring1 = gear.left_stikini, ring2 = "Metamorph Ring +1" })
    sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, { hands = "Heathen's Gauntlets +1" })

    sets.midcast['Dread Spikes'] = set_combine(sets.HP_High,
        {
            main = "Crepuscular Scythe",
            swarub = "Utu Grip",
            head = "Ratri sallet +1",
            body = "Heathen's Cuirass +2",
            hands = "Rat. Gadlings +1",
            feet = "Rat. sollerets +1"
        })
    sets.midcast['Dread Spikes'].Weapon = { main = "Crepuscular Scythe", sub = "Utu Grip" }

    sets.midcast['Poison'] = sets.midcast['Enfeebling Magic']
    sets.midcast['Poison'].TH = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
    sets.midcast['Poisonga'] = sets.midcast['Enfeebling Magic']
    sets.midcast['Poisonga'].TH = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
    sets.midcast['Absorb-CHR'] = sets.midcast.Absorb
    sets.midcast['Absorb-CHR'].TH = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)

    -- Elemental Magic sets
    sets.midcast['Elemental Magic'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Friomisi Earring",
        body = "Nyame Mail",
        hands = "Fallen's Finger Gauntlets +3",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.casting_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'],
        { head = empty, body = "Crepuscular Cloak", ring2 = gear.right_stikini })

    -------------------------------------------------------------------------------------------------------------------
    -- Engaged sets
    -------------------------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    sets.weapons = { main = gear.MainHand, sub = gear.SubHand }
    sets.TwoHand_OH = { sub = "Utu Grip" }
    sets.OneHand_OH = { sub = "Blurred Shield +1" }

    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Brutal earring",
        ear2 = "Telos Earring",
        body = "Sakpata's Plate",
        hands = "Flamma Manopolas +2",
        ring1 = "Moonlight ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Flamma Gambieras +2"
    }
    sets.engaged.Acc = {
        ammo = "Seething Bomblet +1",
        head = "Flamma Zucchetto +2",
        neck = "Abyssal Beads +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight ring",
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Flamma Gambieras +2"
    }
    sets.engaged.SubtleBlow = {
        neck = "Bathy Choker +1",
        ear2 = "Dignitary's Earring",
        body = "Dagon Breastplate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Chirich Ring +1",
        ring2 = "Niqmaddu Ring",
    }
    sets.engaged.AccHigh = set_combine(sets.engaged.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Brutal earring",
        ear2 = "Telos Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Acc.PDT = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.AccHigh.PDT = set_combine(sets.engaged.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.SubtleBlow.PDT = {}
    sets.engaged.AccHigh.PDT = {}
    sets.engaged.Reraise = {
        ammo = "Coiste Bodhar",
        head = "Crepuscular Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Brutal earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Acc.Reraise = {
        ammo = "Seething Bomblet +1",
        head = "Crepuscular Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.SubtleBlow.Reraise = {}
    sets.engaged.AccHigh.Reraise = set_combine(sets.engaged.Acc.Reraise, { hands = "Gazu Bracelet +1" })

    -- Dual Wield sets
    sets.engaged.DW = sets.engaged
    sets.engaged.Acc.DW = sets.engaged.Acc
    sets.engaged.SubtleBlow.DW = sets.engaged.SubtleBlow
    sets.engaged.AccHigh.DW = sets.engaged.AccHigh
    sets.engaged.PDT.DW = sets.engaged.PDT
    sets.engaged.Acc.PDT.DW = sets.engaged.Acc.PDT
    sets.engaged.SubtleBlow.PDT.DW = sets.engaged.SubtleBlow.PDT
    sets.engaged.AccHigh.PDT.DW = sets.engaged.AccHigh.PDT
    sets.engaged.Reraise.DW = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.DW = sets.engaged.Acc.Reraise
    sets.engaged.SubtleBlow.Reraise.DW = sets.engaged.SubtleBlow.Reraise
    sets.engaged.AccHigh.Reraise.DW = sets.engaged.AccHigh.Reraise

    -- Apocalypse
    sets.engaged.Apocalypse = set_combine(sets.engaged, {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Niqmaddu Ring",
        feet = "Flamma Gambieras +2"
    })
    sets.engaged.Apocalypse.Acc = set_combine(sets.engaged.Apocalypse, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Apocalypse.SubtleBlow = set_combine(sets.engaged.Apocalypse, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Apocalypse.AccHigh = set_combine(sets.engaged.Apocalypse.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.Apocalypse.PDT = sets.engaged.PDT
    sets.engaged.Apocalypse.Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged.Apocalypse.SubtleBlow.PDT = sets.engaged.SubtleBlow.PDT
    sets.engaged.Apocalypse.AccHigh.PDT = set_combine(sets.engaged.Apocalypse.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.Apocalypse.Reraise = sets.engaged.Reraise
    sets.engaged.Apocalypse.Acc.Reraise = sets.engaged.Acc.Reraise
    sets.engaged.Apocalypse.SubtleBlow.Reraise = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Apocalypse.AccHigh.Reraise = set_combine(sets.engaged.Apocalypse.Acc.Reraise,
        { hands = "Gazu Bracelet +1" })

    sets.engaged.Apocalypse.AM = sets.engaged.Apocalypse
    sets.engaged.Apocalypse.Acc.AM = sets.engaged.Apocalypse.Acc
    sets.engaged.Apocalypse.SubtleBlow.AM = sets.engaged.Apocalypse.SubtleBlow
    sets.engaged.Apocalypse.AccHigh.AM = sets.engaged.Apocalypse.AccHigh
    sets.engaged.Apocalypse.PDT.AM = sets.engaged.Apocalypse.PDT
    sets.engaged.Apocalypse.Acc.PDT.AM = sets.engaged.Apocalypse.Acc.PDT
    sets.engaged.Apocalypse.SubtleBlow.PDT.AM = sets.engaged.Apocalypse.SubtleBlow.PDT
    sets.engaged.Apocalypse.AccHigh.PDT.AM = sets.engaged.Apocalypse.AccHigh.PDT
    sets.engaged.Apocalypse.Reraise.AM = sets.engaged.Apocalypse.Reraise
    sets.engaged.Apocalypse.Acc.Reraise.AM = sets.engaged.Apocalypse.Acc.Reraise
    sets.engaged.Apocalypse.SubtleBlow.Reraise.AM = sets.engaged.Apocalypse.SubtleBlow.Reraise
    sets.engaged.Apocalypse.AccHigh.Reraise.AM = sets.engaged.Apocalypse.AccHigh.Reraise

    -- -- Ragnarok
    -- sets.engaged.Ragnarok = sets.engaged
    -- sets.engaged.Acc.Ragnarok = sets.engaged.Acc
    -- sets.engaged.PDT.Ragnarok = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Ragnarok = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Ragnarok = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Ragnarok = sets.engaged.Acc.Reraise

    -- sets.engaged.Ragnarok.AM = sets.engaged
    -- sets.engaged.Acc.Ragnarok.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Ragnarok.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Ragnarok.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Ragnarok.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Ragnarok.AM = sets.engaged.Acc.Reraise

    -- Caladbolg
    sets.engaged.Caladbolg = set_combine(sets.engaged, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Caladbolg.Acc = set_combine(sets.engaged.Acc, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Caladbolg.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {})
    sets.engaged.Caladbolg.AccHigh = set_combine(sets.engaged.Caladbolg.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {})
    sets.engaged.Caladbolg.PDT = sets.engaged.PDT
    sets.engaged.Caladbolg.Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged.Caladbolg.SubtleBlow.PDT = sets.engaged.SubtleBlow.PDT
    sets.engaged.Caladbolg.AccHigh.PDT = set_combine(sets.engaged.Caladbolg.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.Reraise = sets.engaged.Reraise
    sets.engaged.Caladbolg.Acc.Reraise = sets.engaged.Acc.Reraise
    sets.engaged.Caladbolg.SubtleBlow.Reraise = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Caladbolg.AccHigh.Reraise = set_combine(sets.engaged.Caladbolg.Acc.Reraise,
        { hands = "Gazu Bracelet +1" })

    sets.engaged.Caladbolg.AM = set_combine(sets.engaged, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Caladbolg.Acc.AM = set_combine(sets.engaged.Acc, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Caladbolg.AccHigh.AM = set_combine(sets.engaged.Caladbolg.Acc.AM, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.PDT.AM = sets.engaged.PDT
    sets.engaged.Caladbolg.Acc.PDT.AM = sets.engaged.Acc.PDT
    sets.engaged.Caladbolg.SubtleBlow.PDT.AM = sets.engaged.SubtleBlow.PDT
    sets.engaged.Caladbolg.AccHigh.PDT.AM = set_combine(sets.engaged.Caladbolg.Acc.PDT.AM, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.Reraise.AM = sets.engaged.Reraise
    sets.engaged.Caladbolg.Acc.Reraise.AM = sets.engaged.Acc.Reraise
    sets.engaged.Caladbolg.SubtleBlow.Reraise.AM = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Caladbolg.AccHigh.Reraise.AM = set_combine(sets.engaged.Caladbolg.Acc.Reraise.AM,
        { hands = "Gazu Bracelet +1" })

    sets.engaged.Caladbolg.AM3 = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Regal Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Caladbolg.Acc.AM3 = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Crepuscular Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Caladbolg.SubtleBlow.AM3 = set_combine(sets.engaged.Caladbolg.SubtleBlow, {})
    sets.engaged.Caladbolg.AccHigh.AM3 = set_combine(sets.engaged.Caladbolg.Acc.AM3, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.PDT.AM3 = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Caladbolg.Acc.PDT.AM3 = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Crepuscular Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Moonlight Ring",
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Caladbolg.SubtleBlow.PDT.AM3 = set_combine(sets.engaged.Caladbolg.SubtleBlow, {})
    sets.engaged.Caladbolg.AccHigh.PDT.AM3 = set_combine(sets.engaged.Caladbolg.Acc.PDT.AM3,
        { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.Reraise.AM3 = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Regal Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Caladbolg.Acc.Reraise.AM3 = {
        ammo = "Seething Bomblet +1",
        head = "Crepuscular Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Brutal Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = "Niqmaddu Ring",
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Caladbolg.SubtleBlow.Reraise.AM3 = set_combine(sets.engaged.Caladbolg.SubtleBlow.Reraise, {})
    sets.engaged.Caladbolg.AccHigh.Reraise.AM3 = set_combine(sets.engaged.Caladbolg.Acc.Reraise.AM3,
        { hands = "Gazu Bracelet +1" })

    -- -- Liberator
    -- sets.engaged.Liberator = sets.engaged
    -- sets.engaged.Acc.Liberator = sets.engaged.Acc
    -- sets.engaged.PDT.Liberator = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Liberator = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Liberator = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Liberator = sets.engaged.Acc.Reraise

    -- sets.engaged.Liberator.AM = sets.engaged
    -- sets.engaged.Acc.Liberator.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Liberator.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Liberator.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Liberator.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Liberator.AM = sets.engaged.Acc.Reraise

    -- sets.engaged.Liberator.AM = sets.engaged
    -- sets.engaged.Acc.Liberator.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Liberator.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Liberator.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Liberator.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Liberator.AM = sets.engaged.Acc.Reraise

    -- -- Redemption
    -- sets.engaged.Redemption = sets.engaged
    -- sets.engaged.Acc.Redemption = sets.engaged.Acc
    -- sets.engaged.PDT.Redemption = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Redemption = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Redemption = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Redemption = sets.engaged.Acc.Reraise

    -- sets.engaged.Redemption.AM = sets.engaged
    -- sets.engaged.Acc.Redemption.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Redemption.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Redemption.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Redemption.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Redemption.AM = sets.engaged.Acc.Reraise

    -- sets.engaged.Redemption.AM = sets.engaged
    -- sets.engaged.Acc.Redemption.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Redemption.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Redemption.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Redemption.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Redemption.AM = sets.engaged.Acc.Reraise

    -- -- Anguta
    -- sets.engaged.Anguta = sets.engaged
    -- sets.engaged.Acc.Anguta = sets.engaged.Acc
    -- sets.engaged.PDT.Anguta = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Anguta = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Anguta = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Anguta = sets.engaged.Acc.Reraise

    -- sets.engaged.Anguta.AM = sets.engaged
    -- sets.engaged.Acc.Anguta.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Anguta.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Anguta.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Anguta.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Anguta.AM = sets.engaged.Acc.Reraise

    -- sets.engaged.Anguta.AM = sets.engaged
    -- sets.engaged.Acc.Anguta.AM = sets.engaged.Acc
    -- sets.engaged.PDT.Anguta.AM = sets.engaged.PDT
    -- sets.engaged.Acc.PDT.Anguta.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Reraise.Anguta.AM = sets.engaged.Reraise
    -- sets.engaged.Acc.Reraise.Anguta.AM = sets.engaged.Acc.Reraise

    -- Father Time
    sets.engaged['Father Time'] = sets.engaged
    sets.engaged.Acc['Father Time'] = sets.engaged.Acc
    sets.engaged.PDT['Father Time'] = sets.engaged.PDT
    sets.engaged.Acc.PDT['Father Time'] = sets.engaged.Acc.PDT
    sets.engaged.Reraise['Father Time'] = sets.engaged.Reraise
    sets.engaged.Acc.Reraise['Father Time'] = sets.engaged.Acc.Reraise

    --more weapons here

    -- Low Damage/Omen objectives
    sets.engaged.Low = {
        ammo = "Seething Bomblet +1",
        head = "Flamma Zucchetto +2",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Sacro Plate",
        hands = "Gazu Bracelet +1",
        ring1 = "Regal Ring",
        ring2 = "Moonlight Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignomingy Flanchard +3",
        feet = "Flamma Gambieras +2"
    }
    sets.engaged.Low.Acc = sets.engaged.Low
    sets.engaged.Low.SubtleBlow = sets.engaged.Low
    sets.engaged.Low.PDT = sets.engaged.Low
    sets.engaged.Low.Acc.PDT = sets.engaged.Low
    sets.engaged.Low.SubtleBlow.PDT = sets.engaged.Low
    -- sets.engaged.Low.AccHigh.PDT = sets.engaged.Low
    sets.engaged.Low.Reraise = sets.engaged.Low
    sets.engaged.Low.Acc.Reraise = sets.engaged.Low
    sets.engaged.Low.SubtleBlow.Reraise = sets.engaged.Low
    -- sets.engaged.Low.AccHigh.Reraise = sets.engaged.Low

    -------------------------------------------------------------------------------------------------------------------
    -- Buff specific sets
    -------------------------------------------------------------------------------------------------------------------
    sets.buff['Souleater'] = { head = "Ignominy Burgonet +3" }
    sets.buff['Arcane Circle'] = { feet = "Ignominy Sollerets +1" }
    sets.buff['Nether Void'] = { legs = "Heathen's Flanchard +2" }
    sets.buff['Dark Seal'] = { head = "Fallen's Burgeonet +3" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    if spell.type == 'WeaponSkill' then
        local main = player.equipment.main
        cancel_spell()
        -- weapon agnostic remap
        if spell.english == "Catastrophe" then
            if main == 'Caladbolg' then
                send_command('input /ws "Torcleaver" ' .. spell.target.raw)
            elseif main == 'Lycurgos' or main == "Hepatizon Axe" or main == "Hepatizon Axe +1" then
                send_command('input /ws "Steel Cyclone" ' .. spell.target.raw)
            elseif main == 'Naegling' or main == 'Ridill' then
                send_command('input /ws "Savage Blade" ' .. spell.target.raw)
            elseif main == 'Loxotic Mace +1' then
                send_command('input /ws "Judgment" ' .. spell.target.raw)
            end
        elseif spell.english == "Cross Reaper" then
            if main == 'Caladbolg' then
                send_command('input /ws "Ground Strike" ' .. spell.target.raw)
            elseif main == 'Lycurgos' or main == "Hepatizon Axe" or main == "Hepatizon Axe +1" then
                send_command('input /ws "Upheaval" ' .. spell.target.raw)
            elseif main == 'Naegling' then
                send_command('input /ws "Sanguine Blade" ' .. spell.target.raw)
            end
        elseif spell.english == "Entropy" then
            if main == 'Caladbolg' then
                send_command('input /ws "Resolution" ' .. spell.target.raw)
            elseif main == 'Lycurgos' or main == "Hepatizon Axe" or main == "Hepatizon Axe +1" then
                send_command('input /ws "Fell Cleave" ' .. spell.target.raw)
            end
            -- elseif spell.english == "Insurgency" then
            -- elseif spell.english == "Guillotine" then
            -- elseif spell.english == "Quietus" then
        elseif spell.english == "Nightmare Scythe" then
            if main == 'Lycurgos' or main == "Hepatizon Axe" or main == "Hepatizon Axe +1" then
                send_command('input /ws "Keen Edge" ' .. spell.target.raw)
            end
        elseif spell.english == "Infernal Scythe" then
            if main == 'Lycurgos' then
                send_command('input /ws "Armor Break" ' .. spell.target.raw)
            elseif main == 'Hepatizon Axe' or main == 'Hepatizon Axe +1' then
                send_command('input /ws "Full Break" ' .. spell.target.raw)
            end
        end
    elseif spell.type == 'JobAbility' then
        if player.sub_job == 'DRG' then
            cancel_spell()
            if spell.english == 'Hasso' then
                send_command('input /ja "High Jump" ' .. spell.target.raw)
            elseif spell.english == 'Sekkanoki' then
                send_command('input /ja "Super Jump" ' .. spell.target.raw)
            end
        elseif player.sub_job == 'NIN' then
            cancel_spell()
            if spell.english == 'Hasso' then
                send_command('input /ma "Utsusemi: Ni" <me>')
            elseif spell.english == 'Sekkanoki' then
                send_command('input /ma "Utsusemi: Ichi" <me>')
            end
        end
    end

    -- if spell.english == 'Torcleaver' then
    --     if main == 'Naegling' then
    --         send_command('input /ws "Savage Blade" ' .. spell.target.raw)
    --     elseif main == 'Apocalypse' then
    --         send_command('input /ws "Catastrophe" ' .. spell.target.raw)
    --     elseif main == 'Loxotic Mace +1' then
    --         send_command('input /ws "Judgment" ' .. spell.target.raw)
    --     elseif main == 'Karambit' then
    --         send_command('input /ws "Asuran Fists" ' .. spell.target.raw)
    --     end
    -- end
end

-- function job_pretarget(spell, action, spellMap, evtArgs)

-- end

function job_precast(spell, action, spellMap, eventArgs)
    -- set this so we know what to come back to later
    --info.recastWeapon = player.equipment.main
    if buffactive['Dark Seal'] then
        equip(set_combine(sets.precast.FC, sets.buff['Dark Seal']))
    end

    setRecast()
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    local ability_recast = windower.ffxi.get_ability_recasts()
    if (spell.action_type:lower() == 'magic') then
        if player.status == 'Idle' then
            if (state.Buff['Hasso'] and (ability_recast[138] == 0 or ability_recast[138] == nil)) then
                --cast_delay(0.3)
                send_command('cancel hasso')
            end
        end
    elseif spell.type:lower() == 'weaponskill' then
        if info.TP_scaling_ws:contains(spell.english) and info.TP.new > 2999 then
            -- kinda messy, but will equip moonshade with either lugra or a specific sets
            -- earring if lugra exists in the first ear slot.
            if sets.precast.WS[spell.english].ear1 == sets.precast.WS.FullTP.ear2 then
                equip(sets.precast[spell.english].FullTP)
            else
                equip(sets.precast.WS.FullTP)
            end
        end
    end

    if buffactive['Dark Seal'] and spell.skill == 'Dark Magic' then
        equip(sets.buff['Dark Seal'])
    end
end

--Commented out because it is largely unused, but may be used in the future.
--function job_midcast(spell, action, spellMap, eventArgs)
--end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Lock reraise items
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end

    -- Treasure Hunter handling
    if state.TreasureMode.value == 'Tag' and S { 'Poisonga', 'Poison', 'Absorb-CHR' }:contains(spell.english) then
        equip(sets.midcast[spell.english].TH)
    end

    -- Dark seal handling
    if spell.skill == 'Dark Magic' and buffactive['Dark Seal'] then
        if spell.english == 'Drain III' then
            equip(sets.midcast['Drain III'].DarkSeal)
            -- we're not interested in the relic bonus for these spells
        elseif S { 'Drain', 'Drain II', 'Aspir', 'Aspir II', 'Dread Spikes' }:contains(spell.english) then
            equip(sets.midcast[spell.english])
        elseif S { 'Endark', 'Endark II' }:contains(spell.english) then
            equip(sets.midcast['Endark'].DarkSeal)
        else
            equip(sets.midcast['Dark Magic'].DarkSeal)
        end
    end

    -- Weapon swap handling
    if spell.skill == 'Dark Magic' and player.tp < 1000 then
        if S { 'Drain', 'Drain II', 'Drain III', 'Aspir', 'Aspir II' }:contains(spell.english) and
            (sets.midcast['Drain'].Weapon.main ~= player.equipment.main) then
            setRecast()
            equip(sets.midcast['Drain'].Weapon)
            -- do not change weapons if AM3 is up
        elseif S { 'Endark', 'Endark II' }:contains(spell.english) and
            (sets.midcast['Endark'].Weapon.main ~= player.equipment.main) and not buffactive['Aftermath: Lv.3'] then
            setRecast()
            equip(sets.midcast['Endark'].Weapon)
        elseif spell.english == 'Dread Spikes' and (sets.midcast['Dread Spikes'].Weapon.main ~= player.equipment.main)
            and not buffactive['Aftermath: Lv.3'] then
            setRecast()
            equip(sets.midcast['Dread Spikes'].Weapon)
        end
    end

    if S { 'Dread Spikes', 'Drain II', 'Drain III', 'Endark', 'Endark II' }:contains(spell.english) or
        spell.english:startswith('Absorb') then
        adjust_timers_darkmagic(spell, spellMap)
    end

    if S { 'enabled', 'one-time' }:contains(state.SIRDMode.value) then
        equip(set_combine(sets.SIRD, sets.midcast['Dread Spikes'].Weapon))
        if state.SIRDMode.value == 'one-time' then state.SIRDMode:reset() end
    end

    if S { 'Stun' }:contains(spell.english) and state.StunMode.value == 'Enmity' then
        equip(sets.enmity)
        if player.tp < 1000 then
            equip(sets.enmity.Weapon)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- set AM level in aftercast, this is needed for some reason because job_buff gets eaten.
    if spell.type == 'WeaponSkill' and info.Weapons.REMA:contains(player.equipment.main) and
        info.AM.potential > info.AM.level then
        info.AM.level = info.AM.potential
        classes.CustomMeleeGroups:clear()
        if data.weaponskills.relic[player.equipment.main] then
            if data.weaponskills.relic[player.equipment.main] == spell.english then
                classes.CustomMeleeGroups:append('AM')
            end
        elseif data.weaponskills[info.Weapons.REMA.Type[player.equipment.main]][player.equipment.main] then
            if data.weaponskills[info.Weapons.REMA.Type[player.equipment.main]][player.equipment.main] == spell.english then
                if info.AM.potential == 1 then
                    classes.CustomMeleeGroups:append('AM')
                elseif info.AM.potential == 2 then
                    classes.CustomMeleeGroups:append('AM')
                elseif info.AM.potential == 3 then
                    classes.CustomMeleeGroups:append('AM3')
                end
            end
        end
    elseif spell.english == 'Dread Spikes' and not spell.interrupted then
        echo('Dread Spikes [' .. calculate_dreadspikes() .. ']')
    end

    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if buffactive.Souleater then equip(sets.buff['Souleater']) end

    -- if we changed weapons, change back.
    if hasRecast() then
        equip(recallRecast())
        resetRecast()
    end

    if buffactive.doom then
        equip(sets.buff.doom)
    end

    eventArgs.handled = false
end

function job_buff_change(buff, gain)
    -- when gaining a buff
    if gain then
        if buff == 'sleep' and player.hp > 50 then
            if not buffactive['charm'] then
                equip(sets.buff.sleep)
            end
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs equip sets.idle.PDT')
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
                if buffactive['Drown'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Rasp'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Frost'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Helix'] then
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
            update_combat_form()
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
        elseif S { 'Dread Spikes', 'Drain II', 'Drain III', 'Endark', 'Endark II' }:contains(buff) or
            buff:startswith('Absorb') then
            send_command('timers delete "' .. buff .. '"')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    procTime(world.time)
    update_combat_form()
    th_update(cmdParams, eventArgs)
    --eventArgs.handled = false

    if buffactive.sleep then
        send_command('gs equip sets.buff.sleep')
    elseif buffactive.terror or buffactive.stun then
        send_command('gs equip sets.idle.PDT')
    elseif buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            send_command('gs equip sets.buff.doom')
        elseif state.DoomMode.value == 'Holy Water' then
            send_command('gs equip sets.buff.doom.HolyWater')
        end
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-- called when state changes are made
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'WeaponMode' then
        update_weapon_mode(newValue)
        --job_update()
    end
end

-- update weapon sets
function update_weapon_mode(w_state)
    gear.MainHand = sets.Weapons[w_state].main
    gear.SubHand = sets.Weapons[w_state].sub

    sets.weapons = { main = gear.MainHand, sub = gear.SubHand }
    equip(sets.weapons)
end

-- select a macro book based on weapon type and subjob
function weapon_macro_book()
    local currentWeapon = player.equipment.main
    local subjob = player.sub_job


    -- ensure it exists, then go there
    if (info.Weapons.Type[currentWeapon] ~= nil or currentWeapon ~= empty) and info.macro_sets.subjobs:contains(subjob) then
        local book = info.macro_sets[info.Weapons.Type[currentWeapon]][subjob].book
        local page = info.macro_sets[info.Weapons.Type[currentWeapon]][subjob].page
        echo('Changing macro book to <' .. book .. ',' .. page .. '>.', 0, 144)
        set_macro_page(page, book)
    end
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

-- reset combat form, or choose a specific weapons combat form. Blind to aftermath
function reset_combat_form()
    local weapon_slot = player.equipment.main
    local sub_slot = player.equipment.sub

    if S { 'NIN', 'DNC' }:contains(player.sub_job) then
        -- change to DW only if mainhanding a one handed weapon and a weapon is equipped in the sub slot
        if info.Weapons.Onehanded:contains(info.Weapons.Type[weapon_slot]) then
            if info.Weapons.Shields:contains(info.Weapons.Type[sub_slot]) or sub_slot == empty then
                state.CombatForm:reset()
            else
                state.CombatForm:set('DW')
            end
        end
    else
        state.CombatForm:reset()
    end
end

-- process time of day changes
function procTime(myTime)
    if isNight() then
        gear.WSEarBrutal = gear.WSNightEar1
        gear.WSEarMoonshade = gear.WSNightEar2
        gear.WSEarThrud = gear.WSNightEar3
    else
        gear.WSEarBrutal = gear.WSDayEar1
        gear.WSEarMoonshade = gear.WSDayEar2
        gear.WSEarThrud = gear.WSDayEar3
    end
end

-- if the mainhand weapon changes, update it so callbacks can tell.
function isMainChanged()
    if info.lastWeapon == player.equipment.main then
        return false
    else
        info.lastWeapon = player.equipment.main
        return true
    end
end

-- initializes weapon recast handler
function initRecast()
    sets._Recast = {}
    info._RecastFlag = false
end

-- sets the Recast weapon set to what is currently equipped
-- affected slots: main sub ranged ammo
function setRecast()
    sets._Recast = {
        main = player.equipment.main,
        sub = player.equipment.sub,
        range = player.equipment.range,
        ammo = player.equipment.ammo
    }
    info._RecastFlag = true
end

-- resets the Recast weapon set to nil
function resetRecast()
    sets._Recast = { main = nil, sub = nil, range = nil, ammo = nil }
    info._RecastFlag = false
end

-- returns the Recast weapon set
function recallRecast()
    return sets._Recast
end

-- returns true if the recast set has been used
function hasRecast()
    return info._RecastFlag
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

-- return true if night
function isNight()
    return (world.time >= 17 * 60 or world.time < 7 * 60)
end

-- get unchangable TP Bonus items, return 0 if we don't know any.
function getWeaponTPBonus()
    local weapon = player.equipment.main
    local sub = player.equipment.sub
    local range = player.equipment.range

    local fencer = getFencerBonus()

    local tp_bonus = 0

    -- check weapon slot items
    if info.Weapons.TPBonus[weapon] then
        if weapon == 'Lycurgos' then
            if player.hp <= 5000 then
                tp_bonus = tp_bonus + (player.hp / 5)
            else
                tp_bonus = tp_bonus + 1000
            end
        else
            tp_bonus = tp_bonus + info.Weapons.TPBonus[weapon]
        end
    end

    -- check ranged slot items
    if info.Weapons.TPBonus[ranged] then
        tp_bonus = tp_bonus + info.Weapons.TPBonus[ranged]
    end
    return tp_bonus
end

function getFencerBonus()
    local fencer = 0
    local bonus = 0

    if player.job == 'WAR' then
        if player.main_job_level >= 97 then
            fencer = 5
        elseif player.main_job_level >= 84 then
            fencer = 4
        elseif player.main_job_level >= 71 then
            fencer = 3
        elseif player.main_job_level >= 58 then
            fencer = 2
        elseif player.main_job_level >= 45 then
            fencer = 1
        end
    elseif player.job == 'BST' then
        if player.main_job_level >= 94 then
            fencer = 3
        elseif player.main_job_level >= 87 then
            fencer = 2
        elseif player.main_job_level >= 80 then
            fencer = 1
        end
    elseif player.job == 'BRD' then
        if player.main_job_level >= 95 then
            fencer = 2
        elseif player.main_job_level >= 85 then
            fencer = 1
        end
    end

    -- calculate but do not add to the tier granted by subjobs
    -- assumes sj is levelled. level your subjobs.
    if player.sub_job == 'WAR' and player.main_job_level >= 90 and fencer == 0 then
        fencer = 1
    end

    -- calculate fencer bonus from gear
    -- TODO:

    -- return fencer + bonus
    if fencer > 8 then fencer = 8 end
    if info.Fencer.JPGift.active then
        bonus = info.Fencer[fencer] + info.Fencer.JPGift.bonus
    else
        bonus = info.Fencer[fencer]
    end
    return bonus
end

-- returns true if tp is overcapping
function isOverMaxTP(tp, perm_bonus_tp, max_tp)
    perm_bonus_tp = perm_bonus_tp or 0
    return (tp + perm_bonus_tp) > (max_tp or 3000)
end

function calculate_dreadspikes()
    local base = player.max_hp
    local base_absorbed = 0.5

    if info.JobPoints.DreadSpikesBonus then base_absorbed = base_absorbed + 0.1 end
    if player.equipment.body == 'Bale Cuirass +1' then base_absorbed = base_absorbed + 0.0625 end
    if player.equipment.body == 'Bale Cuirass +2' then base_absorbed = base_absorbed + 0.125 end
    if player.equipment.body == "Heathen's Cuirass" then base_absorbed = base_absorbed + 0.125 end
    if player.equipment.body == "Heathen's Cuirass +1" then base_absorbed = base_absorbed + 0.175 end
    if player.equipment.body == "Heathen's Cuirass +2" then base_absorbed = base_absorbed + 0.225 end
    if player.equipment.body == "Heathen's Cuirass +3" then base_absorbed = base_absorbed + 0.275 end
    if player.equipment.main == 'Crepuscular Scythe' then base_absorbed = base_absorbed + 0.25 end

    return math.floor(base * base_absorbed)
end

-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers_darkmagic(spell, spellMap)
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

    local dur = calculate_duration_darkmagic(spell.name, spellMap)
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
-- Called from adjust_timers_darkmagic(), which is only called on aftercast().
function calculate_duration_darkmagic(spellName, spellMap)
    local mult = 1
    local base_duration = 0

    if spellMap == 'Absorb' and spellName ~= 'Absorb-Attri' and spellName ~= 'Absorb-TP' then base_duration = 1.5 * 60 end
    --if spellName == 'Bio' then base_duration = 1*60 end
    --if spellName == 'Bio II' then base_duration = 2*60 end
    --if spellName == 'Bio III' then base_duration = 180 end
    if spellName == 'Drain II' then base_duration = 3 * 60 end
    if spellName == 'Drain III' then base_duration = 3 * 60 end
    if spellName == 'Dread Spikes' then base_duration = 3 * 60 end
    if spellName == "Endark" then base_duration = 3 * 60 end
    if spellName == "Endark II" then base_duration = 3 * 60 end

    if player.equipment.feet == 'Ratri Sollerets' then mult = mult + 0.2 end
    if player.equipment.feet == 'Ratri Sollerets +1' then mult = mult + 0.25 end
    if player.equipment.ring1 == 'Kishar Ring' and spellMap == 'Absorb' and spellName ~= 'Absorb-TP' then
        mult = mult +
            0.1
    end
    if player.equipment.ring2 == 'Kishar Ring' and spellMap == 'Absorb' and spellName ~= 'Absorb-TP' then
        mult = mult +
            0.1
    end

    if buffactive.DarkSeal and
        S { 'Abyss Burgeonet +2', "Fallen's Burgeonet", "Fallen's Burgeone +1", "Fallen's Burgeonet +2",
            "Fallen's Burgeonet +3" }:contains(player.equipment.head) then
        mult = mult + (info.JobPoints.DarkSealMerits * 0.1)
    end

    local totalDuration = math.floor(mult * base_duration)

    return totalDuration
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
    then
        return true
    end
end

-- send a message to the game
function echo(msg, verbosity_, chatmode)
    local verbosity = verbosity_ or 0
    local function getVerbosityLevel()
        local vlvl = 0
        if state.Verbose.value == "Normal" then
            vlvl = 0
        elseif state.Verbose.value == 'Verbose' then
            vlvl = 1
        elseif state.Verbose.value == 'Debug' then
            vlvl = 2
        end
        return vlvl
    end

    if getVerbosityLevel() >= verbosity then
        local mode = chatmode or 144
        windower.add_to_chat(mode, msg)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    determine_combat_weapon()

    classes.CustomMeleeGroups:clear()

    if buffactive['Aftermath'] then
        info.AM.level = 1
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.1'] then
        info.AM.level = 1
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.2'] then
        info.AM.level = 2
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.3'] then
        info.AM.level = 3
        classes.CustomMeleeGroups:append('AM3')
    else
        info.AM.level = 0
    end
    reset_combat_form()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    enable('main', 'sub')
    -- Default macro set/book
    -- if player.sub_job == 'SAM' then
    --     set_macro_page(1, 8)
    -- elseif player.sub_job == 'DNC' then
    --     set_macro_page(2, 8)
    -- elseif player.sub_job == 'THF' then
    --     set_macro_page(3, 8)
    -- elseif player.sub_job == 'NIN' then
    --     set_macro_page(4, 8)
    -- elseif player.sub_job == 'WAR' then
    --     set_macro_page(5, 8)
    -- else
    --     set_macro_page(6, 8)
    -- end

    set_macro_page(1, 8)

    send_command("@wait 5;input /lockstyleset 4")
end
