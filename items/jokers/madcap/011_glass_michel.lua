return {
    data = {
        object_type = "Joker",
        key     = 'glass_michel',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,0),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { odds = 6 }
        },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_CENTERS.m_glass)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'glass_michel')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context) -- also keeps glass cards safe

            if
                context.repetition
                and context.cardarea == G.play
                and (SMODS.has_enhancement(context.other_card, 'm_glass')
                    or context.forcetrigger)
            then
                context.other_card.ability.glass_michel = true
                return MadLib.get_retrigger_data(card,1)
            end

            -- End of round stuff
            if Madcap.Funcs.banana_context(context) then
                -- Reset the cards
                for _, v in pairs(G.playing_cards) do
                    if v.ability.glass_michel then v.ability.glass_michel = nil end
                end

                return SMODS.pseudorandom_probability(card, 'glass_michel', 1, card.ability.extra.odds)
                    and MadLib.banana_remove(card)
                    or MadLib.get_safe_data(card)
            end
        end,
        perishable_compat   = false,
        demicoloncompat     = true,
    },
}
