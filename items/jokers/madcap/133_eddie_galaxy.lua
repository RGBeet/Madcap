return {
    categories = {
        'Unfinished Content',
        'Subhands',
    },
    data = {
        object_type = "Joker",
        key     = 'eddie_galaxy',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 6,
        config = { },
        calculate = function(self, card, context)
            if context.before then
                local subhands = MadLib.get_subhands(context.scoring_hand)
                MadLib.loop_func(subhands, function(v)
                    Madcap.Funcs.level_up_subhand(card, v, false, 1)
                end)
                if #subhands > 0 then
                    return { message = "Eddie Galaxy!" }
                end
            end
        end,
        demicoloncompat = true,
    }
}
