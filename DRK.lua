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
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod', 'Low')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    state.WeaponMode = M{['description']='Weapon Mode', 'greatsword', 'scythe', 'greataxe', 'sword', 'club'}
    state.Verbose = M{['description']='Verbosity', 'Normal', 'Verbose', 'Debug'}
    
    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
    --send_command('bind != gs c cycle WeaponMode')

    send_command('bind numpad1 gs equip sets.Weapons.greatsword')
    send_command('bind numpad2 gs equip sets.Weapons.scythe')
    send_command('bind numpad3 gs equip sets.Weapons.greataxe')
    send_command('bind numpad4 gs equip sets.Weapons.sword')
    send_command('bind numpad5 gs equip sets.Weapons.club')

    sets.Weapons = {}
    sets.Weapons['scythe'] = {main="Apocalypse", sub="Utu Grip"}
    sets.Weapons['greatsword'] = {main="Caladbolg", sub="Utu Grip"}
    sets.Weapons['greataxe'] = {main="Lycurgos", sub="Utu Grip"}
    sets.Weapons['sword'] = {main="Naegling", sub="Blurred Shield +1"}
    sets.Weapons['club'] = {main="Loxotic Mace +1", sub="Blurred Shield +1"}

    gear.default.obi_waist = "Eschan Stone"
    gear.default.drain_waist = "Austerity Belt +1"

    gear.melee_cape = { name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.ws_cape = {name="Ankou's Mantle", augments={'STR+20', 'Accuracy+20 Attack+20', 'Weapon skill damage +10%'}}
    gear.torcleaver_cape = { name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}}
    gear.casting_cape = { name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}
    
    gear.torcleaver_helm = { name="Odyssean Helm", augments={'Mag. Acc.+23','Weapon skill damage +3%','VIT+10','Attack+2',}}
    gear.torcleaver_gauntlets = { name="Odyssean Gauntlets", augments={'VIT+9','Enmity+5','Weapon skill damage +3%','Accuracy+13 Attack+13','Mag. Acc.+1 "Mag.Atk.Bns."+1',}}

    gear.WSDayEar1 = "Brutal Earring"
    gear.WSDayEar2 = "Moonshade Earring"
    gear.WSDayEar3 = "Thrud Earring"
    gear.WSNightEar1 = "Lugra Earring +1"
    gear.WSNightEar2 = "Lugra Earring"
    gear.WSNightEar3 = "Lugra Earring"

    gear.Moonshade = {}
    gear.Moonshade.name = 'Moonshade Earring'
    gear.default.Moonshade = 'Ishvara Earring'

    gear.WSEarBrutal = {name=gear.WSDayEar1}
    gear.WSEarMoonshade = {name=gear.WSDayEar2}
    gear.WSEarThrud = {name=gear.WSDayEar3}

    info.Weapons = {}
    info.Weapons.Type = {
        ['Naegling'] = 'sword',
        ['Zulfiqar'] = 'greatsword', ['Caladbolg'] = 'greatsword',
        ['Lycurgos'] = 'greataxe',
        ['Kaja Axe']= 'axe',['Dolichenus']='axe',
        ['Apocalypse'] = 'scythe', ['Father Time'] = 'scythe', ['Liberator'] = 'scythe', ['Redemption'] = 'scythe', ['Anguta'] = 'scythe',
        ['Loxotic Mace +1'] = 'club',['Loxotic Mace'] = 'club',
        ['empty'] = 'handtohand',
        ['Blurred Shield']= 'shield', ['Blurred Shield +1'] = 'shield', ['Adapa Shield'] = 'shield',
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
    --list of two handed weapon types
    info.Weapons.Twohanded = S{'greatsword', 'greataxe','scythe','staff','greatkatana','polearm'}
    info.Weapons.Onehanded = S{'sword', 'club', 'katana', 'dagger', 'axe'}
    info.Weapons.HandtoHand = S{'handtohand'}
    info.Weapons.Ranged = S{'throwing', 'archery', 'marksmanship'}
    info.Weapons.Shields = S{'shield'}

    -- macro book locations
    info.macro_sets = {}
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

    info.lastWeapon = nil


    -- Event driven functions
    ticker = windower.register_event('time change', function(myTime)
        if isMainChanged() then
            procSub()
            weapon_macro_book()
            determine_combat_weapon()
        end
        if (myTime == 17*60 or myTime == 7*60) then 
            procTime(myTime)
            if (player.status == 'Idle' or state.Kiting.value) then
                update_combat_form()
            end
        end
    end)

    info.AM = {}
    info.AM.potential = 0
    info.AM.level = 0
    info.TP = 0

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
        echo('new: ' .. new_tp .. ' old: '.. old_tp, 2)

    end)

    update_weapon_mode(state.WeaponMode.value)
    update_combat_form()
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    windower.unregister_event(ticker)
    windower.unregister_event(tp_ticker)
    send_command('unbind ^`')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Arcane Circle'] = {feet="Ignominy Sollerets +1"}
    sets.precast.JA['Weapon Bash'] = {hands="Ignominy Gauntlets +2"}
    sets.precast.JA['Blood Weapon'] = {body="Fallen's Cuirass"}
    sets.precast.JA['Dark Seal'] = {head="Fallen's Burgeonet +2"}
    sets.precast.JA['Diabolic Eye'] = {hands="Fallen's Finger Gauntlets +2"}
    sets.precast.JA['Souleater'] = {head="Ignominy Burgeonet +1", legs="Fallen's Flanchard +3"}
    sets.precast.JA['Nether Void'] = {legs="Heathen's Flanchard +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -------------------------------------------------------------------------------------------------------------------
    -- Weaponskill sets
    -------------------------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Knobkierrie",
        head="Fallen's Burgeonet +2",neck="Fotia Gorget",ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Ignominy Cuirass +3",hands="Valorous Mitts",ring1="Regal Ring",ring2="Karieyh Ring +1",
        back=gear.ws_cape,waist="Fotia Belt",legs="Fallen's Flanchard +3",feet="Sulevia's Leggings +2"}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    sets.precast.WS.SingleHit = set_combine(sets.precast.WS,{neck="Abyssal Beads +2", waist="Sailfi Belt +1"})

    sets.precast.WS.MultiHit = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm",neck="Fotia Gorget",ear1=gear.WSEarThrud, ear2="Moonshade Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Regal Ring",ring2="Niqmaddu Ring",
        back=gear.multi_cape, waist="Fotia Belt", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}

    sets.precast.WS.Magic = {ammo="Knobkierrie",
        head="Flamma Zucchetto +2", neck="Baetyl Pendant", ear1="Friomisi Earring", ear2="Malignance Earring",
        body="Ignominy Cuirass +3", hands="Valorous Mitts", ring1="Acumen Ring", ring2="Karieyh Ring +1",
        back=gear.ws_cape, waist="Eschan Stone", legs="Fallen's Flanchard +3", feet="Sulevia's Leggings +2"}

    sets.precast.WS.Crit = {ammo="Yetshila +1",
    head="Sakpata's Helm",neck="Fotia Gorget",ear1=gear.WSEarThrud,ear2="Moonshade Earring",
    body="Ignominy Cuirass +3",hands="Flamma Manopolas +2",ring1="Regal Ring",ring2="Begrudging Ring",
    back=gear.ws_cape,waist="Fotia Belt",legs="Fallen's Flanchard +3", feet="Sulevia's Leggings +2"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    -- Scythe Weaponskills
    sets.precast.WS['Spinning Scythe'] = set_combine(sets.precast.WS.SingleHit, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Spinning Scythe'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Spinning Scythe'].Mod = set_combine(sets.precast.WS['Spinning Scythe'], {feet="Ratri Sollerets +1"})

    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS.SingleHit, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Spiral Hell'].Mod = set_combine(sets.precast.WS['Spiral Hell'], {feet="Ratri Sollerets +1"})

    sets.precast.WS['Entropy'] = set_combine(sets.precast.WS.MultiHit, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Entropy'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Entropy'].Mod = set_combine(sets.precast.WS['Entropy'], {feet="Ratri Sollerets +1"})

    sets.precast.WS['Quietus'] = set_combine(sets.precast.WS.SingleHit, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Quietus'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Quietus'].Mod = set_combine(sets.precast.WS['Quietus'], {feet="Ratri Sollerets +1"})

    sets.precast.WS['Guillotine'] = set_combine(sets.precast.WS.MultiHit, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Guillotine'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Guillotine'].Mod = set_combine(sets.precast.WS['Guillotine'], {feet="Ratri Sollerets +1"})

    sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS.MultiHit, {neck="Abyssal Beads +2",waist="Sailfi Belt +1", feet="Ratri Sollerets +1"})
    sets.precast.WS['Cross Reaper'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Cross Reaper'].Mod = set_combine(sets.precast.WS, {feet="Ratri Sollerets +1"})

    sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS.MultiHit, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Insurgency'].Acc = set_combine(sets.precast.WS.Acc, {feet="Ratri Sollerets +1"})
    sets.precast.WS['Insurgency'].Mod = set_combine(sets.precast.WS['Insurgency'], {feet="Ratri Sollerets +1"})

    sets.precast.WS['Catastrophe'] = set_combine(sets.precast.WS.SingleHit, {neck="Abyssal Beads +2",waist="Sailfi Belt +1",ear2=gear.WSEarBrutal, feet="Ratri Sollerets +1"})
    sets.precast.WS['Catastrophe'].Acc = set_combine(sets.precast.WS.Acc, {ear2=gear.WSEarBrutal, feet="Ratri Sollerets +1"})
    sets.precast.WS['Catastrophe'].Mod = set_combine(sets.precast.WS['Catastrophe'], {feet="Ratri Sollerets +1"})

    -- Greatsword WS's
    sets.precast.WS['Shockwave'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Shockwave'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Shockwave'].Mod = set_combine(sets.precast.WS['Shockwave'], {})

    sets.precast.WS['Spinning Slash'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Spinning Slash'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Spinning Slash'].Mod = set_combine(sets.precast.WS['Spinning Slash'], {})

    sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Ground Strike'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ground Strike'].Mod = set_combine(sets.precast.WS['Ground Strike'], {})

    sets.precast.WS['Torcleaver'] = set_combine(sets.precast.WS.SingleHit, {head=gear.torcleaver_helm, neck="Abyssal Beads +2", hands=gear.torcleaver_gauntlets, waist="Sailfi Belt +1"})
    sets.precast.WS['Torcleaver'].Acc = set_combine(sets.precast.WS.Acc, {head=gear.torcleaver_helm})
    sets.precast.WS['Torcleaver'].Mod = set_combine(sets.precast.WS['Torcleaver'], {head=gear.torcleaver_helm})

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Resolution'].Mod = set_combine(sets.precast.WS['Resolution'], {})

    -- Greataxe WS's
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Upheaval'].Mod = set_combine(sets.precast.WS['Upheaval'], {})

    
    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS.SingleHit, {neck="Abyssal beads +2", waist="Sailfi belt +1"})
    sets.precast.WS['Fell Cleave'].Acc = set_combine(sets.precast.WS.Acc, {neck="Abyssal beads +2", waist="Sailfi belt +1"})
    sets.precast.WS['Fell Cleave'].Mod = set_combine(sets.precast.WS['Fell Cleave'], {neck="Abyssal beads +2", waist="Sailfi belt +1"})

    sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS.SingleHit, {neck="Abyssal beads +2", waist="Sailfi belt +1"})
    sets.precast.WS['Steel Cyclone'].Acc = set_combine(sets.precast.WS.Acc, {neck="Abyssal beads +2", waist="Sailfi belt +1"})
    sets.precast.WS['Steel Cyclone'].Mod = set_combine(sets.precast.WS['Steel Cyclone'], {neck="Abyssal beads +2", waist="Sailfi belt +1"})

    -- Axe WS's
    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS.Crit, {})
    sets.precast.WS['Rampage'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Rampage'].Mod = set_combine(sets.precast.WS.Mod, {})
    
    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Decimation'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Decimation'].Mod = set_combine(sets.precast.WS.Mod, {})
    
    sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS.SingleHit, {})
    sets.precast.WS['Bora Axe'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Bora Axe'].Mod = set_combine(sets.precast.WS.Mod, {})

    sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Ruinator'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Ruinator'].Mod = set_combine(sets.precast.WS.Mod, {})

    -- Sword WS's
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS.SingleHit, {})

    -- Club WS's
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS.SingleHit, {})

    -- Magical Weaponskills
    sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS.Magic, {head="Pixie Hairpin +1", ring1="Archon Ring"})
    sets.precast.WS['Nightmare Scythe'] = sets.precast.WS['Shadow of Death']
    sets.precast.WS['Infernal Scythe'] = sets.precast.WS['Shadow of Death']

    sets.precast.WS['Gale Axe'] = sets.precast.WS.Magic

    sets.precast.WS['Burning Blade'] = sets.precast.WS.Magic
    sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Burning Blade']
    sets.precast.WS['Shining Blade'] = sets.precast.WS['Burning Blade']
    sets.precast.WS['Seraph Blade'] = sets.precast.WS['Burning Blade']
    sets.precast.WS['Sanguine Blade'] = sets.precast.WS['Shadow of Death']

    sets.precast.WS['Frostbite'] = sets.precast.WS.Magic
    sets.precast.WS['Freezebite'] = sets.precast.WS['Frostbite']

    sets.precast.WS['Shining Strike'] = sets.precast.WS.Magic
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Shining Strike']
    sets.precast.WS['Flash Nova'] = sets.precast.WS['Shining Strike']


    -- Sets to return to when not performing an action.
    
    -------------------------------------------------------------------------------------------------------------------
    -- Resting sets
    -------------------------------------------------------------------------------------------------------------------
    sets.resting = {neck="Abyssal Beads +2",ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -------------------------------------------------------------------------------------------------------------------
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    -------------------------------------------------------------------------------------------------------------------

    sets.idle.Town = {
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Hearty Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Archon Ring",
        back=gear.melee_cape,waist="Leech Belt",legs="Carmine Cuisses +1",feet="Sakpata's Leggings"}
    
    sets.idle.Field = set_combine(sets.idle.Town, {ammo="Ginsen", hands="Sakpata's Gauntlets",feet="Sakpata's Leggings" })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Weak = {
        head="Twilight Helm",neck="Abyssal Beads +2",ear1="Ethereal earring",ear2="Hearty Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back=gear.melee_cape,waist="Flume Belt",legs="Carmine Cuisses +1",feet="Sakpata's Leggings"}

    sets.idle.PDT = set_combine(sets.idle.Field, {head="Sakpata's Helm",body="Sakpata's Plate"})
    
    sets.idle.Reraise = sets.idle.Weak

    sets.idle.Refresh = set_combine(sets.idle.Field, {body="Lugra Cloak +1", ring1="Stikini Ring +1", ring2="Stikini Ring +1"})
    
    -------------------------------------------------------------------------------------------------------------------
    -- Defense sets
    -------------------------------------------------------------------------------------------------------------------
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Hearty Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Archon Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}

    sets.defense.Reraise = {
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Hearty Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Paguroidea Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Ignominy Flanchard +1",feet="Flamma Gambieras +2"}

    sets.defense.MDT = {ammo="Impatiens",
        head="Flamma Zucchetto +2",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Hearty Earring",
        body="Sakpata's Plate",hands="Flamma Manopolas +2",ring1="Defending Ring",ring2="Archon Ring",
        back=gear.melee_cape,waist="Flume Belt",legs="Ignominy Flanchard +1",feet="Flamma Gambieras +2"}

    sets.Kiting = {head="Sakpata's Helm",body="Sakpata's Plate",feet="Carmine Cuisses +1"}

    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}


    -------------------------------------------------------------------------------------------------------------------
    -- Precast Sets
    -------------------------------------------------------------------------------------------------------------------

    sets.precast.FC = {ammo="Sapience Orb",
        head="Sakpata's Helm",neck="Baetyl Pendant",ear1="Malignance Earring",ear2="Loquacious Earring",
        body="Sacro Breastplate",hands="Flamma Manopolas +2",ring1="Kishar Ring",ring2="Prolix Ring",
        back=gear.casting_cape,waist="Sailfi Belt +1",legs="Carmine Cuisses +1",feet="Flamma Gambieras +2"}

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC['Dark Magic'] = set_combine (sets.precast.FC, {
        head="Fallen's Burgeonet +2"
    })

    sets.precast.FC.Cure = set_combine(sets.precast.FC, { })

    sets.precast.FC.Curaga = sets.precast.FC.Cure

    -------------------------------------------------------------------------------------------------------------------
    -- Midcast Sets
    -------------------------------------------------------------------------------------------------------------------
    sets.midcast.FastRecast = {ammo="Sapience Orb",
        head="Sakpata's Helm",neck="Baetyl Pendant",ear1="Malignance Earring",ear2="Loquacious Earring",
        body="Sacro Breastplate",hands="Flamma Manopolas +2",ring1="Kishar Ring",ring2="Prolix Ring",
        back=gear.casting_cape,waist="Sailfi Belt +1",legs="Carmine Cuisses +1",feet="Flamma Gambieras +2"}

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast.FastRecast, {
        neck="Erra Pendant",
        body="Ignominy Cuirass +3", ring1="Stikini Ring +1", ring2="Stikini Ring +1"
    })

    sets.midcast['Dark Magic'] = {ammo="Sturm's Report",
        head="Ignominy Burgeonet +1",neck="Erra Pendant",ear1="Malignance Earring",ear2="Gwati earring",
        body="Carm. Sc. Mail +1",hands="Fallen's Finger Gauntlets +2",ring1="Evanescence Ring",ring2="Archon Ring",
        back=gear.casting_cape,waist="Eschan Stone",legs="Fallen's Flanchard +3",feet="Ratri Sollerets +1"}
    sets.midcast['Dark Magic'].DarkSeal = set_combine(sets.midcast['Dark Magic'], {head="Fallen's Burgeonet +2"})

    sets.midcast['Dread Spikes'] = set_combine(sets.HP_High,{body="Heathen's Cuirass +1", feet="Rat. sollerets +1"})
    sets.midcast['Dread Spikes'].DarkSeal = set_combine(sets.midcast['Dread Spikes'], {head="Fallen's Burgeonet +2"})

    sets.midcast['Endark'] = set_combine(sets.midcast['Dark Magic'],{back="Niht Mantle",legs="Heathen's Flanchard +1",ring2="Stikini Ring +1"})
    sets.midcast['Endark II'] = sets.midcast['Endark']
    sets.midcast['Endark'].DarkSeal = set_combine(sets.midcast['Endark'], {head="Fallen's Burgeonet +2"})
    sets.midcast['Endark II'].DarkSeal = sets.midcast['Endark'].DarkSeal

    sets.midcast.Drain = set_combine( sets.midcast['Dark Magic'], {ammo="Sturm's Report",
        head="Pixie Hairpin +1",neck="Erra Pendant",ear1="Malignance Earring", ear2="Hirudinea Earring",
        hands="Fallen's finger Gauntlets +2",
        back="Niht Mantle",waist=gear.DrainWaist,legs="Fallen's Flanchard +3"})
    sets.midcast.Drain.DarkSeal = set_combine(sets.midcast.Drain, {head="Fallen's Burgeonet +2"})
    
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
        head="Flamma Zucchetto +2",neck="Erra Pendant",ear1="Malignance Earring",ear2="Gwati Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Stikini Ring +1",ring2="Archon Ring",
        back="Niht Mantle",waist="Eschan Stone",legs="Fallen's Flanchard +3",feet="Flamma Gambieras +2"}

    sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'],{head="Ignominy Burgeonet +1",back=gear.casting_cape})
    sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, {hands="Heathen's Gauntlets +1"})


    -- Elemental Magic sets    
    sets.midcast['Elemental Magic'] = {ammo="Seething Bomblet +1",
        head="Flamma Zucchetto +2",neck="Erra Pendant",ear1="Malignance Earring",ear2="Friomisi Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Stikini Ring +1",ring2="Acumen Ring",
        back=gear.casting_cape,waist=gear.ElementalObi,legs="Fallen's Flanchard +3",feet="Flamma Gambieras +2"}

    -------------------------------------------------------------------------------------------------------------------
    -- Engaged sets
    -------------------------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    sets.weapons = {main=gear.MainHand, sub=gear.SubHand}
    sets.TwoHand_OH = {sub="Utu Grip"}
    sets.OneHand_OH = {sub="Blurred Shield +1"}

    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {ammo="Ginsen",
        head="Flamma Zucchetto +2",neck="Abyssal Beads +2",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Niqmaddu Ring",ring2="Petrov Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Ignominy Flanchard +3",feet="Flamma Gambieras +2"}
    sets.engaged.Acc = {ammo="Seething Bomblet +1",
        head="Flamma Zucchetto +2",neck="Abyssal Beads +2",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Ioskeha Belt +1",legs="Ignominy Flanchard +3",feet="Flamma Gambieras +2"}
    sets.engaged.PDT = {ammo="Ginsen",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Niqmaddu Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}
    sets.engaged.Acc.PDT = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Ioskeha Belt +1",legs="Ignominy Flanchard +3",feet="Sakpata's Leggings"}
    sets.engaged.Reraise = {ammo="Ginsen",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Niqmaddu Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}
    sets.engaged.Acc.Reraise = {ammo="Seething Bomblet +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Defending ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Ioskeha Belt +1",legs="Ignominy Flanchard +3",feet="Sakpata's Leggings"}

    -- Dual Wield sets
    sets.engaged.DW = sets.engaged
    sets.engaged.Acc.DW = sets.engaged.Acc
    sets.engaged.PDT.DW = sets.engaged.PDT
    sets.engaged.Acc.PDT.DW = sets.engaged.Acc.PDT
    sets.engaged.Reraise.DW = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.DW = sets.engaged.Acc.Reraise

    -- Apocalypse
    sets.engaged.Apocalypse = sets.engaged
    sets.engaged.Acc.Apocalypse = sets.engaged.Acc
    sets.engaged.PDT.Apocalypse = sets.engaged.PDT
    sets.engaged.Acc.PDT.Apocalypse = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Apocalypse = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Apocalypse = sets.engaged.Acc.Reraise

    sets.engaged.Apocalypse.AM = sets.engaged
    sets.engaged.Acc.Apocalypse.AM = sets.engaged.Acc
    sets.engaged.PDT.Apocalypse.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Apocalypse.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Apocalypse.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Apocalypse.AM = sets.engaged.Acc.Reraise

    -- Ragnarok
    sets.engaged.Ragnarok = sets.engaged
    sets.engaged.Acc.Ragnarok = sets.engaged.Acc
    sets.engaged.PDT.Ragnarok = sets.engaged.PDT
    sets.engaged.Acc.PDT.Ragnarok = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Ragnarok = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Ragnarok = sets.engaged.Acc.Reraise

    sets.engaged.Ragnarok.AM = sets.engaged
    sets.engaged.Acc.Ragnarok.AM = sets.engaged.Acc
    sets.engaged.PDT.Ragnarok.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Ragnarok.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Ragnarok.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Ragnarok.AM = sets.engaged.Acc.Reraise

    -- Caladbolg
    sets.engaged.Caladbolg = sets.engaged
    sets.engaged.Acc.Caladbolg = sets.engaged.Acc
    sets.engaged.PDT.Caladbolg = sets.engaged.PDT
    sets.engaged.Acc.PDT.Caladbolg = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Caladbolg = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Caladbolg = sets.engaged.Acc.Reraise
    
    sets.engaged.Caladbolg.AM = sets.engaged
    sets.engaged.Acc.Caladbolg.AM = sets.engaged.Acc
    sets.engaged.PDT.Caladbolg.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Caladbolg.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Caladbolg.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Caladbolg.AM = sets.engaged.Acc.Reraise

    sets.engaged.Caladbolg.AM3 = {ammo="Ginsen",
        head="Sakpata's Helm", neck="Abyssal Beads +2", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Niqmaddu Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Sailfi belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Acc.Caladbolg.AM3 = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm", neck="Abyssal Beads +2", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Niqmaddu Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.PDT.Caladbolg.AM3 = {ammo="Ginsen",
        head="Sakpata's Helm", neck="Loricate Torque +1", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Defending Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Sailfi belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Acc.PDT.Caladbolg.AM3 = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm", neck="Loricate Torque +1", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Defending Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Reraise.Caladbolg.AM3 = {ammo="Ginsen",
        head="Sakpata's Helm", neck="Abyssal Beads +2", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Niqmaddu Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Sailfi belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Acc.Reraise.Caladbolg.AM3 = {ammo="Seething Bomblet +1",
        head="Twilight Helm", neck="Abyssal Beads +2", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Twilight Mail", hands="Sakpata's Gauntlets", ring1="Niqmaddu Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}

    -- Liberator
    sets.engaged.Liberator = sets.engaged
    sets.engaged.Acc.Liberator = sets.engaged.Acc
    sets.engaged.PDT.Liberator = sets.engaged.PDT
    sets.engaged.Acc.PDT.Liberator = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Liberator = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Liberator = sets.engaged.Acc.Reraise

    sets.engaged.Liberator.AM = sets.engaged
    sets.engaged.Acc.Liberator.AM = sets.engaged.Acc
    sets.engaged.PDT.Liberator.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Liberator.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Liberator.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Liberator.AM = sets.engaged.Acc.Reraise

    sets.engaged.Liberator.AM = sets.engaged
    sets.engaged.Acc.Liberator.AM = sets.engaged.Acc
    sets.engaged.PDT.Liberator.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Liberator.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Liberator.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Liberator.AM = sets.engaged.Acc.Reraise

    -- Redemption
    sets.engaged.Redemption = sets.engaged
    sets.engaged.Acc.Redemption = sets.engaged.Acc
    sets.engaged.PDT.Redemption = sets.engaged.PDT
    sets.engaged.Acc.PDT.Redemption = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Redemption = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Redemption = sets.engaged.Acc.Reraise

    sets.engaged.Redemption.AM = sets.engaged
    sets.engaged.Acc.Redemption.AM = sets.engaged.Acc
    sets.engaged.PDT.Redemption.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Redemption.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Redemption.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Redemption.AM = sets.engaged.Acc.Reraise

    sets.engaged.Redemption.AM = sets.engaged
    sets.engaged.Acc.Redemption.AM = sets.engaged.Acc
    sets.engaged.PDT.Redemption.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Redemption.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Redemption.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Redemption.AM = sets.engaged.Acc.Reraise

    -- Anguta
    sets.engaged.Anguta = sets.engaged
    sets.engaged.Acc.Anguta = sets.engaged.Acc
    sets.engaged.PDT.Anguta = sets.engaged.PDT
    sets.engaged.Acc.PDT.Anguta = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Anguta = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Anguta = sets.engaged.Acc.Reraise

    sets.engaged.Anguta.AM = sets.engaged
    sets.engaged.Acc.Anguta.AM = sets.engaged.Acc
    sets.engaged.PDT.Anguta.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Anguta.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Anguta.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Anguta.AM = sets.engaged.Acc.Reraise

    sets.engaged.Anguta.AM = sets.engaged
    sets.engaged.Acc.Anguta.AM = sets.engaged.Acc
    sets.engaged.PDT.Anguta.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Anguta.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Anguta.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Anguta.AM = sets.engaged.Acc.Reraise

    -- Father Time
    sets.engaged['Father Time'] = sets.engaged
    sets.engaged.Acc['Father Time'] = sets.engaged.Acc
    sets.engaged.PDT['Father Time'] = sets.engaged.PDT
    sets.engaged.Acc.PDT['Father Time'] = sets.engaged.Acc.PDT
    sets.engaged.Reraise['Father Time'] = sets.engaged.Reraise
    sets.engaged.Acc.Reraise['Father Time'] = sets.engaged.Acc.Reraise

    -- Low Damage/Omen objectives
    sets.engaged.Low = {ammo="Seething Bomblet +1",
        head="Flamma Zucchetto +2", neck="Combatant's Torque", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Flamma Korazin +2", hands="Flamma Manopolas +2", ring1="Regal Ring",ring2="Petrov Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1",legs="Ignomingy Flanchard +3",feet="Flamma Gambieras +2"
    }
    sets.engaged.Low.Acc = sets.engaged.Low
    sets.engaged.Low.PDT = sets.engaged.Low
    sets.engaged.Low.Acc.PDT = sets.engaged.Low
    sets.engaged.Low.Reraise = sets.engaged.Low
    sets.engaged.Low.Acc.Reraise = sets.engaged.Low

    -------------------------------------------------------------------------------------------------------------------
    -- Miscellaneous Sets
    -------------------------------------------------------------------------------------------------------------------
    sets.HP_High = {
        head="Odyssean Helm",ear1="Eabani Earring",
        body="Ignominy Cuirass +3",hands="Sakpata's Gauntlets",ring2="Regal Ring",
        waist="Eschan Stone",legs="Sakpata's Cuisses",feet="Ratri Sollerets +1",
    }
    sets.HP_Low = set_combine(sets.naked, {main=gear.MainHand, sub=gear.SubHand, ranged="",})
    sets.Sleeping = {neck="Berserker's Torque"}

    -------------------------------------------------------------------------------------------------------------------
    -- Buff specific sets
    -------------------------------------------------------------------------------------------------------------------
    sets.buff['Blood Weapon'] = { }
    sets.buff['Souleater'] = { }
    sets.buff['Last Resort'] = { }
    sets.buff['Scarlet Delirium'] = { }
    sets.buff['Consume Mana'] = { }
    sets.buff['Arcane Circle'] = { feet="Ignominy Sollerets +1" }
    sets.buff['Soul Enslavement'] = { }
    sets.buff['Nether Void'] = { legs="Heathen's Flanchard +1" }
    sets.buff['Dark Seal'] = { head="Fallen's Burgeonet +2" }

    sets.buff['Dread Spikes'] = { }
    sets.buff['Endark'] = { }
    sets.buff['Endark II'] = sets.buff['Endark']

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    local ability_recast = windower.ffxi.get_ability_recasts()
    if (spell.action_type:lower() == 'magic' and player.status == 'Idle') then
        if (state.Buff['Hasso'] and (ability_recast[138] == 0 or nil)) then
            --cast_delay(0.3)
            send_command('cancel hasso')
        end
    end
    if spell.type:lower() == 'weaponskill' then
        if state.Buff['Souleater'] then
            equip(sets.buff['Souleater'])
        end
        if state.Buff['Last Resort'] then
            equip(sets.buff['Last Resort'])
        end
        if state.Buff['Scarlet Delirium'] then
            equip(sets.buff['Scarlet Delirium'])
        end
        if state.Buff['Consume Mana'] then
            equip(sets.buff['Consume Mana'])
        end
        if state.Buff['Blood Weapon'] then
            equip(sets.buff['Blood Weapon'])
        end
        if state.Buff['Soul Enslavement'] then
            equip(sets.buff['Soul Enslavement'])
        end
    elseif spell.type:lower() == 'ability' then
        if state.Buff['Last Resort'] then
            equip(sets.buff['Last Resort'])
        end
        if state.Buff['Scarlet Delirium'] then
            equip(sets.buff['Scarlet Delirium'])
        end
        if state.Buff['Consume Mana'] then
            equip(sets.buff['Consume Mana'])
        end
        if state.Buff['Dread Spikes'] then
            equip(sets.buff['Dread Spikes'])
        end
        if state.Buff['Blood Weapon'] then
            equip(sets.buff['Blood Weapon'])
        end
        if state.Buff['Soul Enslavement'] then
            equip(sets.buff['Soul Enslavement'])
        end
        if state.Buff['Nether Void'] then
            equip(sets.buff['Nether Void'])
        end   
    end
end


function job_midcast(spell, action, spellMap, eventArgs)

    --[[-- Dark seal handling
    if spell.skill == 'Dark Magic' and buffactive['Dark Seal'] then
        if S{'Drain', 'Drain II', 'Drain III', 'Aspir', 'Aspir II'}:contains(spell.english) then
            equip(sets.midcast.Drain.DarkSeal)
        elseif S{'Dread Spikes'}:contains(spell.english) then
            equip(sets.midcast['Dread Spikes'].DarkSeal)
        elseif S{'Endark', 'Endark II'}:contains(spell.english) then
            equip(sets.midcast['Endark'].DarkSeal)
        else
            equip(sets.midcast['Dark Magic'].DarkSeal)
        end
    end]]
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
        if S{'Drain', 'Drain II', 'Drain III', 'Aspir', 'Aspir II'}:contains(spell.english) then
            equip(sets.midcast.Drain.DarkSeal)
        elseif S{'Dread Spikes'}:contains(spell.english) then
            equip(sets.midcast['Dread Spikes'].DarkSeal)
        elseif S{'Endark', 'Endark II'}:contains(spell.english) then
            equip(sets.midcast['Endark'].DarkSeal)
        else
            equip(sets.midcast['Dark Magic'].DarkSeal)
        end
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

--[[function job_post_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then 
        update_combat_form()
    end
    eventArgs.handled = false
end]]

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
    if info.Weapons.Type[currentWeapon] ~= nil then
        local book = info.macro_sets[info.Weapons.Type[currentWeapon]][subjob].book
        local page = info.macro_sets[info.Weapons.Type[currentWeapon]][subjob].page
        windower.add_to_chat(144, 'Changing macro book to <' .. book .. ',' .. page .. '>.')
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
    echo('CombatWeapon mode: '.. state.CombatWeapon.value,2)
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

