-- Universal sets and functions

sets.TreasureHunter = {
    head = "Volte Cap",
    waist = "Chaac Belt", legs = "Volte Hose", feet = "Volte Boots"
}

sets.ProShell = {
    ear1 = "Brachyura EArring"
}

hook = {}
hook.proshell_hook = false

info.proshellra_ids = T {
    125, 126, 127, 128, 129, -- protectra
    130, 131, 132, 133, 134 -- shellra
}

info.proshell_ids = T {
    43, 44, 45, 46, 47, -- protect
    48, 49, 50, 51, 52 -- shell
}

function get_party_ids()
    local party = windower.ffxi.get_party()
    local ids = T {}
    if party.p0.mob then ids.append(party.p0.mob.id) end
    if party.p1.mob then ids.append(party.p1.mob.id) end
    if party.p2.mob then ids.append(party.p2.mob.id) end
    if party.p3.mob then ids.append(party.p3.mob.id) end
    if party.p4.mob then ids.append(party.p4.mob.id) end
    if party.p5.mob then ids.append(party.p5.mob.id) end
    return ids
end

function register_proshell_hook()
    -- only allow one hook
    if hook.proshell_hook then return end

    hook.proshell_hook = windower.register_event('action', function(act)
        if act.category == 7 then
            -- checks if the spell is a protect or shell spell
            local function isProtect()
                for i, v in pairs(info.proshell_ids + info.proshellra_ids) do
                    if act.targets.actions.param == v then return true end
                end
                return false
            end

            -- checks if the spell is cast on a party member
            local function isOnSelf()
                local ids = get_party_ids()
                for i, v in pairs(ids) do
                    if act.targets.id == v then return true end
                end
                return false
            end

            if isOnSelf() and isProtect() then
                send_command('gs equip sets.Proshell')
            end
        end
    end)
end

function unregister_proshell_hook()
    windower.unregister_event(hook.proshell_hook)
    hook.proshell_hook = false
end
