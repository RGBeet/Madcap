local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

-- Like Eternal, but allows for selling
local shielded = {
    key = "rgmc_shielded",
	config = { },
	pos = { x = 0, y = 0},
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
    key = "rgmc_painted",
	config = { },
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
	key = "rgmc_twinkling",
	config = { },
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
    key = "rgmc_engraved",
	config = { },
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

-- Given by The Grave
-- Sets Mult to 0 upon scoring (subject to change!)
local clown = {
    key = "rgmc_clown",
	config = {},
	pos = {x=4,y=1},
	badge_colour = HEX('F13938'),
	loc_vars = function(self, info_queue, card)
		return Madcap.BlankVar
	end,
	calculate = function(self, card, context)
		if
			context.main_scoring 
			and context.cardarea == G.play
			and not context.repetition
			and not context.individual
		then
			MadLib.event({
                trigger = 'after', 
                func = function() 
                    play_sound('rgmc_clown_ow', 1.2, 0.4)
                    card:juice_up(0.3,0.3)
                    return true 
                end
            })
		end

        if -- end of round shenanigans
			context.end_of_round
			and not context.repetition
			and not context.individual
		then
		end
	end,
}

-- Red Power (+Mult)
local bismuth_red = {
    key = "rgmc_bismuth_red",
	config = { mult = 15 },
	pos = { x = 0, y = 2},
	badge_colour = HEX("C95B86"),
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult or 0 } }
	end,
	should_apply = false,
	apply = function(self, card, val)
	end,
	bismuth = true,
	calculate = function(self, card, context)
		if
			not context.repetition
			and (
				(context.joker_main and context.cardarea == G.jokers)
				or (context.main_scoring and context.cardarea == G.play)
			)
		then
			return {
                message = localize{
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.mult or 1 }
				},
                x_mult = card.ability.mult or 1,
                colour = G.C.MULT,
			}
		end
	end,
}

-- Green Power (+Retrigger)
local bismuth_green = {
    key = "rgmc_bismuth_green",
	config = { retriggers = 1 },
	pos = { x = 1, y = 2},
	badge_colour = HEX("3867DD"),
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.retriggers or 0 } }
	end,
	should_apply = false,
	apply = function(self, card, val)
	end,
	bismuth = true,
	calculate = function(self, card, context)
		if
			not context.repetition
			and (
				(context.joker_main and context.cardarea == G.jokers)
				or (context.main_scoring and context.cardarea == G.play)
			)
		then
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.retriggers,
				card = card,
			}
		end
	end,
}

-- Yellow Power (Draw +1)
local bismuth_yellow = {
    key = "rgmc_bismuth_yellow",
	config = { draw = 1 },
	pos = { x = 2, y = 2},
	badge_colour = HEX("3867DD"),
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.draw or 0 } }
	end,
	should_apply = false,
	apply = function(self, card, val)
	end,
	bismuth = true,
	calculate = function(self, card, context)
		if
			not context.repetition
			and (
				(context.joker_main and context.cardarea == G.jokers)
				or (context.main_scoring and context.cardarea == G.play)
			)
		then
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.retriggers,
				card = card,
			}
		end
	end,
}

-- Purple Power (XScore)
local bismuth_purple = {
    key = "rgmc_bismuth_purple",
	config = { x_score = 1.2 },
	pos = { x = 3, y = 2},
	badge_colour = HEX("3867DD"),
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.x_score or 1 } }
	end,
	should_apply = false,
	apply = function(self, card, val)
	end,
	bismuth = true,
	calculate = function(self, card, context)

		-- to purple
        if
			context.main_scoring
			and context.cardarea == G.play
		then
			card.ability.rgmc_purple_bismuth = true
            return {
				message = "...?",
				colour = G.C.PURPLE
			}
		end

		-- purpled
		if
			context.after
			and card.ability.rgmc_purple_bismuth
		then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
				func = function()
					G.GAME.chips = (to_big(G.GAME.chips)) * (to_big(card.ability.x_score))
					G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
					play_sound('holo1')
                    card.ability.rgmc_purple_bismuth = nil -- not needed now
					return true
				end,
			}))
            return {
				message = "X" .. format_number(card.ability.x_score),
				colour = G.C.PURPLE
			}
        end
	end,
}

-- Blue Power (+Chip)
local bismuth_blue = {
    key = "rgmc_bismuth_blue",
	config = { chips = 50 },
	pos = { x = 4, y = 2},
	badge_colour = HEX("3867DD"),
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chups or 0 } }
	end,
	should_apply = false,
	apply = function(self, card, val)
	end,
	bismuth = true,
	calculate = function(self, card, context)
		if
			not context.repetition
			and (
				(context.joker_main and context.cardarea == G.jokers)
				or (context.main_scoring and context.cardarea == G.play)
			)
		then
			return {
                message = localize{
					type = 'variable',
					key = 'a_chips',
					vars = { card.ability.chips or 1 }
				},
                x_mult = card.ability.chips or 1,
                colour = G.C.CHIPS,
			}
		end
	end,
}

local list = {

	-- "regular" stickers
	shielded,
    painted,
    twinkling,
    engraved,
	clown,

    -- bismuth stickers
    bismuth_red,
    bismuth_green,
    bismuth_yellow,
    bismuth_purple,
    bismuth_blue,
}

for i=1,#list do
	list[i].object_type = 'Sticker'
	list[i].atlas 		= 'stickers'
end

return {
    name = "Stickers",
    init = function() print("Stickers!") end,
    items = list
}
