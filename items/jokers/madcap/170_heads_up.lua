return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'heads_up',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 9,
        config = { 
            extra = { 
                ranks = { '4', '7', 'rgmc_13' },
                x_numerator = 0.75
            } 
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(MadLib.round(card.ability.extra.x_numerator * (4/3), 2)),
                number_format(card.ability.extra.x_numerator),
                localize(card.ability.extra.ranks[1] or '4', 'ranks'),
                localize(card.ability.extra.ranks[3] or 'rgmc_13', 'ranks'),
                localize(card.ability.extra.ranks[2] or '7', 'ranks'))
        end,
        calculate = function(self, card, context)
            if context.mod_probability and not context.blueprint and not context.repetition then
                local x_numerator = 1
                MadLib.loop_func(G.hand and G.hand.cards or {}, function(v)
                    if 
                        MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[1] or '4'].id) 
                        or MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[3] or 'rgmc_13'].id) 
                    then
                        x_numerator = x_numerator * MadLib.round(card.ability.extra.x_numerator * (4/3), 2)
                    elseif MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[2] or '7'].id) then
                        x_numerator = x_numerator * card.ability.extra.x_numerator
                    end
                end)
                return { numerator = math.min(MadLib.round(context.numerator * x_numerator), context.denominator) }
            end
        end,
        demicoloncompat = false,
    },
}
