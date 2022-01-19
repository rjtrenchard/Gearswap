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
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('Mote-TreasureHunter')

    state.OffenseMode:options('Normal', 'Acc', 'Enspell', 'Magic')
    state.HybridMode:options('Normal', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'MDT')
    
    state.MBurst = M{['description']='Magic Burst','None', 'Magic Burst'}
    state.TPMode = M{['description']='TP Mode', 'Expend', 'Preserve', 'Preserve > 1000'}
    state.UseCustomTimers = M(false, 'Use Custom Timers')

    info.JobPoints = {}
    info.JobPoints.EnhancingDuration = 20
    info.JobPoints.EnhancingMerits = 5

    gear.default.obi_waist = "Acuity Belt +1"
    gear.default.drain_waist = "Fucho-no-Obi"
    gear.default.cure_waist = "Embla Sash"


    gear.int_cape = { name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+4','"Mag.Atk.Bns."+10',}}
    gear.mnd_cape = { name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20',}}
    gear.melee_cape = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Damage taken-5%',}}
    gear.ws_cape = { name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.idle_cape = gear.melee_cape

    gear.PhalanxHead = { name="Taeon Chapeau", augments={'Phalanx +3',}}
    gear.PhalanxBody = { name="Taeon Tabard", augments={'Phalanx +3',}}
    gear.PhalanxHands = { name="Taeon Gloves", augments={'Phalanx +3',}}
    gear.PhalanxLegs = { name="Taeon Tights", augments={'"Fast Cast"+3','Phalanx +3',}}
    gear.PhalanxFeet = { name="Taeon Boots", augments={'Phalanx +3',}}
    
    gear.CureHands = { name="Telchine Gloves", augments={'"Cure" potency +7%', '"Regen" potency +3'}}

    gear.EnhancingWeapon = { name="Colada", augments={'Enh. Mag. eff. dur. +4','STR+1','Mag. Acc.+16',}}

    enhancing_skill_magic = S{'Temper', 'Temper II', 'Aquaveil'}

    custom_timers = {}

    sets._Recast = {}
    info._RecastFlag = false

    select_default_macro_book()

    info.can_DW = S{'NIN', 'DNC'}:contains(player.sub_job)
    if info.can_DW then
        send_command('bind numpad7 gs equip sets.Weapons.CroceaMors.DW')
        send_command('bind numpad8 gs equip sets.Weapons.Enspell.DW')
        send_command('bind numpad9 gs equip sets.Weapons.Naegling.DW')
    else
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

    -- Precast Sets
    sets.TreasureHunter = {head="Volte Cap", waist="Chaac belt"}

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Vitiation Tabard +3"}


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Atrophy Chapeau +2",
        body="Atrophy Tabard +3",hands="Yaoyotl Gloves",
        back="Refraction Cape",legs="Hagondes Pants",feet="Vitiation boots +3"}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    sets.precast.FC = {ammo="Sapience Orb",
        head="Atrophy Chapeau +2",neck="Baetyl Pendant",ear1="Loquacious Earring",ear2="Malignance Earring",
        body="Vitiation Tabard +3",hands="Gendewitha Gages +1",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Embla Sash",legs="Ayanmo Cosciales +2",feet="Jhakri Pigaches +2"}
    sets.precast.FastRecast = sets.precast.FC

    sets.precast['Enfeebling Magic'] = set_combine(sets.precast.FC, {head="Lethargy Chappel +1"})
    sets.precast['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast['Dispelga'] = set_combine(sets.precast.FC, {main="Daybreak"})
    sets.precast['Impact'] = set_combine(sets.precast.FC, {main="Crocea Mors", sub="Ammurapi Shield", head="", body="Crepuscular Cloak"})
    sets.precast.FC['Impact'] = set_combine(sets.precast.FC, {head="",body="Crepuscular Cloak"})

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Voluspa Tathlum",
        head="Vitiation Chapeau +3",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Vitiation Tabard +3",hands="Atrophy Gloves +3",ring1="Apate Ring",ring2="Karieyh Ring +1",
        back=gear.ws_cape,waist="Fotia Belt",legs="Vitiation Tights +2",feet="Chironic Slippers"}

    sets.precast.WS.Crit = {ammo="Yetshila +1",
        head="Vitiation Chapeau +3",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
        body="Vitiation Tabard +3",hands="Atrophy Gloves +3",ring1="Ilabrat Ring",ring2="Begrudging Ring",
        back=gear.ws_cape,waist="Fotia Belt",legs="Malignance Tights",feet="Chironic Slippers"}

    sets.precast.WS.Acc = {ammo='Ginsen',
        head='Malignance Chapeau', neck='Fotia Gorget', ear1='Cessance Earring', ear2='Moonshade Earring',
        body="Vitiation Tabard +3", hands='Malignance Gloves', ring1='Apate Ring',ring2="Karieyh Ring +1",
        back=gear.ws_cape,waist='Fotia Gorget', legs='Malignance Tights', feet='Chironic Slippers'}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS,{ammo="Regal Gem",
        head="Vitiation Chapeau +3",ear1="Sherida Earring",ear2="Snotra Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Stikini Ring +1",ring2="Metamorph Ring +1",
        back=gear.mnd_cape, legs="Vitiation Tights +2",feet="Jhakri Pigaches +2"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Regal Gem",
        head="Pixie Hairpin +1",neck="Baetyl Pendant",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Jhakri Robe +2",hands="Jhakri cuffs +1",ring1="Archon Ring",ring2="Metamorph Ring +1",
        back=gear.ws_cape,waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Vitiation boots +3"}

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS.Crit, {ammo="Yetshila +1",
    head="Ayanmo Zucchetto +2", body="Jhakri Robe +2", hands="Atrophy Gloves +3", feet="Ayanmo Gambieras +1"})

    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit, {ring2="Begrudging Ring"})

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {ammo="Voluspa Tathlum",neck="Caro Necklace", waist="Sailfi Belt +1"})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.Acc,
        {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Caro Necklace",
        body="Malignance Tabard", hands="Malignance Gloves",
        waist="Sailfi Belt +1", legs="Malignance Tights", feet="Malignance Boots"})

    sets.precast.WS['Death Blossom'] = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.Crit, {})

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {ammo='Regal Gem',
        head="Vitiation Chapeau +3", neck="Fotia Gorget", ear1="Malignance Earring", ear2="Moonshade Earring",
        body="Vitiation Tabard +3", hands="Atrophy Gloves +3", ring1="Karieyh Ring +1", ring2="Metamorph Ring +1",
        back=gear.ws_cape, waist="Sailfi Belt +1", legs="Vitiation Tights +2", feet="Chironic Slippers"
    })


    -- Midcast Sets
    sets.SIRD = {ammo="Staunch Tathlum +1",
        neck="Loricate Torque +1", 
        body="Rosette jaseran +1",hands="Chironic Gloves",ring1="Evanescence Ring", ring2="Freke Ring",
        legs="Carmine Cuisses +1"
    }

    sets.midcast.FastRecast = { ammo="Sapience Orb",
        head="Atrophy Chapeau +2", neck="Baetyl Pendant",ear1="Loquacious Earring",ear2="Malignance Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Fi Follet Cape +1",waist="Embla Sash",legs="Atrophy Tights +3",feet="Vitiation boots +3"}
    sets.midcast.FC = sets.midcast.FastRecast

    -- aims for 500 skill (476 base, 24 needed)
    sets.midcast['Enhancing Magic'] = {
        neck="Duelist's Torque +2",
        body="Vitiation Tabard +3",hands="Atrophy Gloves +3",
        back="Ghostfyre Cape",waist="Embla Sash",feet="Lethargy Houseaux +1"}
    -- uncapped skill
    sets.midcast['Enhancing Magic'].PureSkill = {
        head="Befouled Crown",neck="Incanter's Torque",ear1="Andoaa Earring",ear2="Mimir Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Ghostfyre Cape",waist="Olympus Sash",legs="Atrophy Tights +3",feet="Lethargy Houseaux +1"}
    sets.midcast['Enhancing Magic'].Weapon = {main="Pukulatmuj +1", sub="Forfend +1"}
    sets.midcast['Enhancing Magic'].DW = sets.midcast['Enhancing Magic'].Weapon
    sets.midcast['Enhancing Magic'].None = {}

    -- Enhancing magic skill duration, no regard for skill
    sets.midcast['Enhancing Magic'].Duration = {
        neck="Duelist's Torque +2",
        body="Vitiation tabard +3",hands="Atrophy Gloves +3", 
        back="Sucellos's Cape",waist='Embla Sash',feet="Lethargy Houseaux +1"}
    sets.midcast['Enhancing Magic'].Duration.Weapon = {main=gear.EnhancingWeapon,sub="Ammurapi Shield"}
    sets.midcast['Enhancing Magic'].Duration.DW = sets.midcast['Enhancing Magic'].Duration.Weapon
    sets.midcast['Enhancing Magic'].Duration.None = {}

    -- Phalanx for self
    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
        head=gear.PhalanxHead, neck="Duelist's Torque +2",ear1="Andoaa Earring",
        body=gear.PhalanxBody, hands=gear.PhalanxHands, ring1="Stikini Ring +1", ring2="Stikini Ring +1",
        back="Ghostfyre Cape", wait="Embla Sash", legs=gear.PhalanxLegs, feet=gear.PhalanxFeet
    })
    sets.midcast.Phalanx.Weapon = {main="Sakpata's Sword", sub="Ammurapi Shield"}
    sets.midcast.Phalanx.DW = {main="Sakpata's Sword", sub="Egeking"}
    sets.midcast.Phalanx.None = {}

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'].Duration,{main="Bolelabunga",sub="Genbu's Shield",hands="Telchine Gloves"})

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'].Duration,{head="Amalric Coif +1",body="Atrophy Tabard +3",hands="Atrophy Gloves +3",legs="Lethargy Fuseau +1"})
    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration,{head="Amalric Coif +1", legs="Shedir Seraweels"})

    -- Stoneskin +125 (425 HP absorbed)
    sets.midcast.Stoneskin = {
        neck="Nodens Gorget",ear1="Earthcry Earring", 
        hands="Stone Mufflers",
        waist="Siegel Sash", legs="Shedir Seraweels"
    }

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {legs="Shedir Seraweels"})
    sets.midcast.BarStatus = sets.midcast.BarElement

    sets.midcast.GainStat = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. gloves +3"})

    sets.midcast.ProShell = {}
    sets.midcast.ProShell.Self = set_combine(sets.midcast.ProShell, {ring1="Sheltered Ring"})
    
    sets.midcast['Divine Magic'] = {neck="Incanter's Torque",ring1="Stikini Ring +1",ring2="Metamorph Ring +1"}
    sets.midcast['Divine Magic'].Weapon = {main="Daybreak",sub="Ammurapi Shield"}
    sets.midcast['Divine Magic'].DW = {main="Daybreak", sub="Tauret"}
    sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'], {head="Ipoca Beret", neck="Jokushu Chain", ring2="Fenian Ring", back="Disperser's Cape"})

    sets.midcast['Healing Magic'] = {
        neck="Incanter's Torque", 
        body="Vitiation Tabard +3", ring1="Stikini Ring +1", ring2="Stikini Ring +1",
        legs="Carmine Cuisses +1", 
    }
    
    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], {main="Daybreak",ammo="Regal Gem",
    head="Vanya Hood",neck="Nodens Gorget",ear1="Snotra Earring",ear2="Malignance Earring",
    body="Gendewitha Bliaut +1",hands="Telchine Gloves",
    back=gear.mnd_cape,waist=gear.ElementalObi,legs="Atrophy Tights +3"})

    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = sets.midcast.Cure

    sets.midcast.Cursna = set_combine(sets.midcast['Healing Magic'], {feet="Gendewitha Galoshes +1"})

    sets.midcast['Enfeebling Magic'] = {ammo="Regal Gem",
        head="Vitiation Chapeau +3",neck="Duelist's Torque +2",ear1="Snotra Earring",ear2="Malignance Earring",
        body="Lethargy Sayon +1",hands="Malignance Gloves",ring1="Kishar Ring",ring2="Metamorph Ring +1",
        back="Sucellos's Cape",waist="Acuity Belt +1",legs="Chironic Hose",feet="Vitiation boots +3"}
    sets.midcast['Enfeebling Magic'].Weapon = {main="Daybreak", sub="Ammurapi Shield"}
    sets.midcast['Enfeebling Magic'].DW ={main="Daybreak", sub="Tauret"}

    sets.midcast['Enfeebling Magic'].Acc = {ammo="Regal Gem",
        head=empty, neck="Duelist's Torque +2",ear1="Snotra Earring", ear2="Malignance Earring",
        body="Cohort Cloak +1", hands="Malignance Gloves",ring1="Stikini Ring +1", ring2="Metamorph Ring +1",
        back=gear.mnd_cape, waist="Acuity Belt +1", legs="Chironic Hose", feet="Vitiation boots +3"}

    sets.midcast['Enfeebling Magic'].Duration = set_combine(sets.midcast['Enfeebling Magic'], {
        head="Lethargy Chappel +1", body="Lethargy Sayon +1", hands="Lethargy Gantherots +1", legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"
    })
    
    sets.midcast['Dispel'] = set_combine(sets.midcast['Enfeebling Magic'].Acc, {neck="Duelist's Torque +2", back=gear.int_cape})
    sets.midcast['Dispelga'] = set_combine(sets.midcast.Dispel, {main="Daybreak"})

    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {ammo="Regal Gem", back=gear.mnd_cape})
    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {ammo="Regam Gem",back=gear.int_cape})

    sets.midcast['Poison'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Volte Cap", waist="Chaac Belt"})
    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {})

    sets.midcast["Frazzle II"] = set_combine(sets.midcast['Enfeebling Magic'].Acc, {main="Contemplator +1", sub="",head=empty, body="Cohort Cloak +1", back=gear.int_cape})

    sets.midcast['Elemental Magic'] = {ammo="Ghastly Tathlum +1",
        head=empty,neck="Baetyl Pendant",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Cohort Cloak +1",hands="Amalric Gages +1",ring1="Jhakri Ring",ring2="Metamorph Ring +1",
        back=gear.int_cape,waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Vitiation boots +3"}
    sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {head=empty,neck="Sanctity Necklace",body="Cohort Cloak +1",waist="Acuity Belt +1", ring1="Stikini Ring +1", ring2="Metamorph Ring +1"})
    sets.midcast['Elemental Magic'].Weapon = {main="Daybreak", sub="Genbu's Shield"}
    sets.midcast['Elemental Magic'].DW = {main="Daybreak", sub="Tauret"}

    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'].Acc, {mainhead=empty,body="Crepuscular Cloak", ring1="Archon Ring"})

    sets.midcast.MagicBurst = {neck="Mizukage-no-kubikazari",ring1="Jhakri Ring", ring2="Mujin Band", feet="Jhakri Pigaches +2"}

    sets.midcast['Dark Magic'] = {main="Naegling",sub="Genbu's Shield",ammo="Regal Gem",
        head="Malignance Chapeau",neck="Erra Pendant",ear1="Mani Earring",ear2="Malignance Earring",
        body="Carmine Scale Mail +1",hands="Malignance Gloves",ring1="Stikini Ring +1",ring2="Evanescence Ring",
        back=gear.int_cape,waist="Casso Sash",legs="Malignance Tights",feet="Malignance Boots"}
    sets.midcast['Dark Magic'].Weapon = {main="Naegling", sub="Ammurapi Shield"}
    sets.midcast['Dark Magic'].DW = sets.midcast['Dark Magic'].Weapon

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1", neck="Erra Pendant", 
        ring1="Archon Ring", ring2="Evanescence Ring", waist=gear.DrainWaist})
    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.buff.ComposureOther = {
        head="Lethargy Chappel +1",
        body="Lethargy Sayon +1",hands="Atrophy Gloves +3",
        legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}
    
    sets.buff.Composure = {
        head="Lethargy Chappel +1",
        body="Lethargy Sayon +1",hands="Lethargy Gantherots +1",
        legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}

    sets.buff.Saboteur = {hands="Lethargy Gantherots +1"}


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {main="Bolelabunga", sub="Genbu's Shield",ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Bathy Choker +1",
        body="Jhakri Robe +2",hands="Serpentes Cuffs",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Felicitas cape +1",waist="Fucho-no-obi",legs="Nares Trews",feet="Chelona Boots +1"}


    -- Idle sets
    sets.idle.Weapon = {main="Bolelabunga", sub="Genbu's Shield"}
    sets.idle = {ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Jhakri Robe +2",hands="Malignance Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.idle_cape,waist="Fucho-No-Obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.Town = {ammo="Homiliary",
        head="Shaded Spectacles",neck="Smithy's Torque",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Blacksmith's Smock",hands="Smithy's Mitts",ring1="Confectioner's Ring",ring2="Craftmaster's Ring",
        back=gear.idle_cape,waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.Weak = {ammo="Homiliary",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Stikini ring +1",ring2="Defending Ring",
        back=gear.idle_cape,waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.PDT = {ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Stikini Ring +1",ring2="Defending Ring",
        back=gear.idle_cape,waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.MDT = sets.idle.PDT

    sets.base = {}
    sets.base.idle = sets.idle
    sets.base.idle.Town = sets.idle.Town
    sets.base.idle.Weak = sets.idle.Weak
    sets.base.idle.PDT = sets.idle.PDT
    sets.base.idle.MDT = sets.idle.PDT


    -- Defense sets
    sets.defense.PDT = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Eabani Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Flume Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.MDT = set_combine(sets.defense.PDT,{ring2="Archon Ring"})

    sets.Kiting = {legs="Carmine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.Weapons = {}
    sets.Weapons.Naegling = {main="Naegling", sub="Genbu's Shield"}
    sets.Weapons.Naegling.DW = {main="Naegling", sub="Thibron"}
    sets.Weapons.Enspell = {main="Aern Dagger", sub="Genbu's Shield"}
    sets.Weapons.Enspell.DW = {main="Aern Dagger", sub="Aern Dagger II"}
    sets.Weapons.CroceaMors = {main="Crocea Mors", sub="Genbu's Shield"}
    sets.Weapons.CroceaMors.DW = {main="Crocea Mors", sub="Daybreak"}

    sets.engaged = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Anu Torque",ear1="Sherida Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Petrov Ring",ring1="Ilabrat Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.Acc = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Telos Earring",ear2="Cessance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Jhakri Ring",ring1="Varar Ring +1",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.Enspell = set_combine(sets.engaged.Acc, {ammo="Regal Gem", 
        neck="Duelist's Torque +2",ear1="Crepuscular Earring",ear2="Malignance Earring",
        hands="Ayanmo Manopolas +2", ring1="Stikini Ring +1", ring2="Stikini Ring +1", 
        back=gear.melee_cape,waist="Hachirin-no-Obi"})

    sets.engaged.Defense = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Sherida Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Defending Ring",ring1="Ilabrat Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.PDT = sets.engaged.Defense
    sets.engaged.MDT = set_combine(sets.engaged.PDT, {ring2="Archon Ring"})


    sets.engaged.DW = set_combine(sets.engaged, {ear2="Suppanomimi", waist="Sailfi belt +1", legs="Carmine Cuisses +1"})
    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {ear2="Suppanomimi", waist="Sailfi Belt +1", legs="Carmine Cuisses +1"})

    sets.engaged.Defense.DW = set_combine(sets.engaged.Defense, {waist="Sailfi Belt +1", legs="Carmine Cuisses +1"})
    sets.engaged.DW.Defense = sets.engaged.Defense.DW
    sets.engaged.DW.PDT = sets.engaged.Defense.DW
    sets.engaged.DW.MDT = set_combine(sets.engaged.PDT.DW, {ring2 = "Archon Ring"})

    sets.engaged.DW.Enspell = set_combine(sets.engaged.DW.Acc, {ammo="Regal Gem", 
        head="Malignance Chapeau",neck="Duelist's Torque +2",ear1="Crepuscular Earring",ear2="Malignance Earring",
        body="Malignance Tabard",hands="Ayanmo Manopolas +2", ring1="Stikini Ring +1", ring2="Stikini Ring +1", 
        back=gear.int_cape, waist="Acuity Belt +1", legs="Malignance Tights"})


    -- define idle sets


    -- Default offense mode based on subjob
    if S{'BRD', 'COR', 'WHM', 'BLM', 'SCH', 'SMN', 'DRK', 'PLD'}:contains(player.sub_job) then
        state.OffenseMode:set('Magic')
    else
        state.TPMode:set('Preserve > 1000')
    end


    if S{'Normal', 'Acc', 'Enspell'}:contains(state.OffenseMode.value) then
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
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Dispelga' then
        if player.equipment.main == 'Daybreak' or player.equipment.sub == 'Daybreak' then 
            return
        else
            -- changing weapons is implicit with dispelga, unless it is already equipped
            equip(sets.precast.Dispelga)
            --cast_delay(1.0)
        end
    -- Because impact is so slow and takes crucial equip slots, 
    -- we're going to force it to use crocea mors for more utility
    elseif spell.english == 'Impact' then
        if player.equipment.body == 'Crepuscular Cloak' then return
        else
            equip(sets.precast['Impact'])
            --cast_delay(1.0)
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

        if not save_TP and not S{'Dispelga', 'Impact', 'Dia', 'Dia II', 'Dia III', 'Bio', 'Bio II', 'Bio III', 'Frazzle II'}:contains(spell.english) then
            if info.can_DW then 
                equip(sets.midcast["Enfeebling Magic"].DW)
            else
                equip(sets.midcast["Enfeebling Magic"].Weapon)
            end
        end

        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end

        if state.Buff['Elemental Seal'] then
            equip(sets.midcast['Enfeebling Magic'].Duration)
        end

    elseif spell.skill == 'Enhancing Magic' then

        local weapon_set = nil
        
        if info.can_DW and not save_TP then 
            weapon_set = 'DW' 
        elseif not save_TP then
            weapon_set = 'Weapon' 
        else
            weapon_set = 'None'
        end


            -- skill independant but special gear
        if spell.english:startswith('Refresh') or spell.english:startswith('Regen') then 
            equip(set_combine(sets.midcast[spell.english], sets.midcast['Enhancing Magic'].Duration[weapon_set]))
        elseif spell.english:startswith('Protect') or spell.english:startswith('Shell') then
            equip(set_combine(sets.midcast.ProShell, sets.midcast['Enfeebling Magic'].Duration))
            if spell.target.type == 'SELF' then equip(sets.midcast.ProShell.Self) end

            -- pure skill enhancing magic
        elseif spell.english:startswith('Temper') then
            equip(set_combine(sets.midcast['Enhancing Magic'].PureSkill, sets.midcast['Enhancing Magic'][weapon_set]))
        elseif spellMap == 'Enspell' then
            equip(set_combine(sets.midcast['Enhancing Magic'].PureSkill, sets.midcast['Enhancing Magic'][weapon_set]))

            -- caps at 500 skill
        elseif spellMap == 'BarElement' then
            equip(set_combine(sets.midcast.BarElement, sets.midcast['Enhancing Magic'].Duration[weapon_set]))
        elseif spellMap == 'BarStatus' then
            equip(set_combine(sets.midcast.BarStatus, sets.midcast['Enhancing Magic'].Duration[weapon_set]))
        elseif spellMap == 'GainStat' then
            equip(set_combine(sets.midcast['Enhancing Magic'].GainStat, sets.midcast['Enhancing Magic'].Duration[weapon_set]))

            -- skill enhancing, but has other factors that influence it
        elseif spell.english == 'Phalanx' and spell.target.type == 'SELF' then
            equip(set_combine(sets.midcast.Phalanx, sets.midcast.Phalanx[weapon_set]))
            -- because of their potential high usage and ease of capping, 
            -- stoneskin, aquaveil, and blink won't change weapons
        elseif S{'Stoneskin', 'Aquaveil'}:contains(spell.english) then
            equip(sets.midcast[spell.english])
        elseif spell.english == 'Blink' then
            equip(sets.midcast['Enhancing Magic'].Duration)

        else
            -- if unknown/undef, just go with duration
            equip(set_combine(sets.midcast['Enhancing Magic'].Duration, sets.midcast['Enhancing Magic'].Duration[weapon_set]))
        end
        adjust_timers_enhancing(spell, spellMap)
    elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
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

    -- Treasure Hunter handling
    if state.TreasureMode.value == 'Tag' and S{'Poisonga', 'Poison', 'Diaga'}:contains(spell.english) then
        equip(sets.TreasureHunter)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

    if stateField == "Offense Mode" then
        if S{'Normal', 'Acc', 'Enspell'}:contains(newValue) then
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
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
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
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
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
    for spell_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[spell_name] = true
        end
    end
    for spell_name,expires in pairs(temp_timer_list) do
        custom_timers[spell_name] = nil
        custom_timers.basetime[spell_name] = nil
    end
    
    local dur = calculate_duration_enhancing(spell.name, spellMap)
    if custom_timers[spell.name] then
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        send_command('timers create "'..spell.name..'" '..dur..' down')
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers_enhancing(), which is only called on aftercast().
function calculate_duration_enhancing(spellName, spellMap)
    local mult = 1
    local base_duration = 0

    if spellName.english:startswith('Bar') then base_duration = 8*60 end
    if spellName.english:startswith('Protect') then base_duration = 30*60 end
    if spellName.english:startswith('Shell') then base_duration = 30*60 end
    if spellName.english 'Aquaveil' then base_duration = 10*60 end
    if spellName.english:startswith('En') then base_duration = 3*60 end
    if spellName.english 'Blaze Spikes' then base_duration = 3*60 end
    if spellName.english 'Ice Spikes' then base_duration = 3*60 end
    if spellName.english 'Shock Spikes' then base_duration = 3*60 end
    if spellName.english 'Regen' then base_duration = 75 end
    if spellName.english 'Regen II' then base_duration = 60 end
    if spellName.english 'Blink' then base_duration = 5*60 end
    if spellName.english 'Phalanx' then base_duration = 180 end
    if spellName.english 'Phalanx II' then base_duration = 240 end
    if spellName.english 'Stoneskin' then base_duration = 5*60 end
    if spellName.english 'Refresh' then base_duration = 150 end
    if spellName.english 'Refresh II' then base_duration = 150 end
    if spellName.english 'Refresh III' then base_duration = 150 end
    if spellName.english 'Flurry' then base_duration = 3*60 end
    if spellName.english 'Flurry II' then base_duration = 3*60 end
    if spellName.english 'Haste' then base_duration = 3*60 end
    if spellName.english 'Haste II' then base_duration = 3*60 end
    if spellName.english:startswith('Gain-') then base_duration = 5*60 end
    if spellName.english 'Temper' then base_duration = 3*60 end
    if spellName.english 'Temper II' then base_duration = 180 end
    if spellName.english:endswith('storm') then base_duration = 3*60 end

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
    if S{'Estq. Houseaux +2', 'Lethargy Houseaux', 'Lethargy Houseaux +1'}:contains(player.equipment.feet) then composure_count = composure_count + 1 end
    if S{'Estq. Chappel +2', 'Lethargy Chappel +1', 'Lethargy Chappel +1 +1'}:contains(player.equipment.head) then composure_count = composure_count + 1 end
    if S{'Estq. Sayon +2', 'Lethargy Sayon', 'Lethargy Sayon +1'}:contains(player.equipment.body) then composure_count = composure_count + 1 end
    if S{'Estq. Ganthrt. +2', 'Lethargy Gantherots', 'Lethargy Gantherots +1'}:contains(player.equipment.hands) then composure_count = composure_count + 1 end
    if S{'Estq. Fuseau +2', 'Lethargy Fuseau', 'Lethargy Fuseau +1'}:contains(player.equipment.legs) then composure_count = composure_count + 1 end
    
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

    if S{"Duelist's Gloves +2", 'Vitiation Gloves', 'Vitiation Gloves +1','Vitiation Gloves +2','Vitiation Gloves +3'}:contains(player.equipment.hands) then
        base_duration = base_duration + (info.JobPoints.EnhancingMerits * 9)
    else
        base_duration = base_duration + (info.JobPoints.EnhancingMerits * 6)
    end
    base_duration = base_duration + info.JobPoints.EnhancingDuration

    local totalDuration = math.floor(mult*base_duration)

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

function job_post_aftercast(spell, action, spellMap, eventArgs)
        -- if we changed weapons, change back.
        if hasRecast() then
            equip(recallRecast())
            resetRecast()
        end
        --[[if state.OffenseMode.value == 'Magic' then
            equip(sets.idle.Weap+
            on)
        end]]
        eventArgs.handled = false
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
    sets._Recast = {main = nil, sub = nil, range = nil, ammo = nil}
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

    send_command( "@wait 5;input /lockstyleset 9" )
end
