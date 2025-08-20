function Madcap.Funcs.jumble_ranks(self)
    if G.playing_cards then return false end
    local rank_map = MadLib.get_ranks_from_cards(G.playing_cards)
    local rank_list, changed_ranks = {}, {}
    -- add to list
    MadLib.loop_func_table(rank_map, function(k,v)
        table.insert(rank_list, v)
        table.insert(changed_ranks, v)
    end)
    pseudoshuffle(changed_ranks, pseudoseed('jumble'))
    MadLib.loop_func(rank_list, function(v,i)
        G.GAME.JumbleVals[v] = changed_ranks[i] -- old
    end)
    return true
end

return {
    devmode = true,
    categories = {
        'Decks',
    },
    data = {
        object_type = "Back",
        key     = "jumble",
        atlas   = 'decks',
        pos     = MLIB.coords(1,4),
        config  = {

        },
        apply = function(self, back)
            G.GAME.modifiers.rgmc_deck      = true  -- music activated
            G.GAME.modifiers.rgmc_jumble    = true

            G.GAME.JumbleVals = {}
            Madcap.Funcs.jumble_ranks(self)
        end,
        calculate = function(self, card, context)
            if
                context.seting_blind
                and (#G.GAME.JumbleVals == 0)
            then -- get the ranks

            end
        end,
        init = function(self)
            -- get id
            local get_id_ref = Card.get_id
            function Card:get_id()
                local old_id = get_id_ref(self)
                if
                    G.GAME.modifiers
                    and G.GAME.modifiers.rgmc_jumble
                    and G.GAME.JumbleVals
                    and G.GAME.JumbleVals[old_id] ~= nil
                then
                    return G.GAME.JumbleVals[old_id]
                end
                -- continue as usual...
                return old_id
            end

            -- ease ante does the jumble
            local ease_ante_ref = ease_ante
            function ease_ante(mod)
                if
                    G.GAME.modifiers
                    and G.GAME.modifiers.rgmc_jumble
                then
                    Madcap.Funcs.jumble_ranks(self)
                end
            end
        end
    }
}
