return {
    categories = {
        'Unfinished Content',
        'Enhancements'
    },
    data = {
        object_type = "Joker",
        key     = 'double_rainbow',
        atlas   = 'jokers',
        pos     = MLIB.coords(10,1),
        rarity  = 1,
        cost    = 6,
        config = { },
        loc_vars = function(self, info_queue, card)
        end,
        calculate = function(self, card, context)
            if 
                context.cardarea == G.play
                and G.GAME.current_round.hands_played == 0
                and (context.other_card and SMODS.has_enhancement(context.other_card, 'm_rgmc_bismuth'))
            then
                context.other_card.rgmc_coil = true
                local target = context.other_card
                local new_type, tries = nil, 0
                while (new_type ~= target.ability.immutable.sticker_type) and (tries < 100) do
                    new_type = pseudorandom_element(Madcap.Lists.Bismuth, pseudoseed('rgmc_bismuth'))
                end

                return {
                    message = localize('k_double_rainbow'),
                    colour = G.C.SECONDARY_SET.Enhanced,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        MadLib.simple_event(function()
                            target.ability.immutable.sticker_type = new_type
                            target.ability['rgmc_bismuth_'..new_type] = true
                            SMODS.Stickers['rgmc_bismuth_'..new_type]:apply(self,true)
                            return true
                        end, 0.5, 'after')
                    end
                }
            end
        end,
        in_pool = function(self, args) -- at least one glass card
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return SMODS.has_enhancement(v, 'm_rgmc_bismuth')
            end)
        end,
    }
}
