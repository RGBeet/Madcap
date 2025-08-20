return {
    data = {
        object_type = 'Blind',
        key     = 'grave',
        atlas   = "blinds",
        pos     = MLIB.coords(5),
        dollars = 6,
        boss_colour = HEX('73CC4E'),
        in_pool = function(self) return true end,
        calculate = function(self, blind, context)
            if context.discard and not G.GAME.blind.disabled and not context.repetition then
                MadLib.loop_func(G.hand.highlighted, function(v) SMODS.Stickers["rgmc_engraved"]:apply(v,true) end)
            end
        end,
    }
}
