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
            return blind_add_tag('rgmc_anti_boomerang') -- change to tag_rgmc_anti_investment
        end,
    }
}
