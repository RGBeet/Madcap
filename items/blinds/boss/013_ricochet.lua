-- At end of blind, give Rebound AnTag (activates at start of next Blind)
return {
    data = {
        object_type = 'Blind',
        key     = 'ricochet',
        atlas   = "blinds",
        pos     = MLIB.coords(12),
        boss_colour = HEX('C17050'),
        min_ante = 2,
        in_pool = function(self) return true end,
        defeat = function(self, silent)
            MadLib.event({
                func = function()
                    add_tag(Tag('tag_rgmc_anti_boomerang'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            })
        end,
    }
}
