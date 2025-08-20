return {
    categories = {
        'Tags',
        'Editions',
    },
    data = {
        object_type = "Tag",
        key     = "galactic",
        atlas   = "tags",
        pos     = MLIB.coords(3,3),
        in_pool = function() return Madcap.Data.devmode or G.GAME.round_resets.ante > 1 end,
        config  = { type = "store_joker_modify", edition = "e_rgmc_galactic" },
        loc_vars = get_simple_edition_locvar,
        apply   = function(self, tag, context) return Madcap.Funcs.activate_edition(self, tag, context) end
    }
}
