return {
    data = {
        object_type = "Joker",
        key         = 'legend_foreman',
        atlas       = 'jokers_legendary',
        pos         = MLIB.legend(3,false),
        soul_pos    = MLIB.legend(3,true),
        rarity      = 4,
        cost        = 15,
        config =  {
            extra = { x_mult = 1.0, xmult_mod = 0.05, suit = MadcapConfig['New Suits'] and 'rgmc_goblets' or 'Hearts' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(localize(card.ability.extra.suit, 'suits_plural'), card.ability.extra.xmult_mod, card.ability.extra.x_mult, { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            if G.GAME.current_round.hands_played == 0 and context.cardarea == G.play and context.other_card and not context.other_card:is_suit(card.ability.extra.suit) then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.xmult_mod
                MadLib.flip_card(context.other_card,function(v)
                    SMODS.change_base(v, card.ability.extra.suit, _)
                end)
                local _card = context.other_card
                MadLib.simple_event(function()
                    _card:juice_up(0.5, 0.5)
                    return true
                end, 1.0, 'after')
            end
            if context.cardarea == G.jokers and context.joker_main or context.forcetrigger then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult) end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
