return {
    data = {
        object_type = "Joker",
        key     = 'crystal_cola',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,5),
        rarity  = 2,
        cost    = 4,
        config =  { extra = { tags = 1 } },
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.selling_self and not context.blueprint
            end
            if (context.selling_self and not context.blueprint) or context.forcetrigger then
                for i=1, card.ability.extra.tags do
                    MadLib.simple_event(function()
                        local tag = Tag("tag_rgmc_boomerang")
                        add_tag(tag)
                        play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
                        play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end, 0.1, 'after')
                end
            end
        end,
        eternal_compat = false, -- dependent on selling
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
