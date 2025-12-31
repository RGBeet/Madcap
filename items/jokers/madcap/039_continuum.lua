local calc_func = nil

if Overloaded or Cryptid then
    calc_func = function(self, card, context)
        if context.checktrigger then -- Check
            return MadLib.joker_check_rank(context.other_card, card, '8')
        end
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'continuum',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,8),
        rarity  = 2,
        cost    = 9,
        config =  {
            extra = { rank = '8', retrigger_cards = 1 },
            immutable = { current_position = 0 },
            active = false
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                localize(card.ability.extra.rank,'ranks'),
                number_format(card.ability.extra.retrigger_cards))
        end,
        alter_scoring_order = function(self, card, scoring_hand, context)
            if
                #scoring_hand > 1
                and MadLib.joker_check_rank(context.other_card, card, '8')
            then -- 1 or more continuums
                local repeats = #SMODS.find_card('j_rgmc_continuum')
                local index, selection = 1, nil
                -- Score cards again until the original card is reached
                SMODS.score_card(card, context)
                while
                    index <= #scoring_hand   -- haven't gone through the whole thing
                do
                    selection = scoring_hand[index]
                    if selection == card and i == repeats then
                        break -- we're done here
                    end
                    SMODS.score_card(selection, context)
                    index = (selection == card) and (#scoring_hand + 1) or (index + 1)
                end
            end
        end,
        -- no calculation here - mostly happens using lovely shenanigans
        demicoloncompat     = false, -- dont think you can demicolon this?
        quasicoloncheck     = true
    }
}
