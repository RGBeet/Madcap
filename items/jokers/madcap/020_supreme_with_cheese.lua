function Madcap.Funcs.eat_food_joker(card)
    MadLib.event({
        func = function()
            play_sound('tarot1')
            
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            
            MadLib.event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    card:remove()
                    return true
                end
            })
            return true
        end
    })
end

function Madcap.Funcs.food_joker_round_end(card)
    if not Madcap.Funcs.get_end_of_round(context) then return end
    card.ability.extra.rounds_remaining = card.ability.extra.rounds_remaining
        and lenient_bignum(card.ability.extra.rounds_remaining - 1)
        or 1

    if lenient_bignum(card.ability.extra.rounds_remaining) > 0 then
        return { message = { localize("rgmc_minus_round") }, colour = G.C.FILTER, }
    else
        Madcap.Funcs.eat_food_joker(card)
        return { message = { "!!" }, colour = G.C.RED, }
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'supreme_with_cheese',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,9),
        rarity  = 1,
        cost    = 6,
        eternal_compat      = false,
        perishable_compat   = false,
        config = {
            extra = { x_mult = 2, rounds_remaining = 8 },
            immutable = { max_rounds = 8 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.rounds_remaining),
                number_format(card.ability.extra.x_mult),
                { MadLib.get_warning_colour(card.ability.extra.rounds_remaining / card.ability.immutable.max_rounds) })
        end,
        calculate = function(self, card, context)
            if context.joker_main and G.GAME.current_round.hands_played == 0 then
                return { xmult = card.ability.extra.x_mult }
            end
            Madcap.Funcs.food_joker_round_end(card)
        end,
        demicoloncompat = true
    },
}
