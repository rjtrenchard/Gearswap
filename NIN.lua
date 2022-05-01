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

    determine_haste_group()
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

    gear.default.obi_waist = "Eschan Stone"

    gear.NormalShuriken = 'Togakushi Shuriken'
    gear.SangeShuriken = 'Happo Shuriken'
    gear.Shuriken = {name=gear.NormalShuriken}

    --options.ammo_warning_limit = 15

    gear.MovementFeet = {name="Danzo Sune-ate"}
    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = gear.DayFeet --"Hachiya Kyahan"

    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17*60 or myTime == 7*60) then 
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
    return (world.time >= 17*60 or world.time < 7*60)
end

function user_unload()
    windower.unregister_event(ticker)
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    sets.Enmity = {ammo="Sapience Orb",
        ear1="Trux Earring",ear2="Cryptic Earring",
        ring1="Supershear Ring",ring2="Petrov Ring",
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Mijin Gakure'] = {legs="Mochizuki Hakama"}
    sets.precast.JA['Futae'] = {legs="Iga Tekko +2"}
    sets.precast.JA['Sange'] = {ammo=gear.SangeShuriken, legs="Mochizuki Chainmail +1"}

    -- catch all for enmity spells
    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast["Divine Magic"] = sets.Enmity
    sets.precast["Dark Magic"] = sets.Enmity
    sets.precast["Blue Magic"] = sets.Enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Yamarang",
        head="Malignance Chapeau",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Malignance Tights",feet="Malignance Boots"}
        -- Uk'uxkaj Cap, Daihanshi Habaki
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Choreia Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Patricius Ring",
        back="Yokaze Mantle",waist="Chaac Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Sapience Orb",
        head="Herculean helm",ear2="Loquacious Earring",
        hands="Malignance Gloves",ring1="Kishar Ring",ring2="Prolix Ring"
    }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {back="Andartia's Mantle",neck="Magoraga Beads",body="Mochizuki Chainmail +1"})

    -- Snapshot for ranged
    sets.precast.RA = {hands="Manibozho Gloves",legs="Nahtirah Trousers",feet="Wurrukatte Boots", waist="Aquiline Belt"}
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Seething Bomblet +1",
        head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Lugra Earring +1",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring2="Epaminondas's Ring",ring1="Regal Ring",
        back="Atheling Mantle",waist="Fotia Belt",legs="Hizamaru hizayoroi",feet="Hizamaru Sune-ate"}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Jukukik Feather",hands="Buremte Gloves",
        back="Yokaze Mantle"})
    sets.precast.WS.Magic = {ammo="Seething Bomblet +1",
        head="Herculean Helm",neck="Sanctity Necklace",ear1="Hecate's Earring",ear2="Friomisi Earring",
        body="Samnuha Coat",hands="Leyline Gloves", ring1="Epaminondas's Ring", ring2="Acumen Ring",
        back="Atheling Mantle",waist=gear.ElementalObi, legs="Herculean Trousers", feet="Malignance Boots"}

    sets.precast.WS.Low = set_combine(sets.naked, 
        {main="meh",sub="meh",ammo="meh",neck="Fotia Gorget", ear1="Odr Earring", ear2="crepuscular earring",
        ring1="epona's ring",ring2="Epaminondas's Ring",
        back="atheling mantle",waist="Fotia belt"
    })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {ammo="Cath Palug Stone",
        head="Blistering Sallet +1",ear1="Odr Earring",ear2="Lugra Earring +1",
        body="Mummu Jacket +1",hands="Mummu Wrists +2",ring2="Epaminondas's Ring", ring1="Begrudging Ring",
        waist="Sveltesse Gouriz +1",legs="Zoar Subligar +1",feet="Mummu Gamashes +1"})

    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS['Blade: Hi'],{ammo="yetshila +1",
    ear1="Odr Earring",ear2="Lugra Earring +1",ring1="Ilabrat Ring",ring2="Begrudging Ring"})

    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS,{ammo="Cath Palug Stone",
        ear1="Odr Earring",ear2="Lugra Earring +1",ring1="Regal Ring",ring2="Epona's Ring"})

    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS,{neck="Caro Necklace", ear1="Moonshade Earring", waist="Sailfi Belt +1", ring1="Regal Ring", ring2="Epaminondas's Ring"})

    sets.precast.WS['Blade: Ku'] = sets.precast.WS['Blade: Shun']
    sets.precast.WS['Blade: Ku'].Low = sets.precast.WS.Low

    sets.precast.WS['Eviscaration'] = sets.precast.WS['Blade: Jin']

    sets.precast.WS['Aeolian Edge'] = {ammo="Seething Bomblet +1",
        head="Herculean Helm",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Malignance Tabard",hands="Herculean Gloves",ring1="Dingir Ring",ring2="Regal Ring",
        back="Toro Cape",waist=gear.ElementalObi,legs="Herculean Trousers",feet="Malignance Boots"}

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,{ammo="Seething Bomblet +1",
        neck="Caro Necklace",ear1="Ishvara Earring",ring1="Regal Ring",waist="Sailfi Belt +1"
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.Magic, {head='Pixie Hairpin +1', ring2="Archon Ring"})
    
    -- Magical Weaponskills
    sets.precast.WS['Blade: Teki'] = set_combine(sets.precast.WS.Magic, {})
    sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS.Magic, {head="Pixie Hairpin +1", ring2="Archon Ring"})
    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS.Magic, {})

    
    
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head="Herculean Helm",ear2="Loquacious Earring",
        body="Hachiya Chainmail +1",hands="Herculean Gloves",ring1="Prolix Ring",
        legs="Hachiya Hakama",feet="Herculean Boots"}

    sets.midcast.SIRD = {ammo="Staunch Tathlum +1"
    }
    sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu, {ammo="Togakushi Shuriken",neck="Magoraga Bead Necklace",body="",back="Andartia's Mantle",feet="Iga Kyahan +2"})

    sets.midcast.ElementalNinjutsu = {ammo="Yamarang",
        head="Hachiya Hatsuburi",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Hachiya Chainmail +1",hands="Iga Tekko +2",ring1="Dingir Ring",ring2="Metamorph Ring +1",
        back="Toro Cape",waist=gear.ElementalObi,legs="Malignance Tights",feet="Hachiya Kyahan"}

    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {
        head="Malignance Tabard",neck="Sanctity Necklace",ear1="Crepuscular Earring",ear2="Gwati Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Stikini Ring +1", ring2="Stikini Ring +1",
        back="Yokaze Mantle", waist="Eschan Stone", legs="Malignance Tights", boots="Malignance Boots"})

    sets.midcast.NinjutsuDebuff = {ammo="Yamarang",
        head="Hachiya Hatsuburi",neck="Sanctity Necklace",ear1="Crepuscular Earring",ear2="Gwati Earring",
        hands="Mochizuki Tekko",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Yokaze Mantle",waist="Eschan Stone",legs="Malignance Rights",feet="Hachiya Kyahan"}
    sets.midcast['Kurayami: Ni'] = set_combine(sets.midcast.NinjutsuDebuff, {ring1="Archon Ring"})
    sets.midcast['Kurayami: Ichi'] = sets.midcast['Kurayami: Ni']
    sets.midcast['Yurin: Ichi'] = sets.midcast['Kurayami: Ni']

    sets.midcast.NinjutsuBuff = {head="Hachiya Hatsuburi",neck="Sanctity Necklace",hands="Mochizuki Tekko",ring1="Stikini Ring +1",ring2="Stikini Ring +1",back="Yokaze Mantle"}

    sets.midcast.RA = {
        head="Malignance Chapeau",neck="Sanctity Necklace",
        body="Malignance Tabard",hands="Hachiya Tekko",ring1="Longshot Ring",ring2="Dingir Ring",
        back="Yokaze Mantle",legs="Malignance Tights",feet="Malignance Boots"}
    -- Hachiya Hakama/Thurandaut Tights +1

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
    
    -- Resting sets
    sets.resting = {neck="Sanctity Necklace",
        body="hizamaru haramaki",ring1="Sheltered Ring",ring2="Defending Ring"}
    
    -- Idle sets
    sets.idle = {
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="Eabani Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Atheling Mantle",waist="Flume Belt +1",legs="Malignance Tights",feet=gear.MovementFeet}

    sets.idle.Town = {main="Raimitsukane",sub="Kaitsuburi",ammo="Togakushi Shuriken",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="Eabani Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Atheling Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet=gear.MovementFeet}
    
    sets.idle.Weak = {
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Suppamonimi",ear2="crepuscular earring",
        body="Hizamaru Haramaki",hands="Malignance Gloves",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Flume Belt +1",legs="Malignance Tights",feet=gear.MovementFeet}
    
    -- Defense sets
    sets.defense.Evasion = {
        head="Malignance Chapeau",neck="Sanctity Necklace",
        body="Mochizuki Chainmail +1",hands="Malignance Gloves",ring1="Defending Ring",ring2="Ilabrat Ring",
        back="Yokaze Mantle",waist="Flume Belt +1",legs="Malignance Tights",feet="Hizamaru Sune-ate"}

    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Malignance Chapeau",neck="Loricate Torque +1",
        body="Mochizuki Chainmail +1",hands="Malignance Gloves",ring2="Defending Ring",ring1="Epona's Ring",
        back="Shadow Mantle",waist="Flume Belt +1",legs="Malignance Tights",feet="Hizamaru Sune-ate"}

    sets.defense.MDT = {ammo="Demonry Stone",
        head="Malignance Chapeau",neck="Loricate Torque +1",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Defending Ring",ring1="Archon Ring",
        back="Engulfer Cape",waist="Flume Belt +1",legs="Malignance Tights",feet="Hizamaru Sune-ate"}


    sets.Kiting = {feet=gear.MovementFeet}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Suppanomimi",ear2="Brutal Earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Reiki Yotai",legs="Hizamaru Hizayoroi",feet="Hizamaru sune-ate"}
    sets.engaged.Acc = {ammo="Togakushi Shuriken",
        head="Malignance Chapeau",neck="Combatant's Torque",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Evasion = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Combatant's Torque",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.Evasion = {ammo="Togakushi Shuriken",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet="Hizamaru Sune-ate"}
    sets.engaged.PDT = {ammo="Togakushi Shuriken",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Acc.PDT = {ammo="Togakushi Shuriken",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}

    -- Custom melee group: High Haste (~20% DW)
    sets.engaged.HighHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Reiki Yotai",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.HighHaste = {ammo="Yamagarang",
        head="Malignance Chapeau",neck="Iskur Gorget",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Evasion.HighHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Hachiya Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.Evasion.HighHaste = {ammo="Yamarang",
        head="Adhemar Bonnet +1",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}
    sets.engaged.PDT.HighHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.PDT.HighHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Reiki Yotai",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}

    -- Custom melee group: Embrava Haste (7% DW)
    sets.engaged.EmbravaHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.EmbravaHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Sailfi Belt +1",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}
    sets.engaged.Evasion.EmbravaHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Windbuffet Belt",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.Evasion.EmbravaHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Sanctity Necklace",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Sailfi Belt +1",legs="Hachiya Hakama",feet="Hizamaru Sune-ate"}
    sets.engaged.PDT.EmbravaHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Windbuffet Belt",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.PDT.EmbravaHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Sailfi Belt +1",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}

    -- Custom melee group: Max Haste (0% DW)
    sets.engaged.MaxHaste = {ammo="Togakushi Shuriken",
        head="Adhemar Bonnet +1",neck="Iskur Gorget",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Mochizuki Chainmail +1",hands="Adhemar Wristbands +1",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Kentarch Belt",legs="Hizamaru Hizayoroi",feet="Hizamaru Sune-ate"}
    sets.engaged.Acc.MaxHaste = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Iskur Gorget",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Evasion.MaxHaste = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Windbuffet Belt",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Acc.Evasion.MaxHaste = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.PDT.MaxHaste = {ammo="Togakushi Shuriken",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Windbuffet Belt",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Acc.PDT.MaxHaste = {ammo="Yamarang",
        head="Malignace Chapeau",neck="Loricate Torque +1",ear1="Brutal Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Epona's Ring",
        back="Yokaze Mantle",waist="Windbuffet Belt",legs="Malignance Tights",feet="Malignance Boots"}


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    --sets.buff.Migawari = {body="Iga Ningi +2"}
    --sets.buff.Doom = {ring2="Saida Ring"}
    sets.buff.Yonin = {}
    sets.buff.Innin = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------


function job_precast(spell, action, spellMap, eventArgs)
    -- ensure there is viable shuriken
    do_shuriken_check(spell, spellMap, eventArgs)

    --handle Sange
    if spell.english == 'Sange' then
        gear.Shuriken = {name=gear.SangeShuriken}
    else
        gear.Shuriken = {name=gear.NormalShuriken}
    end
end

function do_shuriken_check(spell, spellMap, eventArgs)
    local shuriken_name = gear.SangeShuriken
    local available_shuriken = player.inventory[shuriken_name] or player.wardrobe[shuriken_name] or player.wardrobe2[shuriken_name] or player.wardrobe3[shuriken_name] or player.wardrobe4[shuriken_name]

    -- ensure ammo exists
    if not available_shuriken then
        add_to_chat(104, 'No Ammo ('..tostring(shuriken_name)..') available for that action.')
        --eventArgs.cancel = true
        return
    end
end

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

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end

    if S{'Sange'}:contains(buff:lower()) then 
        if not buffactive.Sange then 
            gear.Shuriken = {name=gear.NormalShuriken}
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
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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
    
    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.march == 2 or (buffactive.march and buffactive.haste)) then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march) then
        classes.CustomMeleeGroups:append('EmbravaHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end

function select_weaponskill_ears()
    if world.time >= 17*60 or world.time < 7*60 then
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
    --[[end]]--   
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
    send_command( "@wait 5;input /lockstyleset 2" )
end

