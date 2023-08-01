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

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')

    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant', 'Low')
    state.IdleMode:options('Normal', 'PDT')

    state.MagicBurst = M(false, 'Magic Burst')

    lowTierNukes = S { 'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II' }



    -- Additional local binds
    send_command('bind ^` input /ma Stun <t>')
    send_command('bind @` gs c activate MagicBurst')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------


    ---- Precast Sets ----

    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = { feet = "Goetia Sabots +2" }

    sets.precast.JA.Manafont = { body = "Sorcerer's Coat +2" }

    -- equip to maximize HP (for Tarus) and minimize MP loss before using convert
    sets.precast.JA.Convert = {}


    -- Fast cast sets for spells
    -- FC 80, QC 10
    sets.precast.FC = {
        main = gear.grioavolr.fc,
        ammo = "Impatiens",
        head = gear.merlinic.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Malignance Earring",
        ear2 = "Loquacious Earring",
        body = gear.merlinic.fc.body,
        hands = gear.merlinic.fc.hands,
        ring1 = "Lebeche Ring",
        ring2 = "Weatherspoon Ring +1",
        back = "Perimede Cape",
        waist = "Embla Sash",
        legs = "Lengo Pants",
        feet = gear.merlinic.fc.feet
    }

    sets.precast.FC.Impact = set_combine(sets.precast.FC, { head = empty, body = "Crepuscular Cloak" })

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head = "Agwu's Cap",
        neck = "Combatant's Torque",
        ear1 = "Bladeborn Earring",
        ear2 = "Steelflash Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Rajas Ring",
        ring2 = "Icesoul Ring",
        back = "Refraction Cape",
        waist = "Cognition Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Vidohunir'] = {
        ammo = "Dosis Tathlum",
        head = "Agwu's Cap",
        neck = "Erra Pendant",
        ear1 = "Friomisi Earring",
        ear2 = "Regal Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Icesoul Ring",
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = "Thunder Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }


    ---- Midcast Sets ----

    sets.midcast.FastRecast = {
        head = "Agwu's Cap",
        ear2 = "Loquacious Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Rahab Ring",
        back = "Fi Follet Cape +1",
        waist = "Cornelia's Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.Cure = {
        main = "Tamaxchi",
        sub = "Ammurapi Shield",
        head = "Agwu's Cap",
        neck = "Incanter's Torque",
        ear2 = "Loquacious Earring",
        body = "Heka's Kalasiris",
        hands = "Agwu's Gages",
        ring1 = "Ephedra Ring",
        ring2 = "Sirona's Ring",
        back = "Pahtli Cape",
        waist = gear.ElementalObi,
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Cursna = set_combine({}, {
        neck = "Debilis Medallion",
        hands = "Hieros Mittens",
        ring1 = "Menelaus's Ring",
        ring2 = "Haoma's Ring",
        feet = "Gendewitha Galoshes +1"
    })

    sets.midcast['Enhancing Magic'] = {
        head = "Befouled Crown",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Anhur Robe",
        hands = "Ayao's Gages",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Embla Sash",
        legs = "Shedir Seraweels",
        feet = "Telchine Pigaches"
    }

    sets.midcast.Stoneskin = set_combine(sets.midcast["Enhancing Magic"], {
        neck = "Nodens Gorget",
        ear1 = "Earthcry Earring",
        waist = "Seigel Sash",
        legs = "Shedir Seraweels"
    })

    sets.midcast['Enfeebling Magic'] = {
        main = "Lehbrailg +2",
        sub = "Enki Strap",
        ammo = "Pemphredo Tathlum",
        head = "Befouled Crown",
        neck = "Erra Pendant",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Manasa Chasuble",
        ring1 = "Metamorph Ring +1",
        ring2 = gear.right_stikini,
        back = "Aurist's Cape +1",
        waist = "Luminary Sash",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], { main = "Daybreak", sub = "Ammurapi Shield" })

    sets.midcast['Dark Magic'] = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Aesir Torque",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        back = "Aurist's Cape +1",
        waist = gear.DrainWaist,
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.Drain = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Aesir Torque",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Archon Ring",
        ring2 = "Evanescence Ring",
        back = "Merciful Cape",
        waist = gear.DrainWaist,
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
        main = "Rubicundity",
        sub = "Ammurapi Shield",
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Aesir Torque",
        ear1 = "Malignance Earring",
        ear2 = "Mani Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Metamorph Ring +1",
        ring2 = "Evanescence Ring",
        back = "Aurist's Cape +1",
        waist = gear.DrainWaist,
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }


    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
        main = "Lehbrailg +2",
        sub = "Enki Strap",
        ammo = "Dosis Tathlum",
        head = "Cath Palug Crown",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Amalric Doublet +1",
        hands = "Amalric Gages +1",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = gear.ElementalObi,
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1"
    }

    sets.midcast['Elemental Magic'].Resistant = {
        main = "Lehbrailg +2",
        sub = "Enki Strap",
        ammo = "Dosis Tathlum",
        head = "Cath Palug Crown",
        neck = "Sibyl Scarf",
        ear1 = "Malignance Earring",
        ear2 = "Regal Earring",
        body = "Amalric Doublet +1",
        hands = "Amalric Gages +1",
        ring1 = "Freke Ring",
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = gear.ElementalObi,
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1"
    }

    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})
    sets.midcast['Elemental Magic'].HighTierNuke.Resistant = set_combine(sets.midcast['Elemental Magic'],
        {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], { head = empty, body = "Crepuscular Cloak" })


    -- Minimal damage gear for Lows.
    sets.midcast['Elemental Magic'].Low = {
        main = "Earth Staff",
        sub = "Enki Strap",
        ammo = "Staunch Tathlum +1",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Manasa Chasuble",
        hands = "Serpentes Cuffs",
        ring1 = "Sheltered Ring",
        ring2 = "Shadow Ring",
        back = "Fi Follet Cape +1",
        waist = "Witful Belt",
        legs = "Agwu's Slops",
        feet = "Chelona Boots +1"
    }



    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        main = "Daybreak",
        sub = "Ammurapi Shield",
        ammo = "Clarus Stone",
        head = "Befouled Crown",
        neck = "Bathy Choker +1",
        body = "Heka's Kalasiris",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Austerity Belt +1",
        legs = "Agwu's Slops",
        feet = "Serpentes Sabots"
    }


    -- Idle sets

    -- Normal refresh idle set
    sets.idle = {
        main = "Lehbrailg +2",
        sub = "Enki Strap",
        ammo = "Staunch Tathlum +1",
        head = "Nefer Khat +1",
        neck = "Loricate Torque +1",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Heka's Kalasiris",
        hands = "Serpentes Cuffs",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Umbra Cape",
        waist = "Shinjutsu-no-obi +1",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    -- Idle mode that keeps PDT gear on, but doesn't prevent normal gear swaps for precast/etc.
    sets.idle.PDT = {
        main = "Earth Staff",
        sub = "Enki Strap",
        ammo = "Staunch Tathlum +1",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Defending Ring",
        ring2 = gear.DarkRing.physical,
        back = "Umbra Cape",
        waist = "Shinjutsu-no-obi +1",
        legs = "Agwu's Slops",
        feet = "Crier's Gaiters"
    }

    -- Idle mode scopes:
    -- Idle mode when weak.
    sets.idle.Weak = sets.idle.PDT

    -- Town gear.
    sets.idle.Town = {
        main = "Lehbrailg +2",
        sub = "Enki Strap",
        ammo = "Staunch Tathlum +1",
        head = "Agwu's Cap",
        neck = "Bathy Choker +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Sheltered Ring",
        ring2 = "Shadow Ring",
        back = "Umbra Cape",
        waist = "Shinjutsu-no-obi +1",
        legs = "Agwu's Slops",
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
        main = "Earth Staff",
        sub = "Enki Strap",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Defending Ring",
        ring2 = gear.DarkRing.physical,
        back = "Umbra Cape",
        waist = "Platinum Moogle Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.defense.MDT = {
        ammo = "Staunch Tathlum +1",
        head = "Agwu's Cap",
        neck = "Loricate Torque +1",
        body = "Agwu's Robe",
        hands = "Agwu's Gages",
        ring1 = "Defending Ring",
        ring2 = "Shadow Ring",
        back = "Moonlight Cape",
        waist = "Platinum Moogle Belt",
        legs = "Agwu's Slops",
        feet = "Agwu's Pigaches"
    }

    sets.Kiting = { feet = "Crier's Gaiters" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.

    sets.buff['Mana Wall'] = { feet = "Goetia Sabots +2" }

    sets.magic_burst = { neck = "Mizukage-no-Kubikazari" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        head = "Nyame Helm",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Nyame Mail",
        hands = "Gazu Bracelets +1",
        ring1 = "Chirich Ring +1",
        ring2 = "Lehko's Ring",
        back = "Umbra Cape",
        waist = "Windbuffet Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Cure' or spellMap == 'Curaga' then
        gear.default.obi_waist = "Cornelia's Belt"
    elseif spell.skill == 'Elemental Magic' then
        gear.default.obi_waist = "Sekhmet Corset"
        if state.CastingMode.value == 'Low' then
            classes.CustomClass = 'Low'
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if not spell.interrupted then
        if spell.english == 'Mana Wall' then
            enable('feet')
            equip(sets.buff['Mana Wall'])
            disable('feet')
        elseif spell.skill == 'Elemental Magic' then
            state.MagicBurst:reset()
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock feet when Mana Wall buff is lost.
    if buff == "Mana Wall" and not gain then
        enable('feet')
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
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

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        --[[ No real need to differentiate with current gear.
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
        --]]
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
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
    set_macro_page(1, 20)
end
