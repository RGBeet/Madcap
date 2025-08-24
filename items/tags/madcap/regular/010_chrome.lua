return {
    categories = {
        'Tags',
        'Editions',
        'Score'
    },
    data = {
        object_type = "Tag",
        key     = "chrome",
        atlas   = "tags",
        pos     = MLIB.coords(2,4),
        in_pool = function() return Madcap.Data.devmode or G.GAME.round_resets.ante > 1 end,
        config  = { type = "store_joker_modify", edition = "e_rgmc_chrome" },
        loc_vars = get_simple_edition_locvar,
        apply   = function(self, tag, context) return Madcap.Funcs.activate_edition(self, tag, context) end
    }
}
