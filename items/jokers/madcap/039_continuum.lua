return {
    data = {
        object_type = "Joker",
        key     = 'continuum',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,8),
        rarity  = 2,
        cost    = 9,
        config =  {
            extra = { rank = '8', retrigger_cards = 1 },
            immutable = { current_position = 0 },
            active = false
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                localize(card.ability.extra.rank,'ranks'),
                number_format(card.ability.extra.retrigger_cards))
        end,
        -- no calculation here - mostly happens using lovely shenanigans
        demicoloncompat     = false, -- dont think you can demicolon this?
    }
}
