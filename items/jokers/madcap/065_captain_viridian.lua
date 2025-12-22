return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Joker",
        key     = 'captain_viridian',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,4),
        rarity  = 2,
        cost    = 8,
        config = {
            extra = { chips = 36, odds = 6 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars(card.ability.extra.chips, _numer, _denom)
        end,
        calculate = function(self, card, context)
            -- scaling
            if
                context.forcetrigger
                or (context.cardarea == G.play
                    and context.other_card
                    and SMODS.pseudorandom_probability(card, 'captain_viridian', 1, card.ability.extra.odds))
            then
                local _success = Madcap.Funcs.set_edition_flipped(context.other_card)
                if _success then return { message = localize("rgmc_flipped_ex"), card = card } end
            end

            if
                context.other_card
                and context.other_card.edition
                and context.other_card.edition.flipped
            then
                return { chips = card.ability.extra.chips }
            end
        end,
        demicoloncompat = true,
    }
}
