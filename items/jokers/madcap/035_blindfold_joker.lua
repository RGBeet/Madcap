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
            if context.checktrigger then
                return context.joker_main and card.ability.extra.active == true
            end
            if context.setting_blind then
                local is_big_blind = G.GAME.blind:get_type() == 'Big'
                card.ability.extra.active = is_big_blind and true or false

                if is_big_blind then
                    local eval = function() return G.GAME.blind:get_type() ~= "Big" end
                    juice_card_until(card, eval, true)
                end
            end
            if context.skip_blind then -- uh oh...
                if MadLib.is_positive_number(MadLib.subtract(MadLib.subtract(card.ability.extra.x_mult, card.ability.extra.x_mult_penalty),0.5)) then
                    SMODS.destroy_cards(card, nil, nil, true)
                else
                    -- See note about SMODS Scaling Manipulation on the wiki
                    card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.x_mult_penalty
                    return {
                        message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.x_mult_penalty } },
                        colour = G.C.MULT
                    }
                end
            end
            if -- big blind be like
                (context.joker_main and card.ability.extra.active == true)
                or context.forcetrigger -- demicolon
            then
                return { xmult = card.ability.extra.x_mult, card = card }
            end
        end,
        demicoloncompat = true,
    },
}
