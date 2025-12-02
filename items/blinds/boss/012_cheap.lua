-- At end of blind, give Deficit AnTag (activates at end of next Boss Blind)
return {
    data = {
        object_type = 'Blind',
        key     = 'cheap',
        atlas   = "blinds",
        pos     = MLIB.coords(11),
        boss_colour = HEX('5CB572'),
        min_ante = 4,
        in_pool = function(self)
            return Madcap.Data.devmode
                or ((to_big(G.GAME.dollars - 20) > to_big(G.GAME.bankrupt_at))
                and (to_big(G.GAME.dollars) < to_big(20)))
        end,
        defeat = function(self, silent)
            MadLib.event({
                func = function()
                    add_tag(Tag('tag_rgmc_anti_investment'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            })
        end,
    }
}
