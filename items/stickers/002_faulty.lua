
return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_faulty",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,1),
        badge_colour = HEX('902726'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(1), number_format(3), number_format(4))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and not card.debuff
            then
                if SMODS.pseudorandom_probability(card, 'faulty', 1, 3) then
                    card.faulty_trigger     = true
                    return { message = "!", colour = G.C.RED }
                elseif SMODS.pseudorandom_probability(card, 'faulty', 1, 4) then
                    card.faulty_retrigger   = true
                    return { message = "!", colour = G.C.GREEN }
                end
            end

            if
                context.other_card == card
                and card.faulty_retrigger
                and (not card.debuff
                and (context.repetition or (context.retrigger_joker_check and not context.retrigger_joker))
                or (context.main_scoring and context.cardarea == G.play))
            then
                return { repetitions = 1 }
            end

            if context.after and (card.faulty_trigger or card.faulty_retrigger) then
                card.faulty_trigger     = nil
                card.faulty_retrigger   = nil
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_faulty = true
        end,
    }
}
