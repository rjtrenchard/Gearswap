require('natty_helper_data.lua')
res = require('resources')

local MAX_MAGIC_HASTE = 448 / 1024 * 100
local MIN_MAGIC_HASTE = -0.5 * 100
local MAX_JOB_HASTE = 256 / 1024 * 100
local MAX_TOTAL_HASTE = 0.8 * 100

local MIN_OSASH_USE = 2 -- switch to osash if we get 2 affinity or more

---------------------------------------------
-- Recast functions
---------------------------------------------

-- initializes weapon recast handler
function init_recast()
    sets._Recast = sets._Recast or {}
    info._RecastFlag = false
end

-- sets the Recast weapon set to what is currently equipped
-- affected slots: main sub ranged ammo
-- passing a string naming that slot will disable the slot for recall
-- ie, set_recast('main') would ignore the main slot
function set_recast(...)
    -- if has_recast() then return end

    local e_main = true
    local e_sub = true
    local e_range = true
    local e_ammo = true

    sets._next = {}

    for k, v in ipairs(arg) do
        if tostring(v) == 'main' then
            e_main = false
        elseif tostring(v) == 'sub' then
            e_sub = false
        elseif tostring(v) == 'range' then
            e_range = false
        elseif tostring(v) == 'ammo' then
            e_ammo = false
        end
    end

    if e_main then
        sets._Recast.main = player.equipment.main
        sets._next.main = player.equipment.main
    end
    if e_sub then
        sets._Recast.sub = player.equipment.sub
        sets._next.sub = player.equipment.sub
    end
    if e_range then
        sets._Recast.range = player.equipment.range
        sets._next.range = player.equipment.range
    end
    if e_ammo then
        sets._Recast.ammo = player.equipment.ammo
        sets._next.ammo = player.equipment.ammo
    end

    info._RecastFlag = (sets._Recast.main or sets._Recast.sub or sets._Recast.range or sets._Recast.ammo) or false
end

function set_recast_from_table(arg)
    if can_DW() and sets.weapons[arg] and sets.weapons[arg].DW then
        sets._Recast = sets.weapons[arg].DW
    else
        sets._Recast = sets.weapons[arg]
    end
end

function update_recast(gearset)
    local tbl = sets.weapons

    for str in gearset:gmatch("%w+") do
        next = tbl[str]
    end
    -- print("updating recast for ", gearset)

    if can_DW() and tbl[DW] then
        print("Recast has Dual Wield")
        tbl = tbl[DW]
    end



    sets._Recast = tbl
end

-- resets the Recast weapon set to nil
function reset_recast()
    -- sets._Recast = { main = nil, sub = nil, range = nil, ammo = nil }
    -- info._RecastFlag = false
end

-- returns the Recast weapon set
function recall_recast()
    return sets._Recast
end

-- returns true if the recast set has been used
function has_recast()
    return info._RecastFlag
end

function equip_recast()
    if has_recast() then
        equip(recall_recast())
        -- reset_recast()
    end
end

function next_recast_weapon()
    return sets._next and sets._next.main
end

function next_recast_sub()
    return sets._next and sets._next.sub
end

function next_recast_range()
    return sets._next and sets._next.range
end

function next_recast_ammo()
    return sets._next and sets._next.ammo
end

---------------------------------------------
-- Utsusemi functions
---------------------------------------------

function get_copy_image()
    if buffactive['Copy Image'] then
        return 'Copy Image'
    elseif buffactive['Copy Image (1)'] then
        return 'Copy Image (1)'
    elseif buffactive['Copy Image (2)'] then
        return 'Copy Image (2)'
    elseif buffactive['Copy Image (3)'] then
        return 'Copy Image (3)'
    elseif buffactive['Copy Image (4+)'] then
        return 'Copy Image (4+)'
    else
        return nil
    end
end

function has_copy_image()
    return (buffactive['Copy Image'] or buffactive['Copy Image (1)'] or buffactive['Copy Image (2)'] or
        buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] or 0) > 0
end

function cancel_copy_image()
    if has_copy_image() then
        send_command('cancel ' .. get_copy_image())
    end
end

---------------------------------------------
-- Dual Wield functions
---------------------------------------------

-- true if sub slot is not a shield or a grip.
function equipped_DW()
    local special_names = S {
        'Khonsu',
        'Aegis',
        'Ochain',
        'Duban',
        'Ageist',
        'Mandraguard',
        'Regis',
        'Troth',
        'Pelte',
        'Clipeus',
        'Ancile',
        'Adamas',
        'Ajax',
        'Ajax +1',
        'Culminus',
        'Deliverance',
        'Deliverance +1',
        'Evalach',
        'Evalach +1',
        'Kaidate',
        'Priwen',
        'Srivatsa',
        'Svalinn',
        'Kupayopl',
    }
    return player and not
        (player.equipment.sub == 'empty'
            or special_names:contains(player.equipment.sub)
            or player.equipment.sub:endswith('Strap')
            or player.equipment.sub:endswith('Strap +1')
            or player.equipment.sub:endswith('Grip')
            or player.equipment.sub:endswith('Grip +1')
            or player.equipment.sub:endswith('Shield')
            or player.equipment.sub:endswith('Shield -1')
            or player.equipment.sub:endswith('Shield +1')
            or player.equipment.sub:endswith('Aspis')
            or player.equipment.sub:endswith('Aspis -1')
            or player.equipment.sub:endswith('Aspis +1')
            or player.equipment.sub:endswith('Buckler')
            or player.equipment.sub:endswith('Buckler +1')
            or player.equipment.sub:endswith('Buckler -1')
            or player.equipment.sub:endswith('Bulwark')
            or player.equipment.sub:endswith('Bulwark -1')
            or player.equipment.sub:endswith('Bulwark +1')
            or player.equipment.sub:endswith('Escutcheon')
            or player.equipment.sub:endswith('Scutum')
            or player.equipment.sub:endswith('Scutum -1')
            or player.equipment.sub:endswith('Scutum +1')
            or player.equipment.sub:endswith('Ecu')
            or player.equipment.sub:endswith('Ecu -1')
            or player.equipment.sub:endswith('Ecu +1')
            or player.equipment.sub:endswith('Targe')
            or player.equipment.sub:endswith('Targe -1')
            or player.equipment.sub:endswith('Targe +1')
            or player.equipment.sub:endswith('Hoplon')
            or player.equipment.sub:endswith('Hoplon -1')
            or player.equipment.sub:endswith('Hoplon +1')
            or player.equipment.sub:endswith('Sipar')
            or player.equipment.sub:endswith('Sipar -1')
            or player.equipment.sub:endswith('Sipar +1')
            or player.equipment.sub:endswith('Guard')
            or player.equipment.sub:endswith('Guard +1'))
end

function can_DW()
    return T(windower.ffxi.get_abilities().job_traits)
        :contains(res.job_traits:with('english', 'Dual Wield').id)
end

-- when blu, calculate how much DW they have
function calculate_BLU_DW(trait_bonus)
    trait_bonus = trait_bonus or 0

    local dual_wield_tiers = T {
        [0] = 0,
        [1] = 10,
        [2] = 15,
        [3] = 25,
        [4] = 30,
        [5] = 35,
        [6] = 40,
    }
    local get_tier = function(tier, bonus)
        bonus = bonus or 0
        if tier < 1 then return 0 end
        return dual_wield_tiers[((tier + bonus) > 6) and 6 or (tier + bonus)]
    end

    -- local trait_bonus = has_trait_bonus and 1 or 0
    local player_data = windower.ffxi.get_player()
    local blu_data = nil
    local trait_points = 0

    if player_data.main_job == 'BLU' then
        blu_data = windower.ffxi.get_mjob_data().spells
    elseif player_data.sub_job == 'BLU' then
        blu_data = windower.ffxi.get_sjob_data().spells
    else
        return 0
    end

    -- tally up spells
    for v in pairs(blu_data) do
        local spell = res.spells[blu_data[v]].english
        if S { 'Animating Wail', 'Blazing Bound', 'Quad. Continuum', 'Delta Thrust', 'Mortal Ray', 'Barbed Crescent' }:contains(spell) then
            trait_points = trait_points + 4
        elseif spell == 'Molting Plumage' then
            trait_points = trait_points + 8
        end
    end

    local base_trait = 0
    if trait_points >= 24 then
        base_trait = 4 -- DW 4
    elseif trait_points >= 16 then
        base_trait = 3 -- DW 3
    elseif trait_points >= 10 then
        base_trait = 2 -- DW 2
    elseif trait_points >= 4 then
        base_trait = 1 -- DW 1
    end

    return get_tier(base_trait, trait_bonus)
end

-- calculates how much DW the player has from traits
function get_max_DW_trait(blu_trait_bonus)
    blu_trait_bonus = blu_trait_bonus or 0
    local player_data = windower.ffxi.get_player()
    local DW_trait = 0

    if player_data.main_job == 'NIN' or player_data.main_job == 'DNC' then
        return 35
    elseif player_data.main_job == 'THF' then
        return 30
    elseif player_data.main_job == 'BLU' then
        DW_trait = calculate_BLU_DW(blu_trait_bonus)
    end

    -- get subjob trait DW

    local sub_haste = 0
    if player_data.sub_job == 'NIN' then
        if player_data.sub_job_level >= 65 then
            sub_haste = 30
        elseif player_data.sub_job_level >= 45 then
            sub_haste = 25
        elseif player_data.sub_job_level >= 25 then
            sub_haste = 15
        elseif player_data.sub_job_level >= 10 then
            sub_haste = 10
        end
    elseif player_data.sub_job == 'DNC' then
        if player_data.sub_job_level >= 60 then
            sub_haste = 25
        elseif player_data.sub_job_level >= 40 then
            sub_haste = 15
        elseif player_data.sub_job_level >= 20 then
            sub_haste = 10
        end
    end

    if DW_trait > sub_haste then return DW_trait else return sub_haste end
end

-- called in job_buff_change(buff, gain)
function attack_speed_update(buff)
    buff = buff or 'haste'
    if S { 'haste', 'slow', 'haste samba', 'embrava', 'march', 'elegy', 'blitzer\'s roll' }:contains(buff:lower()) then
        set_DW_class()
        send_command('gs c update')
    end
end

function turtle_update(buff)
    if S { 'terror', 'stun', 'petrify', 'sleep', 'doom' }:contains(buff:lower()) then
        if buffactive[buff] then
            send_command('gs equip sets.defense.PDT')
        else
            send_command('gs update')
        end
    end
end

function doom_update(buff)
    if buff:lower() == 'doom' then
        if buffactive[buff] then
            if state.DoomMode.value == 'Cursna' then
                send_command('gs equip sets.buff.doom')
            elseif state.DoomMode.value == 'Holy Water' then
                send_command('gs equip sets.buff.doom.HolyWater')
            end
        else
            send_command('gs c update')
        end
    end
end

-- tallys haste amounts from buffactive
function get_haste_from_buffactive()
    local magic_haste = 0
    local debuff_slow = 0
    local job_haste = 0
    local total_haste = 0

    if buffactive.march == 1 then -- Honor
        -- assume honor march for single march song
        magic_haste = magic_haste + 16.99
    elseif buffactive.march == 2 then -- Honor + Victory
        magic_haste = magic_haste + 28.61 + 16.99
    elseif buffactive.march == 3 then -- Honor + Victory + Advancing
        magic_haste = magic_haste + 18.95 + 26.61 + 16.99
    end


    if buffactive.haste == 1 then
        -- assume haste II
        magic_haste = magic_haste + 30
    elseif buffactive.haste == 2 then
        -- cornelia active
        magic_haste = magic_haste + 30 + 20
    elseif buffactive.haste == 3 then -- multiple bubbles and haste 3, assume capped
        magic_haste = magic_haste + 30 + 20 + 20
    end

    if buffactive['Blitzer\'s Roll'] then
        magic_haste = magic_haste + 15
    end

    if buffactive.embrava then
        magic_haste = magic_haste + 25.9
    end

    if state.Buff['Haste Samba'] then
        job_haste = job_haste + 5
    end

    if state.Buff['Mighty Guard'] then
        magic_haste = magic_haste + 15
    end

    if state.Buff['Slow'] then
        debuff_slow = debuff_slow - 30 -- assume max slow 1, around 30%
    end

    if state.Buff['Elegy'] then
        debuff_slow = debuff_slow - 50
    end

    return get_total_haste(magic_haste, job_haste, debuff_slow)
end

function is_stunned()
    return buffactive and (buffactive.terror or buffactive.stun or buffactive.petrification)
end

-- calculates the total haste vs debuff
function get_total_haste(magic, job, debuff)
    -- set defaults
    local magic = magic or 0
    local debuff = debuff or 0
    local job = job or 0
    local total_magic_haste = magic - debuff
    local total_haste

    -- apply magic haste caps
    if total_magic_haste > MAX_MAGIC_HASTE then
        total_magic_haste = MAX_MAGIC_HASTE
    elseif total_magic_haste <= MIN_MAGIC_HASTE then
        total_magic_haste = MIN_MAGIC_HASTE
    end

    total_haste = total_magic_haste

    -- apply job haste cap
    if job >= MAX_JOB_HASTE then job = MAX_JOB_HASTE end

    -- calculate total combined haste
    total_haste = total_haste + job

    -- apply haste cap
    if total_haste >= MAX_TOTAL_HASTE then total_haste = MAX_TOTAL_HASTE end

    -- windower.add_to_chat(144, 'Haste amount: ' .. total_haste)
    return total_haste
end

-- returns a string based on total haste amount, assumed to have capped gear haste
function get_DW_class(total_haste)
    total_haste = total_haste or 0
    if total_haste < -30 then
        return 'SlowMaxDW'
    elseif total_haste < 0 then
        return 'SlowDW'
    elseif total_haste <= 29 then
        return 'NormalDW'
    elseif total_haste > 29 and total_haste < 43.75 then
        return 'HasteDW'
    elseif total_haste >= 43.75 then
        return 'HasteMaxDW'
    end
end

function is_healer_role()
    return S { 'WHM', 'SCH', 'RDM' }:contains(player.sub_job) or buffactive['Light Arts'] or
        buffactive['Addendum: Light']
end

-- returns WithArts, AgainstArts, or NA based on spell type and buff active
function is_with_arts(spell)
    spell = spell or nil
    if not spell then return 'NA' end

    local book = (function()
        if buffactive['Light Arts'] or buffactive['Addendum: White'] then
            return 'Light Arts'
        elseif buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
            return 'Dark Arts'
        else
            return 'NA'
        end
    end)()

    if book == 'Dark Arts' then
        if spell.type == 'BlackMagic' then
            return 'WithArts'
        elseif spell.type == 'WhiteMagic' then
            return 'AgainstArts'
        else
            return 'NA'
        end
    elseif book == 'Light Arts' then
        if spell.type == 'WhiteMagic' then
            return 'WithArts'
        elseif spell.type == 'BlackMagic' then
            return 'AgainstArts'
        else
            return 'NA'
        end
    else
        return 'NA'
    end
end

-- sets the custom melee group
function set_DW_class(custom_DW)
    if not can_DW() then return end

    if not equipped_DW() then
        state.CombatForm:reset()
        return
    end

    if custom_DW then
        if custom_DW == 'pass' then
            state.CombatForm:reset()
        else
            state.CombatForm:set(custom_DW)
        end
        return
    end

    local DW_class = get_DW_class(get_haste_from_buffactive())

    -- reset DW groups
    state.CombatForm:set(DW_class)
end

function set_tp_class()
    if player.tp == 3000 then
        classes.CustomMeleeGroups:append('FullTP')
    elseif buffactive['Aftermath'] or buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] then
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.3'] then
        classes.CustomMeleeGroups:append('AM3')
    end
end

function determine_melee_groups(custom_DW)
    -- reset groups
    classes.CustomMeleeGroups:clear()

    -- determine DW first
    set_DW_class(custom_DW)

    -- find AM class or fullTP
    set_tp_class()
end

function start_tp_ticker()
    -- only allow one ticker
    if _tp_ticker then return end


    _tp_ticker = windower.register_event('tp change', function(new_tp, old_tp)
        -- update if TP reaches or leaves 3000
        if (old_tp < 3000 and new_tp == 3000) or (old_tp == 3000 and new_tp < 3000) then
            determine_melee_groups()
            send_command('gs c update')
        end
    end)
end

function is_tp_ticker()
    return _tp_ticker ~= 0
end

function stop_tp_ticker()
    windower.unregister_event(_tp_ticker)

    print(_tp_ticker)
end

function melee_groups_to_string()
    local msg = ""
    if classes.CustomMeleeGroups:contains('SlowMaxDW') then
        msg = msg .. ' (SlowMaxDW)'
    elseif classes.CustomMeleeGroups:contains('SlowDW') then
        msg = msg .. ' (SlowDW)'
    elseif classes.CustomMeleeGroups:contains('NormalDW') then
        msg = msg .. ' (NormalDW)'
    elseif classes.CustomMeleeGroups:contains('HasteDW') then
        msg = msg .. ' (HasteDW)'
    elseif classes.CustomMeleeGroups:contains('HasteMaxDW') then
        msg = msg .. ' (HasteMaxDW)'
    end

    if classes.CustomMeleeGroups:contains('AM') then
        msg = msg .. ' (AM)'
    end
    if classes.CustomMeleeGroups:contains('AM3') then
        msg = msg .. ' (AM3)'
    end
    if classes.CustomMeleeGroups:contains('FullTP') then
        msg = msg .. ' (FullTP)'
    end

    return msg
end

-- make sure you set your initial class, or you'll be in regular melee mode upon loading the lua
init_DW_class = set_DW_class

--TODO:
function calculate_MA(delay, bonus)
    bonus = bonus or 0
    delay = delay or 480
end

-- get FC from traits
function get_FC_amount(blu_trait_bonus, RDM)
    blu_trait_bonus = blu_trait_bonus or 0

    local player_data = windower.ffxi.get_player()

    local rdm_fc = get_RDM_FC_amount()
    local blu_fc = get_BLU_FC_amount()
end

-- returns the amount of fc blu or blu sub has.
function get_BLU_FC_amount()
    local player_data = windower.ffxi.get_player()
    local blu_data = nil

    local blu_points = player_data.job_points.blu.jp_spent

    if player_data.main_job == 'BLU' then
        blu_data = windower.ffxi.get_mjob_data().spells
    elseif player_data.sub_job == 'BLU' then
        blu_data = windower.ffxi.get_sjob_data().spells
    else
        return 0
    end
end

-- returns the amount of fastcast rdm or rdm sub has.
function get_RDM_FC_amount()
    local player_data = windower.ffxi.get_player()
    if player_data.main_job == 'RDM' then
        local mj_level = player_data.main_job_level
        if mj_level >= 99 then
            local jp_level = player_data.job_points.rdm.jp_spent
            if jp_level >= 2000 then
                return 38
            elseif jp_level >= 1125 then
                return 36
            elseif jp_level >= 500 then
                return 34
            elseif jp_level >= 150 then
                return 32
            else
                return 30
            end
        elseif mj_level >= 89 then
            return 30
        elseif mj_level >= 76 then
            return 25
        elseif mj_level >= 55 then
            return 20
        elseif mj_level >= 35 then
            return 15
        elseif mj_level >= 15 then
            return 10
        end
    elseif player_data.sub_job == 'RDM' then
        local sj_level = player_data.sub_job_level
        if sj_level >= 55 then
            return 20
        elseif sj_level >= 15 then
            return 15
        elseif sj_level >= 35 then
            return 10
        end
    else
        return 0
    end
end

-- returns true if a slip debuff is active
-- send buffactive table
function has_poison_debuff()
    return buffactive and
        (((buffactive.poison or 0)
            + (buffactive['Bio'] or 0)
            + (buffactive['Dia'] or 0)
            + (buffactive['Drown'] or 0)
            + (buffactive['Shock'] or 0)
            + (buffactive['Choke'] or 0)
            + (buffactive['Frost'] or 0)
            + (buffactive['Rasp'] or 0)
            + (buffactive['Helix'] or 0)
            + (buffactive['Sublimation: Activated'] or 0)
            + (buffactive['Requiem'] or 0)
            + (buffactive['Kaustra'] or 0)
            + (buffactive['taint'] or 0)) > 0)
end

-- returns true if the player has a huge amount of attack
function has_PDL_buffs()
    return buffactive
        -- and (buffactive['Last Resort'] or buffactive['Berserk']) -- has last resort or berserk
        and (buffactive['Minuet'] and buffactive['Minuet'] >= 2) -- has two or more minuets
        and (buffactive['Chaos Roll'])                           -- has chaos roll
end

function equip_PDL_WS_set(spell)
    if sets.precast.WS[spell.english] and sets.precast.WS[spell.english].PDL then
        equip(sets.precast.WS[spell.english].PDL)
    end
end

-- Find item in equippable inventory
function has_equippable(name)
    return player.inventory[name]
        or (function(name)
            for _, wardrobe_number in ipairs({ '', '2', '3', '4', '5', '6', '7', '8' }) do
                local wardrobe = 'wardrobe' .. wardrobe_number
                if player[wardrobe] and player[wardrobe][name] then return player[wardrobe][name] end
            end
        end)()
end

--@type string
function get_spell_base(spell)
    for spellBase in spell.english:gmatch("[^%s]+") do
        return spellBase
    end
end

-- returns the tier of a given spell as a string, 1 returns an empty string
-- if include_space_flag is true, do not trim the space. It will return like " II" for "Cure II"
-- normal return will be "II" with no space
function get_spell_tier(spell, include_space_flag)
    include_space_flag = (include_space_flag and "") or "%s+"
    for spellTier in spell.english:gmatch("%s[IV]+$") do
        return spellTier:gsub(include_space_flag, "") or ""
    end
    return ""
end

function get_ninjutsu_tier(spell)
    for ninTier in spell.english:gmatch("%s%w+$") do
        return ninTier
    end
end

-- maps a roman numeral string to a numerical digit
-- anything not in the list is assume to be a first tier
function numeral_to_digit(roman_numeral)
    local tierMap = T {
        ["II"] = 2,
        ["III"] = 3,
        ["IV"] = 4,
        ["V"] = 5,
        ["VI"] = 6,
        ["VII"] = 7,
        ["VIII"] = 8,
        ["IX"] = 9,
    }
    return tierMap[roman_numeral] or 1;
end

-- maps a digit to a roman numeral string.
-- if no_space_flag is true then the string will not prepend a space on return
-- 1 or less returns an empty string
function digit_to_numeral(digit, no_space_flag)
    if digit == nil or digit < 2 then return "" end
    no_space_flag = (no_space_flag and "") or " "
    local tierMap = T {
        "",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
    }
    return no_space_flag .. tierMap[digit]
end

function digit_to_jp_num(digit, no_space_flag)
    if digit == nil or digit < 1 then return "" end
    no_space_flag = (no_space_flag and "") or ": "
    local tierMap = T {
        "Ichi",
        "Ni",
        "San",
        "Shi"
    }
    return no_space_flag .. tierMap[digit]
end

function jp_num_to_digit(jp_num)
    local tierMap = T {
        ["Ichi"] = 1,
        ["Ni"] = 2,
        ["San"] = 3,
        ["Shi"] = 4,
    }
    return tierMap[jp_num] or 1;
end

-- subtracts one tier from a spell
function send_downgraded_spell_tier(spell, eventArgs)
    local new_spell = get_spell_base(spell) .. digit_to_numeral(numeral_to_digit(get_spell_tier(spell)) - 1)
    -- if spell is the same, dont make an infinite loop
    if new_spell ~= spell.english then
        eventArgs.cancel = true
        send_command('input /ma "' .. new_spell .. '" ' .. spell.target.raw)
    end
end

function downgrade_ninjutsu_tier(spell)
    return '"' .. spell.english .. digit_to_jp_num(jp_num_to_digit(get_ninjutsu_tier(spell) - 1)) .. '"'
end

function is_spell_ready(spell)
    return windower.ffxi.get_spell_recasts()[spell.recast_id] == 0
end

function get_3D_distance(target, optional_base)
    optional_base = optional_base or player
    target = target or nil

    if not target then return -1 end
    if not optional_base then return -1 end -- player or other target not found not found

    local target_space = { x = target.x, y = target.y, z = target.z }
    local base_space = { x = optional_base.x, y = optional_base.y, z = optional_base.z }

    return math.sqrt(
        ((target_space.x - base_space.x) ^ 2) +
        ((target_space.y - base_space.y) ^ 2) +
        ((target_space.z - base_space.z) ^ 2))
end

function calculate_osash_bonus(target)
    local distance = get_3D_distance(target)

    if distance == -1 then return 1 end -- on error, just assume the worst

    -- at min/max
    if distance <= 1.93 then
        return 15
    elseif distance >= 13.00 then
        return 1
    end

    -- otherwise, return reverse scale, mostly based on assumption.
    -- https://www.desmos.com/calculator/crhqgyjbhp
    return 1 + math.floor((1400 * (14 - distance)) / 1207)
end

-- returns a trust count in party
function count_trusts()
    if windower.ffxi.get_party().alliance_leader then return 0 end
    local trust_count = 0
    for i = 1, 5, 1 do
        trust_count = trust_count +
            ((windower.ffxi.get_mob_by_target("p" .. tostring(i)) and windower.ffxi.get_mob_by_target("p" .. tostring(i)).is_npc) and 1 or 0)
    end
    return trust_count
end

-- unbinds the numpad and other common keys,
-- useful for when you have a lot of special keybinds
function unbind_numpad()
    for i = 0, 9, 1 do
        unbind_key_all_meta('numpad' .. i)
    end

    unbind_key_all_meta('numpad.')
    unbind_key_all_meta('`')
    unbind_key_all_meta('-')
    unbind_key_all_meta('=')
end

function unbind_key_all_meta(key)
    for k, metakey in ipairs({ '', '!', '^', '~', '@' }) do
        send_command('unbind ' .. metakey .. key)
    end
end

-- send a message to the game
function echo(msg, verbosity, chatmode)
    local verbosity = verbosity or 0
    local function getVerbosityLevel()
        local vlvl = 0
        if state.Verbose.value == "Normal" then
            vlvl = 0
        elseif state.Verbose.value == 'Verbose' then
            vlvl = 1
        elseif state.Verbose.value == 'Debug' then
            vlvl = 2
        end
        return vlvl
    end

    if getVerbosityLevel() >= verbosity then
        local mode = chatmode or 144
        windower.add_to_chat(mode, msg)
    end
end

-- place in job_aftercast()
function calculate_dreadspikes()
    local base = player.max_hp
    local base_absorbed = 0 -- as a percent, 20 = 20%

    -- get dread spikes bonus from JP
    local has_dreadspikes_jp_gift = windower.ffxi.get_player()['job_points']['drk']['jp_spent'] >= 1200
    if has_dreadspikes_jp_gift and player.main_job == "DRK" and player.main_job_level == 99 then
        base_absorbed = base_absorbed + 20
    end


    -- get bodypiece
    base_absorbed = base_absorbed + (function(body)
        if body == "Heath. Cuirass +3" then
            return 55
        elseif body == "Heath. Cuirass +2" then
            return 45
        elseif body == "Heath. Cuirass +1" then
            return 35
        elseif body == "Heathen's Cuirass" then
            return 25
        elseif body == 'Bale Cuirass +2' then
            return 25
        elseif body == 'Bale Cuirass +1' then
            return 12.5
        else
            return 0
        end
    end)(player.equipment.body)

    -- get main
    if player.equipment.main == "Crepuscular Scythe" then base_absorbed = base_absorbed + 50 end

    return math.floor(base * ((100 + base_absorbed) / 200))
end

function update_if_weapon(weapon)
    if (info and info.Weapons and info.Weapons.REMA and info.Weapons.Special) -- check if table exists
        and (info.Weapons.REMA + info.Weapons.Special):contains(weapon) then
        send_command('gs c update')
    end
end

function check_FullTP()
    if player.tp == 3000 and not classes.CustomMeleeGroups:contains('AM3') then
        classes.CustomMeleeGroups:clear()
        classes.CustomMeleeGroups:append("FullTP")
    elseif not classes.CustomMeleeGroups:contains('AM3') then
        classes.CustomMeleeGroups:clear()
    end
end

function is_night()
    return (world.time >= 17 * 60 or world.time < 7 * 60)
end

function job_custom_weapon_equip(arg)
    if not sets then
        print('Error: no sets yet!')
        return
    end
    if not sets.weapons then
        print('Error: no sets.weapons table')
        return
    end
    if not sets.weapons[arg] then
        print("Error: no set found: sets.weapons." .. arg)
        return
    end


    if can_DW() then
        if sets.weapons[arg] and sets.weapons[arg].DW then
            send_command('gs equip sets.weapons.' .. arg .. '.DW')
        else
            set_recast()
            send_command('gs equip sets.weapons.' .. arg)
        end
    else
        set_recast()
        send_command('gs equip sets.weapons.' .. arg)
    end

    -- update_recast(arg)
    set_recast_from_table(arg)
end

function get_pet_killer_trait(pet_name)
    return mon and mon.monster_family_killer[mon.monster_species[mon.jugpet[pet_name or 'No'] or 'No'] or 'No'] or "No"
end

function announce_pet_killer()
    local pet_name = (pet and pet.is_valid) and pet.name
    if pet_name then
        windower.add_to_chat(144, "Using " .. get_pet_killer_trait(pet_name) .. " Killer.")
    end
end

-- put in filtered_action for easy stratagem handling.
function agnostic_stratagems(spell)
    if spell.type ~= 'Scholar' then return end
    local light_stratagems = S { "Penury", "Addendum: White", "Celerity",
        "Accession", "Rapture", "Altruism", "Tranquility", "Perpetuance", }

    local dark_stratagems = S { "Parsimony", "Addendum: Black", "Manifestation",
        "Alacrity", "Ebullience", "Focalization", "Equanimity", "Immanence", }

    local stratagems = light_stratagems + dark_stratagems

    local book_arts = (buffactive['Dark Arts'] or buffactive['Light Arts'] or buffactive['Addendum: Black'] or buffactive['Addendum: White'])

    if S { 'Light Arts', 'Dark Arts' }:contains(spell.english) then
        return_to_macro()
    end

    -- make arts-agnostic stratagems
    -- check if we're in a book, open appropriate book if not.
    if stratagems:contains(spell.english) and book_arts then
        cancel_spell()
    elseif stratagems:contains(spell.english) and not book_arts then
        cancel_spell()
        if light_stratagems:contains(spell.english) then
            send_command('input /ja "Light Arts" <me>')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    end

    if buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
        if spell.english == "Penury" then
            send_command('input /ja "Parsimony <me>')
        elseif spell.english == "Addendum: White" then
            send_command('input /ja "Addendum: Black" <me>')
        elseif spell.english == "Celerity" then
            send_command('input /ja "Alacrity" <me>')
        elseif spell.english == "Accession" then
            send_command('input /ja "Manifestation" <me>')
        elseif spell.english == "Rapture" then
            send_command('input /ja "Ebullience" <me>')
        elseif spell.english == "Altruism" then
            send_command('input /ja "Focalization" <me>')
        elseif spell.english == "Tranquility" then
            send_command('input /ja "Equanimity" <me>')
        elseif spell.english == "Perpetuance" then
            send_command('input /ja "Immanence" <me>')
        end
    elseif buffactive['Light Arts'] or buffactive['Addendum: White'] then
        if spell.english == "Parsimony" then
            send_command('input /ja "Penury" <me>')
        elseif spell.english == "Alacrity" then
            send_command('input /ja "Celerity" <me>')
        elseif spell.english == "Addendum: Black" then
            send_command('input /ja "Addendum: White" <me>')
        elseif spell.english == "Manifestation" then
            send_command('input /ja "Accession" <me>')
        elseif spell.english == "Ebullience" then
            send_command('input /ja "Rapture" <me>')
        elseif spell.english == "Focalization" then
            send_command('input /ja "Altruism" <me>')
        elseif spell.english == "Equanimity" then
            send_command('input /ja "Tranquility" <me>')
        elseif spell.english == "Immanence" then
            send_command('input /ja "Perpetuance" <me>')
        end
    end
end

(function()
    -- check if functions exist
    if not set_elemental_gear
        or not set_elemental_gorget_belt
        or not get_trust_count
        or not set_elemental_obi_cape_ring
        or not get_elemental_item_name
    then
        print("Error: Motentens libs not loaded, helper functions might not work.")
    end

    elements.obi_of = {
        ['Light'] = 'Korin Obi',
        ['Dark'] = 'Anrin Obi',
        ['Fire'] = 'Karin Obi',
        ['Water'] = 'Suirin Obi',
        ['Thunder'] = 'Rairin Obi',
        ['Earth'] = 'Dorin Obi',
        ['Wind'] = 'Furin Obi',
        ['Ice'] = 'Hyorin Obi',
        ['default'] = 'Hachirin-no-obi'
    }
    elements.gorget_of = {
        ['Light'] = 'Fotia Gorget',
        ['Dark'] = 'Fotia Gorget',
        ['Fire'] = 'Fotia Gorget',
        ['Water'] = 'Fotia Gorget',
        ['Thunder'] = 'Fotia Gorget',
        ['Earth'] = 'Fotia Gorget',
        ['Wind'] = 'Fotia Gorget',
        ['Ice'] = 'Fotia Gorget',
    }
    elements.belt_of = {
        ['Light'] = 'Fotia Belt',
        ['Dark'] = 'Fotia Belt',
        ['Fire'] = 'Fotia Belt',
        ['Water'] = 'Fotia Belt',
        ['Thunder'] = 'Fotia Belt',
        ['Earth'] = 'Fotia Belt',
        ['Wind'] = 'Fotia Belt',
        ['Ice'] = 'Fotia Belt',
    }

    get_elemental_item_name = function(item_type, valid_elements, restricted_to_elements)
        local potential_elements = restricted_to_elements or elements.list
        local item_map = elements[item_type:lower() .. '_of']

        for element in (potential_elements.it or it)(potential_elements) do
            if valid_elements:contains(element) and (player.inventory[item_map[element]] or player.wardrobe[item_map[element]] or player.wardrobe2[item_map[element]] or player.wardrobe3[item_map[element]] or player.wardrobe4[item_map[element]] or player.wardrobe5[item_map[element]] or player.wardrobe6[item_map[element]] or player.wardrobe7[item_map[element]] or player.wardrobe8[item_map[element]]) then
                return item_map[element]
            end
        end
    end

    -- General handler function to set all the elemental gear for an action.
    set_elemental_gear = function(spell)
        set_osash(spell)
        set_elemental_gorget_belt(spell)
        set_elemental_obi_cape_ring(spell)
        set_elemental_staff(spell)
    end

    -- add "NukeWaist"
    gear.default.nuke_waist = "Sacro Cord"
    gear.NukeWaist = "Sacro Cord"

    set_osash = function(spell)
        gear.NukeWaist = (calculate_osash_bonus(spell.target) >= MIN_OSASH_USE) and "Orpheus's Sash" or
            gear.default.nuke_waist
    end

    -- Set the name field of the predefined gear vars for gorgets and belts, for the specified weaponskill.
    set_elemental_gorget_belt = function(spell)
        if spell.type ~= 'WeaponSkill' then return end

        -- Get the union of all the skillchain elements for the weaponskill
        local weaponskill_elements = S {}
            :union(skillchain_elements[spell.skillchain_a])
            :union(skillchain_elements[spell.skillchain_b])
            :union(skillchain_elements[spell.skillchain_c])

        gear.ElementalGorget.name  = get_elemental_item_name("gorget", weaponskill_elements) or gear.default
            .weaponskill_neck or ""
        gear.ElementalBelt.name    = get_elemental_item_name("belt", weaponskill_elements) or
            gear.default.weaponskill_waist or ""

        if get_trust_count() >= 2 then
            gear.TrustRing.name = "Sroda Ring"
        else
            gear.TrustRing.name = gear.default.trust_ring
        end
    end

    -- returns a trust count in party
    get_trust_count = function()
        if windower.ffxi.get_party().alliance_leader then return 0 end
        return is_trust("p1") + is_trust("p2") + is_trust("p3") + is_trust("p4") + is_trust("p5")
    end

    is_trust = function(get_mob_by_target_str)
        local party_member = windower.ffxi.get_mob_by_target(get_mob_by_target_str)
        return (party_member and party_member.is_npc) and 1 or 0
    end


    world_opposing_elements = T {
        ['Fire'] = 'Water',
        ['Water'] = 'Thunder',
        ['Thunder'] = 'Stone',
        ['Stone'] = 'Wind',
        ['Wind'] = 'Ice',
        ['Ice'] = 'Fire',
        ['Light'] = 'Dark',
        ['Dark'] = 'Light',
        ['None'] = ''
    }

    -- Function to get an appropriate obi/cape/ring for the current action.
    set_elemental_obi_cape_ring = function(spell)
        if spell.element == 'None' then
            return
        end

        local osash_bonus = 1 + (calculate_osash_bonus(spell.target) / 100)
        local env_bonus = 1

        local world_elements = S { world.day_element }

        if world.day_element == spell.element then
            env_bonus = env_bonus + 0.1
        elseif world_opposing_elements[world.day_element] == spell.element then
            env_bonus = env_bonus - 0.1
        end

        if world.weather_element ~= 'None' then
            world_elements:add(world.weather_element)

            if world.weather_element == spell.element then
                if world.weather_intensity == 1 then
                    env_bonus = env_bonus + 0.1
                elseif world.weather_intensity == 2 then
                    env_bonus = env_bonus + 0.25
                end
            elseif world_opposing_elements[world.weather_element] == spell.element then
                if world.weather_intensity == 1 then
                    env_bonus = env_bonus - 0.1
                elseif world.weather_intensity == 2 then
                    env_bonus = env_bonus - 0.25
                end
            end
        end

        -- print(osash_bonus, env_bonus)

        -- osash aware swap.
        local obi_name
        if gear.default.obi_waist == 'Orpheus\'s Sash' then
            obi_name = (osash_bonus < env_bonus) and "Hachirin-no-obi" or "Orpheus's Sash"
            -- and get_elemental_item_name("obi", S { spell.element }, world_elements)
            -- or nil
        else
            -- obi_name = get_elemental_item_name("obi", S { spell.element }, world_elements)
            obi_name = env_bonus > 1.01 and "Hachirin-no-obi" or nil
        end
        gear.ElementalObi.name = obi_name or gear.default.obi_waist or ""

        -- print(obi_name)
        if obi_name then
            if player.inventory['Twilight Cape'] or player.wardrobe['Twilight Cape'] or player.wardrobe2['Twilight Cape'] or player.wardrobe3['Twilight Cape'] or player.wardrobe4['Twilight Cape'] then
                gear.ElementalCape.name = "Twilight Cape"
            end
            if (player.inventory['Zodiac Ring'] or player.wardrobe['Zodiac Ring'] or player.wardrobe2['Zodiac Ring'] or player.wardrobe3['Zodiac Ring'] or player.wardrobe4['Zodiac Ring']) and spell.english ~= 'Impact' and
                not S { 'Divine Magic', 'Dark Magic', 'Healing Magic' }:contains(spell.skill) then
                gear.ElementalRing.name = "Zodiac Ring"
            end
        else
            gear.ElementalCape.name = gear.default.obi_back
            gear.ElementalRing.name = gear.default.obi_ring
            gear.DrainWaist = gear.default.drain_waist
        end
    end

    state.Verbose = state.Verbose or M { ['description'] = 'Verbosity', 'Normal', 'Verbose', 'Debug' }
    init_recast()
    init_DW_class()
end)();
