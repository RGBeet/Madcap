function Madcap.Funcs.is_scoring_area(area)
	if area == G.play then return true end
    if next(SMODS.find_card('j_rgmc_cont2nuum')) then return area == G.hand end
    return false
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
