return {
    data = {
        object_type = 'Blind',
        key     = 'bowler',
        atlas   = "blinds",
        pos     = MLIB.coords(31),
        min_ante = 3,
        boss_colour = HEX('427B85'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        calculate = function (self, blind, context)
            if not G.GAME.blind.disabled and context.after and #G.hand.cards > 0 then
                MadLib.loop_func(G.hand.cards, function(v,i)
                    if check_pattern_rank(MadLib.is_triangular, v) and i < #G.hand.cards then -- discard this card
                        local target = G.hand.cards[i+1]
                        print(target ~= nil)
                    end
                end)
            end
        end,
    }
}
