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
            return blind_add_tag('rgmc_anti_boomerang') -- change to tag_rgmc_anti_investment
        end,
    }
}
