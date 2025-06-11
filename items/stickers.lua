-- Like Eternal, but allows for selling
local shielded = {
    object_type = "Sticker",
    key = "rgmc_shielded",
	config = { },
	atlas = "stickers",
	pos = {x=0,y=0},
	badge_colour = HEX('8d67e7'),
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                G.GAME and card.ability.rgmc_shielded_tally or 21
            }
        }
	end,
	calculate = function(self, card, context)
        if -- end of round shenanigans
			context.end_of_round
			and not context.repetition
			and not context.individual
		then
			card:calculate_rgmc_shielded()
		end
	end,
	should_apply = false,
	apply = function(self, card, val)
		card.ability.rgmc_shielded 			= true
		card.ability.rgmc_shielded_tally 	= 3
	end,
}

-- Originally made for Rio
-- Applies random enhancement on application
local painted = {
    object_type = "Sticker",
    key = "rgmc_painted",
	config = { },
	atlas = "stickers",
	pos = {x=2,y=0},
	badge_colour = HEX('8d67e7'),
	calculate = function(self, card, context)
		if context.end_of_round then
			card:calculate_rgmc_painted(false)
		end
	end,
	should_apply = false
}

-- Given by Twinkle of Contagion
-- cannot change edition
local twinkling = {
    object_type = "Sticker",
    key = "rgmc_twinkling",
	config = { },
	atlas = "stickers",
	pos = {x=3,y=0},
	badge_colour = HEX('15BE59'),
	calculate = function(self, card, context)
		if context.end_of_round then
			card:calculate_rgmc_twinkling(false)
		end
	end,
	should_apply = false
}

-- Given by The Grave
-- Sets Mult to 0 upon scoring (subject to change!)
local engraved = {
    object_type = "Sticker",
    key = "rgmc_engraved",
	config = { },
	atlas = "stickers",
	pos = {x=3,y=1},
	badge_colour = HEX('736C4E'),
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                G.GAME and card.ability.rgmc_engraved_tally or 21
            }
        }
	end,
	calculate = function(self, card, context)
		if
			(context.joker_main and context.cardarea == G.jokers)
			or (context.main_scoring and context.cardarea == G.play)
		then
			return {
                message = localize{type='variable',key='a_xmult',vars={0}},
                x_mult = 0,
                colour = G.C.RED,
			}
		end
        if -- end of round shenanigans
			context.end_of_round
			and not context.repetition
			and not context.individual
		then
			card:calculate_rgmc_engraved()
		end
	end,
	should_apply = false,
	apply = function(self, card, val)
		card.ability.rgmc_engraved 			= true
		card.ability.rgmc_engraved_tally 	= 3
	end,
}

local list = {
	shielded,
    painted,
    twinkling,
    engraved
}

return {
    name = "Stickers",
    init = function() print("Stickers!") end,
    items = list
}
