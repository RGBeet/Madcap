

local ferrous = {
    object_type = "Enhancement",
	key = "ferrous",
	atlas = "enhance",
	pos = {x=0, y = 0},
    config = {
        extra = {
            chips = 15,
            gain = 15
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.chips),
                number_format(card.ability.extra.gain)
            }
        }
    end,
	calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.main_scoring
        then
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.chips) },
				}),
				chip_mod = lenient_bignum(card.ability.extra.chips),
			}
        end

        if -- Upgrades if left in hand at end of round
            context.playing_card_end_of_round
            and context.cardarea == G.hand
        then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
			return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card
            }
        end
    end,
}

 local wolfram = {
    object_type = "Enhancement",
	key = "wolfram",
	atlas = "enhance",
	pos = {x=1, y=0},
    config = {
        extra = {
            mult = 3,
            gain = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.gain)
            }
        }
    end,
	calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.main_scoring
        then
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { number_format(card.ability.extra.mult) },
				}),
				mult_mod = lenient_bignum(card.ability.extra.mult),
			}
        end

        if -- Upgrades if left in hand at end of round
            context.playing_card_end_of_round
            and context.cardarea == G.hand
        then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
			return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
    end,
}

local lustrous = {
    object_type = "Enhancement",
	key = "lustrous",
	atlas = "enhance",
	pos = {x=2, y=0},
    config = {
        extra = {
            x_mult = 1.1,
            gain = 0.3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.gain)
            }
        }
    end,
	calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.main_scoring
        then
			return {
				message = localize({
					type = "variable",
					key = "a_xmult",
					vars = { number_format(card.ability.extra.x_mult) },
				}),
				mult_mod = lenient_bignum(card.ability.extra.x_mult),
			}
        end

        if -- Upgrades if left in hand at end of round
            context.playing_card_end_of_round
            and context.cardarea == G.hand
        then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
			return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
    end,
}

local list = {
    ferrous,
    wolfram,
    lustrous
}

for i=1, #list do
	list[i].order = i-1
end

return {
    name = "Enhancements",
    init = function() print("Enhancements!") end,
    items = list
}
