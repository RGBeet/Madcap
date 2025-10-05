return {
    data = {
        object_type = "Joker",
        key     = 'pogladontasaurus',
        atlas   = 'jokers',
        rarity  = 2,
        cost    = 6,
        pos     = MLIB.coords(7,0),
        config = {
            extra = { retriggers = 2, rank = "4", },
            immutable = { max_retriggers = 20, active = false }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers))
        end,
        calculate = function(self, card, context)
            -- do held hand shit
            if context.individual and context.cardarea == G.hand and context.other_card and not context.end_of_round then
                if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id) then
                    card.ability.immutable.active = true
                    return {
                        repetitions = math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers),
                        card = card
                    }
                end
            end
            -- pick new rank
            if  (context.after and card.ability.immutable.active) or (context.end_of_round and context.cardarea == G.jokers) or context.forcetrigger then
                local pick = MadLib.shuffle_sort_list(G.playing_cards, 1, function(v)  return true end)
                card.ability.immutable.active = false
                if pick then card.ability.extra.rank = pick[1].base.id end
                return { -- new rank
                    message = "!",
                    card    = card,
                    func    = function()
                        play_sound('rgmc_pogladontasaurus', 1, 0.5)
                        return true
                    end
                }
            end
        end,
        demicoloncompat = false, -- TODO: add later
    }
}
