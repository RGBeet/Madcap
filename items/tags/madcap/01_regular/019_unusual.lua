return {
    categories = {
        'Tags',
        'Unusual',
    },
    data = {
        object_type = "Tag",
        key     = "unusual",
        atlas   = "tags",
        pos     = MLIB.coords(1,5),
        config = { type = "store_joker_create", extra = 'rgmc_unusual' },
        apply = function(self, tag, context)
            Madcap.Funcs.do_rarity_tag(self, tag, context, { cost_fac = 0.5 })
        end
    }
}
