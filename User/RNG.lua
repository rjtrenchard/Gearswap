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
	state.Buff.Barrage = buffactive.Barrage or false
	state.Buff.Camouflage = buffactive.Camouflage or false
	state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	include('augments.lua')
	include('natty_helper_functions.lua')
	include('default_sets.lua')

	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')

	gear.default.weaponskill_neck = "Ocachi Gorget"
	gear.default.weaponskill_waist = "Elanid Belt"

	DefaultAmmo = { ['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet" }
	U_Shot_Ammo = { ['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet" }

	select_default_macro_book()

	send_command('bind f9 gs c cycle RangedMode')
	send_command('bind ^f9 gs c cycle OffenseMode')
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	unbind_numpad()
	send_command('unbind f9')
	send_command('unbind ^f9')
end

-- Set up all gear sets.
function init_gear_sets()
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Bounty Shot'] = { hands = "Sylvan Glovelettes +2" }
	sets.precast.JA['Camouflage'] = { body = "Orion Jerkin +1" }
	sets.precast.JA['Scavenge'] = { feet = "Orion Socks +1" }
	sets.precast.JA['Shadowbind'] = { hands = "Orion Bracers +1" }
	sets.precast.JA['Sharpshot'] = { legs = "Orion Braccae +1" }


	-- Fast cast sets for spells

	sets.precast.FC = {
		head = "Carmine Mask +1",
		neck = "Orunmila's Torque",
		ear1 = "Enchanter's Earring +1",
		ear2 = "Loquacious Earring",
		body = "Adhemar Jacket +1",
		hands = "Leyline Gloves",
		ring1 = "Rahab Ring",
		ring2 = "Rahab Ring",
		legs = "Limbo Trousers",
		feet = "Carmine Greaves +1"
	}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck = "Magoraga Beads" })


	-- Ranged sets (snapshot)

	sets.precast.RA = {
		head = "Amini Gapette +1",
		body = "Ikenga's Vest",
		hands = "Alruna's Gloves +1",
		ring1 = "Crepuscular Ring",
		waist = "Yemaya Belt",
		legs = "Adhemar Kecks +1",
		feet = "Meghanada Jambeaux +2"
	}


	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
		head = "Orion beret +2",
		neck = "Fotia Gorget",
		ear1 = "Ishvara Earring",
		ear2 = "Moonshade Earring",
		hands = "Nyame Gauntlets",
		ring1 = "Regal Ring",
		ring2 = "Epaminondas's Ring",
		back = "Sylvan Chlamys",
		waist = "Fotia Belt",
		legs = "Arcadian Braccae +2",
		feet = "Orion Socks +1"
	}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		body = "Kyujutsugi",
		ring1 = "Hajduk Ring +1",
		back = "Lutian Cape",
		legs = "Orion Braccae +1"
	})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		ammo = "Hauksbok Arrow",
		neck = "Republican Platinum Medal",
		ring2 = "Epaminondas's Ring",
		waist = "Sailfi Belt +1"
	})


	--------------------------------------
	-- Midcast sets
	--------------------------------------

	-- Fast recast for spells

	sets.midcast.FastRecast = {
		head = "Orion Beret +1",
		ear1 = "Loquacious Earring",
		ring1 = "Rahab Ring",
		waist = "Pya'ekue Belt +1",
		legs = "Orion Braccae +1",
		feet = "Orion Socks +1"
	}

	sets.midcast.Utsusemi = {}

	-- Ranged sets

	sets.midcast.RA = {
		head = "Malignance Chapeau",
		neck = "Iskur Gorget",
		ear1 = "Telos Earring",
		ear2 = "Beyla Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Dingir Ring",
		ring2 = "Regal Ring",
		back = "Lutian Cape",
		waist = "Yemaya Belt",
		legs = "Malignance Tights",
		feet = "Malignance Boots"
	}

	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		head = "Malignance Chapeau",
		neck = "Iskur Gorget",
		ear1 = "Telos Earring",
		ear2 = "Beyla Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Dingir Ring",
		ring2 = "Regal Ring",
		back = "Lutian Cape",
		waist = "Yemaya Belt",
		legs = "Malignance Tights",
		feet = "Malignance Boots"
	})

	sets.midcast.RA.Annihilator = set_combine(sets.midcast.RA)

	sets.midcast.RA.Annihilator.Acc = set_combine(sets.midcast.RA.Acc)

	sets.midcast.RA.Yoichinoyumi = set_combine(sets.midcast.RA, {
		ear2 = "Clearview Earring",
		ring2 = "Rajas Ring",
		back = "Sylvan Chlamys"
	})

	sets.midcast.RA.Yoichinoyumi.Acc = set_combine(sets.midcast.RA.Acc, { ear2 = "Clearview Earring" })

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

	-- Sets to return to when not performing an action.

	-- Resting sets
	sets.resting = { neck = "Bathy Choker +1" }

	-- Idle sets
	sets.idle = {
		head = "Malignance Chapeau",
		neck = "Loricate Torque +1",
		ear1 = "Odnowa Earring +1",
		ear2 = "Etiolation Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Defending Ring",
		back = "Moonlight Cape",
		waist = "Flume Belt +1",
		legs = "Carmine Cuisses +1",
		feet = "Malignance Boots"
	}

	-- Defense sets
	sets.defense.PDT = {
		head = "Malignance Chapeau",
		neck = "Loricate Torque +1",
		ear1 = "Odnowa Earring +1",
		ear2 = "Etiolation Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Defending Ring",
		back = "Moonlight Cape",
		waist = "Flume Belt +1",
		legs = "Malignance Tights",
		feet = "Malignance Boots"
	}

	sets.defense.MDT = {
		head = "Malignance Chapeau",
		neck = "Loricate Torque +1",
		ear1 = "Odnowa Earring +1",
		ear2 = "Etiolation Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Defending Ring",
		back = "Moonlight Cape",
		waist = "Flume Belt +1",
		legs = "Malignance Tights",
		feet = "Malignance Boots"
	}

	sets.Kiting = { legs = "Carmine Cuisses +1" }


	--------------------------------------
	-- Engaged sets
	--------------------------------------

	sets.engaged = {
		head = "Malignance Chapeau",
		neck = "Anu Torque",
		ear1 = "Sherida Earring",
		ear2 = "Telos Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Epona's Ring",
		ring2 = gear.right_chirich,
		back = "Moonlight Cape",
		waist = "Sailfi Belt +1",
		legs = "Samnuha Tights",
		feet = "Malignance Boots"
	}

	sets.engaged.Acc = {
		head = "Malignance Chapeau",
		neck = "Combatant's Torque",
		ear1 = "Crepuscular Earring",
		ear2 = "Telos Earring",
		body = "Malignance Tabard",
		hands = "Malignance Gloves",
		ring1 = "Epona's Ring",
		ring2 = gear.right_chirich,
		back = "Moonlight Cape",
		waist = "Sailfi Belt +1",
		legs = "Malignance Tights",
		feet = "Malignance Boots"
	}

	sets.engaged.DW = set_combine(sets.engaged, { waist = "Reiki Yotai" })

	sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, { waist = "Reiki Yotai" })

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, { hands = "Orion Bracers +1" })
	sets.buff.Camouflage = { body = "Orion Jerkin +1" }

	sets.resist = {}
	sets.resist.death = {
		main = "Odium",
		body = "Samnuha Coat",
		ring1 = "Shadow Ring",
		ring2 = "Eihwaz Ring"
	}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end

	if spell.action_type == 'Ranged Attack' or
		(spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
		check_ammo(spell, action, spellMap, eventArgs)
	end

	if state.DefenseMode.value ~= 'None' and spell.type == 'WeaponSkill' then
		-- Don't gearswap for weaponskills when Defense is active.
		eventArgs.handled = true
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if buff == "Camouflage" then
		if gain then
			equip(sets.buff.Camouflage)
			disable('body')
		else
			enable('body')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Check for proper ammo when shooting or weaponskilling
function check_ammo(spell, action, spellMap, eventArgs)
	-- Filter ammo checks depending on Unlimited Shot
	if state.Buff['Unlimited Shot'] then
		if player.equipment.ammo ~= U_Shot_Ammo[player.equipment.range] then
			if player.inventory[U_Shot_Ammo[player.equipment.range]] or player.wardrobe[U_Shot_Ammo[player.equipment.range]] then
				add_to_chat(122, "Unlimited Shot active. Using custom ammo.")
				equip({ ammo = U_Shot_Ammo[player.equipment.range] })
			elseif player.inventory[DefaultAmmo[player.equipment.range]] or
				player.wardrobe[DefaultAmmo[player.equipment.range
				]] then
				add_to_chat(122, "Unlimited Shot active but no custom ammo available. Using default ammo.")
				equip({ ammo = DefaultAmmo[player.equipment.range] })
			else
				add_to_chat(122, "Unlimited Shot active but unable to find any custom or default ammo.")
			end
		end
	else
		if player.equipment.ammo == U_Shot_Ammo[player.equipment.range] and
			player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122, "Unlimited Shot not active. Using Default Ammo")
					equip({ ammo = DefaultAmmo[player.equipment.range] })
				else
					add_to_chat(122, "Default ammo unavailable.  Removing Unlimited Shot ammo.")
					equip({ ammo = empty })
				end
			else
				add_to_chat(122, "Unable to determine default ammo for current weapon.  Removing Unlimited Shot ammo.")
				equip({ ammo = empty })
			end
		elseif player.equipment.ammo == 'empty' then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122, "Using Default Ammo")
					equip({ ammo = DefaultAmmo[player.equipment.range] })
				else
					add_to_chat(122, "Default ammo unavailable.  Leaving empty.")
				end
			else
				add_to_chat(122, "Unable to determine default ammo for current weapon.  Leaving empty.")
			end
		elseif player.inventory[player.equipment.ammo].count < 15 then
			add_to_chat(122,
				"Ammo '" ..
				player.inventory[player.equipment.ammo].shortname ..
				"' running low (" .. player.inventory[player.equipment.ammo].count .. ")")
		end
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 11)
end
