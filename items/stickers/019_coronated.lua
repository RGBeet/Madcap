return {
    data = {
        object_type     = "Sticker",
        key             = "rgmc_coronated",
        atlas           = 'stickers',
        pos             = MLIB.coords(3,4),
        badge_colour    = HEX('D89134'),
        should_apply    = false,
        apply = function(self, card, val)
            card.ability.rgmc_coronated = true
        end,
        calculate = function(self, card, context)
            if
                context.ml_post_shuffle
                and context.ml_shuffling_area == G.deck
            then
                local target_position   = nil
                local current_position  = nil

                MadLib.loop_func(G.deck.cards, function(v)
                    if v == card then
                        current_position = i
                    elseif
                        (not (v.ability and v.ability.rgmc_coronated))
                        or (v.ability and v.ability.rgmc_coronated
                            and pseudorandom('rgmc_coronated'..G.GAME.round_resets.ante) < 0.5)
                    then
                        target_position = i
                    end
                end)

                target_position     = target_position or #G.deck.cards
                current_position    = current_position or #G.deck.cards
                G.deck.cards[current_position], G.deck.cards[target_position] = G.deck.cards[target_position], G.deck.cards[current_position]
			end
        end
    }
}
