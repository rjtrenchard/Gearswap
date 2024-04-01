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
    include('augments.lua')
    include('default_sets.lua')
    include('natty_helper_functions.lua')

    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    send_command('bind ^G input /mount raptor')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {
        main = gear.grioavolr.fc,
        ammo = "Impatiens",
        head = "Bunzi's Hat",
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2",
        hands = "Gendewitha Gages +1",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Lebeche Ring",
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = "Kaykaus Tights +1",
        feet = gear.telchine.fc.feet
    }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, { waist = "Siegel Sash", })

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, { legs = "Eber Pantaloons", })

    -- sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
        head = "Piety Cap",
        back = "Perimede Cape",
    })
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = set_combine(sets.precast.FC.Cure)

    --sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
    --sets.midcast.FC.Dispelga = set_combine( sets.precast.FC['Dispelga'], {} )
    -- CureMelee spell map should default back to Healing Magic.

    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = { body = "Piety Briault" }
    sets.precast.JA['Afflatus Misery'] = { legs = "Piety Pantaloons" }
    sets.precast.JA['Afflatus Solace'] = { legs = "Piety Duckbills" }
    sets.precast.JA.Devotion = { head = "Piety Cap" }
    sets.precast.JA.Martyr = { hands = "Piety Mitts" }




    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
    }


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = "Fotia Gorget"
    gear.default.weaponskill_waist = "Fotia Belt"

    sets.precast.WS = {
        ammo = "Oshasha's treatise",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Shukuyu Ring",
        back = "Felicitas Cape +1",
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ring1 = "Epaminondas's Ring",
        ring2 = "Medada's Ring",
        waist = "Luminary Sash"
    })
    sets.precast.WS['Seraph Strike'] = set_combine(sets.precast.WS['Flash Nova'], {})
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Seraph Strike']

    sets.precast.WS['Hexastrike'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Dagan'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Kaykaus Mitra +1",
        neck = "Orunmila's Torque",
        ear1 = "Nehalennia earring",
        ear2 = "Etiolation Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = "Metamorph Ring +1",
        ring2 = "Mephitas's Ring +1",
        back = "Fi Follet Cape +1",
        waist = "Shinjutsu-no-obi +1",
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus boots +1",
    }

    sets.precast.WS['Mystic Boon'] = set_combine(sets.precast.WS, {
        ear1 = "Regal Earring",
        ring2 = "Metamorph Ring +1",
        waist = "Luminary Sash",
    })

    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS['Flash Nova'],
        { head = "Pixie Hairpin +1", ring2 = "Archon Ring" })

    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Flash Nova']

    -- Midcast Sets

    sets.midcast.FastRecast = {
        head = "Bunzi's Hat",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2",
        ring2 = "Rahab Ring",
        back = "Fi Follet Cape +1",
        waist = "Shinjutsu-no-obi +1",
    }

    -- Cure sets
    gear.default.obi_waist = "Luminary Sash"
    gear.default.cure_waist = "Luminary Sash"

    sets.midcast['Healing Magic'] = {
        main = "Gada",
        head = "Kaykaus Mitra +1",
        neck = "Incanter's Torque",
        ear1 = "Beatific earring",
        ear2 = "Meili Earring",
        body = "Ebers Bliaut",
        hands = "Theophany Mitta +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Altruistic cape",
        waist = "Bishop's Sash",
        legs = "Piety Pantaloons +1",
        feet = "Bunzi's Sabots",
    }

    sets.midcast.CureSolace = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Kaykaus Mitra +1",
        neck = "Nodens Gorget",
        ear1 = "Magnetic Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = "Metamorph Ring +1",
        ring2 = "Mephitas's Ring +1",
        back = "Oretania's Cape +1",
        waist = "Shinjutsu-no-obi +1",
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus Boots +1"
    }

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], {
        main = "Daybreak",
        head = "Kaykaus Mitra +1",
        neck = "Elite Royal Collar",
        ear1 = "Regal Earring",
        ear2 = "Magnetic Earring",
        body = "Kaykaus Bliaut +1",
        hands = "Kaykaus Cuffs +1",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Fi Follet Cape +1",
        waist = gear.CureWaist,
        legs = "Kaykaus Tights +1",
        feet = "Kaykaus Boots +1"
    })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        back = "Alaunus's Cape",
        legs = "Theophany Pantaloons +1",
        feet = "Gendewitha Galoshes +1",
    })

    sets.midcast.StatusRemoval = {
        head = "Eber Cap", legs = "Piety Pantaloons"
    }

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {
        main = "Grioavolr",
        sub = "Oneiros Grip",
        head = "Befouled Crown",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Telchine Chasuble",
        hands = "Inyanga Dastanas +2",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Mending Cape",
        waist = "Embla Sash",
        legs = "Piety Pantaloons",
        feet = "Theophany Duckbills +1",
    }

    sets.midcast['Enhancing Magic'].Duration = set_combine(sets.midcast['Enhancing Magic'], {
        head = gear.telchine.enh_dur.head,
        body = gear.telchine.enh_dur.body,
        hands = gear.telchine.enh_dur.hands,
        legs = gear.telchine.enh_dur.legs,
        feet = gear.telchine.enh_dur.feet
    })

    sets.midcast.Stoneskin = {
        main = "Grioavolr",
        sub = "Oneiros Grip",
        head = "Inyanga Tiara +1",
        neck = "Orison Locket",
        ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2",
        hands = "Dynasty Mitts",
        back = "Fi Follet Cape +1",
        waist = "Siegel Sash",
        legs = "Gendewitha Spats",
        feet = "Gendewitha Galoshes"
    }

    sets.midcast.Auspice = { hands = "Dynasty Mitts", feet = "Eber Duckbills" }

    sets.midcast.BarElement = { main = "Beneficus", legs = "", }

    sets.midcast.Regen = {
        main = "Bolelabunga",
        sub = "Ammurapi Shield",
        head = "Inyanga Tiara +1",
        body = "Piety Briault",
        hands = "Eber Mitts",
        legs = "Theophany Pantaloons +1"
    }

    sets.midcast.Protectra = { ring1 = "Sheltered Ring", feet = "Piety Duckbills" }

    sets.midcast.Shellra = { ring1 = "Sheltered Ring", legs = "Piety Pantaloons" }


    sets.midcast['Divine Magic'] = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        head = "Bunzi's Hat",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = "Freke Ring",
        ring2 = "Weatherspoon Ring +1",
        back = "Felicitas Cape +1",
        waist = gear.ElementalObi,
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

    sets.midcast['Divine Magic']['Banish'] = set_combine(sets.midcast['Divine Magic'], {
        head = "Ipoca Beret",
        neck = "Jokushu Chain",
        hands = "Piety Mitts +1",
        ring2 = "Fenian Ring",
        back = "Disperser's Cape",
    })


    sets.midcast['Dark Magic'] = {
        main = "Bunzi's Rod",
        sub = "Ammurapi Shield",
        head = "Bunzi's Hat",
        neck = "Sibyl Scarf",
        ear1 = "Regal Earring",
        ear2 = "Malignance Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Felicitas Cape +1",
        waist = "Acuity Belt +1",
        legs = "Bunzi's Pants",
        feet = "Bunzi's Sabots"
    }

    sets.midcast['Enfeebling Magic'] = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        head = "Bunzi's Hat",
        neck = "Incanter's Torque +1",
        ear1 = "Enfeebling Earring",
        ear2 = "Vor Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Aurist's Cape +1",
        waist = "Rumination Sash",
        legs = "Chironic Hose",
        feet = "Bunzi's Sabots"
    }





    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { main = "Bolelabunga" }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        main = "Bolelabunga",
        sub = "Ammurapi Shield",
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick ring",
        back = "Felicitas Cape +1",
        waist = "Fucho-no-obi",
        legs = "Nyame Flanchard",
        feet = "Crier's Gaiters"
    }

    sets.idle.PDT = {
        main = "Malignance Pole",
        sub = "Oneiros Grip",
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Shneddick Ring",
        back = "Felicitas Cape +1",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.Town = {
        ammo = "Homiliary",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Shneddick Ring",
        back = "Moonlight Cape",
        waist = "Blacksmith's Belt",
        legs = "Carmine Cuisses +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.Weak = {
        ammo = "Homiliary",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring",
        back = "Felicitas Cape +1",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = "Crier's Gaiters"
    }

    sets.idle.Refresh = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Homiliary",
        head = "Befouled Crown",
        neck = "Sibyl Scarf",
        body = "Shamash Robe",
        hands = gear.chironic.refresh.hands,
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = gear.chironic.refresh.feet
    }

    -- Defense sets

    sets.defense.PDT = {
        main = "Malignance Pole",
        sub = "Oneiros Grip",
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Felicitas Cape +1",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = "Crier's Gaiters",
    }

    sets.defense.MDT = {
        main = "Malignance Pole",
        sub = "Oneiros Grip",
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Felicitas Cape +1",
        waist = "Fucho-no-obi",
        legs = "Assiduity Pants +1",
        feet = "Crier's Gaiters"
    }

    sets.Kiting = { feet = "Crier's Gaiters" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
        head = "Bunzi's Hat",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Bunzi's Robe",
        hands = "Bunzi's Gloves",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        waist = "Sailfi Belt +1",
        legs = "Ayanmo Cosciales +2",
        feet = "Bunzi's Sabots"
    }


    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = { hands = "Eber Mitts", back = "Mending Cape" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- function filtered_action(spell)
--     print(spell.english, spell.type)
--     if spell.english == 'Chocobo' then
--         cancel_spell()
--         send_command('input /mount Raptor')
--     end
-- end

-- function job_pretarget(s, a, sM, evt)
--     print(s.english, s.type)
-- end

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
        gear.default.obi_back = "Aurist's Cape +1"
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
    -- if stateField == 'Offense Mode' then
    --     if newValue == 'Normal' then
    --         disable('main', 'sub', 'range')
    --     else
    --         enable('main', 'sub', 'range')
    --     end
    -- end
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
            -- elseif spell.skill == "Enfeebling Magic" then
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
    send_command("@wait 5;input /lockstyleset 1")
end
