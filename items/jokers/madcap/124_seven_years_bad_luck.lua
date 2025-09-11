function Madcap.Funcs.sveerz_generate_pattern(card)
    card.ability.immutable.suit_pattern = {}
    local potential_cards = MadLib.shuffle_sort_list(G.playing_cards, card.ability.immutable.pattern_length, function(v)
        return not SMODS.has_no_suit(v)
    end) or {}
    local j = 1
    for i=1,card.immutable.pattern_length do
        card.ability.immutable.suit_pattern[i] = potential_cards[j].base.suit
        if j+1 < #potential_cards then j=j+1 end
    end
end

return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'seven_years_bad_luck',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,3),
        rarity  = 2,
        cost    = 6,
        config = {
            extra = { denominator = 0, denominator_mod = 0, ranks = { '4', MadLib.RankIds['13'] } }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.denominator_mod),
                localize(card.ability.extra.ranks[1] or '4', 'ranks'),
                localize(card.ability.extra.ranks[2] or MadLib.RankIds['13'], 'ranks'),
                number_format(card.ability.extra.denominator))
        end,
        in_pool = function(self, args) -- can play Dark subhands
            MadLib.loop_table(G.GAME.subhands, function(_,v)
                if v.enabled then return true end
            end)
            return false
        end,
        calculate = function(self, card, context)
            if 
                context.mod_probability 
                and not context.blueprint 
                and not context.repetition 
            then
                return { denominator = context.denominator + card.ability.denominator }
            end
            if context.remove_playing_cards and not context.blueprint then
                card.ability.denominator_mod = 0
                MadLib.loop_func(context.removed, function(v)
                    if not v.shattered then return end
                    card.ability.denominator_mod = card.ability.denominator_mod + (MadLib.list_matches_one(card.ability.extra.ranks, function(v2)
                        return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end) and 2 or 1)
                end)
                -- Add denominator mod
                if card.ability.denominator_mod > 0 then
                    SMODS.scale_card(card, {
                        ref_table   = card.ability.extra,
                        ref_value   = "denominator",
                        scalar_value = "denominator_mod",
                        scaling_message = {
                            message = "+" .. number_format(card.ability.card.ability.denominator_mod),
                            colour = G.C.GREEN
                        }
                    })
                end
            end
        end,
        demicoloncompat = false
    }
}
