-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Mod', 'Crit')
    state.HybridMode:options('Normal', 'PDT', 'MDT', 'Evasion')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Low')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Fotia Gorget"
    gear.default.weaponskill_waist = "Fotia Belt"

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind ^=')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {head="Volte Cap", hands="Plunderer's Armlets +1", waist="Chaac Belt", feet="Skulker's poulaines +1"}
    sets.TreasureHunterTag = {hands="Plunderer's Armlets +1", waist="Chaac Belt", feet="Skulkuer's Poulaines"}
    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}
    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    sets.buff['Sneak Attack'] = {ammo="Cath Palug Stone",
        head="Adhemar Bonnet +1",neck="Combatant's Torque",ear1="Sherida Earring",ear2="Odr Earring",
        body="Pillager's Vest +2",hands="Skulker's armlets",ring1="Regal Ring",ring2="Ilabrat Ring",
        back=gear.melee_cape,waist="Chaac Belt",legs="Pillager's Culottes +1",feet="Plunderer's Poulaines +1"}

    sets.buff['Trick Attack'] = {ammo="Cath Palug Stone",
        head="Adhemar Bonnet +1",neck="Combatant's Torque",ear1="Sherida Earring",ear2="Etiolation Earring",
        body="Pillager's Vest +2",hands="Pillager's armlets +1",ring1="Regal Ring",ring2="Ilabrat Ring",
        back=gear.melee_cape,waist="Chaac Belt",legs="Pillager's Culottes +1",feet="Plunderer's Poulaines +1"}

    --sets.buff['Feint'] = {legs="Plunderer's Culottes"}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet"}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet"}
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +1"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +2"}
    sets.precast.JA['Conspirator'] = {body="Skulker's Vest"}
    sets.precast.JA['Steal'] = {ammo="barathrum",head="Plunderer's Bonnet",hands="Pillager's Armlets +1",legs="Pillager's Culottes +1",feet="Pillager's Poulaines +1"}
    sets.precast.JA['Despoil'] = set_combine(sets.precast.JA['Steal'],{ammo="Barathrum",legs="Skulker's Culottes",feet="Skulker's poulaines +1"})
    sets.precast.JA['Mug'] = {ammo="Barathrum",head="Mummu Bonnet +1", neck="Magoraga bead necklace", ear1="suppanomimi",
    body="Meghanada cuirie +1", hands="Malignance Gloves", ring1="Regal Ring", ring2="Ilabrat Ring",
    back=gear.melee_cape,waist="Chaac belt", legs="Herculean Trousers", feet="Mummu Gamashes +1"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {legs="Plunderer's Culottes"} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    gear.melee_cape = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Damage taken-5%',}}
    gear.crit_cape = { name="Toutatis's Cape", augments={'DEX+3','Accuracy+20 Attack+20','Crit.hit rate+7',}}
    gear.dex_ws_cape = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
    gear.str_ws_cape = gear.dex_ws_cape

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Meghanada Visor +1", 
        body="Meghanada Cuirie +1",hands="Plunderer's Armlets +1",
        back="Iximulew Cape",waist="Chaac Belt",legs="Malignance Tights",feet="Plunderer's Poulaines +1"}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Sapience Orb",
        head="Herculean Helm",neck="Baetyl Pendant",ear1="Loquacious Earring",ear2="Etiolation Earring",
        hands="Thaumas Gloves",ring1="Kishar Ring",ring2="Prolix Ring",}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


    -- Ranged snapshot gear
    sets.precast.RA = {head="Malignance Chapeau",neck="Iskur Gorget",
        hands="Mummu Wrists +2",ring2="stormsoul ring",
        waist="eschan stone",legs="Meghanada chausses +1",feet="Meghanada Jambeaux +1"}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Seething Bomblet +1",
        head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Moonshade Earring",
        body="Meghanada cuirie +1",hands="Meghanada Gloves +2",ring2="Karieyh Ring +1",ring1="Regal Ring",
        back=gear.str_ws_cape,waist="Fotia Belt",legs="Pillager's culottes +1",feet="Meghanada Jambeaux +1"}
    sets.precast.WS.Crit = set_combine(sets.precast.WS, {ammo="Yetshila +1", body="Pillager's Vest +2", hands="Mummu Wrists +2",ring1="Begrudging Ring", ring2="Mummu Ring", back=gear.crit_cape})
    sets.precast.WS.SingleHit = set_combine(sets.precast.WS, {})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Honed Tathlum"})
    sets.precast.WS.Low = set_combine(sets.naked, {main="",sub="",ranged="", head="Malignance Chapeau", neck="Fotia Gorget", body="Malignance Tabard", hands="Malignance Gloves", waist="Fotia Belt", legs="Malignance Tights", feet="Malignance Boots"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {hands="Adhemar Wristbands +1",ring1="Ilabrat Ring"})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].Att = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Att,  {})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Att, {})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Att, {})
    sets.precast.WS['Exenterator'].Low = sets.precast.WS.Low

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {ring1="Regal Ring"})
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Att = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Att, {})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Att, {})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Att, {})
    sets.precast.WS['Dancing Edge'].Low = sets.precast.WS.Low

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.Crit, {ammo="Yetshila +1", ear2="Odr Earring", body="Pillager's Vest +2", hands="Adhemar Wristbands +1"})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].Att = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Att, {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Att, {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Att, {})
    sets.precast.WS['Evisceration'].Low = sets.precast.WS.Low

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {ammo="Cath Palug Stone",
        head="Pillager's Bonnet +3", neck="Caro Necklace",ear1="Odr Earring",ear2="Moonshade Earring", 
        body="Pillager's Vest +2", 
        back=gear.dex_ws_cape, waist="Sailfi Belt +1", legs="Herculean Trousers"})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].Att = set_combine(sets.precast.WS["Rudra's Storm"], {ring2="Ilabrat Ring"})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Att, {ammo="Yetshila +1", body="Pillager's Vest +2"})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Att, {ammo="Yetshila +1", body="Pillager's Vest +2"})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Att, {ammo="Yetshila +1", body="Pillager's Vest +2"})
    sets.precast.WS["Rudra's Storm"].Low = sets.precast.WS.Low

    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +3", ear1="Odr Earring",ear2="Moonshade Earring", ring1="Epona's Ring"})
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {ammo="Honed Tathlum", back=gear.dex_ws_cape})
    sets.precast.WS['Shark Bite'].Att = set_combine(sets.precast.WS['Shark Bite'], {ring2="Ilabrat Ring"})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Att, {ammo="Yetshila +1",
        body="Pillager's Vest +2",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Att, {ammo="Yetshila +1",
        body="Pillager's Vest +2",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Att, {ammo="Yetshila +1",
        body="Pillager's Vest +2",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].Low = sets.precast.WS.Low

    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +3",ear1="Odr Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Honed Tathlum"})
    sets.precast.WS['Mandalic Stab'].Att = set_combine(sets.precast.WS['Mandalic Stab'], {back="Kayapa Cape"})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Att, {ammo="Yetshila +1",
        body="Pillager's Vest +2",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Att, {ammo="Yetshila +1",
        body="Pillager's Vest +2",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Att, {ammo="Yetshila +1",
        body="Pillager's Vest +2",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].Low = sets.precast.WS.Low


    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +3", neck="Caro Necklace", ear1="Ishvara Earring", back=gear.str_ws_cape, waist="Sailfi Belt +1", legs="Herculean Trousers"})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Savage Blade'].Att = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Savage Blade'].SA = set_combine(sets.precast.WS['Savage Blade'], {ammo="Yetshila +1"})
    sets.precast.WS['Savage Blade'].TA = set_combine(sets.precast.WS['Savage Blade'], {ammo="Yetshila +1"})
    sets.precast.WS['Savage Blade'].SATA = set_combine(sets.precast.WS['Savage Blade'], {ammo="Yetshila +1"})
    sets.precast.WS['Savage Blade'].Low = sets.precast.WS.Low

    sets.precast.WS['Aeolian Edge'] = {ammo="Seething Bomblet +1",
        head="Herculean Helm",neck="Sanctity Necklace",ear1="Hecate's Earring",ear2="Friomisi Earring",
        body="Malignance Tabard",hands="Herculean Gloves",ring1="Dingir Ring",ring2="Karieyh Ring +1",
        back=gear.dex_ws_cape, waist="Eschan Stone",legs="Herculean Trousers",feet="Malignance Boots"}
    

    --sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

    sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunterTag)

    sets.precast.WS['Energy Drain'] = set_combine(sets.precast.WS['Aeolian Edge'], {head="Pixie Hairpin +1",ring2="Archon Ring"})
    sets.precast.WS['Energy Steal'] = sets.precast.WS['Energy Drain']


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head="Herculean Helm",ear2="Loquacious Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Prolix Ring",
        back="Canny Cape",legs="Malignance Tights",feet="Malignance Boots"}

    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {neck="Magoraga Bead Necklace"})

    sets.midcast.FC = set_combine(sets.midcast.FastRecast, {})
    sets.midcast.FC['Poisonga'] = set_combine(
        {   
            head="Herculean Helm", body="Pillager's Vest +2", hands="Meghanada Gloves +2", ear2="Loquacious Earring",
            legs="Meghanada Chausses +1", waist="Sailfi belt +1", feet="Plunderer's Poulaines +1", 
            ear1="loquacious earring", ring1="Prolix ring"}, 
        sets.TreasureHunterTag)
    sets.midcast['Poisonga'] = sets.midcast.FC['Poisonga']
    sets.midcast['Poison'] = sets.midcast['Poisonga']
    sets.midcast['Poison'].FC = sets.midcast['Poisonga']

    -- Ranged gear
    sets.precast.RA = {
        waist="Aquiline Belt"
    }

    sets.midcast.RA = {
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Clearview Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Dingir Ring",ring2="Regal Ring",
        back="Libeccio Mantle",waist="Eschan Stone",legs="Malignance Tights",feet="Malignance Boots"}

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {head="Malignance Chapeau", body="Malignance Tabard",hands="Malignance Gloves",legs="Malignance Tights",feet="Malignance Boots"})


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {neck="Sanctity Necklace",
        ring1="Sheltered Ring"}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Skadi's Jambeaux +1"}

    sets.idle.Town = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Flume Belt +1",legs="Malignance Tights",feet="Skadi's Jambeaux +1"}

    sets.idle.Weak = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Eabani Earring",ear2="Etiolation Earring",
        body="Malignance Tabard",hands="Malignance Glvoes",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Flume Belt +1",legs="Malignance Tights",feet="Skadi's Jambeaux +1"}


    -- Defense sets

    sets.defense.Evasion = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Eabani Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Flume Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Malignance Chapeau",neck="Loricate Torque +1",
        body="Malignance Tabard",hands="Malignance Gloves",ring2="Defending Ring",
        back=gear.melee_cape,waist="Flume Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.MDT = {ammo="Demonry Stone",
        head="Malignance Chapeau",neck="Loricate Torque +1", ear1="Eabani Earring", ear2="crepuscular earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Archon Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {ammo="Ginsen",
        head="Adhemar Bonnet +1",neck="Anu Torque",ear1="Dedition Earring",ear2="Telos Earring",
        body="Pillager's Vest +2",hands="Adhemar Wristbands +1",ring1="Moonlight Ring",ring2="Epona's Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Meghanada chausses +1",feet="Plunderer's Poulaines +1"}
    sets.engaged.Acc = {ammo="Seething Bomblet +1",
        head="Malignance Chapeau",neck="Combatant's Torque",ear1="Sherida Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
        
    -- Mod set for behind mob
    sets.engaged.Mod = set_combine(sets.engaged,{body="Plunderer's Vest"})

    -- Mod set for Crits
    sets.engaged.Crit = set_combine(sets.engaged,{ammo="Yetshila +1",head="Mummu Bonnet +1",ear2="Odr Earring",body="Mummu Jacket +1",hands="Mummu Wrists +2",legs="Mummu Kecks +1",feet="Mummu Gamashes +1"})

    sets.engaged.Evasion = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Sanctity Necklace",ear1="Eabani Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight Ring",ring2="Epona's Ring",
        back="Canny Cape",waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Acc.Evasion = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Ej Necklace",ear1="Eabani Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight Ring",ring2="Regal Ring",
        back="Canny Cape",waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.PDT = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Dedition Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    sets.engaged.Acc.PDT = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Sherida Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Regal Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.MDT = set_combine(sets.engaged.PDT, {ammo="Yamarang",ear2="Eabani Earring"})
    sets.engaged.Acc.MDT = set_combine(sets.engaged.MDT, {})

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
    -- remap Evisceration to Savage Blade when holding a sword.
    if spell.english == 'Evisceration' and player.equipment.main == 'Naegling' then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Savage Blade"')
    end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' then --or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        --equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    
    if player.sub_job == 'DNC' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'WAR' then
        set_macro_page(3, 6)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 6)
    else
        set_macro_page(4, 6)
    end
    send_command( "@wait 5;input /lockstyleset 1" )
end


