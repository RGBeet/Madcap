function Madcap.Funcs.microfiche_check(card)
    if not card then return false end
    local rank      = SMODS.Ranks[card.base.value]
    local nominal   = rank and rank.nominal or 3
    local irregular = MadLib.has_rank_in_list(MadLib.RankTypes.Irregular)
    return (not MadLib.has_rank_in_list(MadLib.RankTypes.Irregular)) and nominal < 2
end

return {
    categories = {
        'Small Ranks'
    },
    data = {
        object_type = "Joker",
        key     = 'microfiche',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,9),
        rarity  = 3,
        cost    = 8,
        config =  {
            extra = { x_mult = 1.0, xmult_mod  = 0.05 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.xmult_mod, card.ability.extra.x_mult)
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.play
                and context.individual
                and context.other_card
                and Madcap.Funcs.microfiche_check(context.other_card)
            then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.xmult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour  = G.C.MULT
                }
            end
            if (context.joker_main or context.forcetrigger) and card.ability.extra.x_mult > 1 then
                return {
                    xmult = card.ability.extra.x_mult,
                    card = card
                }
            end
        end,
        in_pool = function(self, args) -- At least one owned card has a nominal of less than 2
            return MadLib.list_matches_one(G.playing_cards, function(v)
                return Madcap.Funcs.microfiche_check(v)
            end)
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
