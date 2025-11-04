-- Give $3 if hand has 3+ unscored cards
return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'gutterball',
        atlas   = 'jokers',
        pos     = MLIB.coords(11,2),
        rarity  = 2,
        cost    = 6,
        config = {
            extra = { ranks = { '3', '6', '10' }, repetitions = 1 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1] or '3', 'ranks'),
                localize(card.ability.extra.ranks[2] or '6', 'ranks'),
                localize(card.ability.extra.ranks[3] or '10', 'ranks'),
                card.ability.extra.repetitions)
        end,
        calculate = function(self, card, context)

            if 
                context.other_card
                and context.scoring_hand
            then
                local pos = 0
                for i=1,#context.scoring_hand do
                    if context.scoring_hand[i] == context.other_card then
                        pos = i
                        break
                    end
                end
                if pos > 1 then
                    local target = context.scoring_hand[pos-1]
                    if MadLib.list_matches_one(card.ability.extra.ranks, function(v) 
                        return MadLib.is_rank(target, SMODS.Ranks[v].id)
                    end) then
                        return { repetitions = card.ability.extra.repetitions or 1 }
                    end
                end
            end
        end,
        demicoloncompat = true
    }
}
