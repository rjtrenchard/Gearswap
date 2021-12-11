--[[ 
    f9      F9          cycle OffenseMode
    ^f9     CTRL+F9     cycle HybridMode
    !f9     ALT+F9      cycle RangedMode
    @f9     WIN+F9      cycle WeaponskillMode
    f10     F10         DefenseMode Physical
    ^f10    CTRL+F10    cycle PhysicalDefenseMode
    !f10    ALT+F10     toggle Kiting
    f11     F11         set DefenseMode Magical
    ^f11    CTRL+F11    cycle CastingMode
    f12     F12         update user
    ^f12    CTRL+F12    cycle IdleMode
    !f12    ALT+F12     reset DefenseMode

    bind ^- gs c toggle selectnpctargets')
    send_command('bind ^= gs c cycle pctargetmode')
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

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Souleater = buffactive.Souleater or false

    state.Buff.Berserk = buffactive.Berserk or false
    state.Buff.Warcry = buffactive.Warcry or false
    state.Buff.Aggressor = buffactive.Aggressor or false

    state.Buff['Dread Spikes'] = buffactive['Dread Spikes'] or false
    state.Buff['Endark'] = buffactive['Endark'] or false
    state.Buff['Endark II'] = buffactive['Endark II'] or false

    state.Buff['Arcane Circle'] = buffactive['Arcane Circle'] or false
    state.Buff['Consume Mana'] = buffactive['Consume Mana'] or false
    state.Buff['Soul Enslavement'] = buffactive['Soul Enslavement'] or false
    state.Buff['Scarlet Delirium'] = buffactive['Scarlet Delirium'] or false
    state.Buff['Nether Void'] = buffactive['Nether Void'] or false
    state.Buff['Last Resort'] = buffactive['Last Resort'] or false
    state.Buff['Diabolic Eye'] = buffactive['Diabolic Eye'] or false
    state.Buff['Dark Seal'] = buffactive['Dark Seal'] or false
    state.Buff['Blood Weapon'] = buffactive['Blood Weapon'] or false

    state.Buff['Aftermath'] = (buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3'] or buffactive['Aftermath']) or false

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    job_helper()
    include('gear_' .. player.name:lower()..'/'..player.main_job:upper()..'.lua' )

    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod', 'Low')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    state.StunMode = M{['description']='Stun Mode', 'default', 'Enmity'}
    state.WeaponMode = M{['description']='Weapon Mode', 'greatsword', 'scythe', 'greataxe', 'sword', 'club'}
    state.Verbose = M{['description']='Verbosity', 'Normal', 'Verbose', 'Debug'}
    state.UseCustomTimers = M(false, 'Use Custom Timers')
    state.AutoMacro = M(true, 'Use automatic macro books')

    include_job_stats()

    -- Additional local binds
    send_command('bind ^` input /ja "Scarlet Delirium"')
    send_command('bind !` input /ja "Scarlet Delirium"')
    --send_command('bind !` input /ja "Seigan" <me>')
    --send_command('bind != gs c cycle WeaponMode')

    send_command('bind numpad1 gs equip sets.Weapons.greatsword')
    send_command('bind numpad2 gs equip sets.Weapons.scythe')
    send_command('bind numpad3 gs equip sets.Weapons.greataxe')
    send_command('bind numpad4 gs equip sets.Weapons.sword')
    send_command('bind numpad5 gs equip sets.Weapons.club')
    send_command('bind numpad6 gs equip sets.Weapons.ridill')
    send_command('bind numpad9 gs equip sets.HP_High')

    gear.Moonshade = {}
    gear.Moonshade.name = 'Moonshade Earring'
    gear.default.Moonshade = 'Ishvara Earring'

    info.lastWeapon = nil
    sets._Recast = {}
    info._RecastFlag = false
    


    -- Event driven functions
    ticker = windower.register_event('time change', function(myTime)
        if isMainChanged() then
            procSub()
            if state.AutoMacro.value then
                weapon_macro_book()
            end
            determine_combat_weapon()
        end
        if (myTime == 17*60 or myTime == 7*60) then 
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    custom_timers = {}

    info.AM = {}
    info.AM.potential = 0
    info.AM.level = 0
    info.TP = {}
    info.TP.old = 0
    info.TP.new = 0

    tp_ticker = windower.register_event('tp change', function(new_tp, old_tp)
        if old_tp == 3000 or new_tp == 3000 then
            info.AM.potential = 3
        elseif (new_tp >= 2000 or new_tp < 3000) or (old_tp >= 2000 or old_tp < 3000) then
            info.AM.potential = 2
        elseif (new_tp >= 1000 or new_tp < 2000) or (old_tp >= 1000 or old_tp < 2000) then
            info.AM.potential = 1
        else
            info.AM.potential = 0
        end
        info.TP.old = old_tp
        info.TP.new = new_tp
        echo('new: ' .. new_tp .. ' old: '.. old_tp, 2)

    end)
    
    echo('Job:' .. player.main_job .. '/' .. player.sub_job .. '.',2)
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    windower.unregister_event(ticker)
    windower.unregister_event(tp_ticker)
    send_command('unbind ^`')
    send_command('unbind !-')
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
end

function job_helper()
    info.TP_scaling_ws = S{
        'Spinning Scythe', 'Spiral Hell', 'Cross Reaper', 'Entropy', 
        'Spinning Slash', 'Ground Strike', 'Torcleaver', 'Resolution', 
        'Upheaval', 'Steel Cyclone', 'Savage Blade', 'Judgment'
    }
    info.Weapons = {}
    info.Weapons.Type = {
        ['Naegling'] = 'sword',['Ridill'] = 'sword',
        ['Zulfiqar'] = 'greatsword', ['Caladbolg'] = 'greatsword',
        ['Lycurgos'] = 'greataxe',
        ['Kaja Axe']= 'axe',['Dolichenus']='axe',
        ['Apocalypse'] = 'scythe', ['Father Time'] = 'scythe', ['Liberator'] = 'scythe', ['Redemption'] = 'scythe', ['Anguta'] = 'scythe', ['Dacnomania']='scythe',['Woeborn']='scythe',
        ['Loxotic Mace +1'] = 'club',['Loxotic Mace'] = 'club',
        ['empty'] = 'handtohand',
        ['Blurred Shield']= 'shield', ['Blurred Shield +1'] = 'shield', ['Adapa Shield'] = 'shield',["Smyth's Aspis"]='shield',["Smyth's Ecu"]='shield',["Smythe's Scutum"]='shield',["Smythe's Shield"]='shield',["Smythe's Eschuteon"]="Shield",
        ['Utu Grip']='Grip',['Caecus Grip']='Grip'
    }
    info.Weapons.REMA = S{'Apocalypse','Ragnarok','Caladbolg','Redemption','Liberator','Anguta','Father Time'}
    info.Weapons.REMA.Type = {
        ['Apocalypse'] = 'relic',
        ['Ragnarok'] = 'relic',
        ['Caladbolg'] = 'empyrean',
        ['Redemption'] = 'empyrean',
        ['Liberator'] = 'mythic',
        ['Anguta'] = 'aeonic',
    }
    info.Weapons.Delay = {
        ['Naegling'] = 240,
        ['Zulfiqar'] = 504,
        ['Caladbolg'] = 430,
        ['Lycurgos'] = 508,
        ['Apocalypse'] = 513,
        ['Father Time'] = 513,
        ['Liberator'] = 528,
        ['Redemption'] = 502,
        ['Anguta'] = 528,
        ['Loxotic Mace +1'] = 334,
    }
    info.Weapons.TPBonus = {
        ['Anguta'] = 500,
        ['Lycurgos'] = 1,
    }
    info.Weapons.Fencer = {
        ['Blurred Shield +1'] = 0
    }
    info.Fencer = {}
    info.Fencer[0] = 0
    info.Fencer[1] = 200
    info.Fencer[2] = 300
    info.Fencer[3] = 400
    info.Fencer[4] = 450
    info.Fencer[5] = 500
    info.Fencer[6] = 550
    info.Fencer[7] = 600
    info.Fencer[8] = 630
    info.Fencer.JPGift = {}
    info.Fencer.JPGift = {bonus = 230, active=false}
    --list of weapon types
    info.Weapons.Twohanded = S{'greatsword', 'greataxe','scythe','staff','greatkatana','polearm'}
    info.Weapons.Onehanded = S{'sword', 'club', 'katana', 'dagger', 'axe'}
    info.Weapons.HandtoHand = S{'handtohand'}
    info.Weapons.Ranged = S{'throwing', 'archery', 'marksmanship'}
    info.Weapons.Shields = S{'shield'}

    -- macro book locations
    info.macro_sets = {}
    info.macro_sets.subjobs = S{'SAM', 'NIN', 'WAR', 'DRG'}
    info.macro_sets['greatsword'] = {['SAM'] = {book=8,page=2}, 
                                     ['NIN'] = {book=8,page=4},
                                     ['WAR'] = {book=8,page=6},
                                     ['DRG'] = {book=8,page=10}}
    
    info.macro_sets['scythe'] = {    ['SAM'] = {book=8,page=1}, 
                                     ['NIN'] = {book=8,page=3},
                                     ['WAR'] = {book=8,page=5},
                                     ['DRG'] = {book=8,page=9}}

    info.macro_sets['greataxe'] = {  ['SAM'] = {book=8,page=8}, 
                                     ['NIN'] = {book=8,page=8},
                                     ['WAR'] = {book=8,page=8},
                                     ['DRG'] = {book=8,page=8}}

    info.macro_sets['sword'] = {     ['SAM'] = {book=8,page=7}, 
                                     ['NIN'] = {book=8,page=7},
                                     ['WAR'] = {book=8,page=7},
                                     ['DRG'] = {book=8,page=7}}

    info.macro_sets['axe'] = info.macro_sets['sword']
    info.macro_sets['club'] = info.macro_sets['sword']
    
end

-- found in gear_name/DRK.lua
function init_gear_sets()
    include_job_sets()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    -- set this so we know what to come back to later
    --info.recastWeapon = player.equipment.main
    
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    local ability_recast = windower.ffxi.get_ability_recasts()
    if (spell.action_type:lower() == 'magic') then
        if player.status == 'Idle' then
            if (state.Buff['Hasso'] and (ability_recast[138] == 0 or ability_recast[138] == nil)) then
                --cast_delay(0.3)
                send_command('cancel hasso')
            end
        end
    elseif spell.type:lower() == 'weaponskill' then
        if info.TP_scaling_ws:contains(spell.english) and info.TP.new > 2999 then
            -- kinda messy, but will equip moonshade with either lugra or a specific sets 
            -- earring if lugra exists in the first ear slot.
            if sets.precast.WS[spell.english].ear1 == sets.precast.WS.FullTP.ear2 then
                equip(sets.precast[spell.english].FullTP)
            else
                equip(sets.precast.WS.FullTP)
            end
        end
    end
end


function job_midcast(spell, action, spellMap, eventArgs)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Lock reraise items
    if state.HybridMode.value == 'Reraise' or (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end

    -- Dark seal handling
    if spell.skill == 'Dark Magic' and buffactive['Dark Seal'] then
        if spell.english == 'Drain III' then
            equip(sets.midcast['Drain III'].DarkSeal)
        -- we're not interested in the relic bonus for these spells    
        elseif S{'Drain','Drain II','Aspir','Aspir II','Dread Spikes'}:contains(spell.english) then
            equip(sets.midcast[spell.english])
        elseif S{'Endark', 'Endark II'}:contains(spell.english) then
            equip(sets.midcast['Endark'].DarkSeal)
        else
            equip(sets.midcast['Dark Magic'].DarkSeal)
        end
    end

    -- Weapon swap handling
    if spell.skill == 'Dark Magic' and player.tp < 1000 then
        if S{'Drain', 'Drain II', 'Drain III', 'Aspir', 'Aspir II'}:contains(spell.english) and (sets.midcast['Drain'].Weapon.main ~= player.equipment.main) then
            setRecast()
            equip(sets.midcast['Drain'].Weapon)
        -- do not change weapons if AM3 is up
        elseif S{'Endark', 'Endark II'}:contains(spell.english) and (sets.midcast['Endark'].Weapon.main ~= player.equipment.main) and not buffactive['Aftermath: Lv.3'] then
            setRecast()
            equip(sets.midcast['Endark'].Weapon)
        elseif spell.english == 'Dread Spikes' and (sets.midcast['Dread Spikes'].Weapon.main ~= player.equipment.main) and not buffactive['Aftermath: Lv.3'] then
            setRecast()
            equip(sets.midcast['Dread Spikes'].Weapon)
        end
    end

    if S{'Dread Spikes', 'Drain II', 'Drain III', 'Endark', 'Endark II'}:contains(spell.english) or spell.english:startswith('Absorb') then
        adjust_timers_darkmagic(spell, spellMap)
    end

    if S{'Provoke'}:contains(spell.english) then 
        equip(sets.Enmity)
    elseif S{'Stun'}:contains(spell.english) and state.StunMode.value == 'Enmity' then
        equip(sets.Enmity)
    end


    if spell.english == 'Dread Spikes' then
        echo('Dread Spikes [' .. calculate_dreadspikes() .. ']')
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- set AM level in aftercast, this is needed for some reason because job_buff gets eaten.
    if spell.type == 'WeaponSkill' and info.Weapons.REMA:contains(player.equipment.main) and info.AM.potential > info.AM.level then
        info.AM.level = info.AM.potential
        classes.CustomMeleeGroups:clear()
        if data.weaponskills.relic[player.equipment.main] then
            if data.weaponskills.relic[player.equipment.main] == spell.english then
                classes.CustomMeleeGroups:append('AM')
            end
        elseif data.weaponskills[info.Weapons.REMA.Type[player.equipment.main]][player.equipment.main] then
            if data.weaponskills[info.Weapons.REMA.Type[player.equipment.main]][player.equipment.main] == spell.english then
                if info.AM.potential == 1 then
                    classes.CustomMeleeGroups:append('AM')
                elseif info.AM.potential == 2 then
                    classes.CustomMeleeGroups:append('AM')
                elseif info.AM.potential == 3 then
                    classes.CustomMeleeGroups:append('AM3')
                end
            end
        end
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    if buffactive.Souleater then equip(sets.buff['Souleater']) end

    -- if we changed weapons, change back.
    if hasRecast() then
        equip(recallRecast())
        resetRecast()
    end
    eventArgs.handled = false
end

function job_buff_change(buff, gain)
    -- when gaining a buff
    if gain then
        if buff == 'sleep' and player.hp > 50 then
            if not buffactive['charm'] then
                equip(sets.Sleeping)
            end
        elseif buff == 'charm' then
            
            local function count_slip_debuffs()
                local erase_dots = 0
                if buffactive['poison'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Dia'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Bio'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Burn'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Choke'] then 
                    erase_dots = erase_dots + 1
                end 
                if buffactive['Shock'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Drown'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Rasp'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Frost'] then
                    erase_dots = erase_dots + 1
                end
                if buffactive['Helix'] then
                    erase_dots = erase_dots + 1
                end
                return erase_dots
            end

            local debuffs = count_slip_debuffs() 
            if debuffs > 0 then
                send_command('input /p Charmed and I cannot be slept.')
            else
                send_command('input /p Charmed.')
            end
        elseif S{'Aftermath', 'Aftermath: Lv.1', 'Aftermath: Lv.2', 'Aftermath: Lv.3'}:contains(buff) then
            update_combat_form()
            job_update()
            
        end
    
    -- when losing a buff
    else
        if buff == 'charm' then
            send_command('input /p Charm off.')
        elseif buff == 'sleep' then
            job_update()
        elseif S{'Aftermath'}:contains(buff) then
            info.AM.level = 0
            update_combat_form()
            job_update()
        elseif S{'Dread Spikes', 'Drain II', 'Drain III', 'Endark', 'Endark II'}:contains(buff) or buff:startswith('Absorb') then
            send_command('timers delete "'..buff..'"')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    procTime(world.time)
    update_combat_form()
    --eventArgs.handled = false
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-- called when state changes are made
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'WeaponMode' then
        update_weapon_mode(newValue)
        job_update()
    end
end

-- update weapon sets
function update_weapon_mode(w_state)
    gear.MainHand = sets.Weapons[w_state].main
    gear.SubHand = sets.Weapons[w_state].sub

    sets.weapons = {main=gear.MainHand, sub=gear.SubHand}
    equip(sets.weapons)
end

-- select a macro book based on weapon type and subjob
function weapon_macro_book()
    local currentWeapon = player.equipment.main
    local subjob = player.sub_job


    -- ensure it exists, then go there
    if (info.Weapons.Type[currentWeapon] ~= nil or currentWeapon ~= empty) and info.macro_sets.subjobs:contains(subjob) then
        local book = info.macro_sets[info.Weapons.Type[currentWeapon]][subjob].book
        local page = info.macro_sets[info.Weapons.Type[currentWeapon]][subjob].page
        echo('Changing macro book to <' .. book .. ',' .. page .. '>.',0,144)
        set_macro_page(page, book)
    end
end

function determine_combat_weapon()
    -- if a weapon has a specific combat form, switch to that
    if info.Weapons.REMA:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
        echo('CombatWeapon: '.. player.equipment.main ..' set',1)
    else
        state.CombatWeapon:reset()
        echo('CombatWeapon: Normal set',1)
    end
    echo('CombatWeapon mode: '.. state.CombatWeapon.value,1)
end

-- reset combat form, or choose a specific weapons combat form. Blind to aftermath
function reset_combat_form()
    local weapon_slot = player.equipment.main
    local sub_slot = player.equipment.sub

    if S{'NIN','DNC'}:contains(player.sub_job) then
        -- change to DW only if mainhanding a one handed weapon and a weapon is equipped in the sub slot
        if info.Weapons.Onehanded:contains(info.Weapons.Type[weapon_slot]) then
            if info.Weapons.Shields:contains(info.Weapons.Type[sub_slot]) or sub_slot == empty then
                state.CombatForm:reset()
            else
                state.CombatForm:set('DW')
            end
        end
    else
        state.CombatForm:reset()
    end
end

-- process time of day changes
function procTime(myTime) 
    if isNight() then
        gear.WSEarBrutal = gear.WSNightEar1
        gear.WSEarMoonshade = gear.WSNightEar2
        gear.WSEarThrud = gear.WSNightEar3
    else
        gear.WSEarBrutal = gear.WSDayEar1
        gear.WSEarMoonshade = gear.WSDayEar2
        gear.WSEarThrud = gear.WSDayEar3
    end
end

-- if the mainhand weapon changes, update it so callbacks can tell.
function isMainChanged()
    if info.lastWeapon == player.equipment.main then 
        return false
    else
        info.lastWeapon = player.equipment.main
        return true
    end
end

-- sets the Recast weapon set to what is currently equipped
-- affected slots: main sub ranged ammo
function setRecast() 
    sets._Recast = {
        main = player.equipment.main,
        sub = player.equipment.sub,
        ranged = player.equipment.range,
        ammo = player.equipment.ammo
    }
    info._RecastFlag = true
end

-- resets the Recast weapon set to nil
function resetRecast()
    sets._Recast = {main = nil, sub = nil, ranged = nil, ammo = nil}
    info._RecastFlag = false
end

-- returns the Recast weapon set
function recallRecast()
    return sets._Recast
end

-- returns true if the recast set has been used
function hasRecast()
    return info._RecastFlag
end

-- check if there is something in the sub slot
function procSub()
    local currentWeapon = player.equipment.main
    if player.equipment.sub == 'empty' then
        if info.Weapons.Twohanded:contains(info.Weapons.Type[currentWeapon]) then
            equip(sets.TwoHand_OH)
        else
            equip(sets.OneHand_OH)
        end
    end
end

-- return true if night
function isNight()
    return (world.time >= 17*60 or world.time < 7*60)
end

-- get unchangable TP Bonus items, return 0 if we don't know any.
function getWeaponTPBonus() 
    local weapon = player.equipment.main
    local sub = player.equipment.sub
    local ranged = player.equipment.range

    local fencer = getFencerBonus()

    local tp_bonus = 0
    
    -- check weapon slot items
    if info.Weapons.TPBonus[weapon] then
        if weapon == 'Lycurgos' then
            if player.hp <= 5000 then
                tp_bonus = tp_bonus + (player.hp / 5)
            else 
                tp_bonus = tp_bonus + 1000
            end
        else
            tp_bonus = tp_bonus + info.Weapons.TPBonus[weapon]
        end
    end

    -- check ranged slot items
    if info.Weapons.TPBonus[ranged] then
        tp_bonus = tp_bonus + info.Weapons.TPBonus[ranged]
    end
    return tp_bonus
end

function getFencerBonus() 
    local fencer = 0
    local bonus = 0

    if player.job == 'WAR' then 
        if player.main_job_level >= 97 then
            fencer = 5
        elseif player.main_job_level >= 84 then
            fencer = 4
        elseif player.main_job_level >= 71 then
            fencer = 3
        elseif player.main_job_level >= 58 then
            fencer = 2
        elseif player.main_job_level >= 45 then
            fencer = 1
        end
    elseif player.job == 'BST' then
        if player.main_job_level >= 94 then
            fencer = 3
        elseif player.main_job_level >= 87 then
            fencer = 2
        elseif player.main_job_level >= 80 then
            fencer = 1
        end
    elseif player.job == 'BRD' then
        if player.main_job_level >= 95 then 
            fencer = 2
        elseif player.main_job_level >= 85 then
            fencer = 1
        end
    end

    -- calculate but do not add to the tier granted by subjobs
    -- assumes sj is levelled. level your subjobs.
    if player.sub_job == 'WAR' and player.main_job_level >= 90 and fencer == 0 then
        fencer = 1
    end

    -- calculate fencer bonus from gear
    -- TODO:

    -- return fencer + bonus
    if fencer > 8 then fencer = 8 end
    if info.Fencer.JPGift.active then 
        bonus = info.Fencer[fencer] + info.Fencer.JPGift.bonus
    else 
        bonus = info.Fencer[fencer]
    end
    return bonus
end

-- returns true if tp is overcapping
function isOverMaxTP(tp, perm_bonus_tp, max_tp)
    perm_bonus_tp = perm_bonus_tp or 0
    return (tp+perm_bonus_tp) > (max_tp or 3000)
end

function calculate_dreadspikes() 
    local base = player.max_hp
    local base_absorbed = 0.5

    if info.JobPoints.DreadSpikesBonus then base_absorbed = base_absorbed + 0.1 end
    if player.equipment.body == 'Bale Cuirass +1' then base_absorbed = base_absorbed + 0.0625 end
    if player.equipment.body == 'Bale Cuirass +2' then base_absorbed = base_absorbed + 0.125 end
    if player.equipment.body == "Heathen's Cuirass" then base_absorbed = base_absorbed + 0.125 end
    if player.equipment.body == "Heathen's Cuirass +1" then base_absorbed = base_absorbed + 0.175 end
    if player.equipment.main == 'Crepuscular Scythe' then base_absorbed = base_absorbed + 0.25 end

    return math.floor(base * base_absorbed)
end

-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers_darkmagic(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end
    
    local current_time = os.time()
    
    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.
    
    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for spell_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[spell_name] = true
        end
    end
    for spell_name,expires in pairs(temp_timer_list) do
        custom_timers[spell_name] = nil
        custom_timers.basetime[spell_name] = nil
    end
    
    local dur = calculate_duration_darkmagic(spell.name, spellMap)
    if custom_timers[spell.name] then
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        send_command('timers create "'..spell.name..'" '..dur..' down')
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers_darkmagic(), which is only called on aftercast().
function calculate_duration_darkmagic(spellName, spellMap)
    local mult = 1
    local base_duration = 0

    if spellMap == 'Absorb' and spellName ~= 'Absorb-Attri' and spellName ~= 'Absorb-TP' then base_duration = 1.5*60 end
    --if spellName == 'Bio' then base_duration = 1*60 end
    --if spellName == 'Bio II' then base_duration = 2*60 end
    --if spellName == 'Bio III' then base_duration = 180 end
    if spellName == 'Drain II' then base_duration = 3*60 end
    if spellName == 'Drain III' then base_duration = 3*60 end
    if spellName == 'Dread Spikes' then base_duration = 3*60 end
    if spellName == "Endark" then base_duration = 3*60 end
    if spellName == "Endark II" then base_duration = 3*60 end

    if player.equipment.feet == 'Ratri Sollerets' then mult = mult + 0.2 end
    if player.equipment.feet == 'Ratri Sollerets +1' then mult = mult + 0.25 end
    if player.equipment.ring1 == 'Kishar Ring' and spellMap == 'Absorb' and spellName ~= 'Absorb-TP' then mult = mult + 0.1 end
    if player.equipment.ring2 == 'Kishar Ring' and spellMap == 'Absorb' and spellName ~= 'Absorb-TP' then mult = mult + 0.1 end

    if buffactive.DarkSeal and S{'Abyss Burgeonet +2', "Fallen's Burgeonet","Fallen's Burgeone +1","Fallen's Burgeonet +2","Fallen's Burgeonet +3"}:contains(player.equipment.head) then
        mult = mult + (info.JobPoints.DarkSealMerits*0.1)
    end
    
    local totalDuration = math.floor(mult*base_duration)

    return totalDuration
end


-- sent a message to the game
function echo(msg, verbosity_, chatmode)
    local verbosity = verbosity_ or 0
    local function getVerbosityLevel()
        local vlvl = 0
        if state.Verbose.value == "Normal" then vlvl = 0
        elseif state.Verbose.value == 'Verbose' then vlvl = 1
        elseif state.Verbose.value == 'Debug' then vlvl = 2
        end
        return vlvl
    end
    if getVerbosityLevel() >= verbosity then
        local mode = chatmode or 144
        windower.add_to_chat(mode, msg)
    end
end



-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    
    determine_combat_weapon()

    classes.CustomMeleeGroups:clear()
    
    if buffactive['Aftermath'] then
        info.AM.level = 1
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.1'] then
        info.AM.level = 1
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.2'] then
        info.AM.level = 2
        classes.CustomMeleeGroups:append('AM')
    elseif buffactive['Aftermath: Lv.3'] then
        info.AM.level = 3
        classes.CustomMeleeGroups:append('AM3')
    else
        info.AM.level = 0
    end
    reset_combat_form()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    enable('main','sub')
    -- Default macro set/book
    if player.sub_job == 'SAM' then
        set_macro_page(1, 8)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 8)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 8)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 8)
    elseif player.sub_job == 'WAR' then
        set_macro_page(5, 8)
    else
        set_macro_page(6, 8)
    end
    
    send_command( "@wait 5;input /lockstyleset 4" )
end

