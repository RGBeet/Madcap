return {
    data = {
        object_type = "Joker",
        key     = 'barbershop_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,8),
        rarity  = 1,
        cost    = 5,
        config =  {
            extra = { mult = 3, scored = false }
        },
        loc_vars = function(self, info_queue, card)
            local _suit = Madcap.Funcs.get_joker_suit(card, G.GAME.current_round
                and G.GAME.current_round.rgmc_barbershop
                and G.GAME.current_round.rgmc_barbershop.suit
                or 'Spades')
            if type(_suit) == 'string' then
                return MadLib.collect_vars_colours(localize(_suit, 'suits_singular'), number_format(card.ability.extra.mult), { G.C.SUITS[_suit] })
            else
                return Madcap.BlankVar
            end
        end,
        calculate = function(self, card, context)

            if
                (context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit(Madcap.Funcs.get_joker_suit(card, G.GAME.current_round.rgmc_barbershop.suit)))
                or context.forcetrigger
            then
                G.GAME.current_round.rgmc_barbershop.changed = false
                card.ability.extra.scored = true
                return { mult = card.ability.extra.mult }
            end

            if
                context.after
                and card.ability.extra.scored
                and not G.GAME.current_round.rgmc_barbershop.changed -- only switch it ONCE!
            then
                local data = G.GAME.current_round.rgmc_barbershop
                data.changed  = true
                data.index    = data.index + 1
                if data.index > #data.order then data.index = 1 end
                data.suit = data.order[data.index]
                card.ability.extra.scored = false
                return {
                    message = 'Two Bits!',
                    colour = G.C.YELLOW,
                    card = card
                }
            end
        end,
        in_pool = function(self, args) -- at least two different suits
            return MadLib.get_num_suits(G.playing_cards or {}) > 1
        end,
        demicoloncompat = true,
    },
}
