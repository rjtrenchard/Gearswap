-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    ExtraSongsMode may take one of three values: None, Dummy, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy
    
    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.ExtraSongsMode = M { ['description'] = 'Extra Songs', 'None', 'Dummy', 'FullLength' }
    state.HonorMarch = M { ['description'] = 'Honor March', 'None', 'HonorMarch' }

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
    initRecast()
    -- For tracking current recast timers via the Timers plugin.
    custom_timers = {}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('SaveTP', 'None')
    state.HybridMode:options('Normal', 'PDT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    -- information about your job points
    info.JobPoints = {}
    info.JobPoints.Marcato = 20
    info.JobPoints.Tenuto = 20
    info.JobPoints.DurationGift = true


    -- Weapon to use while engaged
    state.WeaponMode = M { ['description'] = 'Weapon Mode', 'Sword', 'Dagger' }

    brd_offense = S { 'Naegling', 'Aeneas', 'Tauret', 'Kaja Knife' }

    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'
    info.HonorMarch = 'Marsyas'
    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 2

    -- Set this to false if you don't want to use custom timers.
    state.UseCustomTimers = M(true, 'Use Custom Timers')

    -- Augmented Gear
    gear.RecastFeet = { name = "Telchine Pigaches", augments = { 'Mag. Evasion+21', 'Song spellcasting time -7%', 'Enh. Mag. eff. dur. +9', } }
    gear.EnhancingFeet = gear.RecastFeet
    gear.CureHands = { name = "Telchine Gloves", augments = { '"Cure" potency +7%', '"Regen" potency +3' } }

    gear.IdleInstrument = { name = "Linos", augments = { 'Mag. Evasion+15', 'Magic dmg. taken -4%', 'HP+20', } }
    gear.MeleeInstrument = { name = "Linos", augments = { 'Accuracy+20', '"Dbl.Atk."+3', 'Quadruple Attack +3', } }
    gear.WSInstrument = { name = "Linos", augments = { 'Accuracy+15 Attack+15', 'Weapon skill damage +3%', 'STR+8', } }

    gear.CastingCape = { name = "Intarabus's Cape", augments = { 'CHR+20', 'Mag. Acc.+10', '"Fast Cast"+10%', 'Mag. Acc.+20/Mag. Dmg.+20' } }
    gear.WSCape = { name = "Intarabus's Cape", augments = { 'STR+20', 'Accuracy+20 Attack+20', 'STR+5', 'Weapon skill damage +10%', } }
    gear.MeleeCape = gear.WSCape

    gear.RefreshFeet = { name = "Chironic Slippers", augments = { 'Crit. hit damage +1%', 'Sklchn.dmg.+4%', '"Refresh"+2', 'Mag. Acc.+11 "Mag.Atk.Bns."+11', } }
    gear.RefreshHands = { name = "Chironic Gloves", augments = { 'Weapon skill damage +2%', 'Pet: Accuracy+17 Pet: Rng. Acc.+17', '"Refresh"+2', 'Mag. Acc.+17 "Mag.Atk.Bns."+17', } }

    info.DWsubs = S { 'NIN', 'DNC' }

    -- Additional local binds
    --send_command('bind ^` gs c cycle ExtraSongsMode')
    info.can_DW = S { 'NIN', 'DNC' }:contains(player.sub_job)
    if info.can_DW then
        send_command('bind numpad7 gs equip sets.Weapons.Sword.DW')
        send_command('bind numpad8 gs equip sets.Weapons.Dagger.DW')
    else
        send_command('bind numpad7 gs equip sets.Weapons.Sword')
        send_command('bind numpad8 gs equip sets.Weapons.Dagger')
    end

    send_command('bind numpad1 input /ma "Horde Lullaby II" <t>')
    send_command('bind numpad2 input /ma "Foe Lullaby II" <t>')

    send_command('bind ^` input /ja Pianissimo <me>')
    send_command('bind !` input /ja Pianissimo <me>')
    send_command('bind ^q input /ma "Chocobo Mazurka" <me>')
    send_command('bind != gs c cycle WeaponMode')
    send_command('bind !- gs c cycle OffenseMode')




    pick_tp_weapon()
    update_weapon_mode(state.WeaponMode.value)

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')

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

    sets.Weapons = {}
    sets.Weapons['Sword'] = { main = "Naegling", sub = "Ammurapi Shield" }
    sets.Weapons['Dagger'] = { main = "Aeneas", sub = "Ammurapi Shield" }
    sets.Weapons['Sword'].DW = { main = "Naegling", sub = "Centovente" }
    sets.Weapons['Dagger'].DW = { main = "Aeneas", sub = "Kaja Knife" }

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = { main = "Kali",
        head = "Fili Calot +1", neck = "Baetyl Pendant", ear1 = "Etiolation Earring", ear2 = "Loquac. Earring",
        body = "Inyanga Jubbah +2", hands = "Gendewitha Gages +1", ring1 = "Rahab Ring", ring2 = "Kishar Ring",
        back = "Fi Follet Cape +1", waist = "Embla Sash", legs = "Ayanmo Cosciales +2", feet = "Bihu Slippers +1" }

    sets.precast.FC.Cure = set_combine(sets.precast.FC, { back = "Pahtli cape" })

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, { waist = "Siegel Sash" })

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
        main = "Pukulatmuj +1",
        head = "Umuthi Hat",
        waist = "Siegel Sash" })

    sets.precast.FC.BardSong = { main = "Kali", range = "Gjallarhorn",
        head = "Fili Calot +1", neck = "Baetyl Pendant", ear1 = "Aoidos' Earring", ear2 = "Loquac. Earring",
        body = "Inyanga Jubbah +2", hands = "Gendewitha Gages +1", ring1 = "Rahab Ring", ring2 = "Kishar Ring",
        back = gear.CastingCape, waist = "Embla Sash", legs = "Ayanmo Cosciales +2", feet = gear.RecastFeet }

    sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, { range = info.ExtraSongInstrument })

    sets.precast['Honor March'] = set_combine(sets.precast.FC.BardSong, { range = info.HonorMarch })


    -- Precast sets to enhance JAs

    sets.precast.JA.Nightingale = { feet = "Bihu Slippers +1" }
    sets.precast.JA.Troubadour = { body = "Bihu Justaucorps +3" }
    sets.precast.JA['Soul Voice'] = { legs = "Bihu Cannions +2" }
    sets.precast.JA['Con Brio'] = { hands = "Bihu Cuffs +2" }
    sets.precast.JA['Con Anima'] = { head = "Bihu Roundlet +2" }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head = "Nahtirah Hat",
        body = "Gendewitha Bliaut +1", hands = "Buremte Gloves",
        back = gear.CastingCape, legs = "Gendewitha Spats", feet = "Gendewitha Galoshes +1" }


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = { ranged = gear.WSInstrument,
        head = "Bihu Roundlet +2", neck = "Fotia Gorget", ear1 = "Ishvara Earring", ear2 = "Moonshade Earring",
        body = "Bihu Justaucorps +3", hands = "Bihu Cuffs +2", ring1 = "Apate Ring", ring2 = "Epaminondas's Ring",
        back = gear.WSCape, waist = "Fotia Belt", legs = "Bihu Cannions +2", feet = "Chironic Slippers" }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        head = "Blistering Sallet +1",
        ring1 = "Ilabrat Ring", ring2 = "Begrudging Ring",
        legs = "Zoar Subligar +1"
    })

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { neck = "Republican Platinum medal", waist = "Sailfi Belt +1" })


    -- Midcast Sets

    -- General set for recast times.
    sets.midcast.FastRecast = {
        head = "Ayanmo Zucchetto +2", ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2", hands = "Gendewitha Gages +1", ring1 = "Rahab Ring", ring2 = "Kishar Ring",
        back = gear.CastingCape, waist = "Sailfi Belt +1", legs = "Ayanmo Cosciales +2", feet = "Ayanmo Gambieras +2" }



    -- Gear to enhance certain classes of songs.  No instruments added here since Gjallarhorn is being used.
    sets.midcast.Ballad = { legs = "Fili Rhingrave" }
    sets.midcast.Lullaby = { hands = "Brioso Cuffs +2" }
    sets.midcast.Madrigal = { head = "Fili Calot +1", back = "Intrabus's Cape" }
    sets.midcast.Prelude = { back = "Intrabus's Cape" }
    sets.midcast.March = { hands = "Fili Manchettes" }
    sets.midcast.Minuet = { body = "Fili Hongreline +1" }
    sets.midcast.Minne = {}
    sets.midcast.Paeon = { head = "Brioso Roundlet +2" }
    sets.midcast.Carol = { head = "Fili Calot +1",
        body = "Fili Hongreline +1", hands = "Fili Manchettes",
        legs = "Fili Rhingrave", feet = "Fili Cothurnes +1" }
    sets.midcast["Sentinel's Scherzo"] = { feet = "Fili Cothurnes +1" }
    sets.midcast['Magic Finale'] = { legs = "Fili Rhingrave" }
    sets.midcast['Honor March'] = set_combine(sets.midcast.SongEffect, { ranged = info.HonorMarch })

    sets.midcast['Horde Lullaby'] = set_combine(sets.midcast.Lullaby, { ranged = "Daurdabla" })
    sets.midcast['Horde Lullaby II'] = sets.midcast['Horde Lullaby']

    sets.midcast.Mazurka = { range = info.ExtraSongInstrument }


    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEffect = { main = "Kali", range = "Gjallarhorn",
        head = "Fili Calot +1", neck = "Moonbow whistle +1", ear1 = "Handler's Earring +1", ear2 = "Loquacious Earring",
        body = "Fili Hongreline +1", hands = "Fili Manchettes", ring1 = "Rahab Ring", ring2 = "Kishar Ring",
        back = gear.CastingCape, waist = "Corvax Sash", legs = "Inyanga Shalwar +2", feet = "Brioso Slippers +2" }

    -- For song debuffs (duration primary, accuracy secondary)
    sets.midcast.SongDebuff = { main = "Kali", sub = "Ammurapi Shield", range = "Gjallarhorn",
        head = "Brioso Roundlet +2", neck = "Moonbow Whistle +1", ear1 = "Dignitary's Earring", ear2 = "Crepuscular Earring",
        body = "Fili Hongreline +1", hands = "Fili Manchettes", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = gear.CastingCape, waist = "Acuity Belt +1", legs = "Marduk's Shalwar +1", feet = "Brioso Slippers +2" }

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.ResistantSongDebuff = { main = "Kali", sub = "Ammurapi Shield", range = "Gjallarhorn",
        head = "Brioso Roundlet +2", neck = "Moonbow Whistle +1", ear1 = "Dignitary's Earring", ear2 = "Crepuscular Earring",
        body = "Brioso Justaucorps +2", hands = "Fili Manchettes", ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = gear.CastingCape, waist = "Acuity Belt +1", legs = "Brioso Cannions +2", feet = "Brioso Slippers +2" }

    -- Song-specific recast reduction
    sets.midcast.SongRecast = {
        neck = "Baetyl Pendant", ear1 = "Etiolation Earring", ear2 = "Loquacious Earring",
        body = "Inyanga Jubbah +2", hands = "Gendewitha Gages +1", ring1 = "Rahab Ring", ring2 = "Kishar Ring",
        back = gear.CastingCape, waist = "Embla Sash", legs = "Fili Rhingrave" }

    sets.midcast.Daurdabla = set_combine(sets.midcast.FastRecast, sets.midcast.SongRecast, { range = info.ExtraSongInstrument })

    -- Cast spell with normal gear, except using Daurdabla instead
    sets.midcast.Daurdabla = { range = info.ExtraSongInstrument }

    -- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
    sets.midcast.DaurdablaDummy = { main = "Kali", range = info.ExtraSongInstrument,
        head = "Volte Cap", neck = "Incanter's Torque", ear1 = "Dignitary's Earring", ear2 = "Crepuscular Earring",
        body = "Ayanmo corazza +2", hands = "Ayanmo manopolas +2", ring1 = "Rahab Ring", ring2 = "Kishar Ring",
        back = gear.CastingCape, waist = "Embla Sash", legs = "Ayanmo Cosciales +2", feet = "Volte Boots" }

    -- Other general spells and classes.
    sets.midcast['Healing Magic'] = {
        head = "Vanya Hood", neck = "Incanter's Torque",
        hands = "Inyanga Dastanas +2", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = "Oretania's Cape" }

    sets.midcast.Cure = set_combine(sets.midcast['Healing Magic'], { main = "Daybreak", sub = "Ammurapi Shield",
        head = "Vanya Hood", neck = "Nodens Gorget", ear1 = "Regal Earring", ear2 = "",
        body = "Gendewitha Bliaut +1", hands = gear.CureHands, ring1 = "Stikini Ring +1", ring2 = "Metamorph Ring +1",
        back = "Oretania's Cape", legs = "Chironic Hose", feet = "Gendewitha Galoshes +1" })

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Stoneskin = set_combine(sets.midcast["Enhancing Magic"], {
        neck = "Nodens Gorget", ear1 = "Earthcry Earring",
        waist = "Seigel Sash", legs = "Shedir Seraweels" })

    sets.midcast.Cursna = {
        neck = "Malison Medallion",
        hands = "Hieros Mittens", ring1 = "Ephedra Ring",
        feet = "Gendewitha Galoshes +1" }

    sets.midcast['Enhancing Magic'] = { main = "Pukulatmuj +1",
        head = "Umuthi Hat", neck = "Incanter's Torque", ear1 = "Mimir Earring", ear2 = "Andoaa Earring",
        body = "Anhur Robe", hands = "Inyanga Dastanas +2", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = "Fi Follet Cape +1", waist = "Embla Sash", legs = "Shedir Seraweels", feet = gear.EnhancingFeet }
    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], { legs = 'Shedir Seraweels' })
    sets.midcast.BarStatus = sets.midcast.BarElement

    sets.midcast.Banish = { head = "Ipoca Beret" }

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
        head = "Befouled Crown", neck = "Bathy Choker +1",
        body = "Gendewitha Bliaut +1", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        legs = "Assiduity Pants +1" }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = { range = gear.IdleInstrument,
        head = "Ayanmo Zucchetto +2", neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Ayanmo Corazza +2", hands = gear.RefreshHands, ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = gear.CastingCape, waist = "Flume Belt +1", legs = "Assiduity Pants +1", feet = gear.RefreshFeet }

    sets.idle.PDT = { range = gear.IdleInstrument,
        head = "Ayanmo Zucchetto +2", neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Ayanmo Corazza +2", hands = "Ayanmo Manopolas +2", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = gear.MeleeCape, waist = "Flume Belt +1", legs = "Assiduity Pants +1", feet = "Ayanmo Gambieras +2" }

    sets.idle.Town = { main = "Daybreak", sub = "Ammurapi Shield", range = gear.IdleInstrument,
        head = "Befouled Crown", neck = "Loricate Torque +1", ear1 = "Etiolation Earring", ear2 = "Eabani Earring",
        body = "Bihu Jstcorps. +3", hands = "Bihu Cuffs +2", ring1 = "Stikini Ring +1", ring2 = "Defending Ring",
        back = "Umbra Cape", waist = "Flume Belt +1", legs = "Bihu Cannions +2", feet = "Fili Cothurnes +1" }

    sets.idle.Weak = sets.idle.PDT

    sets.idle.Refresh = { main = "Kali", sub = "Ammurapi Shield",
        head = "Befouled Crown",
        body = "Gendewitha Bliaut +1", ring1 = "Stikini Ring +1", ring2 = "Stikini Ring +1",
        back = gear.MeleeCape, legs = "Assiduity Pants +1", feet = "Fili Cothurnes +1", }

    sets.idle.HonorMarch = set_combine(sets.idle, { range = info.HonorMarch })


    -- Defense sets

    sets.defense.PDT = { main = gear.Staff.PDT, sub = "Enki Strap",
        head = "Ayanmo Zucchetto +2", neck = "Combatant's Torque", ear1 = "Brutal Earring", ear2 = "Crepuscular Earring",
        body = "Ayanmo Corazza +2", hands = "Ayanmo Manopolas +2", ring1 = "Moonlight Ring", ring2 = "Defending Ring",
        back = gear.MeleeCape, waist = "Reiki Yotai", legs = "Inyanga Shalwar +2", feet = "Ayanmo Gambieras +2" }

    sets.defense.MDT = { main = gear.Staff.PDT, sub = "Enki Strap",
        head = "Ayanmo Zucchetto +2", neck = "Loricate Torque +1", ear1 = "Brutal Earring", ear2 = "Crepuscular Earring",
        body = "Ayanmo Corazza +2", hands = "Ayanmo Manopolas +2", ring1 = "Archon Ring", ring2 = "Defending Ring",
        back = gear.MeleeCape, waist = "Reiki Yotai", legs = "Inyanga Shalwar +2", feet = "Ayanmo Gambieras +2" }

    sets.Kiting = { feet = "Fili Cothurnes +1" }

    sets.latent_refresh = { waist = "Fucho-no-obi" }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    sets.weapons = { main = gear.MainHand, sub = gear.SubHand }

    -- Basic set for if no TP weapon is defined.
    sets.engaged = set_combine(sets.weapons, { range = gear.MeleeInstrument,
        head = "Ayanmo Zucchetto +2", neck = "Combatant's Torque", ear1 = "Telos Earring", ear2 = "Crepuscular Earring",
        body = "Ayanmo Corazza +2", hands = "Gazu Bracelet +1", ring1 = "Moonlight Ring", ring2 = "Ilabrat Ring",
        back = gear.MeleeCape, waist = "Sailfi belt +1", legs = "Ayanmo Cosciales +2", feet = "Ayanmo Gambieras +2" })

    sets.engaged.PDT = set_combine(sets.engaged, { neck = "Loricate Torque +1", ring2 = "Defending Ring" })

    -- Set if dual-wielding
    sets.engaged.DW = set_combine(sets.weapons, { range = gear.MeleeInstrument,
        head = "Ayanmo Zucchetto +2", neck = "Combatant's Torque", ear1 = "Telos Earring", ear2 = "Suppanomimi",
        body = "Ayanmo Corazza +2", hands = "Gazu Bracelet +1", ring1 = "Moonlight Ring", ring2 = "Ilabrat Ring",
        back = gear.MeleeCape, waist = "Reiki Yotai", legs = "Ayanmo Cosciales +2", feet = "Ayanmo Gambieras +2" })

    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, { neck = "Loricate Torque +1", ring2 = "Defending Ring" })
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type ~= 'WeaponSkill' then
        setRecast()
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- check_engaged()
    -- if spell.type == 'BardSong' then
    -- Auto-Pianissimo
    --[[if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end]]
    -- originally for honor march, turns out i'm just an idiot and didn't define precast sets.
    --[[if spell.english == 'Honor March' then
            local delay_flag = false
            if player.equipment.ranged == info.HonorMarch then delay_flag = true end
            equip(sets.precast['Honor March'])
            if delay_flag then cast_delay(1.0) end
        end]]
    -- end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        elseif spell.skill == 'Enhancing Magic' then
            if spellMap == 'BarElement' then
                equip(sets.midcast.BarElement)
            elseif spellMap == 'BarStatus' then
                equip(sets.midcast.BarStatus)
            end
        end

    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if spell.english == 'Honor March' then
            equip(sets.midcast['Honor March'])
        elseif state.ExtraSongsMode.value == 'FullLength' then
            equip(sets.midcast.Daurdabla)
        end
        state.ExtraSongsMode:reset()
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
    end
    -- check_engaged()
    eventArgs.handled = false
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- if we changed weapons, change back.
    if hasRecast() then
        equip(recallRecast())
        resetRecast()
    end
    --[[if state.OffenseMode.value == 'Magic' then
        equip(sets.idle.Weap+
        on)
    end]]
    eventArgs.handled = false
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

    if stateField == 'Weapon Mode' then
        --update_weapon_mode(newValue)
        job_update()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
-- initializes weapon recast handler
function initRecast()
    sets._Recast = {}
    info._RecastFlag = false
end

-- sets the Recast weapon set to what is currently equipped
-- affected slots: main sub ranged ammo
function setRecast()
    if not hasRecast() then
        sets._Recast.main = player.equipment.main
        sets._Recast.sub = player.equipment.sub
        sets._Recast.range = player.equipment.range
        sets._Recast.ammo = player.equipment.ammo
    end
    info._RecastFlag = sets._Recast.main or sets._Recast.sub or sets._Recast.range or sets._Recast.ammo
end

-- resets the Recast weapon set to nil
function resetRecast()
    sets._Recast = { main = nil, sub = nil, range = nil, ammo = nil }
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

function check_engaged()
    -- if state.OffenseMode.value == 'SaveTP' then
    --     if player.status == 'Engaged' then
    --         disable('main','sub')
    --     else
    --         enable('main','sub')
    --     end
    -- else
    --     enable('main', 'sub')
    -- end
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_weapon_mode(state.WeaponMode.value)
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        return 'DaurdablaDummy'
    else
        return 'SongEffect'
    end
end

-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end

    local current_time = os.time()

    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.

    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name, expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name, expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end

    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).

        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "' .. spell.name .. '"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end

        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
        else
            local rep, repsong
            for song_name, expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "' .. repsong .. '"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "' .. spell.name .. '" ' .. dur .. ' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    local amt_added = 0

    if player.equipment.range == "Miracle Cheer" then
        if S { 'Ballad', 'Paeon', 'Madrigal', 'Ballad', 'Minuet', 'Minne', 'March', 'Scherzo', 'Mazurka' }:contains(spellMap) then
            return math.floor(15 * 60)
        else
            mult = mult + 0.3
        end
    end

    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Marsyas" then mult = mult + 0.5 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Blurred Harp" then mult = mult + 0.1 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Blurred Harp +1" then mult = mult + 0.2 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Homestead Flute" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall

    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.main == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Kali" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.neck == "Moonbow Whistle" then mult = mult + 0.2 end
    if player.equipment.neck == "Moonbow Whistle +1" then mult = mult + 0.3 end
    if player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if player.equipment.body == "Fili Hongreline" then mult = mult + 0.11 end
    if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
    if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
    if player.equipment.legs == "Inyanga Shalwar" then mult = mult + 0.12 end
    if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
    if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
    if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end

    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +2" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +3" then mult = mult + 0.2 end
    if spellMap == 'Madrigal' and player.equipment.head == "Fili Calot" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Fili Calot +1" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Fili Hongreline" then mult = mult + 0.11 end
    if spellMap == 'Minuet' and player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Fili Manchettes' then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Fili Manchettes +1' then mult = mult + 0.1 end
    if spellMap == 'Lullaby' and player.equipment.range == "Blurred Harp" then mult = mult + 0.2 end
    if spellMap == 'Ballad' and player.equipment.range == "Blurred Harp +1" then mult = mult + 0.2 end
    if spellMap == 'Ballad' and player.equipment.legs == "Fili Rhingrave" then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Fili Rhingrave +1" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Fili Cothurnes" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Fili Cothurnes +1" then mult = mult + 0.1 end

    if buffactive.Troubadour then
        mult = mult * 2
    end
    if S { "Sentinel's Scherzo", "Goddess's Hymnus", "Raptor Mazurka", "Chocobo Mazurka" }:contains(spellName) then
        if buffactive['Soul Voice'] then
            mult = mult * 2
        elseif buffactive['Marcato'] then
            mult = mult * 1.5
        end
    end

    if info.JobPoints.DurationGift then mult = mult + 0.05 end

    if buffactive.Marcato and not buffactive["Soul Voice"] then
        amt_added = amt_added + info.JobPoints.Marcato * 1
    end

    if buffactive.Tenuto and not buffactive.pianissimo then
        amt_added = amt_added + info.JobPoints.Tenuto * 2
    end

    local totalDuration = math.floor(mult * (120 + amt_added))

    return totalDuration
end

-- Examine equipment to determine what our current TP weapon is.
function pick_tp_weapon()
    --[[if brd_offense:contains(player.equipment.main) then
        state.CombatWeapon:set('Dagger')
        
        if S{'NIN','DNC'}:contains(player.sub_job) and brd_offense:contains(player.equipment.sub) then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    else]]
    if S { 'NIN', 'DNC' }:contains(player.sub_job) then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
    --end
end

function update_weapon_mode(w_state)
    if S { 'NIN', 'DNC' }:contains(player.sub_job) then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
    -- overwrite weapons and equip
    update_sets()
    --equip(sets.weapons)
end

function update_sets()

end

-- Function to reset timers.
function reset_timers()
    for i, v in pairs(custom_timers) do
        send_command('timers delete "' .. i .. '"')
    end
    custom_timers = {}
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
    send_command("@wait 5;input /lockstyleset 13")
end

windower.raw_register_event('zone change', reset_timers)
windower.raw_register_event('logout', reset_timers)
