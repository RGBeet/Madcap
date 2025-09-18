return {
    categories = {
        'Unreleased',
        'Suits' -- requires new suits to load
    },
    data = {
        object_type = "Joker",
        key     = 'green_thumb',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { suit = 'rgmc_blooms', dollars = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suit, 'suits_singular'),
                card.ability.extra.dollars,
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            if 
                (context.end_of_round 
                and context.game_over == false 
                and context.main_eval)
                and context.cardarea == G.hand
            then
                local blooms = 0
                MadLib.loop_func(G.hand.cards, function(v)
                    if not v:is_suit(card.ability.extra.suit) then return end
                    blooms = blooms + 1
                    MadLib.simple_event(function()
                        v:juice_up()
                        card:juice_up()
                        play_sound('chips1', 0.8+ (0.9 + 0.2*math.random())*0.2, 1)
                        return true
                    end, 0.25, 'before')
                end)
                return { dollars = card.ability.extra.dollars * blooms }
            end
        end,
        demicoloncompat = true,
    },
}
