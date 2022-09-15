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
    state.Buff.Saboteur = buffactive.saboteur or false
    state.Buff['Elemental Seal'] = buffactive['elemental seal'] or false

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S { 35, 204 }
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S { 201, 202, 203, 205, 207 }

    include('Mote-TreasureHunter')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

    state.OffenseMode:options('Normal', 'Acc', 'Enspell', 'EnspellMax', 'Magic')
    state.HybridMode:options('Normal', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.RangedMode:options('None', 'Normal')
    state.IdleMode:options('Normal', 'PDT', 'MDT')


    state.MBurst = M { ['description'] = 'Magic Burst', 'None', 'Magic Burst' }
    state.TPMode = M { ['description'] = 'TP Mode', 'Expend', 'Preserve', 'Preserve > 1000' }
    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }
    -- state.DWMode = M { ['description'] = 'Dual Wield Mode', '30%', 'Capped' }
    state.UseCustomTimers = M(false, 'Use Custom Timers')

    info.JobPoints = {}
    info.JobPoints.EnhancingDuration = 20
    info.JobPoints.EnhancingMerits = 5

    gear.default.obi_waist = "Sacro Cord"
    gear.default.drain_waist = "Fucho-no-Obi"
    gear.default.cure_waist = "Luminary Sash"

    enhancing_skill_magic = S { 'Temper', 'Temper II', 'Aquaveil' }

    custom_timers = {}

    sets._Recast = {}
    info._RecastFlag = false

    select_default_macro_book()

    info.can_DW = S { 'NIN', 'DNC' }:contains(player.sub_job)
    if info.can_DW then
        state.IdleMode:set('PDT')
        send_command('bind numpad5 gs equip sets.Weapons.AeolianEdge.DW')
        send_command('bind numpad6 gs equip sets.Weapons.Maxentius.DW')
        send_command('bind numpad7 gs equip sets.Weapons.CroceaMors.DW')
        send_command('bind numpad8 gs equip sets.Weapons.Enspell.DW')
        send_command('bind numpad9 gs equip sets.Weapons.Naegling.DW')

    else
        send_command('bind numpad5 gs equip sets.Weapons.AeolianEdge')
        send_command('bind numpad6 gs equip sets.Weapons.Maxentius')
        send_command('bind numpad7 gs equip sets.Weapons.CroceaMors')
        send_command('bind numpad8 gs equip sets.Weapons.Enspell')
        send_command('bind numpad9 gs equip sets.Weapons.Naegling')
    end

    send_command('bind ^- gs c cycle TPMode')
    send_command('bind !` gs c cycle MBurst')
    send_command('bind != gs c set OffenseMode Magic')
    send_command('bind ^= gs c cycle treasuremode')

    send_command('bind numpad1 input /ma Silence <t>')
    send_command('bind numpad2 input /ma "Cure IV" <t>')
    send_command('bind numpad3 input /ma "Sleep II" <t>')

    -- send_command('bind numpad4 input /ja Accession <me>')

    send_command('bind ^- gs c cycle DoomMode')

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

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Augmented gear
    gear.int_cape = { name = "Sucellos's Cape",
        augments = { 'INT+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'INT+10', '"Mag.Atk.Bns."+10', } }
    gear.mnd_cape = { name = "Sucellos's Cape",
        augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'MND+10', 'Weapon skill damage +10%', } }
    gear.melee_cape = { name = "Sucellos's Cape",
        augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }
    gear.dw_cape = gear.melee_cape
    gear.ws_cape = { name = "Sucellos's Cape",
        augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', } }
    gear.idle_cape = gear.melee_cape

    gear.PhalanxHead = { name = "Taeon Chapeau", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxBody = { name = "Taeon Tabard", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxHands = { name = "Taeon Gloves", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxLegs = { name = "Taeon Tights", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
    gear.PhalanxFeet = { name = "Taeon Boots", augments = { '"Repair" potency +5%', 'Phalanx +3', } }

    gear.CureHands = { name = "Telchine Gloves", augments = { 'Mag. Evasion+23', '"Fast Cast"+5', '"Regen" potency+3', } }

    gear.RegenHead = { name = "Telchine Cap", augments = { '"Regen" potency+3', } }
    gear.RegenBody = { name = "Telchine Chasuble", augments = { '"Regen" potency+3', } }
    gear.RegenHands = gear.CureHands
    gear.RegenLegs = { name = "Telchine Braconi", augments = { '"Regen" potency+3', } }
    gear.RegenFeet = { name = "Telchine Pigaches", augments = { '"Fast Cast"+2', '"Regen" potency+3', } }

    gear.EnhancingWeapon = { name = "Colada", augments = { 'Enh. Mag. eff. dur. +4', 'STR+1', 'Mag. Acc.+16', } }

    gear.RefreshFeet = { name = "Chironic Slippers",
        augments = { 'Crit. hit damage +1%', 'Sklchn.dmg.+4%', '"Refresh"+2', 'Mag. Acc.+11 "Mag.Atk.Bns."+11', } }
    gear.RefreshHands = { name = "Chironic Gloves",
        augments = { 'Weapon skill damage +2%', 'Pet: Accuracy+17 Pet: Rng. Acc.+17', '"Refresh"+2',
            'Mag. Acc.+17 "Mag.Atk.Bns."+17', } }

    gear.fc_feet = { name = "Merlinic Crackows", augments = { '"Mag.Atk.Bns."+1', '"Fast Cast"+7', 'MND+3',
        'Mag. Acc.+14', } }

    gear.default_ranged = "Ullr"
    gear.default_ranged_ammo = "Chapuli Arrow"


    -- Misc sets

    -- make HP low, but still armoured.
    sets.LowHP = {
        head = "Taeon Chapeau",
        body = "Taeon Tabard", hands = "Taeon Gloves", ring1 = "Jhakri Ring",
        legs = "Taeon Tights", feet = "Taeon boots"
    }

    sets.enmity = { ammo = "Sapience Orb",
        head = "Halitus Helm", neck = "Unmoving Collar +1", ear1 = "Trux Earring", ear2 = "Cryptic Earring",
        body = "Emet Harness +1", ring1 = "Supershear Ring", ring2 = "Eihwaz Ring",
        waist = "Trance Belt", legs = "Zoar Subligar +1"
    }

    -- Precast Sets
    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt", legs = "Volte Hose", feet = "Volte Boots"
    }

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = { body = "Vitiation Tabard +3" }


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.RA = { hands = "Carmine Finger Gauntlets +1", ring1 = "Crepuscular Ring", ring2 = "Haverton Ring +1",
        waist = "Yemaya Belt" }

    -- Fast cast sets for spells

    -- 90% Fast Cast (including trait) for all spells, 10% Quick Magic, retain 285 HP
    sets.precast.FC = { main = "Crocea Mors",
        head = "Atrophy Chapeau +2", neck = { name = "Unmoving Collar +1", priority = 10 },
        ear1 = { name = "Eabani Earring", priority = 9 }, ear2 = { name = "Etiolation Earring", priority = 8 },
        ring1 = "Lebeche Ring", ring2 = "Weatherspoon Ring +1",
        back = "Perimede Cape", waist = "Embla Sash", feet = gear.fc_feet }

    -- for when we cast spells that can't overwrite themselves, and the buff is active
    sets.precast.FC.NoQC = { main = "Crocea Mors",
        head = "Atrophy Chapeau +2", neck = { name = "Unmoving Collar +1", priority = 10 },
        ear1 = { name = "Eabani Earring", priority = 9 }, ear2 = { name = "Etiolation Earring", priority = 8 },
        ring1 = "Kishar Ring", ring2 = "Rahab Ring",
        back = "Fi Follet Cape +1", waist = "Embla Sash", feet = gear.fc_feet }

    sets.precast['Dispelga'] = set_combine(sets.precast.FC, {
        main = { name = "Daybreak", priority = 10 }, sub = { name = "Ammurapi Shield", priority = 9 },
        hands = "Leyline Gloves",
        feet = "Carmine Greaves +1"
    })
    sets.precast.FC.Dispelga = sets.precast.Dispelga

    sets.precast['Impact'] = set_combine(sets.precast.FC,
        { main = "Crocea Mors", sub = "Ammurapi Shield",
            head = empty,
            body = "Crepuscular Cloak", hands = "Leyline Gloves",
            feet = "Carmine Greaves +1" })
    sets.precast.FC['Impact'] = sets.precast['Impact']

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Voluspa Tathlum",
        head = "Vitiation Chapeau +3", neck = "Fotia Gorget", ear1 = "Ishvara Earring", ear2 = "Moonshade Earring",
        body = "Vitiation Tabard +3", hands = "Atrophy Gloves +3", ring1 = "Apate Ring", ring2 = "Epaminondas's Ring",
        back = gear.ws_cape, waist = "Fotia Belt", legs = "Vitiation Tights +2", feet = "Lethargy Houseaux +2" }

    sets.precast.WS.Crit = { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", neck = "Fotia Gorget", ear1 = "Brutal Earring", ear2 = "Moonshade Earring",
        body = "Vitiation Tabard +3", hands = "Atrophy Gloves +3", ring1 = "Ilabrat Ring", ring2 = "Begrudging Ring",
        back = gear.ws_cape, waist = "Fotia Belt", legs = "Zoar Subligar +1", feet = "Ayanmo Gambieras +2" }

    sets.precast.WS.Acc = { ammo = 'Voluspa Tathlum',
        head = 'Malignance Chapeau', neck = 'Fotia Gorget', ear1 = 'Crepuscular Earring', ear2 = 'Telos Earring',
        body = "Malignance Tabard", hands = 'Malignance Gloves', ring1 = 'Apate Ring', ring2 = "Epaminondas's Ring",
        back = gear.ws_cape, waist = 'Fotia Gorget', legs = 'Malignance Tights', feet = 'Lethargy Houseaux +2' }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, { ammo = "Regal Gem",
        head = "Vitiation Chapeau +3", ear1 = "Sherida Earring", ear2 = "Regal Earring",
        body = "Vitiation Tabard +3", hands = "Jhakri Cuffs +2", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, legs = "Vitiation Tights +2", feet = "Lethargy Houseaux +2" })

    sets.precast.WS['Sanguine Blade'] = { ammo = "Ghastly Tathlum +1",
        head = "Pixie Hairpin +1", neck = "Sibyl Scarf", ear1 = "Regal Earring", ear2 = "Malignance Earring",
        body = "Amalric Doublet +1", hands = "Jhakri cuffs +2", ring1 = "Archon Ring", ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Lethargy Houseaux +2" }

    sets.precast.WS['Aeolian Edge'] = { ammo = "Oshasha's Treatise",
        head = "Cath Palug Crown", neck = "Sibyl Scarf", ear1 = "Regal Earring", ear2 = "Malignance Earring",
        body = "Amalric Doublet +1", hands = "Jhakri cuffs +2", ring1 = "Epaminondas's Ring", ring2 = "Freke Ring",
        back = gear.mnd_cape, waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Lethargy Houseaux +2"
    }

    sets.precast.WS['Seraph Blade'] = { ammo = "Oshasha's Treatise",
        head = "Cath Palug Crown", neck = "Baetyl Pendant", ear1 = "Regal Earring", ear2 = "Moonshade Earring",
        body = "Amalric Doublet +1", hands = "Jhakri Cuffs +2", ring1 = "Freke Ring", ring2 = "Weatherspoon Ring +1",
        back = gear.mnd_cape, waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Lethargy Houseaux +2"
    }
    sets.precast.WS['Seraph Blade'].MaxTP = { ear2 = "Malignance Earring" }

    sets.precast.WS['Red Lotus Blade'] = { ammo = "Ghastly Tathlum +1",
        head = "Cath Palug Crown", neck = "Sibyl Scarf", ear1 = "Regal Earring", ear2 = "Malignance Earring",
        body = "Amalric Doublet +1", hands = "Jhakri Cuffs +2", ring1 = "Freke Ring", ring2 = "Epaminondas's Ring",
        back = gear.ws_cape, waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Lethargy Houseaux +2"
    }

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS.Crit, { ammo = "Yetshila +1",
        head = "Blistering Sallet +1",
        body = "Jhakri Robe +2", hands = "Atrophy Gloves +3",
        legs = "Zoar Subligar +1", feet = "Ayanmo Gambieras +2" })
    sets.precast.WS['Chant du Cygne'].MaxTP = { ear2 = "Brutal Earring" }

    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit, { ring2 = "Begrudging Ring" })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
        { ammo = "Oshasha's Treatise", neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.Acc,
        { ammo = "Voluspa Tathlum",
            head = "Malignance Chapeau", neck = "Republican Platinum medal",
            body = "Malignance Tabard", hands = "Malignance Gloves",
            waist = "Sailfi Belt +1", legs = "Malignance Tights", feet = "Lethargy Houseaux +2" })
    sets.precast.WS['Savage Blade'].MaxTP = { ear2 = "Sherida Earring" }

    sets.precast.WS['Death Blossom'] = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.Crit, { ring1 = "Hetairoi Ring" })

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, { ammo = "Oshasha's Treatise",
        head = "Vitiation Chapeau +3", neck = "Duelist's Torque +2", ear1 = "Regal Earring",
        ear2 = "Moonshade Earring",
        body = "Vitiation Tabard +3", hands = "Atrophy Gloves +3", ring1 = "Epaminondas's Ring",
        ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, waist = "Sailfi Belt +1", legs = "Vitiation Tights +2", feet = "Lethargy Houseaux +2"
    })
    sets.precast.WS['Black Halo'].MaxTP = { ear2 = "Ishvara Earring" }

    sets.precast.WS['Empyreal Arrow'] = set_combine(sets.precast.WS.Acc, { range = nil, ammo = gear.ranged_ws_ammo })


    -- Midcast Sets
    sets.SIRD = { ammo = "Staunch Tathlum +1",
        body = "Rosette jaseran +1", ring2 = "Freke Ring",
        waist = "Emphatikos Rope", legs = "Carmine Cuisses +1", feet = "Amalric Nails +1" }

    sets.midcast.RA = {
        head = "Malignance Chapeau", neck = "Marked gorget", ear1 = "Crepuscular Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Crepuscular Ring", ring2 = "Cacoethic Ring +1",
        waist = "Yemaya Belt", legs = "Malignance Tights", feet = "Malignance Boots"
    }

    sets.midcast.FastRecast = { ammo = "Sapience Orb",
        head = "Atrophy Chapeau +2", neck = "Orunmila's Torque", ear1 = "Loquacious Earring", ear2 = "Malignance Earring",
        body = "Vitiation Tabard +3", hands = "Vitiation Gloves +3", ring1 = "Kishar Ring", ring2 = "Rahab Ring",
        waist = "Embla Sash", legs = "Atrophy Tights +3", feet = "Vitiation boots +3" }

    sets.midcast.Utsusemi = set_combine(sets.precast.FC, sets.SIRD)

    -- aims for 500 skill (476 base, 24 needed)
    sets.midcast['Enhancing Magic'] = {
        neck = "Duelist's Torque +2",
        body = "Vitiation Tabard +3", hands = "Atrophy Gloves +3",
        back = "Ghostfyre Cape", waist = "Embla Sash", feet = "Lethargy Houseaux +2"
    }

    -- uncapped skills
    sets.midcast['Enhancing Magic'].PureSkill = {
        head = "Befouled Crown", neck = "Incanter's Torque", ear1 = "Andoaa Earring", ear2 = "Mimir Earring",
        body = "Vitiation Tabard +3", hands = "Vitiation Gloves +3", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = "Ghostfyre Cape", waist = "Olympus Sash", legs = "Atrophy Tights +3", feet = "Lethargy Houseaux +2"
    }
    sets.midcast['Enhancing Magic'].Weapon = { main = "Pukulatmuj +1", sub = "Forfend +1" }
    sets.midcast['Enhancing Magic'].DW = sets.midcast['Enhancing Magic'].Weapon
    sets.midcast['Enhancing Magic'].None = {}

    -- Enhancing magic skill duration, no regard for skill
    sets.midcast['Enhancing Magic'].Duration = {
        neck = "Duelist's Torque +2",
        body = "Vitiation tabard +3", hands = "Atrophy Gloves +3",
        back = "Sucellos's Cape", waist = 'Embla Sash', feet = "Lethargy Houseaux +2"
    }
    sets.midcast['Enhancing Magic'].Duration.Weapon = { main = gear.EnhancingWeapon,
        sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Enhancing Magic'].Duration.DW = sets.midcast['Enhancing Magic'].Duration.Weapon
    sets.midcast['Enhancing Magic'].Duration.None = {}

    -- Phalanx for self
    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
        head = gear.PhalanxHead, neck = "Duelist's Torque +2", ear1 = "Andoaa Earring",
        body = gear.PhalanxBody, hands = gear.PhalanxHands, ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = "Ghostfyre Cape", wait = "Embla Sash", legs = gear.PhalanxLegs, feet = gear.PhalanxFeet
    })
    sets.midcast.Phalanx.Weapon = { main = "Sakpata's Sword", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast.Phalanx.DW = { main = "Sakpata's Sword", sub = "Egeking" }
    sets.midcast.Phalanx.None = {}

    sets.midcast.Regen = { main = "Bolelabunga", head = gear.RegenHead, body = gear.RegenBody, hands = gear.RegenHands,
        legs = gear.RegenLegs, feet = gear.RegenFeet }

    sets.midcast.Refresh = { head = "Amalric Coif +1", body = "Atrophy Tabard +3", legs = "Lethargy Fuseau +1" }
    sets.midcast.Gishdubar = { waist = "Gishdubar Sash" }

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, { ammo = "Staunch Tathlum +1",
        head = "Amalric Coif +1",
        body = "Rosette Jaseran +1", hands = "Amalric Gages +1", ring1 = "Evanescence Ring", ring2 = "Freke Ring",
        back = gear.int_cape, waist = "Emphatikos Rope", legs = "Shedir Seraweels", feet = "Amalric Nails +1" })

    -- Stoneskin +125 (425 HP absorbed)
    sets.midcast.Stoneskin = {
        neck = "Nodens Gorget", ear1 = "Earthcry Earring",
        hands = "Stone Mufflers",
        waist = "Siegel Sash", legs = "Shedir Seraweels"
    }

    sets.midcast.BarElement = { legs = "Shedir Seraweels" }
    sets.midcast.BarStatus = sets.midcast.BarElement

    sets.midcast.GainStat = { hands = "Viti. gloves +3" }

    sets.midcast.ProShell = {}
    sets.midcast.ProShell.Self = set_combine(sets.midcast.ProShell, { ear1 = "Brachyura Earring" })

    sets.midcast['Divine Magic'] = { neck = "Incanter's Torque", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1" }
    sets.midcast['Divine Magic'].Weapon = { main = "Daybreak", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Divine Magic'].DW = { main = "Crocea Mors", sub = "Daybreak" }
    sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'],
        { head = "Ipoca Beret", neck = "Jokushu Chain", ring1 = "Weatherspoon Ring +1", ring2 = "Fenian Ring",
            back = "Disperser's Cape" })

    sets.midcast['Healing Magic'] = {
        head = "Kaykaus Mitra +1", neck = "Incanter's Torque", ear1 = "Beatific Earring", ear2 = "Meili Earring",
        body = "Vitiation Tabard +3", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        waist = "Bishop's Sash", legs = "Carmine Cuisses +1", feet = "Vanya Clogs"
    }

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], { main = "Daybreak", ammo = "Regal Gem",
        head = "Kaykaus Mitra +1", neck = "Duelist's Torque +2", ear1 = "Magnetic Earring", ear2 = "Regal Earring",
        body = "Kaykaus Bliaut +1", hands = "Kaykaus Cuffs +1", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, waist = gear.CureWaist, legs = "Kaykaus Tights +1", feet = "Kaykaus Boots +1" })

    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, sets.midcast.Gishdubar)

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], { main = "Prelatic Pole", sub = "Curatio Grip",
        neck = "Debilis Medallion",
        hands = "Hieros Mittens", ring1 = "Haoma's Ring", ring2 = "Haoma's Ring",
        feet = "Gendewitha Galoshes +1"
    })
    sets.midcast.CursnaSelf = set_combine(sets.midcast.Cursna, { waist = "Gishdubar Sash" })


    sets.midcast['Enfeebling Magic'] = { ammo = "Regal Gem",
        head = "Vitiation Chapeau +3", neck = "Duelist's Torque +2", ear1 = "Snotra Earring", ear2 = "Regal Earring",
        body = "Lethargy Sayon +2", hands = "Atrophy Gloves +3", ring1 = "Kishar Ring", ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, waist = "Acuity Belt +1", legs = "Chironic Hose", feet = "Vitiation boots +3" }
    sets.midcast['Enfeebling Magic'].Weapon = { main = "Crocea Mors", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Enfeebling Magic'].DW = { main = "Crocea Mors", sub = "Daybreak" }

    sets.midcast['Enfeebling Magic'].Acc = { main = "Crocea Mors", sub = "Ammurapi Shield", range = "Ullr",
        ammo = { name = "Regal Gem", priority = 10 },
        head = empty, neck = "Duelist's Torque +2", ear1 = "Snotra Earring", ear2 = "Malignance Earring",
        body = "Cohort Cloak +1", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, waist = "Acuity Belt +1", legs = "Chironic Hose", feet = "Vitiation boots +3" }

    -- purely skill/mnd based spells
    sets.midcast['Enfeebling Magic'].PureSkill = { ammo = "Regal Gem",
        head = "Vitiation Chapeau +3", neck = "Duelist's Torque +2", ear1 = "Snotra Earring", ear2 = "Vor Earring",
        body = "Lethargy Sayon +2", hands = "Lethargy Gantherots +1", ring1 = "Stikini Ring +1",
        ring2 = "Stikini Ring +1",
        back = gear.mnd_cape, waist = "Casso Sash", legs = "Chironic Hose", feet = "Vitiation Boots +3" }

    -- dMND spells (Paralyze, Slow, Addle)
    sets.midcast['Enfeebling Magic'].dMND = { main = "Daybreak", sub = { name = "Ammurapi Shield", priority = 10 },
        ammo = "Regal Gem",
        head = "Vitiation Chapeau +3", neck = "Duelist's Torque +2", ear1 = "Snotra Earring", ear2 = "Regal Earring",
        body = "Lethargy Sayon +2", hands = "Vitiation Gloves +3", ring1 = "Stikini Ring +1",
        ring2 = "Metamorph Ring +1",
        back = gear.mnd_cape, waist = "Luminary Sash", legs = "Chironic Hose", feet = "Vitiation Boots +3" }

    sets.midcast['Enfeebling Magic'].Duration = set_combine(sets.midcast['Enfeebling Magic'], {
        head = "Lethargy Chappel +1",
        body = "Lethargy Sayon +2", hands = "Lethargy Gantherots +1",
        legs = "Lethargy Fuseau +1", feet = "Lethargy Houseaux +2"
    })

    sets.midcast['Dispel'] = set_combine(sets.midcast['Enfeebling Magic'].Acc,
        { neck = "Duelist's Torque +2", back = gear.int_cape })
    sets.midcast['Dispelga'] = set_combine(sets.midcast.Dispel, { main = "Daybreak" })

    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'],
        { ammo = "Regal Gem", back = gear.mnd_cape })
    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'],
        { ammo = "Regal Gem", back = gear.mnd_cape })

    sets.midcast['Poison'] = set_combine(sets.midcast['Enfeebling Magic'], { head = "Volte Cap", waist = "Chaac Belt" })
    sets.midcast['Diaga'] = sets.midcast['Poison']
    sets.midcast['Poison II'] = set_combine(sets.midcast['Enfeebling Magic'].PureSkill, { back = gear.int_cape }) -- poison potency is affected by magic skill
    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {})


    sets.midcast['Frazzle II'] = set_combine(sets.midcast['Enfeebling Magic'].Acc,
        { --main="Contemplator +1", sub="Enki Strap",
            range = "Ullr", ammo = empty,
            head = empty, body = "Cohort Cloak +1", back = gear.mnd_cape })

    sets.midcast['Elemental Magic'] = { ammo = "Ghastly Tathlum +1",
        head = "Cath Palug Crown", neck = "Sibyl Scarf", ear1 = "Regal Earring", ear2 = "Malignance Earring",
        body = "Amalric Doublet +1", hands = "Amalric Gages +1", ring1 = "Freke Ring", ring2 = "Metamorph Ring +1",
        back = gear.int_cape, waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Amalric Nails +1" }
    -- sets.midcast['Elemental Magic'] = { main = empty, sub = empty, ammo = empty, head = empty, neck = empty, ear1 = empty,
    --     ear2 = empty,
    --     body = empty, hands = empty, ring1 = empty, ring2 = empty,
    --     back = empty, waist = empty, legs = empty, feet = empty }
    sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], { range = "Ullr", ammo = empty,
        head = empty, neck = "Incanter's Torque", ear1 = "Crepuscular Earring", ear2 = "Malignance Earring",
        body = "Cohort Cloak +1", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        waist = "Acuity Belt +1", legs = "Vitiation Tights +3", feet = "Vitiation Boots +3" })
    sets.midcast['Elemental Magic'].Weapon = { main = "Daybreak", sub = { name = "Ammurapi Shield", priority = 10 } }

    sets.midcast['Elemental Magic'].DW = { main = "Daybreak", sub = { name = "Ammurapi Shield", priority = 10 } }
    -- sets.midcast['Elemental Magic'].DW = {}

    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'].Acc,
        { main = "Crocea Mors", sub = { name = "Ammurapi Shield", priority = 10 },
            head = empty,
            body = "Crepuscular Cloak", ring1 = "Archon Ring" }
    )

    sets.midcast.MagicBurst = { neck = "Mizukage-no-kubikazari", ring1 = "Jhakri Ring", ring2 = "Mujin Band",
        feet = "Jhakri Pigaches +2" }

    sets.midcast['Dark Magic'] = { ammo = "Regal Gem",
        head = "Malignance Chapeau", neck = "Erra Pendant", ear1 = "Mani Earring", ear2 = "Dark Earring",
        body = "Carmine Scale Mail +1", hands = "Malignance Gloves", ring1 = "Archon Ring", ring2 = "Evanescence Ring",
        back = gear.int_cape, waist = "Casso Sash", legs = "Malignance Tights", feet = "Malignance Boots"
    }
    sets.midcast['Dark Magic'].Weapon = { main = "Rubicundity", sub = { name = "Ammurapi Shield", priority = 10 } }
    sets.midcast['Dark Magic'].DW = sets.midcast['Dark Magic'].Weapon

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], { main = "Rubicundity", sub = "Ammurapi Shield",
        head = "Pixie Hairpin +1", neck = "Erra Pendant", ear1 = "Mani Earring",
        ring1 = "Archon Ring", ring2 = "Evanescence Ring",
        back = gear.int_cape, waist = gear.DrainWaist })
    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.buff.ComposureOther = {
        head = "Lethargy Chappel +1",
        body = "Lethargy Sayon +2", hands = "Atrophy Gloves +3",
        legs = "Lethargy Fuseau +1", feet = "Lethargy Houseaux +2"
    }

    sets.buff.Composure = {
        head = "Lethargy Chappel +1",
        body = "Lethargy Sayon +2", hands = "Lethargy Gantherots +1",
        legs = "Lethargy Fuseau +1", feet = "Lethargy Houseaux +2"
    }

    sets.buff.Saboteur = { hands = "Lethargy Gantherots +1" }

    sets.buff.doom = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring",
        back = gear.DDCape, waist = "Gishdubar Sash", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.buff.doom.HolyWater = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Blenmot's Ring +1", ring2 = "Blenmot's Ring +1",
        back = gear.DDCape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { ammo = "Homiliary",
        head = "Vitiation Chapeau +3", neck = "Bathy Choker +1",
        body = "Jhakri Robe +2", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        waist = "Fucho-no-obi", }


    -- Idle sets
    sets.idle = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Eabani Earring", ear2 = "Etiolation Earring",
        body = "Lethargy Sayon +2", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = gear.idle_cape, waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Malignance Boots" }

    sets.idle.Town = { ammo = "Homiliary",
        head = "Shaded Spectacles", neck = "Smithy's Torque", ear1 = "Eabani Earring", ear2 = "Etiolation Earring",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.idle_cape, waist = "Blacksmith's Belt", legs = "Carmine Cuisses +1", feet = "Malignance Boots" }

    sets.idle.Weak = { ammo = "Homiliary",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Eabani Earring", ear2 = "Etiolation Earring",
        body = "Lethargy Sayon +2", hands = "Malignance Gloves", ring1 = "Stikini ring +1", ring2 = "Defending Ring",
        back = gear.idle_cape, waist = "Fucho-no-obi", legs = "Carmine Cuisses +1", feet = "Malignance Boots" }

    sets.idle.PDT = { ammo = "Homiliary",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Eabani Earring", ear2 = "Etiolation Earring",
        body = "Lethargy Sayon +2", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = gear.idle_cape, waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Malignance Boots" }

    sets.idle.MDT = sets.idle.PDT

    sets.base = {}
    sets.base.idle = sets.idle
    sets.base.idle.Town = sets.idle.Town
    sets.base.idle.Weak = sets.idle.Weak
    sets.base.idle.PDT = sets.idle.PDT
    sets.base.idle.MDT = sets.idle.PDT


    -- Defense sets
    sets.defense.PDT = { ammo = "Ginsen",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Eabani Earring", ear2 = "Etiolation Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Ilabrat Ring", ring2 = "Defending Ring",
        back = gear.idle_cape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.defense.MDT = set_combine(sets.defense.PDT, { ring2 = "Archon Ring" })

    sets.Kiting = { legs = "Carmine Cuisses +1" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.Weapons = {}
    sets.Weapons.Naegling = { main = "Naegling", sub = "Forfend +1" }
    sets.Weapons.Naegling.DW = { main = "Naegling", sub = "Thibron" }
    sets.Weapons.Enspell = { main = "Aern Dagger", sub = "Forfend +1" }
    sets.Weapons.Enspell.DW = { main = "Aern Dagger", sub = "Aern Dagger II" }
    sets.Weapons.CroceaMors = { main = "Crocea Mors", sub = "Forfend +1" }
    sets.Weapons.CroceaMors.DW = { main = "Crocea Mors", sub = "Daybreak" }
    sets.Weapons.Maxentius = { main = "Maxentius", sub = "Forfend +1" }
    sets.Weapons.Maxentius.DW = { main = "Maxentius", sub = "Thibron" }
    sets.Weapons.AeolianEdge = { main = "Tauret", sub = "Ammurapi Shield" }
    sets.Weapons.AeolianEdge.DW = { main = "Tauret", sub = "Maxentius" }

    sets.engaged = { ammo = "Ginsen",
        head = "Malignance Chapeau", neck = "Anu Torque", ear1 = "Sherida Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Ayanmo Manopolas +2", ring2 = "Hetairoi Ring", ring1 = "Petrov Ring",
        back = gear.melee_cape, waist = "Sailfi belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.engaged.Acc = { ammo = "Ginsen",
        head = "Malignance Chapeau", neck = "Sanctity Necklace", ear1 = "Telos Earring", ear2 = "Crepuscular Earring",
        body = "Malignance Tabard", hands = "Ayanmo Manopolas +2", ring2 = "Jhakri Ring", ring1 = "Varar Ring +1",
        back = gear.melee_cape, waist = "Sailfi Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.engaged.Enspell = set_combine(sets.engaged, { hands = "Ayanmo Manopolas +2" })

    sets.engaged.EnspellMax = set_combine(sets.engaged.Acc, { ammo = "Regal Gem",
        neck = "Duelist's Torque +2", ear1 = "Crepuscular Earring", ear2 = "Dignitary's Earring",
        hands = "Ayanmo Manopolas +2", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = gear.melee_cape, waist = "Hachirin-no-Obi" })

    sets.engaged.Defense = { ammo = "Ginsen",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Sherida Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring2 = "Defending Ring", ring1 = "Ilabrat Ring",
        back = gear.melee_cape, waist = "Sailfi belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }
    sets.engaged.PDT = sets.engaged.Defense
    sets.engaged.MDT = set_combine(sets.engaged.PDT, { ring2 = "Archon Ring" })


    sets.engaged.DW = set_combine(sets.engaged,
        { waist = "Reiki Yotai" })
    sets.engaged.DW.MaxDW = set_combine(sets.engaged.DW,
        { ear1 = "Eabani Earring", ear2 = "Suppanomimi",
            back = gear.dw_cape, waist = "Reiki Yotai", legs = "Carmine cuisses +1" })
    sets.engaged.DW.MidDW = set_combine(sets.engaged.DW,
        { ear2 = "Suppanomimi",
            back = gear.dw_cape, waist = "Reiki Yotai", })
    sets.engaged.DW.MinDW = set_combine(sets.engaged.DW, {
        ear2 = "Suppanomimi",
        waist = "Reiki Yotai"
    })

    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc,
        { waist = "Reiki Yotai", legs = "Carmine Cuisses +1" })

    sets.engaged.Defense.DW = set_combine(sets.engaged.Defense, { waist = "Sailfi Belt +1", })
    sets.engaged.DW.Defense = sets.engaged.Defense.DW
    sets.engaged.DW.PDT = sets.engaged.Defense.DW
    sets.engaged.DW.MDT = set_combine(sets.engaged.PDT.DW, { ring2 = "Archon Ring" })

    sets.engaged.DW.Enspell = set_combine(sets.engaged.DW, { hands = "Ayanmo Manopolas +2" })

    sets.engaged.DW.EnspellMax = set_combine(sets.engaged.DW.Acc, { ammo = "Regal Gem",
        neck = "Duelist's Torque +2", ear1 = "Crepuscular Earring", ear2 = "Dignitary's Earring",
        hands = "Ayanmo Manopolas +2", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = gear.melee_cape, waist = "Hachirin-no-Obi" })



    -- define idle sets


    -- Default offense mode based on subjob
    if S { 'BRD', 'COR', 'WHM', 'BLM', 'SCH', 'SMN', 'DRK', 'PLD' }:contains(player.sub_job) then
        state.OffenseMode:set('Magic')
    else
        state.TPMode:set('Preserve > 1000')
    end


    if S { 'Normal', 'Acc', 'Enspell' }:contains(state.OffenseMode.value) then
        sets.idle = sets.base.idle
        sets.idle.Town = sets.base.idle.Town
        sets.idle.PDT = sets.base.idle.PDT
        sets.idle.Weak = sets.base.idle.Weak
    else
        sets.idle = set_combine(sets.idle, sets.idle.Weapon)
        sets.idle.Town = set_combine(sets.idle, sets.idle.Weapon)
        sets.idle.PDT = set_combine(sets.idle, sets.idle.Weapon)
        sets.idle.Weak = set_combine(sets.idle, sets.idle.Weapon)
    end
    sets.idle.MDT = sets.idle.PDT


end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type ~= 'WeaponSkill' then
        setRecast()
    elseif spell.english == 'Dispelga' then
        if player.equipment.sub == 'Daybreak' then
            -- equip(sets.precast['Dispelga'].pretarget) --why does this only work this way? who knows!
            --send_command('input equip sub;wait 0.5;gs equip sets.precast.Dispelga')
            equip(sets.precast.Dispelga.pretarget)
            --cast_delay(1)

            --else
            --send_command('gs equip sets.precast.Dispelga')
        end
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Dispelga' then
        if player.equipment.sub == 'Daybreak' then
            send_command('input /equip sub;wait 0.1;gs equip sets.precast.Dispelga')
            cast_delay(1.5)
        else
            equip(sets.precast.Dispelga)
        end
        -- elseif spell.type == 'WeaponSkill' and state.RangedMode.value == 'Normal' then
        --     disable('range', 'ammo')

        -- if S{'Seraph Blade', 'Savage Blade', 'Chant du Cygne', }:contains(spell.english) then
        --     equip(sets.precast.WS[spell.english].MaxTP)
        -- end
    end
end

function job_post_precast(spell, action, spellMap, eventArts)
    if spell.type == 'WeaponSkill' and player.tp == 3000 then
        if sets.precast.WS[spell.english] then
            if sets.precast.WS[spell.english].MaxTP then
                equip(sets.precast.WS[spell.english].MaxTP)
            end
        end
    elseif S { 'Stoneskin', 'Blink' }:contains(spell.english) then
        if buffactive[spell.english] then
            equip(sets.precast.FC.NoQC)
        end
    elseif spell.english:startswith('Utsusemi') then
        if buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or
            buffactive['Copy Image (4+)'] then
            equip(sets.precast.FC.NoQC)
        end
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and buffactive.composure then equip(sets.buff.Composure) end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    local save_TP = (state.TPMode.value == 'Preserve > 1000' and player.tp > 1000) or (state.TPMode.value == 'Preserve')

    if spell.skill == 'Enfeebling Magic' then
        -- equip composure base if active

        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end

        if not save_TP and
            not
            S { 'Dispelga', 'Impact', 'Dia', 'Dia II', 'Dia III', 'Bio', 'Bio II', 'Bio III', 'Frazzle II' }:contains(spell
                .english) then
            if info.can_DW then
                equip(sets.midcast["Enfeebling Magic"].DW)
            else
                equip(sets.midcast["Enfeebling Magic"].Weapon)
            end
        end

        if S { 'Frazzle III', 'Distract III', 'Poison II' }:contains(spell.english) then
            equip(sets.midcast['Enfeebling Magic'].PureSkill)
        elseif S { 'Paralyze II', 'Slow II', 'Addle II' }:contains(spell.english) then
            equip(sets.midcast['Enfeebling Magic'].dMND)
        end

        if spell.english == 'Dispelga' then
            equip(sets.midcast.Dispelga)
        end

    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast['Enhancing Magic'])
        local weapon_set = nil

        if info.can_DW and not save_TP then
            weapon_set = 'DW'
        elseif not save_TP then
            weapon_set = 'Weapon'
        else
            weapon_set = 'None'
        end

        -- skill independant but special gear
        if spell.english:startswith('Refresh') then
            if spell.target.type ~= 'SELF' then
                equip(set_combine(sets.buff.ComposureOther, sets.midcast.Refresh))
                equip(sets.midcast.Gishdubar)
            else
                equip(sets.midcast.Refresh)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        elseif spell.english:startswith('Regen') then
            if spell.target.type ~= 'SELF' then
                equip(set_combine(sets.buff.ComposureOther, sets.midcast.Regen))
            else
                equip(sets.midcast.Regen)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        elseif spell.english:startswith('Protect') or spell.english:startswith('Shell') then
            if spell.target.type ~= 'SELF' then
                equip(sets.buff.ComposureOther)
            else
                equip(set_combine(sets.midcast['Enhancing Magic'].Duration, sets.midcast.ProShell.Self))
            end

            -- pure skill enhancing magic
        elseif spell.english:startswith('Temper') then
            equip(set_combine(sets.midcast['Enhancing Magic'].PureSkill, sets.midcast['Enhancing Magic'][weapon_set]))
        elseif spellMap == 'Enspell' then
            equip(set_combine(sets.midcast['Enhancing Magic'].PureSkill, sets.midcast['Enhancing Magic'][weapon_set]))

            -- caps at 500 skill
        elseif spellMap == 'BarElement' then
            if spell.target.type ~= 'SELF' then
                equip(sets.buff.ComposureOther, sets.midcast.BarElement)
            else
                equip(sets.midcast.BarElement)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        elseif spellMap == 'BarStatus' then
            equip(set_combine(sets.buff.ComposureOther, sets.midcast.BarStatus,
                sets.midcast['Enhancing Magic'].Duration[weapon_set]))
        elseif spellMap == 'GainStat' then
            equip(set_combine(sets.midcast['Enhancing Magic'].GainStat,
                sets.midcast['Enhancing Magic'].Duration[weapon_set]))

            -- skill enhancing, but has other factors that influence it
        elseif spell.english == 'Phalanx' and spell.target.type == 'SELF' then
            equip(set_combine(sets.midcast.Phalanx, sets.midcast.Phalanx[weapon_set]))
            -- because of their potential high usage and ease of capping,
            -- stoneskin, aquaveil, and blink won't change weapons
        elseif S { 'Stoneskin', 'Aquaveil' }:contains(spell.english) then
            equip(sets.midcast[spell.english])
        elseif spell.english == 'Blink' then
            equip(sets.midcast['Enhancing Magic'].Duration)

        else
            -- if unknown/undef, just go with duration
            if spell.target.type ~= 'SELF' then
                equip(sets.buff.ComposureOther)
            else
                equip(sets.midcast['Enhancing Magic'].Duration)
            end
            equip(sets.midcast['Enhancing Magic'].Duration[weapon_set])
        end

        adjust_timers_enhancing(spell, spellMap)
    elseif spell.skill == 'Healing Magic' then
        if spell.english:startswith('Cure') and spell.target.type == 'SELF' then
            equip(sets.midcast.CureSelf)
        elseif spell.english == 'Cursna' and spell.target.type == 'SELF' then
            equip(sets.midcast.CursnaSelf)
        end
    elseif spell_burstable:contains(spell.english) and state.MBurst.value == 'Magic Burst' then
        equip(sets.midcast.MagicBurst)
        state.MBurst:set('None')
        windower.add_to_chat(122, 'Magic Bursting. State reset')
    elseif spell.skill == 'Divine Magic' then
        if spell.english:startswith('Banish') then
            equip(sets.midcast.Banish)
        end
    elseif spell.skill == 'Elemental Magic' then
        if not save_TP then
            if info.can_DW then
                equip(sets.midcast['Elemental Magic'].DW)
            else
                equip(sets.midcast['Elemental Magic'].Weapon)
            end
        end
    end

    -- if state.LowMagic.value == 'Enabled' then
    --     equip(sets.naked)
    -- end
    -- Treasure Hunter handling
    if state.TreasureMode.value == 'Tag' and S { 'Poisonga', 'Poison', 'Diaga' }:contains(spell.english) then
        equip(sets.TreasureHunter)
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)

    --[[if state.OffenseMode.value == 'Magic' then
            equip(sets.idle.Weap+
            on)
        end]]


    if spell.english == 'Light Arts' then
        -- windower.add_to_chat(144, 'Light Arts')
        send_command('bind numpad4 input /ja "Accession" <me>')
    elseif spell.english == 'Dark Arts' then
        -- windower.add_to_chat(144, 'Dark Arts')
        send_command('bind numpad4 input /ja "Manifestation" <me>')
    end

    if hasRecast() then
        equip(recallRecast())
        resetRecast()
    end

    if spell.type == 'WeaponSkill' and state.RangedMode.value == 'Normal' then
        equip({ range = gear.default_ranged, ammo = gear.default_ranged_ammo })
    end

    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end

    -- equip(sets.Weapons.CroceaMors.DW)
    eventArgs.handled = false
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == "Offense Mode" then
        if S { 'Normal', 'Acc', 'Enspell' }:contains(newValue) then
            sets.idle = sets.base.idle
            sets.idle.Town = sets.base.idle.Town
            sets.idle.PDT = sets.base.idle.PDT
            sets.idle.Weak = sets.base.idle.Weak
        else
            sets.idle = set_combine(sets.idle, sets.idle.Weapon)
            sets.idle.Town = set_combine(sets.idle, sets.idle.Weapon)
            sets.idle.PDT = set_combine(sets.idle, sets.idle.Weapon)
            sets.idle.Weak = set_combine(sets.idle, sets.idle.Weapon)
        end
        sets.idle.MDT = sets.idle.PDT

    elseif stateField == 'Ranged Mode' then
        if newValue == 'Normal' then
            equip({ range = gear.default_ranged, ammo = gear.default_ranged_ammo })
            disable('range', 'ammo')
        else
            enable('range', 'ammo')
        end
    end
    --[[elseif stateField == 'Magic Burst' then
        if state.MBurst.value then
            add_to_chat(122, 'Magic Burst enabled')
        else
            add_to_chat(122, 'Magic Burst disabled')
        end]]
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
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

    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: ' .. state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    if state.MBurst.value == 'Magic Burst' then
        msg = msg .. ', Magic Burst'
    end

    add_to_chat(122, msg)
    display_current_caster_state()
    eventArgs.handled = true
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            -- if spell.type == 'WhiteMagic' then
            return 'MndEnfeebles'
            -- else
            --     return 'IntEnfeebles'
            -- end
            --[[elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end]]
        end
    end
end

function job_buff_change(buff, gain)
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

function job_update(cmdParams, eventArgs)
    update_combat_form()
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

function adjust_timers_enhancing(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end

    local current_time = os.time()

    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.

    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for spell_name, expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[spell_name] = true
        end
    end
    for spell_name, expires in pairs(temp_timer_list) do
        custom_timers[spell_name] = nil
        custom_timers.basetime[spell_name] = nil
    end

    local dur = calculate_duration_enhancing(spell.name, spellMap)
    if custom_timers[spell.name] then
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "' .. spell.name .. '"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
        end
    else
        send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers_enhancing(), which is only called on aftercast().
function calculate_duration_enhancing(spellName, spellMap)
    local mult = 1
    local base_duration = 0

    if spellName.english:startswith('Bar') then base_duration = 8 * 60 end
    if spellName.english:startswith('Protect') then base_duration = 30 * 60 end
    if spellName.english:startswith('Shell') then base_duration = 30 * 60 end
    if spellName.english 'Aquaveil' then base_duration = 10 * 60 end
    if spellName.english:startswith('En') then base_duration = 3 * 60 end
    if spellName.english 'Blaze Spikes' then base_duration = 3 * 60 end
    if spellName.english 'Ice Spikes' then base_duration = 3 * 60 end
    if spellName.english 'Shock Spikes' then base_duration = 3 * 60 end
    if spellName.english 'Regen' then base_duration = 75 end
    if spellName.english 'Regen II' then base_duration = 60 end
    if spellName.english 'Blink' then base_duration = 5 * 60 end
    if spellName.english 'Phalanx' then base_duration = 180 end
    if spellName.english 'Phalanx II' then base_duration = 240 end
    if spellName.english 'Stoneskin' then base_duration = 5 * 60 end
    if spellName.english 'Refresh' then base_duration = 150 end
    if spellName.english 'Refresh II' then base_duration = 150 end
    if spellName.english 'Refresh III' then base_duration = 150 end
    if spellName.english 'Flurry' then base_duration = 3 * 60 end
    if spellName.english 'Flurry II' then base_duration = 3 * 60 end
    if spellName.english 'Haste' then base_duration = 3 * 60 end
    if spellName.english 'Haste II' then base_duration = 3 * 60 end
    if spellName.english:startswith('Gain-') then base_duration = 5 * 60 end
    if spellName.english 'Temper' then base_duration = 3 * 60 end
    if spellName.english 'Temper II' then base_duration = 180 end
    if spellName.english:endswith('storm') then base_duration = 3 * 60 end

    -- get equipment bonuses
    if player.equipment.body == 'Vitiation Tabard +2' then mult = mult + 0.1 end
    if player.equipment.body == 'Vitiation Tabard +3' then mult = mult + 0.15 end
    if player.equipment.hands == 'Atrophy Gloves' then mult = mult + 0.15 end
    if player.equipment.hands == 'Atrophy Gloves +1' then mult = mult + 0.16 end
    if player.equipment.hands == 'Atrophy Gloves +2' then mult = mult + 0.18 end
    if player.equipment.hands == 'Atrophy Gloves +3' then mult = mult + 0.2 end
    if player.equipment.back == "Sucellos's Cape" then mult = mult + 0.2 end
    if player.equipment.waist == "Embla Sash" then mult = mult + 0.1 end
    if player.equipment.feet == 'Lethargy Houseaux' then mult = mult + 0.25 end
    if player.equipment.feet == 'Lethargy Houseaux' then mult = mult + 0.30 end
    if player.equipment.sub == 'Ammurapi Shield' then mult = mult + 0.16 end
    if player.equipment.main == 'Oranyan' then mult = mult + 0.1 end

    -- get composure bonus
    local composure_count = 0
    if S { 'Estq. Houseaux +2', 'Lethargy Houseaux', 'Lethargy Houseaux +2' }:contains(player.equipment.feet) then composure_count = composure_count
            + 1
    end
    if S { 'Estq. Chappel +2', 'Lethargy Chappel +1', 'Lethargy Chappel +1 +1' }:contains(player.equipment.head) then composure_count = composure_count
            + 1
    end
    if S { 'Estq. Sayon +2', 'Lethargy Sayon', 'Lethargy Sayon +2' }:contains(player.equipment.body) then composure_count = composure_count
            + 1
    end
    if S { 'Estq. Ganthrt. +2', 'Lethargy Gantherots', 'Lethargy Gantherots +1' }:contains(player.equipment.hands) then composure_count = composure_count
            + 1
    end
    if S { 'Estq. Fuseau +2', 'Lethargy Fuseau', 'Lethargy Fuseau +1' }:contains(player.equipment.legs) then composure_count = composure_count
            + 1
    end

    if buffactive.composure then
        if spellName.target.name == player.name then
            mult = mult * 3
        else
            if composure_count == 5 then
                mult = mult + 0.5
            elseif composure_count == 4 then
                mult = mult + 0.35
            elseif composure_count == 3 then
                mult = mult + 0.2
            elseif composure_count == 2 then
                mult = mult + 0.1
            end
        end
    end

    if S { "Duelist's Gloves +2", 'Vitiation Gloves', 'Vitiation Gloves +1', 'Vitiation Gloves +2', 'Vitiation Gloves +3' }
        :contains(player.equipment.hands) then
        base_duration = base_duration + (info.JobPoints.EnhancingMerits * 9)
    else
        base_duration = base_duration + (info.JobPoints.EnhancingMerits * 6)
    end
    base_duration = base_duration + info.JobPoints.EnhancingDuration

    local totalDuration = math.floor(mult * base_duration)

    return totalDuration
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
    then return true
    end
end

-- if the mainhand weapon changes, update it so callbacks can tell.
function isMainChanged()
    if info.lastWeapon == player.equipment.main then
        return false
    else
        info.lastWeapon = player.equipment.main
        return true
    end
end

-- initializes weapon recast handler
function initRecast()
    sets._Recast = {}
    info._RecastFlag = false
end

-- sets the Recast weapon set to what is currently equipped
-- affected slots: main sub ranged ammo
function setRecast()
    if not hasRecast() then
        sets._Recast.main = player.equipment.main
        sets._Recast.sub = player.equipment.sub
        sets._Recast.range = player.equipment.range
        sets._Recast.ammo = player.equipment.ammo
    end
    info._RecastFlag = sets._Recast.main or sets._Recast.sub or sets._Recast.range or sets._Recast.ammo
end

-- resets the Recast weapon set to nil
function resetRecast()
    sets._Recast = { main = nil, sub = nil, range = nil, ammo = nil }
    info._RecastFlag = false
end

-- returns the Recast weapon set
function recallRecast()
    return sets._Recast
end

-- returns true if the recast set has been used
function hasRecast()
    return info._RecastFlag
end

-- check if there is something in the sub slot
function procSub()
    local currentWeapon = player.equipment.main
    if player.equipment.sub == 'empty' then
        if info.Weapons.Twohanded:contains(info.Weapons.Type[currentWeapon]) then
            equip(sets.TwoHand_OH)
        else
            equip(sets.OneHand_OH)
        end
    end
end

function calculate_haste()
    if not S { 'NIN', 'DNC' }:contains(player.sub_job) then return end
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

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(9, 4)

    elseif player.sub_job == 'NIN' then
        set_macro_page(6, 4)
    elseif player.sub_job == 'WHM' then
        set_macro_page(2, 4)
    elseif player.sub_job == 'BLM' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'SCH' then
        set_macro_page(2, 4)
    else
        set_macro_page(1, 4)
    end

    if S { 'DNC', 'NIN' }:contains(player.sub_job) then
        send_command("@wait 5;input /lockstyleset 14")
    else
        send_command("@wait 5;input /lockstyleset 9")
    end
end
