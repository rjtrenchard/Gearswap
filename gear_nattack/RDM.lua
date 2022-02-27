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
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function include_job_stats()

    info.JobPoints = {}
    info.JobPoints.EnhancingDuration = 20
    info.JobPoints.EnhancingMerits = 5

    enhancing_skill_magic = S{'Temper', 'Temper II', 'Aquaveil'}
    
end

-- Define sets and vars used by this job file.
function include_job_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    gear.default.obi_waist ="Acuity Belt +1"

    gear.int_cape = { name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+4','"Mag.Atk.Bns."+10',}}
    gear.mnd_cape = { name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20',}}
    gear.melee_cape = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Damage taken-5%',}}
    gear.ws_cape = { name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.idle_cape = gear.melee_cape
    
    gear.CureHands = { name="Telchine Gloves", augments={'"Cure" potency +7%', '"Regen" potency +3'}}

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
    sets.precast['Impact'] = set_combine(sets.precast.FC, {head="", body="Crepuscular Cloak"})
    sets.precast.FC['Impact'] = set_combine(sets.precast.FC, {head="",body="Crepuscular Cloak"})

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Voluspa Tathlum",
        head="Vitiation Chapeau +3",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Vitiation Tabard +3",hands="Atrophy Gloves +3",ring1="Apate Ring",ring2="Epaminondas's Ring",
        back=gear.ws_cape,waist="Fotia Belt",legs="Vitiation Tights +2",feet="Chironic Slippers"}

    sets.precast.WS.Crit = {ammo="Yetshila +1",
        head="Vitiation Chapeau +3",neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring",
        body="Vitiation Tabard +3",hands="Atrophy Gloves +3",ring1="Ilabrat Ring",ring2="Begrudging Ring",
        back=gear.ws_cape,waist="Fotia Belt",legs="Malignance Tights",feet="Chironic Slippers"}

    sets.precast.WS.Acc = {ammo='Ginsen',
        head='Malignance Chapeau', neck='Fotia Gorget', ear1='crepuscular earring', ear2='Moonshade Earring',
        body="Vitiation Tabard +3", hands='Malignance Gloves', ring1='Apate Ring',ring2="Epaminondas's Ring",
        back=gear.ws_cape,waist='Fotia Gorget', legs='Malignance Tights', feet='Chironic Slippers'}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS,{ammo="Regal Gem",
        head="Vitiation Chapeau +3",ear1="Sherida Earring",ear2="Snotra Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Stikini Ring +1",ring2="Metamorph Ring +1",
        back=gear.mnd_cape, legs="Vitiation Tights +2",feet="Jhakri Pigaches +2"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Regal Gem",
        head="Pixie Hairpin +1",neck="Baetyl Pendant",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Archon Ring",ring2="Metamorph Ring +1",
        back=gear.ws_cape,waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Vitiation boots +3"}

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS.Crit, {ammo="Yetshila +1",
    head="Ayanmo Zucchetto +2", body="Jhakri Robe +2", hands="Atrophy Gloves +3", feet="Ayanmo Gambieras +2"})

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
        body="Vitiation Tabard +3", hands="Atrophy Gloves +3", ring1="Epaminondas's Ring", ring2="Metamorph Ring +1",
        back=gear.ws_cape, waist="Sailfi Belt +1", legs="Vitiation Tights +2", feet="Chironic Slippers"
    })


    -- Midcast Sets
    sets.midcast.SIRD = {sub="Culminus",ammo="Staunch Tathlum +1",
        legs="Carmine Cuisses +1"
    }

    sets.midcast.FastRecast = { ammo="Sapience Orb",
        head="Atrophy Chapeau +2",ear1="Loquacious Earring",ear2="Malignance Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Atrophy Tights +3",feet="Vitiation boots +3"}
    sets.midcast.FC = sets.midcast.FC

    sets.midcast.Cure = {main="Daybreak",sub="Ammurapi Shield",ammo="Regal Gem",
        head="Vanya Hood",neck="Nodens Gorget",ear1="Roundel Earring",ear2="Malignance Earring",
        body="Gendewitha Bliaut +1",hands="Telchine Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Oretania's Cape",waist="Witful Belt",legs="Atrophy Tights +3",feet="Vitiation boots +3"}

    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = sets.midcast.Cure

    sets.midcast['Enhancing Magic'] = {main={ name="Grioavolr", augments={'Enh. Mag. eff. dur. +8','MND+12','Mag. Acc.+27',}},sub="Enki Strap",ammo="Regal Gem",
        head="Befouled Crown",neck="Duelist's Torque +2",ear1="Andoaa Earring",ear2="Mimir Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.mnd_cape,waist="Embla Sash",legs="Atrophy Tights +3",feet="Lethargy Houseaux +1"}

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'],{main="Bolelabunga",sub="Ammurapi Shield",hands="Telchine Gloves"})

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'],{head="Amalric Coif +1",body="Atrophy Tabard +3",hands="Atrophy Gloves +3",legs="Lethargy Fuseau +1"})
    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'],{head="Amalric Coif +1"})

    sets.midcast.Stoneskin = {waist="Siegel Sash"}

    --sets.midcast.ProShell = set_combine(set.midcast['Enhancing Magic'], {ring1="Sheltered Ring"})

    sets.midcast['Enfeebling Magic'] = {main="Naegling",sub="Tauret",ammo="Regal Gem",
        head="Vitiation Chapeau +3",neck="Duelist's Torque",ear1="Snotra Earring",ear2="Malignance Earring",
        body="Lethargy Sayon +1",hands="Malignance Gloves",ring1="Kishar Ring",ring2="Metamorph Ring +1",
        back="Sucellos's Cape",waist="Acuity Belt +1",legs="Chironic Hose",feet="Vitiation boots +3"}

    sets.midcast['Enfeebling Magic'].Acc = {main="Naegling",ammo="Regal Gem",
        head=empty, neck="Duelist's Torque",ear1="Snotra Earring", ear2="Malignance Earring",
        body="Cohort Cloak +1", hands="Malignance Gloves",ring1="Stikini Ring +1", ring2="Metamorph Ring +1",
        back=gear.mnd_cape, waist="Eschan Stone", legs="Chironic Hose", feet="Vitiation boots +3"}

    sets.midcast['Enfeebling Magic'].Duration = set_combine(sets.midcast['Enfeebling Magic'], {
        head="Lethargy Chappel +1", body="Lethargy Sayon +1", hands="Lethargy Gantherots +1", legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"
    })
    
    sets.midcast["Enfeebling Magic"].DW = set_combine(sets.midcast["Enfeebling Magic"], {sub="Tauret"})

    sets.midcast['Divine Magic'] = {neck="Incanter's Torque",ring1="Stikini Ring +1",ring2="Metamorph Ring +1"}
    sets.midcast.Cursna = set_combine(sets.midcast['Divine Magic'], {feet="Gendewitha Galoshes +1"})


    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield",back=gear.mnd_cape})
    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {main="Naegling", sub="Ammurapi Shield",back=gear.int_cape})

    sets.midcast['Poison'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Volte Cap", waist="Chaac Belt"})
    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {})

    sets.midcast["Frazzle II"] = set_combine(sets.midcast['Enfeebling Magic'].Acc, {head=empty, body="Cohort Cloak +1", back=gear.int_cape})

    sets.midcast['Elemental Magic'] = {main={ name="Grioavolr", augments={'INT+9','Mag. Acc.+7', '"Mag. Atk. Bns."+20','"Conserve MP"+7','Magic Damage+2'} },sub="Enki Strap",ammo="Regal Gem",
        head=empty,neck="Baetyl Pendant",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Cohort Cloak +1",hands="Amalric Gages +1",ring1="Jhakri Ring",ring2="Metamorph Ring +1",
        back=gear.int_cape,waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Vitiation boots +3"}
    sets.midcast['Elemental Magic'].Acc = set_combine(sets.midcast['Elemental Magic'], {head=empty,neck="Sanctity Necklace",body="Cohort Cloak +1",waist="Acuity Belt +1", ring1="Stikini Ring +1", ring2="Stikini Ring +1"})

    sets.midcast.MagicBurst = set_combine(sets.midcast['Elemental Magic'], {neck="Mizukage-no-kubikazari",ring1="Jhakri Ring", ring2="Mujin Band", feet="Jhakri Pigaches +2"})

    sets.midcast['Dark Magic'] = {main="Naegling",sub="Ammurapi Shield",ammo="Regal Gem",
        head="Malignance Chapeau",neck="Erra Pendant",ear1="Mani Earring",ear2="Malignance Earring",
        body="Carmine Scale Mail +1",hands="Malignance Gloves",ring1="Stikini ring +1",ring2="Evanescence Ring",
        back=gear.int_cape,waist="Casso Sash",legs="Malignance Tights",feet="Malignance Boots"}

    sets.midcast['Dispel'] = set_combine(sets.midcast['Enfeebling Magic'].Acc, {neck="Duelist's Torque", back=gear.int_cape})
    sets.midcast['Dispelga'] = set_combine(sets.midcast.Dispel, {main="Daybreak"})
    sets.midcast['Impact'] = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Crepuscular Cloak"})
    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {head="Pixie Hairpin +1", neck="Erra Pendant", ring1="Archon Ring", ring2="Evanescence Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.midcast.GainStat = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. gloves +3"})

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'],
        {main={ name="Grioavolr", augments={'Enh. Mag. eff. dur. +8','MND+12','Mag. Acc.+27',}}, sub="Enki Strap",
        hands="Atrophy Gloves +3",
        back="Sucellos's Cape",waist='Embla Sash',feet="Lethargy Houseaux +1"})

    sets.buff.ComposureOther = {head="Lethargy Chappel +1",
        body="Lethargy Sayon +1",hands="Atrophy Gloves +3",
        legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}

    sets.buff.Saboteur = {hands="Lethargy Gantherots +1"}


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {main="Daybreak", sub="Ammurapi Shield",ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Sanctity Necklace",
        body="Jhakri Robe +2",hands="Serpentes Cuffs",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Felicitas cape +1",waist="Fucho-no-obi",legs="Nares Trews",feet="Chelona Boots +1"}


    -- Idle sets
    sets.idle = {main="Bolelabunga",sub="Ammurapi Shield",ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Jhakri Robe +2",hands="Malignance Gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.idle_cape,waist="Fucho-No-Obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.Town = {main="Bolelabunga",sub="Ammurapi Shield",ammo="Homiliary",
        head="Shaded Spectacles",neck="Smithy's Torque",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Blacksmith's Smock",hands="Smithy's Mitts",ring1="Confectioner's Ring",ring2="Craftmaster's Ring",
        back=gear.idle_cape,waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.Weak = {main="Bolelabunga",sub="Ammurapi Shield",ammo="Homiliary",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Stikini ring +1",ring2="Defending Ring",
        back=gear.idle_cape,waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.PDT = {main="Malignance Pole",sub="Oneiros Grip",ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Stikini Ring +1",ring2="Defending Ring",
        back=gear.idle_cape,waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.MDT = sets.idle.PDT


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
    sets.offense = {main="Naegling", sub="Ammurapi Shield"}
    sets.offenseDW = {main="Naegling", sub="Thibron"}
    sets.offenseEnspell = {main="Aern Dagger", sub="Ammurapi Shield"}
    sets.offenseEnspellDW = {main="Aern Dagger", sub="Aern Dagger II"}

    sets.engaged = {ammo="Ginsen",
        head="Ayanmo Zucchetto +2",neck="Anu Torque",ear1="Sherida Earring",ear2="Telos Earring",
        body="Ayanmo Corazza +2",hands="Ayanmo Manopolas +2",ring2="Petrov Ring",ring1="Ilabrat Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Ayanmo Cosciales +2",feet="Ayanmo Gambieras +2"}

    sets.engaged.Acc = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Telos Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Jhakri Ring",ring1="Varar Ring +1",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.Enspell = set_combine(sets.engaged.Acc, {ammo="Regal Gem", 
        neck="Duelist's Torque",ear1="Crepuscular Earring",ear2="Malignance Earring",
        hands="Ayanmo Manopolas +2", ring1="Stikini Ring +1", ring2="Stikini Ring +1", 
        back="Ghostfyre Cape"})
    sets.engaged.Enspell0 = set_combine(sets.engaged.Enspell, {back=gear.melee_cape, waist="Acuity Belt +1", ear1="Crepuscular Earring"})

    sets.engaged.Defense = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Sherida Earring",ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Defending Ring",ring1="Ilabrat Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.PDT = sets.engaged.Defense
    sets.engaged.MDT = set_combine(sets.engaged.PDT, {ring2="Archon Ring"})


    sets.engaged.DW = set_combine(sets.engaged, {ear2="Suppanomimi", waist="Shetal Stone", legs="Carmine Cuisses +1"})
    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {ear2="Suppanomimi", waist="Shetal Stone", legs="Carmine Cuisses +1"})

    sets.engaged.Defense.DW = set_combine(sets.engaged.Defense, {waist="Shetal Stone", legs="Carmine Cuisses +1"})
    sets.engaged.DW.Defense = sets.engaged.Defense.DW
    sets.engaged.DW.PDT = sets.engaged.Defense.DW
    sets.engaged.DW.MDT = set_combine(sets.engaged.PDT.DW, {ring2 = "Archon Ring"})

    sets.engaged.DW.Enspell = set_combine(sets.engaged.DW.Acc, {ammo="Regal Gem", 
        head="Malignance Chapeau",neck="Duelist's Torque",ear1="Crepuscular Earring",ear2="Malignance Earring",
        body="Malignance Tabard",hands="Ayanmo Manopolas +2", ring1="Stikini Ring +1", ring2="Stikini Ring +1", 
        back=gear.int_cape, waist="Acuity Belt +1", legs="Malignance Tights"})
    sets.engaged.DW.Enspell0 = set_combine(sets.engaged.DW.Enspell, {main="Aern Dagger", sub="Aern Dagger II", ring1="Stikini Ring +1", ring2="Stikini Ring +1"})

end
