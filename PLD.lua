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
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('PDT', 'Normal',  'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')
    
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')

    gear.WSDayEar1 = "Brutal Earring"
    gear.WSDayEar2 = "Cessance Earring"
    gear.WSNightEar1 = "Lugra Earring +1"
    gear.WSNightEar2 = "Lugra Earring"

    gear.WSEarBrutal = {name=gear.WSDayEar1}
    gear.WSEarCessance = {name=gear.WSDayEar2}

    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17*60 or myTime == 7*60) then 
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    update_defense_mode()
    select_default_macro_book()
end

function procTime(myTime) 
    if isNight() then
        gear.WSEarBrutal = gear.WSNightEar1
        gear.WSEarCessance = gear.WSNightEar2
        gear.MovementFeet = gear.NightFeet
    else
        gear.WSEarBrutal = gear.WSDayEar1
        gear.WSEarCessance = gear.WSDayEar2
        gear.MovementFeet = gear.DayFeet
    end
end
    
function isNight()
        return (world.time >= 17*60 or world.time < 7*60)
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches"}
    sets.precast.JA['Holy Circle'] = {feet="Sulevia's Leggings +2"}
    sets.precast.JA['Shield Bash'] = {hands="Caballarius Gauntlets"}
    sets.precast.JA['Sentinel'] = {feet="Caballarius Leggings"}
    sets.precast.JA['Rampart'] = {head="Caballarius Coronet"}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat"}
    sets.precast.JA['Divine Emblem'] = {feet="Creed Sabatons +2"}
    sets.precast.JA['Cover'] = {head="Sulevia's Mask +1"}

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Sulevia's Mask +1",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Leviathan Ring",ring2="Aquasoul Ring",
        back="Weard Mantle",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Sulevia's Mask +1",ear1="Thrud Earring",ear2="Handler's Earring +1",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring2="Asklepian Ring",
        back="Iximulew Cape",waist="Chaac Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Incantor Stone",
        head="Cizin Helm",ear2="Loquacious Earring",ring1="Kishar Ring",ring2="Prolix Ring",legs="Enif Cosciales"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Ginsen",
        head="Sulevia's Mask +1",neck="Fotia Gorget",ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Regal Ring",ring2="Karieyh Ring +1",
        back="Atheling Mantle",waist="Fotia Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}

    sets.precast.WS.Acc = {ammo="Ginsen",
        head="Sulevia's Mask +1",neck="Fotia Gorget",ear1="Cessance Earring",ear2="Moonshade Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Regal Ring",ring2="Karieyh Ring +1",
        back="Atheling Mantle",waist="Fotia Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring1="Leviathan Ring"})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {ring1="Leviathan Ring"})

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Sanguine Blade'] = {ammo="Ginsen",
        head="Pixie Hairpin +1",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Archon Ring",ring2="Karieyh Ring +1",
        back="Toro Cape",waist="Eschan Stone",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    
    sets.precast.WS['Atonement'] = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Fotia Gorget",ear1="Hearty Earring",ear2="Moonshade Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Regal Ring",ring2="Vexer Ring",
        back="Fierabras's Mantle",waist="Fotia Belt",legs="Sulevia's Cuisses +2",feet="Caballarius Leggings"}
    
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})
    
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head="Sulevia's Mask +1",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Kishar Ring",ring2="Prolix Ring",
        waist="Sailfi belt +1",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
        
    sets.midcast.Enmity = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Invidia Torque",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Vexer Ring",
        back="Fierabras's Mantle",waist="Goading Belt",legs="Sulevia's Cuisses +2",feet="Caballarius Leggings"}

    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {})
    
    sets.midcast.Stun = sets.midcast.Flash

    sets.midcast.Cure = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Phalaina Locket",ear1="Nourishing Earring +1",ear2="Nourishing Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Kunaji Ring",ring2="Asklepian Ring",
        back="Fierabras's Mantle",waist="Chuq'aba Belt",legs="Sulevia's Cuisses +2",feet="Caballarius Leggings"}

    sets.midcast.SIRD = {ammo="Impatiens",
        head="Sulevia's Mask +1",neck="Phalaina Locket",ear1="Magnetic Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Kunaji Ring",ring2="Asklepian Ring",
        back="Fierabras's Mantle",waist="Chuq'aba Belt",legs="Sulevia's Cuisses +2",feet="Caballarius Leggings"}

    sets.midcast['Enhancing Magic'] = {neck="Incanter's Torque",waist="Olympus Sash",legs="Sulevia's Cuisses +2"}

    sets.midcast['Divine Magic'] = {neck="Incanter's Torque"}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
    
    sets.resting = {neck="Sanctity Necklace",
        ring1="Sheltered Ring",ring2="Defending Ring",
        waist="Fucho-no-obi"}
    

    -- Idle sets
    sets.idle = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Ethereal earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Fierabras's Mantle",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Sulevia's Leggings +2"}

    sets.idle.Town = {main="Malignance Sword",ammo="Incantor Stone",
        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Ethereal earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Fierabras's Mantle",waist="Flume Belt",legs="Carmine cuisses +1",feet="Sulevia's Leggings +2"}
    
    sets.idle.Weak = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Sanctity Necklace",ear1="Thrud Earring",ear2="Ethereal earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Fierabras's Mantle",waist="Flume Belt",legs="Carmine cuisses +1",feet="Sulevia's Leggings +2"}
    
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
    
    sets.Kiting = {legs="Carmine cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
    sets.MP = {neck="Creed Collar",waist="Flume Belt"}
    sets.MP_Knockback = {neck="Creed Collar",waist="Flume Belt",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Anahera Sword",sub="Killedar Shield"} -- Ochain
    sets.MagicalShield = {main="Anahera Sword",sub="Beatific Shield +1"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Buckler Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Petrov Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    sets.defense.HP = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Ethereal earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Petrov Ring",ring2="Meridian Ring",
        back="Weard Mantle",waist="Creed Baudrier",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    sets.defense.Reraise = {ammo="Iron Gobbet",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Ethereal earring",
        body="Twilight Mail",hands="Sulevia's Gauntlets +1",ring1="Petrov Ring",ring2="Defending Ring",
        back="Weard Mantle",waist="Nierenschutz",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    sets.defense.Charm = {ammo="Iron Gobbet",
        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Eabani Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Petrov Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {ammo="Demonry Stone",
        head="Sulevia's Mask +1",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Ethereal earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",ring1="Archon Ring",ring2="Defending Ring",
        back="Engulfer Cape",waist="Creed Baudrier",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    sets.engaged = {ammo="Ginsen",
        head="Flamma Zucchetto +2",neck="Sanctity Necklace",ear1="Brutal Earring",ear2="Cessance Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Petrov Ring",ring2="Flamma Ring",
        back="Atheling Mantle",waist="Sailfi belt +1",legs="Cizin Breeches",feet="Flamma Gambieras +2"}

    sets.engaged.Acc = {ammo="Ginsen",
        head="Flamma Zucchetto +2",neck="Sanctity Necklace",ear1="Brutal Earring",ear2="Cessance Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Petrov Ring",ring2="Flamma Ring",
        back="Atheling Mantle",waist="Sailfi belt +1",legs="Cizin Breeches",feet="Flamma Gambieras +2"}

    sets.engaged.DW = {ammo="Ginsen",
        head="Flamma Zucchetto +2",neck="Sanctity Necklace",ear1="Cessance Earring",ear2="Suppanomimi",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Petrov Ring",ring2="Flamma Ring",
        back="Atheling Mantle",waist="Shetal Stone",legs="Flamma Dirs +1",feet="Flamma Gambieras +2"}

    sets.engaged.DW.Acc = {ammo="Ginsen",
        head="Flamma Zucchetto +2",neck="Asperity Necklace",ear1="Cessance Earring",ear2="Suppanomimi",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Petrov Ring",ring2="Flamma Ring",
        back="Atheling Mantle",waist="Shetal Stone",legs="Cizin Breeches",feet="Flamma Gambieras +2"}

    sets.engaged.PDT = set_combine(sets.engaged, {head="Sulevia's mask +1",body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2",neck="Loricate Torque +1",ring1="Petrov Ring"})
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, {head="Sulevia's mask +1",body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2",neck="Loricate Torque +1",ring1="Petrov Ring"})
    sets.engaged.Reraise = set_combine(sets.engaged, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc, sets.Reraise)

    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {head="Sulevia's mask +1",body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2",neck="Loricate Torque +1",ring1="Petrov Ring"})
    sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc, {head="Sulevia's mask +1",body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +1",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2",neck="Loricate Torque +1",ring1="Petrov Ring"})
    sets.engaged.DW.Reraise = set_combine(sets.engaged.DW, sets.Reraise)
    sets.engaged.DW.Acc.Reraise = set_combine(sets.engaged.DW.Acc, sets.Reraise)


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Doom = {ring2="Saida Ring"}
    sets.buff.Cover = {head="Sulevia's Mask +1", body="Caballarius Surcoat"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    job_update()
end
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
    
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(4, 7)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 7)
    elseif player.sub_job == 'RDM' then
        set_macro_page(2, 7)
    else
        set_macro_page(1, 7)
    end
end

