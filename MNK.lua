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
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false

    state.FootworkWS = M(false, 'Footwork on WS')

    info.impetus_hit_count = 0
    windower.raw_register_event('action', on_action_for_impetus)
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    include('augments.lua')
    include('natty_helper_functions.lua')
    include('default_sets.lua')

    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'SomeAcc', 'Acc', 'Fodder')
    state.HybridMode:options('Normal', 'PDT', 'Counter')
    state.PhysicalDefenseMode:options('PDT', 'HP')

    state.SpinningTHTag = M { ['description'] = 'Spinning TH Tag', 'Disabled', 'Once' }

    state.Quietus = M { ['description'] = 'Quietus Mode', 'Disabled', 'Enabled' }

    send_command('bind numpad7 gs equip sets.weapons.godhands')
    send_command('bind numpad8 gs equip sets.weapons.xoanon')

    send_command('bind ^= gs c cycle SpinningTHTag')

    update_combat_form()
    update_melee_groups()

    select_default_macro_book()
end

function user_unload()
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.ws_cape_vit = { name = "Segomo's Mantle", augments = { 'VIT+20', 'Accuracy+20 Attack+20', 'VIT+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%' } }
    gear.ws_cape_str = { name = "Segomo's Mantle", augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }
    gear.tp_cape = { name = "Segomo's Mantle", augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%', } }

    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    gear.default.obi_waist = "Orpheus's Sash"

    sets.resist = {}
    sets.resist.death = {
        body = "Samnuha Coat", ring1 = "Shadow Ring", ring2 = "Eihwaz Ring"
    }

    sets.weapons = {}
    sets.weapons.godhands = { main = "Godhands" }
    sets.weapons.xoanon = { main = "Xoanon", sub = "Ultio Grip" }

    -- Buff sets

    sets.TreasureHunter = {
        ammo = "Perfect lucky egg",
        body = gear.herculean.th.body,
        waist = "Chaac Belt"
    }

    sets.Buff = {}
    sets.Buff['Impetus'] = { body = "Bhikku Cyclas +3" }
    sets.Buff['Perfect Counter'] = { head = "Bhikku Crown +3" }

    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Halitus helm",
        neck = "Unmoving Collar +1",
        ear1 = "Trux Earring",
        ear2 = "Cryptic earring",
        body = "emet harness +1",
        hands = "Kurys gloves",
        ring1 = "Eihwaz Ring",
        ring2 = "Supershear ring",
        -- back = "",
        waist = "Trance Belt",
        -- legs = "",
        -- feet = "",

    }

    -- Precast Sets


    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = { legs = "Hesychast's Hose +1" }
    sets.precast.JA['Boost'] = { hands = "Anchorite's Gloves +1", waist = "Ask Sash" }
    sets.precast.JA['Dodge'] = { feet = "Anchorite's Gaiters +2" }
    sets.precast.JA['Focus'] = { head = "Anchorite's Crown +1" }
    sets.precast.JA['Counterstance'] = { feet = "Hesychast's Gaiters +1" }
    sets.precast.JA['Footwork'] = { feet = "Bhikku Gaiters +3" }
    sets.precast.JA['Formless Strikes'] = { body = "Hesychast's Cyclas" }
    sets.precast.JA['Mantra'] = { feet = "Hesychast's Gaiters +1" }

    sets.precast.JA['Chi Blast'] = {
        head = "Hesychast's crown +1",
        body = "Mpaca's Doublet",
        hands = "Hesychast's Gloves +1",
        back = "Moonlight Cape",
        legs = "Hesychast's Hose +1",
        feet = "Anchorite's Gaiters +2"
    }

    sets.precast.JA['Chakra'] = {
        ammo = "Aurgelmir Orb +1",
        head = "Bhikku crown +3",
        neck = "Unmoving Collar +1",
        ear1 = "Handler's Earring +1",
        ear2 = "Tuisto's Earring",
        body = "Anchorite's Cyclas +1",
        hands = "Hesychast's Gloves +1",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gelatinous Ring +1",
        back = gear.ws_cape_vit,
        waist = "Caudata Belt",
        legs = "Bhikku Hose +3",
        feet = "Bhikku Gaiters +3"
    }

    sets.precast.JA['Provoke'] = sets.enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo = "Sonia's Plectrum",
        head = "Felistris Mask",
        body = "Mpaca's Doublet",
        hands = "Hesychast's Gloves +1",
        ring1 = "Spiral Ring",
        back = "Iximulew Cape",
        waist = "Caudata Belt",
        legs = "Qaaxo Tights",
        feet = "Mpaca's boots"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Step = { waist = "Chaac Belt" }
    sets.precast.Flourish1 = { waist = "Chaac Belt" }


    -- Fast cast sets for spells

    sets.precast.FC = {
        ammo = "Sapience Orb",
        head = gear.herculean.fc.head,
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Adhemar Jacket +1",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        legs = "Limbo Trousers"
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck = "Magoraga Beads" })


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS                   = {
        ammo = "Coiste Bodhar",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Sherida Earring",
        ear2 = "Moonshade Earring",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        ring1 = "Ephramad's Ring",
        ring2 = "Gere Ring",
        back = gear.ws_cape_str,
        waist = "Moonbow Belt +1",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots"
    }
    sets.precast.WSAcc                = {
        ammo = "Knobkierrie",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Sherida Earring",
        ear2 = "Moonshade Earring",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        ring1 = "Regal Ring",
        ring2 = "Ephramad's Ring",
        back = gear.tp_cape,
        waist = "Fotia Belt",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots"
    }

    sets.precast.WSCrit               = {
        ammo = "Knobkierrie",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Odr Earring",
        ear2 = "Moonshade Earring",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        ring2 = "Begrudging Ring",
        ring1 = "Regal Ring",
        back = gear.tp_cape,
        waist = "Fotia Belt",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots"
    }
    sets.precast.MaxTP                = { ear1 = "Brutal Earring", ear2 = "Crepuscular Earring" }
    sets.precast.WS.Acc               = set_combine(sets.precast.WS, sets.precast.WSAcc)
    sets.precast.WS.Mod               = set_combine(sets.precast.WS, sets.precast.WSMod)

    -- Specific weaponskill sets.

    -- legs={name="Quiahuiz Trousers", augments={'Phys. dmg. taken -2%','Magic dmg. taken -2%','STR+8'}}}

    sets.precast.WS['Raging Fists']   = set_combine(sets.precast.WS, {
        ammo = "Crepuscular Pebble",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Schere Earring",
        body = "Bhikku Cyclas +3",
        hands = "Bhikku Gloves +3",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gere Ring",
        back = gear.ws_cape_vit,
        waist = "Moonbow belt +1",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots"

    }) -- TP = Damage, fTP replicating
    sets.precast.WS['Howling Fist']   = set_combine(sets.precast.WS,
        {
            ammo = "Crepuscular Pebble",
            head = "Mpaca's Cap",
            neck = "Fotia Gorget",
            ear1 = "Moonshade earring",
            ear2 = "Schere Earring",
            body = "Nyame Mail",
            hands = "Nyame Gauntlets",
            ring1 = "Niqmaddu Ring",
            ring2 = "Gere Ring",
            back = gear.ws_cape_vit,
            waist = "Moonbow Belt +1",
            legs = "Mpaca's Hose",
            feet = "Nyame Sollerets"
        })                                                                -- fTP replicating, decent fTP bonus from TP
    sets.precast.WS['Asuran Fists']   = set_combine(sets.precast.WS,
        { ear1 = "Etiolation Earring", ring1 = "Niqmaddu ring" })         -- Multi-hit max attack rounds
    sets.precast.WS["Ascetic's Fury"] = set_combine(sets.precast.WSCrit,
        { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" }) -- Attack boost


    sets.precast.WS["Victory Smite"]      = set_combine(sets.precast.WSCrit, {
        ammo = "Coiste Bodhar",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Sherida Earring",
        ear2 = "Schere Earring",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        ring1 = "Niqmaddu Ring",
        ring2 = "Ephramad's Ring",
        back = gear.ws_cape_str,
        waist = "Moonbow Belt +1",
        legs = "Mpaca's Hose",
        feet = "Mpaca's Boots"
    }) -- Crit WS, STR80

    sets.precast.WS['Shijin Spiral']      = set_combine(sets.precast.WS, {
        ammo = "Coiste Bodhar",
        head = "Mpaca's Cap",
        neck = "Fotia Gorget",
        ear1 = "Sherida Earring",
        ear2 = "Schere Earring",
        body = "Bhikku Cyclas +3",
        hands = "Bhikku gloves +3",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gere Ring",
        back = gear.tp_cape
    }) -- 5hit attack, DEX73-85
    sets.precast.WS['Dragon Kick']        = set_combine(sets.precast.WS, {
        ammo = "Crepuscular Pebble",
        head = "Mpaca's Cap",
        neck = "Republican Platinum medal",
        ear1 = "Moonshade Earring",
        ear2 = "Schere Earring",
        body = "Nyame Mail",
        hands = "Bhikku Gloves +3",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gere Ring",
        back = gear.ws_cape_str,
        waist = "Moonbow Belt +1",
        legs = "Mpaca's Hose",
        feet = "Anchorite's Gaiters +2"
    })                                                                                                -- Kick attack WS, TP=Damage?
    sets.precast.WS['Tornado Kick']       = set_combine(sets.precast.WS['Dragon Kick'], {})           -- Kick attack WS, 3fold, tpReplicating, TP=Damage
    sets.precast.WS['Spinning Attack']    = set_combine(sets.precast.WS, { ring1 = "Niqmaddu ring" }) -- TP=Range, STR100

    sets.precast.WS["Raging Fists"].Acc   = set_combine(sets.precast.WSAcc, sets.precast.WS["Raging Fists"])
    sets.precast.WS["Howling Fist"].Acc   = set_combine(sets.precast.WSAcc, sets.precast.WS["Howling Fist"])
    sets.precast.WS["Asuran Fists"].Acc   = set_combine(sets.precast.WSAcc, sets.precast.WS["Asuran Fists"])
    sets.precast.WS["Ascetic's Fury"].Acc = set_combine(sets.precast.WSAcc, sets.precast.WS["Ascetic's Fury"])
    sets.precast.WS["Victory Smite"].Acc  = set_combine(sets.precast.WSAcc, sets.precast.WS["Victory Smite"])
    sets.precast.WS["Shijin Spiral"].Acc  = set_combine(sets.precast.WSAcc, sets.precast.WS["Shijin Spiral"])
    sets.precast.WS["Dragon Kick"].Acc    = set_combine(sets.precast.WSAcc, sets.precast.WS["Dragon Kick"])
    sets.precast.WS["Tornado Kick"].Acc   = set_combine(sets.precast.WSAcc, sets.precast.WS["Tornado Kick"])

    sets.precast.WS["Raging Fists"].Mod   = set_combine(sets.precast.WSMod, sets.precast.WS["Raging Fists"])
    sets.precast.WS["Howling Fist"].Mod   = set_combine(sets.precast.WSMod, sets.precast.WS["Howling Fist"])
    sets.precast.WS["Asuran Fists"].Mod   = set_combine(sets.precast.WSMod, sets.precast.WS["Asuran Fists"])
    sets.precast.WS["Ascetic's Fury"].Mod = set_combine(sets.precast.WSMod, sets.precast.WS["Ascetic's Fury"])
    sets.precast.WS["Victory Smite"].Mod  = set_combine(sets.precast.WSMod, sets.precast.WS["Victory Smite"])
    sets.precast.WS["Shijin Spiral"].Mod  = set_combine(sets.precast.WSMod, sets.precast.WS["Shijin Spiral"])
    sets.precast.WS["Dragon Kick"].Mod    = set_combine(sets.precast.WSMod, sets.precast.WS["Dragon Kick"])
    sets.precast.WS["Tornado Kick"].Mod   = set_combine(sets.precast.WSMod, sets.precast.WS["Tornado Kick"])


    sets.precast.WS['Shell Crusher'] = {
        ammo = "Pemphredo Tathlum",
        head = "Bhikku Crown +3",
        neck = "Moonlight Necklace",
        ear1 = "Dignitary's Earring",
        ear2 = "Crepuscular Earring",
        body = "Bhikku Cyclas +3",
        hands = "Bhikku Gloves +3",
        ring1 = "Stikini Ring +1",
        ring2 = "Metamorph Ring +1",
        back = gear.tp_cape,
        waist = "Acuity Belt +1",
        legs = "Bhikku Hose +3",
        feet = "Bhikku Gaiters +3"
    }

    sets.precast.WS['Earth Crusher'] = {
        ammo = "Knobkierrie",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Metamorph Ring +1",
        ring2 = "Epaminondas's Ring",
        back = gear.ws_cape_str,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS['Cataclysm'] = {
        ammo = "Knobkierrie",
        head = "Pixie Hairpin +1",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Metamorph Ring +1",
        ring2 = "Archon Ring",
        back = gear.ws_cape_str,
        waist = gear.ElementalObi,
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }



    -- Midcast Sets
    sets.midcast.FastRecast = {
        ammo = "Staunch Tathlum +1",
        head = "Herculean Helm",
        ear2 = "Loquacious Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Rahab Ring",
        waist = "Black Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, { neck = "Magoraga Bead Necklace" })


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        head = "Ocelomeh Headpiece +1",
        neck = "Combatant's Torque",
        body = "Hesychast's Cyclas",
        ring1 = "Sheltered Ring",
        ring2 = "Defending Ring"
    }


    -- Idle sets
    sets.idle = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Tuisto Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = "Shneddick Ring +1",
        back = gear.ws_cape_vit,
        waist = "Audumbla Sash",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Town = {
        ammo = "Staunch Tathlum +1",
        head = "Shaded Specatles",
        neck = "Smithy's Torque",
        ear1 = "Infused Earring",
        ear2 = "Odnowa Earring +1",
        body = "Blacksmith's Smock",
        hands = "Smithy's Mitts",
        ring1 = "Confectioner's Ring",
        ring2 = "Shneddick Ring +1",
        back = "Iximulew Cape",
        waist = "Black Belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Weak = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Eabani Earring",
        ear2 = "Infused Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Sheltered Ring",
        ring2 = "Shneddick Ring +1",
        back = "Iximulew Cape",
        waist = "Black Belt",
        legs = "Malignance Tights",
        feet = "Nyame Sollerets"
    }

    -- Defense sets
    sets.defense.PDT = {
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Brutal Earring",
        ear2 = "Crepuscular Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Defending Ring",
        ring2 = "Epona's Ring",
        back = gear.tp_cape,
        waist = "Moonbow belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.HP = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Eabani Earring",
        ear2 = "Odnowa Earring +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Gelatinous Ring +1",
        ring2 = gear.right_moonlight,
        back = "Moonlight Cape",
        waist = "Platinum Moogle belt",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = set_combine(sets.defense.PDT, { ear1 = "Eabani Earring", ring2 = "Archon Ring" })

    sets.Kiting = { feet = "Hermes' Sandals" }

    sets.ExtraRegen = {}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee sets
    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Bhikku Crown +3",
        neck = "Anu Torque",
        ear1 = "Sherida Earring",
        ear2 = "Mache Earring +1",
        body = "Mpaca's Doublet",
        hands = "Mpaca's Gloves",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gere Ring",
        back = gear.tp_cape,
        waist = "Moonbow Belt +1",
        legs = "Bhikku Hose +3",
        feet = "Mpaca's Boots"
    }
    sets.engaged.Acc = {
        ammo = "Voluspa Tathlum",
        head = "Malignance Chapeau",
        neck = "Combatant's Torque",
        ear1 = "Sherida Earring",
        ear2 = "Mache Earring +1",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gere Ring",
        back = gear.tp_cape,
        waist = "Moonbow belt +1",
        legs = "Tatenashi Haidate +1",
        feet = "Tatenashi Sune-ate +1"
    }

    sets.engaged.Impetus = set_combine(sets.engaged, { body = "Bhikku Cyclas +3" })
    -- sets.engaged.Impetus = set_combine(sets.engaged.Impetus, { feet = "Anchorite's Gaiters +2" })

    -- Defensive melee hybrid sets
    sets.engaged.PDT = {
        ammo = "Staunch Tathlum +1",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        ear1 = "Sherida Earring",
        ear2 = "Schere Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Niqmaddu Ring",
        ring2 = "Gere Ring",
        back = gear.tp_cape,
        waist = "Moonbow belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.engaged.Acc.PDT = set_combine(sets.engaged.PDT, {})

    sets.engaged.Counter = set_combine(sets.engaged, {})
    sets.engaged.Acc.Counter = set_combine(sets.engaged.Acc, {})


    -- Hundred Fists/Impetus melee set mods
    sets.engaged.HF = set_combine(sets.engaged, {})
    sets.engaged.HF.Impetus = set_combine(sets.engaged, { body = "Bhikku Cyclas +3" })
    sets.engaged.Acc.HF = set_combine(sets.engaged.Acc)
    sets.engaged.Acc.HF.Impetus = set_combine(sets.engaged.Acc, { body = "Bhikku Cyclas +3" })
    sets.engaged.Counter.HF = set_combine(sets.engaged.Counter)
    sets.engaged.Counter.HF.Impetus = set_combine(sets.engaged.Counter, { body = "Bhikku Cyclas +3" })
    sets.engaged.Acc.Counter.HF = set_combine(sets.engaged.Acc.Counter)
    sets.engaged.Acc.Counter.HF.Impetus = set_combine(sets.engaged.Acc.Counter, { body = "Bhikku Cyclas +3" })


    -- Footwork combat form
    sets.engaged.Footwork = set_combine(sets.engaged, { feet = "Anchorite's Gaiters +2" })
    sets.engaged.Footwork.Acc = set_combine(sets.engaged.Acc, {})
    sets.engaged.Footwork.Impetus = set_combine(sets.engaged, {
        feet = "Anchorite's Gaiters +2",
        body =
        "Bhikku Cyclas +3"
    })

    -- Quick sets for post-precast adjustments, listed here so that the gear can be Validated.
    sets.impetus_body = { body = "Bhikku Cyclas +3" }
    sets.footwork_kick_feet = { feet = "Anchorite's Gaiters +2" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Don't gearswap for weaponskills when Defense is on.
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        eventArgs.handled = true
    end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        if state.Buff.Impetus and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
            -- Need 6 hits at capped dDex, or 9 hits if dDex is uncapped, for Bhikku to tie or win.
            if (state.OffenseMode.current == 'Fodder' and info.impetus_hit_count > 5) or (info.impetus_hit_count > 8) then
                equip(sets.impetus_body)
            end
        elseif state.Buff.Footwork and (spell.english == "Dragon's Kick" or spell.english == "Tornado Kick") then
            equip(sets.footwork_kick_feet)
        end
    end

    if (spell.english == "Spinning Attack" or spell.english == "Cataclysm") and state.SpinningTHTag.value == 'Once' then
        windower.add_to_chat(144, 'Treasure Hunter spinning attack!')
        equip(sets.TreasureHunter)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- if spell.type == 'WeaponSkill' and not spell.interrupted and state.FootworkWS and state.Buff.Footwork then
    --     send_command('cancel Footwork')
    -- end


    if spell.english == 'Impetus' or buffactive['Impetus'] then equip(sets.Buff["Impetus"]) end

    if S { 'Spinning Attack', 'Cataclysm' }:contains(spell.english) and not spell.interrupted then
        state.SpinningTHTag:set('Disabled')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Set Footwork as combat form any time it's active and Hundred Fists is not.
    if buff == 'Footwork' and gain and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    elseif buff == "Hundred Fists" and not gain and buffactive.footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end

    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Hundred Fists" or buff == "Impetus" then
        classes.CustomMeleeGroups:clear()

        if (buff == "Hundred Fists" and gain) or buffactive['hundred fists'] then
            classes.CustomMeleeGroups:append('HF')
        end

        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
    end

    -- Update gear if any of the above changed
    if buff == "Hundred Fists" or buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if player.hpp < 75 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_combat_form()
    update_melee_groups()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if buffactive.footwork and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()

    if buffactive['hundred fists'] then
        classes.CustomMeleeGroups:append('HF')
    end

    if buffactive.impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Custom event hooks.
-------------------------------------------------------------------------------------------------------------------

-- Keep track of the current hit count while Impetus is up.
function on_action_for_impetus(action)
    if state.Buff.Impetus then
        -- count melee hits by player
        if action.actor_id == player.id then
            if action.category == 1 then
                for _, target in pairs(action.targets) do
                    for _, action in pairs(target.actions) do
                        -- Reactions (bitset):
                        -- 1 = evade
                        -- 2 = parry
                        -- 4 = block/guard
                        -- 8 = hit
                        -- 16 = JA/weaponskill?
                        -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 1
                        end
                    end
                end
            elseif action.category == 3 then
                -- Missed weaponskill hits will reset the counter.  Can we tell?
                -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
                -- Can't tell if any hits were missed, so have to assume all hit.
                -- Increment by the minimum number of weaponskill hits: 2.
                for _, target in pairs(action.targets) do
                    for _, action in pairs(target.actions) do
                        -- This will only be if the entire weaponskill missed or was parried.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 2
                        end
                    end
                end
            end
        elseif action.actor_id ~= player.id and action.category == 1 then
            -- If mob hits the player, check for counters.
            for _, target in pairs(action.targets) do
                if target.id == player.id then
                    for _, action in pairs(target.actions) do
                        -- Spike effect animation:
                        -- 63 = counter
                        -- ?? = missed counter
                        if action.has_spike_effect then
                            -- spike_effect_message of 592 == missed counter
                            if action.spike_effect_message == 592 then
                                info.impetus_hit_count = 0
                            elseif action.spike_effect_animation == 63 then
                                info.impetus_hit_count = info.impetus_hit_count + 1
                            end
                        end
                    end
                end
            end
        end

        --add_to_chat(123,'Current Impetus hit count = ' .. tostring(info.impetus_hit_count))
    else
        info.impetus_hit_count = 0
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book

    if player.sub_job == 'DNC' then
        set_macro_page(2, 2)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 2)
    else
        set_macro_page(4, 2)
    end

    send_command('@wait 5; input /lockstyleset 8')
end
