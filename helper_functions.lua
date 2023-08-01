res = require('resources')

function init_helper_functions()
    init_recast()
    init_DW_class()
end

local MAX_MAGIC_HASTE = 448 / 1024 * 100
local MIN_MAGIC_HASTE = -0.5 * 100
local MAX_JOB_HASTE = 256 / 1024 * 100
local MAX_TOTAL_HASTE = 0.8 * 100

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
function set_recast()
    if not has_recast() then
        sets._Recast.main = player.equipment.main
        sets._Recast.sub = player.equipment.sub
        sets._Recast.range = player.equipment.range
        sets._Recast.ammo = player.equipment.ammo
    end
    info._RecastFlag = sets._Recast.main or sets._Recast.sub or sets._Recast.range or sets._Recast.ammo
end

-- resets the Recast weapon set to nil
function reset_recast()
    sets._Recast = { main = nil, sub = nil, range = nil, ammo = nil }
    info._RecastFlag = false
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
    if has_recast then
        equip(recall_recast())
        reset_recast()
    end
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

function can_DW()
    local dual_wield_id = 18
    return T(windower.ffxi.get_abilities().job_traits):contains(dual_wield_id)
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

-- tallys haste amounts from buffs
function get_haste_from_buffs()
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
        return 'HasteMidDW'
    elseif total_haste >= 43.75 then
        return 'HasteMaxDW'
    end
end

function is_healer_role()
    return S { 'WHM', 'SCH', 'RDM' }:contains(player.sub_job) or buffactive['Light Arts'] or
    buffactive['Addendum: Light']
end

-- sets the custom melee group
function set_DW_class()
    if not can_DW() then return end
    local DW_class = get_DW_class(get_haste_from_buffs())
    if classes.CustomMeleeGroups:contains(DW_class) then return end
    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(DW_class)
end

-- make sure you set your initial class, or you'll be in regular melee mode upon loading the lua
init_DW_class = set_DW_class

function init_helper_functions()
    init_recast()
    init_DW_class()
end

--TODO:
function calculate_MA(delay, bonus)
    bonus = bonus or 0
    delay = delay or 480
end

-- get FC from traits
function get_FC_amount(blu_trait_bonus, RDM)
    blu_trait_bonus = blu_trait_bonus or 0

    local player_data = windower.ffxi.get_player()

    local rdm_points = player_data.job_points.rdm.jp_spent
end

function get_BLU_FC_amount(blu_trait_bonus)
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

init_helper_functions();
