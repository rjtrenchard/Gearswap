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
    state.RewardMode = M { ['description'] = 'Reward Mode', 'Theta', 'Zeta', 'Eta' }
    gear.reward_food = { name = "Pet Food Theta" }

    -- Set up Monster Correlation Modes and keybind Alt-F8
    state.CorrelationMode = M { ['description'] = 'Correlation Mode', 'Neutral', 'Favorable' }

    -- Custom pet modes for engaged gear
    state.PetMode = M { ['description'] = 'Pet Mode', 'Normal', 'PetStance', 'PetTank' }


    -- Physical based ready skills
    ready_physical = S {
        'Sic', 'Whirl Claws', 'Foot Kick', 'Sheep Charge', 'Lamb Chop',
        'Head Butt', 'Wild Oats', 'Leaf Dagger', 'Claw Cyclone', 'Razor Fang',
        'Nimble Snap', 'Cyclotail', 'Rhino Guard', 'Rhino Attack', 'Power Attack',
        'Mandibular Bite',
        'Big Scissors', 'Grapple', 'Spinning Top', 'Double Claw',
        'Frog Kick', 'Queasyshroom', 'Numbshroom', 'Shakeshroom', 'Blockhead',
        'Tail Blow', 'Brain Crush', '1000 Needles',
        'Needleshot', 'Scythe Tail', 'Ripper Fang', 'Chomp Rush', 'Recoil Dive',
        'Sudden Lunge', 'Spiral Spin', 'Wing Slap',
        'Beak Lunge', 'Suction', 'Back Heel',
        'Tortoise Stomp',
        'Sensilla Blades', 'Tegmina Buffet', 'Swooping Frenzy', 'Pentapeck', 'Sweeping Gouge',
        'Tickling Tendrils',
    }
    -- Magical or Magic accuracy based ready skills
    ready_magical = S { 'Cursed Sphere',
        'Bubble Shower',
        'Silence Gas', 'Dark Spore', 'Fireball', 'Plague Breath',
        'Snow Cloud',
        'Drainkiss', 'Acid Mist', 'Choke Breath', 'Charged Whisker', 'Purulent Ooze',
        'Corrosive Ooze',
        'Aqua Breath', 'Molting Plumage',
        'Stink Bomb', 'Nectarous Deluge', 'Nepenthic Plunge'
    }
    ready_effect = S {
        'Sheep Song', 'Dust Cloud', 'Scream', 'Dream Flower', 'Roar', 'Gloeosuccus', 'Palsy Pollen', 'Soporific',
        'Venom', 'Geist Wall', 'Toxic Spit', 'Numbing Noise', 'Spoil', 'Hi-Freq Field', 'Sandpit', 'Sandblast',
        'Venom Spray', 'Spore', 'Filamented Hold', 'Infrasonics', 'Chaotic Eye', 'Blaster', 'Intimidate', 'TP Drainkiss', 'Jettatura',
        'Noisome Powder'
    }
    -- Buffs and heal based ready skills
    ready_buff = S { 'Harden Shell', 'Secretion', 'Rage', 'Zealous Snort', 'Water Wall', 'Metallic Body', 'Scissor Guard',
        'Bubble Curtain',
        'Wild Carrot', 'Fantod' }

    state.PetWSMode = M { ['description'] = 'Pet Weaponskill Mode', 'WS', 'WSMagEffect', 'WSMagical', 'WSBuff' }

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

function user_setup()
    include('augments.lua')
    include('helper_functions.lua')
    include('default_sets.lua')

    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.DefenseMode:options('None', 'Physical', 'Magical', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'PDT', 'Reraise', 'PetDT')
    state.PhysicalDefenseMode:options('PDT', 'Hybrid', 'Killer', 'Reraise')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    gear.default.ElementalObi = "Eschan Stone"

    send_command('bind numpad7 gs c equip axes')
    send_command('bind numpad8 gs c equip Dolichenus')
    send_command('bind !numpad8 gs c equip AE')
    send_command('bind numpad9 gs c equip tp_bonus')
    send_command('bind !numpad9 gs c equip sword')
    send_command('bind ^numpad9 gs c equip scythe')

    send_command('bind ^` gs c cycle PetMode')
    send_command('bind !` gs c cycle CorrelationMode')

    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^- gs c cycle DoomMode')

    send_command('bind numpad1 input /bstpet 1')
    send_command('bind numpad2 input /bstpet 2')
    send_command('bind numpad3 input /bstpet 3')
    send_command('bind numpad4 input /bstpet 4')
    send_command('bind numpad5 input /bstpet 5')
    send_command('bind numpad6 input /bstpet 6')

    send_command('bind ^f11 gs c set DefenseMode Reraise')

    update_combat_form()
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    -- Unbinds the Reward and Correlation hotkeys.
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.weapons = {}
    sets.weapons.axes = { main = "Agwu's Axe", sub = "Kaidate" }
    sets.weapons.axes.DW = { main = "Dolichenus", sub = "Agwu's Axe" }
    sets.weapons.tp_bonus = { main = "Agwu's Axe", sub = "Kaidate" }
    sets.weapons.tp_bonus.DW = { main = "Agwu's Axe", sub = "Fernagu" }
    sets.weapons.Dolichenus = { main = "Dolichenus", sub = "Kaidate" }
    sets.weapons.Dolichenus.DW = { main = "Dolichenus", sub = "Agwu's Axe" }
    sets.weapons.sword = { main = "Naegling", sub = "Kaidate" }
    sets.weapons.sword.DW = { main = "Naegling", sub = "Fernagu" }
    sets.weapons.AE = { main = "Crepuscular Knife", sub = "Fernagu" }
    sets.weapons.AE.DW = sets.weapons.AE
    sets.weapons.scythe = { main = "Drepanum", sub = "Bloodrain Strap" }
    sets.weapons.scythe.DW = sets.weapons.scythe

    gear.pet_phys_cape = { name = "Artio's Mantle", augments = { 'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20', 'Eva.+20 /Mag. Eva.+20', 'Pet: Haste+10', 'System: 1 ID: 1246 Val: 4', } }
    gear.pet_mag_cape = { name = "Artio's Mantle", augments = { 'Pet: M.Acc.+20 Pet: M.Dmg.+20', 'Eva.+20 /Mag. Eva.+20', 'Pet: "Regen"+10', 'Pet: "Regen"+5', } }

    gear.melee_cape = { name = "Artio's Mantle", augments = { 'DEX+20', 'Accuracy+20 Attack+20', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }

    gear.str_ws_cape = { name = "Artio's Mantle", augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Weapon skill damage +10%', } }
    gear.primalrend_cape = { name = "Artio's Mantle", augments = { 'CHR+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'CHR+10', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%', } }
    gear.cloudsplitter_cape = { name = "Artio's Mantle", augments = { 'MND+20', 'Mag. Acc+20 /Mag. Dmg.+20', 'MND+10', 'Weapon skill damage +10%', } }
    gear.multi_ws_cape = gear.melee_cape
    gear.crit_ws_cape = gear.str_ws_cape

    gear.charm_cape = gear.primalrend_cape
    gear.reward_cape = gear.cloudsplitter_cape

    -- used by user function to call a pet using gearswap
    sets.jugpet = { ammo = empty }

    sets.buff['Killer Instinct'] = { head = "Ankusa Helm +3", body = "Nukumi Gausape +3", }
    sets.buff['Killer Instinct'].Magical_WS = { body = "Nukumi Gausape +3" }

    -- Precast Sets
    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

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
        head = gear.acro.SIRD.head,  -- 10
        neck = "Loricate Torque +1", -- 5
        ear1 = "Magnetic earring",   -- 8
        ear2 = "Halasz Earring",     -- 5
        ring1 = "Evanescence Ring",  -- 5
        ring2 = gear.dark_ring.SIRD, -- 4

    }

    sets.resist = {}
    sets.resist.death = {
        main = "Odium",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    sets.buff.doom = set_combine(sets.defense.PDT, {
        neck = "Nicander's Necklace",
        ring1 = "Eshmun's Ring",
        ring2 = "Eshmun's Ring",
        waist = "Gishdubar Sash"
    })

    sets.buff.doom.HolyWater = set_combine(sets.buff.doom, {
        neck = "Nicander's Necklace",
        ring1 = "Blenmot's Ring +1",
        ring2 = "Blenmot's Ring +1"
    })

    --------------------------------------
    -- Precast sets
    --------------------------------------

    sets.precast.JA['Killer Instinct'] = { head = "Ankusa Helm +3" }
    sets.precast.JA['Feral Howl'] = { body = "Ankusa Jackcoat +3" }
    sets.precast.JA['Call Beast'] = { hands = "Ankusa Gloves +3", body = "Mirke Wardecors" }
    sets.precast.JA['Bestial Loyalty'] = sets.precast.JA['Call Beast']
    sets.precast.JA['Familiar'] = { legs = "Ankusa Trousers +3" }
    sets.precast.JA['Tame'] = { ear1 = "Tamer's Earring", legs = "Stout Kecks" }
    sets.precast.JA['Spur'] = { feet = "Nukumi Ocreae +3" }
    sets.precast.JA['Ready'] = { hands = "Nukumi Manoplas +3", legs = "Gleti's Breeches" } -- equip before any "Monster" ability
    sets.precast.JA['Sic'] = sets.precast.JA['Ready']

    sets.precast.JA['Reward'] = {
        ammo = gear.reward_food,
        head = "Crepuscular Helm",
        ear2 = "Pratik Earring",
        body = "Ankusa Jackcoat +3",
        hands = "Malignance Gloves",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.reward_cape,
        waist = "Engraved Belt",
        legs = "Ankusa Trousers +3",
        feet = "Ankusa Gaiters +3"
    }

    sets.precast.JA['Charm'] = {
        ammo = "Pemphredo Tathlum",
        head = "Ankusa Helm +3",
        neck = "Unmoving Collar +1",
        ear1 = "Dignitary's Earring",
        ear2 = "Nukumi Earring +1",
        body = "Ankusa Jackcoat +3",
        hands = "Ankusa Gloves +3",
        ring1 = gear.left_stikini,
        ring2 = "Metamorph Ring +1",
        back = gear.charm_cape,
        waist = "Eschan Stone",
        legs = "Ankusa Trousers +3",
        feet = "Ankusa Gaiters +3"
    }
    sets.precast.JA['Gauge'] = sets.precast.JA['Charm']

    -- CURING WALTZ
    sets.precast.Waltz = sets.precast.JA['Charm']

    -- HEALING WALTZ
    sets.precast.Waltz['Healing Waltz'] = {}

    -- STEPS
    sets.precast.Step = {
        ammo = "Voluspa Tathlum",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Crepuscular Earring",
        ear2 = "Nukumi Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.melee_cape,
        waist = "Klouskap Sash +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- VIOLENT FLOURISH
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {}

    sets.precast.FC = {
        ammo = "Sapience Orb",           -- 2
        neck = "Orunmila's Torque",      -- 5
        ear1 = "Loquacious Earring",     -- 2
        ear2 = "Enchanter's Earring +1", -- 2
        body = "Sacro Breastplate",      -- 10
        hands = "Leyline Gloves",        -- 8
        ring1 = "Medada's Ring",         -- 10
        ring2 = "Weatherspoon Ring +1",  -- 6
        legs = "Limbo Trousers",         -- 3
    }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})

    -- WEAPONSKILLS
    -- Default weaponskill set.
    sets.precast.WS = {
        ammo = "Voluspa Tathlum",
        head = "Ankusa Helm +3",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Thrud Earring",
        body = "Nukumi Gausape +3",
        hands = "Meghanada Gloves +2",
        ring2 = gear.TrustRing,
        ring1 = "Epaminondas's Ring",
        back = gear.str_ws_cape,
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }
    sets.precast.WS.FullTP = {
        ear1 = "Lugra Earring +1"
    }

    sets.precast.WS.WSAcc = {
        ammo = "Crepuscular Pebble",
        head = "Nyame Helm",
        neck = "Fotia Gorget",
        ear1 = "Telos Earring",
        ear2 = "Nukumi Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Regal Ring",
        back = gear.str_ws_cape,
        waist = "Fotia Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS.WSCrit = {
        ammo = "Crepuscular Pebble",
        head = "Blistering Sallet +1",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Lugra Earring +1",
        body = "Gleti's Cuirass",
        hands = "Nukumi Manoplas +3",
        ring2 = gear.right_chirich,
        ring1 = "Begrudging Ring",
        back = gear.crit_ws_cape,
        waist = "Fotia Belt",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots"
    }

    sets.precast.WS.MultiHit = {
        ammo = "Crepuscular Pebble",
        head = "Gleti's Mask",
        neck = "Fotia Gorget",
        ear1 = "Sherida Earring",
        ear2 = "Lugra Earring +1",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Sroda Ring",
        ring2 = "Gere Ring",
        back = gear.multi_ws_cape,
        waist = "Fotia Belt",
        legs = "Gleti's Breeches",
        feet = "Nukumi Ocreae +3"
    }

    -- Specific weaponskill sets.
    -- Axes
    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Mistral Axe'].Acc = set_combine(sets.precast.WS.WSAcc,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Mistral Axe'].FullTP = sets.precast.WS.FullTP

    sets.precast.WS['Calamity'] = set_combine(sets.precast.WS,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Calamity'].Acc = set_combine(sets.precast.WS.WSAcc,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Calamity'].FullTP = sets.precast.WS.FullTP

    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS.WSCrit,
        { ear1 = "Lugra Earring +1", ear2 = "Sherida Earring" })
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})


    sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS.MultiHit,
        { ear1 = "Lugra Earring +1", ear2 = "Sherida Earring" })
    sets.precast.WS['Ruinator'].Acc = set_combine(sets.precast.WS.WSAcc,
        { ear1 = "Lugra Earring +1", ear2 = "Sherida Earring" })

    sets.precast.WS['Onslaught'] = set_combine(sets.precast.WS, { ear1 = "Lugra Earring +1" })
    sets.precast.WS['Onslaught'].Acc = set_combine(sets.precast.WSAcc, {})

    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Decimation'].Acc = set_combine(sets.precast.WS.MultiHit, {})

    sets.precast.WS['Primal Rend'] = {
        ammo = "Oshasha's Treatise",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Moonshade Earring",
        ear2 = "Friomisi Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Weatherspoon Ring +1",
        ring2 = "Epaminondas's Ring",
        back = gear.primalrend_cape,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets",
    }
    sets.precast.WS['Primal Rend'].FullTP = {
        ear1 = "Crematio Earring"
    }

    sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS['Primal Rend'],
        {
            ring1 = "Medada's Ring",
            back = gear.cloudsplitter_cape,
        })
    sets.precast.WS['Cloudsplitter'].FullTP = sets.precast.WS['Primal Rend'].FullTP

    -- Sword
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
        {
            neck = "Republican Platinum medal",
            waist = "Sailfi Belt +1",
        })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS.WSAcc, {})
    sets.precast.WS['Savage Blade'].FullTP = sets.precast.WS.FullTP

    -- Dagger
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.WSCrit, {})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS.WSAcc, {})

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Cloudsplitter'])
    sets.precast.WS['Aeolian Edge'].FullTP = sets.precast.WS['Cloudsplitter'].FullTP

    -- Scythe
    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS.WSAcc,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })
    sets.precast.WS['Spiral Hell'].FullTP = sets.precast.WS.FullTP


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        ammo = "Sapience Orb",
        head = "Malignance Chapeau",
        neck = "Orunmila's Torque",
        ear1 = "Loquacious Earring",
        ear2 = "Enchanter's Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Medada's Ring",
        ring2 = "Weatherspoon Ring +1",
        waist = "Klouskap Sash +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, { neck = "Magoraga Bead Necklace" })


    -- PET SIC & READY MOVES
    -- default
    sets.midcast.Pet = {
    }

    sets.midcast.Pet.WS = {
        ammo = "Hesperiidae",
        head = "Emicho Coronet +1",
        neck = "Shulmanu Collar",
        ear1 = "Sroda Earring",
        ear2 = "Nukumi Earring +1",
        body = "Ankusa Jackcoat +3",
        hands = "Nukumi Manoplas +3",
        ring1 = "Varar Ring +1",
        ring2 = "Cath Palug Ring",
        back = gear.pet_phys_cape,
        waist = "Incarnation Sash",
        legs = "Totemic Trousers +2",
        feet = "Gleti's Boots"
    }
    sets.midcast.Pet.WS.Unleash = {}

    -- pet magical debuff attacks
    sets.midcast.Pet.WSMagEffect = {
        ammo = "Hesperiidae",
        head = "Nukumi Cabasset +3",
        neck = "Beastmaster collar +2",
        ear1 = "Handler's Earring +1",
        ear2 = "Crepuscular earring",
        body = "Nukumi Gausape +3",
        hands = "Nukumi Manoplas +3",
        ring1 = "Varar Ring +1",
        ring2 = "Cath Palug Ring",
        back = gear.pet_mag_cape,
        waist = "Incarnation Sash",
        legs = "Nukumi Quijotes +3",
        feet = "Gleti's Boots"
    }
    sets.midcast.Pet.WSMagEffect.Unleash = {}

    -- pet magical attacks
    sets.midcast.Pet.WSMagical = set_combine(sets.midcast.Pet.WSMagEffect, {
        ammo = "Hesperiidae",
        neck = "Adad Amulet",
        body = "Udug Jacket",
        hands = "Nukumi Manoplas +3",
        back = gear.pet_mag_cape,
        waist = "Incarnation Sash",
    })
    sets.midcast.Pet.WSMagical.Unleash = {}

    sets.midcast.Pet.WSBuff = set_combine(sets.midcast.Pet.WS.Magical, {})

    sets.midcast.Pet.WS.Unleash = {}

    sets.midcast.Pet.Neutral = {}
    sets.midcast.Pet.Favorable = { head = "Nukumi Cabasset +3" }


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- RESTING
    sets.resting = {

    }

    -- IDLE SETS
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Tuisto Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Skadi's Jambeaux +1"
    }

    sets.idle.PDT = set_combine(sets.idle, { body = "Adamantite Armor" })

    sets.idle.Town = sets.idle

    sets.idle.Refresh = {
        head = "Sibyl Scarf",
        body = "Crepuscular Mail",
        ring1 = gear.left_stikini,
        ring2 = gear.right_stikini
    }

    sets.idle.Reraise = set_combine(sets.idle, { head = "Crepuscular Helm", body = "Crepuscular Mail" })

    sets.idle.Pet = set_combine(sets.idle, {
        ear1 = "Handler's Earring +1",
        ear2 = "Enmerkar Earring",
        head = "Nukumi Cabasset +3",
        body = "Nyame Mail",
        hands = "Gleti's Gauntlets",
        legs = "Nukumi Quijotes +3",
        waist = "Isa Belt",
        back = gear.pet_mag_cape
    })

    sets.idle.Pet.Engaged = {
        ammo = "Hesperiidae",
        head = "Nukumi Cabasset +3",
        neck = "Shulmanu Collar",
        ear1 = "Rimeice Earring",
        ear2 = "Nukumi Earring +1",
        body = "Ankusa Jackcoat +3",
        hands = "Gleti's Gauntlets",
        ring1 = "Varar Ring +1",
        ring2 = "Cath Palug Ring",
        back = gear.pet_phys_cape,
        waist = "Klouskap Sash +1",
        legs = "Nukumi Quijotes +3",
        feet = "Gleti's Boots"
    }

    sets.idle.Pet.PetTank = set_combine(sets.idle.Pet.Engaged, {
        head = "Anwig Salade",
        neck = "Shepherd's Chain",
        ear1 = "Handler's Earring +1",
        ear2 = "Rimeice Earring",
        body = gear.taeon.petdt.body,
        hands = "Gleti's Gauntlets",
        legs = gear.taeon.petdt.legs,
        feet = gear.taeon.petdt.feet
    })

    -- DEFENSE SETS
    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Adamantite Armor",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = gear.right_moonlight,
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = set_combine(sets.defense.PDT, {
        ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau",
        neck = "Warder's Charm +1",
        ear1 = "Eabani Earring",
        ear2 = "Odnowa Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Archon Ring",
        ring2 = "Shadow Ring",
        waist = "Engraved Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    })

    sets.defense.Hybrid = set_combine(sets.defense.PDT, { waist = "Klouskap Sash +1" })

    sets.defense.Killer = set_combine(sets.defense.Hybrid, { body = "Nukumi Gausape +3" })

    sets.defense.Reraise = set_combine(sets.defense.PDT, { head = "Crepuscular Helm", body = "Crepuscular Mail" })

    sets.Kiting = set_combine(sets.defense.PDT, { feet = "Skadi's Jambeaux +1" })


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Shulmanu Collar",
        ear1 = "Telos Earring",
        ear2 = "Sherida Earring",
        body = "Gleti's Cuirass",
        hands = "Malignance Gloves",
        ring1 = "Epona's Ring",
        ring2 = "Gere Ring",
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.Acc = {
        ammo = "Voluspa Tathlum",
        head = "Nukumi Cabasset +3",
        neck = "Shulmanu Collar",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        body = "Nukumi Gausape +3",
        hands = "Nukumi Manoplas +3",
        ring1 = gear.left_moonlight,
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Sailfi Belt +1",
        legs = "Nukumi Quijotes +3",
        feet = "Nukumi Ocreae +3"
    }

    sets.engaged.PDT = {
        ammo = "Voluspa Tathlum",
        head = "Malignance Chapeau",
        neck = "Loricate Torque +1",
        ear1 = "Sherida Earring",
        ear2 = "Telos Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Gelatinous Ring +1",
        ring2 = gear.right_moonlight,
        back = gear.melee_cape,
        waist = "Klouskap Sash +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.engaged.Killer = set_combine(sets.engaged,
        { head = "Ankusa Helm +3", body = "Nukumi Gausape +3", legs = "Totemic Trousers +2" })
    sets.engaged.Killer.Acc = set_combine(sets.engaged.Acc, { body = "Nukumi Gausape +3" })

    sets.engaged.HasteMaxDW = set_combine(sets.engaged, {
        ear1 = "Eabani Earring",
        waist = "Reiki Yotai"
    })

    sets.engaged.HasteMidDW = set_combine(sets.engaged, {
        ear1 = "Eabani Earring",
        ear2 = "Suppanomimi",
        waist = "Reiki Yotai"
    })

    sets.engaged.NormalDW = set_combine(sets.engaged, {
        ear1 = "Eabani Earring",
        ear2 = "Suppanomimi",
        waist = "Reiki Yotai"
    })
    sets.engaged.SlowDW = sets.engaged.NormalDW
    sets.engaged.SlowMaxDW = sets.engaged.NormalDW
    -- EXAMPLE SETS WITH PET MODES

    -- sets.engaged.PetStance.Killer = {}
    -- sets.engaged.PetStance.Killer.Acc = {}
    -- sets.engaged.PetTank.Killer = {}
    -- sets.engaged.PetTank.Killer.Acc = {}

    -- MORE EXAMPLE SETS WITH EXPANDED COMBAT FORMS

    -- sets.engaged.NormalDW.PetStance = {}
    -- sets.engaged.NormalDW.PetStance.Acc = {}
    -- sets.engaged.NormalDW.PetTank = {}
    -- sets.engaged.NormalDW.PetTank.Acc = {}

    -- sets.engaged.KillerDW.PetStance = {}
    -- sets.engaged.KillerDW.PetStance.Acc = {}
    -- sets.engaged.KillerDW.PetTank= {}
    -- sets.engaged.KillerDW.PetTank.Acc = {}

    sets.engaged.PetStance = set_combine(sets.engaged, { waist = "Klouskap Sash +1", feet = "Gleti's Boots" })
    sets.engaged.PetStance.Acc = set_combine(sets.engaged.Acc, { waist = "Klouskap Sash +1", feet = "Gleti's Boots" })
    sets.engaged.PetStance.PDT = set_combine(sets.engaged.PDT, { waist = "Klouskap Sash +1", feet = "Gleti's Boots" })
    sets.engaged.PetTank = set_combine(sets.engaged.PDT,
        {
            head = "Anwig Salade",          --10
            ear1 = "Handler's Earring +1",  -- 4
            ear2 = "Enmerkar Earring",      -- 3
            ring2 = "Cath Palug Ring",
            body = gear.taeon.petdt.body,   -- 4
            hands = gear.taeon.petdt.hands, -- 4
            legs = "Nukumi Quijotes +3",    -- 8
            feet = gear.taeon.petdt.feet    -- 4
        })
    sets.engaged.PetTank.Acc = set_combine(sets.engaged.Acc,
        {
            ear1 = "Handler's Earring +1",
            body = gear.taeon.petdt.body,
            hands = gear.taeon.petdt.hands,
            legs = gear.taeon.petdt.legs,
            feet = gear.taeon.petdt.feet
        })
    sets.engaged.PetStance.Killer = set_combine(sets.engaged, {})
    sets.engaged.PetStance.Killer.Acc = set_combine(sets.engaged, {})
    sets.engaged.PetTank.Killer = set_combine(sets.engaged, {})
    sets.engaged.PetTank.Killer.Acc = set_combine(sets.engaged, {})

    --sets.engaged.DW.PetStance = sets.engaged
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
    if spell.type == 'Weaponskill' then
        local main = player.equipment.main
        if S { "Crepuscular Knife", "Tauret" }:contains(main) then
            if spell.english == 'Primal Rend' or spell.english == 'Mistral Axe' then
                cancel_spell()
                send_command('input /ws "Aeolian Edge"')
            end
        elseif S { "Naegling" }:contains(main) then
            if spell.english == 'Primal Rend' then
                cancel_spell()
                send_command('input /ws "Savage Blade"')
            end
        elseif S { "Drepanum" }:contains(main) then
            if spell.english == 'Primal Rend' then
                cancel_spell()
                send_command('input /ws "Entropy"')
            elseif spell.english == 'Calamity' then
                cancel_spell()
                send_command('input /ws "Spiral Hell"')
            elseif spell.english == 'Mistral Axe' then
                cancel_spell()
                send_command('input /ws "Spinning Scythe"')
            end
        end
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
    -- auto engage on ready action
    if spell.type == 'Monster' and pet.status ~= 'Engaged' and player.target.type == 'MONSTER' then
        eventArgs.cancel = true
        send_command("input /pet Fight <t>")
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    -- print(spell.english, spell.type, spell.action_type)

    -- Define class for Ready moves.
    if spell.type == 'Monster' then
        equip(sets.precast.JA['Ready'])
        state.PetWSMode:reset()
        if ready_physical:contains(spell.english) then
            state.PetWSMode:set("WS")
        elseif ready_magical:contains(spell.english) then
            state.PetWSMode:set("WSMagical")
        elseif ready_effect:contains(spell.english) then
            state.PetWSMode:set("WSMagEffect")
        elseif ready_buff:contains(spell.english) then
            state.PetWSMode:set("WSBuff")
        else
            state.PetWSMode:set("WS")
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if state.CorrelationMode.value == 'Favorable' then
            -- if info.magical_ws:contains(spell.english) then
            --     equip(sets.buff['Killer Instinct'].Magical_WS)
            -- else
            equip(sets.buff['Killer Instinct'])
            -- end
        end
        if player.tp == 3000 and sets.precast.WS[spell.english] and sets.precast.WS[spell.english].FullTP then
            equip(sets.precast.WS[spell.english].FullTP)
        elseif player.tp == 3000 and not sets.precast.WS[spell.english] and sets.precast.WS.FullTP then
            equip(sets.precast.WS.FullTP)
        end
    end
end

function job_pet_midcast(spell, action, spellMap, eventArgs)
    equip(sets.midcast.Pet[state.PetWSMode.value])
    if buffactive['Unleash'] then
        if sets.midcast.Pet[state.PetWSMode.value].Unleash then
            equip(sets.midcast.Pet[state.PetWSMode.value].Unleash)
        else
            equip(sets.midcast.Pet.WS.Unleash)
        end
    end
    if state.CorrelationMode.value == 'Favorable' then
        equip(sets.midcast.Pet.Favorable)
    end
    eventArgs.handled = true
    state.PetWSMode:reset()
end

function job_aftercast(spell, action, spellMap, eventArgs)
    sets.jugpet.ammo = empty
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
    if buff == 'Killer Instinct' then
        update_combat_form()
        handle_equipping_gear(player.status)
    elseif S { 'haste', 'march', 'embrava', 'haste samba', 'slow', 'elegy' }:contains(buff:lower()) then
        set_DW_class()
        send_command('gs c update')
    end

    if gain then
        if S { 'haste', 'march', 'embrava', 'haste samba', 'slow', 'elegy' }:contains(buff:lower()) then
            set_DW_class()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('gs equip sets.idle.PDT')
            send_command('input /p Charmed')
        elseif buff == 'doom' then
            send_command('input /p Doomed')
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs equip sets.idle.PDT')
        elseif buff == 'sleep' then
            if buffactive['Stoneskin'] and has_poison_debuff(buffactive) then send_command('cancel stoneskin') end
        elseif buff == 'Level Restriction' then
            bind_weapons()
        elseif buff:startswith('En') then
            update_combat_form()
        end
    else
        if S { 'haste', 'march', 'embrava', 'haste samba', 'slow', 'elegy' }:contains(buff:lower()) then
            set_DW_class()
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off')
        elseif buff == 'doom' then
            send_command('input /p Doom off')
            send_command('gs c update')
        elseif buff == 'terror' or buff == 'stun' then
            send_command('gs c update')
        elseif buff == 'Level Restriction' then
            bind_weapons()
        end
    end
end

function bind_weapons()
    send_command('bind numpad7 gs c equip axes')
    send_command('bind numpad8 gs c equip Dolichenus')
    send_command('bind !numpad8 gs c equip AE')
    send_command('bind numpad9 gs c equip tp_bonus')
    send_command('bind !numpad9 gs c equip sword')
    send_command('bind ^numpad9 gs c equip scythe')
end

-- function job_pet_change(pet, gain)

-- end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
    send_command('gs c update')

    -- set pet mode?
    if newStatus == 'Engaged' then
        display_pet_status()
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name ..
            ' [' .. get_pet_killer_trait(pet.name) .. ' Killer' .. ']: ' .. tostring(pet.status) ..
            '  TP=' .. tostring(pet.tp) .. '  HP%=' .. tostring(pet.hpp) .. '  Pet Mode=' .. state.PetMode.value

        add_to_chat(122, petInfoString)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Reward Mode' then
        -- Theta, Zeta or Eta
        gear.reward_food.name = "Pet Food " .. newValue
    elseif stateField == 'Pet Mode' then
        state.CombatWeapon:set(newValue)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

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

    if classes.CustomMeleeGroups:contains('SlowMaxDW') then
        msg = msg .. ' (SlowMaxDW)'
    elseif classes.CustomMeleeGroups:contains('SlowDW') then
        msg = msg .. ' (SlowDW)'
    elseif classes.CustomMeleeGroups:contains('NormalDW') then
        msg = msg .. ' (NormalDW)'
    elseif classes.CustomMeleeGroups:contains('HasteMidDW') then
        msg = msg .. ' (HasteMidDW)'
    elseif classes.CustomMeleeGroups:contains('HasteMaxDW') then
        msg = msg .. ' (HasteMaxDW)'
    end

    msg = msg .. ': '

    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value

    if state.DefenseMode.value ~= 'None' then
        msg = msg ..
            ', ' ..
            'Defense: ' ..
            state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    if pet.isvalid then
        msg = msg .. ' [' .. get_pet_killer_trait(pet.name) .. ' Killer]'
    end

    msg = msg .. ', Reward: ' .. state.RewardMode.value .. ', Correlation: ' .. state.CorrelationMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

function job_self_command(cmdParams, eventArgs)
    local command = cmdParams[1]:lower()

    local function second_arg(cmdParams)
        t = T {}
        for k, v in pairs(cmdParams) do
            -- print(k, v)
            if k ~= 1 then t:append(v) end
        end
        if t:length() < 1 then return nil else return t end
    end

    local arg = second_arg(cmdParams) or nil
    if arg then arg = arg:sconcat() end

    -- call with:
    -- gs c cb "Bubbly Broth"
    -- or in a macro
    -- /console gs c cb "Bubbly Broth"
    if command == 'cb' then
        call_pet('Call Beast', arg)

        -- call with:
        -- gs c bl "Bubbly Broth"
        -- or in a macro
        -- /console gs c bl "Bubbly Broth"
    elseif command == 'bl' then
        call_pet('Bestial Loyalty', arg)
    elseif command == 'equip' then
        job_custom_weapon_equip(arg)
    end
end

function call_pet(action, jugpet_item)
    if not (action == 'Call Beast' or action == 'Bestial Loyalty') then
        windower.add_to_chat(36, "Error: Unknown command: " .. action)
        return
    end
    if not (check_for_jugpet(jugpet_item)) then
        windower.add_to_chat(36, "Error: No '" .. jugpet_item .. "' jugpet available.")
        return
    end

    sets.jugpet = { ammo = jugpet_item }

    -- equip jugpet
    send_command("gs equip sets.jugpet")

    -- call the pet
    send_command("input /ja \"" .. action .. "\"")
end

function check_for_jugpet(jugpet_item)
    return (jugpet_item and has_equippable(jugpet_item)) or false
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 9)

    send_command("@wait 5;input /lockstyleset 7")
end
