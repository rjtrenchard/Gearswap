-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.


    Configuration commands:

    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.

    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.

    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.

    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M { ['description'] = 'Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step' }
    state.AltStep = M { ['description'] = 'Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step' }
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M { ['description'] = 'Current Step', 'Main', 'Alt' }
    state.SkillchainPending = M(false, 'Skillchain Pending')

    determine_haste_group()
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
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')
    state.IdleMode:options('Normal', 'Regain', 'PDT')

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    -- send_command('bind ^` input /ja "Chocobo Jig" <me>')
    -- send_command('bind !` input /ja "Chocobo Jig II" <me>')

    send_command('bind numpad1 input /ja "Curing Waltz III"')
    send_command('bind numpad2 input /ja "Curing Waltz V"')
    send_command('bind numpad3 input /ja "Contradance"')

    send_command('bind numpad4 input /ja "Divine Waltz II')
    send_command('bind numpad5 input /ja "Healing Waltz"')

    send_command('bind numpad7 gs c equip sets.weapons.normal')
    send_command('bind numpad8 gs c equip sets.weapons.TP')

    info.WaltzCosts = {
        ["Curing Waltz"] = 200,
        ["Divine Waltz"] = 400,
        ["Curing Waltz II"] = 350,
        ["Healing Waltz"] = 200,
        ["Curing Waltz III"] = 500,
        ["Curing Waltz IV"] = 650,
        ["Divine Waltz II"] = 800,
        ["Curing Waltz V"] = 800
    }

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
    unbind_numpad()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    gear.tp_cape = { name = "Senuna's Mantle", augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10', 'Phys. dmg. taken-10%' } }
    gear.ws_cape_dex = { name = "Senuna's Mantle", augments = { 'DEX+20', 'Accuracy+20 Attack+20', 'Weapon skill damage +10%', 'Phys. dmg. taken-10%', } }

    sets.weapons = {}
    sets.weapons.normal = {
        main = "Mpu Gandring",
        sub = "Crepuscular Knife"
    }

    sets.weapons.TP = {
        main = "Mpu Gandring",
        sub = "Centovente"
    }

    sets.resist = {}
    sets.resist.death = {
        main = "Odium",
        body = "Samnuha Coat",
        ring1 = "Shadow Ring",
        ring2 = "Eihwaz Ring"
    }

    sets.enmity = {
        ammo = "Sapience Orb",
        head = "Halitus Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Trux Earring",
        ear2 = "Cryptic Earring",
        body = "Emet Harness +1",
        hands = "Kurys Gloves",
        ring1 = "Supershear Ring",
        ring2 = "Eihwaz Ring",
        -- back = "",
        waist = "Trance Belt",
        legs = "Zoar Subligar +1",
        feet = "Ahosi Leggings",
    }

    sets.TreasureHunter = {
        ammo = "Perfect Lucky egg",
        waist = "Chaac belt",
        legs = "Volte Hose",
        feet = "Volte Boots"
    }

    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = { body = "Horos Casaque +1" }

    sets.precast.JA['Trance'] = { head = "Horos Tiara +1" }


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        ammo = "Brigantia Pebble",
        head = "Horos Tiara +1",
        neck = "Etoile Gorget +2",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Handler's Earring +1",
        body = "Maxixi Casaque +1",
        hands = "Maculele Bangles +3",
        ring1 = "Metamorth Ring +1",
        ring2 = "Defending Ring",
        back = gear.tp_cape,
        waist = "Chaac Belt",
        legs = "Dashing Subligar",
        feet = "Maxixi Toe Shoes +1"
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Samba = { head = "Maxixi Tiara +1" }

    sets.precast.Jig = { legs = "Horos Tights +1", feet = "Maxixi Toe Shoes +1" }

    sets.precast.Step = {
        ammo = "Cath Palug Stone",
        head = "Maxixi Tiara +1",
        neck = "Etoile Gorget +2",
        ear1 = "Odr Earring",
        ear2 = "Maculele Earring +2",
        body = "Horos Casaque +1",
        hands = "Maxixi Bangles +1",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.dex_cape,
        waist = "Kentarch Belt +1",
        legs = "Maculele Tights +3",
        feet = "Horos Toe Shoes +1"
    }
    sets.precast.Step['Feather Step'] = { feet = "Maculele Toe Shoes +3" }

    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Animated Flourish'] = sets.enmity
    sets.precast.Flourish1['Violent Flourish'] = {
        ear1 = "Dignitary's Earring",
        ear2 = "Maculele Earring +2",
        body = "Horos Casaque +1",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        waist = "Chaac Belt",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    } -- magic accuracy
    sets.precast.Flourish1['Desperate Flourish'] = {
        ammo = "Cath Palug Stone",
        head = "Maculele Tiara +3",
        neck = "Etoile Gorget +2",
        body = "Horos Casaque +1",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_chirich,
        ring2 = gear.right_chirich,
        back = gear.tp_cape,
        waist = "Kentarch Belt +1",
        legs = "Maculele Tights +3",
        feet = "Maculele Toe Shoes +3"
    } -- acc gear

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {
        hands = "Maculele Bangles +3",
        back = gear.tp_cape,
    }

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = { body = "Maculele Casaque +3" }
    sets.precast.Flourish3['Climactic Flourish'] = { head = "Maculele Tiara +3" }

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
        -- ring2 = "Rahab Ring",
        legs = "Limbo Trousers",
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo = "Coiste Bodhar",
        head = "Maculele Tiara +3",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Maculele earring +2",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Regal Ring",
        back = gear.ws_cape_dex,
        waist = "Gerdr Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, { ammo = "Yamarang", back = gear.tp_cape })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        ammo = "Coiste Bodhar",
        ring1 = "Ilabrat Ring",
        ring2 = "Regal Ring",
        waist = "Fotia Belt",
    })
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'],
        { ammo = "Yamarang", })
    -- sets.precast.WS['Exenterator'].Fodder = set_combine(sets.precast.WS['Exenterator'], { waist = gear.ElementalBelt })

    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, { hands = "Adhemar Wristbands +1" })
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS.Acc, { hands = "Adhemar Wristbands +1" })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo = "Coiste Bodhar",
        head = "Blistering Sallet +1",
        ear1 = "Sherida Earring",
        ear2 = "Odr Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Ephramad's Ring",
        ring2 = "Begrudging Ring",
        back = gear.ws_cape_dex,
        waist = "Gerdr Belt +1",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots"
    })
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'],
        {})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS,
        { ammo = "Crepuscular Pebble" })
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"],
        { ammo = "Yamarang", })

    sets.precast.WS['Aeolian Edge'] = {
        ammo = "Ghastly Tathlum +1",
        head = "Nyame Helm",
        neck = "Sibyl Scarf",
        ear1 = "Friomisi Earring",
        ear2 = "Moonshade Earring",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = "Epaminondas's Ring",
        ring2 = "Ilabrat Ring",
        back = "Toro Cape",
        waist = "Orpheus's Sash",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.precast.WS['Ruthless Stroke'] = set_combine(sets.precast.WS, {
        ammo = "Coiste Bodhar",
        -- hands = "Maxixi Bangles +1"
    })

    sets.precast.Skillchain = { hands = "Maculele Bangles +3" }


    -- Midcast Sets

    sets.midcast.FastRecast = {
        ammo = "Sapience Orb",
        head = "Malginance Chapeau",
        neck = "Orunmila's Torque",
        ear1 = "Enchanter's Earring +1",
        ear2 = "Loquacious Earring",
        body = "Malignance Tabard",
        hands = "Leyline Gloves",
        ring1 = "Rahab Ring",
        ring2 = "Rahab Ring",
        back = "",
        waist = "Sailfi belt +1",
        legs = "Malginance Tights",
        feet = "Malignance Boots"
    }

    -- Specific spells
    sets.midcast.Utsusemi = {
        head = "Adhemar Bonnet +1",
        ear2 = "Loquacious Earring",
        body = "Iuitl Vest",
        hands = "Adhemar Wristbands +1",
        ring1 = "Beeline Ring",
        back = gear.tp_cape,
        legs = "Kaabnax Trousers",
        feet = "Malignance Boots"
    }


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        head = "Ocelomeh Headpiece +1",
        neck = "Combatant's Torque",
        ring1 = "Sheltered Ring",
        ring2 = "Defending Ring"
    }
    sets.ExtraRegen = { head = "Ocelomeh Headpiece +1" }


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
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.idle.Town = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Anu Torque",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Sheltered Ring",
        ring2 = "Shneddick Ring +1",
        back = "Atheling Mantle",
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.idle.Regain = {
        ammo = "Aurgelmir Orb +1",
        head = "Gleti's Mask",
        neck = "Republican Platinum medal",
        ear1 = "Telos Earring",
        ear2 = "Dedition Earring",
        body = "Gleti's Cuirass",
        hands = "Gleti's Gauntlets",
        ring1 = "Roller's Ring",
        ring2 = "Defending Ring",
        back = gear.tp_cape,
        waist = "Reiki Yotai",
        legs = "Gleti's Breeches",
        feet = "Gleti's Boots"
    }

    sets.idle.Weak = sets.idle
    -- Defense sets

    sets.defense.Evasion = {
        head = "Malignance Chapeau",
        neck = "Bathy Choker +1",
        ear1 = "Eabani Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = gear.left_moonlight,
        ring2 = "Gelatinous Ring +1",
        back = gear.tp_cape,
        waist = "Flume Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    sets.defense.PDT = {
        ammo = "Brigantia Pebble",
        head = "Nyame Helm",
        neck = "Loricate Torque +1",
        body = "Nyame Mail",
        hands = "Nyame Gauntlets",
        ring1 = gear.left_moonlight,
        ring2 = "Gelatinous Ring +1",
        back = "Moonlight Cape",
        waist = "Flume Belt +1",
        legs = "Nyame Flanchard",
        feet = "Nyame Sollerets"
    }

    sets.defense.MDT = set_combine(sets.defense.PDT,
        { ear1 = "Eabani Earring", ear2 = "Eabani Earring", ring2 = 'Archon Ring', waist = "Platinum Moogle Belt" })

    -- sets.Kiting = { feet = "Skadi's Jambeaux +1" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        ammo = "Coiste Bodhar",
        head = "Malignance Chapeau",
        neck = "Anu Torque",
        ear1 = "Sherida Earring",
        ear2 = "Maculele Earring +2",
        body = "Gleti's Cuirass",
        hands = "Malignance Gloves",
        ring1 = gear.left_moonlight,
        ring2 = "Gere Ring",
        back = gear.tp_cape,
        waist = "Sailfi Belt +1",
        legs = "Gleti's Breeches",
        feet = "Maculele Toe Shoes +3"
    }

    sets.engaged.Acc = {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        neck = "Anu Torque",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Maculele Casaque +3",
        hands = "Adhemar Wristbands +1",
        ring1 = "Rajas Ring",
        ring2 = "Epona's Ring",
        back = gear.tp_cape,
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Evasion = {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        neck = "Bathy Choker +1",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Gleti's Cuirass",
        hands = "Adhemar Wristbands +1",
        ring1 = "Beeline Ring",
        ring2 = "Epona's Ring",
        back = gear.tp_cape,
        waist = "Reiki Yotai",
        legs = "Kaabnax Trousers",
        feet = "Malignance Boots"
    }
    sets.engaged.PDT = {
        ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau",
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Malignance Tabard",
        hands = "Malignance Gloves",
        ring1 = "Patricius Ring",
        ring2 = "Epona's Ring",
        back = "Moonlight Cape",
        waist = "Reiki Yotai",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Acc.Evasion = {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        neck = "Bathy Choker +1",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Gleti's Cuirass",
        hands = "Adhemar Wristbands +1",
        ring1 = "Beeline Ring",
        ring2 = "Epona's Ring",
        back = gear.tp_cape,
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }
    sets.engaged.Acc.PDT = {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Brutal Earring",
        body = "Gleti's Cuirass",
        hands = "Adhemar Wristbands +1",
        ring1 = "Patricius Ring",
        ring2 = "Epona's Ring",
        back = gear.tp_cape,
        waist = "Sailfi Belt +1",
        legs = "Malignance Tights",
        feet = "Malignance Boots"
    }

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = { legs = "Horos Tights +1" }
    sets.buff['Climactic Flourish'] = { head = "Maculele Tiara +3" }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- function filtered_action(spell)
--     print('Filtered action: ' .. spell.english)
-- end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Waltz' and buffactive['Saber Dance'] then
        send_command('cancel "saber dance"')
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'Waltz' and spell.english ~= "Healing Waltz" then
        local tp_cost = info.WaltzCosts[spell.english]
        if player.tp < tp_cost then
            -- get next spell
            local next_tier = numeral_to_digit(get_spell_tier(spell)) - 1
            if next_tier > 0 then
                eventArgs.cancel = true
                local base_spell = get_spell_base(spell) .. " " .. spell.type
                send_command("input /ja " .. base_spell .. " " .. digit_to_numeral(next_tier - 1))
            else
                windower.add_to_chat(144, "Not enough TP!")
            end
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end

-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- if not spell.interrupted then
    -- if spell.english == "Wild Flourish" then
    -- state.SkillchainPending:set()
    -- send_command('wait 5;gs c unset SkillchainPending')
    --     elseif spell.type == "WeaponSkill" then
    --         -- state.SkillchainPending:toggle()
    --         -- send_command('wait 6;gs c unset SkillchainPending')
    --     end
    -- end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S { 'haste', 'march', 'embrava', 'haste samba' }:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end

function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end

function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end

    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
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
        msg = msg ..
            ', ' ..
            'Defense: ' ..
            state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', [' .. state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/' .. state.AltStep.current
    end

    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps .. ' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current .. 'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end

        send_command('@input /ja "' .. doStep .. '" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Maculele body, Maculele neck + DW earrings, and Reiki Yotai.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff

    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()

    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end

-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and
            not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(3, 19)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 19)
    elseif player.sub_job == 'SAM' then
        set_macro_page(2, 19)
    else
        set_macro_page(5, 19)
    end
    send_command('@wait 5; input /lockstyleset 15')
end
