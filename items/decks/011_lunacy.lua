--[[
    Combines the following decks:
    ACTIVE:
    - Pale Deck         (1/4 of deck becomes Negative)
    - Jumble Deck       (Randomizes ranks and suits after defeating boss)
    - Capital Deck      (Going bankrupt, extra interest costing money to enter blinds/shops)
    - Cross Deck        (Cards debuffed after playing)
    - Anaglyph Deck     (Double Tag after defeating Boss Blind)

    PASSIVE:
    - Deck of Mayhem    (+8 Mayhem, Voids more common)
    - Sangria/Merlot    (Light and dark subhands automatically enabled)
    - Hexing/Abandoned  (Start with ranks 4-9 for all ten suits)
    - Micro Deck        (-1 Selection Size, X0.5 Blind Size)
    - Plasma Deck       (Chips and Mult are balanced, X2 Blind Size)
]]

return {
    categories = {
        'Decks',
        'Mayhem'
    },
    data = {
        object_type = "Back",
        key     = "lunacy",
        atlas   = 'deck_lunacy',
        pos     = MLIB.coords(0,0),
        config = {
            starting_suits      = { 'Hearts', 'Spades', 'Diamonds', 'Clubs', 'rgmc_goblets', 'rgmc_towers', 'rgmc_blooms', 'rgmc_daggers' },
            starting_ranks      = { '4', '5', '6', '7', '8', '9', 'rgmc_Madcap'},
            ante_scaling        = 3,
            spectral_rate       = 2,
            finisher_frequency  = 3,
            ante_win            = 10,
            hand_size           = 2,
            joker_slot          = 1,
            discards            = 1,
            dollars             = 10,
            vouchers = {
                'v_tarot_merchant',
                'v_planet_merchant',
                'v_overstock_norm',
                'v_crystal_ball',
                'v_telescope'
            },
            consumables = {
                'c_fool',
                'c_hex'
            }
        },
        loc_vars = function(self)
            return { vars = { self.config.mayhem, self.config.mayhem_scale, self.config.void_suit_spawn } }
        end,
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.finisher_frequency, self.config.ante_win)
        end,
        apply = function(self, back)
            G.GAME.modifiers.rgmc_deck          = true  -- music activated
            G.GAME.modifiers.rgmc_lunacy        = true
            G.GAME.rgmc_total_mayhem            = true
            G.GAME.starting_params.add_mayhem   = 10
        end,
        calculate = function(self, card, context)

            -- The Flint
            if context.modify_hand then
                mult        = math.max(math.floor(mult * 0.5 + 0.5), 1)
                hand_chips  = math.max(math.floor(hand_chips * 0.5 + 0.5), 0)
                update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
            end

            -- Anaglyph Deck
            if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
                MadLib.event({
                    func = function()
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end
                })
            end

            -- Plasma Deck
            if (context.final_scoring_step) then
                return { balance = true }
            end

            --Madcap.DeckFuncs['pale'].calculate(self, card, context)
            Madcap.DeckFuncs['cross'].calculate(self, card, context)
        end
    }
}
