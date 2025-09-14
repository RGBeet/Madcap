return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Edition",
        key 	= 'iridescent',
        shader 	= 'iridescent',
        weight 	= 2,
        in_shop = true,
        extra_cost = 4,
        config  = { x_chips = 2.5, trigger = nil },
        sound   = { sound = "rgmc_e_iridescent", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(self.config.x_chips)
        end,
        calculate = function(self, card, context)
            if 
                context.post_joker or
                (context.main_scoring and context.cardarea == G.play) 
            then
                -- Redistributes the sum of chips and mult 70-30
                -- (larger value gets 70%, smaller gets 30%)
                local tyler = hand_chips + mult
                local major = hand_chips >= mult and 'hand_chips' or 'mult'
                local minor = hand_chips <= mult and 'mult' or 'hand_chips'
                local major_score, minor_score = tyler*0.7, tyler*0.3

                hand_chips = major == 'hand_chips' and major_score or minor_score
                mult = major == 'mult' and major_score or minor_score

                G.HUD:get_UIE_by_ID('hand_chips'):juice_up(0.5, 0.5)
                G.HUD:get_UIE_by_ID('hand_mult'):juice_up(0.3, 0.3)

                play_sound("gong", 0.94 * 1.5, 0.2)

                return {
                    message = localize("rgmc_balanced"),
                    colour = G.C.PURPLE
                }
            end

            if context.joker_main then
                card.config.trigger = true -- context.edition triggers twice, this makes it only trigger once (only for jonklers)
            end

            if context.after then
                card.config.trigger = nil
            end
        end,
    }
}
