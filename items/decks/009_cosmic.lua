return {
    categories = {
        'Decks',
        'Cosma Tarots',
    },
    data = {
        object_type = "Back",
        key     = "cosmic",
        atlas   = 'decks',
        pos     = MLIB.coords(2,1),
        config = { 
            vouchers = { 'v_rgmc_cosma_merchant' }, 
            consumables = { 'c_rgmc_demise' } 
        },
        loc_vars = function(self, info_queue, back)
            return {
                vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
                localize { type = 'name_text', key = self.confiG.consumeables[1], set = 'CosmaTarot' }
                }
            }
        end,
        apply = function(self, back)
            Madcap.Funcs.init_deck('cosmic')
        end,
    }
}
