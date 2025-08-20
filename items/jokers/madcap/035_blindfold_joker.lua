return {
    data = {
        object_type = "Joker",
        key     = 'blindfold_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,4),
        rarity  = 2,
        cost    = 7,
        config =  {
            extra = { x_mult = 3, x_mult_penalty = 0.25, active = false }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                    number_format(card.ability.extra.x_mult),
                    number_format(card.ability.extra.x_mult_penalty),
                    card.ability.extra.active
                        and localize("k_active_ex")
                        or localize("rgmc_inactive"))
        end,
        calculate = function(self, card, context)

            -- start blind: activate if big blind show it's active
            if context.setting_blind then
                local is_big_blind = G.GAME.blind:get_type() == 'Big'
                card.ability.extra.active = is_big_blind

                if is_big_blind then
                    local eval = function() return G.GAME.blind:get_type() ~= "Big" end
                    juice_card_until(card, eval, true)
                end
            end

            -- Reduces by ? until lower than 0.5X Mult, then destructs.
            if context.skip_blind then -- uh oh...
                if (card.ability.extra.x_mult - card.ability.extra.x_mult_penalty) > 0.5 then -- going down
                    return Madcap.Funcs.get_simple_downgrade_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult_penalty)
                else
                    -- fucking explode
                    return MadLib.banana_remove(card)
                end
            end

            if -- big blind be like
                (context.joker_main and G.GAME.blind:get_type() == "Big")
                or context.forcetrigger -- demicolon
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
            end
        end,
        demicoloncompat = true,
    },
}
