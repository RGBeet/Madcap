return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'nightfall',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 8,
        config = { 
            extra = { x_mult = 3 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_mult * 2))
        end,
        calculate = function(self, card, context)
            if 
                context.joker_main 
                and G.GAME.current_round.hands_left == 0
            then
                local _xmult = (MadLib.context_has_subhand(context, 'ml_sh_dark') and card.ability.extra.x_mult or 1)
                    * (MadLib.context_has_subhand(context, 'ml_sh_low') and card.ability.extra.x_mult or 1)
                if _xmult > 1 then return { xmult = _xmult} end
            end

            if context.forcetrigger then
                return { xmult = card.ability.extra.x_mult * 3}
            end
        end,
        demicoloncompat = true
    },
}
