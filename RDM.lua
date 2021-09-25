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
function user_setup()

    state.OffenseMode:options('Normal', 'Acc', 'Enspell', 'Enspell0', 'Magic')
    state.HybridMode:options('Normal', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'MDT')
    
    state.MBurst = M{'None', 'Magic Burst'}

    state.OffenseMode:set('Magic')
    if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
        send_command('gs c cycle OffenseMode')
    end

    send_command('bind !` gs c cycle MBurst')
    send_command('bind != gs c set OffenseMode Magic')

    send_command('bind @numpad1 input /ma Silence <t>')
    send_command('bind @numpad4 input /ma \"Cure IV\" <t>')

    gear.default.obi_waist ="Refoccilation Stone"

    gear.int_cape = { name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+4','"Mag.Atk.Bns."+10',}}
    gear.mnd_cape = { name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20',}}
    gear.melee_cape = { name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Damage taken-5%',}}
    gear.ws_cape = { name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    
    gear.CureHands = { name="Telchine Gloves", augments={'"Cure" potency +7%', '"Regen" potency +3'}}

    enhancing_skill_magic = S{'Temper', 'Temper II', 'Aquaveil'}

    select_default_macro_book()
    
end

function user_unload()
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
        body="Atrophy Tabard +2",hands="Yaoyotl Gloves",
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

    sets.precast['Enfeebling Magic'] = set_combine(sets.precast.FC, {head="Lethargy Chappel"})
    sets.precast['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.Dispelga = set_combine(sets.precast.FC, {main="Daybreak"})
    sets.precast.Impact = set_combine(sets.precast.FC, {head="", body="Twilight Cloak"})
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})

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
        body="Vitiation Tabard +3", hands='Malignance Gloves', ring1='Apate Ring',ring2='Karieyh Ring',
        back=gear.ws_cape,waist='Fotia Gorget', legs='Malignance Tights', feet='Chironic Slippers'}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS,
        {ear1="Brutal Earring",ear2="Moonshade Earring",ring1="Aquasoul Ring",ring2="Aquasoul Ring"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Witchstone",
        head="Pixie Hairpin +1",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +1",ring1="Karieyh Ring +1",ring2="Archon Ring",
        back=gear.ws_cape,waist=gear.ElementalObi,legs="Jhakri Slops +1",feet="Vitiation boots +3"}

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS.Crit, {ammo="Yetshila +1",
    head="Ayanmo Zucchetto +2", body="Jhakri Robe +2", hands="Atrophy Gloves +3", feet="Ayanmo Gambieras +1"})

    sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS.Crit, {ring2="Begrudging Ring"})

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {ammo="Voluspa Tathlum",neck="Tjukurrpa medal", waist="Prosilio belt"})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.Acc,
        {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Tjukurrpa medal",
        body="Malignance Tabard", hands="Malignance Gloves",
        waist="Prosilio belt", legs="Malignance Tights", feet="Malignance Boots"})

    sets.precast.WS['Death Blossom'] = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.Crit, {})

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {ammo='Regal Gem',
        head="Vitiation Chapeau +3", neck="Fotia Gorget", ear1="Malignance Earring", ear2="Moonshade Earring",
        body="Vitiation Tabard +3", hands="Atrophy Gloves +3", ring1="Karieyh Ring +1", ring2="Epamonidas Ring",
        back=gear.ws_cape, waist="Fotia Gorget", legs="Vitiation Tights +2", feet="Chironic Slippers"
    })


    -- Midcast Sets
    sets.midcast.SIRD = {sub="Culminus",ammo="Impatiens",
        legs="Carmine Cuisses +1"
    }

    sets.midcast.FastRecast = { ammo="Sapience Orb",
        head="Atrophy Chapeau +2",ear1="Loquacious Earring",ear2="Malignance Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Atrophy Tights +2",feet="Vitiation boots +3"}
    sets.midcast.FC = sets.midcast.FC

    sets.midcast.Cure = {main="Daybreak",sub="Genbu's Shield",ammo="Regal Gem",
        head="Vanya Hood",neck="Phalaina locket",ear1="Roundel Earring",ear2="Malignance Earring",
        body="Gendewitha Bliaut +1",hands="Telchine Gloves",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist="Witful Belt",legs="Atrophy Tights +2",feet="Vitiation boots +3"}

    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = sets.midcast.Cure

    sets.midcast['Enhancing Magic'] = {main={ name="Grioavolr", augments={'Enh. Mag. eff. dur. +8','MND+12','Mag. Acc.+27',}},sub="Enki Strap",ammo="Regal Gem",
        head="Umuthi Hat",neck="Incanter's Torque",ear1="Andoaa Earring",ear2="Mimir Earring",
        body="Vitiation Tabard +3",hands="Vitiation Gloves +3",ring1="Kishar Ring",ring2="Prolix Ring",
        back=gear.mnd_cape,waist="Embla Sash",legs="Atrophy Tights +2",feet="Lethargy Houseaux +1"}

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'],{main="Bolelabunga",sub="Genbu's Shield",hands="Telchine Gloves"})

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'],{body="Atrophy Tabard +2",hands="Atrophy Gloves +3",legs="Lethargy Fuseau +1"})

    sets.midcast.Stoneskin = {waist="Siegel Sash"}

    --sets.midcast.ProShell = set_combine(set.midcast['Enhancing Magic'], {ring1="Sheltered Ring"})

    sets.midcast['Enfeebling Magic'] = {main="Naegling",sub="Genbu Shield",ammo="Regal Gem",
        head="Vitiation Chapeau +3",neck="Duelist's Torque",ear1="Snotra Earring",ear2="Malignance Earring",
        body="Lethargy Sayon +1",hands="Malignance Gloves",ring1="Kishar Ring",ring2="Sangoma Ring",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Chironic Hose",feet="Vitiation boots +3"}

    sets.midcast['Enfeebling Magic'].Acc = {main="Naegling",ammo="Regal Gem",
        head="Malignance Chapeau", neck="Duelist's Torque",ear1="Snotra Earring", ear2="Malignance Earring",
        body="Atrophy Tabard +2", hands="Malignance Gloves",ring1="Kishar Ring", ring2="Sangoma Ring",
        back=gear.mnd_cape, waist="Eschan Stone", legs="Chironic Hose", feet="Vitiation boots +3"}

    sets.midcast['Divine Magic'] = {}
    sets.midcast.Cursna = set_combine(sets.midcast['Divine Magic'], {feet="Gendewitha Galoshes +1"})


    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Genbu's Shield",back=gear.mnd_cape})
    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {main="Naegling", sub="Genbu's Shield",back=gear.int_cape})

    sets.midcast['Poison'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Volte Cap", waist="Chaac Belt"})
    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {})

    sets.midcast["Frazzle II"] = set_combine(sets.midcast['Enfeebling Magic'].Acc, {back=gear.int_cape})

    sets.midcast['Elemental Magic'] = {main={ name="Grioavolr", augments={'INT+9','Mag. Acc.+7', '"Mag. Atk. Bns."+20','"Conserve MP"+7','Magic Damage+2'} },sub="Enki Strap",ammo="Regal Gem",
        head="Merlinic Hood",neck="Baetyl Pendant",ear1="Friomisi Earring",ear2="Malignance Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +1",ring1="Jhakri Ring",ring2="Acumen Ring",
        back=gear.int_cape,waist=gear.ElementalObi,legs="Jhakri Slops +1",feet="Vitiation boots +3"}
    sets.midcast['Elemental Magic'].acc = set_combine(sets.midcast['Elemental Magic'], {neck="Sanctity Necklace",waist="Eschan Stone"})

    sets.midcast.MagicBurst = set_combine(sets.midcast['Elemental Magic'], {neck="Mizukage-no-kubikazari",ring1="Jhakri Ring", ring2="Mujin Band", feet="Jhakri Pigaches +2"})

    sets.midcast['Dark Magic'] = {main="Naegling",sub="Genbu's Shield",ammo="Regal Gem",
        head="Malignance Chapeau",neck="Erra Pendant",ear1="Snotra Earring",ear2="Malignance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Archon Ring",ring2="Evanescence Ring",
        back=gear.int_cape,waist=gear.ElementalObi,legs="Malignance Tights",feet="Malignance Boots"}

    sets.midcast.Dispel = set_combine(sets.midcast['Enfeebling Magic'], {neck="Duelist's Torque", ring1="Archon Ring"})
    sets.midcast.Dispelga = set_combine(sets.midcast.Dispel, {main="Daybreak"})
    sets.midcast.Impact = set_combine(sets.midcast['Dark Magic'], {head=empty,body="Twilight Cloak", waist="Eschan Stone"})
    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {head="Pixie Hairpin +1", neck="Erra Pendant", ring2="Evanescence Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.midcast.GainStat = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. gloves +3"})

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'],
        {main={ name="Grioavolr", augments={'Enh. Mag. eff. dur. +8','MND+12','Mag. Acc.+27',}}, sub="Enki Strap",
        hands="Atrophy Gloves +3",
        back="Sucellos's Cape",waist='Embla Sash',feet="Lethargy Houseaux +1"})

    sets.buff.ComposureOther = {head="Lethargy Chappel",
        body="Lethargy Sayon +1",hands="Atrophy Gloves +3",
        legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}

    sets.buff.Saboteur = {hands="Lethargy Gantherots +1"}


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {main="Daybreak", sub="Genbu's Shield",ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Sanctity Necklace",
        body="Jhakri Robe +2",hands="Serpentes Cuffs",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Felicitas cape +1",waist="Fucho-no-obi",legs="Nares Trews",feet="Chelona Boots +1"}


    -- Idle sets
    sets.idle = {main="Bolelabunga",sub="Genbu's Shield",ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Infused Earring",
        body="Jhakri Robe +2",hands="Malignance Gloves",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Felicitas Cape +1",waist="Fucho-No-Obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.Town = {main="Bolelabunga",sub="Genbu's Shield",ammo="Homiliary",
        head="Vitiation Chapeau +3",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Infused earring",
        body="Vitiation Tabard +3",hands="Atrophy Gloves +3",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.Weak = {main="Bolelabunga",sub="Genbu's Shield",ammo="Homiliary",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Infused earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Sheltered Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Malignance Boots"}

    sets.idle.PDT = {main="Malignance Pole",sub="Oneiros Grip",ammo="Homiliary",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Infused earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Defending Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.idle.MDT = sets.idle.PDT


    -- Defense sets
    sets.defense.PDT = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Eabani Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Defending Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.MDT = set_combine(sets.defense.PDT,{ring2="Archon Ring"})

    sets.Kiting = {legs="Carmine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.offense = {main="Naegling", sub="Genbu's Shield"}
    sets.offenseDW = {main="Naegling", sub="Thibron"}
    sets.offenseEnspell = {main="Aern Dagger", sub="Genbu's Shield"}
    sets.offenseEnspellDW = {main="Aern Dagger", sub="Aern Dagger II"}

    sets.engaged = {ammo="Ginsen",
        head="Ayanmo Zucchetto +2",neck="Anu Torque",ear1="Sherida Earring",ear2="Brutal Earring",
        body="Ayanmo Corazza +2",hands="Ayanmo Manopolas +2",ring2="Petrov Ring",ring1="Ilabrat Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Ayanmo Cosciales +2",feet="Ayanmo Gambieras +1"}

    sets.engaged.Acc = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Sherida Earring",ear2="Cessance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Jhakri Ring",ring1="Varar Ring +1",
        back=gear.melee_cape,waist="Shetal Stone",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.Enspell = set_combine(sets.engaged.Acc, {ammo="Regal Gem", 
        neck="Duelist's Torque",ear2="Malignance Earring",
        hands="Ayanmo Manopolas +2", ring1="Kishar Ring", ring2="Sangoma Ring", 
        back="Ghostfyre Cape"})
    sets.engaged.Enspell0 = set_combine(sets.engaged.Enspell, sets.offense.Enspell)

    sets.engaged.Defense = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Sherida Earring",ear2="Cessance Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Defending Ring",ring1="Ilabrat Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.PDT = sets.engaged.Defense
    sets.engaged.MDT = set_combine(sets.engaged.PDT, {ring2 = "Archon Ring"})


    sets.engaged.DW = set_combine(sets.engaged, {ear2="Suppanomimi", waist="Shetal Stone", legs="Carmine Cuisses +1"})
    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {ear2="Suppanomimi", waist="Shetal Stone", legs="Carmine Cuisses +1"})

    sets.engaged.Defense.DW = set_combine(sets.engaged.Defense, {ear2="Eabani Earring", waist="Shetal Stone", legs="Carmine Cuisses +1"})
    sets.engaged.DW.Defense = sets.engaged.Defense.DW
    sets.engaged.DW.PDT = sets.engaged.Defense.DW
    sets.engaged.DW.MDT = set_combine(sets.engaged.PDT.DW, {ring2 = "Archon Ring"})

    sets.engaged.DW.Enspell = set_combine(sets.engaged.DW.Acc, {ammo="Regal Gem", 
    neck="Duelist's Torque",ear2="Malignance Earring",
    hands="Ayanmo Manopolas +2", ring1="Kishar Ring", ring2="Sangoma Ring", 
    back=gear.mnd_cape, legs="Malignance Tights"})
    sets.engaged.DW.Enspell0 = set_combine(sets.engaged.DW.Enspell, sets.offense.EnspellDW)

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and state.Buff.Saboteur then
        equip(sets.buff.Saboteur)
    elseif spell.skill == 'Enhancing Magic' then
        if enhancing_skill_magic:contains(spell.english) then
            equip(sets.midcast['Enhancing Magic'])
        elseif spellMap == 'BarElement' then
            equip(sets.midcast['Enhancing Magic'])
        elseif spellMap == 'BarStatus' then
            equip(sets.midcast['Enhancing Magic'])
        elseif spellMap == 'Enspell' then
            equip(sets.midcast['Enhancing Magic'])
        elseif spellMap == 'GainStat' then
            equip(sets.midcast.GainStat)
        --elseif spellMap == 'Protect' or spellMap == 'Shell' then
        --    equip(sets.midcast.ProShell)
        else
            equip(sets.midcast.EnhancingDuration)
                if buffactive.composure and spell.target.type == 'PLAYER' then
                    equip(sets.buff.ComposureOther)
                end
        end
    elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    elseif spell_burstable:contains(spell.english) and state.MBurst.value == 'Magic Burst' then
        equip(sets.midcast.MagicBurst)
        state.MBurst:set('None')
        windower.add_to_chat(122, 'Magic Bursting. State reset')
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if state.OffenseMode.value == 'Magic' and spell.english == 'Dispelga' then
        if player.equipment.main == 'Daybreak' then return
        else
            equip(sets.precast.Dispelga)
            cast_delay(1.0)
        end
    elseif spell.english == 'Dispelga' then -- in the future, modify this so it can check if its main or offhand
        add_to_chat(122,"Not in Magic mode, cancelling.")
        eventArgs.cancel = true
    end
    
    if spell.english == 'Impact' then
        if player.equipment.body == 'Twilight Cloak' then return
        else
            equip(sets.precast.Impact)
            cast_delay(1.0)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Magic' or newValue == 'Enspell0' then
            enable('main','sub','range')
        else
            if (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
                if newValue == "Enspell0" then
                    enable('main','sub','range')
                    equip(sets.offenseEnspell)
                else
                    enable('main','sub','range')
                    equip(sets.offenseDW)
                end
            else
                enable('main','sub','range')
                equip(sets.offense)
            end
            disable('main','sub','range')
        end
    --[[elseif stateField == 'Magic Burst' then
        if state.MBurst.value then
            add_to_chat(122, 'Magic Burst enabled')
        else
            add_to_chat(122, 'Magic Burst disabled')
        end]]
    end
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
end

function update_combat_form()
    if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
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
