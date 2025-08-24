return {
    categories = {
        'Seals',
        'Cosma Tarots'
    },
    data = {
        object_type = "Seal",
        key = "seafoam",
        atlas = 'seals',
        pos = MLIB.coords(1,2),
        badge_colour = HEX("5CC497"),
        config = { extra = { odds = 2 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, self.config.extra.odds, 'seafoam_seal')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                context.discard
                and context.other_card == card
                and SMODS.pseudorandom_probability(card, 'seafoam_seal', 1, card.ability.extra.odds)
            then
                local new_card = (not SMODS.pseudorandom_probability(card, 'seafoam', 1, card.ability.extra.odds))
                    and MadLib.get_random_card("CosmaTarot")
                    or MadLib.get_random_card("CosmaTarot")
                new_card:add_to_deck()
                table.insert(G.consumeables, new_card)
                G.consumeables:emplace(new_card)
                tell("Seafoam Seal activated!")
            end
        end,
    }
}
