-- NOTE: I do not play bst, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.

-- Credit to Quetzalcoatl.Falkirk for most of the original work.

--[[
    Custom commands:
    
    Ctrl-F8 : Cycle through available pet food options.
    Alt-F8 : Cycle through correlation modes for pet attacks.
]]

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
    -- Set up Reward Modes and keybind Ctrl-F8
    state.RewardMode = M{['description']='Reward Mode', 'Theta', 'Zeta', 'Eta'}
    RewardFood = {name="Pet Food Theta"}
    send_command('bind ^f8 gs c cycle RewardMode')

    -- Set up Monster Correlation Modes and keybind Alt-F8
    state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral','Favorable'}
    send_command('bind !f8 gs c cycle CorrelationMode')
    
    -- Custom pet modes for engaged gear
    state.PetMode = M{['description']='Pet Mode', 'Normal', 'PetStance', 'PetTank'}

    -- Physical based ready skills
    ready_physical = S{'Sic','Whirl Claws','Foot Kick','Sheep Charge','Lamb Chop',
        'Head Butt','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang',
        'Nimble Snap','Cyclotail','Rhino Guard','Rhino Attack','Power Attack',
        'Mandibular Bite',
        'Big Scissors','Grapple','Spinning Top','Double Claw',
        'Frog Kick','Queasyshroom','Numbshroom','Shakeshroom','Blockhead',
        'Tail Blow','Brain Crush','1000 Needles',
        'Needleshot','Scythe Tail','Ripper Fang','Chomp Rush','Recoil Dive',
        'Sudden Lunge','Spiral Spin','Wing Slap',
        'Beak Lunge','Suction','Back Heel',
        'Tortoise Stomp',
        'Sensilla Blades','Tegmina Buffet','Swooping Frenzy','Pentapeck','Sweeping Gouge'}
    -- Magical or Magic accuracy based ready skills
    ready_magical = S{'Sheep Song','Dust Cloud','Scream','Dream Flower','Roar','Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Venom',
    'Geist Wall','Toxic Spit','Numbing Noise','Spoil','Hi-Freq Field','Sandpit','Sandblast','Venom Spray','Bubble Shower','Filamented Hold',
    'Silence Gas','Spore','Dark Spore','Fireball','Plague Breath','Infrasonics','Chaotic Eye','Blaster','Intimidate','Snow Cloud','Noisome Powder',
    'Drainkiss','Acid Mist','TP Drainkiss','Jettatura','Choke Breath','Charged Whisker','Purulent Ooze','Corrosive Ooze',
    'Aqua Breath','Molting Plumage'}
    -- Buffs and heal based ready skills
    ready_buff = S{'Harden Shell', 'Secretion', 'Rage', 'Zealous Snort', 'Water Wall', 'Metallic Body', 'Scissor Guard', 'Bubble Curtain',
    'Wild Carrot','Fantod'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Refresh', 'Reraise')
    state.PhysicalDefenseMode:options('PDT', 'Hybrid', 'Killer')

    gear.default.ElementalObi = "Eschan Stone"

    gear.PetPDThead = 'Anwig Salade'
    gear.PetPDTbody = {name="Taeon Tabard", augments={'Pet: Damage Taken -4%','Pet: Accuracy+21 Rng. Acc.+21', 'Pet: "Double Attack"+5%'}}
    gear.PetPDThands = {name="Taeon Gloves", augments={'Pet: Damage Taken -4%', 'Pet: Accuracy+20 Rng. Acc.+20', 'Pet: "Double Attack"+5%'}}
    gear.PetPDTlegs = {name="Taeon Tights", augments={'Pet: Damage Taken -4%', 'Pet: Accuracy+17 Rng. Acc.+17', 'Pet: "Double Attack"+5%'}}
    gear.PetPDTboots = {name="Taeon Boots", augments={'Pet: Damage Taken -4%', 'Pet: Accuracy+17 Rng. Acc.+17', 'Pet: "Double Attack"+5%'}}

    gear.SIRDhead = {name="Taeon Chapeau"}
    gear.SIRDbody = {name="Taeon Chapeau"}
    gear.SIRDhands = {name="Taeon Chapeau"}
    gear.SIRDlegs = {name="Taeon Chapeau"}
    gear.SIRDboots = {name="Taeon Chapeau"}

    gear.WSDayEar1 = "Brutal Earring"
    gear.WSDayEar2 = "Cessance Earring"
    gear.WSDayEar3 = "Thrud Earring"
    gear.WSNightEar1 = "Lugra Earring"
    gear.WSNightEar2 = "Lugra Earring +1"
    gear.WSNightEar3 = "Lugra Earring +1"
    gear.WSEarBrutal = {name=gear.WSDayEar1}
    gear.WSEarCessance = {name=gear.WSDayEar2}
    gear.WSEarThrud = {name=gear.WSDayEar3}

    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17*60 or myTime == 7*60) then 
            procTime(myTime)
        end
    end)

    update_combat_form()
    select_default_macro_book()
end

function isNight()
    return (world.time >= 17*60 or world.time < 7*60)
end

function procTime(myTime) 
    if isNight() then
        gear.WSEarBrutal = gear.WSNightEar1
        gear.WSEarCessance = gear.WSNightEar2
        gear.WSEarThrud = gear.WSNightEar3
    else
        gear.WSEarBrutal = gear.WSDayEar1
        gear.WSEarCessance = gear.WSDayEar2
        gear.WSEarThrud = gear.WSDayEar3
    end
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    -- Unbinds the Reward and Correlation hotkeys.
    windower.unregister_event(ticker)
    send_command('unbind ^f8')
    send_command('unbind !f8')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    sets.precast.JA['Killer Instinct'] = {head="Ankusa Helm +1"}
    sets.precast.JA['Feral Howl'] = {body="Ankusa Jackcoat +1"}
    sets.precast.JA['Call Beast'] = {hands="Ankusa Gloves +1", body="Mirke Wardecors"}
    sets.precast.JA['Bestial Loyalty'] = sets.precast.JA['Call Beast']
    sets.precast.JA['Familiar'] = {legs="Ankusa Trousers +1"}
    sets.precast.JA['Tame'] = {head="Totemic Helm +1",ear1="Tamer's Earring",legs="Stout Kecks"}
    sets.precast.JA['Spur'] = {feet="Nukumi Ocreae"}

    sets.precast.JA['Reward'] = {ammo=RewardFood,
        head="Ankusa Helm +1",neck="Phaliana Locket",ear1="Lifestorm Earring",ear2="Pratik Earring",
        body="Totemic Jackcoat +1",hands="Malignance Gloves",ring1="Aquasoul Ring",ring2="Aquasoul Ring",
        back="Artio's Mantle",waist="Crudelis Belt",legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    sets.precast.JA['Charm'] = {ammo="Voluspa Tathlum",
        head="Totemic Helm +1",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Handler's Earring +1",
        body="Ankusa Jackcoat +1",hands="Ankusa Gloves +1",ring1="Balrahn's Ring",ring2="Sangoma Ring",
        back="Aisance Mantle +1",waist="Eschan Stone",legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    -- CURING WALTZ
    sets.precast.Waltz = {ammo="Voluspa Tathlum",
        head="Totemic Helm +1",neck="Phalaina Locket",ear1="",ear2="Handler's Earring +1",
        body="Ankusa Jackcoat +1",hands="Totemic Gloves +1",ring1="Ilabrat Ring",ring2="Asklepian Ring",
        back="Aisance Mantle +1",waist="Chaac Belt",legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    -- HEALING WALTZ
    sets.precast.Waltz['Healing Waltz'] = {}

    -- STEPS
    sets.precast.Step = {ammo="Jukukik Feather",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Zwazo Earring",ear2="Cessance Earring",
        body="Mikinaak Breastplate",hands="Malignance Gloves",ring1="Ilabrat Ring",ring2="Apate Ring",
        back="Letalis Mantle",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}

    -- VIOLENT FLOURISH
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {body="Ankusa Jackcoat +1"}

    sets.precast.FC = {ammo="Impatiens",neck="Orunmila's Torque",ear1="Loquacious Earring",ring1="Prolix Ring"}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Bead Necklace"})

    -- WEAPONSKILLS
    -- Default weaponskill set.
    sets.precast.WS = {ammo="Voluspa Tathlum",
        head="Meghanada Visor +1",neck="Fotia Gorget",ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Malignance Tabard",hands="Meghanada Gloves +2",ring2="Regal Ring",ring1="Karieyh Ring +1",
        back="Atheling Mantle",waist="Fotia Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.precast.WS.WSAcc = {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Fotia Gorget",ear1="Zwazo Earring",ear2="Moonshade Earring",
        body="Malignance Tabard",hands="Meghanada Gloves +2",ring2="Regal Ring",ring1="Karieyh Ring +1",
        back="Atheling Mantle",waist="Fotia Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.precast.WS.WSCrit = {ammo="Voluspa Tathlum",
        head="Meghanada visor +1", neck="Fotia Gorget",ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Meghanada cuirie +1", hands="Meghanada Gloves +2",ring2="Regal Ring",ring1="Begrudging Ring",
        back="Atheling Mantle",waist="Fotia Belt",legs="Meghanada Chausses +1",feet="Meghanada Jambeaux +1"}

    sets.precast.WS.MultiHit = {ammo="Voluspa Tathlum",
        head="Meghanada Visor +1", neck="Fotia Gorget", ear1="Sherida Earring", ear2="Moonshade Earring",
        body="Meghanada Cuirie +1", hands="Meghanada Gloves +2",ring1="Epona's Ring",ring2="Regal Ring",
        back="Atheling Mantle", waist="Fotia Belt", legs="Meghanada Chausses +1", feet="Meghanada Jambeaux +1"}

    -- Specific weaponskill sets.
    -- Axes
    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})
    sets.precast.WS['Mistral Axe'].Acc = set_combine(sets.precast.WS.WSAcc, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})

    sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})
    sets.precast.WS['Calamity'].Acc = set_combine(sets.precast.WS.WSAcc, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})

    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS.WSCrit, {ear1=gear.WSEarThrud, ear2=gear.WSEarBrutal})
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS.MultiHit, {ear1=gear.WSEarThrud,ear2=gear.WSEarBrutal})
    sets.precast.WS['Ruinator'].Acc = set_combine(sets.precast.WS.WSAcc, {ear1=gear.WSEarThrud,ear2=gear.WSEarBrutal})

    sets.precast.WS['Onslaught'] = set_combine(sets.precast.WS, {ear2=gear.WSEarBrutal,ring1="Rajas Ring"})
    sets.precast.WS['Onslaught'].Acc = set_combine(sets.precast.WSAcc, {ring1="Rajas Ring"})

    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS.MultiHit, {ear2=gear.WSEarBrutal})
    sets.precast.WS['Decimation'].Acc = set_combine(sets.precast.WS.MultiHit, {ear2=gear.WSEarBrutal})

    sets.precast.WS['Primal Rend'] = {ammo="Pemphredo Tathlum",
        head="Ankusa Helm +1",neck="Sanctity Necklace",ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Samnuha Coat",hands="Meghanada gloves +2",ring1="Regal Ring",ring2="Karieyh Ring +1",
        back="Argocham. Mantle",waist=gear.ElementalObi,legs="Limbo Trousers",feet="Malignance Boots"}

    sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS['Primal Rend'], {})

    -- Sword
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.WSAcc, {})

    -- Dagger
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.WSCrit, {})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS.WSAcc, {})

    -- Scythe
    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS.WSAcc, {neck="Tjukurrpa Medal", waist="Sailfi Belt +1"})

    
    --------------------------------------
    -- Midcast sets
    --------------------------------------
    
    sets.midcast.FastRecast = {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Loquacious Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Prolix Ring",ring2="Defending Ring",
        waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}

    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {neck="Magoraga Bead Necklace"})


    -- PET SIC & READY MOVES
    sets.midcast.Pet.WS = {ammo="Voluspa Tathlum",
        head="Totemic Helm +1",neck="Shulmanu Collar",ear1="Domesticator's Earring",ear2="Enmerkar Earring",
        body="Ankusa Jackcoat +1",hands="Nukumi Manoplas",ring1="Varar Ring +1",ring2="Varar Ring +1",
        back="Artio's Mantle",waist="Hurch'lan Sash",legs="Totemic Trousers +1",feet="Totemic Gaiters +1"}
    
    sets.midcast.Pet.WSMagical = set_combine(sets.midcast.Pet.Physical,{neck="Adad Necklace"})

    sets.midcast.Pet.WSBuff = set_combine(sets.midcast.Pet.WS.Magical,{})

    sets.midcast.Pet.WS.Unleash = set_combine(sets.midcast.Pet.WS, {hands="Scorpion Mittens"})

    sets.midcast.Pet.Neutral = {}
    sets.midcast.Pet.Favorable = {head="Nukumi Cabasset"}


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- RESTING
    sets.resting = {ammo="Voluspa Tathlum",
        head="Twilight Helm",neck="Sanctity Necklace",ear1="Domesticator's Earring",ear2="Enmerkar Earring",
        body="Twilight Mail",hands="Totemic Gloves +1",ring1="Defending Ring",ring2="Sheltered Ring",
        back="Pastoralist's Mantle",waist="Muscle Belt +1",legs="Nukumi Quijotes",feet="Skadi's Jambeaux +1"}

    -- IDLE SETS
    sets.idle = {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Hearty Earring",ear2="Infused Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Sheltered Ring",
        back="Pastoralist's Mantle",waist="Muscle Belt +1",legs="Malignance Tights",feet="Skadi's Jambeaux +1"}

    sets.idle.Town = sets.idle

    sets.idle.Refresh = {head="Wivre Hairpin",body="Twilight Mail",hands="Ogier's Gauntlets",legs="Ogier's Breeches"}

    sets.idle.Reraise = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})

    sets.idle.Pet = set_combine(sets.idle, {ear2="Enmerkar Earring"})

    sets.idle.Pet.Engaged = {ammo="Voluspa Tathlum",
        head="Ankusa Helm +1",neck="Shulmanu Collar",ear1="Rimeice Earring",ear2="Enmerkar Earring",
        body="Ankusa Jackcoat +1",hands="Totemic Gloves +1",ring1="Varar Ring +1",ring2="Varar Ring +1",
        back="Artio's Mantle",waist="Hurch'lan Sash",legs="Ankusa Trousers +1",feet="Taeon Boots"}

    sets.idle.Pet.PetTank = set_combine(sets.idle.Pet.Engaged,{
        head="Anwig Salade",neck="Shepherd's Chain",ear1="Handler's Earring +1",
        body="Taeon Tabard", hands="Taeon Gloves", 
        legs="Taeon Tights", feet="Taeon Boots"})

    -- DEFENSE SETS
    sets.defense.PDT = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Loricate Torque +1", ear1="Eabani Earring", ear2="Hearty Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Epona's Ring",ring1="Defending Ring",
        back="Mollusca Mantle",waist="Flume Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.Hybrid = set_combine(sets.defense.PDT, {waist="Hurch'lan Sash"})

    sets.defense.Killer = set_combine(sets.defense.Hybrid, {body="Nukumi Gausape"})

    sets.defense.MDT = set_combine(sets.defense.PDT, {
        ear1="Eabani Earring",ear2=gear.WSEarCessance,
        ring1="Archon Ring"})

    sets.Kiting = set_combine(sets.defense.PDT,{feet="Skadi's Jambeaux +1"})


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    sets.engaged = {ammo="Ginsen",
        head="Meghanada Visor +1",neck="Shulmanu Collar",ear1="Sherida Earring",ear2="Suppanomimi",
        body="Meghanada Cuirie +1",hands="Meghanada Gloves +2",ring1="Epona's Ring",ring2="Petrov Ring",
        back="Atheling Mantle",waist="Shetal Stone",legs="Meghanada chausses +1",feet="Meghanada Jambeaux +1"}

    sets.engaged.Acc = {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Shulmanu Collar",ear1="Sherida Earring",ear2="Suppanomimi",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Epona's Ring",ring2="Regal Ring",
        back="Atheling Mantle",waist="Hurch'lan Sash",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.PDT = {ammo="Voluspa Tathlum",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Sherida Earring", ear2="Suppanomimi",
        body="Malignance Tabard", hands="Malignance Gloves", ring1="Epona's Ring", ring2="Defending Ring",
        back="Atheling Mantle", waist="Hurch'lan Sash", legs="Malignance Tights", feet="Malignance Boots"}

    sets.engaged.Killer = set_combine(sets.engaged, {head="Ankusa Helm +1",body="Nukumi Gausape", legs="Totemic Trousers +1"})
    sets.engaged.Killer.Acc = set_combine(sets.engaged.Acc, {body="Nukumi Gausape"})
    
    
    -- EXAMPLE SETS WITH PET MODES
    --[[
    sets.engaged.PetStance = {}
    sets.engaged.PetStance.Acc = {}
    sets.engaged.PetTank = {}
    sets.engaged.PetTank.Acc = {}
    sets.engaged.PetStance.Killer = {}
    sets.engaged.PetStance.Killer.Acc = {}
    sets.engaged.PetTank.Killer = {}
    sets.engaged.PetTank.Killer.Acc = {}
    ]]
    -- MORE EXAMPLE SETS WITH EXPANDED COMBAT FORMS
    --[[
    sets.engaged.DW.PetStance = {}
    sets.engaged.DW.PetStance.Acc = {}
    sets.engaged.DW.PetTank = {}
    sets.engaged.DW.PetTank.Acc = {}
    sets.engaged.KillerDW.PetStance = {}
    sets.engaged.KillerDW.PetStance.Acc = {}
    sets.engaged.KillerDW.PetTank= {}
    sets.engaged.KillerDW.PetTank.Acc = {}
    ]]
    
    sets.engaged.PetStance = set_combine(sets.engaged,{waist="Hurch'lan Sash"})
    sets.engaged.PetStance.Acc = set_combine(sets.engaged.Acc,{})
    sets.engaged.PetStance.PDT = set_combine(sets.engaged.PDT,{})
    sets.engaged.PetTank = set_combine(sets.engaged.PDT,{head="Anwig Salade", ear1="Handler's Earring +1", ear2="Enmerkar Earring", body="Taeon Tabard", hands="Taeon Gloves", legs="Taeon Tights", feet="Taeon Boots"})
    sets.engaged.PetTank.Acc = set_combine(sets.engaged.Acc,{ear1="Handler's Earring +1", body="Taeon Tabard", hands="Taeon Gloves", legs="Taeon Tights", feet="Taeon Boots"})
    sets.engaged.PetStance.Killer = set_combine(sets.engaged,{})
    sets.engaged.PetStance.Killer.Acc = set_combine(sets.engaged,{})
    sets.engaged.PetTank.Killer = set_combine(sets.engaged,{})
    sets.engaged.PetTank.Killer.Acc = set_combine(sets.engaged,{})

    --sets.engaged.DW.PetStance = sets.engaged
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff['Killer Instinct'] = {head="Ankusa Helm +1",body="Nukumi Gausape", legs="Totemic Trousers +1"}
    
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    -- Define class for Sic and Ready moves.
    if ready_physical:contains(spell.english) and pet.status == 'Engaged' then
        classes.CustomClass = "WS"
    elseif ready_magical:contains(spell.english) and pet.status == 'Engaged' then
        classes.CustomClass = "WSMagical"
    elseif ready_buff:contains(spell.english) and pet.status == 'Engaged' then
        classes.CustomClass = "WSBuff"
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- If Killer Instinct is active during WS, equip Ferine Gausape +2.
    if spell.type:lower() == 'weaponskill' and buffactive['Killer Instinct'] then
        equip(sets.buff['Killer Instinct'])
    end
end


function job_pet_post_midcast(spell, action, spellMap, eventArgs)
    -- Equip monster correlation gear, as appropriate
    equip(sets.midcast.Pet[state.CorrelationMode.value])
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
    if buff == 'Killer Instinct' then
        update_combat_form()
        handle_equipping_gear(player.status)
    end
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Reward Mode' then
        -- Theta, Zeta or Eta
        RewardFood.name = "Pet Food " .. newValue
    elseif stateField == 'Pet Mode' then
        state.CombatWeapon:set(newValue)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    if defaut_wsmode == 'Normal' then
--[[        if spell.english == "Ruinator" and (world.day_element == 'Water' or world.day_element == 'Wind' or world.day_element == 'Ice') then
            return 'Mekira'
        end
    end]]
    end
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
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
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', Reward: '..state.RewardMode.value..', Correlation: '..state.CorrelationMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    procTime(world.time)
    if buffactive['Killer Instinct'] then
        if (player.sub_job == 'NIN' or player.sub_job == 'DNC') and player.equipment.sub:endswith('Axe') then
            state.CombatForm:set('KillerDW')
        else
            state.CombatForm:set('Killer')
        end
    elseif (player.sub_job == 'NIN' or player.sub_job == 'DNC') and player.equipment.sub:endswith('Axe') then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    send_command( "@wait 5;input /lockstyleset 3" )
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'SAM' then
        set_macro_page(1, 9)
    elseif player.sub_job == 'WHM' then
        set_macro_page(1, 9)
    elseif player.sub_job == 'DNC' then
        set_macro_page(1, 9)
    else 
        set_macro_page(1, 9)
    end
end