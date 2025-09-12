return {
    categories = {
        'Tags',
    },
    data = {
        object_type = "Tag",
        key     = "legendary",
        atlas   = "tags",
        pos     = MLIB.coords(1,4),
        apply = function(self, tag, context)
            if context.type == 'store_joker_create' then
                local card = SMODS.create_card {
                    set = "Joker",
                    rarity = "Legendary",
                    area = context.area,
                    key_append = "Legendary"
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
