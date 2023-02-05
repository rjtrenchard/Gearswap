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

    calculate_haste()
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S { 35, 204 }
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S { 201, 202, 203, 205, 207 }


end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water' }

    gear.default.obi_waist = "Eschan Stone"

    gear.NormalShuriken = 'Date Shuriken'
    gear.SangeShuriken = 'Happo Shuriken'


    --options.ammo_warning_limit = 15


    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = "Hachiya Kyahan +1"
    gear.MovementFeet = { gear.DayFeet }


    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17 * 60 or myTime == 7 * 60) then
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                job_update()
            end
        end
    end)

    --procTime(world.time) -- initial setup of proctime

    send_command('bind numpad7 gs equip sets.Weapons.Katana')
    send_command('bind numpad8 gs equip sets.Weapons.Naegling')

    send_command('bind numpad4 input /nin \"Raiton: San\"')
    send_command('bind numpad5 input /nin \"Doton: San\"')
    send_command('bind numpad6 input /nin \"Huton: San\"')
    send_command('bind numpad1 input /nin \"Hyoton: San\"')
    send_command('bind numpad2 input /nin \"Katon: San\"')
    send_command('bind numpad3 input /nin \"Suiton: San\"')

    send_command('bind numpad0 gs equip sets.resist.death')

    select_default_macro_book()
end

function procTime(myTime)
    if isNight() then
        gear.MovementFeet.name = gear.NightFeet
    else
        gear.MovementFeet.name = gear.DayFeet
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
    sets.Weapons = {}
    sets.Weapons.Katana = { main = "Kunimitsu", sub = "Crepuscular Knife" }
    sets.Weapons.Naegling = { main = "Naegling", sub = "Hitaki" }

    gear.fc_head = { name = "Herculean Helm", augments = { 'Mag. Acc.+18', '"Fast Cast"+6', 'MND+8', } }

    gear.da_cape = { name = "Andartia's Mantle",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', '"Dbl.Atk."+10', '"Phys. dmg. taken -10"' } }
    gear.stp_cape = gear.da_cape
    gear.dw_cape = gear.da_cape
    gear.str_ws_cape = { name = "Sacro Mantle" }
    gear.blade_hi_cape = { name = "Sacro Mantle" }
    gear.matk_cape = { name = "Sacro Mantle" }
    gear.magic_ws_cape = { name = "Sacro Mantle" }
    gear.fc_cape = gear.da_cape
    gear.idle_cape = gear.da_cape

    sets.SIRD = { ammo = "Staunch Tathlum +1",
        -- head="Taeon Chapeau" -- 10
        neck = "Moonlight Necklace", ear1 = "Halasz Earring", ear2 = "Magnetic Earring",
        --body="Taeon Tabard", -- 10
        hands = "Rawhide Gloves", ring1 = "Evanescence Ring",
        --back="Andartia's Mantle", -- 10
        waist = "Audumbla Sash", c
        --legs="Taeon Tights", feet="Taeon Boots" -- 40
    }

    sets.enmity = { ammo = "Sapience Orb",
        head = "Halitus Helm", neck = "Unmoving Collar +1", ear1 = "Trux Earring", ear2 = "Cryptic Earring",
        body = "Emet Harness +1", ring1 = "Supershear Ring", ring2 = "Eihwaz Ring",
        waist = "Trance Belt", legs = "Zoar Subligar +1", feet = "Mochizuki Kyahan +3"
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Mijin Gakure'] = { legs = "Mochizuki Hakama +3" }
    sets.precast.JA['Futae'] = { legs = "Hattori Tekko +2" }
    sets.precast.JA['Sange'] = { legs = "Mochizuki Chainmail +3" }
    sets.precast.JA['Yonin'] = { head = "Mochizuki Hatsuburi +3" }
    sets.precast.JA['Innin'] = sets.precast.JA['Yonin']

    -- catch all for enmity spells
    sets.precast.JA['Provoke'] = sets.Enmity
    sets.midcast["Divine Magic"] = sets.Enmity
    sets.midcast["Dark Magic"] = sets.Enmity
    sets.midcast["Blue Magic"] = sets.Enmity

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
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Choreia Earring", ear2 = "Crepuscular Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Patricius Ring",
        back = "Sacro Mantle", waist = "Chaac Belt", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.precast.Flourish1 = { waist = "Chaac Belt" }

    -- Fast cast sets for spells

    sets.precast.FC = { ammo = "Sapience Orb",
        head = gear.fc_head, neck = "Orunmila's Torque", ear1 = "Enchanter's Earring +1", ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1", hands = "Leyline Gloves", ring1 = "Kishar Ring", ring2 = "Weatherspoon Ring +1",
        back = "Andartia's Mantle", legs = "Gyve Trousers", }

    sets.precast.FC.Ninjutsu = set_combine(sets.precast.FC, { ammo = "Impatiens", ring1 = "Lebeche Ring" })

    -- Snapshot for ranged
    sets.precast.RA = {
        head = "Aurore Beret +1", hands = "Manibozho Gloves", ring1 = "Crepuscular Ring",
        legs = "Adhemar Kecks +1", feet = "Wurrukatte Boots",
    }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Oshasha's Treatise",
        head = "Nyame Helm", neck = "Fotia Gorget", ear1 = "Moonshade Earring", ear2 = "Lugra Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Regal Ring", ring2 = "Epaminondas's Ring",
        back = gear.str_ws_cape, waist = "Fotia Belt", legs = "Mochizuki Hakama +3", feet = "Hattori Kyahan +2"
    }
    sets.precast.MultiHit = { ammo = "Seething Bomblet +1",
        head = "Mpaca's Cap", neck = "Fotia Gorget", ear1 = "Brutal Earring", ear2 = "Lugra Earring +1",
        body = "Mpaca's Doublet", hands = "Mpaca's Gloves", ring1 = "Epona's Ring",
        ring2 = "Gere Ring",
        back = gear.da_cape, waist = "Fotia Belt", legs = "Mpaca's Hose", feet = "Mpaca's Boots", }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    sets.precast.WS.Magic = { ammo = "Seething Bomblet +1",
        head = "Nyame Helm", neck = "Sibyl Scarf", ear1 = "Hecate's Earring", ear2 = "Friomisi Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Epaminondas's Ring", ring2 = "Dingir Ring",
        back = gear.magic_ws_cape, waist = gear.ElementalObi, legs = "Nyame Flanchard", feet = "Nyame Sollerets" }

    sets.precast.WS.Low = set_combine(sets.naked,
        { main = "", sub = "", ammo = "", neck = "Fotia Gorget", ear1 = "Sherida Earring",
            ear2 = "Crepuscular Earring",
            ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
            waist = "Fotia belt"
        })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", ear1 = "Odr Earring", ear2 = "Lugra Earring +1",
        body = "Mpaca's Doublet", hands = "Mpaca's Gloves", ring1 = "Begrudging Ring", ring2 = "Epaminondas's Ring",
        back = gear.blade_hi_cape, legs = "Zoar Subligar +1", feet = "Mpaca's Boots" })

    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS['Blade: Hi'], {
        ear1 = "Odr Earring", ear2 = "Lugra Earring +1",
        ring1 = "Begrudging Ring", ring2 = "Hetairoi Ring"
    })

    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS.MultiHit, { ammo = "Cath Palug Stone",
        head = "Adhemar Bonnet +1", ear1 = "Odr Earring", ear2 = "Lugra Earring +1",
        hands = "Adhemar Wristbands +1", ring1 = "Epona's Ring", ring2 = "Gere Ring" })

    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum medal", ear1 = "Moonshade Earring",
        hands = "Nyame Gauntlets", ring1 = "Regal Ring", ring2 = "Epaminondas's Ring",
        waist = "Sailfi Belt +1",
    })

    sets.precast.WS['Blade: Ku'] = sets.precast.WS['Blade: Shun']
    sets.precast.WS['Blade: Ku'].Low = sets.precast.WS.Low

    sets.precast.WS['Eviscaration'] = sets.precast.WS['Blade: Jin']

    sets.precast.WS['Aeolian Edge'] = { ammo = "Seething Bomblet +1",
        head = "Herculean Helm", neck = "Baetyl Pendant", ear1 = "Friomisi Earring", ear2 = "Moonshade Earring",
        body = "Malignance Tabard", hands = "Herculean Gloves", ring1 = "Dingir Ring", ring2 = "Regal Ring",
        back = gear.magic_ws_cape, waist = gear.ElementalObi, legs = "Herculean Trousers", feet = "Malignance Boots" }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { ammo = "Seething Bomblet +1",
        neck = "Republican Platinum medal", ear1 = "Lugra Earring +1", ear2 = "Moonshade Earring",
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
        head = "Malignance Chapeau", neck = "Orunmila's Torque", ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves",
        legs = "Malignance Tights", feet = "Malignance Boots"
    }

    sets.midcast["Ninjutsu"] = {
        hands = "Mochizuki Tekko +3"
    }

    sets.midcast["Ninjutsu"].Skill = {
        head = "Hachiya Hatsuburi +2", neck = "Incanter's Torque",
        ring1 = gear.left_stikini, ring2 = gear.right_stikini,
        feet = "Mochizuki Kyahan +3"
    }

    sets.midcast.SelfNinjutsu = set_combine(sets.midcast["Ninjutsu"], {})

    sets.midcast.Utsusemi = set_combine(sets.SIRD,
        { hands = "Mochizuki Tekko +3", back = "Andartia's Mantle", feet = "Hattori Kyahan +2" })

    sets.midcast.ElementalNinjutsu = { ammo = "Ghastly Tathlum +1",
        head = "Mochizuki Hatsuburi +3", neck = "Sibyl Scarf", ear1 = "Friomisi Earring", ear2 = "Hecate's Earring",
        body = "Nyame Mail", hands = "Hattori Tekko +2", ring1 = "Dingir Ring", ring2 = "Metamorph Ring +1",
        back = gear.matk_cape, waist = gear.ElementalObi, legs = "Nyame Flanchard", feet = "Mochizuki Kyahan +3" }

    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, { ammo = "Pemphredo Tathlum",
        neck = "Moonlight Necklace", ear1 = "Crepuscular Earring", ear2 = "Dignitary's Earring",
        ring1 = gear.left_stikini, ring2 = "Metamorph Ring +1",
        waist = "Eschan Stone",
    })

    sets.midcast.ElementalNinjutsu.burst = set_combine(sets.midcast.ElementalNinjutsu, {})

    sets.midcast.NinjutsuDebuff = { ammo = "Yamarang",
        head = "Hachiya Hatsuburi +2", neck = "Moonlight Necklace", ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = gear.left_stikini, ring2 = "Metamorph Ring +1",
        back = gear.matk_cape, waist = "Eschan Stone", legs = "Malignance Tights", feet = "Mochizuki Kyahan +3" }
    sets.midcast['Kurayami: Ni'] = set_combine(sets.midcast.NinjutsuDebuff, { ring1 = "Archon Ring" })
    sets.midcast['Kurayami: Ichi'] = sets.midcast['Kurayami: Ni']
    sets.midcast['Yurin: Ichi'] = sets.midcast['Kurayami: Ni']

    sets.midcast.NinjutsuBuff = {
        head = "Hachiya Hatsuburi +2", neck = "Incanter's Torque",
        hands = "Mochizuki Tekko +3", ring1 = { name = "Stikini Ring +1", bag = "wardrobe3" },
        ring2 = { name = "Stikini Ring +1", bag = "wardrobe4" },
        feet = "Mochizuki Kyahan +3"
    }

    sets.midcast.RA = {
        head = "Malignance Chapeau", neck = "Iskur Gorget", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Crepuscular Ring", ring2 = "Dingir Ring",
        back = "Sacro Mantle", waist = "Yemaya Belt", legs = "Malignance Tights", feet = "Malignance Boots"
    }
    -- Hachiya Hakama/Thurandaut Tights +1

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1",
        body = "Hizamaru Haramaki +2" }

    -- Idle sets
    sets.idle = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Tuisto Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Gelatinous Ring +1", ring2 = "Defending Ring",
        back = "Sacro Mantle", waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = gear.MovementFeet
    }

    sets.idle.Town = { ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles", neck = "Smithy's Torque", ear1 = "Odnowa Earring +1", ear2 = "Tuisto Earring",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.idle_cape, waist = "Blacksmith's Belt", legs = "Nyame Flanchard", feet = gear.MovementFeet
    }

    sets.idle.Weak = sets.idle

    -- Defense sets
    sets.defense.Evasion = { ammo = "Yamarang",
        head = "Malignance Chapeau", neck = "Bathy Choker +1", ear1 = "Odnowa Earring +1", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring", ring2 = "Ilabrat Ring",
        back = gear.dw_cape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.defense.PDT = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Tuisto Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring",
        back = gear.dw_cape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.defense.MDT = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Odnowa Earring +1", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring",
        back = gear.dw_cape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }


    sets.Kiting = { feet = gear.MovementFeet }


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = { ammo = "Date Shuriken",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Suppanomimi", ear2 = "Telos Earring",
        body = "Tatenashi Haramaki +1", hands = "Tatenashi Gote +1", ring1 = "Epona's Ring", ring2 = "Gere Ring",
        back = gear.stp_cape, waist = "Reiki Yotai", legs = "Tatenashi Haidate +1", feet = "Tatenashi Sune-ate +1" }
    sets.engaged.Acc = { ammo = "Date Shuriken",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Epona's Ring", ring2 = "Gere Ring",
        back = gear.stp_cape, waist = "Reiki Yotai", legs = "Tatenashi Haidate +1", feet = "Tatenashi Sune-ate +1" }
    sets.engaged.Evasion = { ammo = "Date Shuriken",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Epona's Ring", ring2 = "Gere Ring",
        back = gear.stp_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.Acc.Evasion = { ammo = "Date Shuriken",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Epona's Ring", ring2 = "Gere Ring",
        back = gear.stp_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.PDT = { ammo = "Date Shuriken",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Brutal Earring", ear2 = "Telos Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Gelatinous Ring +1", ring2 = "Gere Ring",
        back = gear.stp_cape, waist = "Reiki Yotai", legs = "Nyame Flanchard", feet = "Nyame Sollerets" }
    sets.engaged.Acc.PDT = { ammo = "Date Shuriken",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Gelatinous Ring +1", ring2 = "Gere Ring",
        back = gear.stp_cape, waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }


    -- accessories only
    sets.DTDW = { ear2 = "Eabani Earring", ear1 = "Suppanomimi", waist = "Reiki Yotai" }

    -- need 39 DW
    sets.MaxDW = { ear2 = "Suppanomimi",
        body = "Mochizuki Chainmail +3",
        waist = "Reiki Yotai", legs = "Mochizuki Hakama +3", feet = "Hizamaru Sune-ate +2" }
    sets.engaged.MaxDW = set_combine(sets.engaged, sets.MaxDW)
    sets.engaged.MaxDW.Acc = set_combine(sets.engaged.Acc, sets.MaxDW)
    sets.engaged.MaxDW.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.MaxDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.MaxDW.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.MaxDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)


    -- need 21 DW
    sets.MidDW = { ear1 = "Suppanomimi", waist = "Reiki Yotai", legs = "Mochizuki Hakama +3" }
    sets.engaged.MidDW = set_combine(sets.engaged, sets.MidDW)
    sets.engaged.MidDW.Acc = set_combine(sets.engaged.Acc, sets.MidDW)
    sets.engaged.MidDW.Evasion = set_combine(sets.engaged.Evasion, sets.DTDW)
    sets.engaged.MidDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.DTDW)
    sets.engaged.MidDW.PDT = set_combine(sets.engaged.PDT, sets.DTDW)
    sets.engaged.MidDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.DTDW)


    -- need 1 DW
    sets.MinDW = { ear1 = "Iga Mimikazari", waist = "Kentarch Belt +1" }
    sets.engaged.MinDW = set_combine(sets.engaged, sets.MinDW)
    sets.engaged.MinDW.Acc = set_combine(sets.engaged.Acc, sets.MinDW)
    sets.engaged.MinDW.Evasion = set_combine(sets.engaged.Evasion, sets.MinDW)
    sets.engaged.MinDW.Acc.Evasion = set_combine(sets.engaged.Acc.Evasion, sets.MinDW)
    sets.engaged.MinDW.PDT = set_combine(sets.engaged.PDT, sets.MinDW)
    sets.engaged.MinDW.Acc.PDT = set_combine(sets.engaged.Acc.PDT, sets.MinDW)

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.doom = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.buff.doom.HolyWater = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Blenmot's Ring +1", ring2 = "Blenmot's Ring +1",
        waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots", }

    sets.resist = {}
    sets.resist.death = { main = "Odium",
        body = "Samnuha Coat", ring1 = "Shadow Ring", ring2 = "Eihwaz Ring"
    }
    sets.buff.Migawari = { body = "Hattori Ningi +1" }
    sets.buff.Yonin = {}
    sets.buff.Innin = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    if S {
        "Katon: San", "Katon: Ni",
        "Hyoton: San", "Hyoton: Ni",
        "Huton: San", "Huton: Ni",
        "Doton: San", "Doton Ni",
        "Raiton: San", "Raiton: Ni",
        "Suiton: San", "Suiton: Ni"
    }:contains(spell.english) then

        local recasts = windower.ffxi.get_spell_recasts()

        if recasts and recasts[spell.id] > 0 then

            -- cancel if spell is counting down and try to cast the next nuke down
            eventArgs.cancel = true

            local nextDown = ""
            if spell.english:endswith("San") then
                nextDown = " Ni"
            elseif spell.english:endswith("Ni") then
                nextDown = " Ichi"
            end

            -- get first element of iterator, which will be the spell name
            local spellBase = ""
            for v in spell.english:gmatch("[^%s]+") do
                spellBase = v
                break
            end
            send_command("input /nin \"" .. spellBase .. nextDown .. "\"" .. spell.target.raw)
        end
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    -- equip ninjutsu with QC if we're not trying to overwrite utsusemi
    if spell.skill == 'Ninjutsu' then
        if spell.name:startswith("Utsusemi") then
            if buffactive["Copy Image"]
                or buffactive["Copy Image (2)"]
                or buffactive["Copy Image (3)"]
                or buffactive["Copy Image (4+)"] then
                equip(sets.precast.FC)
            else
                equip(sets.precast.FC.Ninjutsu)
            end
        else
            equip(sets.precast.FC.Ninjutsu)
        end
    end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- if buffactive['Sange'] and shuriken_check() then
    --     equip({ sets.SangeShuriken })
    -- end
    if state.Buff.Doom then
        equip(sets.buff.Doom)
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
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

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
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs equip sets.defense.PDT')
        end
    else
        if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
            calculate_haste()
            send_command('gs c update')
        elseif buff == 'terror' or buff == 'stun' then
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
    calculate_haste()

    th_update(cmdParams, eventArgs)

    if buffactive.terror or buffactive.stun then
        send_command('gs equip sets.defense.PDT')
    elseif buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            send_command('gs equip sets.buff.doom')
        elseif state.DoomMode.value == 'Holy Water' then
            send_command('gs equip sets.buff.doom.HolyWater')
        end
    end
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

    if state.Buff['Haste Samba'] then
        haste = haste + 5
    end

    if state.Buff['Mighty Guard'] then
        haste = haste + 15
    end

    classes.CustomMeleeGroups:clear()
    if haste <= 29 then
        -- equip up to 39 DW
        classes.CustomMeleeGroups:append('MaxDW')
    elseif haste > 29 and haste < 43.75 then
        -- equip up to 21 DW
        classes.CustomMeleeGroups:append('MidDW')
    elseif haste >= 43.75 then
        -- equip 1 DW
        classes.CustomMeleeGroups:append('MinDW')
    end
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
