return {
    categories = {
        'Tags',
        'Editions'
    },
    data = {
        object_type = "Tag",
        key     = "rainbow",
        atlas   = "tags",
        pos     = MLIB.coords(0,4),
        config = { type = 'store_joker_modify' },
        in_pool = function()
            return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
        end,
        config = { type = "store_joker_modify", edition = "e_rgmc_iridescent" },
        loc_vars = function(self, info_queue, tag)
            info_queue[#info_queue + 1] = G.P_CENTERS[self.config.edition]
            return Madcap.BlankVar
        end,
        set_ability = function(self, tag)
            self.config.edition = MadLib.get_weighted_edition({
                'e_foil',
                'e_holo',
                'e_polychrome',
                'e_negative',
                'e_rgmc_iridescent',
                'e_rgmc_infernal',
                'e_rgmc_chrome',
                'e_rgmc_disco',
                'e_rgmc_galactic',
                'e_rgmc_abyssal',
                'e_rgmc_luxury',
            })
            tell(self.config.edition)
        end,
        apply = function(self, tag, context)
            return Madcap.Funcs.activate_edition(self, tag, context)
        end,
    }
}
