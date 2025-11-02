return {
    categories = {
        'Decks',
        'Subhands',
        'Spatia Planets'
    },
    data = {
        object_type = "Back",
        key     = "spatial",
        atlas   = 'decks',
        pos     = MLIB.coords(2,2),
        config = {
            vouchers = { 
                'v_rgmc_bright_bulb',
                'v_rgmc_blacklight'
            }, 
        },
        loc_vars = function(self, info_queue, back)
            return {
                vars = { 
                    localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
                    localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' },
                }
            }
        end,
        apply = function(self, back)
            Madcap.Funcs.init_deck('spatial')
        end,
    }
}
