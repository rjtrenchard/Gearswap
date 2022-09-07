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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false

    -- determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water' }

    gear.default.obi_waist = "Eschan Stone"

    gear.NormalShuriken = 'Togakushi Shuriken'
    gear.SangeShuriken = 'Happo Shuriken'


    --options.ammo_warning_limit = 15

    gear.MovementFeet = { name = "Danzo Sune-ate" }
    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = gear.DayFeet --"Hachiya Kyahan"

    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17 * 60 or myTime == 7 * 60) then
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    --procTime(world.time) -- initial setup of proctime

    select_default_macro_book()
end

function procTime(myTime)
    if isNight() then
        gear.MovementFeet = gear.NightFeet
    else
        gear.MovementFeet = gear.DayFeet
    end
end

function isNight() -- this originally was used a lot more, so I just left it.
    return (world.time >= 17 * 60 or world.time < 7 * 60)
end

function user_unload()
    windower.unregister_event(ticker)
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.fc_head = { name = "Herculean Helm", augments = { 'Mag. Acc.+18', '"Fast Cast"+6', 'MND+8', } }

    sets.SIRD = { ammo = "Staunch Tathlum +1",
        -- head="Taeon Chapeau" -- 10
        neck = "Moonlight Necklace", ear1 = "Halasz Earring", ear2 = "Magnetic Earring",
        --body="Taeon Tabard", -- 10
        hands = "Rawhide Gloves", ring1 = "Evanescence Ring",
        --back="Andartia's Mantle", -- 10
        waist = "Audumbla Sash",
        --legs="Taeon Tights", feet="Taeon Boots" -- 40
    }

    sets.enmity = { ammo = "Sapience Orb",
        head = "Halitus Helm", neck = "Unmoving Collar +1", ear1 = "Trux Earring", ear2 = "Cryptic Earring",
        body = "Emet Harness +1", ring1 = "Supershear Ring", ring2 = "Eihwaz Ring",
        waist = "Trance Belt", legs = "Zoar Subligar +1"
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Mijin Gakure'] = { legs = "Mochizuki Hakama +1" }
    sets.precast.JA['Futae'] = { legs = "Iga Tekko +2" }
    sets.precast.JA['Sange'] = { legs = "Mochizuki Chainmail +1" }
    sets.precast.JA['Yonin'] = { head = "Mochizuki Hatsuburi" }
    sets.precast.JA['Innin'] = sets.precast.JA['Yonin']

    -- catch all for enmity spells
    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast["Divine Magic"] = sets.Enmity
    sets.precast["Dark Magic"] = sets.Enmity
    sets.precast["Blue Magic"] = sets.Enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = { ammo = "Yamarang",
        head = "Malignance Chapeau",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Spiral Ring",
        back = "Iximulew Cape", waist = "Caudata Belt", legs = "Malignance Tights", feet = "Malignance Boots" }
    -- Uk'uxkaj Cap, Daihanshi Habaki

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Sanctity Necklace", ear1 = "Choreia Earring", ear2 = "Crepuscular Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Patricius Ring",
        back = "Yokaze Mantle", waist = "Chaac Belt", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.precast.Flourish1 = { waist = "Chaac Belt" }

    -- Fast cast sets for spells

    sets.precast.FC = { ammo = "Sapience Orb",
        head = gear.fc_head, neck = "Orunmila's Torque", ear1 = "Enchanter's Earring +1", ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1", hands = "Leyline Gloves", ring1 = "Kishar Ring", ring2 = "Weatherspoon Ring +1",
        back = "Andartia's Mantle", legs = "Gyve Trousers", }

    -- Snapshot for ranged
    sets.precast.RA = {
        head = "Aurore Beret +1", hands = "Manibozho Gloves", ring1 = "Crepuscular Ring",
        legs = "Adhemar Kecks +1", feet = "Wurrukatte Boots",
    }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Seething Bomblet +1",
        head = "Adhemar Bonnet +1", neck = "Fotia Gorget", ear1 = "Brutal Earring", ear2 = "Lugra Earring +1",
        body = "Mochizuki Chainmail +1", hands = "Adhemar Wristbands +1", ring1 = "Regal Ring",
        ring2 = "Epaminondas's Ring",
        back = "Atheling Mantle", waist = "Fotia Belt", legs = "Samnuha Tights", }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    sets.precast.WS.Magic = { ammo = "Seething Bomblet +1",
        head = "Herculean Helm", neck = "Sibyl Scarf", ear1 = "Hecate's Earring", ear2 = "Friomisi Earring",
        body = "Samnuha Coat", hands = "Leyline Gloves", ring1 = "Epaminondas's Ring", ring2 = "Dingir Ring",
        back = "Atheling Mantle", waist = gear.ElementalObi, legs = "Herculean Trousers", feet = "Malignance Boots" }

    sets.precast.WS.Low = set_combine(sets.naked,
        { main = empty, sub = empty, ammo = empty, neck = "Fotia Gorget", ear1 = "Sherida Earring",
            ear2 = "Crepuscular Earring",
            ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
            waist = "Fotia belt"
        })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", ear1 = "Odr Earring", ear2 = "Lugra Earring +1",
        body = "Mpaca's Doublet", hands = "Mpaca's Gloves", ring1 = "Begrudging Ring", ring2 = "Epaminondas's Ring",
        waist = "Gerdr Belt +1", legs = "Zoar Subligar +1", feet = "Mpaca's Boots" })

    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS['Blade: Hi'], {
        ear1 = "Odr Earring", ear2 = "Lugra Earring +1",
        ring1 = "Begrudging Ring", ring2 = "Ilabrat Ring"
    })

    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, { ammo = "Cath Palug Stone",
        ear1 = "Odr Earring", ear2 = "Lugra Earring +1",
        ring1 = "Regal Ring", ring2 = "Epona's Ring" })

    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum medal", ear1 = "Moonshade Earring",
        ring1 = "Regal Ring", ring2 = "Epaminondas's Ring",
        waist = "Sailfi Belt +1"
    })

    sets.precast.WS['Blade: Ku'] = sets.precast.WS['Blade: Shun']
    sets.precast.WS['Blade: Ku'].Low = sets.precast.WS.Low

    sets.precast.WS['Eviscaration'] = sets.precast.WS['Blade: Jin']

    sets.precast.WS['Aeolian Edge'] = { ammo = "Seething Bomblet +1",
        head = "Herculean Helm", neck = "Sanctity Necklace", ear1 = "Friomisi Earring", ear2 = "Moonshade Earring",
        body = "Malignance Tabard", hands = "Herculean Gloves", ring1 = "Dingir Ring", ring2 = "Regal Ring",
        back = "Toro Cape", waist = gear.ElementalObi, legs = "Herculean Trousers", feet = "Malignance Boots" }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { ammo = "Seething Bomblet +1",
        neck = "Republican Platinum medal", ear1 = "Ishvara Earring", ear2 = "Moonshade Earring",
        ring1 = "Regal Ring", ring2 = "Epaminondas's Ring",
        waist = "Sailfi Belt +1"
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.Magic,
        { head = 'Pixie Hairpin +1', ring2 = "Archon Ring" })

    -- Magical/Hybrid Weaponskills
    sets.precast.WS['Blade: Teki'] = set_combine(sets.precast.WS.Magic, {})
    sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS.Magic,
        { head = "Pixie Hairpin +1", ring2 = "Archon Ring" })
    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS.Magic, {})
    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS.Magic, {})

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.Trust = sets.SIRD

    sets.midcast.FastRecast = {
        head = "Herculean Helm", ear2 = "Loquacious Earring",
        body = "Hachiya Chainmail +1", hands = "Herculean Gloves",
        legs = "Hachiya Hakama", feet = "Herculean Boots"
    }

    sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu,
        { back = "Andartia's Mantle", feet = "Iga Kyahan +2" })

    sets.midcast.ElementalNinjutsu = { ammo = "Ghastly Tathlum +1",
        head = "Hachiya Hatsuburi", neck = "Sibyl Scarf", ear1 = "Friomisi Earring", ear2 = "Hecate's Earring",
        body = "Hachiya Chainmail +1", hands = "Iga Tekko +2", ring1 = "Dingir Ring", ring2 = "Metamorph Ring +1",
        back = "Toro Cape", waist = gear.ElementalObi, legs = "Malignance Tights", feet = "Hachiya Kyahan" }

    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {
        head = "Malignance Tabard", neck = "Sanctity Necklace", ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = "Yokaze Mantle", waist = "Eschan Stone", legs = "Malignance Tights", boots = "Malignance Boots"
    })

    sets.midcast.ElementalNinjutsu.burst = set_combine(sets.midcast.ElementalNinjutsu, {})

    sets.midcast.NinjutsuDebuff = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Moonlight Necklace", ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = "Yokaze Mantle", waist = "Eschan Stone", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.midcast['Kurayami: Ni'] = set_combine(sets.midcast.NinjutsuDebuff, { ring1 = "Archon Ring" })
    sets.midcast['Kurayami: Ichi'] = sets.midcast['Kurayami: Ni']
    sets.midcast['Yurin: Ichi'] = sets.midcast['Kurayami: Ni']

    sets.midcast.NinjutsuBuff = { head = "Hachiya Hatsuburi", hands = "Mochizuki Tekko",
        ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1", back = "Yokaze Mantle" }

    sets.midcast.RA = {
        head = "Malignance Chapeau", neck = "Iskur Gorget", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Crepuscular Ring", ring2 = "Dingir Ring",
        back = "Yokaze Mantle", waist = "Yemaya Belt", legs = "Malignance Tights", feet = "Malignance Boots"
    }
    -- Hachiya Hakama/Thurandaut Tights +1

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = { neck = "Sanctity Necklace",
        body = "hizamaru haramaki", ring1 = "Sheltered Ring", ring2 = "Defending Ring" }

    -- Idle sets
    sets.idle = {
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Etiolation Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Sheltered Ring", ring2 = "Defending Ring",
        back = "Atheling Mantle", waist = "Flume Belt +1", legs = "Malignance Tights", feet = gear.MovementFeet
    }

    sets.idle.Town = {
        head = "Shaded Spectacles", neck = "Smithy's Torque",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.idle_cape, waist = "Blacksmith's Belt", feet = gear.MovementFeet
    }

    sets.idle.Weak = {
        head = "Malignance Chapeau", neck = "Bathy Choker +1", ear1 = "Odnowa Earring +1", ear2 = "Etiolation Earring",
        body = "Hizamaru Haramaki", hands = "Malignance Gloves", ring1 = "Sheltered Ring", ring2 = "Defending Ring",
        back = "Shadow Mantle", waist = "Flume Belt +1", legs = "Malignance Tights", feet = gear.MovementFeet
    }

    -- Defense sets
    sets.defense.Evasion = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring", ring2 = "Ilabrat Ring",
        back = "Yokaze Mantle", waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.defense.PDT = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring",
        back = "Yokaze Mantle", waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.defense.MDT = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring",
        back = "Yokaze Mantle", waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }


    sets.Kiting = { feet = gear.MovementFeet }


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = { ammo = "Togakushi Shuriken",
        head = "Adhemar Bonnet +1", neck = "Iskur Gorget", ear1 = "Brutal Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Adhemar Wristbands +1", ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
        back = "Atheling Mantle", waist = "Reiki Yotai", legs = "Samnuha Tights", feet = "Hizamaru sune-ate" }
    sets.engaged.Acc = { ammo = "Togakushi Shuriken",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Ilabrat Ring", ring2 = "Epona's Ring",
        back = "Yokaze Mantle", waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.Evasion = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
        back = "Yokaze Mantle", waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.Acc.Evasion = { ammo = "Togakushi Shuriken",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Ilabrat Ring", ring2 = "Epona's Ring",
        back = "Yokaze Mantle", waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.PDT = { ammo = "Togakushi Shuriken",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Brutal Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring", ring2 = "Epona's Ring",
        back = "Yokaze Mantle", waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.Acc.PDT = { ammo = "Togakushi Shuriken",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring", ring2 = "Epona's Ring",
        back = "Yokaze Mantle", waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }


    sets.engaged.MaxDW = set_combine(sets.engaged, {})
    sets.engaged.Acc = set_combine(sets.engaged.Acc, {})
    sets.engaged.Evasion = set_combine(sets.engaged.Evasion, {})
    sets.engaged.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, {})
    sets.engaged.PDT = set_combine(sets.engaged.PDT, {})
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc.PDT, {})


    -- accessories only
    sets.DTDW = { ear1 = "Eabani Earring", ear2 = "Suppanomimi", waist = "Reiki Yotai" }

    -- need 39 DW
    sets.MaxDW = { ear2 = "Suppanomimi",
        body = "Mochizuki Chainmail +3",
        waist = "Reiki Yotai", legs = "Mochizuki Hakama +3", feet = "Hizamaru Sune-ate +2" }
    sets.engaged.MaxDW = set_combine(sets.engaged, sets.MaxDW)
    sets.engaged.Acc = set_combine(sets.engaged.Acc, sets.MaxDW)
    sets.engaged.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)

    -- need 21 DW
    sets.MidDW = { ear2 = "Suppanomimi", waist = "Reiki Yotai", legs = "Mochizuki Hakama +3" }
    sets.engaged.MaxDW = set_combine(sets.engaged, sets.MidDW)
    sets.engaged.Acc = set_combine(sets.engaged.Acc, sets.MidDW)
    sets.engaged.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)

    -- need 1 DW
    sets.MinDW = { waist = "Kentarch Belt +1" }
    sets.engaged.MaxDW = set_combine(sets.engaged, sets.MinDW)
    sets.engaged.Acc = set_combine(sets.engaged.Acc, sets.MinDW)
    sets.engaged.Evasion = set_combine(sets.engaged.Evasion, sets.MinDW)
    sets.engaged.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.MinDW)
    sets.engaged.PDT = set_combine(sets.engaged.PDT, sets.MinDW)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.MinDW)
    --------------------------------------
    -- Custom buff sets
    --------------------------------------


    sets.buff.doom = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring",
        back = gear.DDCape, waist = "Gishdubar Sash", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.buff.doom.HolyWater = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Blenmot's Ring +1", ring2 = "Blenmot's Ring +1",
        back = gear.DDCape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.buff.Migawari = { body = "Hattori Ningi +2" }
    sets.buff.Yonin = {}
    sets.buff.Innin = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.english == 'Sange' and not shuriken_check() then
        eventArgs.cancel = true
    end
end

-- function job_precast(spell, action, spellMap, eventArgs)
-- end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if buffactive['Sange'] and shuriken_check() then
        equip({ sets.SangeShuriken })
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function shuriken_check()
    local shuriken_name = gear.SangeShuriken
    local available_shuriken = player.inventory[shuriken_name] or player.wardrobe[shuriken_name] or
        player.wardrobe2[shuriken_name] or player.wardrobe3[shuriken_name] or player.wardrobe4[shuriken_name] or
        player.wardrobe5[shuriken_name] or player.wardrobe6[shuriken_name] or player.wardrobe7[shuriken_name] or
        player.wardrobe8[shuriken_name]

    -- ensure ammo exists
    if not available_shuriken then
        windower.add_to_chat(104, 'No Ammo (' .. tostring(shuriken_name) .. ') available for that action.')
        return false
    end
    return true
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- if 'Sange' == buff then
    --     if gain then
    --         if not shuriken_check() then
    --             send_command('cancel sange')
    --             return
    --         end
    --         sange_event = windower.register_event('action', function(act)
    --             if act.category == 01 then
    --                 if player.equipment.ammo ~= gear.SangeShuriken then
    --                     send_command('input /equip ammo ' .. gear.SangeShuriken)
    --                 elseif player.equipment.ammo == gear.NormalShuriken and (gear.NormalShuriken ~= gear.SangeShuriken) then
    --                     send_command('input /equip ammo')
    --                     send_command('cancel sange')
    --                 end
    --             end
    --         end)

    --     else
    --         windower.unregister_event(sange_event)
    --     end

    -- print(buff:lower(), buffactive.haste)
    if gain then
        if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
            calculate_haste()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charmed')
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        end
    else
        if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
            calculate_haste()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off')
        elseif buff == 'doom' then
            send_command('input /p Doom off')
            send_command('gs c update')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
                return 'NinjutsuDebuff'
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    procTime(world.time)
    determine_haste_group()

    if buffactive['Sange'] then send_command('input /equip ammo ' .. gear.SangeShuriken) end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function calculate_haste()
    local haste = 0


    if buffactive.march == 1 then
        -- assume honor march for single march song
        haste = haste + 16.99
    elseif buffactive.march == 2 then
        haste = 43.75
    end

    if buffactive.haste == 1 then
        -- assume haste II
        haste = haste + 30
    elseif buffactive.haste == 2 then
        -- cornelia active
        haste = 43.75
    end

    if buffactive.embrava then
        haste = haste + 25.9
    end

    if buffactive['haste samba'] then
        haste = haste + 5
    end

    classes.CustomMeleeGroups:clear()
    if haste <= 29 then
        -- equip up to 64 DW
        classes.CustomMeleeGroups:append('MaxDW')
    elseif haste > 29 and haste < 43.75 then
        -- equip up to 31 DW
        classes.CustomMeleeGroups:append('MidDW')
    elseif haste >= 43.75 then
        -- equip 11 DW
        classes.CustomMeleeGroups:append('MinDW')
    end

end

function determine_haste_group()
    -- We have three groups of DW in gear: Hachiya body/legs, Iga head + Reiki Yotai, and DW earrings

    -- Standard gear set reaches near capped delay with just Haste (77%-78%, depending on HQs)

    -- For high haste, we want to be able to drop one of the 10% groups.
    -- Basic gear hits capped delay (roughly) with:
    -- 1 March + Haste
    -- 2 March
    -- Haste + Haste Samba
    -- 1 March + Haste Samba
    -- Embrava

    -- High haste buffs:
    -- 2x Marches + Haste Samba == 19% DW in gear
    -- 1x March + Haste + Haste Samba == 22% DW in gear
    -- Embrava + Haste or 1x March == 7% DW in gear

    -- For max haste (capped magic haste + 25% gear haste), we can drop all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste+March or 2x March
    -- 2x Marches + Haste

    -- So we want four tiers:
    -- Normal DW
    -- 20% DW -- High Haste
    -- 7% DW (earrings) - Embrava Haste (specialized situation with embrava and haste, but no marches)
    -- 0 DW - Max Haste

    -- classes.CustomMeleeGroups:clear()

    -- if buffactive.embrava and (buffactive.march == 2 or (buffactive.march and buffactive.haste)) then
    --     classes.CustomMeleeGroups:append('MaxHaste')
    -- elseif buffactive.march == 2 and buffactive.haste then
    --     classes.CustomMeleeGroups:append('MaxHaste')
    -- elseif buffactive.embrava and (buffactive.haste or buffactive.march) then
    --     classes.CustomMeleeGroups:append('EmbravaHaste')
    -- elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
    --     classes.CustomMeleeGroups:append('HighHaste')
    -- elseif buffactive.march == 2 then
    --     classes.CustomMeleeGroups:append('HighHaste')
    -- end

end

function select_weaponskill_ears()
    if world.time >= 17 * 60 or world.time < 7 * 60 then
        gear.WSEar1.name = gear.WSNightEar1
        gear.WSEar2.name = gear.WSNightEar2
    else
        gear.WSEar1.name = gear.WSDayEar1
        gear.WSEar2.name = gear.WSDayEar2
    end
end

function update_combat_form()
    --[[if areas.Adoulin:contains(world.area) and buffactive.ionis then
        state.CombatForm:set('Adoulin')
    --else]]
    state.CombatForm:reset()
    --[[end]] --
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(4, 13)
    elseif player.sub_job == 'THF' then
        set_macro_page(5, 13)
    else
        set_macro_page(2, 13)
    end
    send_command("@wait 5;input /lockstyleset 2")
end
