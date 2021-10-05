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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {main=gear.FastcastStaff,ammo="Incantor Stone",
        head="Inyanga Tiara +1",neck="Orison Locket",ear1="Malignance Earring",ear2="Loquacious Earring",
        body="Inyanga Jubbah +2",hands="Gendewitha Gages +1",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Eber Pantaloons",feet="Chelona Boots +1"}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat"})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Eber Pantaloons"})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {main="Daybreak", sub="Genbu's Shield", head="Piety Cap", back="Pahtli Cape"})--,sub="Genbu's Shield",ammo="Impatiens"})
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = set_combine(sets.precast.FC.Cure)

    --sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Genbu's Shield"})
    --sets.midcast.FC.Dispelga = set_combine( sets.precast.FC['Dispelga'], {} )
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault"}
    sets.precast.JA['Afflatus Misery'] = {legs="Piety Pantaloons"}
    sets.precast.JA['Afflatus Solace'] = {legs="Piety Duckbills"}
    sets.precast.JA.Devotion = {head="Piety Cap"}
    sets.precast.JA.Martyr = {hands="Piety Mitts"}




    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Inyanga Tiara +1",ear1="Roundel Earring",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",
        back="Felicitas Cape +1",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    
    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = "Fotia Gorget"
    gear.default.weaponskill_waist = "Fotia Belt"
    sets.precast.WS = {ammo="Kalboron Stone",
        head="Inyanga Tiara +1",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",ring1="Karieyh Ring +1",ring2="K'ayres Ring",
        back="Felicitas Cape +1",waist="Fotia Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    sets.precast.WS['Flash Nova'] = {
        head="Inyanga Tiara +1",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",ring1="Karieyh Ring +1",ring2="Strendu Ring",
        back="Toro Cape",waist="Eschan Stone",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    

    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Inyanga Tiara +1",ear1="Malignance Earring",ear2="Loquacious Earring",
        body="Inyanga Jubbah +2",hands="Dynasty Mitts",ring1="Prolix Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    -- Cure sets
    gear.default.obi_waist = "Witful Belt"
    gear.default.obi_back = "Mending Cape"

    sets.midcast.CureSolace = {main="Daybreak",sub="Genbu's Shield",ammo="Incantor Stone",
        head="Eber Cap",neck="Phalaina Locket",ear1="Glorious Earring",ear2="Nourishing Earring +1",
        body="Eber Bliaud",hands="Theophany Mitts +1",ring1="Prolix Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist=gear.ElementalObi,legs="Eber Pantaloons",feet="Piety Duckbills"}

    sets.midcast.Cure = {main="Daybreak",sub="Genbu's Shield",ammo="Incantor Stone",
        head="Eber Cap",neck="Phalaina Locket",ear1="Glorious Earring",ear2="Nourishing Earring +1",
        body="Gendewitha Bliaut +1",hands="Theophany Mitts +1",ring1="Prolix Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist=gear.ElementalObi,legs="Eber Pantaloons",feet="Piety Duckbills"}

    sets.midcast.Curaga = {main="Daybreak",sub="Genbu's Shield",ammo="Incantor Stone",
        head="Eber Cap",neck="Phalaina Locket",ear1="Glorious Earring",ear2="Nourishing Earring +1",
        body="Gendewitha Bliaut +1",hands="Theophany Mitts +1",ring1="Prolix Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist=gear.ElementalObi,legs="Eber Pantaloons",feet="Piety Duckbills"}

    sets.midcast.CureMelee = {ammo="Incantor Stone",
        head="Eber Cap",neck="Phalaina Locket",ear1="Glorious Earring",ear2="Nourishing Earring +1",
        body="Inyanga Jubbah +2",hands="Theophany Mitts +1",ring1="Prolix Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist=gear.ElementalObi,legs="Eber Pantaloons",feet="Piety Duckbills"}

    sets.midcast.Cursna = {main="Beneficus",sub="Genbu's Shield",
        head="Eber Cap",neck="Malison Medallion",
        body="Eber Bliaud",hands="Hieros Mittens",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Mending Cape",waist="Witful Belt",legs="Theophany Pantaloons +1",feet="Gendewitha Galoshes"}

    sets.midcast.StatusRemoval = {
        head="Eber Cap",legs="Piety Pantaloons"}

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {main="Grioavolr",sub="Oneiros Grip",
        head="Umuthi Hat",neck="Incanter's Torque",
        body="Manasa Chasuble",hands="Dynasty Mitts",
        back="Mending Cape",waist="Embla Sash",legs="Piety Pantaloons",feet="Eber Duckbills"}

    sets.midcast.Stoneskin = {main="Grioavolr",sub="Oneiros Grip",
        head="Inyanga Tiara +1",neck="Orison Locket",ear2="Loquacious Earring",
        body="Inyanga Jubbah +2",hands="Dynasty Mitts",
        back="Swith Cape +1",waist="Siegel Sash",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}

    sets.midcast.Auspice = {hands="Dynasty Mitts",feet="Eber Duckbills"}

    sets.midcast.BarElement = {main="Grioavolr",sub="Oneiros Grip",
        head="Eber Cap",neck="Incanter's Torque",
        body="Eber Bliaud",hands="Eber Mitts",
        back="Mending Cape",waist="Olympus Sash",legs="Piety Pantaloons",feet="Eber Duckbills"}

    sets.midcast.Regen = {main="Bolelabunga",sub="Genbu's Shield",
        head="Inyanga Tiara +1",
        body="Piety Briault",hands="Eber Mitts",
        legs="Theophany Pantaloons +1"}

    sets.midcast.Protectra = {ring1="Sheltered Ring",feet="Piety Duckbills"}

    sets.midcast.Shellra = {ring1="Sheltered Ring",legs="Piety Pantaloons"}


    sets.midcast['Divine Magic'] = {main="Daybreak",sub="Genbu's Shield",
        head="Inyanga Tiara +1",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Inyanga Jubbah +2",hands="Theophany Mitts +1",ring2="Stikini Ring +1",
        back="Felicitas Cape +1",waist=gear.ElementalObi,legs="Theophany Pantaloons +1",feet="Gendewitha Galoshes"}

    sets.midcast['Dark Magic'] = {main="Daybreak", sub="Genbu's Shield",
        head="Inyanga Tiara +1",neck="Aesir Torque",ear1="Gwati Earring",ear2="Malignance Earring",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",ring1="Strendu Ring",ring2="Stikini Ring +1",
        back="Felicitas Cape +1",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills"}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {main="Daybreak", sub="Genbu's Shield",
        head="Inyanga Tiara +1",neck="Weike Torque",ear1="Gwati Earring",ear2="Malignance Earring",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",ring1="Aquasoul Ring",ring2="Stikini Ring +1",
        back="Felicitas Cape +1",waist="Eschan Stone",legs="Bokwus Slops",feet="Piety Duckbills"}

    sets.midcast.IntEnfeebles = {main="Daybreak", sub="Genbu's Shield",
        head="Inyanga Tiara +1",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Malignance Earring",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",ring1="Icesoul Ring",ring2="Stikini Ring +1",
        back="Felicitas Cape +1",waist="Eschan Stone",legs="Bokwus Slops",feet="Piety Duckbills"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main=gear.Staff.HMP, 
        body="Gendewitha Bliaut",hands="Serpentes Cuffs",
        waist="Austerity Belt",legs="Nares Trews",feet="Chelona Boots +1"}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {main="Bolelabunga", sub="Genbu's Shield",ammo="Homiliary",
        head="Theophany cap +1",neck="Sanctity Necklace",ear1="Eabani Earring",ear2="Hearty Earring",
        body="Theophany Briault +1",hands="Theophany Cuffs",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Felicitas Cape +1",waist="Fucho-no-obi",legs="Assiduity Pants +1",feet="Theophany Duckbills"}

    sets.idle.PDT = {main="Malignance Pole",sub="Oneiros Grip",ammo="Homiliary",
        head="Inyanga Tiara +1",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Hearty Earring",
        body="Inyanga Jubbah +2",hands="Theophany Cuffs",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Felicitas Cape +1",waist="Witful Belt",legs="Assiduity Pants +1",feet="Crier's Gaiters"}

    sets.idle.Town = {main="Bolelabunga", sub="Genbu's Shield",ammo="Homiliary",
        head="Theophany cap +1",neck="Sanctity Necklace",ear1="Eabani Earring",ear2="Hearty Earring",
        body="Theophany Briault +1",hands="Theophany Mitts +1",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Felicitas Cape +1",waist="Fucho-no-obi",legs="Assiduity Pants +1",feet="Crier's Gaiters"}
    
    sets.idle.Weak = {main="Malignance Pole",sub="Oneiros Grip",ammo="Homiliary",
        head="Inyanga Tiara +1",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Hearty Earring",
        body="Theophany Briault +1",hands="Theophany Mitts +1",ring1="Defending Ring",ring2="Meridian Ring",
        back="Felicitas Cape +1",waist="Fucho-no-obi",legs="Nares Trews",feet="Gendewitha Galoshes"}
    
    -- Defense sets

    sets.defense.PDT = {main="Malignance Pole",sub="Oneiros Grip", ammo="Homiliary",
        head="Inyanga Tiara +1",neck="Loricate Torque +1",
        body="Inyanga Jubbah +2",hands="Gendewitha Gages +1",ring1="Defending Ring",ring2="Archon Ring",
        back="Felicitas Cape +1",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}

    sets.defense.MDT = {main="Malignance Pole",sub="Oneiros Grip",
        head="Inyanga Tiara +1",neck="Loricate Torque +1",
        body="Inyanga Jubbah +2",hands="Inyanga Dastanas +1",ring1="Defending Ring",ring2="Archon Ring",
        back="Oretania's Cape",legs="Bokwus Slops",feet="Gendewitha Galoshes"}

    sets.Kiting = {feet="Crier's Gaiters"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
        head="Inyanga Tiara +1",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="Brutal Earring",
        body="Inyanga Jubbah +2",hands="Dynasty Mitts",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Felicitas Cape +1",waist="Eschan Stone",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}


    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Eber Mitts",back="Mending Cape"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
    
    if spell.skill == 'Healing Magic' then
        gear.default.obi_back = "Mending Cape"
    else
        gear.default.obi_back = "Toro Cape"
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 3)
    send_command( "@wait 5;input /lockstyleset 11" )
end

