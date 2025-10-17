function MadLib.get_card_position(card,min,max)
    if not (card and card.area) then return nil end
    local right = #card.area.cards
    min = min or 1
    max = max or right
    for i=math.max(1, min), math.min(max, right) do
        if card.area.cards[i] == card then return i; end
    end
    return nil
end

return {
    categories = {
        'Unfinished Content',
        'Chaotic Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'id',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_chaotic',
        cost    = 50,
        config  = {
            extra = { powmult = 1.30 },
            immutable = { penalty = 0 }
        },
        loc_vars = function(self, info_queue, card)
            local position = (MadLib.get_card_position(card,2) or not MadLib.get_card_position(card)) and 'k_left_lc' or 'k_right_lc'
            return MadLib.collect_vars(number_format(card.ability.extra.powmult), localize(position))
        end,
        calculate = function(self, card, context)
            -- Playing a hand
            if 
                context.full_hand
			    and not context.blueprint
			    and not context.retrigger_joker 
            then
                local target = pseudorandom_element(context.full_hand, pseudoseed('id'))
                if context.destroy_card == target then
                    return { remove = true }
                end
            end
            
            --At end of Boss Blind, destroy Joker to its left (or right, if no Jokers on the left)
		    if 
                context.end_of_round 
                and G.GAME.blind_on_deck == 'Boss' 
                and context.main_eval
                and G.jokers 
            then
                local position = MadLib.get_card_position(card,2) or MadLib.get_card_position(card) or 0
                if position ~= 0 then -- not leftmost joker, let's destroy the joker to the left
                    local sliced_card = G.jokers.cards[position > 1 and (position - 1) or (position + 1)]
                    sliced_card.getting_sliced = true -- Make sure to do this on destruction effects
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    MadLib.event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    })
                    return {
                        message = "HATE!",
                        colour  = G.C.RED
                    }
                elseif G.jokers.config.card_limit > 1 then -- remove a joker slot
                    card.ability.immutable.penalty = card.ability.immutable.penalty + 1
		            G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit - 1)
                    return {
                        message = "-1",
                        colour  = G.C.RED
                    }
                else
                    -- ???
                end
            end
            
            -- The main part
            if context.joker_main or context.forcetrigger then
                return { emult = card.ability.extra.powmult, card = card }
            end
        end,       
        remove_from_deck = function(self, card, from_debuff)
            G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit + card.ability.immutable.penalty)
        end,
        demicoloncompat = true,
    }
}
