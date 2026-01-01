function Madcap.Funcs.rhodochrosite_check(card, context)
    local suits = Madcap.Funcs.get_joker_suits(card, { "Diamonds", "Spades", "Clubs" })
    if context.other_card:is_suit(suits[1]) then
        local active = nil -- needs a diamond suit to activate
        for i=1,#context.scoring_hand do
            if context.scoring_hand[i] == context.other_card then
                break
            else
                active = (context.scoring_hand[i]:is_suit(suits[2]) and suits[2])
                    or (context.scoring_hand[i]:is_suit(suits[3]) and suits[3])
                if active then break; end
            end
        end
        if active == suits[2] then
            return { mult = card.ability.extra.mult, card = card }
        elseif active == suits[3] then
            return { chips = card.ability.extra.chips, card = card }
        end
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'rhodochrosite',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,2),
        rarity  = 3,
        cost    = 8,
        config =  {
            active = false,
            extra = { mult = 6, chips = 30, suits = { "Diamonds", "Spades", "Clubs" } }
        },
        loc_vars = function(self, info_queue, card)
            local suits = Madcap.Funcs.get_joker_suits(card, { "Diamonds", "Spades", "Clubs" })
            return MadLib.collect_vars_colours(
                localize(suits[1], 'suits_plural'),
                localize(suits[2], 'suits_plural'),
                localize(suits[3], 'suits_plural'),
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips),
            { G.C.SUITS[suits[1]], G.C.SUITS[suits[2]], G.C.SUITS[suits[3]] })
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return Madcap.Funcs.rhodochrosite_check(card, context)
            end
            if
                context.cardarea == G.play
                and context.other_card
                and not context.after
                and not context.before
                and not context.blueprint
            then
                local ret = Madcap.Funcs.rhodochrosite_check(card, context)
                if ret ~= nil then return ret end
            end
            if context.forcetrigger then
                return {
                    chips   = card.ability.extra.chips,
                    mult    = card.ability.extra.mult,
                    card    = card
                }
            end
        end,
        demicoloncompat = true,
        quasicoloncheck = true,
    }
}
