return {
    categories = {
        'Tags',
    },
    data = {
        object_type = "Tag",
        key     = "exchange",
        atlas   = "tags",
        pos     = MLIB.coords(1,3),
        config  = { type 	= "immediate", extra 	= 1 },
        in_pool = function()
            return G.jokers and #G.jokers.cards > 0
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                -- Pseudo-sorted
                local joker_list = MadLib.get_sorted_list(MadLib.get_list_matches(G.jokers.cards, function(v)
                    return not v:is_invulnerable()
                end), function(a,b)
                    return MadLib.get_rarity_value(a.config.center.rarity) + math.random()*2 < MadLib.get_rarity_value(b.config.center.rarity)
                end)
                -- Destroy old jokers, make new jokers
                for i=1, #math.min(self.config.extra,joker_list) do
                    local target 		= joker_list[i]
                    local new_rarity 	= MadLib.get_higher_rarity(target.config.center.rarity)
                    target:start_dissolve({ G.C.RED }, nil, 1.6)
                    card = create_card("Joker", context.area, nil, "cry_epic", nil, nil, nil, "cry_eta")
                    local hittable = {
                        set = "Joker",
                        rarity = new_rarity
                    }
                    SMODS.add_card(hittable)
                end
            end
        end,
    }
}
