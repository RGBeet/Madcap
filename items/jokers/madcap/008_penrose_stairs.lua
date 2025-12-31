local calc_func = function (self, card, context)
    if context.joker_main then
        MadLib.flip_cards(MadLib.get_list_matches(G.play.cards, function(v)
            return (not v:is_rankless()) and SMODS.pseudorandom_probability(card, 'penrose_stairs', 1, card.ability.extra.odds)
        end), function(v)
            assert(SMODS.modify_rank(v, card.ability.extra.times))
        end)
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return MadLib.list_matches_one(G.play.cards, function(v)
                return not (v:is_rankless()) and SMODS.pseudorandom_probability(card, 'penrose_stairs', 1, card.ability.extra.odds)
            end)
        end
        if context.forcetrigger then -- add more cashout money
            MadLib.flip_cards(MadLib.get_list_matches(G.play.cards, function(v)
                return not v:is_rankless()
            end), function(v)
                assert(SMODS.modify_rank(v, card.ability.extra.times))
            end)
        end
        return calc_func_ref(self, card, context)
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'penrose_stairs',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,7),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { times = 1, odds = 6 },
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'penrose_stairs')
            return MadLib.collect_vars(_numer, _denom, card.ability.extra.times)
        end,
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
