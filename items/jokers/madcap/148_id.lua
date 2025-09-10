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
            return {
                vars = { card.ability.extra.powmult }
            }
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
            
            --At end of Boss Blind, destroy Joker to its left
		    if 
                context.end_of_round 
                and G.GAME.blind_on_deck == 'Boss' 
                and context.main_eval
                and G.jokers 
            then
                local position = 0
                for i=2, G.jokers.cards do
                    if G.jokers.cards[i] == card then 
                        position = i
                        break
                    end
                end
                if position ~= 0 then -- not leftmost joker, let's destroy the joker to the left
                    local sliced_card = G.jokers.cards[position-1]
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
                if Talisman then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.ExpMult, card, card.ability.extra.e_mult)
                else
                    return {
                        xmult = mult ^ (card.ability.extra.powmult - 1),
                        message = "^"..card.ability.extra.powmult.." Mult",
                        colour = G.C.DARK_EDITION
                    }
                end
            end
        end,       
        remove_from_deck = function(self, card, from_debuff)
            G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit + card.ability.immutable.penalty)
        end,
        demicoloncompat = true,
    }
}
