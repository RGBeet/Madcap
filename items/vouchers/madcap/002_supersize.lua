return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(0,1),
        atlas       = 'vouchers',
        key 		= "supersize",
        cost 		= 9,
        requires 	= MadLib.get_voucher_reqs('rgmc_combo_meal'),
        config 		= { extra 	= 1.07, active	= true },
        redeem 		= function(self)
        end,
        loc_vars 	= function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        calculate 	= function (self, card, context)
            if context.end_of_round and not context.game_over and context.main_eval then
                -- if you get overkill, you get a free tarot card
                local points, chip_goal = 0, G.GAME.blind.chips

                points = MadLib.build_onto_val(points, function(i)
                    return to_big(G.GAME.chips) >= to_big(chip_goal) and i <= 10
                end, function(v,i)
                    points = points + 1
                    return v ^ self.config.extra
                end, false)

                tell_stat('Rewards Gained',points)

                -- Make a list of 1-9 consumables - weights in Madcap table.
                local rewards = MadLib.get_loop_func_number(math.min(points,9), function(i)
                    local set = 'Tarot'
                    return MadLib.get_random_card(set, G.consumeables, 'supersize')
                end)

                MadLib.loop_func_list(rwards, function(v,i)
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    MadLib.simple_event(function()
                        play_sound('timpani')
                        v:add_to_deck()
                        v:set_edition({ negative = true }, true) -- now spawns as a Negative!
                        G.consumeables:emplace(v)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end, 0.5, 'after')
                end)
            end
        end,
    }
}
