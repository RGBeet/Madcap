Madcap.BalutroList = {
    'Ace',
    '2',
    '5',
    MadLib.RankIds['1'],
    MadLib.RankIds['11'],
    MadLib.RankIds['12'],
    MadLib.RankIds['15'],
    MadLib.RankIds['21'],
    MadLib.RankIds['25']
}

return {
    data = {
        object_type = "Joker",
        key     = 'balutro',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,5),
        rarity  = 2,
        cost    = 8,
        config =  {
            extra = {  active = true, retriggers = 1 },
            immutable = { max_retriggers = 12 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult)
        end,
        calculate = function(self, card, context)
            if
                (context.forcetrigger
                and not card.ability.extra.active)
                or (context.before
                and context.scoring_hand
                and MadLib.list_matches_all(context.scoring_hand, function(v)
                    return MadLib.has_rank_in_list(v, Madcap.BalutroList)
                end))
            then
                card.ability.extra.active = true
                return {
                    message = localize("k_active_ex"),
                    colour = G.C.GREEN
                }
            end

            if
                card.ability.extra.active
                and context.repetition
                and context.other_card
            then
                return MadLib.get_retrigger_data(context.other_card, lenient_bignum(math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers)))
            end
        end,
        demicoloncompat = true,
    }
}
