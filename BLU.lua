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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false


    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S { 35, 204 }
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S { 201, 202, 203, 205, 207 }

    include('Mote-TreasureHunter')
    include('Augments.lua')
    include('natty_helper_functions.lua')
    include('default_sets.lua')

    blue_magic_maps = {}

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical Spells --

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S {
        'Bilgestorm', 'Saurian Slide'
    }

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S {
        'Heavy Strike',
    }

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S {
        'Battle Dance', 'Bloodrake', 'Death Scissors', 'Dimensional Death',
        'Empty Thrash', 'Quadrastrike', 'Sinker Drill', 'Spinal Cleave',
        'Uppercut', 'Vertical Cleave'
    }

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S {
        'Amorphic Spikes', 'Asuran Claws', 'Barbed Crescent', 'Claw Cyclone', 'Disseverment',
        'Foot Kick', 'Frenetic Rip', 'Goblin Rush', 'Hysteric Barrage', 'Paralyzing Triad',
        'Seedspray', 'Sickle Slash', 'Smite of Rage', 'Terror Touch', 'Thrashing Assault',
        'Vanity Dive'
    }

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S {
        'Body Slam', 'Cannonball', 'Delta Thrust', 'Glutinous Dart', 'Grand Slam',
        'Power Attack', 'Quad. Continuum', 'Sprout Smack', 'Sub-zero Smash'
    }

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S {
        'Benthic Typhoon', 'Feather Storm', 'Helldive', 'Hydro Shot', 'Jet Stream',
        'Pinecone Bomb', 'Spiral Spin', 'Wild Oats'
    }

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S {
        'Mandibular Bite', 'Queasyshroom'
    }

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S {
        'Ram Charge', 'Screwdriver', 'Tourbillion'
    }

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S {
        'Bludgeon'
    }

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S {
        'Final Sting'
    }

    -- Magical Spells --

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S {
        'Blastbomb', 'Blazing Bound', 'Bomb Toss', 'Cursed Sphere', 'Dark Orb', 'Death Ray',
        'Diffusion Ray', 'Droning Whirlwind', 'Embalming Earth', 'Firespit', 'Foul Waters',
        'Ice Break', 'Leafstorm', 'Maelstrom', 'Rail Cannon', 'Regurgitation', 'Rending Deluge',
        'Retinal Glare', 'Subduction', 'Tem. Upheaval', 'Water Bomb',
        'Entomb', 'Silent Storm', 'Anvil Lightning', 'Spectral Floe',
        'Scouring Spate', 'Blinding Fulgor', 'Searing Tempest', 'Cesspool', 'Tearing Gust'

    }

    blue_magic_maps.MagicalDarkness = S {
        'Tenebral Crush', 'Palling Salvo', 'Atra. Libations', 'Dark Orb',
        'Everyone\'s Grudge', 'Osmosis', 'Eyes On Me', 'Blood Saber',
        'MP Drainkiss', 'Digest', 'Death Ray', 'Blood Drain'
    }

    blue_magic_maps.MagicalLight = S {
        'Blinding Fulgor', 'Diffusion Ray', 'Rail Cannon', 'Retinal Glare', 'Radiant Breath', 'Magic Hammer'
    }

    -- blue_magic_maps.MagicalWind = S {

    -- }

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S {
        'Acrid Stream', 'Evryone. Grudge', 'Magic Hammer', 'Mind Blast'
    }

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S {
        'Eyes On Me', 'Mysterious Light'
    }

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S {
        'Thermal Pulse'
    }

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S {
        'Charged Whisker', 'Gates of Hades'
    }

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S {
        '1000 Needles', 'Absolute Terror', 'Actinic Burst', 'Auroral Drape', 'Awful Eye',
        'Blank Gaze', 'Blistering Roar', 'Blood Drain', 'Blood Saber', 'Chaotic Eye',
        'Cimicine Discharge', 'Cold Wave', 'Corrosive Ooze', 'Demoralizing Roar', 'Digest',
        'Dream Flower', 'Enervation', 'Feather Tickle', 'Filamented Hold', 'Frightful Roar',
        'Geist Wall', 'Hecatomb Wave', 'Infrasonics', 'Jettatura', 'Light of Penance',
        'Lowing', 'Mind Blast', 'Mortal Ray', 'MP Drainkiss', 'Osmosis', 'Reaving Wind',
        'Sandspin', 'Sandspray', 'Sheep Song', 'Soporific', 'Sound Blast', 'Stinking Gas',
        'Sub-zero Smash', 'Venom Shell', 'Voracious Trunk', 'Yawn', 'Cruel Joke',
    }

    -- Breath-based spells
    blue_magic_maps.Breath = S {
        'Bad Breath', 'Flying Hip Press', 'Frost Breath', 'Heat Breath',
        'Hecatomb Wave', 'Magnetite Cloud', 'Poison Breath', 'Radiant Breath', 'Self-Destruct',
        'Thunder Breath', 'Vapor Spray', 'Wind Breath'
    }

    -- Stun spells
    blue_magic_maps.Stun = S {
        'Blitzstrahl', 'Frypan', 'Head Butt', 'Sudden Lunge', 'Tail slap', 'Temporal Shift',
        'Thunderbolt', 'Whirl of Rage'
    }

    -- Healing spells
    blue_magic_maps.Healing = S {
        'Healing Breeze', 'Magic Fruit', 'Plenilune Embrace', 'Pollen', 'Restoral', 'White Wind',
        'Wild Carrot'
    }

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S {
        'Barrier Tusk', 'Diamondhide', 'Magic Barrier', 'Metallic Body', 'Plasma Charge',
        'Pyric Bulwark', 'Reactor Cool',
    }

    -- Other general buffs
    blue_magic_maps.Buff = S {
        'Amplification', 'Animating Wail', 'Battery Charge', 'Carcharian Verve', 'Cocoon',
        'Erratic Flutter', 'Exuviation', 'Fantod', 'Feather Barrier', 'Harden Shell',
        'Memento Mori', 'Nat. Meditation', 'Occultation', 'Orcish Counterstance', 'Refueling',
        'Regeneration', 'Saline Coat', 'Triumphant Roar', 'Warm-Up', 'Winds of Promyvion',
        'Zephyr Mantle'
    }


    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S {
        'Absolute Terror', 'Bilgestorm', 'Blistering Roar', 'Bloodrake', 'Carcharian Verve',
        'Crashing Thunder', 'Droning Whirlwind', 'Gates of Hades', 'Harden Shell', 'Polar Roar',
        'Pyric Bulwark', 'Thunderbolt', 'Tourbillion', 'Uproot', 'Mighty Guard', 'Cruel Joke',
        'Cesspool', 'Tearing Gust'
    }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('default_sets.lua')

    state.OffenseMode:options('Normal', 'Acc', 'PDT', 'Crit')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh', 'Regen')
    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    gear.default.obi_waist = "Sacro Cord"
    gear.default.drain_waist = "Fucho-no-Obi"
    gear.default.cure_waist = "Shinjutsu-no-obi +1"

    -- Additional local binds
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')



    send_command('bind numpad7 gs equip sets.weapons.Naegling')
    send_command('bind numpad8 gs equip sets.weapons.magicatk')

    send_command('bind numpad1 input /ma "Sudden Lunge" <t>')
    send_command('bind numpad3 input /ma "Cruel Joke" <t>')

    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^- gs c cycle DoomMode')
    send_command('bind numpad0 gs equip sets.resist.death')

    update_combat_form()
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
end

-- Set up gear sets.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    sets.weapons = {}
    sets.weapons.Naegling = { main = "Naegling", sub = "Thibron" }
    sets.weapons.magicatk = { main = "Maxentius", sub = "Bunzi's Rod" }

    gear.default.obi_waist = "Acuity Belt +1"

    sets.buff['Burst Affinity'] = { feet = "Mavi Basmak +2" }
    sets.buff['Chain Affinity'] = { head = "Mavi Kavuk +2", feet = "Assimilator's Charuqs" }
    sets.buff.Convergence = { head = "Luhlaza Keffiyeh" }
    sets.buff.Diffusion = { feet = "Luhlaza Charuqs" }
    sets.buff.Enchainment = { body = "Luhlaza Jubbah" }
    sets.buff.Efflux = { legs = "Mavi Tayt +2" }

    sets.buff.doom = {
        ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau",
        neck = "Nicander's Necklace",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.buff.doom.HolyWater = {
        ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau",
        neck = "Nicander's Necklace",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1",
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots",
    }

    sets.resist = {}
    sets.resist.death = {
        body = "Samnuha Coat", ring1 = "Shadow Ring", ring2 = "Eihwaz Ring"
    }

    -- Precast Sets
    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Halitus Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Trux Earring",
        ear2 = "Cryptic Earring",
        body = "Emet Harness +1",
        ring1 = "Supershear Ring",
        ring2 = "Eihwaz Ring",
        waist = "Trance Belt",
        legs = "Zoar Subligar +1"
    }

    sets.SIRD = {
        ammo = "Staunch Tathlum +1", -- 11
        head = gear.taeon.SIRD.head, -- 10
        neck = "Loricate Torque +1", -- 5
        ear1 = "Hasalz Earring",     -- 5
        ear2 = "Magnetic Earring",   -- 8
        hands = "Amalric Gages +1",  -- 11
        ring1 = "Evanescence Ring",  -- 5
        ring2 = gear.dark_ring.SIRD, -- 4
        waist = "Emphatikos Rope",   -- 12
        legs = "Carmine Cuisses +1", -- 20
        feet = "Amalric Nails +1"    -- 16
    }

    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = { hands = "Mirage Bazubands +2" }

    sets.precast.RA = {
        range = "Albin Bane",
        body = "Volte Harness",
        ring1 = "Crepuscular Ring",
        legs = "Adhemar Kecks +1",
    }
    sets.midcast.RA = { range = "Albin Bane" }


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo = "Sonia's Plectrum",
        head = "Uk'uxkaj Cap",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Spiral Ring",
        back = "Iximulew Cape",
        waist = "Caudata Belt",
        legs = "Gleti's Cuisses",
        feet = "Iuitl Gaiters +1"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.FC = {
        ammo = "Sapience Orb",
        head = "Carmine Mask +1",
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1",
        hands = "Leyline Gloves",
        ring1 = "Lebeche Ring",
        ring2 = "Kishar Ring",
        back = "Fi Follet Cape +1",
        legs = "Enif Cosciales",
        feet = "Carmine Greaves +1"
    }
    sets.precast.FC.Weapon = {
        -- main = "Sakpata's Sword",
        -- sub = "Colada",
        -- ammo = "Impatiens",
        -- ring1 = "Lebeche Ring",
        -- back = "Perimede cape"
    }
    -- sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, { body = "Mavi Mintan +2" })
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, { waist = "Siegel Sash" })


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Brutal Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Sroda Ring",
        back = "Cornflower Cape",
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS.Acc = set_combine(sets.precast.WS,
        {
            head = "Malignance Chapeau",
            ear1 = "Crepuscular Earring",
            body = "Malignance Tabard",
            hands = "Malignance Gloves",
            legs = "Malignance Tights",
            feet = "Malignance Boots"
        })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, { ring1 = "Epona's Ring", feet = "Luhlaza Charuqs" })

    sets.precast.WS['Sanguine Blade'] = {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Regal Earring",
        body = "Amalric Doublet +1",
        hands = "Nyame Gauntlets",
        ring1 = "Metamorph Ring +1",
        ring2 = "Archon Ring",
        back = "Cornflower Cape",
        waist = gear.ElementalObi,
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1"
    }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum medal",
        ear1 = "Ishvara Earring",
        waist = "Sailfi Belt +1"
    })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head = "Blistering Sallet +1",
        ear2 = "Odr Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring2 = "Begrudging Ring",
        ring1 = "Apate Ring",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots"
    })

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
        ear1 = "Regal Earring",
        ring2 = "Metamorph Ring +1"
    })

    sets.midcast.Diaga = sets.TreasureHunter

    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Carmine Mask +1",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1",
        hands = "Leyline Gloves",
        ring1 = "Kishar Ring",
        ring2 = "Medada's ring",
        back = "Fi Follet Cape +1",
        waist = "Witful Belt",
        legs = "Enif Cosciales",
        feet = "Carmine Greaves +1"
    }

    sets.midcast['Blue Magic'] = {
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Regal Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Jhakri Ring",
        ring2 = gear.right_stikini,
        back = "Felicitas cape +1",
        waist = gear.ElementalObi,
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- Physical Spells --

    sets.midcast['Blue Magic'].Physical = {
        ammo = "Coiste Bodhar",
        head = "Adhemar Bonnet +1",
        neck = "Republican Platinum Medal",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Adhemar Gloves +1",
        ring1 = gear.left_chirich,
        ring2 = "Epona's Ring",
        back = "Cornflower Cape",
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.midcast['Blue Magic'].PhysicalAcc = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_chirich,
        ring2 = "Varar Ring +1",
        back = "Cornflower Cape",
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical)

    sets.midcast['Battery Charge'] = { head = "Amalric Coif +1", back = "Grapevine Cape", waist = "Gishdubar Sash", }


    -- Magical Spells --

    sets.midcast['Blue Magic'].Magical = {
        main = "Maxentius",
        sub = "Bunzi's Rod",
        ammo = "Ghastly Tathlum +1",
        head = empty,
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Regal Earring",
        body = "Cohort Cloak +1",
        hands = "Amalric Gages +1",
        ring1 = "Medada's ring",
        ring2 = "Metamorph Ring +1",
        back = "Aurist's Cape +1",
        waist = gear.ElementalObi,
        legs = "Amalric Slops +1",
        feet = "Amalric Nails +1"
    }

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical,
        { ring1 = gear.left_stikini, ring2 = "Metamorph Ring +1" })

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,
        {})

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical,
        { ring1 = "Gelatinous Ring +1" })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        -- ear1 = "Odr Earring"
    })

    sets.midcast['Blue Magic'].MagicalDarkness = set_combine(sets.midcast['Blue Magic'].Magical,
        { head = "Pixie Hairpin +1", body = "Amalric Doublet +1", ring2 = "Archon Ring" })

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical,
        {})

    sets.midcast['Blue Magic'].MagicAccuracy = {
        ammo = "Pemphredo Tathlum",
        head = "Malignance Chapeau",
        neck = "Erra Pendant",
        ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring2 = "Metamorph Ring +1",
        ring1 = "Medada's Ring",
        back = "Aurist's Cape +1",
        waist = "Acuity Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots",
    }

    -- Breath Spells --

    sets.midcast['Blue Magic'].Breath = {
        ammo = "Happy Egg",
        head = "Nyame Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Eihwaz Ring",
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    -- Other Types --

    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy)

    sets.midcast['Blue Magic']['White Wind'] = {
        head = "Adhemar Bonnet +1",
        neck = "Lavalier +1",
        ear1 = "Etiolation Earring",
        ear2 = "Loquacious Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "K'ayres Ring",
        ring2 = "Meridian Ring",
        back = "Fravashi Mantle",
        waist = "Sailfi Belt +1",
        legs = "Enif Cosciales",
        feet = "Gleti's Boots"
    }

    sets.midcast['Blue Magic'].Healing = {
        main = "Bunzi's Rod",
        ammo = "Staunch Tathlum +1",
        head = gear.telchine.regen.head,
        neck = "Nodens Gorget",
        ear1 = "Beatific Earring",
        ear2 = "Meili Earring",
        body = "Amalric Doublet +1",
        hands = "Telchine gloves",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Oretan. Cape +1",
        waist = gear.CureWaist,
        legs = "Carmine Cuisses +1",
        feet = "Amalric Nails +1"
    }

    sets.midcast['Regeneration'] = set_combine(sets.midcast['Blue Magic'].Healing, {
        main = "Bolelabunga",
        head = gear.telchine.regen.head,
        body = gear.telchine.regen.body,
        hands = gear.telchine.regen.hands,
        legs = gear.telchine.regen.legs,
        feet = gear.telchine.regen.feet
    })

    sets.midcast['Blue Magic'].SkillBasedBuff = {
        ammo = "Mavi Tathlum",
        head = "Luhlaza Keffiyeh",
        body = "Assimilator's Jubbah +1",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Cornflower Cape",
        legs = "Mavi Tayt +2",
        feet = "Luhlaza Charuqs"
    }

    sets.midcast['Blue Magic'].Buff = {}
    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'], sets.SIRD)

    sets.midcast['Enhancing Magic'] = {
        main = "Pukulatmuj +1",
        head = "Carmine Mask +1",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Mimir Earring",
        body = "Telchine Chasuble",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        back = "Fi Follet Cape +1",
        waist = "Olympus Sash",
        legs = "Carmine Cuisses +1"
    }

    sets.midcast['Enhancing Magic'].Duration = set_combine(sets.midcast['Enhancing Magic'], {
        main = gear.colada.enh_dur,
        head = gear.telchine.enh_dur.head,
        body = gear.telchine.enh_dur.body,
        hands = gear.telchine.enh_dur.hands,
        legs = gear.telchine.enh_dur.legs,
        feet = gear.telchine.enh_dur.feet
    })

    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'],
        {
            main = "Sakpata's Sword",
            sub = "Pukulatmuj +1",
            head = gear.taeon.phalanx.head,
            body = gear.herculean.phalanx.body,
            hands = gear.herculean.phalanx.hands,
            waist = "Embla Sash",
            legs = gear.herculean.phalanx.legs,
            feet = gear.herculean.phalanx.feet,
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, sets.SIRD,
        { body = gear.taeon.SIRD.body, waist = "Emphatikos Rope", legs = "Shedir Seraweels", })



    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        ear1 = "Earthcry Earring",
        waist = "Siegel Sash",
        legs = "Shedir Seraweels",
    })

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        head = gear.telchine.regen.head,
        body = gear.telchine.regen.body,
        hands = gear.telchine.regen.hands,
        legs = gear.telchine.regen.legs,
        feet = gear.telchine.regen.feet
    })

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        head = "Amalric Coif +1"
    })

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'].Duration, { ear1 = "Brachyura Earring" })
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    -- sets.midcast['Enfeebling Magic'].Diaga = sets.TreasureHunter
    -- sets.midcast.Diaga = sets.midcast['Enfeebling Magic'].Diaga
    sets.midcast.Diaga = sets.TreasureHunter
    sets.midcast.Dia = sets.midcast.Diaga



    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.Learning = { ammo = "Mavi Tathlum", hands = "Assimilator's Bazubands +1" }
    --head="Luhlaza Keffiyeh",
    --body="Assimilator's Jubbah +1",hands="Assimilator's Bazubands +1",
    --back="Cornflower Cape",legs="Mavi Tayt +2",feet="Luhlaza Charuqs"}


    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Resting sets
    sets.resting = {
        head = "Malignance Tabard",
        neck = "Bathy Choker +1",
        body = "Jhakri Robe +2",
        hands = "Malignance Gloves",
        ring1 = gear.left_stikini,
        ring2 = "Defending Ring",
        waist = "Austerity Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- Idle sets
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Bathy Choker +1",
        ear1 = "Etiolation Earring",
        ear2 = "Infused Earring",
        body = "Jhakri Robe +2",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_stikini,
        ring2 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Fucho-no-obi",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa earring +1",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring2 = "Gelatinous Ring +1",
        ring1 = "Shneddick Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Regen = set_combine(sets.idle, {
        neck = "Bathy Choker +1",
        ear2 = "Infused Earring",
        ring1 = "Paguroidea Ring",
        ring2 = gear.right_chirich
    })

    sets.idle.Town = {
        ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles",
        neck = "Smithy's Torque",
        ear1 = "Infused Earring",
        ear2 = "Etiolation Earring",
        body = "Blksmith. Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = "Nyame Sollerets"
    }

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    sets.idle.Refresh = set_combine(sets.idle, {
        neck = "Sibyl Scarf",
        body = "Jhakri Robe +2",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Fucho-no-obi",
        -- legs = "Lengo pants"
    })


    -- Defense sets
    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Odnowa Earring +1",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Paguroidea Ring",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = set_combine(sets.defense.PDT,
        { ear2 = "Eabani Earring", ring1 = "Archon Ring", waist = "Platinum Moogle Belt", })

    sets.Kiting = { legs = "Carmine Cuisses +1" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Gleti's Cuirass",
        hands = "Adhemar Wristbands +1",
        ring1 = gear.left_chirich,
        ring2 = "Epona's Ring",
        back = "Cornflower Cape",
        waist = "Sailfi Belt +1",
        legs = "Samnuha Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.Acc = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Brutal Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_chirich,
        ring2 = "Epona's Ring",
        back = "Cornflower Cape",
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.PDT = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Loricate Torque +1",
        ear1 = "Eabani Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Defending Ring",
        ring2 = "Epona's Ring",
        back = "Cornflower Cape",
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.Crit = set_combine(sets.engaged, {
        head = "Gleti's Mask",
        ear1 = "Odr Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Hetairoi Ring",
        ring2 = "Begrudging Ring",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots"
    })


    sets.engaged.Refresh = set_combine(sets.engaged, { body = "Jhakri Robe +2" })

    sets.engaged.DW = set_combine(sets.engaged,
        { ear1 = "Suppanomimi", waist = "Reiki Yotai", legs = "Carmine Cuisses +1" })

    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc,
        { ear1 = "Suppanomimi", waist = "Reiki Yotai", legs = "Carmine Cuisses +1" })

    sets.engaged.DW.Refresh = set_combine(sets.engaged.DW, { body = "Jhakri Robe +2" })

    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
    sets.engaged.DW.Learning = set_combine(sets.engaged.DW, sets.Learning)

    sets.MaxDW = {
        ear1 = "Suppanomimi",
        waist = "Reiki Yotai",
        legs = "Carmine Cuisses +1"
    }
    sets.engaged.MaxDW = set_combine(sets.engaged, sets.MaxDW)
    sets.engaged.Acc.MaxDW = set_combine(sets.engaged.Acc, sets.MaxDW)
    sets.engaged.PDT.MaxDW = set_combine(sets.engaged.PDT, sets.MaxDW)

    sets.MidDW = sets.MaxDW
    sets.engaged.MidDW = set_combine(sets.engaged, sets.MidDW)
    sets.engaged.Acc.MidDW = set_combine(sets.engaged.Acc, sets.MidDW)
    sets.engaged.PDT.MidDW = set_combine(sets.engaged.PDT, sets.MidDW)

    sets.MinDW = { waist = "Reiki Yotai", ear1 = "Suppanomimi" }
    sets.engaged.MinDW = set_combine(sets.engaged, sets.MinDW)
    sets.engaged.Acc.MinDW = set_combine(sets.engaged.Acc, sets.MinDW)
    sets.engaged.PDT.MinDW = set_combine(sets.engaged.PDT, sets.MinDW)


    sets.self_healing = {
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini,
        waist = "Gishdubar Sash"
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    -- remap phalanx to barrier tusk if it is not available
    if spell.english == "Phalanx" then
        cancel_spell()
        send_command("input /ma \"Barrier Tusk\" <me>")
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and (not (state.Buff['SP Ability II'] or
            state.Buff['Unbridled Learning']) or state.Buff['Unbridled Wisdom']) then
        eventArgs.cancel = true
        local recasts = windower.ffxi.get_ability_recasts() or T {}
        local unbridled_recast = recasts[81] or 0
        if unbridled_recast <= 0.2 or state.Buff['SP Ability II'] or state.Buff['Unbridled Wisdom'] then
            windower.send_command('input /ja "Unbridled Learning" <me>')
        else
            windower.add_to_chat(144,
                "Unbridled Learning is not ready (" .. (math.floor(unbridled_recast * 5 / 3) / 100) .. " mins)")
        end
        -- elseif unbridled_spells:contains(spell.english) then
        -- if state.Buff['SP Ability II'] then
        --     print('SP Ability II: True')
        -- else
        --     print('SP Ability II: False')
        -- end
        -- if state.Buff['Unbridled Learning'] then
        --     print('Unbridled Learning: True')
        -- else
        --     print('Unbridled Learning: False')
        -- end
        -- if state.Buff['Unbridled Wisdom'] then
        --     print('Unbridled Wisdom: True')
        -- else
        --     print('Unbridled Wisdom: False')
        -- end
    end

    -- local recasts = windower.ffxi.get_ability_recasts()
    -- local SPII_recast = recasts[254] or 0
    -- print(SPII_recast / 60)
end

-- function job_pretarget(spell, action, spellMap, eventArgs)
--     if spell.name == 'Unbridled Learning' and buffactive['Unbridled Wisdom'] then
--         eventArgs.cancel = true
--     end
-- end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type ~= 'WeaponSkill' then set_recast() end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_post_precast(spell, action, spellMap, eventArgs)
    if (blue_magic_maps.Magical + blue_magic_maps.MagicalDarkness
            + blue_magic_maps.MagicalLight + blue_magic_maps.MagicalMnd
            + blue_magic_maps.MagicalChr + blue_magic_maps.MagicalVit
            + blue_magic_maps.MagicalDex):contains(spell.english) then
        equip(sets.precast.FC.Weapon)
        eventArgs.handled = false
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff, active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
            equip(sets.self_healing)
        end
        -- equip on top.
        if blue_magic_maps.MagicalDarkness:contains(spell.english) then
            equip(sets.midcast["Blue Magic"].MagicalDarkness)
        elseif blue_magic_maps.MagicalLight:contains(spell.english) then
            equip(sets.midcast["Blue Magic"].MagicalLight)
        end
        -- if spell.english == 'Carcharian Verve' then
        --     equip(spells.midcast['Blue Magic']['Carcharian Verve'])
        -- end
    elseif spell.skill == 'Enhancing Magic' then
        if spell.english:startswith('Haste')
        then
            equip(sets.midcast['Enhancing Magic'].Duration)
        elseif spell.english:startswith('Regen') then
            equip(sets.midcast.Regen)
        elseif spell.english:startswith('Refresh') then
            equip(sets.midcast.Refresh)
        elseif spell.english == 'Aquaveil' then
            equip(sets.midcast.Aquaveil)
        elseif spell.english == 'Stoneskin' then
            equip(sets.midcast.Stoneskin)
        end
    end



    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    equip_recast()

    if buffactive.doom then
        if state.DoomMode.value == 'Cursna' then
            equip(sets.buff.doom)
        elseif state.DoomMode.value == 'Holy Water' then
            equip(sets.buff.doom.HolyWater)
        end
    end

    eventArgs.handled = false
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- print(buff)
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end

    -- adjust Unbridled Learning to match Unbridled Wisdom
    if buff == 'Unbridled Wisdom' then
        state.Buff['Unbridled Learning'] = gain
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

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category, spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()

    if buffactive.terror or buffactive.stun then
        send_command('gs equip sets.idle.PDT')
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

function update_combat_form()

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 5)
    else
        set_macro_page(1, 5)
    end

    send_command("@wait 5;input /lockstyleset 1")
end
