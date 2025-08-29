return {
    categories = {
        'Tags',
    },
    data = {
        object_type = "Tag",
        key     = "exchange",
        atlas   = "tags",
        pos     = MLIB.coords(1,3),
        config  = { type 	= "immediate", extra 	= 1 },
        in_pool = function()
            return G.jokers and #G.jokers.cards > 0
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                -- Pseudo-sorted
                local jokers = MadLib.get_list_matches(G.jokers.cards, function(v)
                    return not SMODS.is_eternal(v)
                end)

                table.sort(jokers, function(a,b)
                    return MadLib.get_rarity_value(a.config.center.rarity) + math.random()*2 < MadLib.get_rarity_value(b.config.center.rarity)
                end)

                -- Destroy old jokers, make new jokers
                for i=1, math.min(#G.jokers.cards, self.config.extra) do
                    local target = G.jokers.cards[i]
                    local new_rarity = MadLib.get_higher_rarity(target.config.center.rarity)

                    MadLib.simple_event(function()
                        target:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end, 1.0, 'after')

                    MadLib.simple_event(function()
                        play_sound("timpani")
                        local card = create_card("Joker", G.jokers, nil, new_rarity, nil, nil, nil, "rgmc_exchange")
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 2.0, 'after')

                    tag:yep('~', G.C.DARK_EDITION, function() return true end)
                    tag.triggered = true
                    return true
                end
            end
        end,
    }
}
