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
    indi_timer = ''
    indi_duration = 180
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')

    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')



    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.default.weaponskill_waist = "Windbuffet Belt +1"
    gear.default.obi_waist = "Sacro Cord"
    gear.default.drain_waist = "Fucho-no-Obi"
    gear.default.cure_waist = "Embla Sash"

    gear.merlinic.fc.head = {
        name = "Merlinic Hood",
        augments = { '"Mag.Atk.Bns."+26', '"Fast Cast"+7', 'Mag. Acc.+11', }
    }
    gear.merlinic.fc.body = { name = "Merlinic Jubbah", augments = { 'Mag. Acc.+1', '"Fast Cast"+7', } }
    gear.merlinic.fc.feet = {
        name = "Merlinic Crackows",
        augments = { '"Mag.Atk.Bns."+1', '"Fast Cast"+7', 'MND+3',
            'Mag. Acc.+14', },
    }

    gear.grioavolr.fc = { name = "Grioavolr", augments = { '"Fast Cast"+7', 'MP+101', } }

    --------------------------------------
    -- Misc sets
    --------------------------------------
    sets.SIRD = {
        neck = "Loricate Torque +1",
        body = "Rosette jaseran +1",
        hands = "Amalric Gages +1",
        waist = "Emphatikos rope",
        legs = "Geomancy Pants +1",
        feet = "Amalric Nails +1"
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = { body = "Bagua Tunic" }
    sets.precast.JA['Life cycle'] = { body = "Geomancy Tunic" }

    -- Fast cast sets for spells
    sets.precast.FC = {
        gear.grioavolr.fc,
        range = "Dunna",
        head = gear.merlinic.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = gear.merlinic.fc.body,
        hands = "Telchine Gloves",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Lebeche Ring",
        back = "Perimede Cape",
        waist = "Embla Sash",
        legs = "Geomancy Pants +1",
        feet = gear.merlinic.fc.feet
    }

    sets.precast.FC.Cure = set_combine(sets.precast.FC,
        { main = "Daybreak", sub = "Ammurapi Shield", back = "Pahtli Cape" })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast['Dispelga'] = set_combine(sets.precast.FC,
        { main = { name = "Daybreak", priority = 9 }, sub = { name = "Ammurapi Shield", priority = 10 } })

    sets.precast['Impact'] = set_combine(sets.precast.FC, { head = empty, body = "Crepuscular Cloak" })
    sets.precast.FC['Impact'] = set_combine(sets.precast.FC, { head = empty, body = "Crepuscular Cloak" })


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head = "",
        neck = "",
        ear1 = "",
        ear2 = "",
        body = "",
        hands = "",
        ring1 = "",
        ring2 = "",
        back = "",
        waist = "",
        legs = "",
        feet = ""
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Flash Nova'] = { ring2 = "Weatherspoon Ring +1" }

    sets.precast.WS['Black Halo'] = {}

    sets.precast.WS['Judgment'] = {}

    sets.precast.WS['Starlight'] = { ear2 = "Moonshade Earring" }

    sets.precast.WS['Moonlight'] = { ear2 = "Moonshade Earring" }

    sets.precast.WS['Exudiation'] = {}

    sets.precast.WS['Realmrazer'] = {}

    sets.precast.WS['Hexastrike'] = {}

    sets.precast.WS['Retribution'] = {}

    sets.precast.WS['Spirit Taker'] = { ear2 = "Moonshade Earring" }

    sets.precast.WS['Cataclysm'] = {}

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        ear1 = "Malignance earring",
        ear2 = "Loquacious Earring",
        hands = "Telchine Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Kishar Ring",
    }

    sets.midcast.Geomancy = {
        range = "Nepote Bell",
        head = "Azimuth Hood +1",
        neck = "Bagua Charm +1",
        body = "Bagua Tunic +1",
        hands = "Geomancy Mitaines +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini
    }
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        legs = "Bagua Pants +1", feet = "Azimuth Gaiters +1"
    })

    sets.midcast['Elemental Magic'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Cath Palug Crown",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Malignance Earring",
        body = "Amalric Doublet +1",
        hands = "Amalric Gages +1",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.int_cape,
        waist = gear.ElementalObi,
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1"
    }
    sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {
        head = empty,
        neck = "Incanter's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Malignance Earring",
        body = "Cohort Cloak +1",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1"
    })
    sets.midcast.MagicBurst = {
        neck = "Mizukage-no-kubikazari",
        ring1 = "Jhakri Ring",
        ring2 = "Mujin Band",
        feet = "Jhakri Pigaches +2"
    }

    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'].Acc, {
        head = empty,
        body = "Crepuscular Cloak",
        ring1 = "Archon Ring"
    }
    )

    sets.midcast['Dark Magic'] = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Ghastly Tathlum +1",
        head = "Cath Palug Crown",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ear2 = "Dark Earring",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        waist = "Casso Sash",
    }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        main = "Rubicundity",
        sub = "Caecus Grip",
        head = "Bagua Galero +1",
        neck = "Erra Pendant",
        ear1 = "Mani Earring",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        waist = gear.DrainWaist
    })
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        head = "Cath Palug Crown",
        neck = "Erra Pendant",
        ring2 = "Kishar Ring",
    })

    sets.midcast['Enhancing Magic'] = {
        main = "Grioavolr",
        head = "Befouled Crown",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Telchine Chasuble",
        hands = "Ayao's Gages",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = "Shedir Seraweels",
        feet = gear.telchine.enh_dur.feet
    }

    sets.midcast.Aquaveil = set_combine(sets.SIRD, {
        head = "Amalric Coif +1",
        waist = "Emphatikos Rope",
        legs = "Shedir Seraweels"
    })
    sets.midcast.Stoneskin = set_combine(sets.SIRD, {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels"
    })

    sets.midcast.Refresh = {
        head = "Amalric Coif +1",
        waist = "Gishdubar Sash"
    }


    sets.midcast['Enfeebling Magic'] = {
        main = "Contemplator +1",
        sub = "Enki Strap",
        ammo = "Pemphredo Tathlum",
        head = "Agwu's Cap",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Dignitary's Earring",
        body = "Agwu's robe",
        hands = "Agwu's Gages",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches",
    }
    sets.midcast['Dispelga'] = set_combine(sets.midcast['Enfeebling Magic'], { main = "Daybreak" })

    sets.midcast.Poison = set_combine(sets.midcast['Enfeebling Magic'], {
        neck = "Incanter's Torque",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Casso Sash",
        legs = "Chironic Hose",
    })
    sets.midcast['Poison II'] = sets.midcast.Poison

    sets.midcast['Healing Magic'] = {
        neck = "Incanter's Torque",
        ear1 = "Beatific Earring",
        ear2 = "Meili Earring",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini
    }

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        back = "Oretania's Cape +1"
    })

    sets.midcast.Cure = {
        main = "Bolelabunga",
        sub = "Ammurapi Shield",
        head = "Vanya Hood",
        neck = "Nodens Gorget",
        body = "Gendewitha Bliault +1",
        hands = "Telchine Gloves",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Protectra = { ring1 = "Sheltered Ring", waist = "Embla Sash" }

    sets.midcast.Shellra = { ring1 = "Sheltered Ring", waist = "Embla Sash" }


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
        head = "Nefer Khat +1",
        neck = "Bathy Choker +1",
        body = "Gendewitha Bliault +1",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Austerity Belt +1",
        legs = "Agwu's Slops",
        feet = "Chelona Boots +1"
    }


    -- Idle sets

    sets.idle = {
        main = "Bolelabunga",
        sub = "Ammurapi Shield",
        range = "Nepote Bell",
        head = "Nefer Khat +1",
        neck = "Loricate Torque +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Jhakri Robe +2",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    sets.idle.PDT = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        range = "Nepote Bell",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Jhakri Robe +2",
        hands = "Agwu's Gages",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = {
        main = "Solstice",
        sub = "Ammurapi Shield",
        range = "Nepote Bell",
        head = "Telchine Cap",
        neck = "Shepherd's Chain",
        ear1 = "Handler's Earring +1",
        ear2 = "Etiolation Earring",
        body = "Telchine Chasuble",
        hands = "Telchine Gloves",
        ring1 = gear.left_stikini,
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Isa Belt",
        legs = "Telchine Braconi",
        feet = "Crier's Gaiters"
    }

    sets.idle.PDT.Pet = {
        main = "Malignance Pole",
        sub = "Oneiros Grip",
        range = "Nepote Bell",
        head = "Telchine Cap",
        neck = "Loricate Torque +1",
        ear1 = "Handler's Earring +1",
        ear2 = "Etiolation Earring",
        body = "Telchine Chasuble",
        hands = "Telchine Gloves",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Isa Belt",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, { legs = "Bagua Pants" })
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, { legs = "Bagua Pants" })
    sets.idle.PDT.Indi = set_combine(sets.idle.PDT, { legs = "Bagua Pants" })
    sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, { legs = "Bagua Pants" })

    sets.idle.Town = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        range = "Nepote Bell",
        head = "Bagua Galero",
        neck = "Loricate Torque +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Jhakri Robe +2",
        hands = "Serpentes Cuffs",
        ring1 = "Sheltered Ring",
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    sets.idle.Weak = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        range = "Nepote Bell",
        head = "Nefer Khat +1",
        neck = "Bathy Choker +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Jhakri Robe +2",
        hands = "Serpentes Cuffs",
        ring1 = "Sheltered Ring",
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    -- Defense sets

    sets.defense.PDT = {
        range = "Nepote Bell",
        head = "Agwu's Cap",
        neck = "Bathy Choker +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Jhakri Robe +2",
        hands = "Agwu's Gages",
        ring1 = "Defending Ring",
        ring2 = gear.DarkRing.physical,
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.defense.MDT = {
        range = "Nepote Bell",
        head = "Agwu's Cap",
        neck = "Bathy Choker +1",
        ear1 = "Lugalbanda Earring",
        ear2 = "Etiolation Earring",
        body = "Jhakri Robe +2",
        hands = "Agwu's Gages",
        ring1 = "Defending Ring",
        ring2 = "Shadow Ring",
        back = "Umbra Cape",
        waist = "Fucho-no-obi",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.Kiting = { feet = "Crier's Gaiters" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        range = "Nepote Bell",
        head = "",
        neck = "Combatant's Torque",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Agwu's Robe",
        hands = "Telchine Gloves",
        ring1 = "Rajas Ring",
        ring2 = "Defending Ring",
        back = "Umbra Cape",
        waist = "Cornelia's Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    --------------------------------------
    -- Custom buff sets
    --------------------------------------
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "' .. indi_timer .. '"')
            indi_timer = spell.english
            send_command('@timers c "' .. indi_timer .. '" ' .. indi_duration .. ' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "' .. spell.english .. ' [' .. spell.target.name .. ']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "' .. spell.english .. ' [' .. spell.target.name .. ']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi') then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main', 'sub', 'range')
        else
            enable('main', 'sub', 'range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
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
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
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
    set_macro_page(1, 15)
end
