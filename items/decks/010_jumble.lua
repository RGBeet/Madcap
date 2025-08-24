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

            G.GAME.jumble_deck = {
                jumbled = false,
                ranks = {},
                suits = {}
            }
        end,
        calculate = function(self, card, context)
            if
                context.seting_blind
                and G.GAME.jumble_deck.jumbled ~= true
            then
                local ranks = MadLib.get_ranks_from_cards(G.playing_cards)
                local old_ranks = {}
                MadLib.loop_table(ranks, function(k) table.insert(old_ranks, k) end)
                ranks = MadLib.deep_copy_list(G.GAME.jumble_deck.ranks)
                pseudoshuffle(ranks, pseudoseed('jumble'))

                local suits = MadLib.get_suits_from_cards(G.playing_cards)
                local old_suits = {}
                MadLib.loop_table(suits, function(k) table.insert(old_suits, k) end)
                suits = MadLib.deep_copy_list(G.GAME.jumble_deck.suits)
                pseudoshuffle(suits, pseudoseed('jumble'))
                MadLib.loop_func(ranks, function(v,i) G.GAME.jumble_deck.ranks[old_ranks[i]] = v end)
                MadLib.loop_func(suits, function(v,i) G.GAME.jumble_deck.suits[old_suits[i]] = v end)
                G.GAME.jumble_deck.jumbled = true
            end
        end,
        init = function(self)
            -- get id
            local get_id_ref = Card.get_id
            function Card:get_id()
                local old_id = get_id_ref(self)
                if G.GAME.jumble_deck and G.GAME.jumble_deck.ranks[old_id] then
                    return G.GAME.jumble_deck.ranks[old_id]
                end
                -- continue as usual...
                return old_id
            end
        end
    }
}
