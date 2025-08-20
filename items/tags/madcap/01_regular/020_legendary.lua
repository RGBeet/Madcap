return {
    categories = {
        'Tags',
    },
    data = {
        object_type = "Tag",
        key     = "legendary",
        atlas   = "tags",
        pos     = MLIB.coords(1,4),
        config = { type = "store_joker_create", extra = 'Legendary' },
        apply = function(self, tag, context)
            Madcap.Funcs.do_rarity_tag(self, tag, context, { cost_fac = 0.25 })
        end
    }
}
