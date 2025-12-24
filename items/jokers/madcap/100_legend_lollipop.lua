--[[
poll_edition({guaranteed = true})

]]
Madcap.Lists.LollipopEditions = {
    'e_holo',
    'e_foil',
    'e_polychrome',
}

local add_editions = true
-- madcap add editions
if add_editions then
    MadLib.loop_func({ 'iridescent', 'chrome', 'disco', 'galactic', 'luxury' }, function(v)
        table.insert(Madcap.Lists.LollipopEditions, 'e_rgmc_'..v)
    end)
end

if next(SMODS.find_mod("Bunco")) then
    MadLib.loop_func({ 'glitter', 'fluorescent' }, function(v)
        table.insert(Madcap.Lists.LollipopEditions, 'e_bunc_'..v)
    end)
end

if next(SMODS.find_mod("paperback")) then
    MadLib.loop_func({ 'dichrome' }, function(v)
        table.insert(Madcap.Lists.LollipopEditions, 'e_paperback_'..v)
    end)
end

if next(SMODS.find_mod("aikoyorisshenanigans")) then
    MadLib.loop_func({ 'texelated' }, function(v)
        table.insert(Madcap.Lists.LollipopEditions, 'e_paperback_'..v)
    end)
end

return {
    --devmode = true,
    data = {
        object_type = "Joker",
        key         = 'legend_lollipop',
        atlas       = 'jokers_legendary',
        pos         = MLIB.legend(2,false),
        soul_pos    = MLIB.legend(2,true),
        rarity      = 4,
        cost        = 19,
        config =  { },
        calculate = function(self, card, context)
            if
                context.joker_type_destroyed
                and not context.blueprint
                and context.card.config.center.set == "Joker"
                and context.card.config.center.rarity == 1 -- common joker
            then
                --print(context.card.config.center.rarity)
                local new_edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, nil, true, true, Madcap.Lists.LollipopEditions)
                MadLib.simple_event(function()
                    local card = copy_card(self, nil, nil, nil, false)
                    card:start_materialize()
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:set_edition(new_edition, true)
                    return true
                end, 0.5, 'after')
            end
        end,
        demicoloncompat   = false,
    }
}
