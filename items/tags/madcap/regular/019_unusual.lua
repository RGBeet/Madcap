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
        apply = function(self, tag, context)
            if context.type == 'store_joker_create' then
                local card = SMODS.create_card {
                    set = "Joker",
                    rarity = "rgmc_unusual",
                    area = context.area,
                    key_append = "rgmc_unusual"
                }
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.GREEN, function()
                    card:start_materialize()
                    card:set_cost()
                    return true
                end)
                tag.triggered = true
                return card
            end
        end
    }
}
