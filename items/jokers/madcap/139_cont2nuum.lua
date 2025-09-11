function Madcap.Funcs.is_scoring_area(area)
	if area == G.play then return true end
    if next(SMODS.find_card('j_rgmc_cont2nuum')) then return area == G.hand end
    return false
end

function Madcap.Funcs.do_after_scoring_stuff()
    if next(SMODS.find_card('j_rgmc_cont2nuum')) then
        MadLib.loop_func(G.hand.cards, function(v)
            MadLib.simple_event(function()
                v.area:remove_from_highlighted(v)
                return true
            end, 0.05, 'after')
        end)
    end
end

return {
    categories = {
        'Unfinished Content',
    },
    data = {
        object_type = "Joker",
        key     = 'cont2nuum',
        atlas   = 'jokers',
        pos     = MLIB.coords(13,8),
        rarity  = 'rgmc_unusual',
        cost    = 15,
        demicoloncompat = false,
    }
}
