-------------------------------------------------------------------------------------------------------------------
-- Gear and data for DRK
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function include_job_stats()

    -- Player merit and job points
    -- set these to match your own
    info.JobPoints = {}

    -- how many Dark Seal merits do you have?
    info.JobPoints.DarkSealMerits = 5

    -- Do you have the JP gift dread spikes bonus?
    info.JobPoints.DreadSpikesBonus = true

end

-- Define sets and vars used by this job file.
function include_job_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- individual gear
    gear.melee_cape = { name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.ws_cape = {name="Ankou's Mantle", augments={'STR+20', 'Accuracy+20 Attack+20', 'Weapon skill damage +10%'}}
    gear.torcleaver_cape = { name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}}
    gear.casting_cape = { name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}

    gear.torcleaver_helm = { name="Odyssean Helm", augments={'Mag. Acc.+23','Weapon skill damage +3%','VIT+10','Attack+2',}}
    gear.torcleaver_gauntlets = { name="Odyssean Gauntlets", augments={'VIT+9','Enmity+5','Weapon skill damage +3%','Accuracy+13 Attack+13','Mag. Acc.+1 "Mag.Atk.Bns."+1',}}

    gear.DrainFeet = { name="Yorium Sabatons", augments={'Mag. Acc.+10','"Drain" and "Aspir" potency +6',}}
    gear.DrainBody = { name="Acro Surcoat", augments={'Mag. Acc.+10','"Drain" and "Aspir" potency +7','INT+6',}}


    -- Mainhand Sets
    sets.Weapons = {}
    sets.Weapons.greatsword = {main="Caladbolg", sub="Utu Grip"}
    sets.Weapons.scythe = {main="Apocalypse", sub="Utu Grip"}
    sets.Weapons.greataxe = {main="Lycurgos", sub="Utu Grip"}
    sets.Weapons.sword = {main="Naegling",sub="Blurred Shield +1"}
    sets.Weapons.club = {main="Loxotic Mace +1",sub="Blurred Shield +1"}
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Arcane Circle'] = {feet="Ignominy Sollerets +1"}
    sets.precast.JA['Weapon Bash'] = {hands="Ignominy Gauntlets +2"}
    sets.precast.JA['Blood Weapon'] = {body="Fallen's Cuirass"}
    sets.precast.JA['Dark Seal'] = {head="Fallen's Burgeonet +2"}
    sets.precast.JA['Diabolic Eye'] = {hands="Fallen's Finger Gauntlets +3"}
    sets.precast.JA['Souleater'] = {head="Ignominy Burgeonet +2", legs="Fallen's Flanchard +3"}
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
        head="Sakpata's Helm",neck="Abyss Beads +2",ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Ignominy Cuirass +3",hands="Sakpata's Gauntlets",ring1="Regal Ring",ring2="Karieyh Ring +1",
        back=gear.ws_cape,waist="Fotia Belt",legs="Fallen's Flanchard +3",feet="Sulevia's Leggings +2"}
    sets.precast.WS.FullTP = {ear2="Lugra Earring +1"}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    sets.precast.WS.SingleHit = set_combine(sets.precast.WS,{neck="Abyssal Beads +2", waist="Sailfi Belt +1"})

    sets.precast.WS.MultiHit = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm",neck="Abyss Beads +2",ear1="Thrud Earring", ear2="Lugra Earring +1",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Regal Ring",ring2="Niqmaddu Ring",
        back=gear.multi_cape, waist="Fotia Belt", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}

    sets.precast.WS.Magic = {ammo="Knobkierrie",
        head="Flamma Zucchetto +2", neck="Baetyl Pendant", ear1="Friomisi Earring", ear2="Malignance Earring",
        body="Ignominy Cuirass +3", hands="Fallen's Finger Gauntlets +3", ring1="Acumen Ring", ring2="Karieyh Ring +1",
        back=gear.ws_cape, waist="Eschan Stone", legs="Fallen's Flanchard +3", feet="Sulevia's Leggings +2"}

    sets.precast.WS.Crit = {ammo="Yetshila +1",
    head="Sakpata's Helm",neck="Fotia Gorget",ear1=gear.WSEarThrud,ear2="Moonshade Earring",
    body="Ignominy Cuirass +3",hands="Flamma Manopolas +2",ring1="Regal Ring",ring2="Begrudging Ring",
    back=gear.ws_cape,waist="Fotia Belt",legs="Fallen's Flanchard +3", feet="Sulevia's Leggings +2"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    -- Scythe Weaponskills
    sets.precast.WS['Spinning Scythe'] = set_combine(sets.precast.WS.SingleHit, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})
    sets.precast.WS['Spinning Scythe'].Acc = set_combine(sets.precast.WS.Acc, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})
    sets.precast.WS['Spinning Scythe'].Mod = set_combine(sets.precast.WS['Spinning Scythe'], {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})

    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS.SingleHit, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})
    sets.precast.WS['Spiral Hell'].Acc = set_combine(sets.precast.WS.Acc, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})
    sets.precast.WS['Spiral Hell'].Mod = set_combine(sets.precast.WS['Spiral Hell'], {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})

    sets.precast.WS['Entropy'] = set_combine(sets.precast.WS.MultiHit, {
        head="Ratri Sallet +1",ear1="Lugra Earring +1",ear2="Moonshade Earring",
        body="Sakpata's breastplate",hands="Fallen's Finger gauntlets +3",
        back=gear.ws_cape, legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"})
    sets.precast.WS['Entropy'].Acc = set_combine(sets.precast.WS.Acc, {ear2="Moonshade Earring"})
    sets.precast.WS['Entropy'].Mod = set_combine(sets.precast.WS['Entropy'], {ear2="Moonshade Earring"})
    sets.precast.WS['Entropy'].FullTP = {ear2="Malignance Earring"}

    sets.precast.WS['Quietus'] = set_combine(sets.precast.WS.SingleHit, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1", ear2="Lugra Earring +1"})
    sets.precast.WS['Quietus'].Acc = set_combine(sets.precast.WS.Acc, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1", ear2="Lugra Earring +1"})
    sets.precast.WS['Quietus'].Mod = set_combine(sets.precast.WS['Quietus'], {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1", ear2="Lugra Earring +1"})

    sets.precast.WS['Guillotine'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Guillotine'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Guillotine'].Mod = set_combine(sets.precast.WS['Guillotine'], {})

    sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS.SingleHit, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",neck="Abyssal Beads +2",waist="Sailfi Belt +1", feet="Ratri Sollerets +1"})
    sets.precast.WS['Cross Reaper'].Acc = set_combine(sets.precast.WS.Acc, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})
    sets.precast.WS['Cross Reaper'].Mod = set_combine(sets.precast.WS, {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})

    sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS.MultiHit, {})
    sets.precast.WS['Insurgency'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Insurgency'].Mod = set_combine(sets.precast.WS['Insurgency'], {})

    sets.precast.WS['Catastrophe'] = set_combine(sets.precast.WS.SingleHit, {head="Ratri Sallet +1",neck="Abyssal Beads +2",hands="Ratri Gadlings +1",waist="Sailfi Belt +1",ear2="Lugra Earring +1", feet="Ratri Sollerets +1"})
    sets.precast.WS['Catastrophe'].Acc = set_combine(sets.precast.WS.Acc, {head="Ratri Sallet +1",ear2="Lugra Earring +1", hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})
    sets.precast.WS['Catastrophe'].Mod = set_combine(sets.precast.WS['Catastrophe'], {head="Ratri Sallet +1",hands="Ratri Gadlings +1",feet="Ratri Sollerets +1"})

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

    sets.precast.WS['Torcleaver'] = set_combine(sets.precast.WS.SingleHit, {head="Sakpata's Helm", neck="Abyssal Beads +2", hands="Sakpata's Gauntlets", waist="Sailfi Belt +1", back=gear.torcleaver_cape})
    sets.precast.WS['Torcleaver'].Acc = set_combine(sets.precast.WS.Acc, {head="Sakpata's Helm", hands="Sakpata's Gauntlets", back=gear.torcleaver_cape, waist="Sailfi Belt +1"})
    sets.precast.WS['Torcleaver'].Mod = set_combine(sets.precast.WS['Torcleaver'], {head=gear.torcleaver_helm, back=gear.torcleaver_cape})

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS.MultiHit, {ear2="Moonshade Earring"})
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS.Acc, {})
    sets.precast.WS['Resolution'].Mod = set_combine(sets.precast.WS['Resolution'], {})

    -- Greataxe WS's
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.MultiHit, {ear2="Moonshade Earring"})
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS.Acc, {ear2="Moonshade Earring"})
    sets.precast.WS['Upheaval'].Mod = set_combine(sets.precast.WS['Upheaval'], {ear2="Moonshade Earring"})

    
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
    sets.resting = {neck="Sanctity Necklace",body="Lugra Cloak +1",ring1="Stikini Ring +1",ring2="Stikini Ring +1", waist="Austerity belt +1"}

    -------------------------------------------------------------------------------------------------------------------
    -- Miscellaneous Sets
    -------------------------------------------------------------------------------------------------------------------
    sets.HP_High = {
        head="Ratri sallet +1",ear1="Eabani Earring",
        body="Ignominy Cuirass +3",hands="Rat. Gadlings +1",ring1="Moonlight Ring",ring2="Regal Ring",
        waist="Eschan Stone",legs="Sakpata's Cuisses",feet="Ratri Sollerets +1",
    }
    sets.HP_Low = set_combine(sets.naked, {main=gear.MainHand, sub=gear.SubHand, ranged="",})
    sets.Sleeping = {neck="Berserker's Torque"}
    

    -------------------------------------------------------------------------------------------------------------------
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    -------------------------------------------------------------------------------------------------------------------

    sets.idle.Town = {ammo="Crepuscular pebble",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Ethereal Earring",ear2="Eabani Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Leech Belt",legs="Carmine Cuisses +1",feet="Sakpata's Leggings"}
    
    sets.idle.Field = set_combine(sets.idle.Town, {hands="Sakpata's Gauntlets",feet="Sakpata's Leggings" })
    sets.idle.Field.PDT = set_combine(sets.idle.Field, sets.idle.PDT)

    sets.idle.Weak = {ammo="Crepuscular pebble",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Ethereal Earring",ear2="Eabani Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Flume Belt",legs="Carmine Cuisses +1",feet="Sakpata's Leggings"}

    sets.idle.PDT = set_combine(sets.idle.Field, {head="Sakpata's Helm",body="Sakpata's Plate"})
    
    sets.idle.Reraise = sets.idle.Weak

    sets.idle.Refresh = set_combine(sets.idle.Field, {body="Lugra Cloak +1", ring1="Stikini Ring +1", ring2="Stikini Ring +1"})
    
    -------------------------------------------------------------------------------------------------------------------
    -- Defense sets
    -------------------------------------------------------------------------------------------------------------------
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Eabani Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Archon Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}

    sets.defense.Reraise = {
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Eabani Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Defending Ring",ring2="Paguroidea Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Ignominy Flanchard +1",feet="Flamma Gambieras +2"}

    sets.defense.MDT = {ammo="Impatiens",
        head="Flamma Zucchetto +2",neck="Loricate Torque +1",ear1="Ethereal earring",ear2="Eabani Earring",
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

    sets.precast.FC['Dark Magic'] = set_combine(sets.precast.FC, {
        head="Fallen's Burgeonet +2"
    })
    sets.precast['Dark Magic'] = sets.precast.FC['Dark Magic']

    sets.precast['Impact'] = set_combine(sets.precast.FC['Dark Magic'], {head="", body="Crepuscular cloak"})
    sets.precast.FC['Impact'] = set_combine(sets.precast.FC['Dark Magic'], {head="", body="Crepuscular cloak"})

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
        head="Flamma Zucchetto +2", neck="Erra Pendant",ear1="Malignance Earring",ear2="Crepuscular Earring",
        body="Flamma Korazin +2", hands="Flamma Manopolas +2", ring1="Stikini Ring +1", ring2="Stikini Ring +1",
        back=gear.casting_cape,waist="Eschan Stone",legs="Sakpata's Cuisses", feet="Flamma Gambieras +2"
    })

    sets.midcast['Dark Magic'] = {ammo="Sturm's Report",
        head="Ignominy Burgeonet +2",neck="Erra Pendant",ear1="Malignance Earring",ear2="Mani Earring",
        body="Carm. Sc. Mail +1",hands="Fallen's Finger Gauntlets +3",ring1="Evanescence Ring",ring2="Archon Ring",
        back=gear.casting_cape,waist="Eschan Stone",legs="Fallen's Flanchard +3",feet="Ratri Sollerets +1"}
    sets.midcast['Dark Magic'].DarkSeal = set_combine(sets.midcast['Dark Magic'], {head="Fallen's Burgeonet +2"})

    sets.midcast['Endark'] = set_combine(sets.midcast['Dark Magic'],{back="Niht Mantle",legs="Heathen's Flanchard +1",ring2="Stikini Ring +1"})
    sets.midcast['Endark II'] = sets.midcast['Endark']
    sets.midcast['Endark'].DarkSeal = set_combine(sets.midcast['Endark'], {head="Fallen's Burgeonet +2"})
    sets.midcast['Endark II'].DarkSeal = sets.midcast['Endark'].DarkSeal

    sets.midcast['Impact'] = set_combine(sets.midcast['Dark Magic'],{head="", body="Crepuscular Cloak"})

    sets.midcast['Drain'] = set_combine( sets.midcast['Dark Magic'], {ammo="Sturm's Report",
        head="Pixie Hairpin +1",neck="Erra Pendant",ear1="Hirudinea earring", ear2="Mani Earring",
        body=gear.DrainBody, hands="Fallen's Finger Gauntlets +3",
        back="Niht Mantle",waist=gear.DrainWaist,legs="Fallen's Flanchard +3", feet=gear.DrainFeet})
    sets.midcast['Drain II'] = sets.midcast['Drain']
    sets.midcast['Drain III'] = set_combine( sets.midcast['Dark Magic'], {ammo="Sturm's Report",
    head="Pixie Hairpin +1",neck="Erra Pendant",ear1="Hirudinea earring", ear2="Mani Earring",
    body=gear.DrainBody, hands="Fallen's Finger Gauntlets +3",
    back="Niht Mantle",waist=gear.DrainWaist,legs="Fallen's Flanchard +3", feet="Ratri Sollerets +1"})
    sets.midcast['Drain III'].DarkSeal = set_combine(sets.midcast.Drain, {head="Fallen's Burgeonet +2"})
    sets.midcast['Aspir'] = sets.midcast.Drain
    sets.midcast['Aspir II'] = sets.midcast.Aspir
    sets.midcast['Drain'].Weapon = {main="Dacnomania"}

    sets.midcast.Stun = {
        head="Ignominy Burgeonet +2",neck="Erra Pendant",ear1="Malignance Earring",ear2="Mani Earring",
        body="Carmine Scale Mail +1",hands="Fallen's Finger Gauntlets +3",ring1="Evanescence Ring",ring2="Stikini Ring +1",
        back="Niht Mantle",waist="Eschan Stone",legs="Fallen's Flanchard +3",feet="Ratri Sollerets +1"}

    sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'],{head="Ignominy Burgeonet +2",back=gear.casting_cape, ring1="Stikini Ring +1", ring2="Stikini Ring +1"})
    sets.midcast['Absorb-TP'] = set_combine(sets.midcast.Absorb, {hands="Heathen's Gauntlets +1"})

    sets.midcast['Dread Spikes'] = set_combine(sets.HP_High, {head="Ratri sallet +1", body="Heathen's Cuirass +1", hands="Rat. Gadlings +1", feet="Rat. sollerets +1"})

    -- Elemental Magic sets    
    sets.midcast['Elemental Magic'] = {ammo="Seething Bomblet +1",
        head="Flamma Zucchetto +2",neck="Erra Pendant",ear1="Malignance Earring",ear2="Friomisi Earring",
        body="Flamma Korazin +2",hands="Fallen's Finger Gauntlets +3",ring1="Stikini Ring +1",ring2="Acumen Ring",
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
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Moonlight ring",ring2="Niqmaddu Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Ignominy Flanchard +3",feet="Flamma Gambieras +2"}
    sets.engaged.Acc = {ammo="Seething Bomblet +1",
        head="Flamma Zucchetto +2",neck="Abyssal Beads +2",ear1="Cessance Earring",ear2="Telos Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Moonlight ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Ioskeha Belt +1",legs="Ignominy Flanchard +3",feet="Flamma Gambieras +2"}
    sets.engaged.PDT = {ammo="Ginsen",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}
    sets.engaged.Acc.PDT = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Telos Earring",
        body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Moonlight Ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Ioskeha Belt +1",legs="Ignominy Flanchard +3",feet="Sakpata's Leggings"}
    sets.engaged.Reraise = {ammo="Ginsen",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Moonlight Ring",ring2="Defending Ring",
        back=gear.melee_cape,waist="Sailfi Belt +1",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}
    sets.engaged.Acc.Reraise = {ammo="Seething Bomblet +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Telos Earring",
        body="Twilight Mail",hands="Sakpata's Gauntlets",ring1="Moonlight Ring",ring2="Regal Ring",
        back=gear.melee_cape,waist="Ioskeha Belt +1",legs="Ignominy Flanchard +3",feet="Sakpata's Leggings"}

    -- Dual Wield sets
    sets.engaged.DW = sets.engaged
    sets.engaged.Acc.DW = sets.engaged.Acc
    sets.engaged.PDT.DW = sets.engaged.PDT
    sets.engaged.Acc.PDT.DW = sets.engaged.Acc.PDT
    sets.engaged.Reraise.DW = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.DW = sets.engaged.Acc.Reraise

    -- Apocalypse
    sets.engaged.Apocalypse = set_combine(sets.engaged,{hands="Sakpata's Gauntlets"})
    sets.engaged.Acc.Apocalypse = set_combine(sets.engaged.Acc,{hands="Sakpata's Gauntlets"})
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
    sets.engaged.Caladbolg = set_combine(sets.engaged, {hands="Sakpata's Gauntlets"})
    sets.engaged.Acc.Caladbolg = set_combine(sets.engaged.Acc, {hands="Sakpata's Gauntlets"})
    sets.engaged.PDT.Caladbolg = sets.engaged.PDT
    sets.engaged.Acc.PDT.Caladbolg = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Caladbolg = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Caladbolg = sets.engaged.Acc.Reraise
    
    sets.engaged.Caladbolg.AM = set_combine(sets.engaged, {hands="Sakpata's Gauntlets"})
    sets.engaged.Acc.Caladbolg.AM = set_combine(sets.engaged.Acc, {hands="Sakpata's Gauntlets"})
    sets.engaged.PDT.Caladbolg.AM = sets.engaged.PDT
    sets.engaged.Acc.PDT.Caladbolg.AM = sets.engaged.Acc.PDT
    sets.engaged.Reraise.Caladbolg.AM = sets.engaged.Reraise
    sets.engaged.Acc.Reraise.Caladbolg.AM = sets.engaged.Acc.Reraise

    sets.engaged.Caladbolg.AM3 = {ammo="Ginsen",
        head="Sakpata's Helm", neck="Abyssal Beads +2", ear1="Telos Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Regal Ring", ring2="Niqmaddu Ring",
        back=gear.melee_cape, waist="Sailfi belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Acc.Caladbolg.AM3 = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm", neck="Abyssal Beads +2", ear1="Telos Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Moonlight Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.PDT.Caladbolg.AM3 = {ammo="Ginsen",
        head="Sakpata's Helm", neck="Loricate Torque +1", ear1="Telos Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Moonlight Ring", ring2="Defending Ring",
        back=gear.melee_cape, waist="Sailfi belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Acc.PDT.Caladbolg.AM3 = {ammo="Seething Bomblet +1",
        head="Sakpata's Helm", neck="Loricate Torque +1", ear1="Telos Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Defending Ring", ring2="Regal Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Reraise.Caladbolg.AM3 = {ammo="Ginsen",
        head="Sakpata's Helm", neck="Abyssal Beads +2", ear1="Telos Earring", ear2="Brutal Earring",
        body="Sakpata's Plate", hands="Sakpata's Gauntlets", ring1="Regal Ring", ring2="Niqmaddu Ring",
        back=gear.melee_cape, waist="Sailfi belt +1", legs="Ignominy Flanchard +3", feet="Sakpata's Leggings"}
    sets.engaged.Acc.Reraise.Caladbolg.AM3 = {ammo="Seething Bomblet +1",
        head="Twilight Helm", neck="Abyssal Beads +2", ear1="Telos Earring", ear2="Brutal Earring",
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

    --more weapons here

    -- Low Damage/Omen objectives
    sets.engaged.Low = {ammo="Seething Bomblet +1",
        head="Flamma Zucchetto +2", neck="Combatant's Torque", ear1="Cessance Earring", ear2="Brutal Earring",
        body="Flamma Korazin +2", hands="Flamma Manopolas +2", ring1="Regal Ring",ring2="Moonlight Ring",
        back=gear.melee_cape, waist="Ioskeha Belt +1",legs="Ignomingy Flanchard +3",feet="Flamma Gambieras +2"
    }
    sets.engaged.Low.Acc = sets.engaged.Low
    sets.engaged.Low.PDT = sets.engaged.Low
    sets.engaged.Low.Acc.PDT = sets.engaged.Low
    sets.engaged.Low.Reraise = sets.engaged.Low
    sets.engaged.Low.Acc.Reraise = sets.engaged.Low

    -------------------------------------------------------------------------------------------------------------------
    -- Buff specific sets
    -------------------------------------------------------------------------------------------------------------------
    sets.buff['Blood Weapon'] = { }
    sets.buff['Souleater'] = { head="Ignominy Burgeonet +2" }
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
