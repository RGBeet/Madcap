return {
    data = {
        object_type = "Joker",
        key     = 'six_shooter',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,1),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { rank = '6', odds = 6, chips = 0, chip_mod = 30, }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'six_shooter')
            return MadLib.collect_vars(
                    number_format(_numer),
                    number_format(_denom),
                    localize(card.ability.extra.rank, 'ranks'),
                    number_format(card.ability.extra.chip_mod),
                    number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            if -- build the chips
                context.cardarea == G.play
                and context.individual
                and context.other_card
                and not context.forcetrigger
            then
                if
                    MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id)
                    and SMODS.pseudorandom_probability(card, 'six_shooter', 1, card.ability.extra.odds)
                then
                    local target = context.other_card

                    MadLib.simple_event(function()
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                        play_sound(('tarot2'), 0.76, 0.4)
                        target:juice_up(0.3, 0.4)
                        return true
                    end, 0.1, 'immediate')

                    MadLib.simple_event(function()
                        target:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        return true
                    end, 0.3, 'after')

                    return MadLib.get_detailed_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
                end
            end
            if -- give the chips
                (context.joker_main or context.forcetrigger)
                and MadLib.is_positive(card.ability.extra.chips)
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    },
}
