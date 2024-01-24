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
    state.Buff.Souleater = buffactive.Souleater or false

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
    include('default_sets.lua')
    include('helper_functions.lua')

    job_helper()

    state.OffenseMode:options('Normal', 'Acc', 'SubtleBlow')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.DefenseMode:options('None', 'Physical', 'Magical', 'Reraise')
    state.WeaponskillMode:options('Normal', 'PDL', 'AutoPDL', 'Acc')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    state.EnmityMode = M { ['description'] = 'Enmity Mode', 'default', 'Enmity' }
    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }
    state.SIRDMode = M { ['description'] = 'SIRD Mode', 'disabled', 'enabled', 'one-time' }
    state.WeaponMode = M { ['description'] = 'Weapon Mode', 'greatsword', 'scythe', 'greataxe', 'sword', 'club' }
    state.Verbose = M { ['description'] = 'Verbosity', 'Normal', 'Verbose', 'Debug' }
    state.UseCustomTimers = M(false, 'Use Custom Timers')
    state.Quietus = M { ['description'] = 'Quietus Mode', 'Disabled', 'Enabled' }
    state.Quietus:set('Enabled')
    -- state.AutoMacro = M(true, 'Use automatic macro books')

    -- state.AutoMacro:set(false);

    -- enable equipping of PDL set when the buffs are right
    state.WeaponskillMode:set('AutoPDL')

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

    send_command('bind numpad7 gs equip sets.Weapons.Caladbolg ; gs c update_if_weapon')
    send_command('bind numpad8 gs equip sets.Weapons.Liberator ; gs c update_if_weapon')
    send_command('bind ^numpad8 gs equip sets.Weapons.Apocalypse; gs c update_if_weapon')
    send_command('bind numpad9 gs equip sets.Weapons.greataxe; gs c update_if_weapon')
    send_command('bind ^numpad9 gs equip sets.Weapons.greataxe.hepatizon; gs c update_if_weapon')
    send_command('bind numpad4 gs equip sets.Weapons.sword; gs c update_if_weapon')
    send_command('bind ^numpad4 gs equip sets.Weapons.ridill; gs c update_if_weapon')
    send_command('bind numpad6 gs equip sets.Weapons.club; gs c update_if_weapon')
    send_command('bind numpad1 input /ma stun <t>')
    send_command('bind numpad. gs equip sets.HP_High')
    send_command('bind ^numpad1 gs c cycle EnmityMode')
    send_command('bind ^f11 gs c set DefenseMode Reraise')

    gear.default.obi_waist = "Eschan Stone"
    gear.default.drain_waist = "Austerity Belt +1"
    gear.default.cure_waist = "Gishdubar Sash"

    gear.default.trust_ring = "Regal Ring"

    info.lastWeapon = nil

    -- Event driven functions
    ticker = windower.register_event('time change', function(myTime)
        if isMainChanged() then
            -- procSub()
            -- if state.AutoMacro.value then
            --     weapon_macro_book()
            -- end
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

    -- tp_ticker = windower.register_event('tp change', function(new_tp, old_tp)
    --     if old_tp == 3000 or new_tp == 3000 then
    --         info.AM.potential = 3
    --     elseif (new_tp >= 2000 or new_tp < 3000) or (old_tp >= 2000 or old_tp < 3000) then
    --         info.AM.potential = 2
    --     elseif (new_tp >= 1000 or new_tp < 2000) or (old_tp >= 1000 or old_tp < 2000) then
    --         info.AM.potential = 1
    --     else
    --         info.AM.potential = 0
    --     end
    --     info.TP.old = old_tp
    --     info.TP.new = new_tp
    --     -- echo('new: ' .. new_tp .. ' old: ' .. old_tp, 2)
    -- end)

    tp_ticker = windower.register_event('tp change', function(new_tp, old_tp)
        check_FullTP()
        -- update if TP reaches or leaves 3000
        if (old_tp < 3000 and new_tp == 3000)
            or (old_tp == 3000 and new_tp < 3000) then
            send_command('gs c update')
        end
    end)
    echo('Job:' .. player.main_job .. '/' .. player.sub_job .. '.', 2)

    -- state.HybridMode:set('PDT')
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    windower.unregister_event(ticker)
    windower.unregister_event(tp_ticker)

    unbind_numpad()
end

function job_helper()
    info.TP_scaling_ws = S {
        'Spinning Scythe', 'Spiral Hell', 'Cross Reaper', 'Entropy',
        'Spinning Slash', 'Ground Strike', 'Torcleaver', 'Resolution',
        'Upheaval', 'Steel Cyclone', 'Savage Blade', 'Judgment', 'Full Break', 'Infernal Scythe',
        'Insurgency'
    }
    info.Weapons = {}
    info.Weapons.Type = {
        ['Aern Dagger'] = 'dagger',
        ['Aern Dagger II'] = 'dagger',
        ['Naegling'] = 'sword',
        ['Ridill'] = 'sword',
        ['Zulfiqar'] = 'greatsword',
        ['Caladbolg'] = 'greatsword',
        ['Hepatizon Axe +1'] = 'greataxe',
        ['Hepatizon Axe'] = 'greataxe',
        ['Lycurgos'] = 'greataxe',
        ['Kaja Axe'] = 'axe',
        ['Dolichenus'] = 'axe',
        ['Apocalypse'] = 'scythe',
        ['Father Time'] = 'scythe',
        ['Liberator'] = 'scythe',
        ['Redemption'] = 'scythe',
        ['Anguta'] = 'scythe',
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
    info.Weapons.REMA = S { 'Apocalypse', 'Ragnarok', 'Caladbolg', 'Redemption', 'Liberator', 'Anguta',
        'Father Time' }
    info.Weapons.REMA.Type = {
        ['Apocalypse'] = 'relic',
        ['Ragnarok'] = 'relic',
        ['Caladbolg'] = 'empyrean',
        ['Redemption'] = 'empyrean',
        ['Liberator'] = 'mythic',
        ['Anguta'] = 'aeonic',
    }
    info.Weapons.Special = S { 'Naegling' }
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
    gear.melee_cape = {
        name = "Ankou's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Store TP"+10', 'Phys. dmg. taken-10%', }
    }

    gear.ws_cape = {
        name = "Ankou's Mantle",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%' }
    }
    gear.multi_cape = gear.melee_cape
    gear.torcleaver_cape = {
        name = "Ankou's Mantle",
        augments = { 'VIT+20', 'Accuracy+20 Attack+20', 'VIT+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%' }
    }
    gear.entropy_cape =
    {
        name = "Ankou's Mantle",
        augments = { 'INT+20', 'Accuracy+20 Attack+20', 'INT+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%' }
    }
    gear.magic_ws_cape = {
        name = "Ankou's Mantle",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%' },
    }
    gear.casting_cape = {
        name = "Ankou's Mantle",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', '"Fast Cast"+10', 'Spell interruption rate down-10%', }
    }
    gear.SIRD_cape = gear.casting_cape





    -- {
    --     name = "Ankou's Mantle",
    --     augments = { 'INT+20', 'Accuracy+20 Attack+20', 'INT+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', }
    -- }

    -- Mainhand Sets
    sets.Weapons = {}
    sets.Weapons.Caladbolg = { main = "Caladbolg", sub = "Utu Grip" }
    sets.Weapons.Liberator = { main = "Liberator", sub = "Utu Grip" }
    sets.Weapons.greataxe = { main = "Lycurgos", sub = "Utu Grip" }
    sets.Weapons.greataxe.hepatizon = { main = "Hepatizon Axe +1", sub = "Utu Grip" }
    sets.Weapons.sword = { main = "Naegling", sub = "Blurred Shield +1" }
    sets.Weapons.club = { main = "Loxotic Mace +1", sub = "Blurred Shield +1" }
    sets.Weapons.ridill = { main = "Ridill", sub = "Blurred Shield +1" }
    sets.Weapons.Apocalypse = { main = "Apocalypse", sub = "Utu Grip" }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Arcane Circle'] = { feet = "Ignominy Sollerets +1" }
    sets.precast.JA['Weapon Bash'] = { hands = "Ignominy Gauntlets +2" }
    sets.precast.JA['Blood Weapon'] = { body = "Fallen's Cuirass" }
    sets.precast.JA['Dark Seal'] = { head = "Fallen's Burgeonet +3" }
    sets.precast.JA['Diabolic Eye'] = { hands = "Fallen's Finger Gauntlets +3" }
    sets.precast.JA['Souleater'] = { head = "Ignominy Burgonet +3", legs = "Fallen's Flanchard +3" }
    sets.precast.JA['Nether Void'] = { legs = "Heath. Flanchard +3" }
    sets.precast.JA['Provoke'] = sets.enmity

    sets.precast.JA['Jump'] = {
        ammo = "Coiste Bodhar",
        head = "Flamma Zucchetto +2",
        neck = "Abyssal beads +2",
        ear1 = "Telos Earring",
        ear2 = "Schere Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = "Niqmaddu Ring",
        back = gear.stp_cape,
        waist = "Kentarch Belt +1",
        legs = "Volte Tights",
        feet = "Flamma Gambieras +2"

    }
    sets.precast.JA['High Jump'] = sets.precast.JA['Jump']

    -------------------------------------------------------------------------------------------------------------------
    -- Miscellaneous Sets
    -------------------------------------------------------------------------------------------------------------------
    sets.HP_High = {
        ammo = "Happy Egg",
        head = "Ratri sallet +1",
        neck = "Unmoving Collar +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Ignominy Cuirass +3",
        hands = "Rat. Gadlings +1",
        ring1 = gear.left_moonlight,
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
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

    sets.phalanx = {
        legs = "Sakpata's Cuisses",
        feet = gear.yorium.phalanx.feet
    }

    sets.SIRD = {
        ammo = "Staunch Tathlum +1",  -- +11
        head = gear.acro.SIRD.head,   -- 10
        ear2 = "Magnetic Earring",    -- 5
        hands = gear.acro.SIRD.hands, -- 10
        ring1 = gear.dark_ring.SIRD,  -- 4
        ring2 = "Evanescence Ring",   -- 5
        back = gear.SIRD_cape,        -- 10
        legs = "Founder's Hose",      -- 30
        feet = "Odyssean Greaves"     -- 20
    }

    sets.FullTP = {
        ammo = "Coiste Bodhar",
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

    sets.Empyrean = {
        head = "Heathen's burgeonet +3",
        body = "Heathen's Cuirass +3",
        hands = "Heathen's Gauntlets +2",
        legs = "Heath. Flanchard +3",
        feet = "Heathen's Sollerets +3"

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
        hands = "Nyame Gauntlets",
        ring1 = gear.TrustRing,
        ring2 = "Epaminondas's Ring",
        back = gear.ws_cape,
        waist = "Fotia Belt",
        legs = "Fallen's Flanchard +3",
        feet = "Heathen's Sollerets +3"
    }
    sets.precast.WS.FullTP = { ear2 = "Lugra Earring +1" }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        head = "Nyame Helm",
        ear1 = "Telos Earring",
        waist = "Fotia Belt"
    })
    sets.precast.WS.Trust = set_combine(sets.precast.WS, {
        ring1 = "Sroda Ring"
    })

    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        ammo = "Crepuscular Pebble",
        head = "Heathen's burgeonet +3",
        ring1 = "Sroda Ring",
    })

    sets.precast.WS.SingleHit = set_combine(sets.precast.WS,
        { neck = "Abyssal Beads +2", waist = "Sailfi Belt +1" })

    sets.precast.WS.MultiHit = {
        ammo = "Seething Bomblet +1",
        head = "Heathen's burgeonet +3",
        neck = "Abyss Beads +2",
        ear1 = "Schere Earring",
        ear2 = "Lugra Earring +1",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.TrustRing,
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
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Medada's Ring",
        back = gear.ws_cape,
        waist = "Eschan Stone",
        legs = "Fallen's Flanchard +3",
        feet = "Heathen's Sollerets +3"
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
        feet = "Heathen's Sollerets +3"
    }

    sets.precast.WS.Low = {
        ammo = "Seething Bomblet +1",
        head = "",
        neck = "Fotia Gorget",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "",
        hands = "",
        ring1 = gear.left_moonlight,
        ring2 = "Epaminondas's Ring",
        back = gear.melee_cape,
        waist = "Fotia Belt",
        legs = "Carmine Cuisses +1",
        feet = ""
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    -- Scythe Weaponskills
    sets.precast.WS['Spinning Scythe'] = set_combine(sets.precast.WS.SingleHit,
        { head = "Heathen's Burgeonet +3", hands = "Ratri Gadlings +1" })
    sets.precast.WS['Spinning Scythe'].Acc = set_combine(sets.precast.WS.Acc,
        { head = "Heathen's Burgeonet +3", hands = "Ratri Gadlings +1", })

    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Heathen's Burgeonet +3",
            hands = "Ratri Gadlings +1",
        })
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS.Acc,
        { head = "Ratri Sallet +1", hands = "Ratri Gadlings +1", feet = { name = "Ratri Sollerets +1", priority = 10 } })
    sets.precast.WS['Spiral Hell'].PDL = set_combine(sets.precast.WS['Spiral Hell'],
        {
            ammo = "Crepuscular Pebble",
            head = "Heathen's Burgeonet +3",
            ring1 = "Sroda Ring"
        })
    sets.precast.WS['Spiral Hell'].FullTP = {
        ear2 = "Lugra Earring +1", ring2 = "Sroda Ring"
    }

    sets.precast.WS['Entropy'] = set_combine(sets.precast.WS.MultiHit, {
        ammo = "Ghastly Tathlum +1",
        ear1 = "Lugra Earring +1",
        ear2 = "Moonshade Earring",
        ring1 = "Metamorph Ring +1",
        ring2 = "Niqmaddu Ring",
        back = gear.entropy_cape,
        legs = "Ignominy Flanchard +3",
    })
    sets.precast.WS['Entropy'].Acc = set_combine(sets.precast.WS.Acc, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Entropy'].PDL = set_combine(sets.precast.WS['Entropy'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring2 = "Sroda Ring" })
    sets.precast.WS['Entropy'].FullTP = { ear2 = "Malignance Earring" }

    sets.precast.WS['Quietus'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Heathen's Burgeonet +3",
            ear2 = "Lugra Earring +1",
            hands = "Ratri Gadlings +1",
            ring1 = "Niqmaddu Ring",
            back = gear.ws_cape,
            feet = "Heathen's Sollerets +3",

        })
    sets.precast.WS['Quietus'].Acc = set_combine(sets.precast.WS.Acc,
        {
            head = "Heathen's Burgeonet +3",
            hands = "Ratri Gadlings +1",
            ear2 = "Lugra Earring +1"
        })
    sets.precast.WS['Quietus'].PDL = set_combine(sets.precast.WS['Quietus'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring", })

    sets.precast.WS['Guillotine'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Guillotine'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Guillotine'].PDL = set_combine(sets.precast.WS['Guillotine'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring2 = "Sroda Ring" })

    sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Heathen's burgeonet +3",
            hands = "Ratri Gadlings +1",
            neck = "Abyssal Beads +2",
            waist = "Sailfi Belt +1",
            feet = "Heathen's Sollerets +3"
        })
    sets.precast.WS['Cross Reaper'].Acc = set_combine(sets.precast.WS.Acc,
        { head = "Heathen's Burgeonet +3", hands = "Ratri Gadlings +1", feet = "Heathen's Sollerets +3" })
    sets.precast.WS['Cross Reaper'].PDL = set_combine(sets.precast.WS['Cross Reaper'],
        {
            ammo = "Crepuscular Tathlum",
            head = "Heathen's Burgeonet +3",
            ring1 = "Sroda Ring",
        })

    sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS,
        {
            head = "Ratri Sallet +1",
            neck = "Abyssal Beads +2",
            hands = "Ratri Gadlings +1",
            back = gear.ws_cape,
            waist = "Sailfi Belt +1",
        })
    sets.precast.WS['Insurgency'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Insurgency'].PDL = set_combine(sets.precast.WS['Insurgency'], {
        ammo = "Crepuscular Pebble",
        head = "Heathen's burgeonet +3",
        ring1 = "Sroda Ring",
    })
    sets.precast.WS['Insurgency'].FullTP = { ear2 = "Lugra Earring +1" }

    sets.precast.WS['Catastrophe'] = set_combine(sets.precast.WS.SingleHit,
        {
            head = "Ratri Sallet +1",
            neck = "Abyssal Beads +2",
            hands = "Ratri Gadlings +1",
            waist = "Sailfi Belt +1",
            ear2 = "Lugra Earring +1",
            feet = "Heathen's Sollerets +3"
        })
    sets.precast.WS['Catastrophe'].Acc = set_combine(sets.precast.WS.Acc,
        {
            head = "Ratri Sallet +1",
            ear2 = "Lugra Earring +1",
            hands = "Ratri Gadlings +1",
            feet = "Heathen's Sollerets +3"
        })
    sets.precast.WS['Catastrophe'].PDL = set_combine(sets.precast.WS['Catastrophe'], {
        ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring"
    })

    sets.precast.WS['Nightmare Scythe'] = set_combine(sets.precast.WS.Low, {})
    sets.precast.WS['Nightmare Scythe'].Acc = set_combine(sets.precast.WS.Low, {})


    -- Greatsword WS's
    sets.precast.WS['Shockwave'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Shockwave'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Spinning Slash'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Spinning Slash'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Ground Strike'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ground Strike'].PDL = set_combine(sets.precast.WS['Ground Strike'], {
        ammo = "Crepuscular Pebble",
        head = "Heathen's Burgeonet +3",
        ring1 = "Sroda Ring"
    })

    sets.precast.WS['Torcleaver'] = set_combine(sets.precast.WS.SingleHit, {
        neck = "Abyssal Beads +2",
        hands = "Sakpata's Gauntlets",
        back = gear.torcleaver_cape,
        waist = "Fotia Belt"
    })
    sets.precast.WS['Torcleaver'].Acc = set_combine(sets.precast.WS.Acc,
        { hands = "Sakpata's Gauntlets", back = gear.torcleaver_cape, waist = "Fotia Belt" })
    sets.precast.WS['Torcleaver'].PDL = set_combine(sets.precast.WS['Torcleaver'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring", waist = "Sailfi Belt +1" })

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS.MultiHit,
        { head = "Heathen's burgeonet +3", ear2 = "Moonshade Earring" })
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Resolution'].PDL = set_combine(sets.precast.WS['Resolution'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring" })
    sets.precast.WS['Resolution'].FullTP = { ear2 = "Schere Earring" }

    -- Greataxe WS's
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.MultiHit, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS.Acc, { ear2 = "Moonshade Earring" })
    sets.precast.WS['Upheaval'].PDL = set_combine(sets.precast.WS['Upheaval'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring" })
    sets.precast.WS['Upheaval'].FullTP = { ear2 = "Schere Earring" }


    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS.SingleHit,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Fell Cleave'].Acc = set_combine(sets.precast.WS.Acc,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Fell Cleave'].PDL = set_combine(sets.precast.WS['Fell Cleave'],
        { ammo = "Crepuscular Pebble", head = "Heathen's Burgeonet +3", waist = "Sailfi belt +1", ring1 = "Sroda Ring" })

    sets.precast.WS['Full Break'] = set_combine(sets.precast.WS.SingleHit, {
        head = "Heathen's burgeonet +3",
        neck = "Abyssal Beads +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary Earring",
        body = "Heathen's Cuirass +3",
        hands = "Heathen's Gauntlets +2",
        ring1 = gear.left_chirich,
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Fotia Belt",
        legs = "Heath. Flanchard +3",
        feet = "Heathen's Sollerets +3"
    })
    sets.precast.WS['Armor Break'] = sets.precast.WS['Full Break']

    sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS.SingleHit,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Steel Cyclone'].Acc = set_combine(sets.precast.WS.Acc,
        { neck = "Abyssal beads +2", waist = "Sailfi belt +1" })
    sets.precast.WS['Steel Cyclone'].PDL = set_combine(sets.precast.WS['Steel Cyclone'], {
        ammo = "Crepuscular Pebble",
        head = "Heathen's Burgeonet +3",
        ring1 = "Sroda Ring"
    })

    sets.precast.WS['Keen Edge'] = set_combine(sets.precast.WS.Low, {})
    sets.precast.WS['Keen Edge'].Acc = set_combine(sets.precast.WS.Low, {})

    -- Axe WS's
    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS.Crit, {})
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Decimation'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Bora Axe'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Ruinator'].Acc = set_combine(sets.precast.WS.Acc, {})

    -- Sword WS's
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'],
        { ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring" })
    sets.precast.WS['Savage Blade'].FullTP = { ear2 = "Lugra Earring +1" }

    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit, {})

    -- Club WS's
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Judgment'], {
        ammo = "Crepuscular Pebble", head = "Heathen's burgeonet +3", ring1 = "Sroda Ring"
    })
    sets.precast.WS['Judgment'].FullTP = { ear2 = "Lugra Earring +1" }


    -- Magical Weaponskills
    sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS.Magic,
        {
            head = "Pixie Hairpin +1",
            ear1 = "Malignance Earring",
            ear2 = "Moonshade Earring",
            ring1 = "Archon Ring",
            ring2 = "Epaminondas's Ring"
        })

    sets.precast.WS['Shadow of Death'].FullTP = { ear2 = "Friomisi Earring" }

    sets.precast.WS['Infernal Scythe'] = set_combine(sets.precast.WS['Shadow of Death'], {
        ammo = "Pemphredo Tathlum",
        head = "Heathen's burgeonet +3",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Crepuscular Earring",
        body = "Heathen's Cuirass +3",
        hands = "Heathen's Gauntlets +2",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heath. Flanchard +3",
        feet = "Heathen's Sollerets +3",
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

    sets.precast.WS['Aeolian Edge'] = {
        ammo = "Knobkierrie",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Medada's Ring",
        back = gear.magic_ws_cape,
        waist = "Eschan Stone",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }


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
        ear1 = "Infused Earring",
        ear2 = "Brachyura Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = "Moonlight Cape",
        waist = "Blacksmith's Belt",
        legs = "Carmine Cuisses +1",
        feet = "Sakpata's Leggings"
    }

    sets.idle.Field = set_combine({}, {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Infused Earring",
        ear2 = "Brachyura Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Paguroidea Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Sakpata's Leggings"
    })

    sets.idle.Weak = {
        ammo = "Staunch Tathlum +1",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Infused Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Gelatinous Ring +1",
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Sakpata's Leggings"
    }

    sets.idle.PDT = set_combine(sets.idle.Field, {
        ammo = "Brigantia Pebble",
        head = "Sakpata's Helm",
        body = "Adamantite Armor",
        ring1 = "Paguroidea Ring"
    })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Reraise = sets.idle.Weak

    sets.idle.Refresh = set_combine(sets.idle.Field,
        { neck = "Sibyl Scarf", body = "Lugra Cloak +1", ring1 = gear.left_stikini, ring2 = gear.right_stikini })

    sets.idle.Field.Refresh = sets.idle.Refresh

    -------------------------------------------------------------------------------------------------------------------
    -- Defense sets
    -------------------------------------------------------------------------------------------------------------------
    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Sakpata's Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Adamantite Armor",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
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
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Flume Belt0 +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm",
        neck = "Warder's Charm +1",
        ear1 = "Etiolation Earring",
        ear2 = "Eabani Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = "Shadow Ring",
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Platinum Moogle Belt",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }

    sets.Kiting = { legs = "Carmine Cuisses +1" }

    sets.Reraise = { head = "Crepuscular Helm", body = "Crepuscular Mail" }


    -------------------------------------------------------------------------------------------------------------------
    -- Precast Sets
    -------------------------------------------------------------------------------------------------------------------

    -- 80 FC, 6 QC
    sets.precast.FC = {
        ammo = "Sapience Orb",                                -- 2
        head = "Carmine Mask +1",                             -- 14
        neck = "Orunmila's Torque",                           -- 5
        ear1 = "Malignance Earring",                          -- 4
        ear2 = "Loquacious Earring",                          -- 2
        body = { name = "Sacro Breastplate", priority = 10 }, -- 10
        hands = "Leyline Gloves",                             -- 8
        ring1 = "Weatherspoon Ring +1",                       -- 6
        ring2 = "Lebeche Ring",                               -- 0
        back = gear.casting_cape,                             -- 10
        legs = "Enif Cosciales",                              -- 8
        feet = gear.odyssean.fc.feet                          -- 11
    }

    -- if hasso is active, you would need FC130
    -- this is but a humble 85, not worth using until a lot more gear is available
    sets.precast.FC.Hasso = {
        ammo = "Sapience Orb",          -- 2
        head = "Carmine Mask +1",       -- 14
        neck = "Orunmila's Torque",     -- 5
        ear1 = "Malignance Earring",    -- 4
        ear2 = "Loquacious Earring",    -- 2
        body = "Odyssean Chestplate",   -- 11
        hands = "Leyline Gloves",       -- 8
        ring1 = "Weatherspoon Ring +1", -- 6
        ring2 = "Medada's Ring",        -- 10
        back = gear.casting_cape,       -- 10
        legs = "Enif Cosciales",        -- 8
        feet = "Odyssean Greaves"       -- 11
    }

    sets.precast['Impact'] = set_combine(sets.precast.FC['Elemental Magic'], {
        head = empty, body = "Crepuscular cloak", ring2 = "Medada's ring"
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
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Medada's Ring",
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
        body = "Heathen's Cuirass +3",
        hands = "Heathen's Gauntlets +2",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heath. Flanchard +3",
        feet = "Heathen's Sollerets +3"
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
        legs = "Heath. Flanchard +3",
        feet = { name = "Ratri Sollerets +1", priority = 10 }
    }
    sets.midcast['Dark Magic'].DarkSeal = { head = "Fallen's Burgeonet +3" }
    sets.midcast['Dark Magic'].Weapon = { main = "Void Scythe", sub = "Caecus Grip" }

    sets.midcast['Endark'] = set_combine(sets.midcast['Dark Magic'],
        {
            back = "Niht Mantle",
            ear1 = "Dark Earring",
            legs = "Heath. Flanchard +3",
            ring2 = gear.right_stikini,
            waist = "Casso Sash",
        })
    sets.midcast['Endark II'] = sets.midcast['Endark']
    sets.midcast['Endark'].Weapon = { main = "Void Scythe", sub = "Caecus Grip" }

    sets.midcast['Endark'].DarkSeal = set_combine(sets.midcast['Endark'], { head = "Fallen's Burgeonet +3" })
    sets.midcast['Endark II'].DarkSeal = sets.midcast['Endark'].DarkSeal

    sets.midcast['Drain'] = set_combine(sets.midcast['Dark Magic'], {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Erra Pendant",
        -- ear1 = "Hirudinea earring",
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
        -- ear1 = "Hirudinea earring",
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
    sets.midcast['Drain'].Weapon = { main = "Misanthropy", sub = "Dark Grip" }

    sets.midcast.Stun = {
        ammo = "Pemphredo Tathlum",
        head = "Ignominy Burgonet +3",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Carmine Scale Mail +1",
        hands = "Fallen's Finger Gauntlets +3",
        ring1 = "Medada's Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.casting_cape,
        waist = "Eschan Stone",
        legs = "Heath. Flanchard +3",
        feet = "Ratri Sollerets +1",
    }

    sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'],
        {
            head = "Ignominy Burgonet +3",
            neck = "Erra Pendant",
            hands = "Vicious Mufflers",
            ring2 = "Medada's Ring",
            ring1 = "Kishar Ring",
            back = "Chuparrosa Mantle",
            feet = "Ratri Sollerets +1"
        })
    sets.midcast.Absorb.Weapon = { main = "Liberator", sub = "Khonsu" }
    sets.midcast.Absorb.DarkSeal = { head = "Fallen's Burgeonet +3" }
    sets.midcast['Absorb-TP'] = set_combine(sets.midcast['Dark Magic'],
        {
            hands = "Heathen's Gauntlets +2",
            ring1 = "Metamorph Ring +1",
            ring2 = "Medada's Ring",
            feet = "Heathen's Sollerets +3"
        })

    sets.midcast['Dread Spikes'] = set_combine(sets.HP_High,
        {
            main = "Crepuscular Scythe",
            sub = "Utu Grip",
            head = "Ratri sallet +1",
            body = "Heathen's Cuirass +3",
            hands = "Rat. Gadlings +1",
            feet = "Rat. sollerets +1"
        })
    sets.midcast['Dread Spikes'].Weapon = { main = "Crepuscular Scythe", sub = "Utu Grip" }

    sets.midcast['Poison'] = sets.midcast['Enfeebling Magic']
    sets.midcast['Poison'].TH = set_combine(sets.SIRD, sets.TreasureHunter)
    sets.midcast['Poisonga'] = sets.midcast['Enfeebling Magic']
    sets.midcast['Poisonga'].TH = {   -- SIRD   TH
        main = "Parashu",             -- 30
        ammo = "Staunch Tathlum +1",  -- 11
        head = "Volte Cap",           -- 0      1
        neck = "Loricate Torque +1",  -- 5
        ear1 = "Hasalz Earring",      -- 5
        ear2 = "Magnetic Earring",    -- 8
        body = gear.acro.SIRD.body,   -- 10
        hands = gear.acro.SIRD.hands, -- 10
        ring1 = gear.dark_ring.SIRD,  -- 4
        ring2 = "Evanescence Ring",   -- 5
        back = gear.SIRD_cape,        -- 10
        waist = "Chaac Belt",         -- 0      1
        legs = "Volte Hose",          -- 0      1
        feet = "Volte Boots"          -- 0      1
    }                                 -- 99     4
    sets.midcast['Absorb-CHR'] = sets.midcast.Absorb
    sets.midcast['Absorb-CHR'].TH = set_combine(sets.SIRD, sets.TreasureHunter)

    -- Elemental Magic sets
    sets.midcast['Elemental Magic'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Friomisi Earring",
        body = "Nyame Mail",
        hands = "Fallen's Finger Gauntlets +3",
        ring1 = "Metamorph Ring +1",
        ring2 = "Medada's Ring",
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
        ear1 = "Telos earring",
        ear2 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Acc = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Flamma Gambieras +2"
    }
    sets.engaged.SubtleBlow = {
        -- neck = "Bathy Choker +1",
        ear2 = "Dignitary's Earring",
        body = "Dagon Breastplate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = "Niqmaddu Ring",
    }
    sets.engaged.AccHigh = set_combine(sets.engaged.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Telos earring",
        ear2 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
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
        ear2 = "Crepuscular Earring",
        ear1 = "Telos Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
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
        ear1 = "Telos earring",
        ear2 = "Brutal Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
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
        ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Crepuscular Mail",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Regal Ring",
        back = gear.melee_cape,
        waist = "Ioskeha Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.SubtleBlow.Reraise = {}
    sets.engaged.AccHigh.Reraise = set_combine(sets.engaged.Acc.Reraise, { hands = "Gazu Bracelet +1" })

    -- Dual Wield sets
    sets.engaged.DW = set_combine(sets.engaged, { ear1 = "Eabani Earring", waist = "Reiki Yotai" })
    sets.engaged.DW.Acc = set_combine(sets.engaged, { ear1 = "Eabani Earring", waist = "Reiki Yotai" })
    sets.engaged.DW.SubtleBlow = set_combine(sets.engaged, { ear1 = "Eabani Earring", waist = "Reiki Yotai" })
    sets.engaged.DW.AccHigh = sets.engaged.AccHigh
    sets.engaged.DW.PDT = sets.engaged.PDT
    sets.engaged.DW.Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged.DW.SubtleBlow.PDT = sets.engaged.SubtleBlow.PDT
    sets.engaged.DW.AccHigh.PDT = sets.engaged.AccHigh.PDT
    sets.engaged.DW.Reraise = sets.engaged.Reraise
    sets.engaged.DW.Acc.Reraise = sets.engaged.Acc.Reraise
    sets.engaged.DW.SubtleBlow.Reraise = sets.engaged.SubtleBlow.Reraise
    sets.engaged.DW.AccHigh.Reraise = sets.engaged.AccHigh.Reraise

    sets.engaged.FullTP = set_combine(sets.engaged, {
        head = "Sakpata's Helm",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        back = gear.melee_cape,
    })
    sets.engaged.Acc.FullTP = set_combine(sets.engaged, { ear2 = "Crepuscular Earring" })
    sets.engaged.SubtleBlow.FullTP = set_combine(sets.engaged, {})
    sets.engaged.AccHigh.FullTP = set_combine(sets.engaged.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.PDT.FullTP = sets.engaged.PDT
    sets.engaged.Acc.PDT.FullTP = sets.engaged.Acc.PDT
    sets.engaged.SubtleBlow.PDT.FullTP = sets.engaged.SubtleBlow.PDT
    sets.engaged.AccHigh.PDT.FullTP = set_combine(sets.engaged.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.Reraise.FullTP = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.FullTP = sets.engaged.Acc.Reraise
    sets.engaged.SubtleBlow.Reraise.FullTP = sets.engaged.SubtleBlow.Reraise
    sets.engaged.AccHigh.Reraise.FullTP = set_combine(sets.engaged.Acc.Reraise,
        { hands = "Gazu Bracelet +1" })

    -- Naegling
    sets.engaged.Naegling = set_combine(sets.engaged, {
    })
    sets.engaged.Naegling.Acc = set_combine(sets.engaged.Naegling, { ear2 = "Brutal Earring" })
    sets.engaged.Naegling.SubtleBlow = set_combine(sets.engaged.Naegling, {
        body = "Dagon Breastplate",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich
    })
    sets.engaged.Naegling.AccHigh = set_combine(sets.engaged.Naegling.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.Naegling.PDT = sets.engaged.PDT
    sets.engaged.Naegling.Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged.Naegling.SubtleBlow.PDT = sets.engaged.SubtleBlow.PDT
    sets.engaged.Naegling.AccHigh.PDT = set_combine(sets.engaged.Naegling.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.Naegling.Reraise = sets.engaged.Reraise
    sets.engaged.Naegling.Acc.Reraise = sets.engaged.Acc.Reraise
    sets.engaged.Naegling.SubtleBlow.Reraise = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Naegling.AccHigh.Reraise = set_combine(sets.engaged.Naegling.Acc.Reraise,
        { hands = "Gazu Bracelet +1" })

    sets.engaged.Naegling.FullTP = set_combine(sets.engaged, {
        head = "Sakpata's Helm",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        back = gear.melee_cape,
    })
    sets.engaged.Naegling.Acc.FullTP = set_combine(sets.engaged.Naegling, { ear2 = "Crepuscular Earring" })
    sets.engaged.Naegling.SubtleBlow.FullTP = set_combine(sets.engaged.Naegling, {})
    sets.engaged.Naegling.AccHigh.FullTP = set_combine(sets.engaged.Naegling.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.Naegling.PDT.FullTP = sets.engaged.PDT
    sets.engaged.Naegling.Acc.PDT.FullTP = sets.engaged.Acc.PDT
    sets.engaged.Naegling.SubtleBlow.PDT.FullTP = sets.engaged.SubtleBlow.PDT
    sets.engaged.Naegling.AccHigh.PDT.FullTP = set_combine(sets.engaged.Naegling.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.Naegling.Reraise.FullTP = sets.engaged.Reraise
    sets.engaged.Naegling.Acc.Reraise.FullTP = sets.engaged.Acc.Reraise
    sets.engaged.Naegling.SubtleBlow.Reraise.FullTP = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Naegling.AccHigh.Reraise.FullTP = set_combine(sets.engaged.Naegling.Acc.Reraise,
        { hands = "Gazu Bracelet +1" })
    -- Apocalypse
    sets.engaged.Apocalypse = set_combine(sets.engaged, {
        head = "Sakpata's Helm",
        ear1 = "Schere Earring",
        ear2 = "Telos Earring",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
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
    sets.engaged.Caladbolg = set_combine(sets.engaged, {
        head = "Flamma Zucchetto +2", ear2 = "Dedition Earring", back = gear.melee_cape })
    sets.engaged.Caladbolg.Acc = set_combine(sets.engaged.Acc, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Caladbolg.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {})
    sets.engaged.Caladbolg.AccHigh = set_combine(sets.engaged.Caladbolg.Acc, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.PDT = set_combine(sets.engaged.Caladbolg, { legs = "Sakpata's Cuisses" })
    sets.engaged.Caladbolg.Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged.Caladbolg.SubtleBlow.PDT = sets.engaged.SubtleBlow.PDT
    sets.engaged.Caladbolg.AccHigh.PDT = set_combine(sets.engaged.Caladbolg.Acc.PDT, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.Reraise = sets.engaged.Reraise
    sets.engaged.Caladbolg.Acc.Reraise = sets.engaged.Acc.Reraise
    sets.engaged.Caladbolg.SubtleBlow.Reraise = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Caladbolg.AccHigh.Reraise = set_combine(sets.engaged.Caladbolg.Acc.Reraise,
        { hands = "Gazu Bracelet +1" })

    sets.engaged.Caladbolg.FullTP = set_combine(sets.engaged.Caladbolg, {
        head = "Sakpata's Helm",
        ear2 = "Brutal Earring",
        back = gear.melee_cape
    })
    sets.engaged.Caladbolg.Acc.FullTP = set_combine(sets.engaged.Acc.FullTP, {})
    sets.engaged.Caladbolg.AccHigh.FullTP = set_combine(sets.engaged.Caladbolg.Acc.FullTP, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.PDT.FullTP = sets.engaged.PDT
    sets.engaged.Caladbolg.Acc.PDT.FullTP = sets.engaged.Acc.PDT
    sets.engaged.Caladbolg.SubtleBlow.PDT.FullTP = sets.engaged.SubtleBlow.PDT
    sets.engaged.Caladbolg.AccHigh.PDT.FullTP = set_combine(sets.engaged.Caladbolg.Acc.PDT.FullTP,
        { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.Reraise.FullTP = sets.engaged.Reraise
    sets.engaged.Caladbolg.Acc.Reraise.FullTP = sets.engaged.Acc.Reraise
    sets.engaged.Caladbolg.SubtleBlow.Reraise.FullTP = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Caladbolg.AccHigh.Reraise.FullTP = set_combine(sets.engaged.Caladbolg.Acc.Reraise.FullTP,
        { hands = "Gazu Bracelet +1" })


    sets.engaged.Caladbolg.AM = set_combine(sets.engaged.Caladbolg, {})
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

    sets.engaged.Caladbolg.AM.FullTP = set_combine(sets.engaged.Caladbolg, {})
    sets.engaged.Caladbolg.Acc.AM.FullTP = set_combine(sets.engaged.Acc, { hands = "Sakpata's Gauntlets" })
    sets.engaged.Caladbolg.AccHigh.AM.FullTP = set_combine(sets.engaged.Caladbolg.Acc.AM, { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.PDT.AM.FullTP = sets.engaged.PDT
    sets.engaged.Caladbolg.Acc.PDT.AM.FullTP = sets.engaged.Acc.PDT
    sets.engaged.Caladbolg.SubtleBlow.PDT.AM.FullTP = sets.engaged.SubtleBlow.PDT
    sets.engaged.Caladbolg.AccHigh.PDT.AM.FullTP = set_combine(sets.engaged.Caladbolg.Acc.PDT.AM,
        { hands = "Gazu Bracelet +1" })
    sets.engaged.Caladbolg.Reraise.AM.FullTP = sets.engaged.Reraise
    sets.engaged.Caladbolg.Acc.Reraise.AM.FullTP = sets.engaged.Acc.Reraise
    sets.engaged.Caladbolg.SubtleBlow.Reraise.AM.FullTP = sets.engaged.SubtleBlow.Reraise
    sets.engaged.Caladbolg.AccHigh.Reraise.AM.FullTP = set_combine(sets.engaged.Caladbolg.Acc.Reraise.AM,
        { hands = "Gazu Bracelet +1" })

    sets.engaged.Caladbolg.AM3 = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear2 = "Telos Earring",
        ear1 = "Brutal Earring",
        body = "Dagon Breastplate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
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
        body = "Dagon Breastplate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
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
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi belt +1",
        legs = "Sakpata's Cuisses",
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
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
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
        ring1 = gear.left_moonlight,
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
    sets.engaged.Liberator = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Telos earring",
        ear2 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Liberator.SubtleBlow = set_combine(sets.engaged.Liberator, {
        ear2 = "Dignitary Earring",
        body = "Dagon Breastplate"
    })
    sets.engaged.Liberator.Acc = sets.engaged.Acc
    sets.engaged.Liberator.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sakpata's Helm",
        neck = "Abyssal Beads +2",
        ear1 = "Telos earring",
        ear2 = "Brutal Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Ignominy Flanchard +3",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Liberator.Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged.Liberator.Reraise = sets.engaged.Reraise
    sets.engaged.Liberator.Acc.Reraise = sets.engaged.Acc.Reraise

    sets.engaged.Liberator.AM = sets.engaged
    sets.engaged.Liberator.Acc.AM = sets.engaged.Acc
    sets.engaged.Liberator.PDT.AM = sets.engaged.PDT
    sets.engaged.Liberator.Acc.PDT.AM = sets.engaged.Acc.PDT
    sets.engaged.Liberator.Reraise.AM = sets.engaged.Reraise
    sets.engaged.Liberator.Acc.Reraise.AM = sets.engaged.Acc.Reraise

    sets.engaged.Liberator.AM3 = {
        ammo = "Coiste Bodhar",
        head = "Flamma Zucchetto +2",
        neck = "Abyssal Beads +2",
        ear1 = "Telos Earring",
        ear2 = "Dedition Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Liberator.SubtleBlow.AM3 = set_combine(sets.engaged.Liberator.AM3,
        { body = "Dagon Breastplate", ear1 = "Dignitary Earring" })
    sets.engaged.Liberator.Acc.AM3 = set_combine(sets.engaged.Liberator.AM3,
        { ear2 = "Crepuscular Earring" })
    sets.engaged.Liberator.PDT.AM3 = {
        ammo = "Coiste Bodhar",
        head = "Flamma Zucchetto +2",
        neck = "Abyssal Beads +2",
        ear1 = "Telos Earring",
        ear2 = "Dedition Earring",
        body = "Sakpata's Plate",
        hands = "Sakpata's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Sakpata's Cuisses",
        feet = "Sakpata's Leggings"
    }
    sets.engaged.Liberator.Acc.PDT.AM3 = set_combine(sets.engaged.Liberator.PDT.AM3,
        { ear2 = "Crepuscular Earring" })
    sets.engaged.Liberator.Reraise.AM3 = sets.engaged.Reraise.Liberator
    sets.engaged.Liberator.Acc.Reraise.AM3 = sets.engaged.Acc.Reraise.Liberator

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
    -- sets.engaged.Anguta.Acc = sets.engaged.Acc
    -- sets.engaged.Anguta.PDT = sets.engaged.PDT
    -- sets.engaged.Anguta.Acc.PDT = sets.engaged.Acc.PDT
    -- sets.engaged.Anguta.Reraise = sets.engaged.Reraise
    -- sets.engaged.Anguta.Acc.Reraise = sets.engaged.Acc.Reraise

    -- sets.engaged.Anguta.AM = sets.engaged
    -- sets.engaged.Anguta.Acc.AM = sets.engaged.Acc
    -- sets.engaged.Anguta.PDT.AM = sets.engaged.PDT
    -- sets.engaged.Anguta.Acc.PDT.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Anguta.Reraise.AM = sets.engaged.Reraise
    -- sets.engaged.Anguta.Acc.Reraise.AM = sets.engaged.Acc.Reraise

    -- sets.engaged.Anguta.AM = sets.engaged
    -- sets.engaged.Anguta.Acc.AM = sets.engaged.Acc
    -- sets.engaged.Anguta.PDT.AM = sets.engaged.PDT
    -- sets.engaged.Anguta.Acc.PDT.AM = sets.engaged.Acc.PDT
    -- sets.engaged.Anguta.Reraise.AM = sets.engaged.Reraise
    -- sets.engaged.Anguta.Acc.Reraise.AM = sets.engaged.Acc.Reraise

    -- Father Time
    sets.engaged['Father Time'] = sets.engaged
    sets.engaged['Father Time'].Acc = sets.engaged.Acc
    sets.engaged['Father Time'].PDT = sets.engaged.PDT
    sets.engaged['Father Time'].Acc.PDT = sets.engaged.Acc.PDT
    sets.engaged['Father Time'].Reraise = sets.engaged.Reraise
    sets.engaged['Father Time'].Acc.Reraise = sets.engaged.Acc.Reraise

    --more weapons here

    -- Low Damage/Omen objectives
    sets.engaged.Low = {
        ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Sacro Plate",
        hands = "Gazu Bracelet +1",
        ring1 = "Regal Ring",
        ring2 = gear.right_moonlight,
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
    sets.buff['Nether Void'] = { legs = "Heath. Flanchard +3" }
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
            if main == 'Liberator' then
                send_command('input /ws "Insurgency"' .. spell.target.raw)
            elseif main == 'Caladbolg' then
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
                send_command('input /ws "Shockwave" ' .. spell.target.raw)
            elseif main == 'Lycurgos' or main == "Hepatizon Axe" or main == "Hepatizon Axe +1" then
                send_command('input /ws "Fell Cleave" ' .. spell.target.raw)
            elseif main == 'Naegling' then
                send_command('input /ws "Sanguine Blade" ' .. spell.target.raw)
            elseif main == 'Parashu' then
                send_command('gs equip sets.weapons.greataxe; gs update_if_weapon')
            end
        elseif spell.english == "Entropy" then
            if main == 'Caladbolg' then
                send_command('input /ws "Resolution" ' .. spell.target.raw)
            elseif S { "Hepatizon Axe", "Hepatizon Axe +1", "Lycurgos", }:contains(main) then
                send_command('input /ws "Upheaval" ' .. spell.target.raw)
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
            if spell.english == 'Hasso' then
                cancel_spell()
                send_command('input /ma "Utsusemi: Ni" <me>')
            elseif spell.english == 'Sekkanoki' then
                cancel_spell()
                send_command('input /ma "Utsusemi: Ichi" <me>')
            end
        end
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    -- remaps last resort to hasso/berserk if it is not ready to use
    if spell.english == 'Last Resort' then
        local ability_recast = windower.ffxi.get_ability_recasts()
        local LastResortID = 87
        if ability_recast[LastResortID] > 0 then
            if player.sub_job == 'SAM' and not buffactive['Last Resort'] then
                eventArgs.cancel = true
                windower.add_to_chat(36, 'Remapping Last Resort to Hasso')
                send_command('input /ja Hasso <me>')
            elseif player.sub_job == 'WAR' and not buffactive['Last Resort'] then
                eventArgs.cancel = true
                windower.add_to_chat(36, 'Remapping Last Resort to Berserk')
                send_command('input /ja Berserk <me>')
            end
        end
    end

    -- if spell.english == 'Quietus'
    --     and state.Quietus.value == 'Enabled'
    --     and player.tp >= 1000
    --     and not buffactive['Consume Mana']
    --     and windower.ffxi.get_ability_recasts()[95] == 0 then
    --     eventArgs.cancel = true
    --     send_command('input /ja "Consume Mana" <me>')
    -- end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type ~= "WeaponSkill" then set_recast() end

    if spell.type == 'JobAbility' and (not spell.english:endswith('Jump')) and state.EnmityMode.value == 'Enmity' then
        equip(sets.enmity)
    end

    if buffactive['Dark Seal'] and spell.skill == 'Dark Magic' then
        equip(set_combine(sets.precast.FC, sets.buff['Dark Seal']))
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if buffactive['Dark Seal'] and spell.skill == 'Dark Magic' then
        equip(sets.buff['Dark Seal'])
    elseif spell.type == 'WeaponSkill' then
        if player.tp == 3000 and sets.precast.WS[spell.english] and sets.precast.WS[spell.english].FullTP then
            if has_PDL_buffs(buffactive) and state.WeaponskillMode.value == 'AutoPDL' then
                equip_PDL_WS_set(spell)
            end
            -- equip moonshade with either lugra or a specific sets
            -- earring if lugra exists in the first ear slot.
            if sets.precast.WS[spell.english] and sets.precast.WS[spell.english].ear1 and sets.precast.WS[spell.english].ear2 and sets.precast.WS[spell.english].ear1 == sets.precast.WS.FullTP.ear2 then
                equip(sets.precast[spell.english].FullTP)
            else
                equip(sets.precast.WS.FullTP)
            end
        elseif player.tp == 3000 and not sets.precast.WS[spell.english] and sets.precast.WS.FullTP then
            equip(sets.precast.WS.FullTP)
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- print(spell.english:startswith("Absorb") and spell.english ~= 'Absorb-TP')
    -- Lock reraise items
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end

    -- Treasure Hunter handling
    if state.TreasureMode.value == 'Tag' and S { 'Poisonga', 'Poison', 'Absorb-CHR' }:contains(spell.english) then
        equip(sets.midcast[spell.english].TH)
    end

    -- Weapon swap handling
    if spell.skill == 'Dark Magic' and player.tp < 600 and not buffactive['Aftermath: Lv.3'] then -- < 600 is a good number, as it wont eat a full meditate
        if S { 'Drain', 'Drain II', 'Drain III', 'Aspir', 'Aspir II' }:contains(spell.english) then
            equip(sets.midcast['Drain'].Weapon)
        elseif spell.english:startswith('Endark') then
            equip(sets.midcast['Endark'].Weapon)
        end
    elseif spell.english == 'Dread Spikes' then
        equip(sets.midcast['Dread Spikes'].Weapon)
    end

    if spell.english:startswith('Absorb') and spell.english ~= 'Absorb-TP' then
        equip(sets.midcast.Absorb)

        -- equip liberator for absorb under these conditions
        if not buffactive['Aftermath: Lv.3']
            and player.tp < 800
            and spell.english ~= 'Absorb-TP'
            and spell.english ~= 'Absorb-Attri' then
            equip(sets.midcast.Absorb.Weapon)
        end
    end

    -- Dark seal handling
    if spell.skill == 'Dark Magic' and buffactive['Dark Seal'] then
        -- we're not interested in the relic bonus for these spells
        if spell.english:startswith('Absorb') or spell.english == 'Drain' or spell.english == 'Dread Spikes' then
            equip(sets.midcast[spell.english])
        elseif spell.english == 'Drain III' then
            equip(sets.midcast['Drain III'].DarkSeal)
        elseif spell.english:startswith('Endark') then
            equip(sets.midcast['Endark'].DarkSeal)
        elseif spell.english:startswith('Absorb') and spell.english ~= 'Absorb-TP' then
            equip(sets.midcast['Dark Magic'], sets.midcast.Absorb, sets.midcast.Absorb.DarkSeal)
        else
            equip(sets.midcast['Dark Magic'].DarkSeal)
        end
    end

    if S { 'enabled', 'one-time' }:contains(state.SIRDMode.value) then
        equip(set_combine(sets.SIRD, sets.midcast['Dread Spikes'].Weapon))
        if state.SIRDMode.value == 'one-time' then state.SIRDMode:reset() end
    end

    if S { 'Stun' }:contains(spell.english) and state.EnmityMode.value == 'Enmity' then
        equip(sets.enmity)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- if spell.english == 'Dread Spikes' and not spell.interrupted then
    if spell.english == 'Dread Spikes' then
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

    equip_recast()

    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end
end

function job_buff_change(buff, gain)
    -- when gaining a buff
    if gain then
        if buff == 'sleep' and player.hp > 50 then
            if not buffactive['charm'] then
                equip(sets.buff.sleep)
                if buffactive['Stoneskin'] and has_poison_debuff(buffactive) then send_command('cancel stoneskin') end
            end
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        elseif S { 'stun', 'petrification', 'terror' }:contains(buff) then
            send_command('gs equip sets.defense.PDT')
        elseif buff == 'charm' then
            if buffactive['Aftermath: Lv.3'] then
                if has_poison_debuff(buffactive) then
                    send_command('input /p Charmed, I have AM3, and I cannot be slept. Good luck with that.')
                else
                    send_command('input /p Charmed and I have AM3.')
                end
            else
                if has_poison_debuff(buffactive) then
                    send_command('input /p Charmed and I cannot be slept.')
                else
                    send_command('input /p Charmed.')
                end
            end
        elseif 'Aftermath: Lv.3' == buff then
            classes.CustomMeleeGroups:append('AM3')
            send_command('gs c update')
        elseif S { 'Aftermath', 'Aftermath: Lv.1', 'Aftermath: Lv.2' }:contains(buff) then
            classes.CustomMeleeGroups:append('AM')
            send_command('gs c update')
        end

        -- when losing a buff
    else
        if buff == 'doom' and player.hpp > 0 then
            send_command('input /p Doom off.')
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off.')
        elseif S { 'sleep', 'stun', 'petrification', 'terror' }:contains(buff) then
            send_command('gs c update')
        elseif S { 'Aftermath', 'Aftermath: Lv.1', 'Aftermath: Lv.2', 'Aftermath: Lv.3' }:contains(buff) then
            classes.CustomMeleeGroups:clear()
            check_FullTP()
            -- reset_combat_form()
            -- send_command('wait 0.1;gs c update')
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
    check_FullTP()
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
    local msg = 'Melee'

    if state.CombatWeapon and state.CombatWeapon.value ~= "" then
        msg = msg .. ' (' .. state.CombatWeapon.value .. ')'
    end

    msg = msg .. ': ' .. state.OffenseMode.value

    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end

    if state.TreasureMode.value == 'Tag' then
        msg = msg .. '/TH'
    end

    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end

    if classes.CustomMeleeGroups:contains('AM3') then
        msg = msg .. ' (AM3)'
    elseif classes.CustomMeleeGroups:contains('AM') then
        msg = msg .. ' (AM)'
    end

    if classes.CustomMeleeGroups:contains('FullTP') then
        msg = msg .. ' (FullTP)'
    end

    msg = msg .. ',  WS: ' .. state.WeaponskillMode.value

    msg = msg .. ',  Doom: ' .. state.DoomMode.value

    msg = msg .. ',  Stun: ' .. state.EnmityMode.value



    add_to_chat(122, msg)
    eventArgs.handled = true
end

-- called when state changes are made
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'WeaponMode' then
        update_weapon_mode(newValue)
    end
end

-- update weapon sets
function update_weapon_mode(w_state)
    gear.MainHand = sets.weapons[w_state].main
    gear.SubHand = sets.weapons[w_state].sub

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
    if info.Weapons.REMA:contains(player.equipment.main) or info.Weapons.Special:contains(player.equipment.main) then
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
    if spellName == 'Drain II' then base_duration = 3 * 60 end
    if spellName == 'Drain III' then base_duration = 3 * 60 end
    if spellName == 'Dread Spikes' then base_duration = 3 * 60 end
    if spellName == "Endark" then base_duration = 3 * 60 end
    if spellName == "Endark II" then base_duration = 3 * 60 end

    if player.equipment.feet == 'Ratri Sollerets' then mult = mult + 0.2 end
    if player.equipment.feet == 'Ratri Sollerets +1' then mult = mult + 0.25 end
    if player.equipment.ring1 == 'Kishar Ring' and spellMap == 'Absorb' and spellName ~= 'Absorb-TP' then
        mult = mult + 0.1
    end
    if player.equipment.ring2 == 'Kishar Ring' and spellMap == 'Absorb' and spellName ~= 'Absorb-TP' then
        mult = mult + 0.1
    end

    if buffactive.DarkSeal and
        S { 'Abyss Burgeonet +2', "Fallen's Burgeonet", "Fallen's Burgeonet +1", "Fallen's Burgeonet +2",
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
    if category == 2 or                                            -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or                         -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
    then
        return true
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'update_if_weapon' then
        update_if_weapon(player.equipment.main)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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

function am_combat_form()

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 8)

    send_command("@wait 5;input /lockstyleset 4")
end
