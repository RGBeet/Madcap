width = 4
local function c(n)
    return {x = (n % width), y = math.floor(n / width)}
end

local patina = {
	object_type = "Seal",
    name = "patina_seal",
    key = "patina",
    atlas = "seals",
    pos = c(0),
    badge_colour = HEX("49ab9a"),
    discovered = true,
	config = {},
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
}

local bronze = {
    object_type = "Seal",
    name = "bronze_seal",
    key = "bronze",
    atlas = "seals",
    pos = c(1),
    badge_colour = HEX("754D42"),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    calculate = function(self, card, context)
    end,
}

local jade = {
    object_type = "Seal",
    name = "jade_seal",
    key = "jade",
    atlas = "seals",
    pos = c(2),
    badge_colour = HEX("226F4C"),
    config = {extra = { }},
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    calculate = function(self, card, context)
		if
            context.main_scoring
            and context.cardarea == G.play
        then
            --draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
            card.ability.rgmc_jade = true
            tell("Jade Seal activated!")
		end
    end,
}

local umber = {
    object_type = "Seal",
    name = "umber_seal",
    key = "umber",
    atlas = "seals",
    pos = c(4),
    badge_colour = HEX("DF6622"),
    config = {
        draw_cards = 2
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(self.config.draw_cards or 2),
            }
        }
    end,
    calculate = function(self, card, context)
		if
            context.pre_discard
        then
            for i=1,2 do draw_card(G.deck,G.hand, i*100/i,'up', true) end
            print("Umber Seal activated!")
		end
    end,
}

local cream = {
    object_type = "Seal",
    name = "cream_seal",
    key = "cream",
    atlas = "seals",
    pos = c(3),
    badge_colour = HEX("EAE9BD"),
    config = {
        odds = 3
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(self.config.odds or 3),
            }
        }
    end,
    calculate = function(self, card, context)
		if
            context.end_of_round
            and context.cardarea == G.hand
            and not context.game_over
            and (pseudorandom(pseudoseed("rgmc_cream_seal")) < (G.GAME.probabilities.normal / self.config.odds))
        then
            tell("Cream Seal activated!")
		end
    end,
}

local list = {
    patina,
    bronze,
    jade,
    umber,
    cream
}

return {
    name = "Seals",
    init = function() print("Seals!") end,
    items = list
}
