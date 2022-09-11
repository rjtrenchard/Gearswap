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

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    state.DoomMode = M { ['description'] = 'Doom Mode', 'Cursna', 'Holy Water', 'None' }

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    gear.WSDayEar1 = "Schere Earring"
    gear.WSDayEar2 = "Crepuscular Earring"
    gear.WSNightEar1 = "Lugra Earring +1"
    gear.WSNightEar2 = "Lugra Earring"

    gear.WSEarBrutal = { name = gear.WSDayEar1 }
    gear.WSEarCessance = { name = gear.WSDayEar2 }

    ticker = windower.register_event('time change', function(myTime)
        if (myTime == 17 * 60 or myTime == 7 * 60) and (player.status == 'Idle' or state.Kiting.value) then
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    send_command('bind numpad4 gs equip sets.Weapons.Sword')
    send_command('bind numpad5 gs equip sets.Weapons.Club')
    send_command('bind numpad6 gs equip sets.Weapons.GAxe')

    send_command('bind numpad7 gs equip sets.Weapons.Spear')
    send_command('bind numpad8 gs equip sets.Weapons.Staff')
    send_command('bind numpad9 gs equip sets.Weapons.Axe')


    send_command('bind ^= gs c cycle treasuremode')

    update_combat_form()
    select_default_macro_book()
end

function procTime(myTime)
    if isNight() then
        gear.WSEarBrutal.name = gear.WSNightEar1
        gear.WSEarCessance.name = gear.WSNightEar2
        gear.MovementFeet = gear.NightFeet
    else
        gear.WSEarBrutal.name = gear.WSDayEar1
        gear.WSEarCessance = gear.WSDayEar2
        gear.MovementFeet = gear.DayFeet
    end
end

function isNight()
    return (world.time >= 17 * 60 or world.time < 7 * 60)
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    windower.unregister_event(ticker)
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
    send_command('unbind numpad6')
    send_command('unbind numpad7')
    send_command('unbind numpad8')
    send_command('unbind numpad9')
    send_command('unbind !`')
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind ^-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    gear.melee_cape = "Mecistopins mantle"

    sets.Weapons = {}
    sets.Weapons.Sword = { main = "Naegling", sub = "Blurred Shield +1" }
    sets.Weapons.Club = { main = "Loxotic Mace +1", sub = "Blurred Shield +1" }
    sets.Weapons.GAxe = { main = "Lycurgos", sub = "Utu Grip" }
    sets.Weapons.Spear = { main = "Shining One", sub = "Utu Grip" }
    sets.Weapons.Staff = { main = "Xoanon", sub = "Utu Grip" }
    sets.Weapons.Axe = { main = "Dolichenus", sun = "Blurred Shield +1" }


    sets.TreasureHunter = {
        head = "Volte Cap",
        waist = "Chaac belt", legs = "Volte Hose", feet = "Volte Boots"
    }

    sets.enmity = { ammo = "Sapience Orb",
        head = "Loess Barbuta +1", neck = "Unmoving Collar +1", ear1 = "Cryptic Earring", ear2 = "Trux Earring",
        body = "Obviation Cuirass +1", hands = "Macabre Gauntlets +1", ring1 = "Supershear Ring", ring2 = "Eihwaz Ring",
        waist = "Trance Belt", legs = "Zoar Subligar +1", feet = gear.EnmityFeet }

    sets.precast.FC = { ammo = "Sapience Orb",
        head = "Sakpata's Helm", neck = "Orunmila's Torque", ear1 = "Enchanter's Earring +1", ear2 = "Loquacious Earring",
        body = "Sacro Breastplate", hands = "Leyline Gloves", ring1 = "Weatherspoon Ring +1", ring2 = "Rahab Ring",
        legs = "Limbo Trousers", feet = "Odyssean Greaves"
    }

    sets.Sleeping = { neck = "Berserker's Torque" }

    sets.buff.doom = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Eshmun's Ring", ring2 = "Eshmun's Ring",
        back = gear.DDCape, waist = "Gishdubar Sash", legs = "Malignance Tights", feet = "Malignance Boots" }

    sets.buff.doom.HolyWater = { ammo = "Staunch Tathlum +1",
        head = "Malignance Chapeau", neck = "Nicander's Necklace",
        body = "Malignance Tabard", hands = "Malignance Gloves", ring1 = "Blenmot's Ring +1", ring2 = "Blenmot's Ring +1",
        back = gear.DDCape, waist = "Flume Belt +1", legs = "Malignance Tights", feet = "Malignance Boots" }

    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Provoke'] = sets.enmity
    sets.precast.JA['Berserk'] = { body = "Pummeler's Lorica +2", back = "Cichol's Mantle", feet = "Agoge calligae +2" }
    sets.precast.JA['Warcry'] = { head = "Agoge Mask +2" }
    sets.precast.JA['Aggressor'] = { head = "Pummeler's Mask +2", body = "Agoge Lorica +2" }
    sets.precast.JA['Retaliation'] = { hands = "Pummeler's Mufflers +1", legs = "Boii Calligae +1" }
    sets.precast.JA['Warrior\'s Charge'] = { legs = "Agoge Cuisses +2" }
    sets.precast.JA['Tomahawk'] = { ammo = "Throwing Tomahawk", feet = "Agoge calligae +2" }
    sets.precast.JA['Restraint'] = { hands = "Boii Mufflers +1" }
    sets.precast.JA['Blood Rage'] = { body = "Boii Lorica +1" }
    sets.precast.JA['Mighty Strikes'] = { hands = "Agoge Mufflers +2" }


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ammo = "Knobkierrie",
        head = "Sakpata's Helm", neck = "Fotia Gorget", ear1 = "Thrud Earring", ear2 = "Moonshade Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Epaminondas's Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Fotia Belt", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    sets.precast.WS.MultiHit = { ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm", neck = "Fotia Gorget", ear1 = "Schere Earring", ear2 = "Moonshade Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Regal Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Fotia Belt", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

    sets.precast.WS.Crit = { ammo = "Yetshila +1",
        head = "Blistering Sallet +1", neck = "Fotia Gorget", ear1 = "Schere Earring", ear2 = "Moonshade Earring",
        body = "Hjarrandi Breastplate", hands = "Sakpata's Gauntlets", ring1 = "Begrudging Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Fotia Belt", legs = "Zoar Subligar +1", feet = "Sakpata's Leggings" }

    sets.precast.WS.Magic = { ammo = "Knobkierrie",
        head = "Nyame Helm", neck = "Sibyl Scarf", ear1 = "Friomisi Earring", ear2 = "Lugra Earring +1",
        body = "Nyame Mail", hands = "Nyame Gauntlets", ring1 = "Epaminondas's Ring", ring2 = "Regal Ring",
        back = gear.melee_cape, waist = "Eschan Stone", legs = "Nyame Flanchard", feet = "Nyame Sollerets"
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck = "Republican Platinum Medal",
        waist = "Sailfi Belt +1"
    })
    sets.precast.WS['Savage Blade'].MaxTP = { ear2 = "Lugra Earring +1" }
    sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Cataclysm'] = { ammo = "Knobkierrie",
        head = "Pixie Hairpin +1", neck = "Sibyl Scarf", ear1 = "Lugra Earring +1", ear2 = "Moonshade Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets",
        back = gear.melee_cape, waist = "Eschan Stone", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings"
    }

    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, { ammo = "Seething Bomblet +1",
        ear1 = "Schere Earring",
        ring1 = "Niqmaddu Ring",
    })




    -- Midcast Sets
    sets.midcast.FastRecast = {
        head = "Sakpata's Helm",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets",
        legs = "Phorcys Dirs", feet = "Sakpata's Leggings"
    }


    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = { neck = "Bathy Choker +1", ring1 = "Sheltered Ring", ring2 = "Moonlight Ring" }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = { ammo = "Staunch Tathlum +1",
        head = "Shaded Spectacles", neck = "Smithy's Torque", ear1 = "Etiolation Earring", ear2 = "Odnowa Earring +1",
        body = "Blacksmith's Smock", hands = "Smithy's Mitts", ring1 = "Confectioner's Ring",
        ring2 = "Craftmaster's Ring",
        back = gear.melee_cape, waist = "Blacksmith's Belt", legs = "Carmine Cuisses +1", feet = "Hermes' sandals" }

    sets.idle.Field = set_combine({}, { ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Odnowa Earring +1",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring2 = "Defending Ring", ring1 = "Moonlight Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Hermes' sandals" })

    sets.idle.Weak = { ammo = "Staunch Tathlum +1",
        head = empty, neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Odnowa Earring +1",
        body = "Lugra Cloak +1", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Defending Ring",
        back = gear.melee_cape, waist = "Flume Belt +1", legs = "Carmine Cuisses +1", feet = "Sakpata's Leggings" }

    sets.idle.PDT = set_combine(sets.idle.Field, { head = "Sakpata's Helm", body = "Sakpata's Plate" })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Reraise = sets.idle.Weak
    -- Defense sets
    sets.defense.PDT = { ammo = "Staunch Tathlum +1",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring2 = "Defending Ring", ring1 = "Moonlight Ring",
        back = "Shadow Mantle", waist = "Flume Belt +1", legs = "Karieyh Brayettes +1", feet = "Sakpata's Leggings" }

    sets.defense.Reraise = {
        head = "Twilight Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Crepuscular Mail", hands = "Buremte Gloves", ring2 = "Defending Ring", ring1 = "Moonlight Ring",
        back = "Shadow Mantle", waist = "Flume Belt +1", legs = "Karieyh Brayettes +1", feet = "Sakpata's Leggings"
    }

    sets.defense.MDT = { ammo = "Demonry Stone",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Defending Ring", ring2 = "Moonlight Ring",
        back = "Engulfer Cape", waist = "Flume Belt +1", legs = "Karieyh Brayettes +1", feet = "Sakpata's Leggings" }

    sets.Kiting = { feet = "Hermes' Sandals" }

    sets.Reraise = { head = "Twilight Helm", body = "Crepuscular Mail" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = { ammo = "Ginsen",
        head = "Sakpata's Helm", neck = "Combatant's Torque", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = gear.melee_cape, waist = "Sailfi Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Acc = { ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm", neck = "Combatant's Torque", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = "Letalis Mantle", waist = "Ioskeha Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.PDT = { ammo = "Ginsen",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Defending Ring",
        back = "Iximulew Cape", waist = "Sailfi Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Acc.PDT = { ammo = "Seething Bomblet +1",
        head = "Sakpata's Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Sakpata's Plate", hands = "Sakpata's Gauntlets", ring1 = "Defending Ring", ring2 = "Niqmaddu Ring",
        back = "Letalis Mantle", waist = "Ioskeha Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Reraise = { ammo = "Ginsen",
        head = "Twilight Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Crepuscular Mail", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = "Ik Cape", waist = "Sailfi Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }
    sets.engaged.Acc.Reraise = { ammo = "Seething bomblet +1",
        head = "Twilight Helm", neck = "Loricate Torque +1", ear1 = "Schere Earring", ear2 = "Telos Earring",
        body = "Crepuscular Mail", hands = "Sakpata's Gauntlets", ring1 = "Moonlight Ring", ring2 = "Niqmaddu Ring",
        back = "Letalis Mantle", waist = "Ioskeha Belt +1", legs = "Sakpata's Cuisses", feet = "Sakpata's Leggings" }

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
-- function job_pretarget(spell, action, spellMap, eventArgs)
-- end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and player.tp == 3000 then
        if sets.precast.WS[spell.english] then
            if sets.precast.WS[spell.english].MaxTP then
                equip(sets.precast.WS[spell.english].MaxTP)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end

    if state.TreasureMode.value == 'Tag' and S { 'Poisonga', 'Poison', 'Diaga', 'Cyclone' }:contains(spell.english) then
        equip(sets.TreasureHunter)
    end
end

function job_buff_change(buff, gain)
    -- when gaining a buff
    if gain then
        if buff == 'sleep' and player.hp > 50 then
            if not buffactive['charm'] then
                equip(sets.Sleeping)
            end
        elseif buff == 'doom' then
            send_command('gs equip sets.buff.doom')
            send_command('input /p Doomed')

        elseif buff == 'charm' then

            local function count_slip_debuffs()
                local erase_dots = 0
                if buffactive.poison then
                    erase_dots = erase_dots + 1
                end
                if buffactive.dia then
                    erase_dots = erase_dots + 1
                end
                if buffactive.bio then
                    erase_dots = erase_dots + 1
                end
                if buffactive.burn then
                    erase_dots = erase_dots + 1
                end
                if buffactive.choke then
                    erase_dots = erase_dots + 1
                end
                if buffactive.shock then
                    erase_dots = erase_dots + 1
                end
                if buffactive.drown then
                    erase_dots = erase_dots + 1
                end
                if buffactive.rasp then
                    erase_dots = erase_dots + 1
                end
                if buffactive.frost then
                    erase_dots = erase_dots + 1
                end
                if buffactive.helix then
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
        elseif S { 'Aftermath', 'Aftermath: Lv.1', 'Aftermath: Lv.2', 'Aftermath: Lv.3' }:contains(buff) then
            -- update_combat_form()
        end

        -- when losing a buff
    else
        if buff == 'doom' then
            send_command('input /p Doom off.')
            send_command('gs c update')
        elseif buff == 'charm' then
            send_command('input /p Charm off.')
        elseif buff == 'sleep' then
            send_command('gs c update')
        elseif S { 'Aftermath' }:contains(buff) then
            info.AM.level = 0
            update_combat_form()
            send_command('gs c update')
        end
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

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    state.CombatForm:reset()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 1)
    else
        set_macro_page(1, 1)
    end
    send_command("@wait 2; input /lockstyleset 6")
end
