return {
    data = {
        object_type = 'Blind',
        key     = 'final_chimes',
        atlas   = "blinds",
        pos     = MLIB.coords(18),
        mult    = 1.25,
        dollars = 8,
        boss_colour = HEX('ABB3FF'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
                return v:get_id() == SMODS.Ranks[tostring(G.GAME.x_value)].id
            end) > 4 or Madcap.Data.devmode
        end,
        loc_vars = function(self, info_queue, card)
            return  MadLib.collect_vars(number_format(card.ability.extra.mult_increase), localize(string.lower("k_" .. SMODS.Rarities[self.config.immutable.min_rarity].key)))
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            if not G.GAME.blind.disabled then
                local _, _, _, scoring = G.FUNCS.get_poker_hand_info(cards)
                if next(find_joker('Splash')) then scoring = cards end
                return not MadLib.list_matches_one(scoring, function(v)
                    return MadLib.is_rank(v,SMODS.Ranks[G.GAME.x_value].id)
                end)
            end
        end
    }
}
