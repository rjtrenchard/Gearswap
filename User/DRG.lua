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
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    include('augments.lua')
    include('natty_helper_functions.lua')
    include('default_sets.lua')

    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    update_combat_form()

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Halitus Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Trux Earring",
        ear2 = "Cryptic Earring",
        body = "Emet Harness +1",
        ring1 = "Supershear Ring",
        ring2 = "Eihwaz Ring",
        waist = "Trance Belt",
        legs = "Zoar Subligar +1"
    }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Ancient Circle'] = { head = "Myochin Kabuto" }
    sets.precast.JA['Dragonbreaker'] = { hands = "Saotome Kote +2" }
    sets.precast.JA['Super Jump'] = {}
    sets.precast.JA['Spirit Link'] = {}
    sets.precast.JA['Spirit Bond'] = {}
    sets.precast.JA['Jump'] = {}
    sets.precast.JA['High Jump'] = sets.precast.JA['Jump']
    sets.precast.JA['Spirit Jump'] = sets.precast.JA['Jump']
    sets.precast.JA['Soul Jump'] = sets.precast.JA['Jump']

    sets.precast.FC = {
        ammo = "Sapience Orb",
        heads = "Carmine Mask +1",
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Sacro Breastplate",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Rahab Ring",
        legs = "Enif Cosciales",
        feet = "Carmine Greaves +1"
    }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo = "Sonia's Plectrum",
        head = "Sulevia's Mask +1",
        body = "Gleti's Cuirass",
        hands = "Nyame Gauntlets",
        ring1 = "Spiral Ring",
        back = "Iximulew Cape",
        waist = "Caudata Belt",
        legs = "Nyame Flanchard",
        feet = "Gleti's Boots"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Coiste Bodhar",
        head = "Sulevia's Mask +1",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Moonshade Earring",
        body = "Sulevia's Platemail +2",
        hands = "Sulevia's Gauntlets +1",
        ring1 = "Rajas Ring",
        ring2 = "Spiral Ring",
        back = "Atheling Mantle",
        waist = "Fotia Belt",
        legs = "Sulevia's Cuisses +2",
        feet = "Nyame Sollerets"
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, { back = "Letalis Mantle" })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Stardiver'].Mod = set_combine(sets.precast.WS['Stardiver'], {})

    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Impulse Drive'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Impulse Drive'].Mod = set_combine(sets.precast.WS['Impulse Drive'], {})

    sets.precast.WS['Camlann\'s Torment'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Camlann\'s Torment'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Camlann\'s Torment'].Mod = set_combine(sets.precast.WS['Camlann\'s Torment'], {})


    sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Drakesbane'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Drakesbane'].Mod = set_combine(sets.precast.WS['Drakesbane'], {})

    sets.precast.WS['Wheeling Thrust'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS['Wheeling Thrust'], {})

    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Sulevia's Mask +1",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        legs = "Flamma Dirs +2",
        feet = "Gleti's Boots"
    }


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1", ring1 = "Sheltered Ring", ring2 = "Defending Ring" }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = {
        sub = "Utu Grip",
        ammo = "Coiste Bodhar",
        head = "Sulevia's Mask +1",
        neck = "Combatant's Torque",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Sulevia's Platemail +2",
        hands = "Sulevia's Gauntlets +1",
        ring1 = "Sheltered Ring",
        ring2 = "Shneddick Ring +1",
        back = "Atheling Mantle",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Field = {
        head = "Sulevia's Mask +1",
        neck = "Bathy Choker +1",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Sheltered Ring",
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Danzo Sune-ate"
    }

    sets.idle.Weak = {
        head = "Crepuscular Helm",
        neck = "Bathy Choker +1",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Crepuscular Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Sheltered Ring",
        ring2 = "Defending Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Danzo Sune-ate"
    }

    -- Defense sets
    sets.defense.PDT = {
        ammo = "Staunch Tathlum +1",
        head = "Sulevia's Mask +1",
        neck = "Loricate Torque +1",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = gear.DarkRing.physical,
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Gleti's Boots"
    }

    sets.defense.Reraise = {
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Crepuscular Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Defending Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Gleti's Boots"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Sulevia's Mask +1",
        neck = "Loricate Torque +1",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Shadow Ring",
        back = "Engulfer Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Gleti's Boots"
    }

    sets.Kiting = { feet = "Danzo Sune-ate" }

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
        head = "Flamma Zucchetto +2",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Flamma Korazin +2",
        hands = "Flamma Manopolas +2",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = "Atheling Mantle",
        waist = "Sailfi Belt +1",
        legs = "Flamma Dirs +2",
        feet = "Flamma Gambieras +2"
    }
    sets.engaged.Acc = {
        ammo = "Coiste Bodhar",
        head = "Gleti's Mask",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = "Letalis Mantle",
        waist = "Sailfi Belt +1",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots"
    }
    sets.engaged.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sulevia's Mask +1",
        neck = "Loricate Torque +1",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Niqmaddu Ring",
        back = "Iximulew Cape",
        waist = "Sailfi Belt +1",
        legs = "Unkai Haidate +2",
        feet = "Gleti's Boots"
    }
    sets.engaged.Acc.PDT = {
        ammo = "Coiste Bodhar",
        head = "Sulevia's Mask +1",
        neck = "Loricate Torque +1",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Niqmaddu Ring",
        back = "Letalis Mantle",
        waist = "Sailfi Belt +1",
        legs = "Unkai Haidate +2",
        feet = "Gleti's Boots"
    }
    sets.engaged.Reraise = {
        ammo = "Coiste Bodhar",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Gleti's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = "Ik Cape",
        waist = "Sailfi Belt +1",
        legs = "Unkai Haidate +2",
        feet = "Gleti's Boots"
    }
    sets.engaged.Acc.Reraise = {
        ammo = "Coiste Bodhar",
        head = "Crepuscular Helm",
        neck = "Loricate Torque +1",
        ear1 = "Crepuscular Earring",
        ear2 = "Telos Earring",
        body = "Crepuscular Mail",
        hands = "Gleti's Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Niqmaddu Ring",
        back = "Letalis Mantle",
        waist = "Sailfi Belt +1",
        legs = "Unkai Haidate +2",
        feet = "Gleti's Boots"
    }

    -- Melee sets for in Adoulin, which has an extra 10 Save TP for weaponskills.
    -- Delay 450 GK, 35 Save TP => 89 Store TP for a 4-hit (49 Store TP in gear), 2 Store TP for a 5-hit
    --    sets.engaged.Adoulin = {ammo="Coiste Bodhar",
    --        head="Sulevia's Mask +1",neck="Combatant's Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
    --        body="Gorney Haubert +1",hands="Gleti's Gauntlets",ring1="Rajas Ring",ring2="K'ayres Ring",
    --        back="Takaha Mantle",waist="Sailfi Belt +1",legs="Unkai Haidate +2",feet="Gleti's Boots"}]
    --    sets.engaged.Adoulin.Acc = {ammo="Coiste Bodhar",
    --        head="Sulevia's Mask +1",neck="Combatant's Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
    --        body="Unkai Domaru +2",hands="Gleti's Gauntlets",ring1="Rajas Ring",ring2="K'ayres Ring",
    --        back="Letalis Mantle",waist="Sailfi Belt +1",legs="Unkai Haidate +2",feet="Gleti's Boots"}
    --    sets.engaged.Adoulin.PDT = {ammo="Coiste Bodhar",
    --        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Bladeborn Earring",ear2="Steelflash Earring",
    --        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Defending Ring",ring2="K'ayres Ring",
    --        back="Iximulew Cape",waist="Sailfi Belt +1",legs="Unkai Haidate +2",feet="Gleti's Boots"}
    --    sets.engaged.Adoulin.Acc.PDT = {ammo="Coiste Bodhar",
    --        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Bladeborn Earring",ear2="Steelflash Earring",
    --        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Defending Ring",ring2="K'ayres Ring",
    --        back="Letalis Mantle",waist="Sailfi Belt +1",legs="Unkai Haidate +2",feet="Gleti's Boots"}
    --    sets.engaged.Adoulin.Reraise = {ammo="Coiste Bodhar",
    --        head="Crepuscular Helm",neck="Loricate Torque +1",ear1="Bladeborn Earring",ear2="Steelflash Earring",
    --        body="Crepuscular Mail",hands="Gleti's Gauntlets",ring1="Beeline Ring",ring2="K'ayres Ring",
    --        back="Ik Cape",waist="Sailfi Belt +1",legs="Unkai Haidate +2",feet="Gleti's Boots"}
    --    sets.engaged.Adoulin.Acc.Reraise = {ammo="Coiste Bodhar",
    --        head="Crepuscular Helm",neck="Loricate Torque +1",ear1="Bladeborn Earring",ear2="Steelflash Earring",
    --        body="Crepuscular Mail",hands="Gleti's Gauntlets",ring1="Beeline Ring",ring2="K'ayres Ring",
    --        back="Letalis Mantle",waist="Sailfi Belt +1",legs="Unkai Haidate +2",feet="Gleti's Boots"}


    sets.buff.Sekkanoki = { hands = "Unkai Kote +2" }
    sets.buff.Sengikori = { feet = "Unkai Sune-ate +2" }
    sets.buff['Meikyo Shisui'] = { feet = "Sakonji Sune-ate" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main == 'Quint Spear' or player.equipment.main == 'Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" ' .. spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
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
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    --if areas.Adoulin:contains(world.area) and buffactive.ionis then
    --    state.CombatForm:set('Adoulin')
    --else
    state.CombatForm:reset()
    --end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'SAM' then
        set_macro_page(1, 14)
    elseif player.sub_job == 'WAR' then
        set_macro_page(2, 14)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 14)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 14)
    else
        set_macro_page(1, 14)
    end
    send_command("@wait 2; input /lockstyleset 10")
end
