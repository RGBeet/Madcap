return {
    data = {
        object_type = 'Blind',
        key     = 'coil',
        atlas   = "blinds",
        pos     = MLIB.coords(14),
        boss_colour = HEX('F4EFF6'),
        min_ante = 2,
        mult    = 2.5,
        config = { extra = -5 },
        loc_vars = function(self, info_queue, blind)
            return MadLib.collect_vars(
                number_format(2 * get_blind_amount(G.GAME and G.GAME.round_resets.ante or 1)),
                number_format(blind and blind.ability.extra or -5)
            )
        end,
        in_pool = function(self)
            return Madcap.Data.devmode or to_big(G.GAME.dollars - self.config.extra*3) > to_big(G.GAME.bankrupt_at)
        end,
        calculate = function(self, blind, context)
            if not G.GAME.blind.disabled and context.scoring_hand and context.final_scoring_step then
                local coilys = MadLib.get_list_matches(context.scoring_hand, function(v)
                    return SMODS.pseudorandom_probability(self, 'coil', 1, 4)
                end)
                MadLib.flip_cards(coilys, function(v) v.ability.rgmc_coil = true end)
            end
        end,
    }
}
