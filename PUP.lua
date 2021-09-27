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
    -- List of pet weaponskills to check for
    petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
        "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
        "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}
    
    -- Map automaton heads to combat roles
    petModes = {
        ['Harlequin Head'..'Harlequin Frame'] = 'Melee',
        ['Harlequin Head'..'Valoredge Frame'] = 'Melee',
        ['Harlequin Head'..'Sharpshot Frame'] = 'Melee',
        ['Harlequin Head'..'Stormwaker Frame'] = 'Magic',

        ['Sharpshot Head'..'Harlequin Frame'] = 'Ranged',
        ['Sharpshot Head'..'Valoredge Frame'] = 'Ranged',
        ['Sharpshot Head'..'Sharpshot Frame'] = 'Ranged',
        ['Sharpshot Head'..'Stormwaker Frame'] = 'Ranged',

        ['Valoredge Head'..'Harlequin Frame'] = 'Tank',
        ['Valoredge Head'..'Valoredge Frame'] = 'Tank',
        ['Valoredge Head'..'Sharpshot Frame'] = 'Tank',
        ['Valoredge Head'..'Stormwaker Frame'] = 'Tank',

        ['Stormwaker Head'..'Harlequin Frame'] = 'Magic',
        ['Stormwaker Head'..'Valoredge Frame'] = 'Melee',
        ['Stormwaker Head'..'Sharpshot Frame'] = 'Melee',
        ['Stormwaker Head'..'Stormwaker Frame'] = 'Magic',

        ['Soulsoother Head'..'Harlequin Frame'] = 'Heal',
        ['Soulsoother Head'..'Valoredge Frame'] = 'Tank',
        ['Soulsoother Head'..'Sharpshot Frame'] = 'Melee',
        ['Soulsoother Head'..'Stormwaker Frame'] = 'Heal',

        ['Spiritreaver Head'..'Harlequin Frame'] = 'Nuke',
        ['Spiritreaver Head'..'Valoredge Frame'] = 'Melee',
        ['Spiritreaver Head'..'Sharpshot Frame'] = 'Melee',
        ['Spiritreaver Head'..'Stormwaker Frame'] = 'Nuke'
    }

    -- Subset of modes that use magic
    magicPetModes = S{'Nuke','Heal','Magic'}
    
    -- Var to track the current pet mode.
    state.PetMode = M{['description']='Pet Mode', 'None', 'Melee', 'Ranged', 'Tank', 'Turtle','Magic', 'Heal', 'Nuke'}
    send_command('bind ^f8 gs c cycle PetMode')

    state.Buff.Overdrive = buffactive.overdrive or false

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Pet')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    -- Default maneuvers 1, 2, 3 and 4 for each pet mode.
    defaultManeuvers = {
        ['Melee'] = {'Fire Maneuver', 'Thunder Maneuver', 'Wind Maneuver', 'Light Maneuver'},
        ['Ranged'] = {'Wind Maneuver', 'Fire Maneuver', 'Thunder Maneuver', 'Light Maneuver'},
        ['Tank'] = {'Earth Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Wind Maneuver'},
        ['Magic'] = {'Ice Maneuver', 'Light Maneuver', 'Dark Maneuver', 'Earth Maneuver'},
        ['Heal'] = {'Light Maneuver', 'Dark Maneuver', 'Water Maneuver', 'Earth Maneuver'},
        ['Nuke'] = {'Ice Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver'}
    }

    update_pet_mode()
    select_default_macro_book()

end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^f8')
end

-- Define sets used by this job file.
function init_gear_sets()
    
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {head="Herculean Helm",ear2="Loquacious Earring",ring1="Prolix Ring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    
    -- Precast sets to enhance JAs
    sets.precast.JA['Tactical Switch'] = {feet="Cirque Scarpe +2"}
    
    sets.precast.JA['Repair'] = {ear1="Pratik Earring",feet="Foire Babouches"}

    sets.precast.JA.Maneuver = {ear2="Burana Earring",neck="Buffoon's Collar",body="Cirque Farsetto +2",hands="Foire Dastanas +1",back="Visucius's Mantle"}

    sets.precast.JA['Overdrive'] = {}



    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Malignance Chapeau",ear1="Roundel Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Niqmaddu Ring",
        legs="Malignance Tights",feet="Malignance Boots"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Hizamaru Somen",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
        body="Hizamaru Haramaki",hands="Hizamaru Kote",ring1="Niqmaddu Ring",ring2="Karieyh Ring +1",
        back="Visucius's Mantle",waist="Fotia Belt",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stringing Pummel'] = set_combine(sets.precast.WS, {ear1="Brutal Earring",ear2="Moonshade Earring",ring2="Begrudging Ring"})

    sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {ear1="Brutal Earring",ear2="Moonshade Earring",ring2="Begrudging Ring"})

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {waist="Sailfi Belt +1"})

    sets.precast.WS['Howling Fist'] = set_combine(sets.precast.WS,{neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})

    sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS,{waist="Sailfi Belt +1"})

    
    -- Midcast Sets

    sets.midcast.FastRecast = {
        head="Herculean Helm",ear2="Loquacious Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Prolix Ring",
        legs="Malignance Tights",feet="Malignance Boots"}
        

    -- Midcast sets for pet actions
    sets.midcast.Pet.Cure = {legs="Foire Churidars"}

    sets.midcast.Pet['Elemental Magic'] = {ear2="Burana Earring",feet="Pitre Babouches"}

    sets.midcast.Pet.WeaponSkill = {neck="Shulmanu Collar", ear2="Burana Earring",body="Taeon Tabard", hands="Taeon Gloves", legs="Taeon Tights", feet="Taeon Boots"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Pitre Taj",neck="Sanctity Necklace",
        ring1="Sheltered Ring",ring2="Defending Ring"}
    

    -- Idle sets

    sets.idle = {range="Animator P",
        head="Hizamaru Somen",neck="Empath Necklace",ear1="Eabani Earring",ear2="Hearty Earring",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Hurch'lan Sash",legs="Taeon Tights",feet="Hermes' Sandals"}

    sets.idle.Town = set_combine(sets.idle, {})

    -- Set for idle while pet is out (eg: pet regen gear)
    sets.idle.Pet = set_combine(sets.idle, {head="Anwig Salade", back="Visucius's Mantle"})

    -- Idle sets to wear while pet is engaged
    sets.idle.Pet.Engaged = {
        head="Anwig Salade",neck="Shulmanu Collar",ear1="Enmerkar Earring",ear2="Rimeice Earring",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Varar Ring +1",ring2="Varar Ring +1",
        back="Visucius's Mantle",waist="Hurch'lan Sash",legs="Taeon Tights",feet="Taeon Boots"}
    sets.idle.Pet.Engaged.Melee = sets.idle.Pet.Engaged

    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {hands="Cirque Guanti +2",legs="Cirque Pantaloni +2"})

    sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

    sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

    sets.idle.Pet.Tank = set_combine(sets.idle.Pet.Engaged, {
        head="Anwig Salade", neck="Shulmanu Collar",ear1="Enmerkar Earring",ear2="Rimeice Earring",
        body="Taeon Tabard",hands="Taeon Gloves",
        back="Visucius's Mantle",waist="Isa Belt",legs="Taeon Tights",feet="Taeon Boots"})

    sets.idle.Pet.Turtle = set_combine(sets.idle.Pet.Tank, {neck="Shepherd's Chain"})

    sets.buff.Overdrive = {
        head="Anwig Salade",neck="Shulmanu Collar",ear1="Domesticator's Earring",ear2="Rimeice Earring",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Varar Ring +1",ring2="Varar Ring +1",
        back="Visucius's Mantle",waist="Hurch'lan Sash",legs="Taeon Tights",feet="Taeon Boots"}

    -- Defense sets

    sets.defense.Evasion = {
        head="Malignance Chapeau",neck="Shulmanu Collar",ear2="Eabani Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Niqmaddu Ring",ring2="Defending Ring",
        back="Ik Cape",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.PDT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Handler's Earring +1",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Niqmaddu Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.MDT = set_combine(sets.defense.PDT, {ear2="Eabani Earring",ring2="Archon Ring"})

    sets.Kiting = {feet="Hermes' Sandals"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
        head="Hizamaru Somen",neck="Shulmanu Collar",ear1="Brutal Earring",ear2="Cessance Earring",
        body="Hizamaru Haramaki",hands="Hizamaru Kote",ring1="Niqmaddu Ring",ring2="Epona's Ring",
        back="Visucius's Mantle",waist="Hurch'lan Sash",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc = {
        head="Hizamaru Somen",neck="Shulmanu Collar",ear1="Brutal Earring",ear2="Cessance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Niqmaddu Ring",ring2="Epona's Ring",
        back="Visucius's Mantle",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.DT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Ethereal Earring",ear2="Cessance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Epona's Ring",
        back="Visucius's Mantle",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Acc.DT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Ethereal Earring",ear2="Cessance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Beeline Ring",
        back="Iximulew Cape",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Pet = set_combine(sets.engaged, {
        head="Anwig Salade", neck="Shulmanu Collar", ear1="Enmerkar Earring", ear2="Burana Earring",
        body="Taeon Tabard", hands="Taeon Gloves",
        waist="Hurch'lan Sash", legs="Taeon Tights", feet="Taeon Boots" })
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when pet is about to perform an action
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if petWeaponskills:contains(spell.english) then
        classes.CustomClass = "Weaponskill"
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == 'Wind Maneuver' then
        handle_equipping_gear(player.status)
    end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
    init_pet()
    update_pet_mode()
end

function init_pet()
    state.PetMode:set(get_pet_mode())
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
    if newStatus == 'Engaged' then
        display_pet_status()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_pet_mode()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_pet_status()
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Overdrive then
        equip(sets.buff.Overdrive)
    end
end

--[[
function customize_idle_set(idleSet)
    if state.Buff.Overdrive then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Overdrive then
        meleeSet = set_combine(meleeSet, sets.buff.Overdrive)
    end
    return meleeSet
end
]]

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'maneuver' then
        if pet.isvalid then
            local man = defaultManeuvers[state.PetMode.value]
            if man and tonumber(cmdParams[2]) then
                man = man[tonumber(cmdParams[2])]
            end

            if man then
                send_command('input /pet "'..man..'" <me>')
            end
        else
            add_to_chat(123,'No valid pet.')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
    if pet.isvalid then
        return petModes[pet.head..pet.frame] or 'None'
    else
        return 'None'
    end
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
    update_custom_groups()
end



-- Update custom groups based on the current pet.
function update_custom_groups()
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        classes.CustomIdleGroups:append(state.PetMode.value)
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name..' ['..pet.head..']: '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp).. '  Pet Mode='..state.PetMode.value
        
        if magicPetModes:contains(state.PetMode.value) then
            petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
        end
        
        add_to_chat(122,petInfoString)
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 10)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 10)
    elseif player.sub_job == 'THF' then
        set_macro_page(2, 10)
    elseif player.sub_job == 'WHM' then
        set_macro_page(2, 10)
    else
        set_macro_page(2, 10)
    end
    send_command( "@wait 5;input /lockstyleset 1" )
end


