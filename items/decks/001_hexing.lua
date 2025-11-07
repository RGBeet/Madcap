return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key         = "hexing",
        atlas       = 'decks',
        pos         = MLIB.coords(0,1),
		config      = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base),
        loc_vars    = function(self)
            return MadLib.collect_vars_colours(
                localize(self.config.starting_suits[5], 'suits_plural'),
                localize(self.config.starting_suits[6], 'suits_plural'),
                { 
                    G.C.SUITS[self.config.starting_suits[5]],
                    G.C.SUITS[self.config.starting_suits[6]]
                })
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('hexing', { finishers = { 'bl_rgmc_final_chimes' }})
            G.GAME.Exotic = true -- Exotic Suits show up!
            MadLib.event({
                func = function()
                    local remove = {'2', '3', '4', '5'}
                    for k, v in pairs(G.playing_cards) do
                        if MadLib.list_matches_one(remove, function(v2) return v.base.value == v2; end) then 
                            v.to_remove = true
                        end
                    end
                    local i = 1
                    while i <= #G.playing_cards do
                        if G.playing_cards[i].to_remove then
                            G.playing_cards[i]:remove()
                        else
                            i = i + 1
                        end
                    end

                    local add_ranks = { '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }
                    local add_suits = { 'rgmc_goblets', 'rgmc_towers' }
                    MadLib.loop_func(add_ranks, function(rank)
                        MadLib.loop_func(add_suits, function(suit)
						    G.playing_cards[#G.playing_cards+1] = SMODS.create_card({ 
							    set = "Base",
							    rank = rank,
							    suit = suit 
						    })
						    G.deck:emplace(G.playing_cards[#G.playing_cards])
                        end)
                    end)

                    G.GAME.starting_deck_size = #G.playing_cards
                    G.deck.config.true_card_limit = #G.playing_cards
                    return true
                end
            })
        end
    }
}
