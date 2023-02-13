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
    state.OffenseMode:options('Normal', 'Acc', 'Crit')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.DefenseMode:options('None', 'Physical', 'Magical', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')

    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    gear.WSDayEar1 = "Schere Earring"
    gear.WSDayEar2 = "Crepuscular Earring"
    gear.WSNightEar1 = "Lugra Earring +1"
    gear.WSNightEar2 = "Lugra Earring"

    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17 * 60 or myTime == 7 * 60) and (player.status == 'Idle' or state.Kiting.value) then
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    gear.tp_neck_regular = { name = "War. Beads +2" }
    gear.tp_neck_vim = { name = "War. Beads +2" }
    gear.tp_neck = gear.tp_neck_vim

    send_command('bind numpad4 gs equip sets.Weapons.Sword')
    send_command('bind ^numpad4 gs equip sets.Weapons.Ridill')
    send_command('bind numpad5 gs equip sets.Weapons.Club')
    send_command('bind ^numpad5 gs equip sets.Weapons.Dagger')
    send_command('bind numpad6 gs equip sets.Weapons.Fists')

    send_command('bind numpad7 gs equip sets.Weapons.GAxe')
    send_command('bind ^numpad7 gs equip sets.Weapons.Axe')
    send_command('bind numpad8 gs equip sets.Weapons.Spear')
    send_command('bind numpad9 gs equip sets.Weapons.Staff')


    send_command('bind ^f11 gs c set DefenseMode Reraise')

    send_command('bind ^- gs c cycle DoomMode')
    send_command('bind ^= gs c cycle treasuremode')

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
    windower.unregister_event(ticker)
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
    send_command('unbind numpad6')
    send_command('unbind numpad7')
    send_command('unbind numpad8')
    send_command('unbind numpad9')
    send_command('unbind !`')
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind ^-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    gear.melee_cape = { name = "Cichol's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }
    gear.str_ws_cape = { name = "Cichol's Mantle",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%' }, }
    gear.magic_ws_cape = { name = "Cichol's Mantle",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'Weapon skill damage +10%', } }
    gear.multi_ws_cape = gear.str_ws_cape

    sets.Weapons = {}
    sets.Weapons.Sword = { main = "Naegling", sub = "Blurred Shield +1" }
    sets.Weapons.Ridill = { main = "Ridill", sub = "Blurred Shield +1" }
    sets.Weapons.Dagger = { main = "Crepuscular Knife", sub = "Blurred Shield +1" }
    sets.Weapons.Club = { main = "Loxotic Mace +1", sub = "Blurred Shield +1" }
    sets.Weapons.GAxe = { main = "Chango", sub = "Utu Grip" }
    sets.Weapons.Spear = { main = "Shining One", sub = "Utu Grip" }
    sets.Weapons.Staff = { main = "Xoanon", sub = "Utu Grip" }
    sets.Weapons.Fists = { main = "Karambit" }
    sets.Weapons.Axe = { main = "Dolichenus", sun = "Blurred Shield +1" }


    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt", legs = "Volte Hose", feet = "Volte Boots"
    }

    sets.enmity = { ammo = "Sapience Orb",
        head = "Halitus Helm", neck = "Unmoving Collar +1", ear1 = "Cryptic Earring", ear2 = "Trux Earring",
        body = "Obviation Cuirass +1", hands = "Macabre Gauntlets +1", ring1 = "Supershear Ring", ring2 = "Eihwaz Ring",
        waist = "Trance Belt", legs = "Zoar Subligar +1", feet = gear.yorium.enmity.feet }

    sets.precast.FC = { ammo = "Sapience Orb",
        head = "Sakpata's Helm", neck = "Orunmila's Torque", ear1 = "Enchanter's Earring +1", ear2 = "Loquacious Earring",
        body = "Sacro Breastplate", hands = "Leyline Gloves", ring1 = "Weatherspoon Ring +1", ring2 = "Rahab Ring",
        legs = "Limbo Trousers", feet = "Odyssean Greaves"
    }

    sets.Sleeping = { neck = "Vim Torque +1" }

    sets.buff.doom = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Nicander's Necklace",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring",
        back = gear.DDCape, waist = "Gishdubar Sash", legs = "Shabti Cuisses +1", feet = "Nyame Sollerets" }

    sets.buff.doom.HolyWater = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Nicander's Necklace",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Blenmot's Ring +1", ring2 = "Blenmot's Ring +1",
        back = gear.DDCape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Nyame Sollerets", }

    sets.resist = {}
    sets.resist.death = { main = "Odium",
        ring1 = "Shadow Ring", ring2 = "Eihwaz Ring"
    }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Provoke'] = sets.enmity
    sets.precast.JA['Berserk'] = { body = "Pummeler's Lorica +3", back = "Cichol's Mantle", feet = "Agoge calligae +2" }
    sets.precast.JA['Warcry'] = { head = "Agoge Mask +1" }
    sets.precast.JA['Aggressor'] = { head = "Pummeler's Mask +1", body = "Agoge Lorica +1" }
    sets.precast.JA['Retaliation'] = { hands = "Pummeler's Mufflers +1", legs = "Boii Calligae +1" }
    sets.precast.JA['Warrior\'s Charge'] = { legs = "Agoge Cuisses +2" }
    sets.precast.JA['Tomahawk'] = { ammo = "Throwing Tomahawk", feet = "Agoge calligae +1" }
    sets.precast.JA['Restraint'] = { hands = "Boii Mufflers +2" }
    sets.precast.JA['Blood Rage'] = { body = "Boii Lorica +1" }
    sets.precast.JA['Mighty Strikes'] = { hands = "Agoge Mufflers +1" }


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Knobkierrie",
        head = "Nyame Helm", neck = "Fotia Gorget", ear1 = "Thrud Earring", ear2 = "Moonshade Earring",
        body = "Pummeler's Lorica +3", hands = "Boii Mufflers +2", ring1 = "Epaminondas's Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.str_ws_cape, waist = "Fotia Belt", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings", }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, { ammo = "Seething Bomblet +1",
        head = "Nyame Helm", neck = "Fotia Gorget", ear1 = "Telos Earring", ear2 = "Dignitary Earring",
        body = "Tatanashi Haramaki +1", hands = "Tatenashi Gote +1", ring1 = "Moonlight Ring", ring2 = "Chirich Ring +1",
        back = gear.str_ws_cape, waist = "Fotia Belt", legs = "Tatanashi Haidate +1", feet = "Tatenashi Sune-ate +1"
    })

    sets.precast.WS.MultiHit = { ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm", neck = "Fotia Gorget", ear1 = "Schere Earring", ear2 = "Moonshade Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Regal Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Fotia Belt", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

    sets.precast.WS.Crit = { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", neck = "Fotia Gorget", ear1 = "Schere Earring", ear2 = "Moonshade Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Begrudging Ring", ring2 = "Niqmaddu Ring",
        back = gear.str_ws_cape, waist = "Fotia Belt", legs = "Zoar Subligar +1", feet = "Sakpata's Leggings" }

    sets.precast.WS.Magic = { ammo = "Knobkierrie",
        head = "Nyame Helm", neck = "Sibyl Scarf", ear1 = "Friomisi Earring", ear2 = "Lugra Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Epaminondas's Ring", ring2 = "Regal Ring",
        back = gear.magic_ws_cape, waist = "Eschan Stone", legs = "Nyame Flanchard", feet = "Nyame Sollerets"
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.MultiHit, { ammo = "Seething Bomblet +1",
        ear1 = "Schere Earring",
        ring1 = "Niqmaddu Ring",
    })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck = "Warrior's Bead Necklace +2",
        waist = "Sailfi Belt +1"
    })
    sets.precast.WS['Savage Blade'].MaxTP = { ear2 = "Lugra Earring +1" }

    sets.precast.WS['Cataclysm'] = { ammo = "Knobkierrie",
        head = "Pixie Hairpin +1", neck = "Sibyl Scarf", ear1 = "Lugra Earring +1", ear2 = "Moonshade Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Epaminondas's Ring", ring2 = "Archon Ring",
        back = gear.magic_ws_cape, waist = "Eschan Stone", legs = "Nyame Flanchard", feet = "Nyame Sollerets",
    }
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Cataclysm'], { back = gear.str_ws_cape })

    sets.precast.WS['Impulse Drive'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Stardiver'] = sets.precast.WS['Upheaval']

    sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Retribution'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Asuran Fists'] = sets.precast.WS.Acc






    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Sakpata's Helm",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets",
        legs = "Phorcys Dirs", feet = "Sakpata's Leggings"
    }


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1", ring2 = "Moonlight Ring" }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = { ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles", neck = "Smithy's Torque", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.melee_cape, waist = "Blacksmith's Belt", legs = "Sakpata's Cuisses", feet = "Hermes' sandals" }

    sets.idle.Field = set_combine({}, { ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring2 = "Gelatinous Ring +1", ring1 = "Moonlight Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Sakpata's Cuisses", feet = "Hermes' sandals" })

    sets.idle.Weak = { ammo = "Staunch Tathlum +1",
        head = "Crepuscular Helm", neck = "Loricate Torque +1", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Crepuscular Mail", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

    sets.idle.PDT = set_combine(sets.idle.Field, { head = "Sakpata's Helm", body = "Sakpata's Plate" })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Reraise = sets.idle.Weak
    -- Defense sets
    sets.defense.PDT = { ammo = "Brigantia Pebble",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Tuisto earring", ear2 = "Odnowa Earring +1",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring2 = "Gelatinous Ring +1", ring1 = "Moonlight Ring",
        back = "Reiki Cloak", waist = "Flume Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

    sets.defense.Reraise = { ammo = "Staunch Tathlum +1",
        head = "Crepuscular Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Crepuscular Mail", hands = "Sakpata's Gauntlets", ring2 = "Gelatinous Ring +1", ring1 = "Moonlight Ring",
        back = "Reiki Cloak", waist = "Flume Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings"
    }

    sets.defense.MDT = { ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Tuitso Earring", ear2 = "Odnowa Earring +1",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Shadow Ring", ring2 = "Moonlight Ring",
        back = "Reiki Cloak", waist = "Engraved Belt", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

    sets.Kiting = { feet = "Hermes' Sandals" }

    sets.Reraise = { head = "Crepuscular Helm", body = "Crepuscular Mail" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = { ammo = "Coiste Bodhar",
        head = "Sakpata's Helm", neck = gear.tp_neck, ear1 = "Schere Earring", ear2 = "Boii Earring",
        body = "Tatenashi Haramaki +1", hands = "Tatenashi Gote +1", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Windbuffet Belt +1", legs = "Tatenashi Haidate +1",
        feet = "Tatenashi Sune-ate +1" }
    sets.engaged.Acc = { ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm", neck = gear.tp_neck, ear1 = "Telos Earring", ear2 = "Boii Earring",
        body = "Tatenashi Haramaki +1", hands = "Tatenashi Gote +1", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Ioskeha Belt +1", legs = "Tatenashi Haidate +1", feet = "Tatenashi Sune-ate +1", }
    sets.engaged.Crit = { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", neck = gear.tp_neck, ear1 = "Schere Earring", ear2 = "Boii Earring",
        body = "Tatenashi Haramaki +1", hands = "Flamma Manopolas +2", ring1 = "Moonlight ring", ring2 = "Niqmaddu Ring",
        back = gear.crit_cape, waist = "Sailfi Belt +1", legs = "Zoar Subligar +1", feet = "Thereoid Greaves"
    }
    sets.engaged.PDT = { ammo = "Coiste Bodhar",
        head = "Sakpata's Helm", neck = gear.tp_neck, ear1 = "Schere Earring", ear2 = "Boii Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Kentarch Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Acc.PDT = { ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Telos Earring", ear2 = "Boii Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Ioskeha Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Reraise = { ammo = "Coiste Bodhar",
        head = "Crepuscular Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Crepuscular Mail", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Sailfi Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Acc.Reraise = { ammo = "Seething bomblet +1",
        head = "Crepuscular Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Crepuscular Mail", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Ioskeha Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    -- weapon agnostic remap
    if spell.type == 'WeaponSkill' then
        cancel_spell()
        local main = player.equipment.main
        if spell.english == 'Upheaval' then
            if main == 'Naegling' then
                send_command('input /ws "Savage Blade" ' .. spell.target.raw)
            elseif main == 'Loxotic Mace +1' then
                send_command('input /ws "Judgment" ' .. spell.target.raw)
            elseif main == 'Shining One' then
                send_command('input /ws "Stardiver" ' .. spell.target.raw)
            elseif main == 'Xoanon' then
                send_command('input /ws "Retribution" ' .. spell.target.raw)
            elseif main == 'Karambit' then
                send_command('input /ws "Asuran Fists" ' .. spell.target.raw)
            end
        elseif spell.english == "Ukko's Fury" then
            if main == 'Shining One' then
                send_command('input /ws "Impulse Drive" ' .. spell.target.raw)
            end
        elseif spell.english == "Fell Cleave" then
            if main == "Shining One" then
                send_command('input /ws "Sonic Thrust" ' .. spell.target.raw)
            elseif main == 'Xoanon' then
                send_command('input /ws "Cataclysm" ' .. spell.target.raw)
            end
        end
    elseif spell.type == 'JobAbility' then
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
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if buffactive['Warcry'] and (spell.english == 'Warcry' or spell.english == 'Blood Rage') then
        windower.add_to_chat(144, 'Cancelled: Warcry is active.')
        eventArgs.cancel = true
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and player.tp == 3000 then
        if sets.precast.WS[spell.english] then
            if sets.precast.WS[spell.english].MaxTP then
                equip(sets.precast.WS[spell.english].MaxTP)
            end
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
                equip(sets.Sleeping)
            end
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

windower.register_event('hpp change', function(new_hpp, old_hpp)
    -- print(new_hpp, old_hpp)
    if buffactive.sleep and new_hpp > 10 then return end
    if new_hpp < 80 and old_hpp >= 80 then
        gear.tp_neck.name = gear.tp_neck_regular.name
        send_command('gs c update')
    elseif new_hpp > 80 and old_hpp <= 80 then
        gear.tp_neck.name = gear.tp_neck_vim.name
        send_command('gs c update')
    end
end)
