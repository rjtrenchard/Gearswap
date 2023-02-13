-- Custom Augment Table
-- holds all augmented items that can be used across classes

-- define augments
if not gear then gear = T {} end

-- Taeon
gear.taeon = {}
gear.taeon.phalanx = {}
gear.taeon.phalanx.head = { name = "Taeon Chapeau", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
gear.taeon.phalanx.body = { name = "Taeon Tabard", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
gear.taeon.phalanx.hands = { name = "Taeon Gloves", augments = { '"Repair" potency +5%', 'Phalanx +3', } }
gear.taeon.phalanx.legs = { name = "Taeon Tights", augments = { '"Repair" potency +5%', 'Phalanx +3' } }
gear.taeon.phalanx.feet = { name = "Taeon Boots", augments = { '"Repair" potency +5%', 'Phalanx +3', } }

gear.taeon.repair = {}
gear.taeon.repair = gear.taeon.phalanx

gear.taeon.petdt = {}
gear.taeon.petdt.body = { name = "Taeon Tabard",
    augments = { 'Pet: Damage Taken -4%', 'Pet: Accuracy+21 Rng. Acc.+21', 'Pet: "Double Attack"+5%' } }
gear.taeon.petdt.hands = { name = "Taeon Gloves",
    augments = { 'Pet: Damage Taken -4%', 'Pet: Accuracy+20 Rng. Acc.+20', 'Pet: "Double Attack"+5%' } }
gear.taeon.petdt.legs = { name = "Taeon Tights",
    augments = { 'Pet: Damage Taken -4%', 'Pet: Accuracy+17 Rng. Acc.+17', 'Pet: "Double Attack"+5%' } }
gear.taeon.petdt.feet = { name = "Taeon Boots",
    augments = { 'Pet: Damage Taken -4%', 'Pet: Accuracy+17 Rng. Acc.+17', 'Pet: "Double Attack"+5%' }, }

gear.taeon.pethaste = {}
gear.taeon.pethaste.legs = { name = "Taeon Tights",
    augments = { 'Pet: Accuracy+22 Pet: Rng. Acc.+22', 'Pet: "Dbl. Atk."+5', 'Pet: Haste+5', } }

-- Telchine
gear.telchine = {}
gear.telchine.enh_dur = {}
gear.telchine.enh_dur.head = { name = "Telchine Cap", augments = { '"Elemental Siphon"+30', 'Enh. Mag. eff. dur. +10', } }
gear.telchine.enh_dur.body = { name = "Telchine Chas.",
    augments = { '"Elemental Siphon"+35', 'Enh. Mag. eff. dur. +10', } }
gear.telchine.enh_dur.hands = { name = "Telchine Gloves",
    augments = { '"Elemental Siphon"+30', 'Enh. Mag. eff. dur. +9', } }
gear.telchine.enh_dur.legs = { name = "Telchine Braconi",
    augments = { '"Elemental Siphon"+30', 'Enh. Mag. eff. dur. +10', } }
gear.telchine.enh_dur.feet = { name = "Telchine Pigaches",
    augments = { 'Mag. Evasion+21', '"Fast Cast"+5', 'Enh. Mag. eff. dur. +9' }, }

gear.telchine.siphon = {}
gear.telchine.siphon = gear.telchine.enh_dur

gear.telchine.fc = {}
gear.telchine.fc.feet = gear.telchine.enh_dur.feet

gear.telchine.regen = {}
gear.telchine.regen.head = { name = "Telchine Cap", augments = { '"Regen" potency+3', } }
gear.telchine.regen.body = { name = "Telchine Chasuble", augments = { '"Regen" potency+3', } }
gear.telchine.regen.hands = gear.telchine.enh_dur.hands
gear.telchine.regen.legs = { name = "Telchine Braconi", augments = { '"Regen" potency+3', } }
gear.telchine.regen.feet = { name = "Telchine Pigaches", augments = { '"Fast Cast"+2', '"Regen" potency+3', } }

-- Yorium
gear.yorium = {}
gear.yorium.enmity = {}
gear.yorium.enmity.feet = { name = "Yorium Sabatons", augments = { 'Enmity+10', 'Phalanx +3' } }

gear.yorium.phalanx = {}
gear.yorium.phalanx.feet = gear.yorium.enmity.feet

gear.yorium.drain = {}
gear.yorium.drain.feet = { name = "Yorium Sabatons", augments = { 'Mag. Acc.+10', '"Drain" and "Aspir" potency +6', } }

-- Acro
gear.acro = {}
gear.acro.SIRD = {}
gear.acro.SIRD.hands = { name = "Acro Gauntlets", augments = { 'DEF+23', 'Spell interruption rate down -10%', 'HP+50', } }
gear.acro.SIRD.head = { name = "Acro Helm", augments = { 'DEF+22', 'Spell interruption rate down -10%', 'HP+50' } }

gear.acro.drain = {}
gear.acro.drain.body = { name = "Acro Surcoat", augments = { 'Mag. Acc.+10', '"Drain" and "Aspir" potency +7', 'INT+6', } }

-- Merlinic
gear.merlinic = {}
gear.merlinic.fc = {}
gear.merlinic.fc.head = { name = "Merlinic Hood", augments = { '"Mag.Atk.Bns."+26', '"Fast Cast"+7', 'Mag. Acc.+11', } }
gear.merlinic.fc.body = { name = "Merlinic Jubbah", augments = { 'Mag. Acc.+1', '"Fast Cast"+7', } }
gear.merlinic.fc.feet = { name = "Merlinic Crackows", augments = { '"Mag.Atk.Bns."+1', '"Fast Cast"+7', 'MND+3',
    'Mag. Acc.+14', } }
gear.merlinic.fc.hands = { name = "Merlinic Dastanas", augments = { '"Fast Cast"+7', 'CHR+10', '"Mag.Atk.Bns."+6' } }

gear.merlinic.bp = {}
gear.merlinic.bp.hands = { name = "Merlinic Dastanas", augments = { 'Pet: "Mag.Atk.Bns."+29', 'Blood Pact Dmg.+9',
    'Pet: INT+4', }, }

gear.merlinic.phalanx = {}
gear.merlinic.phalanx.head = { name = "Merlinic Hood",
    augments = { 'Crit. hit damage +1%', 'STR+2', 'Phalanx +4', 'Accuracy+17 Attack+17', } }

-- Chironic
gear.chironic = {}
gear.chironic.refresh = {}
gear.chironic.refresh.feet = { name = "Chironic Slippers",
    augments = { 'Crit. hit damage +1%', 'Sklchn.dmg.+4%', '"Refresh"+2', 'Mag. Acc.+11 "Mag.Atk.Bns."+11', } }
gear.chironic.refresh.hands = { name = "Chironic Gloves",
    augments = { 'Weapon skill damage +2%', 'Pet: Accuracy+17 Pet: Rng. Acc.+17', '"Refresh"+2',
        'Mag. Acc.+17 "Mag.Atk.Bns."+17', }, }

-- Herculean
gear.herculean = {}
gear.herculean.phalanx = {}
gear.herculean.phalanx.legs = { name = "Herculean Trousers",
    augments = { 'Enmity-6', 'Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3', 'Phalanx +4', 'Mag. Acc.+8 "Mag.Atk.Bns."+8', } }
gear.herculean.phalanx.feet = { name = "Herculean Boots",
    augments = { '"Store TP"+2', '"Mag.Atk.Bns."+20', 'Phalanx +4', } }

gear.herculean.fc = {}
gear.herculean.fc.head = { name = "Herculean Helm", augments = { 'Mag. Acc.+18', '"Fast Cast"+6', 'MND+8' } }

gear.herculean.th = {}
gear.herculean.th.head = { name = "Herculean Helm",
    augments = { 'Accuracy+2 Attack+2', 'MND+15', '"Treasure Hunter"+2', 'Mag. Acc.+9 "Mag.Atk.Bns."+9', } }
gear.herculean.th.body = { name = "Herculean Vest",
    augments = { 'Enmity+2', 'AGI+14', '"Treasure Hunter"+2', 'Accuracy+11 Attack+11', 'Mag. Acc.+5 "Mag.Atk.Bns."+5', } }
gear.herculean.th.legs = { name = "Herculean Trousers",
    augments = { '"Fast Cast"+2', 'Pet: STR+5', '"Treasure Hunter"+2', 'Accuracy+15 Attack+15',
        'Mag. Acc.+2 "Mag.Atk.Bns."+2', }, }

-- gear.herculean.ws = {}
-- gear.herculean.ws.legs = { name = "Herculean Trousers",
--     augments = { 'Phys. dmg. taken -2%', 'Mag. Acc.+16 "Mag.Atk.Bns."+16', 'Weapon skill damage +7%',
--         'Accuracy+18 Attack+18', } }

-- Odyssean
gear.odyssean = {}
gear.odyssean.fc = {}
gear.odyssean.fc.feet = { name = "Odyssean Greaves", augments = { '"Fast Cast"+6', 'Mag. Acc.+13', '"Mag.Atk.Bns."+14' } }

-- Grioavolr
gear.grioavolr = {}
gear.grioavolr.fc = { name = "Grioavolr", augments = { '"Fast Cast"+7', 'MP+101', } }
gear.grioavolr.bp = { name = "Grioavolr",
    augments = { 'Blood Pact Dmg.+9', 'Pet: STR+19', 'Pet: Mag. Acc.+18', 'Pet: "Mag.Atk.Bns."+24' }, }

-- Colada
gear.colada = {}
gear.colada.enh_dur = { name = "Colada", augments = { 'Enh. Mag. eff. dur. +4', 'STR+1', 'Mag. Acc.+16', } }

-- Stinky rings
gear.left_stikini = { name = "Stikini Ring +1", bag = "wardrobe3" }
gear.right_stikini = { name = "Stikini Ring +1", bag = "wardrobe4" }
