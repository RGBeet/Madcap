return {
    data = {
        object_type = 'Blind',
        key     = 'gyre',
        atlas   = "blinds",
        pos     = MLIB.coords(28),
        min_ante = 3,
        mult = 1.618,
        boss_colour = HEX('943534'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        calculate = function (self, blind, context)
            if 
                not G.GAME.blind.disabled 
                and context.other_card and MadLib.has_fib_rank(context.other_card) 
            then
                context.other_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
            end
        end
    }
}
