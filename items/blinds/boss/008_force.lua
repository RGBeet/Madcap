return {
    data = {
        object_type = 'Blind',
        key     = 'force',
        atlas   = "blinds",
        pos     = MLIB.coords(7),
        mult    = 1.5,
        dollars = 6,
        boss_colour = HEX('47848B'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
                return v.edition and v.edition.negative
            end) > 4 or Madcap.Data.devmode
        end,
        stay_flipped = function(self, area, card) return area == G.hand and (card.edition and card.edition.negative) end,
        calculate = function (self, blind, context)
            if context.end_of_round and G.GAME.modifiers.rgmc_force_awakened then
                G.GAME.modifiers.rgmc_force_awakened = false -- the force is dead
                G.GAME.modifiers.rgmc_force_chance = -1
            end
        end
    }
}
