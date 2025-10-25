return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "twofer",
        atlas   = "tags",
        pos     = MLIB.coords(3,7),
        config  = { vouchers = 2 },
        loc_vars = function(self, info_queue, tag)
            return { vars = { tag.config.vouchers } }
        end,
        apply = function(self, tag, context)
            if context.type == 'voucher_add' then
                tag:yep('+', G.C.SECONDARY_SET.Voucher, function()
                    for i=1, tag.config.vouchers do
                        local voucher = SMODS.add_voucher_to_shop()
                        voucher.from_tag = true    
                    end
                    return true
                end)
                tag.triggered = true
            end
        end
    }
}
