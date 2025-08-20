Madcap.ModdedSuits = {'goblets','towers','blooms','daggers'}
return {
    categories = {
        'Tags',
        'New Suits'
    },
    data = {
        object_type = "Tag",
        key     = "royal",
        atlas   = "tags",
        pos     = MLIB.coords(0,2),
        config = { type = 'standard_pack_opened' },
        in_pool = function()
            return G.GAME.round_resets.ante > 1 and G.GAME.Exotic -- appears after ante 1 and Exotics enabled
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                tag:instayep('+', G.C.MADCAP_UNUSUAL, function()
                    return true
                end, 0, nil, true)
                MadLib.event({
                    trigger = 'after',
                    delay = 0,
                    blockable = false,
                    blocking = false,
                    func = function()
                        if
                            G.pack_cards
                            and G.pack_cards.cards
                            and G.pack_cards.VT.y < G.ROOM.T.h -- pack cards
                        then
                            local num_cards = math.ceil((#G.pack_cards.cards * math.random() * 0.25) + (#G.pack_cards.cards/2))
                            local targets = MadLib.get_card_from_shuffled_deck(G.pack_cards.cards, num_cards, function(c)
                                return MadLib.list_matches_one(Madcap.ModdedSuits, function(k)
                                    return c:is_suit('rgmc_' .. k)
                                end)
                            end)
                            MadLib.loop_func(targets, function(v)
                                local suit = pseudorandom_element(Madcap.ModdedSuits, pseudoseed('rgmc_royal_'..G.SEED))
                                v:change_suit('rgmc_'..suit)
                            end)
                            return true
                        end
                    end
                })
                tag.triggered = true
                return true
            end
        end
    }
}
