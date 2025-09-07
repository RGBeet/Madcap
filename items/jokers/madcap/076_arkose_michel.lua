return {
    data = {
        object_type = "Joker",
        key     = 'arkose_michel',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,5),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = { odds = 8, mult = 10 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars(card.ability.extra.mult, number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if 
                (context.cardarea == G.play and context.other_card and SMODS.has_enhancement(context.other_card, 'm_stone')) 
                or context.forcetrigger 
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end
            if Madcap.Funcs.banana_context(context) then 
                return MadLib.banana_logic(card, 'arkose_michel') 
            end
        end,
        in_pool = function(self, args) -- at least one stone card
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return SMODS.has_enhancement(v, 'm_stone')
            end)
        end,
        eternal_compat = false,
        demicoloncompat = true,
    }
}
