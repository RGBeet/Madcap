Madcap.DiscoWeights = {
	{ key = "a_chips", 		weight 	= 6, },
	{ key = "a_mult", 		weight 	= 5, },
	{ key = "a_dollars", 	weight 	= 4, },
	{ key = "x_mult", 		weight 	= 3, },
	{ key = "x_score", 		weight 	= 2, },
	{ key = "x_dollars", 	weight 	= 1, },
}

return {
    categories = {
        'Editions',
        'Score'
    },
    data = {
        object_type = "Edition",
        key 	= 'disco',
        shader 	= 'disco',
        weight = 2,
        extra_cost = 2,
        config = {
            a_chips = 40,
            a_mult = 8,
            x_mult = 2,
            a_dollars = 7,
            x_dollars = 1.5,
            x_score = 2,
            trigger = nil
        },
        sound = { sound = "rgmc_e_disco", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(
                self.config.a_chips or 40,
                self.config.a_mult or 8,
                self.config.x_mult or 2,
                self.config.a_dollars or 7,
                self.config.x_score or 2,
                self.config.x_dollars or 1.5)
        end,
        calculate = function(self, card, context)
            if Madcap.Funcs.edition_in_play(context,card) then
                -- Weighted random choice
                local choice = nil
                local total_weight = 0
                for i = 1, #Madcap.DiscoWeights do
                    total_weight = total_weight + Madcap.DiscoWeights[i].weight
                end
                local nubby = pseudorandom('rgmc_disco_picker', 1, total_weight)
                local running_weight = 0
                for i = 1, #Madcap.DiscoWeights do
                    running_weight = running_weight + Madcap.DiscoWeights[i].weight
                    if nubby <= running_weight then
                        choice = Madcap.DiscoWeights[i].key
                        break
                    end
                end
                if not self.config[choice] then choice = nil end

                if choice == 'x_dollars' then
                    ease_dollars(G.GAME.dollars * lenient_bignum(self.config[choice]))
                    return {
                        message = "X$" .. lenient_bignum(self.config[choice]),
                        colour = G.C.MONEY
                    }
                elseif choice == 'a_dollars' then
                    ease_dollars(G.GAME.dollars + lenient_bignum(self.config[choice]))
                    return {
                        message = "+$" .. lenient_bignum(self.config[choice]),
                        colour = G.C.MONEY
                    }
                elseif choice == 'x_mult' then
                    return {
                        Xmult_mod = lenient_bignum(self.config[choice]),
                        colour = G.C.MULT,
                    }
                elseif choice == 'a_mult' then
                    return {
                        mult_mod = lenient_bignum(self.config[choice]),
                        colour = G.C.MULT,
                    }
                elseif choice == 'a_chips' then
                    return {
                        chip_mod = lenient_bignum(self.config[choice]),
                        colour = G.C.CHIPS,
                    }
                elseif choice == 'x_score' then
                    MadLib.simple_event(function()
                        G.GAME.chips = to_big(G.GAME.chips) * to_big(amt)
                        G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
                        play_sound('holo1')
                        return true
                    end, 0.4, 'after')
                    return {
                        message = "...?",
                        colour = G.C.PURPLE
                    }
                else -- this shouldn't happen
                    return {
                        message = "...",
                        colour = G.C.FILTER
                    }
                end
            end
            if context.joker_main then
                card.config.trigger = true
            end
            if context.after then
                card.config.trigger = nil
            end
        end,
    }
}
