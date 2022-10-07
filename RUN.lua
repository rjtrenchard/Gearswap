-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.
function job_setup()
    -- Table of entries
    rune_timers = T {}
    -- entry = rune, index, expires

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S { 35, 204 }
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S { 201, 202, 203, 205, 207 }

    include('Mote-TreasureHunter')

    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'DD', 'Fence', 'Acc', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Regen', 'Refresh')

    aoe_spells = S { 'Sheep Song', 'Geist Wall', 'Soporific', 'Stinking Gas', 'Foil' }
    st_enmity_spells = S { 'Flash', 'Jettatura', 'Geist Wall' }

    select_default_macro_book()

    gear.default.obi_waist = "Eschan Stone"

    send_command('bind numpad1 input /ma "Flash" <t>')
    send_command('bind numpad2 input /ma "Foil" <me>')
    send_command('bind numpad3 input /ja "Vivacious Pulse" <me>')

    send_command('bind numpad4 input /ma "Phalanx" <me>')
    send_command('bind numpad5 input /ja "Embolden" <me>')


    -- send_command('bind numpad7 input /ma "Aquaveil" <me>')
    -- send_command('bind numpad8 input /ma "Cocoon" <me>')
    -- send_command('bind numpad9 input /ma "Crusade" <me>')

    send_command('bind numpad7 gs equip sets.Weapons.Primary')
    send_command('bind numpad8 gs equip sets.Weapons.DEF')

    send_command('bind ^= gs c cycle treasuremode')

    -- send_command('bind numpad7 gs equip sets.')
end

function user_unload()
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
    send_command('unbind numpad6')
    send_command('unbind numpad7')
    send_command('unbind numpad8')
    send_command('unbind numpad9')
    send_command('unbind !`')
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind ^-')
end

function init_gear_sets()
    -- Phalanx augs
    gear.PhalanxHead = { name = "Taeon Chapeau", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxBody = { name = "Taeon Tabard", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxHands = { name = "Taeon Gloves", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxLegs = { name = "Herculean Trousers",
        augments = { 'Enmity-6', 'Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3', 'Phalanx +4', 'Mag. Acc.+8 "Mag.Atk.Bns."+8', } }
    gear.PhalanxFeet = { name = "Taeon Boots", augments = { '"Repair" potency +5%', 'Phalanx +3', } }

    -- Ambu capes
    gear.SIRDCape = { name = "Ogma's Cape",
        augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Enmity+10', 'Spell interruption rate down-10%', } }
    gear.EnmityCape = gear.SIRDCape
    gear.TankCape = { name = "Ogma's Cape", augments = { 'HP+60', 'Eva.+20 /Mag. Eva.+20', 'Phys. dmg. taken-10%', } }
    gear.DDCape = { name = "Ogma's Cape",
        augments = { 'Accuracy+20 Attack+20', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }
    gear.WSCape = gear.DDCape
    gear.DimCape = gear.WSCape
    gear.FCCape = { name = "Ogma's Cape", augments = { 'HP+60', '"Fast Cast"+10', } }
    gear.LungeCape = gear.EnmityCape


    sets.Weapons = {}
    sets.Weapons.Primary = { main = "Aettir", sub = "Utu Grip" }
    sets.Weapons.DEF = { main = "Aettir", sub = "Refined Grip +1" }

    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt", legs = "Volte Hose", feet = "Volte Boots"
    }

    sets.enmity = { ammo = "Sapience Orb",
        head = "Halitus Helm", neck = "Moonlight Necklace", ear1 = "Trux Earring",
        ear2 = { name = "Etiolation Earring", priority = 9 },
        body = "Emet Harness +1", hands = "Kurys Gloves", ring2 = "Eihwaz Ring",
        ring1 = { name = "Moonlight Ring", priority = 10 },
        back = gear.EnmityCape, waist = "Trance Belt", legs = "Erilaz Leg Guards +2", feet = "Erilaz Greaves +1" }

    sets.SIRD = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Moonlight Necklace", ear1 = "Magnetic Earring", ear2 = "Halasz Earring",
        body = "Nyame Mail", hands = "Rawhide Gloves", ring1 = "Moonlight Ring", ring2 = "Evanescence Ring",
        back = gear.SIRDCape, waist = "Audumbla Sash", legs = "Carmine Cuisses +1", feet = "Nyame Sollerets"
    }
    sets.HP_High = {
        head = "Nyame Helm", neck = "Unmoving Collar +1", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = "Reiki Cloak", legs = "Nyame Flanchard", feet = "Nyame Sollerets"
    }

    sets.buff.doom = set_combine(sets.defense.PDT, {
        neck = "Nicander's Necklace",
        ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash"
    })

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = set_combine(sets.enmity,
        { body = "Runeist's Coat +2", legs = "Futhark Trousers +3", back = gear.EnmityCape })
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = set_combine(sets.enmity, { feet = "Runeist bottes +1" })
    sets.precast.JA['Battuta'] = set_combine(sets.enmity, { head = "Futhark Bandeau +3" })
    sets.precast.JA['Liement'] = set_combine(sets.enmity, { main = "Epeolatry", body = "Futhark Coat +3" })
    sets.precast.JA['Lunge'] = { ammo = "Pemphredo Tathlum",
        head = "Agwu's Cap", neck = "Baetyl Pendant", ear1 = "Friomisi Earring", ear2 = "Hecate's Earring",
        body = "Agwu's Robe", hands = "Agwu's Gages", ring1 = "Mujin Band",
        back = gear.LungeCape, waist = gear.ElementalObi, legs = "Agwu's Slops", feet = "Agwu's Pigaches" }
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = set_combine(sets.enmity, { hands = "Runeist Mitons +2" })
    sets.precast.JA['Rayke'] = set_combine(sets.enmity, { feet = "Futhark Bottes +2" })
    sets.precast.JA['Elemental Sforzo'] = set_combine(sets.enmity, { body = "Futhark Coat +3" })
    sets.precast.JA['Swordplay'] = { hands = "Futhark Mitons +3" }
    sets.precast.JA['Embolden'] = { back = "Evasionist's Cape" }
    sets.precast.JA['Vivacious Pulse'] = {
        head = "Erilaz Galea +1", neck = "Incanter's Torque", ear1 = "Saxnot Earring", ear2 = "Beatific Eerring",
        ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = "Altruistic Cape", waist = "Bishop's Sash", legs = "Runeist's Trousers +2"
    }
    sets.precast.JA['One For All'] = set_combine(sets.enmity, sets.HP_High)
    sets.precast.JA['Provoke'] = sets.enmity

    sets.Lunge = {}
    sets.Lunge.Dark = { head = "Pixie Hairpin +1", ring2 = "Archon Ring" }
    sets.Lunge.Light = { ring2 = "Weatherspoon Ring +1" }

    -- Fast cast sets for spells
    sets.precast.FC = { ammo = "Sapience Orb",
        head = "Runeist's Bandeau +3", neck = "Orunmila's Torque", ear1 = "Loquacious Earring",
        ear2 = "Enchanter's Earring +1",
        body = { name = "Adhemar Jacket +1", priority = 9 }, hands = "Leyline Gloves", ring1 = "Kishar Ring",
        ring2 = "Weatherspoon Ring +1",
        back = gear.FCCape, legs = "Ayanmo Cosciales +2", feet = "Carmine Greaves +1" }

    -- extra +40 FC from inspiration, +8 QC
    sets.precast.FC.inspiration = { ammo = "Impatiens",
        head = "Runeist's Bandeau +3",
        body = { name = "Adhemar Jacket +1", priority = 9 }, ring1 = "Lebeche Ring", ring2 = "Weatherspoon Ring +1",
        back = gear.FCCape
    }

    -- +8 QC, +80 FC
    sets.precast.FC['Enhancing Magic'] = { ammo = "Impatiens",
        head = "Runeist's Bandeau +3", neck = { name = "Unmoving Collar +1", priority = 10 }, ear1 = "Loquacious Earring",
        body = { name = "Adhemar Jacket +1", priority = 9 }, hands = "Leyline Gloves", ring1 = "Lebeche Ring",
        ring2 = "Weatherspoon Ring +1",
        back = gear.FCCape, waist = "Siegel Sash", legs = "Futhark Trousers +3", feet = "Carmine Greaves +1"
    }
    sets.precast['Enhancing Magic'] = sets.precast.FC['Enhancing Magic'] -- I never know which one to use...

    -- Weaponskill sets
    sets.precast.WS = { ammo = "Knobkierrie",
        head = "Nyame Helm", neck = "Fotia Gorget", ear1 = "Sherida Earring", ear2 = "Brutal Earring",
        body = "Nyame Mail", hands = "Adhemar Wristbands +1", ring1 = "Epaminondas's Ring",
        ring2 = "Niqmaddu Ring",
        back = gear.WSCape, waist = "Fotia Belt", legs = "Nyame Flanchard", feet = "Nyame Sollerets" }

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, { ammo = "Seething Bomblet +1",
        ear2 = "Moonshade Earring",
        hands = "Adhemar Wristbands +1", ring1 = "Regal Ring", ring2 = "Niqmaddu Ring" })
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {})
    sets.precast.WS['Resolution'].MaxTP = { ear2 = "Brutal Earring" }

    sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, { ammo = "Knobkierrie",
        neck = "Caro Necklace", ear1 = "Sherida Earring", ear2 = "Moonshade Earring",
        hands = "Meghanada Gloves +2", ring1 = "Epaminondas's Ring", ring2 = "Niqmaddu Ring",
        back = gear.DimCape, waist = "Kentarch Belt +1", legs = "Samnuha Tights", feet = "Nyame Sollerets"
    })
    sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'], {})
    sets.precast.WS['Dimidiation'].MaxTP = { ear2 = "Ishvara Earring" }

    sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {})
    sets.precast.WS['Herculean Slash'].Acc = set_combine(sets.precast.WS['Herculean Slash'], {})

    sets.precast.WS['Shockwave'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum medal", ear2 = "Moonshade Earring",
        waist = "Sailfi Belt +1",
    })
    sets.precast.WS['Savage Blade'].MaxTP = { ear2 = "Telos Earring" }
    sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        neck = "Orunmila's Torque",
        ring1 = "Kishar Ring", ring2 = "Weatherspoon Ring +1",
        waist = "Sailfi Belt +1"
    }

    sets.midcast.Trust = sets.SIRD

    sets.midcast['Enhancing Magic'] = {
        head = "Runeist's Bandeau +3", neck = "Incanter's Torque", ear1 = "Andoaa Earring", ear2 = "Mimir Earring",
        body = "Manasa Chasuble", hands = "Runeist mitons +2", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = "Merciful Cape", waist = "Olympus Sash", legs = "Carmine Cuisses +1"
    }

    sets.midcast['Enhancing Magic'].Duration = { head = "Erilaz Galea +1", ear2 = "Erilaz Earring +1",
        legs = "Futhark Trousers +3" }

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, sets.SIRD)

    sets.midcast['Enfeebling Magic'] = {
        neck = "Incanter's Torque", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        waist = "Luminary Sash"
    }

    --
    sets.midcast.FoilVeil = set_combine(sets.enmity, { head = "Erilaz Galea +1", legs = "Futhark Trousers +3" })


    sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
        head = "Futhark Bandeau +3",
        body = gear.PhalanxBody, hands = gear.PhalanxHands,
        legs = gear.PhalanxLegs, feet = gear.PhalanxFeet
    })

    sets.midcast['Regen'] = { head = "Runeist's Bandeau +3", legs = "Futhark Trousers +3" }
    sets.midcast['Refresh'] = { head = "Erilaz Galea +1" }

    sets.midcast['Stoneskin'] = {
        ear1 = "Earthcry Earring",
        hands = "Stone Mufflers",
        waist = "Siegel Sash"
    }

    sets.midcast.Cure = {
        neck = "Incanter's Torque",
        ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        waist = "Luminary Sash", feet = "Futhark Boots +2"
    }

    sets.midcast['Divine Magic'] = {
        neck = "Incanter's Torque", ear1 = "Saxnot Earring", ear2 = "Beatific Earring",
        ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        legs = "Runeist's Trousers +2"
    }

    sets.midcast['Blue Magic'] = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Moonlight Necklace", ear1 = "Magnetic Earring", ear2 = "Halasz Earring",
        body = "Nyame Mail", hands = "Rawhide Gloves", ring1 = "Defending Ring", ring2 = "Gelatinous Ring +1",
        back = gear.SIRDCape, waist = "Audumbla Sash", legs = "Carmine Cuisses +1", feet = "Erilaz Greaves +1"
    }


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.idle = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.TankCape, waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Nyame Sollerets" }
    sets.idle.Refresh = set_combine(sets.idle, { body = "Runeist's Coat +2", waist = "Fucho-no-obi" })

    sets.idle.Town = {
        head = "Shaded Spectacles", neck = "Smithy's Torque",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.TankCape, waist = "Blacksmith's Belt", legs = "Carmine Cuisses +1",
    }

    -- try to preserve some MP while weak
    sets.idle.Weak = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.TankCape, waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Nyame Sollerets" }


    sets.defense.PDT = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.TankCape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Nyame Sollerets" }

    sets.defense.MDT = set_combine(sets.defense.PDT, { ammo = "Yamarang",
        neck = "Futhark Torque +2",
        waist = "Engraved Belt" })

    sets.Kiting = { legs = "Carmine Cuisses +1" }


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    sets.engaged = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Tuisto Earring", ear2 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Turms Mittens +1", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.TankCape, waist = "Flume Belt +1", legs = "Erilaz Leg Guards +2", feet = "Turms Leggings +1" }
    sets.engaged.DD = { ammo = "Ginsen",
        head = "Adhemar Bonnet +1", neck = "Anu Torque", ear1 = "Sherida Earring", ear2 = "Telos Earring",
        body = "Ayanmo Corazza +2", hands = "Adhemar Wristbands +1", ring1 = "Epona's Ring", ring2 = "Niqmaddu Ring",
        back = gear.DDCape, waist = "Sailfi belt +1", legs = "Samnuha Tights", feet = "Ayanmo Gambieras +2" }

    sets.engaged.Fence = { ammo = "Ginsen",
        head = "Adhemar Bonnet +1", neck = "Anu Torque", ear1 = "Sherida Earring", ear2 = "Telos Earring",
        body = "Ayanmo Corazza +2", hands = "Turms Mittens +1", ring1 = "Epona's Ring", ring2 = "Niqmaddu Ring",
        back = gear.DDCape, waist = "Sailfi belt +1", legs = "Samnuha Tights", feet = "Ayanmo Gambieras +2" }
    sets.engaged.Acc = set_combine(sets.engaged.DD, { ammo = "Yamarang", })
    sets.engaged.PDT = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.TankCape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Nyame Sollerets" }
    sets.engaged.MDT = { ammo = "Yamarang",
        head = "Nyame Helm", neck = "Futhark Torque +2", ear1 = "Etiolation Earring", ear2 = "Odnowa Earring +1",
        body = "Nyame Mail", hands = "Turms Mittens +1", ring1 = "Moonlight Ring", ring2 = "Defending Ring",
        back = gear.TankCape, waist = "Engraved Belt", legs = "Erilaz Leg Guards +2", feet = "Turms Leggings +1" }

    sets.engaged.Weak = { ammo = "Staunch Tathlum +1",
        head = "Nyame Helm", neck = "Futhark Torque +2", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Moonlight Ring", ring2 = "Gelatinous Ring +1",
        back = gear.TankCape, waist = "Flume Belt +1", legs = "Nyame Flanchard", feet = "Nyame Sollerets" }


end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if buffactive['Fast Cast'] and
        -- (spell.skill:startswith('Magic') or S { 'Ninjutsu', 'Singing' }:contains(spell.english)) then
        S { 'WhiteMagic', 'BlackMagic', 'SummonerPact', 'Ninjutsu',
            'BardSong', 'BlueMagic', 'Geomancy', 'Trust' }:contains(spell.type) then
        equip(sets.precast.FC.inspiration)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and player.tp == 3000 then
        if sets.precast.WS[spell.english] then
            if sets.precast.WS[spell.english].MaxTP then
                equip(sets.precast.WS[spell.english].MaxTP)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        local obi = get_obi(get_rune_obi_element())
        if obi then
            equip({ waist = obi })
        end

        if rune_count('Lux') ~= 0 then
            equip(sets.Lunge.Light)
        end
        if rune_count('Tenebrae') ~= 0 then
            equip(sets.Lunge.Dark)
        end

    elseif (aoe_spells:contains(spell.english)) and buffactive['Aquaveil'] then
        if spell.english == 'Foil' then
            equip(sets.midcast.FoilVeil)
        else
            equip(set_combine(sets.enmity, sets.midcast['Enhancing Magic'].Duration))
        end
    elseif aoe_spells:contains(spell.english) then
        equip(sets.SIRD)
    elseif st_enmity_spells:contains(spell.english) then
        equip(sets.enmity)
    elseif spell.english:startswith('Regen') or spell.english:startswith('Protect') or spell.english:startswith('Shell')
        or spell.english == 'Refresh' then
        equip(sets.midcast['Enhancing Magic'].Duration)
    end
end

function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if buffactive.doom then
        equip(sets.buff.doom)
    end
end

function job_buff_change(buff, gain)
    if gain then
        if buff == 'charm' then
            send_command('input /p Charmed')
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            send_command('gs equip sets.buff.doom')
        end
    else
        if buff == 'charm' then
            send_command('input /p Charm off')
        elseif buff == 'doom' then
            send_command('input /p Doom off')
            send_command('gs c update')
        end
    end

end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    local function l_set_macro_page(page, book)
        windower.send_command('input /macro book ' .. book .. '; wait 0.1; input /macro set ' .. page)
        -- coroutine.sleep(.5)
        -- windower.send_command('input /macro set ' .. page)
    end

    -- Default macro set/book
    if player.sub_job == 'WAR' then
        l_set_macro_page(7, 14)
    elseif player.sub_job == 'NIN' then
        l_set_macro_page(8, 14)
    elseif player.sub_job == 'DRK' then
        l_set_macro_page(6, 14)
    elseif player.sub_job == 'BLU' then
        l_set_macro_page(1, 14)
    else
        l_set_macro_page(9, 14)
    end

    send_command("@wait 5;input /lockstyleset 5")
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']

    local found_rune_element

    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end

    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return 'Hachirin-no-Obi'
    end
end

------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = { rune = spell.name, index = entry_index, expires = expires_time }

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry) .. ';wait 0.05;'

    cmd_queue = cmd_queue .. trim()

    --add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index, entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _, entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- function job_update(cmdParams, eventArgs)
--     for i, v in ipairs(buffactive) do
--         print(i, v)
--     end
-- end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index, entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end

        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end

    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''

    for index, entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index, entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end

    return cmd_queue
end

------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change', reset_timers)
windower.raw_register_event('logout', reset_timers)
windower.raw_register_event('status change', function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)
