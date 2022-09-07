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
        'Scouring Spate', 'Blinding Fulgor', 'Searing Tempest',

    }

    blue_magic_maps.MagicalDarkness = S {
        'Tenebral Crush', 'Palling Salvo', 'Atra. Libations', 'Dark Orb',
        'Everyone\'s Grudge', 'Osmosis', 'Eyes On Me', 'Blood Saber',
        'MP Drainkiss', 'Digest', 'Death Ray', 'Blood Drain'
    }

    blue_magic_maps.MagicalLight = S {
        'Blinding Fulgor', 'Diffusion Ray', 'Rail Cannon', 'Retinal Glare', 'Radiant Breath'
    }

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
        'Sub-zero Smash', 'Venom Shell', 'Voracious Trunk', 'Yawn'
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
        'Pyric Bulwark', 'Thunderbolt', 'Tourbillion', 'Uproot'
    }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'PDT', 'Refresh', 'Learning')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Learning')

    gear.macc_hagondes = { name = "Hagondes Cuffs", augments = { 'Phys. dmg. taken -3%', 'Mag. Acc.+29' } }

    -- Additional local binds
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')

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
    gear.matk_head = { name = "Herculean Helm", augments = { 'Mag. Acc.+19 "Mag.Atk.Bns."+19', 'MND+1',
        '"Mag.Atk.Bns."+14', } }

    gear.default.obi_waist = "Acuity Belt +1"

    sets.buff['Burst Affinity'] = { feet = "Mavi Basmak +2" }
    sets.buff['Chain Affinity'] = { head = "Mavi Kavuk +2", feet = "Assimilator's Charuqs" }
    sets.buff.Convergence = { head = "Luhlaza Keffiyeh" }
    sets.buff.Diffusion = { feet = "Luhlaza Charuqs" }
    sets.buff.Enchainment = { body = "Luhlaza Jubbah" }
    sets.buff.Efflux = { legs = "Mavi Tayt +2" }

    -- Precast Sets
    sets.enmity = { ammo = "Sapience Orb",
        head = "Halitus Helm", neck = "Unmoving Collar +1", ear1 = "Trux Earring", ear2 = "Cryptic Earring",
        body = "Emet Harness +1", ring1 = "Supershear Ring", ring2 = "Eihwaz Ring",
        waist = "Trance Belt", legs = "Zoar Subligar +1"
    }

    sets.SIRD = { ammo = "Staunch Tathlum +1",
        neck = "Loricate Torque +1", ear1 = "Hasalz Earring", ear2 = "Magnetic Earring",
        hands = "Rawhide Gloves", ring1 = "Evanescence Ring",
        waist = "Resolute Belt", legs = "Carmine Cuisses +1", feet = "Amalric Nails +1"
    }

    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt", legs = "Volte Hose", feet = "Volte Boots"
    }

    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = { hands = "Mirage Bazubands +2" }

    sets.precast.RA = { range = "Albin Bane" }
    sets.midcast.RA = sets.precast.RA


    -- Waltz set (chr and vit)
    sets.precast.Waltz = { ammo = "Sonia's Plectrum",
        head = "Uk'uxkaj Cap",
        body = "Vanir Cotehardie", hands = "Buremte Gloves", ring1 = "Spiral Ring",
        back = "Iximulew Cape", waist = "Caudata Belt", legs = "Hagondes Pants", feet = "Iuitl Gaiters +1" }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.FC = { ammo = "Sapience Orb",
        head = "Carmine Mask +1", neck = "Orunmila's Torque", ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1", hands = "Leyline Gloves", ring1 = "Kishar Ring", ring2 = "Weatherspoon Ring +1",
        back = "Fi Follet Cape +1", legs = "Enif Cosciales", feet = "Carmine Greaves +1" }

    -- sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, { body = "Mavi Mintan +2" })


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Oshasha's Treatise",
        head = "Adhemar Bonnet +1", neck = "Fotia Gorget", ear1 = "Brutal Earring", ear2 = "Moonshade Earring",
        body = "Gleti's Cuirass", hands = "Adhemar Wristbands +1", ring1 = "Epaminondas's Ring", ring2 = "Regal Ring",
        back = "Sacro Mantle", waist = "Fotia Belt", legs = "Gleti's Breeches", feet = "Gleti's Boots" }

    sets.precast.WS.Acc = set_combine(sets.precast.WS,
        { head = "Malignance Chapeau", ear1 = "Crepuscular Earring", body = "Malignance Tabard",
            hands = "Malignance Gloves", legs = "Malignance Tights", feet = "Malignance Boots" })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, { ring1 = "Epona's Ring", feet = "Luhlaza Charuqs" })

    sets.precast.WS['Sanguine Blade'] = { ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1", neck = "Sibyl Scarf", ear1 = "Friomisi Earring", ear2 = "Hecate's Earring",
        body = "Amalric Doublet +1", hands = "Jhakri Cuffs +2", ring1 = "Metamorph Ring +1", ring2 = "Archon Ring",
        back = "Cornflower Cape", waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Amalric Nails +1" }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum medal", ear1 = "Ishvara Earring",
        ring2 = "Regal Ring",
        waist = "Sailfi Belt +1"
    })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head = "Blistering Sallet +1", ear2 = "Odr Earring",
        body = "Gleti's Cuirass", hands = "Gleti's Gauntlets", ring1 = "Begrudging Ring",
        legs = "Gleti's Breeches", feet = "Gleti's Boots"
    })

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
        ear1 = "Regal Earring",
        ring2 = "Metamorph Ring +1"
    })

    sets.midcast.Diaga = sets.TreasureHunter

    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Carmine Mask +1", ear1 = "Enchanter's Earring +1", ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1", hands = "Leyline Gloves", ring1 = "Kishar Ring", ring2 = "Weatherspoon Ring +1",
        back = "Fi Follet Cape +1", waist = "Witful Belt", legs = "Enif Cosciales", feet = "Carmine Greaves +1"
    }

    sets.midcast['Blue Magic'] = {
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Crepuscular Earring",
        ear2 = "Regal Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Jhakri Ring", ring2 = "Stikini Ring +1",
        back = "Felicitas cape +1", waist = gear.ElementalObi, legs = "Malignance Tights", feet = "Malignance Boots"
    }

    -- Physical Spells --

    sets.midcast['Blue Magic'].Physical = { ammo = "Ginsen",
        head = "Adhemar Bonnet +1", neck = "Republican Platinum Medal", ear1 = "Brutal Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Adhemar Gloves +1", ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
        back = "Cornflower Cape", waist = "Sailfi Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.midcast['Blue Magic'].PhysicalAcc = { ammo = "Ginsen",
        head = "Adhemar Bonnet +1", neck = "Republican Platinum Medal", ear1 = "Telos Earring",
        ear2 = "Crepuscular Earring",
        body = "Luhlaza Jubbah", hands = "Buremte Gloves", ring1 = "Rajas Ring", ring2 = "Patricius Ring",
        back = "Letalis Mantle", waist = "Sailfi Belt +1", legs = "Manibozho Brais", feet = "Qaaxo Leggings" }

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

    sets.midcast['Blue Magic'].Magical = { ammo = "Pemphredo Tathlum",
        head = gear.matk_head, neck = "Sibyl Scarf", ear1 = "Friomisi Earring", ear2 = "Hecate's Earring",
        body = "Amalric Doublet +1", hands = "Amalric Gages +1", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = "Felicitas Cape +1", waist = gear.ElementalObi, legs = "Amalric Slops +1", feet = "Amalric Nails +1" }

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical,
        { body = "Vanir Cotehardie", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
            legs = "Iuitl Tights", feet = "Mavi Basmak +2" })

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,
        {})

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical,
        { ring1 = "Gelatinous Ring +1" })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        ear1 = "Odr Earring"
    })

    sets.midcast['Blue Magic'].MagicalDarkness = set_combine(sets.midcast['Blue Magic'].Magical,
        { head = "Pixie Hairpin +1", ring1 = "Archon Ring" })

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical,
        { ring1 = "Weatherspoon Ring +1" })

    sets.midcast['Blue Magic'].MagicAccuracy = { ammo = "Mavi Tathlum",
        head = "Luhlaza Keffiyeh", neck = "Combatant's Torque", ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        ring2 = "Stikini Ring +1",
    }

    -- Breath Spells --

    sets.midcast['Blue Magic'].Breath = { ammo = "Mavi Tathlum",
        head = "Luhlaza Keffiyeh", neck = "Combatant's Torque", ear1 = "Crepuscular Earring",
        ear2 = "Dignitary's Earring",
        body = "Vanir Cotehardie", hands = "Assimilator's Bazubands +1", ring1 = "K'ayres Ring", ring2 = "Beeline Ring",
        back = "Refraction Cape", legs = "Enif Cosciales", feet = "Iuitl Gaiters +1" }

    -- Other Types --

    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
        { waist = "Chaac Belt" })

    sets.midcast['Blue Magic']['White Wind'] = {
        head = "Adhemar Bonnet +1", neck = "Lavalier +1", ear1 = "Etiolation Earring", ear2 = "Loquacious Earring",
        body = "Vanir Cotehardie", hands = "Buremte Gloves", ring1 = "K'ayres Ring", ring2 = "Meridian Ring",
        back = "Fravashi Mantle", waist = "Sailfi Belt +1", legs = "Enif Cosciales", feet = "Hagondes Sabots"
    }

    sets.midcast['Blue Magic'].Healing = {
        head = "Uk'uxkaj Cap", neck = "Nodens Gorget", ear1 = "Crepuscular Earring", ear2 = "Loquacious Earring",
        body = "Vanir Cotehardie", hands = "Telchine Gloves", ring1 = "Aquasoul Ring", ring2 = "Sirona's Ring",
        back = "Pahtli Cape", legs = "Hagondes Pants", feet = "Hagondes Sabots"
    }

    sets.midcast['Blue Magic'].SkillBasedBuff = { ammo = "Mavi Tathlum",
        head = "Luhlaza Keffiyeh",
        body = "Assimilator's Jubbah +1", ring1 = "Stikini Ring +1", ring2 = "Stiikini Ring +1",
        back = "Cornflower Cape", legs = "Mavi Tayt +2", feet = "Luhlaza Charuqs" }

    sets.midcast['Blue Magic'].Buff = {}

    sets.midcast.Protect = { ring1 = "Stikini Ring +1" }
    sets.midcast.Protectra = { ring1 = "Stikini Ring +1" }
    sets.midcast.Shell = { ring1 = "Stikini Ring +1" }
    sets.midcast.Shellra = { ring1 = "Stikini Ring +1" }




    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.Learning = { ammo = "Mavi Tathlum", hands = "Assimilator's Bazubands +1" }
    --head="Luhlaza Keffiyeh",
    --body="Assimilator's Jubbah +1",hands="Assimilator's Bazubands +1",
    --back="Cornflower Cape",legs="Mavi Tayt +2",feet="Luhlaza Charuqs"}


    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Resting sets
    sets.resting = {
        head = "Malignance Tabard", neck = "Bathy Choker +1",
        body = "Jhakri Robe +2", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        waist = "Austerity Belt", legs = "Malignance Tights", feet = "Malignance Boots"
    }

    -- Idle sets
    sets.idle = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Bathy Choker +1", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = "Shadow Mantle", waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Malignance Boots" }

    sets.idle.PDT = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = "Shadow Mantle", waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Malignance Boots" }

    sets.idle.Town = { main = "Buramenk'ah", ammo = "Staunch Tathlum +1",
        head = "Mavi Kavuk +2", neck = "Bathy Choker +1", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Luhlaza Jubbah", hands = "Assimilator's Bazubands +1", ring1 = "Stikini Ring +1",
        ring2 = "Defending Ring",
        back = "Atheling Mantle", waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Luhlaza Charuqs" }

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)


    -- Defense sets
    sets.defense.PDT = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Etiolation Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = "Shadow Mantle", waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.defense.MDT = set_combine(sets.defense.PDT, { ear2 = "Eabani Earring", ring1 = "Archon Ring" })

    sets.Kiting = { legs = "Carmine Cuisses +1" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = { ammo = "Ginsen",
        head = "Adhemar Bonnet +1", neck = "Combatant's Torque", ear1 = "Brutal Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Adhemar Wristbands +1", ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
        back = "Sacro Mantle", waist = "Sailfi Belt +1", legs = "Samnuha Tights", feet = "Malignance Boots" }

    sets.engaged.Acc = { ammo = "Ginsen",
        head = "Malignance Chapeau", neck = "Combatant's Torque", ear1 = "Brutal Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Hetairoi Ring", ring2 = "Epona's Ring",
        back = "Sacro Mantle", waist = "Sailfi Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.engaged.PDT = { ammo = "Ginsen",
        head = "Malignance Chapeau", neck = "Loricate Torque +1", ear1 = "Eabani Earring", ear2 = "Telos Earring",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Defending Ring", ring2 = "Epona's Ring",
        back = "Sacro Mantle", waist = "Reiki Yotai", legs = "Malignance Tights", feet = "Malignance Boots" }


    sets.engaged.Refresh = set_combine(sets.engaged, { body = "Jhakri Robe +2" })

    sets.engaged.DW = set_combine(sets.engaged,
        { ear1 = "Suppanomimi", waist = "Reiki Yotai", legs = "Carmine Cuisses +1" })

    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc,
        { ear1 = "Suppanomimi", waist = "Reiki Yotai", legs = "Carmine Cuisses +1" })

    sets.engaged.DW.Refresh = set_combine(sets.engaged.DW, { body = "Jhakri Robe +2" })

    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
    sets.engaged.DW.Learning = set_combine(sets.engaged.DW, sets.Learning)


    sets.self_healing = { ring1 = "Kunaji Ring", ring2 = "Asklepian Ring", waist = "Gishdubar Sash" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "' ..
            spell.name .. '" ' .. spell.target.name)
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
    end



    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
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
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    -- Check for H2H or single-wielding
    if player.equipment.sub == "Ammurapi Shield" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end
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
