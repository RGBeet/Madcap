return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'heartbreaker',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,4),
        rarity  = 2,
        cost    = 9,
        config = {
            extra = { 
                suit        = 'Hearts', 
                mult        = 0,
                mult_mod    = 1,
                x_mult      = 1.5,
                active      = false
            },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult_mod),
                localize(card.ability.extra.suit, 'suits_singular'),
                localize(card.ability.extra.suit, 'suits_plural'),
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.mult),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            -- Held Hearts (scale up!)
            if 
                context.individual 
                and context.cardarea == G.hand 
                and not context.end_of_round
                and context.other_card:is_suit(card.ability.extra.suit or 'Hearts')
            then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_mod",
                        message_key = "a_mult",
                        message_colour = G.C.RED,
                    })
                end
            end
            -- Scored Hearts (break the scale!)
            if 
                context.individual 
                and context.cardarea == G.play
                and context.other_card:is_suit(card.ability.extra.suit or 'Hearts')
                and not context.other_card.debuff
            then
                if not card.ability.extra.active then
                    card.ability.extra.active = true
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Broken!", instant = true, sound = 'rgmc_destroy_planet' });
                end
                return { xmult = card.ability.extra.x_mult }
            end
            -- Main Mult stuff
            if context.joker_main or context.forcetrigger then
                return { mult = card.ability.extra.mult }
            end
            -- Reset if activated
            if context.after and card.ability.extra.active then
                card.ability.active     = false
                card.ability.extra.mult = 0
                return { 
                    message     = localize('k_reset'),
                    colour      = G.C.FILTER
                }
            end
        end,
        demicoloncompat = true
    }
}
