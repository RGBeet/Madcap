local deck_text = {
    hexing = {
        "Start run with base suits",
        "plus {V:1}#1#{} and {V:2}#2#{}",
        "Removes ranks {C:attention}2{} through {C:attention}5"
    },
    two_suit = {
		"Start run with",
        "{C:attention}#3# {V:1}#1#",
		"and {C:attention}#3# {V:2}#2#",
        "in deck"
    },
    two_suit_dd = {
		"Converts all {C:rgmc_light}Light{} suits",
        "into {V:1}#1#",
		"and all {C:rgmc_dark}Dark{} suits",
        "into {V:2}#2#"
    },
    micro = {
		"{C:attention}#1#{} hand size",
		"{C:blue}#2#{} play limit",
		"{C:attention}X#3#{} blind size"
    },
    giga = {
		"{C:attention}+#1#{} hand size",
		"{C:blue}+#2#{} play limit",
		"{C:attention}X#3#{} blind size"
    },
    cosmic = {
		"Start with {C:cosmatarot,T:v_rgmc_cosma_merchant}#1#",
        "and {C:cosmatarot,T:c_rgmc_demise}#2#",
    },
    spatial = {
		"Start with {C:cosmatarot,T:v_rgmc_cosma_merchant}#1#",
        "and {C:cosmatarot,T:c_rgmc_demise}#2#",
    },
    beetroot = {
	    "{C:purple}Madcap{}-specific content appears",
        "{C:attention}3X{} more often",
        "{C:inactive,s:0.8}(Jokers, blinds, etc.)"
    },
    argentum = {
		"Start with {C:rgmc_luxury}£#1#{}",
        "Earn {C:rgmc_luxury}£#2#{} at",
        "end of Boss Blind"
    },
    fuchsia = {
	    "Start with {C:purple}+#1#{} temp hands",
        "and discards each",
        "Gain {C:purple}+#2#{} temp hand or discard",
        "upon {C:attention}rerolling{} in shop",
        "or {C:attention}skipping{} blind",
        "{C:blue}#3#{} hands, {C:red}#4#{} discards"
    },
    cross = {
	    "Scored cards are {C:attention}",
        "\"permanently\" debuffed{}",
		"Held cards at end of round",
        "are {C:green}reset{}",
		"{C:attention}+#1#{} hand size"
    },
    capital = {
        "Start with {C:money}$#1#{}",
		"{C:attention}Bosses{} reward {X:money,C:white}X#2#{} Money",
		"{C:attention}Blinds{} and {C:attention}Shops{}",
		"cost {C:money}$#3#{}/{C:money}$#4#{} to enter",
		"If you reach {C:red}$#5#{}, you {C:red}lose{}!"
    },
    communist = {
        "{C:money}Money{}? {C:attention}No{}, comrade.",
        "All items are {C:money}free{}, but greed",
        "is swiftly {C:attention}punished{}",
    }
}

-- add actual function later
local function concat_text(ct,list)
    local ret = MadLib.deep_copy(ct)
    MadLib.loop_func(text, function(v)
        ret[#ret+1] = v
    end)
    return ret
end

return {
	descriptions = {
		Mod = {
			Madcap = {
				name = "Madcap",
				text = {
					"My silly little mod.",
				}
			}
		},
        Back = {
			b_rgmc_hexing = {
				name = "Hexing Deck",
				text = deck_text.hexing
			},
			b_rgmc_sangria = {
				name = "Sangria Deck",
				text = deck_text.two_suit
			},
			b_rgmc_merlot = {
				name = "Merlot Deck",
				text = deck_text.two_suit
			},
			b_rgmc_micro = {
				name = "Micro Deck",
				text = deck_text.micro
			},
			b_rgmc_giga = {
				name = "Giga Deck",
				text = deck_text.giga
			},
			b_rgmc_cosmic = {
				name = "Cosmic Deck",
				text = deck_text.cosmic
			},
			b_rgmc_spatial = {
				name = "Spatial Deck",
				text = deck_text.spatial
			},
			b_rgmc_beetroot = {
				name = "Beetroot Deck",
				text = deck_text.beetroot
			},
			b_rgmc_argentum = {
				name = "Argentum Deck",
				text = deck_text.argentum
			},
			b_rgmc_fuchsia = {
				name = "Fuchsia Deck",
				text = deck_text.fuchsia
			},
			b_rgmc_lunacy = {
				name = "Deck of Lunacy",
				text = {
					"No words can describe the",
                    "madness contained within",
                    "the {C:rgmc_bismuth}Deck of Lunacy{}",
					"Combines most {C:attention}Vanilla{}",
                    "and {C:rgmc_madcap}Madcap{} mechanics{}",
				},
			},
			b_rgmc_cross = {
				name = "Cross Deck",
				text = deck_text.cross
			},
			b_rgmc_capital = {
				name = "Capital Deck",
				text = deck_text.capital
			},
			b_rgmc_communist = {
				name = "Communist Deck",
				text = deck_text.communist
			},
        },
        Edition = {
			e_rgmc_iridescent = {
				name = "Iridescent",
				text = {
					"Doubles {C:inactive}(most){} values",
                    "{C:inactive}(e.g. chips, mult, numerator)"
				},
			},
			e_rgmc_infernal = {
				name = "Infernal",
				text = {
					"{X:rgmc_xscore,C:white}X#1#{} Score",
                    "{C:rgmc_xscore}after{} end of scoring",
					"{C:green}#2# in #3#{} chance to",
					"burn up at",
                    "end of round",
                    "if {C:attention}triggered",
                    "during {C:attention}blind{}"
				},
			},
			e_rgmc_chrome = {
				name = "Chrome",
				text = {
					"{X:rgmc_xscore,C:white}X#1#{} Score"
				},
			},
			e_rgmc_disco= {
				name = "Disco",
				text = {
					"Gives either {C:chips}+#1#{} Chips,",
					"{C:mult}+#2#{} Mult, {X:mult,C:white}X#3#{} Mult,",
					"{C:money}$#4#{}, {X:rgmc_xscore,C:white}X#5#{} Score,",
					"or {C:rgmc_luxury}£#6#",
				},
			},
			e_rgmc_galactic = {
				name = "Galactic",
				text = {
					"Gives base {C:chips}Chips{} & {C:mult}Mult",
                    "of last {C:planet}last played poker hand",
                    "{C:inactive}(Currently {C:planet}#1#{C:inactive} -",
                    "{C:inactive}{C:chips}+#2#{C:inactive} Chips, {C:mult}+#3#{C:inactive} Mult)",
                    ""
				},
			},
			e_rgmc_luxury = {
				name = "Luxury",
				text = {
					"Upon {C:attention}trigger{}, gives",
					"#1# Luxury Point(s)",
					"for next {C:attention}shop{}",
					"Takes {C:money}$#2#{} at",
                    "end of round",
				},
			},
			e_rgmc_flipped= {
				name = "Flipped",
				text = {
					"{C:purple}+#1#{} Score",
					"Counts as a",
                    "{C:attention}Flipped{} card",
				},
			},
        },
        Blind = {
            bl_rgmc_keyhole = {
                name = "The Keyhole",
                text = {
                    "Playing a hidden Poker Hand",
                    "discards the hand"
                },
            },
            bl_rgmc_levy = {
                name = "The Levy",
                text = {
                    "Lose {C:money}$#1#{} per {C:attention}held card{}",
                    "at end of {C:attention}Blind"
                },
            },
            bl_rgmc_jest = {
                name = "The Jest",
                text = {
                    "If score exceeds #1#,",
                    "increase Ante by #2#"
                },
            },
            bl_rgmc_ladder = {
                name = "The Ladder",
                text = {
                    "X#1# requirement per",
					"Joker with #2#",
					"or higher rarity"
                },
            },
            bl_rgmc_bottle = {
                name = "The Bottle",
                text = {
                    "All Goblet cards",
                    "are debuffed",
                },
            },
            bl_rgmc_sword = {
                name = "The Sword",
                text = {
                    "All Tower cards",
                    "are debuffed",
                },
            },
            bl_rgmc_force = {
                name = "The Force",
                text = {
                    "Must not play #1#s",
                },
            },
            bl_rgmc_elevator = {
                name = "The Elevator",
                text = {
                    "Scored cards have a",
                    "{C:green}#1# in #2#{} chance",
                    "to increase in rank"
                },
            },
            bl_rgmc_grave = {
                name = "The Grave",
                text = {
                    "Discarded cards",
                    "become {C:attention}Engraved{}"
                },
            },
            bl_rgmc_sum = {
                name = "The Sum",
                text = {
                    "Blind equals sum of",
                    "previous blind requirements",
                    "this Ante"
                },
            },
            bl_rgmc_statue = {
                name = "The Statue",
                text = {
                    "Scored cards have a",
                    "{C:green}#1# in #2#{} chance",
                    "to become {C:rgmc_stone}Stone"
                },
            },
            bl_rgmc_cheap = {
                name = "The Cheap",
                text = {
                    "At end of {C:attention}Blind{},",
                    "gain a {C:red}Cheapskate Tag"
                },
            },
            bl_rgmc_ricochet = {
                name = "The Ricochet",
                text = {
                    "At end of {C:attention}Blind{},",
                    "gain a {C:red}Boomerang Tag"
                },
            },
            bl_rgmc_cut = {
                name = "The Cut",
                text = {
                    "If score exceeds #1#,",
                    "lose $#2# and halve chips"
                },
            },

            bl_rgmc_coil = {
                name = "The Coil",
                text = {
                    "Scored cards have a",
                    "#1# in #2# chance",
                    "to return to hand"
                },
            },
            bl_rgmc_halo = {
                name = "The Halo",
                text = {
                    "All Void cards",
                    "are debuffed",
                },
            },
            bl_rgmc_spiral = {
                name = "The Spiral",
                text = {
                    "All Lantern cards",
                    "are debuffed",
                },
            },
            bl_rgmc_axe = {
                name = "The Axe",
                text = {
                    "All Bloom cards",
                    "are debuffed",
                },
            },
            bl_rgmc_rust = {
                name = "The Rust",
                text = {
                    "All Dagger cards",
                    "are debuffed",
                },
            },
            bl_rgmc_carousel = {
                name = "The Carousel",
                text = {
                    "Pins and moves all",
                    "Jokers each hand"
                },
            },
            bl_rgmc_factor = {
                name = "The Factor",
                text = {
                    "All prime numbers",
                    "are debuffed"
                },
            },
            bl_rgmc_figure = {
                name = "The Figure",
                text = {
                    "Must play single",
                    "digit numbers"
                },
            },
            bl_rgmc_gyre = {
                name = "The Gyre",
                text = {
                    "All Fibonacci numbers",
                    "are debuffed"
                },
            },
            bl_rgmc_pendulum = {
                name = "The Pendulum",
                text = {
                    "One side is debuffed",
                    "after each hand played"
                },
            },
            bl_rgmc_slide = {
                name = "The Slide",
                text = {
                    "Ranks must be played",
                    "in descending order"
                },
            },
            bl_rgmc_bowler = {
                name = "The Bowler",
                text = {
                    "Held triangular numbers",
                    "discard the card",
                    "to their right"
                },
            },
            bl_rgmc_flip = {
                name = "The Flip",
                text = {
                    "Tempoarily swaps ranks",
                    "of drawn cards"
                },
            },
            bl_rgmc_switch = {
                name = "The Switch",
                text = {
                    "Tempoarily swaps suits",
                    "of drawn cards"
                },
            },
            bl_rgmc_half = { -- The Bisected
                name = "The Half",
                text = {
                    "X#1# hand size"
                },
            },
            bl_rgmc_gibbous = {
                name = "The Gibbous",
                text = {
                    "Must not play",
                    "Dark hands"
                },
            },
            bl_rgmc_crescent = {
                name = "The Crescent",
                text = {
                    "Must not play",
                    "Light hands"
                },
            },
            bl_rgmc_dull = {
                name = "The Dull",
                text = {
                    "Must not play",
                    "Sparkling hands"
                },
            },
            bl_rgmc_final_blindfold = {
                name = "Beige Blindfold",
                text = {
                    "Blind increased by {C:attention}X#1#{}",
                    "per skipped blind",
                },
            },
            bl_rgmc_final_hoop = {
                name = "Han Purple Hoop",
                text = {
                    "Must play at least",
                    "#1# suits",
                }
            },
            bl_rgmc_final_chimes = {
                name = "Wisteria Chimes",
                text = {
                    "Scoring hand must contain a #1#"
                }
            },
            bl_rgmc_final_pin = {
                name = "Periwinkle Pin",
                text = {
                    "Blind increased by {C:attention}X#1#{} per",
                    "{C:attention}#2#{} or better Joker",
                },
            },
            bl_rgmc_final_target = {
                name = "Tomato Target",
                text = {
                    "Score must fall within",
                    "X#1# of blind requirement"
                },
            },
            bl_rgmc_final_void = {
                name = "Midnight Void",
                text = {
                    "Must play at least one",
                    "Negative card",
                },
            },
            bl_rgmc_final_twins = {
                name = "Thistle Twins",
                text = {
                    "Playing Pairs is...",
                    "not reccomended"
                },
            },
            bl_rgmc_final_vino = {
                name = "Verdigris Vino",
                text = {
                    "#1# in #2# chance",
                    "held and discarded",
                    "cards become Vino Cards"
                },
            },
            bl_rgmc_final_claw = {
                name = "Amaranth Claw",
                text = {
                    "Must play #1# cards ",
                    "(+#2# selection size)"
                },
            },
            bl_rgmc_final_horn = {
                name = "Harvest Horn",
                text = {
                    "???"
                },
            },
            bl_rgmc_final_moon = {
                name = "Macchiato Moon",
                text = {
                    "???"
                },
            },
            bl_rgmc_final_gauntlet = {
                name = "Golden Gauntlet",
                text = {
                    "#1# / #2# Bosses Cleared"
                },
            },
            bl_rgmc_final_id = {
                name = "The Id",
                text = {
                    "#1# / #2# Bosses Cleared"
                },
            },
        },
        Joker = {
            j_rgmc_thorium_joker = {
                name = "Thorium Joker",
                text = {
                    "Scored cards of ranks {C:attention}2{}-{C:attention}9{}",
                    "have a {C:green}#1# in #2#{} chance",
                    "to {C:attention}change ranks{}",
                    "{C:inactive,s:0.7}(2~5, 3~8, 4~7, 6~9)"
                },
                quote = {
                    "Whoever made this look like a Jolly Joker",
                    "is a butt"
                }
            },
            j_rgmc_changing_had = {
                name = "Changing Had",
                text = {
                    "Retrigger {C:attention}#1#{} played",
                    "card used in scoring",
                    "{C:attention}#2#{} additional times",
                    "{C:inactive,s:0.7}(Position changes each hand)"
                },
            },
            j_rgmc_glass_michel = {
                name = "Glass Michel",
                text = {
                    "Scored {C:attention}Glass{} cards retrigger",
                    "without chance of breaking",
                    "{C:green}#1# in #2#{} chance this card is",
                    "destroyed at end of {C:attention}Blind{}",
                },
                quote = {
                    "I mean, it's one banana, Michel.",
                    "What could it cost? Ten dollars?"
                },
            },
            j_rgmc_sigma_joker = {
                name = "Sigma Joker",
                text = {
                    "Each {C:attention}Sum{} held in hand",
                    "gives {X:chips,C:white}X(Sum x #1#){} Chips",
                    "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive})",
                    "{C:inactive}(Updates with hand selection)",
                },
                quote = {
                    "It's chip to be square"
                },
            },
            j_rgmc_supreme_with_cheese = {
                name = "Supreme With Cheese",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for",
                    "{C:attention}first{} hand of round",
                    "{C:inactive}(#2# slices left)"
                }
            },
            j_rgmc_house_of_cards = {
                name = "House of Cards",
                    text = {
                    {
                        "Gains {C:chips}+#1#{} Chips per played hand",
                        "{C:green}#2# in #3#{} chance to {C:red}reset{}",
                        "at end of {C:attention}Blind",
                        "{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)"
                    },
                    {
                        "{C:red}Reset{} chance increases by",
                        "{C:attention}+#5#{} per used {C:red}discard{}"
                    }
                }
            },
            j_rgmc_cup_of_joeker = {
                name = "Cup O' Joeker",
                text = {
                    "If Blind is beaten",
                    "in {C:attention}first{} hand,",
                    "create a {C:attention}consumable{}",
                    "{C:inactive}(Must have room)"
                },
            },
            j_rgmc_venn_diagram = {
                name = "Venn Diagram",
                text = {
                    "Played cards with {C:attention}special{}",
                    "{C:attention}rank{} and {C:attention}suit{} give",
                    "{C:mult}+#1#{} Mult when scored"
                },
                quote = {
                    "I Depend on Joker"
                }
            },
            j_rgmc_cavalier = {
                name = "Cavalier",
                text = {
                    "Each {C:attention}#1#{} held in hand",
                    "gives {X:chips,C:white}X#2#{} Chips"
                },
            },
            j_rgmc_crystal_cola = {
                name = "Crystal Cola",
                text = {
                    "Sell this card to create a free",
                    "{C:attention}Boomerang Tag{}"
                },
            },
            j_rgmc_blindfold_joker = {
                name = "Blindfold Joker",
                text = {
                    "{X:mult,C:white}X#1#{} Mult against {C:attention}Boss{} Blinds",
                    "({C:inactive}Lose {X:mult,C:white}X#2#{C:inactive} Mult",
                    "{C:inactive}when {C:attention}Blind{C:inactive} is {C:attention}skipped)",
                    "{C:inactive}({C:attention}#3#{C:inactive})"
                },
            },
            j_rgmc_plentiful_ametrine = {
                name = "Plentiful Ametrine",
                text = {
                    "For each scored {V:1}#5#{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:mult}+#3#{} Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)"
                },
            },
            j_rgmc_toughened_shungite = {
                name = "Toughened Shungite",
                text = {
                    "For each scored {V:1}#5#{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:chips}+#3# Chips",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)"
                },
            },
            j_rgmc_jimbos_funeral = {
                name = "Jimbo's Funeral",
                text = {
                    "After playing {C:attention}final hand{},",
                    "convert remaining {C:red}discards{} to {C:blue}hands{}",
                    "{C:inactive}(Resets at end of Blind)"
                },
                quote = {
                    "Wearing all black for a reason",
                }
            },
            j_rgmc_quick_brown_fox = {
                name = "Quick Brown Fox",
                text = {
                    "Gains {C:chips}+#1#{} Chips",
                    "for every {C:attention}unique rank",
                    "played this Ante",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                },
                quote = {
                    "I Hate This Joker :("
                }
            },
            j_rgmc_penrose_stairs = {
                name = "Penrose Stairs",
                text = {
                    "Scored cards have a {C:green}#1# in #2#{} chance",
                    "to increase in rank {C:attention}#3#{} time(s)",
                    "{C:inactive}(e.g. 10 -> J)"
                },
            },
            j_rgmc_joker_squared = {
                name = "Joker Squared",
                text = {
                    "Scored {C:attention}square number{} ranks",
                    "give {C:mult}+#1#{} Mult",
                },
            },
            j_rgmc_iron_joker = {
                name = "Iron Joker",
                text = {
                    "Gives {C:chips}+#1#{} Chips for",
                    "each {C:attention}Ferrous Card{}",
                    "in your {C:attention}full deck",
                    "{C:inactive,s:0.9}(Currently {C:chips,s:0.9}+#2#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_tungsten_joker = {
                name = "Tungsten Joker",
                text = {
                    "Gives {C:mult}+#1#{} Mult for",
                    "each {C:attention}Wolfram Card{}",
                    "in your {C:attention}full deck",
                    "{C:inactive,s:0.9}(Currently {C:mult,s:0.9}+#2#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_jeweler_joker = {
                name = "Jeweler Joker",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult for",
                    "each {C:attention}Lustrous Card{}",
                    "in your {C:attention}full deck",
                    "{C:inactive,s:0.9}(Currently {C:white,X:mult,s:0.9}X#2#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_ball_breaker = {
                name = "Ball Breaker",
                text = {
                    "If played hand only contains",
                    "{C:attention}Aces{}, {C:attention}2s{}, {C:attention}3s{}, {C:attention}5s{}, and {C:attention}8s{},",
                    "gain {C:chips}+#1#{} Chips",
                    "{C:inactive,s:0.9}(Currently {C:chips,s:0.9}+#2#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_ball_breaker_extra = {
                name = "Ball Breaker",
                text = {
                    "If played hand only contains",
                    "{C:attention}Fibonacci sequence{} numbers,",
                    "gain {C:chips}+6{} Chips",
                    "{C:inactive,s:0.9}(Currently {C:chips,s:0.9}+#1#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_pretentious_joker = {
                name = "Pretentious Joker",
                text = {
                    'Played cards with',
                    '{V:1}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_deceitful_joker = {
                name = "Deceitful Joker",
                text = {
                    'Played cards with',
                    '{V:1}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_barbershop_joker = {
                name = "Barbershop Joker",
                text = {
                    'Played cards with',
                    '{V:1}#1#{} suit give',
                    '{C:mult}+#2#{} Mult when scored',
                    'Suit changes after',
                    'each trigger',
                },
            },
            j_rgmc_neighborhood_watch = {
                name = "Neighborhood Watch",
                text = {
                    "At end of Blind,",
                    "gain {C:money}$#1#{} for",
                    "every held {C:attention}#2#{} of {V:1}#3#{}",
                    "{C:inactive,s:0.7}(Rank and suit change each round)"
                },
                idea = {"Caligula"},
                quote = {
                    "It was very difficult to",
                    "put the sprite together"
                },
            },
            j_rgmc_la_jokeonde = {
                name = "La Jokeonde",
                text = {
                    "At end of Blind, apply random {C:dark_edition}edition",
                    "to {C:attention}#1#{} unscored card(s)",
                    "in {C:attention}winning{} hand",
                },
                idea = {"Caligula"},
            },
            j_rgmc_bluenana = {
                name = "Bluenana",
                text = {
                    "{X:chips,C:white}X#1#{} Chips",
                    "{C:green}#2# in #3#{} chance this card is",
                    "destroyed at end of {C:attention}round{}",
                },
            },
            j_rgmc_redd_dacca = {
                name = "Redd Dacca",
                text = {
                    "{X:rgmc_emult,C:white}^#1#{} Mult",
                    "{C:green}#2# in #3#{} chance this card is",
                    "destroyed at end of {C:attention}round{}",
                },
            },
            j_rgmc_spectator = {
                name = "Spectator",
                text = {
                    "{C:mult}+#1#{} Mult per",
                    "played {C:attention}non-scoring{} card",
                },
            },
            j_rgmc_pentagon = {
                name = "Pentagon",
                text = {
                    "Scored {C:attention}pentagonal number{} ranks",
                    "give {C:chips}+#1#{} Chips",
                    "{C:inactive}({C:attention}Queens{C:inactive} count as {C:attention}12{C:inactive})"
                },
            },
            j_rgmc_null_and_void = {
                name = "Null and Void",
                text = {
                    "Before scoring,",
                    "{C:rgmc_evil}debuffs{} the next {C:attention}#1#{} Joker(s)",
                    "to the right",
                },
            },
            j_rgmc_lady_liberty = {
                name = "Lady Liberty",
                text = {
                    "Upon playing first {C:attention}hand{},",
                    "apply a {C:rgmc_patina}Patina Seal{} to",
                    "{C:attention}first played card{}",
                },
            },
            j_rgmc_vari_seala = {
                name = "Vari-Seala",
                text = {
                    "Scoring cards with {C:attention}Seal{}",
                    "have a {C:green}#1# in #2#{} chance to",
                    "copy Seal to a {C:attention}random{} played card(s){}"
                },
            },
            j_rgmc_bball_pasta = {
                name = "B-Ball Pasta",
                text = {
                    "what",
                    "{C:green}#1# in #2#{} chance this {C:dark_edition}pasta",
                    "gains {C:chips}+#3#{} chips and {C:mult}+#4#{} mult",
                    "at end of {C:attention}blind{}",
                    "{C:inactive}(currently {C:chips}+#5#{} {C:inactive}chips and {C:mult}+#6#{} {C:inactive}mult)"
                },
            },
            j_rgmc_squeezy_cheeze = {
                name = "Squeezy Cheeze",
                text = {
                   "Gives {C:white,X:chips}X#1#{} Chips for",
                   "every {C:white,X:mult}X#2#{} Mult scored",
                   "{C:inactive,s:0.8}Disappears in {C:attention,s:0.8}#3# {C:inactive,s:0.7}round(s)"
                },
            },
            j_rgmc_three_trees = {
                name = "Three Trees",
                text = {
                    "If played hand contains",
                    "a {C:rgmc_light}Light{} suit, a {C:rgmc_dark}Dark{} suit,",
                    "and a {C:attention}modded suit{}, give {X:mult,C:white}X3{} Mult",
                    "{C:inactive,s:0.7}(Requires at least 3 suits)"
                },
            },
            j_rgmc_shovel_joker = {
                name = "Shovel Joker",
                text = {
                    "Scored {C:attention}Knights{} with {C:rgmc_dark}Dark{} suits",
                    "give {C:mult}X#1#{} Mult",
                    "{C:inactive,s:0.7}({C:clubs}Clubs{}, {C:spades}Spades{}, etc.)"
                },
            },
            j_rgmc_rhodochrosite = {
                name = "Rhodochrosite",
                text = {
                    "Scored {V:1}#1#{} give",
                    "{C:mult}+#4#{} Mult/{C:chips}+#5#{} Chips",
                    "if played after {V:2}#2#{}/{V:3}#3#{}"
                },
            },
            j_rgmc_waveworx = {
                name = "Waveworx",
                text = {
                    "First hand of round",
                    "counts as {C:attention}#1#",
                },
            },
            j_rgmc_miracle_pop = {
                name = "Miracle Pop",
                text = {
                    "Gains {C:chips}+#3#{}/{C:chips}+#4#{} Chips per",
                    "scored {V:1}#1#{}/{V:2}#2#{}",
                    "When {C:attention}sold, distribute {C:chips}#5#{} chips{}",
                    "among {C:attention}#6#{} cards in {C:attention}hand",
                    "{C:inactive}(or {C:chips}+#7#{} {C:inactive}bonus chips)"
                },
            },
            j_rgmc_doom_bunny = {
                name = "Doom Bunny",
                text = {
                    "Scored {C:attention}Wild{} cards copy",
                    "a {C:attention}random{} card from deck",
                    "(Copies rank, edition, and seal)"
                },
            },
            j_rgmc_rocket_keychain = {
                name = "Rocket Keychain",
                text = {
                    "Leveling up {C:attention}#1#{} gives {C:attention}#2#{} level(s)",
                    "to {C:attention}#3#",
                    "{C:inactive,s:0.7}(Changes each Blind)"
                },
            },
            j_rgmc_legend_rio = {
                name = "Rio",
                text = {
                    "{C:attention}Aces{} are considered {C:attention}#1#{}",
                    "Can count as either an",
                    "{C:attention}Ace{}, {C:attention}King{}, or {C:attention}Queen{}",
                    "depending on which appears the",
                    "{C:attention}least{} in full deck",
                    "{C:inactive}\"Let's ball.\""
                },
            },
            j_rgmc_legend_picky = {
                name = "Lemonade Picky",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "Increases by {X:attention,C:white}#2#%",
                    "per completed {C:attention}Ante{}",
                    "{C:inactive}\"Time waits for those who wait.\""
                },
            },
            j_rgmc_legend_foreman = {
                name = "Smokin Foreman",
                text = {
                    "Scored {C:attention}suits{} in the",
                    "{C:attention}first hand{} of round are",
                    "converted to {V:1}#1#{}",
                    "Gives {X:mult,C:white}X#2#{} Mult",
                    "per {C:attention}converted{} card",
                    "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive})"
                },
            },
            j_rgmc_legend_bobby = {
                name = "Bobby Khan",
                text = {
                    "{C:rgmc_evil}Destroys{} scored {C:attention}light{} suit cards",
                    "Base {C:chips}chips{} are split between",
                    "all {C:rgmc_dark}Dark{} suit cards",
                    "{V:1}#1#{} gain {X:chips,C:white}#2#X{} value"
                },
            },
            j_rgmc_legend_lollipop = {
                name = "Retro Lollipop",
                text = {
                    { 
                        "When {C:blue}Common{} Jokers",
                        "with no editions are destroyed,",
                        "create a {C:rgmc_mayhem}Mayhemized{} copy",
                        "with a {C:dark_edition}random edition{}"
                    },
                },
            },
            j_rgmc_twinkle_of_contagion = {
                name = "Twinkle of Contagion",
                text = {
                    "At start of Blind,",
                    "apply Twinkling and Polychrome",
                    "to 1 random card(s) in deck",
                    "Scored cards transfer",
                    "edition and sticker to",
                    "random card in hand",
                },
            },
            j_rgmc_conspiracy_wizard = {
                name = "Conspiracy Wizard",
                text = {
                    "Scored {C:attention}#3#s{} give {C:mult}+#1#{} Mult",
                    "Scored {C:attention}#4#{} give {C:chips}+#2#{} Chips"
                },
            },
            j_rgmc_continuum = {
                name = "Continuum",
                text = {
                    "First scored {C:attention}#1#{} retriggers",
                    "all previously scored cards"
                },
            },
            j_rgmc_six_shooter = {
                name = "Six Shooter",
                text = {
                    "{C:green}#1# in #2#{} chance for",
                    "each scored {C:attention}#3#{} to",
                    "get {C:rgmc_evil}shot{} and",
                    "give this {C:attention}Joker{} {C:chips}+#4#{} Chips}",
                    "{C:inactive}(Currently {C:chips}+#5#{C:inactive})"
                },
            },
            j_rgmc_easter_egg = {
                name = "Easter Egg",
                text = {
                    "{C:attention}Sell{} this Joker to",
                    "apply {C:attention}random edition(s){}",
                    "to {C:attention}#1#{} random card(s) in {C:attention}deck{}",
                    "{C:inactive,s:0.7}(Increases by {C:attention}#2# {C:inactive,s:0.7}upon winning Boss Blind)",
                },
            },
            j_rgmc_chinese_takeout = {
                name = "Chinese Takeout",
                text = {
                    "Provides a \"random {C:attention}treat{}\"",
                    "at start of Blind",
                    "{C:inactive,s:0.7}({}{C:red}#1#{}{C:inactive} rounds remaining)"
                },
            },
            j_rgmc_spam = {
                name = "SPAM!",
                text = {
                    {
                        "{C:rgmc_gimmick,E:1}+#1#{} #2#",
                        "{C:rgmc_gimmick,E:1}+#3#{} #4#",
                        "{C:green}#5# in #6#{} chance to get {C:attention}1337ened{}",
                        "at end of {C:attention}Blind{}! ONOS!1!"
                    },
                    {
                        "Did you know {C:attention}SPAM{} backwards",
                        "is {C:white,X:dark_edition}MAPS{}?"
                    }
                },
            },
            j_rgmc_lobster_thermidor = {
                name = "Lobster Thermidor A Crevette",
                text = {
                    {
                        "Gains {X:dark_edition,C:white,E:1}^#1#{} Score",
                        "per {C:attention}1337ened{} {C:rgmc_gimmick,E:1}Gimmick{} Joker",
                        "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive})",
                    },
                    {
                        "... And {C:rgmc_gimmick,E:1}SPAM!{}."
                    }
                },
            },
            j_rgmc_pogladontasaurus = {
                name = "Pogladontasaurus",
                text = {
                    "Retriggers held {C:attention}#1#{}s",
                    "{C:attention}#2#{} times",
                },
            },
            j_rgmc_joker_in_binary = {
                name = "Joker In Binary",
                text = {
                    "Played {C:attention}#1#{} and {C:attention}#2#{}",
                    "give {C:chips}+#3#{} Chips when scored",
                },
            },
            j_rgmc_captain_viridian = {
                name = "Captain Viridian",
                text = {
                    "{C:rgmc_flipped}Flipped{} cards give",
                    "{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance to {c:rgmc_flipped}Flip{}",
                    "{C:blue}scoring{}/{C:red}discarded{} cards on",
                    "{C:attention}first{} {C:blue}hand{} or {C:red}discard"
                },
            },
            j_rgmc_balutro = {
                name = "Balutro",
                text = {
                    "If all {C:attention}scored{} cards include",
                    "digits of {C:attention}1{}, {C:attention}2#{}, or {C:attention}5{}",
                    "retrigger {C:attention}scoring{} cards"
                },
            },
            j_rgmc_catch_the_clown = {
                name = "Catch the Clown",
                text = {
                    {
                        "Sends a Clown to hide among your cards",
                        "Catch this Clown and this Joker",
                        "gains {C:chips}+#1#{} Chips",
                        "If you fail to capture this Clown {C:attention}#2#{} times,",
                        "{C:red}destroy{} this card",
                        "{C:inactive}(Currently gives {C:chips}+#3#{C:inactive} Chips)"
                    },
                    {
                        "#4#"
                        --"I am {C:money}$400,000{} in {C:red}dept{} to {C:attention}Clown College{}",
                    }
                },
            },
            j_rgmc_all_star_joker = {
                name = "All-Star Joker",
                text = {
                   "If sum of scored ranks equals {C:attention}#1#{},",
                   "gain {C:money}$#2#{} at end of round",
                   "per {C:attention}Joker",
                   "{C:inactive}(Currently {C:money}$#3#{C:inactive})"
                },
            },
            j_rgmc_golden_house = {
                name = "The Golden House",
                text = {
                    {
                        "At start of Blind, destroy one random",
                        "{C:planet}Planet{} card, gaining the {C:chips}chips{} and {C:mult}mult{}",
                        "of its {C:attention}Poker Hand{}"
                    },
                    { "Currently gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult" }
                },
            },
            j_rgmc_primordial_joker = {
                name = "Primordial Joker",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "per {C:rgmc_mayhem}Mayhem Point{}",
                    "{C:inactive}(Currently {C:mult}+#2#{}{C:inactive})"
                },
            },
            j_rgmc_sticker_shock = {
                name = "Sticker Shock",
                text = {
                    "{C:chips}+#1#{} Chips per card with",
                    "\"bad {C:attention}Sticker{}\"",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                },
            },
            j_rgmc_nope_joker = {
                name = "nope.jkr",
                text = {
                    {
                        "Upon {C:blue}playing{} or {C:red}discarding:",
                        "{C:green}#1# in #2#{} chance to",
                        "gain +#3# {C:attention}temporary{} {C:blue}hands{} or {C:red}discards",
                        "{C:green}#1# in #2#{} chance for",
                        "-#3# {C:blue}hands{} or {C:red}discards"
                    }
                },
            },
            j_rgmc_bolstered_joker = {
                name = "Bolstered Joker",
                text = {
                    "{C:red}+#1#{} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_rgmc_fortified_joker = {
                name = "Fortified Joker",
                text = {
                    "{C:chips}+#1#{} Chips if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_rgmc_solar_eclipse = {
                name = "Solar Eclipse",
                text = {
                    "{X:chips,C:white}X#1#{} Chips if playing a",
                    "{C:rgmc_light}#2#{} hand",
                },
            },
            j_rgmc_lunar_eclipse = {
                name = "Lunar Eclipse",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if playing a",
                    "{C:rgmc_dark}#2#{} hand",
                },
            },
            j_rgmc_made_of_honor = {
                name = "Made of Honor",
                text = {
                    "Adds one {C:attention}Bismuth{} card",
                    "to the deck when",
                    "{C:attention}Blind{} is selected",
                },
            },
            j_rgmc_outrageous_joker = {
                name = "Outrageous Joker",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "if scoring hand contains",
                    "{C:attention}5{} unique {C:attention}enhancements",
                },
            },
            j_rgmc_flamboyant_joker = {
                name = "Flamboyant Joker",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "if scoring hand contains",
                    "{C:attention}5{} unique {C:attention}enhancements",
                },
            },
            j_rgmc_voracious_joker = {
                name = "Voracious Joker",
                text = {
                    'Played cards with',
                    '{V:1}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_arrogant_joker = {
                name = "Arrogant Joker",
                text = {
                    'Played cards with',
                    '{V:1}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_vibrant_tourmaline= {
                name = "Vibrant Tourmaline",
                text = {
                    "For each scored {V:1}#5#{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:money}$#3#",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently gives",
                    "{C:money}$#4#{C:inactive} at end of round)"
                },
            },
            j_rgmc_obsidian_blade = {
                name = "Obsidian Blade",
                text = {
                    "For each scored {V:1}#5#{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {X:mult,C:white}X#3#{} Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {X:mult,C:white}X#4# {C:inactive} Mult)"
                },
            },
            j_rgmc_jestrogen = {
                name = "Jestrogen",
                text = {
                    "If played hand contains a",
                    "{C:attention}#1#{} or {C:attention}#2#{},",
                    "{C:attention}retrigger{} all",
                    "scored #3#s {C:attention}#4#{} time(s)"
                },
            },
            j_rgmc_radioactive_chinese = {
                name = "Radioactive Chinese?!?",
                text = {
                    "Provides an \"{C:rgmc_unusual,E:1}awesome {C:attention}treat{}\"",
                    "at start of Blind",
                    "{C:green}#2# in #3#{} chance to obtain a",
                    "{C:attention}negative{} effect",
                    "{C:inactive,s:0.7}({}{C:red}#1#{}{C:inactive} rounds remaining)"
                },
            },
            j_rgmc_sanguine = {
                name = "Sanguine",
                text = {
                    "{X:mult,C:white}X#3#{} Mult",
                    "if hand contains both a scoring",
                    "{V:1}#1#{} and {V:2}#2#{}"
                },
            },
            j_rgmc_stonebound = {
                name = "Stonebound",
                text = {
                    "{C:chips}+#3#{} Chips",
                    "if hand contains both a scoring",
                    "{V:1}#1#{} and {V:2}#2#{}"
                },
            },
            j_rgmc_metallurgist = {
                name = "Metallurgist",
                text = {
                    "{C:attention}Retrigger{} most",
                    "{C:attention}metal{}-themed enhancements",
                    "{C:attention#1#{} time(s)}",
                    "{C:inactive}(Steel, Ferrous, Wolfram, etc.)"
                },
            },
            j_rgmc_cosmamancer = {
                name = "Cosmamancer",
                text = {
                    "Create a {C:cosma}Cosma{} card",
                    "when {C:attention}Blind{} is selected",
                    "{C:inactive}(Must have room)",
                },
            },
            j_rgmc_arkose_michel = {
                name = "Arkose Michel",
                text = {
                    "Scoring {C:attention}Stone{} cards",
                    "give {C:mult}+#1#{} Mult",
                    "{C:attention}before{} scoring",
                    "{C:green}#2# in #3#{} chance this card is",
                    "destroyed at end of {C:attention}round{}",
                },
            },
            j_rgmc_formation = {
                name = "The Formation",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "if played hand contains",
                    "a {C:attention}#2#"
                },
            },
            j_rgmc_penumbral = {
                name = "The Penumbral",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "if played hand is {C:rgmc_dark}Dark"
                },
            },
            j_rgmc_photovoltaic = {
                name = "The Photovoltaic",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "if played hand is {C:rgmc_light}Light"
                },
            },
            j_rgmc_variegated = {
                name = "The Variegated",
                text = {
                    "{X:chips,C:white}X#1#{} Chips",
                    "if played hand is {C:rgmc_bismuth}Prismatic"
                },
            },
            j_rgmc_palette = {
                name = "The Palette",
                text = {
                    "This Joker gives {X:chips,C:white}X#1#{} Chips",
                    "per unique {C:attention}enhancement",
                    "in played hand"
                },
            },
            j_rgmc_streemerz = {
                name = "Streemerz",
                text = {
                    {
                        "{C:dark_edition}Flipped{} cards",
                        "cannot be {C:attention}debuffed",
                        "nor {C:attention}destroyed",
                        "{C:green}#1# in #2#{} chance for",
                        "{C:red}discarded{} {C:rgmc_flipped}Flipped{} cards",
                        "to {C:attention}lose edition{}",
                        "{C:green}#1# in #3#{} chance for",
                        "{C:blue}played{} base edition cards",
                        "to become {C:dark_edition}Flipped{}",
                    },
                    { "\"Eureka Tary\"" }
                },
            },
            j_rgmc_microfiche = {
                name = "Microfiche",
                text = {
                    "This Joker gains {X:chips,C:white}X#1#{} Chips",
                    "for every scored rank under {C:attention}#3#{}",
					"{C:inactive,s:0.9}(Currently {X:chips,C:white}X#2#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_squash_keychain = {
                name = "Squash Keychain",
                text = {
                    "Using a base edition {C:tarot}#1#{}",
                    "creates a {C:dark_edition}Negative{} copy",
					"{C:inactive,s:0.9}(Upon triggering or",
                    "{C:inactive,s:0.9}defeating Boss Blind,",
                    "{C:inactive,s:0.9}change Tarot)",
                },
            },
            j_rgmc_jonster_cola = {
                name = "Jonster Cola",
                text = {
                    "Sell this card to {C:rgmc_unusual,E:1}duplicate{}",
                    "your {C:attention}highest scoring{} hand",
                    "played this {C:attetion}run{}",
                },
            },
            j_rgmc_xray_vision = {
                name = "X-Ray Vision",
                text = {
                    "When {C:attention}drawing{} cards,",
                    "{C:green}#1# in #2# chance to draw",
                    "the {C:rgmc_unusual,E:1}highest value{} card",
                    "in the remaining deck",
                    "{C:inactive,s:0.9}(Calculates enhancements,",
                    "{C:inactive,s:0.9}editions, seals, etc.)"
                },
            },
            j_rgmc_weighted_die = {
                name = "Weighted Die",
                text = {
                    "{C:green}#1# in #2# chance",
                    "for each {C:attention}card{} drawn to be",
                    "from {C:attention}bottom{} of the deck",
                },
            },
            j_rgmc_roshambo = {
                name = "Roshambo",
                text = {
                    "Before scoring,",
                    "{C:attention}#4#{}, {C:attention}#5#{}, and {C:attention}#6#{}",
                    "temporarily become",
                    "{C:attention}#1#{}, {C:attention}#2#{}, and {C:attention}#3#{}",
                    "if part of {C:attention}scoring hand"
                },
            },
            j_rgmc_lucky_troll_doll = {
                name = "Lucky Troll Doll",
                text = {
                    "Increases {C:rgmc_unusual,E:1}probabilities{}",
                    "of #1# Joker(s) to its right",
                    "by {C:attention}50%{} of base probability"
                },
            },
            j_rgmc_cat_planet = {
                name = "Cat Planet",
                text = {
                    "Using {C:planet}planets{}",
                    "give {C:rgmc_mayhem,E:1}Mayhem{}",
                },
            },
            j_rgmc_liberty_bell = {
                name = "Liberty Bell",
                text = {
                    "Upon playing first {C:red}Discard{},",
                    "apply a {C:rgmc_cuprum}Cuprum Seal{}",
                    "and {C:chips}+#1#{} permanent bonus chips",
                    "to {C:attention}first discarded card{}",
                },
            },
            j_rgmc_liberty_bell_alt = { -- 2+ cards
                name = "Liberty Bell",
                text = {
                    "Upon playing first {C:red}Discard{},",
                    "apply a {C:rgmc_cuprum}Cuprum Seal{}",
                    "and {C:chips}+#1#{} permanent bonus chips",
                    "to {C:attention}first #2# discarded cards{}",
                },
            },
            j_rgmc_chicken_jokey = {
                name = "Chicken Jokey!",
                text = {
                    "Every {C:attention}#1#{} Blinds, create a",
                    "{C:attention}Perishable Popcorn{C:inactive} (#2#/#1#)",
                    "{C:inactive}I... am Joker"
                },
            },
            j_rgmc_egglike_joker = {
                name = "Egglike Joker",
                text = {
                    "Every {C:attention}#1#{} Blinds, create an",
                    "{C:attention}Perishable Egg{C:inactive} (#2#/#1#)",
                    "{C:inactive}So much to do, so much to see!"
                },
            },
            j_rgmc_talking_bacteria_jim = {
                name = "Talking Bacteria Jim",
                text = {
                    "At start of blind, {C:green}#1# in #2#",
                    "chance to {C:attention}copy{} a card",
                    "{C:inactive}A rather annoying pest."
                },
            },
            j_rgmc_banana_split = {
                name = "Banana Split",
                text = {
                    "{X:red,C:white}X#1#{} Mult",
                    "{C:attention}before scoring",
                    "{C:green}#2# in #3#{} chance",
                    "this card is {C:attention}eaten",
                    "at end of {C:attention}round{C:inactive} (Yum!)",
                },
            },
            j_rgmc_double_rainbow = {
                name = "Double Rainbow",
                text = {
                    "On {C:attention}first poker hand,",
                    "scored {C:rgmc_bismuth}Bismuth{} cards",
                    "{C:attention}return{} to hand",
                    "with {C:rgmc_bismuth}new frame"
                },
            },
            j_rgmc_live_joker_reaction = {
                name = "Live Joker Reaction",
                text = {
                    "Earn {C:money}$#1#{} at",
                    "end of {C:attention}Boss Blind",
                    "If rank of {C:attention}scored cards{}",
                    "exceeds {C:attention}#2#{},",
                    "reduce payout by {C:money}$#3#"
                },
            },
            j_rgmc_mustard_joker = {
                name = "Mustard Joker",
                text = {
                    "Every {C:attention}4th{}",
                    "scoring card",
                    "permanently gains",
                    "{C:chips}+#1#{} chips",
                    "{C:inactive,s:0.8}(MUSTAAAAAARD!)"
                },
            },
            j_rgmc_cuica = {
                name = "Cuica",
                text = {
                    "This Joker Gains {C:chips}+#1#{} Chips",
                    "per scored {C:attention}#2#",
                    "Resets iff hand does {C:attention}not{}",
                    "contain a scoring {C:attention}#2#",
                    "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
                },
            },
            j_rgmc_triangle = {
                name = "Triangle",
                text = {
                    "Every {C:attention}3rd{} scored {C:attention}#1#",
                    "{C:attention}retriggers{} the",
                    "next scoring card {C:inactive}(#3#/3)"
                },
            },
            j_rgmc_toy_piano = {
                name = "Toy Piano",
                text = {
                    {
                        "Such {C:attention}giant steps{}",
                        "for a small piano {C:inactive}(#4#/#5# notes)",
                        "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
                    },
                    {
                        "Gains {C:chips}+#1#{} Chips per correct {C:attention}note{}",
                        "and {C:chips}+#2#{} Chips per {C:attention}completed{} set",
                        "{C:inactive}(Next Rank: {C:attention}#6#{C:inactive})"
                    }
                },
            },
            j_rgmc_lost = {
                name = "The Lost",
                text = {
                    "Upon preventing death,",
                    "{C:dark_edition}reset{} and {C:red}self-destruct{}",
                    "{C:inactive}(Currently {C:attention}#1# {C:inactive}???)"
                },
            },
            j_rgmc_found = {
                name = "The Found",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "on {C:attention}first{} and",
                    "{C:attention}last{} hands"
                },
            },
            j_rgmc_dino_cursor = {
                name = "Dinosaur Cursor",
                text = {
                    "{C:blue}+#1#{} play limit",
                    "{C:red}#2#{} discard limit"
                },
            },
            j_rgmc_hang_ten = {
                name = "Hang Ten",
                text = {
                    "Held {C:attention}#2#s{} give {C:mult}+#1#{} Mult",
                    "Held {C:attention}#4#s{} give {X:mult,C:white}X#3#{} Mult",
                },
            },
            j_rgmc_tune_task = {
                name = "Tune Task",
                text = {
                    "If placed in Joker Slot {C:attention}No.#1#{},",
                    "this Joker gives {C:purple}+#2#{} #3#",
                    "{C:inactive}(Slot and reward change",
                    "{C:inactive}upon trigger or new blind){}"
                },
            },
            j_rgmc_gutterball = {
                name = "Gutterball",
                text = {
                    "Scored {C:attention}#1#s{}, {C:attention}#2#s{}, and {C:attention}#3#s{}",
                    "{C:attention}retrigger{} the next scoring card",
                    "{C:attention}#4#{} time{C:inactive}(s)",
                    "{C:inactive,s:0.8}(Watch that Gutterball!)"
                },
            },
            j_rgmc_everything_bagel = {
                name = "Everything Bagel",
                text = {
                    "{C:chips}+#1#{} Chips per {C:attention}unique",
                    "suit/rank combination {C:attention}scored",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} - {V:1}#3#{C:inactive} bites left)"
                },
            },
            j_rgmc_squashy_grapes = {
                name = "Squashy Grapes",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "Lose {X:mult,C:white}X#2#{} Mult",
                    "per played hand"
                },
            },
            j_rgmc_rainbow_sherbert = {
                name = "Rainbow Sherbert",
                text = {
                    "This Joker cycles between",
                    "{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult,",
                    "{C:money}+$#3#{}, and {X:mult,C:white}X#4#{} Mult",
                    "Next hand will have {V:1}#6#",
                    "{C:inactive}({C:attention}#5#{C:inactive} tastes left)"
                },
            },
            j_rgmc_magical_die_of_judgement = {
                name = "Magical Die of Judgement",
                text = {
                    "Roll a {C:attention}D6{} with values",
                    "between {C:attention}#1#{} and {C:attention}#2#",
                    "{C:attention}+X#3#{} rolled value",
                    "{C:inactive}({C:mult}+#4#~#5#{C:inactive} Mult)"
                },
            },
            j_rgmc_whoopsie_doodles = {
                name = "Whoopsie Doodles!",
                text = {
                    "{s:0.8}There was a mixup at the",
                    "{C:blue,s:0.8}Mult{s:0.8} & {C:red,s:0.8}Chips{s:0.8} Factory!",
                    "{X:chips,C:white}X#1#{} Mult, {X:mult,C:white}X#2#{} Chips",
                    "{C:inactive}({V:1}#3#{C:inactive} bites left)"
                },
            },
            j_rgmc_bank_shot = {
                name = "Bank Shot",
                text = {
                    "If first hand of round is",
                    "a single {C:attention}rankless{} card,",
                    "{C:attention}retrigger{} next {C:attention}#1#{} cards",
                    "{C:inactive}(Currently has {V:1}#2#",
                    "{C:inactive}retriggers left)"
                },
            },
            j_rgmc_sveerz = {
                name = "Sveerz!",
                text = {
                    {
                        "Complete the suit pattern",
                        "without interruption and",
                        "this Joker gains {C:mult}+#1#{} Mult",
                        "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                    }, {
                        "{V:1}#3#",
                        "{V:2}#4#",
                        "{V:3}#5#",
                        "{V:4}#6#",
                    }
                }
            },
            j_rgmc_prog_rock = {
                name = "Prog Rock",
                text = {
                    "If scoring hand contains",
                    "a {C:attention}#1#{} followed by a {C:attention}#2#{},",
                    "retrigger the {C:attention}#2# {C:green}#3#{} times",
                    "{C:inactive,s:0.8}(Get it?)"
                },
            },
            j_rgmc_money_for_nothing = {
                name = "Money for Nothing",
                text = {
                    "If scoring hand contains",
                    "a {C:attention}#1#{} followed by a {C:attention}#2#{},",
                    "gain {C:money}$#3#",
                    "{C:inactive,s:0.8}(We gotta move",
                    "{C:inactive,s:0.8}these {C:rgmc_bismuth,s:0.8}color{C:inactive,s:0.8} TVs!)"
                },
            },
            j_rgmc_lazy_joker = {
                name = "Lazy Joker",
                text = {
                    "{C:attention}Subhands{} require",
                    "{C:attention}one less{} card",
                    "to complete"
                },
            },
            j_rgmc_seven_years_bad_luck = {
                name = "Seven Years Bad Luck",
                text = {
                    "This Joker gains",
                    "{C:green}+#1#{} Denominator",
                    "per {C:attention}shattered{} card",
                    "Shattered {C:attention}#2#s{} and {C:attention}#3#s{}",
                    "give {X:green,C:white}X2{} Denominator",
                    "{C:inactive}(Currently {C:green}+#4#{C:inactive} Denominator)"
                },
            },
            j_rgmc_heartbreaker = {
                name = "Heartbreaker",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "per held {V:1}#2#{} card",
                    "If a {V:1}#2#{} card is played,",
                    "scored {V:1}#3#{} give",
                    "{X:mult,C:white}X#4#{} Mult",
                    "and reset {C:mult}Mult{}",
                    "{C:inactive}(Currently {C:mult}+#5#{C:inactive} Mult)"
                },
            },
            j_rgmc_sarcophagus = {
                name = "Sarcophagus",
                text = {
                    "{C:attention}Pyramids{} can be made with",
                    "{C:attention}5{} or {C:attention}fewer cards"
                },
            },
            j_rgmc_raining_sevens = {
                name = "Raining Sevens",
                text = {
                    "Gain {C:green}+#1#{} Numerator",
                    "for every {C:attention}#2#{} scored {C:attention}#3#s{}",
                    "{C:green}-#4#{} Numerator when a",
                    "probability {C:attention}succeeds{}",
                    "{C:inactive}(Currently {C:green}+#5#{C:inactive} Numerator)"
                },
            },
            j_rgmc_jackpot = {
                name = "The Jackpot",
                text = {
                    "Held {C:attention}#1#s{} have a",
                    "{C:green}#2# in #3#{} chance to",
                    "give {C:rgmc_luxury}£#4#",
                    "Increase jackpot by {C:rgmc_luxury}£#5#",
                    "for every {C:attention}#6#{} failed rolls",
                    "{C:inactive}(#7#/#6# failed rolls)"
                },
            },
            j_rgmc_voidic_joker = {
                name = "Voidic Joker",
                text = {
                    'Played {V:1}#2#{} give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_pure_joker = {
                name = "Purified Joker",
                text = {
                    'Played {V:1}#2#{} give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_sterling_joker = {
                name = "Sterling Joker",
                text = {
                    "At end of {C:attention}Blind,",
                    "gain {C:rgmc_luxury}£#1#{} per",
                    "remaining {C:blue}hand"
                },
            },
            j_rgmc_faberge_egg = {
                name = "Fabergé Egg",
                text = {
                    "Gain {C:rgmc_luxury}£#1#{} of sell value",
                    "at end of {C:attention}Blind"
                },
            },
            j_rgmc_eddie_galaxy = {
                name = "Eddie Galaxy",
                text = {
                    "If played hand contains",
                    "any {C:attention}subhands{},",
                    "{C:green}upgrade{} level",
                    "of all subhands"
                },
            },
            j_rgmc_melvin_melvin = {
                name = "Melvin, Melvin!",
                text = {
                    "{C:green}Retrigger{} all scored, held,",
                    "and discarded {C:attention}#1#s{}",
                    "{C:attention}#2#{} time{C:inactive}(s)",
                },
            },
            j_rgmc_holystone = {
                name = "Holystone",
                text = {
                    "Held {V:1}#1#{} have a",
                    "{C:green}#2# in #3#{} chance",
                    "of {C:attention}removing{} a random",
                    "enhancement, edition,",
                    "or seal",
                    "Upon removal,",
                    "gain {X:mult,C:white}#4#{} Mult",
                    "and {C:rgmc_mayhem}#6# Mayhem",
                    "{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult)"
                },
            },
            j_rgmc_voidstone = {
                name = "Voidstone",
                text = {
                    "Held {V:1}#1#{} have a",
                    "{C:green}#2# in #3#{} chance",
                    "of {C:attention}adding{} a random",
                    "enhancement, edition,",
                    "or seal",
                    "Upon addition,",
                    "gain {C:rgmc_mayhem}+#4# Mayhem"
                },
            },
            j_rgmc_hammer_keychain = {
                name = "Hammer Keychain",
                text = {
                    "{C:attention}+#1#{} selection size",
                    "{C:attention}+#2#{} hand size",
                    "{C:blue}-#1#{} hand",
                    "{C:red}-#1#{} discard",
                },
            },
            j_rgmc_cont2nuum = {
                name = "Cont2nuum",
                text = {
                    "Held cards are",
                    "{C:rgmc_bismuth,E:2}counted as scoring{}"
                },
            },
            j_rgmc_outside_the_box = {
                name = "Thinking Outside The Box",
                text = {
                    "Jokers are triggered",
                    "with {C:attention}this Joker{} as the {C:rgmc_bismuth,E:1}first",
                    "and the Joker to its {C:attention}left{}",
                    "as the {C:attention}last",
                    "{C:inactive}(It wraps over!)"
                },
            },
            j_rgmc_big_fish = {
                name = "The Big Fish",
                text = {
                    "Rerolling {C:rgmc_bismuth,E:1}replenishes{} boosters",
                    "Shops always have",
                    "at least one {C:attention}Voucher{}",
                    "{C:rgmc_evil}+$#1#{} reroll cost"
                },
            },
            j_rgmc_action_replay = {
                name = "Action Replay",
                text = {
                    "When a card {C:attention}retriggers{},",
                    "this Joker has a",
                    "{C:green}#1# in #2#{} chance to",
                    "{C:attention}block{} and {C:attention}stockpile",
                    "said retrigger",
                    "{C:green}#1# in #3#{} chance to retrigger",
                    "{C:attention}rightmost{} scored card",
                    "{C:rgmc_bismuth,E:1}#4#{} times and {C:attention}reset{}"
                },
            },
            j_rgmc_happy_stick_joker = {
                name = "Happy Stick Joker",
                text = {
                    "{C:rgmc_mayhem}+#1#{} Mayhem",
                    "Shop items have a {C:green}#2# in #3#{} chance",
                    "to reroll into a {C:rgmc_bismuth,E:1}random item{}"
                },
            },
            j_rgmc_red_button = {
                name = "Red Button",
                text = {
                    "{C:inactive}I wonder what's this",
                    "{C:red}red{C:inactive} button do?",
                    "Sell this card to win {C:money}$#3#{}!",
                    "This is {C:red}NOT{} A {C:attention}JOKE{}!!",
                    "{C:green}#1# in #2#{} chance to",
                    "{C:rgmc_evil}nuke Norway{} instead..."
                },
            },
            j_rgmc_spam_and_sausage = {
                name = "SPAM! and Sausage",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:green}#2# in #3#{} chance to",
                    "{C:rgmc_gimmick}1337{} the {C:attention}sausage{}",
                    "{C:inactive}\"Daddy, would you like",
                    "{C:inactive}some sausage?\""
                },
            },
            j_rgmc_empty_can = {
                name = "Already Eaten SPAM!",
                text = {
                    "{C:mult}+#1#{} Mult for each",
                    "empty {C:attention}Joker{} slot",
                    "{s:0.8}Empty Can included",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                },
            },
            j_rgmc_jim_co_supply_crate = {
                name = "Jimm Co. Supply Crate",
                text = {
                    "Does absolutely {C:attention}nothing{}",
                    "When {C:attention}sold{},",
                    "{C:green}#1# in #2#{} chance to",
                    "...actually {C:rgmc_bismuth,E:1}do something{}?"
                },
            },
            j_rgmc_id = {
                name = "The Id",
                text = {
                    { 
                        "{X:rgmc_emult,C:white}^#1#{} Mult" 
                    },
                    { 
                        "Destroy a {C:attention}random{} card in",
                        "each {C:attention}played{} hand"
                    },
                    { 
                        "At end of {C:attention}Boss Blind{},",
                        "{C:rgmc_evil}destroy{} Joker to the #2#",
                        "If {C:red}no{} Joker is destroyed,",
                        "lose {C:dark_edition}-1{} Joker Slot" 
                    },
                },
            },
            j_rgmc_superego = {
                name = "The Superego",
                text = {
                    { 
                        "{X:rgmc_echips,C:white}^#1#{} Chips" 
                    },
                    { 
                        "Must play most {C:rgmc_bismuth}optimal{}",
                        "available Poker Hand (currently {C:attention}#2#{})"
                    },
                },
            },
            -- 151-200
            j_rgmc_happy_hour = {
                name = "Happy Hour",
                text = {
                    "Held {V:1}#1#",
                    "give {C:chips}+#2#{} Chips",
                    "Discarding {V:1}#1#",
                    "reduces value by {C:blue}-#3#",
                    "{C:inactive}(Revert to {C:blue}+#4#",
                    "{C:inactive}at start of Blind)"
                },
            },
            j_rgmc_point_and_click = {
                name = "Point and Click",
                text = {
                    "If {C:attention}first hand{} of round is",
                    "a single {V:1}#1#{}, destroy a",
                    "random {C:attention}held card"
                },
            },
            j_rgmc_green_thumb = {
                name = "Green Thumb",
                text = {
                    "At end of {C:attention}Blind{},",
                    "earn {C:money}$#1#{} for",
                    "every held {V:1}#2#{} card"
                },
            },
            j_rgmc_en_passant = {
                name = "En Passant",
                text = {
                    "If {C:attention}first hand{} of round is",
                    "a single {V:1}#1#{}, gain",
                    "{C:attention}+#2#{} hand size",
                    "for the round",
                    "{C:inactive}Currently {C:attention}+#3#{C:inactive} hand size)"
                },
            },
            j_rgmc_maple_donut = {
                name = "Maple Donut",
                text = {
                    "{X:green,C:white}X#1#{} Numerator",
                    "{C:inactive}(#2# bites left)"
                },
            },
            j_rgmc_commedia = {
                name = "Commedia",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Costs {C:money}$#2#{} to remove",
                },
            },
            j_rgmc_mulch = {
                name = "Mulch",
                text = {
                    "If played hand",
                    "contains {C:attention}5{} cards with",
                    "a high {C:attention}#1#",
                    "and a low {C:attention}#2#,",
                    "it is considered",
                    "a {C:attention}#3#"
                },
            },
            j_rgmc_cheese_manor = {
                name = "Cheese Manor",
                text = {
                    "Gives half the",
                    "{C:attention}base mult",
                    "of your {C:attention}last played",
                    "poker hand",
                    "{C:inactive}(Currently {C:attention}#1#",
                    "{C:inactive}and {C:mult}+#2# {C:inactive}Mult)"
                },
            },
            j_rgmc_klondike = {
                name = "Klondike",
                text = {
                    "Scoring cards with",
                    "{C:attention}money{} enhancements gain",
                    "{C:blue}+#1#{} permanent bonus chips",
                    "{C:green}#2# in #3#{} chance to",
                    "{C:attention}melt{} at end of blind"
                },
            },
            j_rgmc_numberjoker = {
                name = "Numberjoker",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "whenever a {C:attention}non-face{} card",
                    "is discarded",
                    "Resets after playing a hand",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Mult)"
                },
            },
            j_rgmc_daybreak = {
                name = "Daybreak",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if played hand",
                    "is {C:rgmc_light}Light{} or {C:attention}High{}",
                    "{X:mult,C:white}X#2#{} Mult if played hand",
                    "contain {C:attention}both{} subhands"
                },
            },
            j_rgmc_nightfall = {
                name = "Nightfall",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if played hand",
                    "is {C:rgmc_dark}Dark{} or {C:attention}Low{}",
                    "{X:mult,C:white}X#2#{} Mult if played hand",
                    "contain {C:attention}both{} subhands"
                },
            },
            j_rgmc_spider_solitaire = {
                name = "Spider Solitaire",
                text = {
                    "If played hand contains a",
                    "{C:attention}Straight{} with an",
                    "alternating {C:rgmc_light}Light{}/{C:rgmc_dark}Dark{} pattern,",
                    "it is considered a",
                    "{C:attention}Straight Flush"
                },
            },
            j_rgmc_aargon = {
                name = "Aargon",
                text = {
                    "Played {C:rgmc_bismuth}Bismuth{} cards",
                    "are considered the",
                    "{C:attention}rank{} and {C:attention}suit{} of",
                    "the card to its {C:attention}left"
                },
            },
            j_rgmc_brains_and_bronze = {
                name = "Brains and Bronze",
                text = {
                    "Retrigger {C:attention}scored{} cards",
                    "with {C:attention}Cuprum{} Seals", "{C:attention}#1#{} time(s)"
                },
            },
            j_rgmc_coke_a_coal = {
                name = "Coke-A-Coal",
                text = {
                    "Held {C:attention}Ferrous{} cards",
                    "give {X:mult,C:white}X#1#{} Mult",
                    "{C:green}#2# in #3#{} chance for",
                    "held {C:attention}Ferrous{} cards",
                    "to {C:red}not{} upgrade at",
                    "end of {C:attention}blind"
                },
            },
            j_rgmc_flunky = {
                name = "Flunky",
                text = {
                    "{X:rgmc_xscore,C:white}X#1#{} Score",
                    "if played hand is {C:attention}Low{}"
                },
            },
            j_rgmc_joker_noir = {
                name = "Joker Noir",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "if ranks of scoring cards",
                    "equal {C:attention}#2#{}",
                    "If ranks {C:attention}exceed{} #2#,",
                    "{C:rgmc_evil}destroy{} a random",
                    "{C:attention}card{} in deck"
                },
            },
            j_rgmc_jimbos_ultimatum = {
                name = "Jimbo's Ultimatum",
                text = {
                    "If {C:attention}first hand{} of round", "is a single card {C:rgmc_evil}destroy{} it",
                    "and {C:attention}create a new card",
                    "{C:green}#1# in #2#{} chance",
                    "this card has the {C:attention}highest{}",
                    "held rank",
                    "Otherwise, this card will have",
                    "the {C:attention}lowest{} held rank",
                    "{C:inactive}Have I truly become",
                    "{C:inactive}a monster?"
                },
            },
            j_rgmc_heads_up = {
                name = "Heads Up",
                text = {
                    "Held {C:attention}#1#s{} and {C:attention}#2#s{}",
                    "give {X:green,C:white}X#3#{} Numerator",
                    "Held {C:attention}#4#s{}",
                    "give {X:green,C:white}X#5#{} Numerator",
                },
            },
            j_rgmc_wario_de_mambo = {
                name = "Wario de Mambo",
                text = {
                    "Earn {C:rgmc_luxury}£#5#{} if",
                    "the following {C:attention}poker hands{}",
                    "are played {C:attention}in order{}:",
                    "{V:1}#1#{}, {V:2}#2#{},",
                    "{V:3}#3#{}, {V:4}#4#{}"
                },
            },
            j_rgmc_high_speed_steel = {
                name = "High Speed Steel",
                text = {
                    "Held {C:attention}Wolfram{} cards",
                    "give {X:chips,C:white}X#1#{} Chips",
                    "{C:green}#2# in #3#{} chance for",
                    "held {C:attention}Wolfram{} cards",
                    "to {C:red}not{} upgrade at",
                    "end of {C:attention}blind"
                },
            },
            j_rgmc_beyond = {
                name = "The Beyond",
                text = {
                    "{X:mult,C:white}#1#{} Mult",
                    "If played hand",
                    "contains a #2#",
                    "Otherwise, scored {C:attention}#3#s",
                    "give {C:mult}+#4#{} Mult"
                },
            },
            j_rgmc_big_cheese = {
                name = "The Big Cheese",
                text = {
                    "Earn {C:rgmc_luxury}£#1#{}",
                    "if played hand is {C:attention}Low{}"
                },
            },
            j_rgmc_calotype_joker = {
                name = "Calotype Joker",
                text = {
                    "Scored {C:attention}base edition{} cards",
                    "have a {C:green}#1# in #2#{} chance",
                    "to become {C:dark_edition}Negative{}"
                },
            },
            j_rgmc_oh_boy_beet_soup = {
                name = "Oh Boy! Beet Soup!",
                text = {
                    "If held hand",
                    "contains only {C:rgmc_light}Light{} suits,",
                    "this Joker gives {X:mult,C:white}#1#{} Mult",
                    "for every {C:attention}unique suit"

                },
            },
            j_rgmc_factor = {
                name = "FACTOR!!!",
                text = {
                    {"{C:attention}floor{} + {C:attention}sine{} * {C:attention}amplitude{} = {X:mult,C:white}X#1#{} Mult"},
                    {"{C:attention}R{} = {C:attention}#2#{} rounds",
                    "{C:attention}J{} = {C:attention}#3#{} Jokers",
                    "{C:attemtion}M{} = {C:attention}X#4#{} base Xmult",
                    "{C:attention}floor{} = {C:red}max{}(0, 1 - (J-1)/7)",
                    "{C:attention}sine{}  = ({C:red}sin{}((R-0.75) * 2*π/5) + 1)/2",
                    "amplitude = {C:red}max{}(0,(J*M) - F)"}
                },
            },
            j_rgmc_caesar_cipher = {
                name = "Caesar Cipher",
                text = {
                    "{C:attention}Rank{}-specific Jokers",
                    "have their {C:attention}target{} ranks",
                    "{C:attention,E:1}shifted{} up by {C:attention}#1#",
                    "{C:inactive}(e.g. {C:attention}2{C:inactive} -> {C:attention}#2#{C:inactive})"
                },
            },
            j_rgmc_empowerer = {
                name = "Empowered Joker",
                text = {
                    "Upon using a {C:potentiacrystal}Potentia Crystal{},",
                    "level up a random {C:attention}poker hand{}",
                    "{C:attention}#1#{} level{C:inactive}(s){} for every",
                    "{C:potentiacrystal}Potentia Crystal used this run",
                    "{C:inactive}(Currently {C:attention}+#2#{C:inactive} level(s))"
                },
            },
            j_rgmc_pumpkin_keychain = {
                name = "Pumpkin Keychain",
                text = {
                    "Using a base edition #1#",
                    "creates a {C:dark_edition}Negative{} copy",
					"{C:inactive,s:0.9}(Upon triggering or",
                    "{C:inactive,s:0.9}defeating Boss Blind,",
                    "{C:inactive,s:0.9}change Spectral)",
                },
            },
            j_rgmc_funeral_for_a_friend = {
                name = "Funeral For a Friend",
                text = {
                    {
                        "{X:mult,C:white}X#7#{} Mult"
                    },
                    {
                        "This Joker gains {X:mult,C:white}X#9#{} Mult",
                        "if a {C:attention}#8#{} of a",
                        "{C:attention}unique suit{} is destroyed",
                        "{C:inactive}({C:attention}#10#{C:inactive}/#11#)"
                    },
                    {
                        "Suits Played:",
                        "{V:1}#1#{}, {V:2}#2#{},",
                        "{V:3}#3#{}, {V:4}#4#{},",
                        "{V:5}#5#{}, {V:6}#6#{},"
                    }
                },
            },
            j_rgmc_love_lies_bleeding = {
                name = "Love Lies Bleeding",
                text = {
                    "If played hand contains",
                    "a scoring {C:attention}#1#{}, this Joker",
                    "gives {X:rgmc_emult,C:white}^0.01{} Mult per",
                    "held {V:1}#2#{} card"
                },
            },
            j_rgmc_glitch_in_the_system = {
                name = "Glitch in the System",
                text = {
                    "{C:rgmc_mayhem}+#1#{} Mayhem",
                    "{C:rgmc_bismuth,E:1}?!?{}"
                },
            },
            j_rgmc_utah_teapot = {
                name = "Utah Teapot",
                text = {
                    "If played hand is",
                    "a {C:planet}Pair{} of {C:attention}base-2{} numbers",
                    "{C:rgmc_evil}destroy{} both cards",
                    "and {C:attention}create{} a new card",
                    "with the {C:rgmc_bismuth,E:1}next base-2 rank",
                    "{C:inactive}(Will create {C:attention}#1#{C:inactive})"
                },
            },
            j_rgmc_simple_simon = {
                name = "Simple Simon",
                text = {
                    "After playing {C:attention}final hand{},",
                    "give {C:blue}+#1#{} hand{C:inactive}(s)",
                    "and {C:attention}#2#{} hand size",
                    "{C:inactive}(Currently {C:blue}+#3#{C:inactive} hands",
                    "{C:inactive}and {C:attention}#4#{C:inactive} hand size)"
                },
            },
            j_rgmc_mmmmmmm = {
                name = "MMMMMMM",
                text = {
                    "If {C:attention}first{} {C:blue}hand{} or {C:red}discard",
                    "contains a single {C:attention}face{} card",
                    "convert it to an {C:attention}#3#",
                    "with a random {C:attention}enhancement{} or {C:attention}seal"
                },
            },
            j_rgmc_apeiros = {
                name = "Apeiros",
                text = {
                    "Scored {C:rgmc_bismuth}#1#s{}",
                    "apply a random {C:attention}enhancement",
                    "to a {C:attention}random card{}",
                    "{C:attention}held{} in hand"
                },
            },
            j_rgmc_pandoras_potato = {
                name = "Pandora's Potato",
                text = {
                    "{C:green}+#2#{} Numerator",
                    "{E:1,C:rgmc_bismuth}?!?"
                },
            },
            j_rgmc_madlib = {
                name = "MadLib",
                text = {
                    "{C:attention}Spawned{} Jokers may",
                    "have {C:rgmc_bismuth}randomized{} values...",
                    "{C:inactive}(Get it?)"
                },
            },
            j_rgmc_mf_colour_fun = {
                name = "Colour Fun",
                text = {
                    "This Joker gains",
                    "{C:chips}+#1#{} Chips upon",
                    "using a {C:attention}#3#",
                    "{C:colour}Colour{} card",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                },
            },
            j_rgmc_mf_purpendicular = {
                name = "Purpendicular",
                text = {
                    "{C:attention}+#1#{} consumeable slot",
                    "Upon defeating {C:attention}Boss Blind{},",
                    "convert all held {C:tarot}Tarots{}",
                    "into their",
                    "{C:rotarot}45 Degree Rotated Tarot",
                    "counterpart"
                },
            },
            j_rgmc_mf_wenge_william = {
                name = "Wenge William",
                text = {
                    "{C:green}#1# in #2#{} chance",
                    "to convert a",
                    "random {C:colour}Colour{} card",
                    "into {C:wenge}Wenge{}"
                },
            },
            -- TOGA compat
            j_rgmc_toga_helpbook = {
                name = "Help Book",
                text = {
                    "On {C:attention}last{} hand of Blind,",
                    "convert a random {C:attention}held{} card",
                    "to {C:attention}#1#",
                    "{C:inactive,S:0.8}(Enhancement changes at",
                    "{C:inactive,S:0.8}end of {C:attention}Blind{C:inactive})"
                },
            },
            j_rgmc_toga_rubber_duck = {
                name = "Rubber Duck",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "If played hand scores fewer",
                    "than {C:purple}#3#{} points,",
                    "{C:inactive,S:0.8}(i.e. Score of last played hand)",
                    "Otherwise, lose {C:mult}#1#{} Mult",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_rgmc_toga_joker_311 = {
                name = "Joker 3.11",
                text = {
					"{C:attention}+#1#{} hand size",
					"{C:planet}+#3#{} level{C:inactive}(s){} to all {C:attention}poker hands{}",
					"{C:attention}#2#{} card selection limit",
                },
            },
            j_rgmc_toga_mute_joker = {
                name = "This Goes Hard On Mute",
                text = {
					"This Goes Hard On Mute",
                    "{C:inactive,s:0.8}(Currently {X:mult,C:white}X#1#{C:inactive,s:0.8} Mult)"
                },
            },
            j_rgmc_toga_aol = {
                name = "AOL",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "receive an {C:attention}Email",
					"Upon {C:attention}cashing out",
                    "{C:inactive,s:0.8}(Currently {C:attention,s:0.8}#3#{C:inactive,s:0.8} {C:red,s:0.8}unread{C:inactive,s:0.8} emails",
                    "{C:inactive,s:0.8}and {C:attention,s:0.8}#4#{C:inactive,s:0.8} {C:blue,s:0.8}read{C:inactive,s:0.8} emails)",
                },
            },
            -- Finity compat
            j_rgmc_finity_blindfold = {
                name = "Beige Blindfold",
                text = {
                    "Skipping a Blind creates",
                    "{C:attention}#1#{} additional copies",
                    "of skip Tag",
                    "Gains {C:attention}+#2#{} Tag(s) after",
                    "defeating {C:attention}Boss Blind{}",
                    "{C:inactive}(Resets upon skipping blind)",
                },
            },
            j_rgmc_finity_hoop = {
                name = "Han Purple Hoop",
                text = {
                    "{C:attention}Changes{} the {C:attention}suit{} of",
                    "a {C:attention}random{} scored card into",
                    "the {C:attention}least frequent{} suit",
                    "{C:inactive}(Currently #1#{C:inactive})",
                },
            },
            j_rgmc_finity_pin = {
                name = "Periwinkle Pin",
                text = {
                    "At start of Blind {C:green}reduce{}",
                    "requirements by {C:attention}#1#%{} per",
                    "{C:attention}#2#{} or better Joker",
                    "{C:inactive}(Currently #3#%{C:inactive})",
                },
            },
            
        },
        Enhanced = {
			m_rgmc_ferrous = {
				name = "Ferrous Card",
				text = {
                    "{C:chips}+#1#{} bonus chips",
                    "Gains {C:chips}+#2#{} Chips",
                    "if held in hand at",
                    "end of {C:attention}round{}",
				},
			},
			m_rgmc_wolfram = {
				name = "Wolfram Card",
				text = {
                    "{C:mult}+#1#{} bonus mult",
                    "Gains {C:mult}+#2#{} Mult",
                    "if held in hand at",
                    "end of {C:attention}round{}",
				},
			},
			m_rgmc_lustrous = {
				name = "Lustrous Card",
				text = {
                    "{X:mult,C:white}x#1#{} bonus mult",
                    "Gains {X:mult,C:white} X#2# {} Mult",
                    "if held in hand at",
                    "end of {C:attention}round{}",
				},
			},
			m_rgmc_vino = {
				name = "Vino Card",
				text = {
                    { "{X:rgmc_xscore,C:white}X#1#{} Score, no {C:attention}rank{} or {C:attention}suit{}",
                        "Always scores" },
                    { "When {C:orange}held{} in hand,",
                        "{C:green}#3# in #4#{} chance",
                        "to give {X:rgmc_xscore,C:white}X#2#{}" },
                    { "When {C:blue}played{} in {C:attention}winning{} hand,",
                        "convert to {C:rgmc_bismuth}Bismuth{} " },
                    { "Classified as an {C:rgmc_evil}Unhancement{}" }
				},
			},
			m_rgmc_dynamite = {
				name = "Dynamite Card",
				text = {
                    { "{X:rgmc_xscore,C:white}X#1#{} Score" },
                    { "When {C:blue}scored{} or {C:red}discarded{},",
                        "{C:green}#1# in #2# chance to {C:rgmc_evil}destroy{}",
                        "itself and any {C:attention}adjacent{} cards" },
                    { "Classified as an {C:rgmc_evil}Unhancement{}" }
				},
			},
			m_rgmc_bismuth = {
				name = "Bismuth Card",
				text = {
                    { "No {C:attention}rank{} or {C:attention}suit{}",
                    "Gains a {C:rgmc_bismuth}random power{}",
                    "upon entering hand" },
                    { "Comes in {C:red}Red{}, {C:gold}Gold{}, {C:green}Green{},",
                    "{C:blue}Blue{}, and {C:purple}Purple{}" }
				},
			},
			m_rgmc_lazurite = {
				name = "Lazurite Card",
				text = {
                    "When scored, scores {C:attention}again",
                    "using the {C:attention}rank{} and {C:attention}suit",
                    "of the card to its right"
				},
			},
			m_rgmc_deluxe = {
				name = "Deluxe Card",
				text = {
                    { "Earn {C:rgmc_luxury}£#1#{} when",
                    "this card is scored" },
                    { "Gains {C:rgmc_luxury}+£#2#{} if",
                    "held in hand at",
                    "end of {C:attention}round{}" },
				},
			},
			m_rgmc_plumbum = {
				name = "Plumbum Card",
				text = {
                    { "{X:mult,C:white}X#1#{} Mult" },
                    { "Always shuffled to {C:attention}back{} of deck",
                        "{C:inactive}The heaviest card..." },
				},
			},
			m_rgmc_aesthetic = {
				name = "Aesthetic Card",
				text = {
                    {
                        "{C:mult}+#1#{} Mult",
                        "Counts as an {C:attention}#2#",
                        "of its {C:rgmc_bismuth}own suit{}",
                        "{C:inactive}(So Retro!)"
                    },
                    {
                        "When included in {C:attention}scoring{} hand,",
                        "this card {C:attention}reduces{} the",
                        "minimum card requirement for",
                        "{C:rgmc_bismuth}all subhands{} by {C:attention}1{}",
                    }
				},
			},
            m_rgmc_boba_tea_card = {
                name = "Boba Tea Card",
                text = {
                    "{X:rgmc_xscore,C:white}X#1#{} Score",
                    "{C:attention}after{} scoring",
                }
            },
			m_rgmc_magnet = {
				name = "Magnet Card",
				text = {
                    "{C:chips}+#1#{} bonus chips",
                    "Gains {C:chips}+#2#{} chips",
                    "per winning {C:attention}hand level{}",
                    "if held in hand at",
                    "end of {C:attention}Blind{}",
                    "{C:inactive}(Will gain {C:chips}+#3#{C:inactive} chips){}",
                    "{C:inactive}Monus + Ferrrous{}"
				},
			},
			m_rgmc_signal = {
				name = "Signal Card",
				text = {
                    "{C:mult}+#1#{} bonus mult",
                    "Gains {C:mult}+#2#{} mult",
                    "per winning {C:attention}hand level{}",
                    "if held in hand at",
                    "end of {C:attention}Blind{}",
                    "{C:inactive}(Will gain {C:mult}+#3#{C:inactive} mult){}",
                    "{C:inactive}Cult + Wolfram{}"
				},
			},
			m_rgmc_crystaltine = {
				name = "Crystaltine Card",
				text = {
                    "{X:chips,C:white}x#1#{} bonus chips",
                    "Gains {X:chips,C:white} X#2# {} Chips",
                    "if held in hand at",
                    "end of {C:attention}round{}",
                    "{C:inactive}Teal + Lustrous{}"
				},
			},
        },
		Auxiliary = {
            ["c_rgmc_aux_goblets"] = {
				name = "Essence of Goblets",
				text = {
					"Add {V:1}#2#{} to",
					"{C:attention}#1#{} selected cards",
					"in your hand",
				},
			},
			["c_rgmc_aux_towers"] = {
				name = "Essence of Towers",
				text = {
					"Add {V:1}#2#{} to",
					"{C:attention}#1#{} selected cards",
					"in your hand",
				},
			},
            ["c_rgmc_aux_blooms"] = {
				name = "Essence of Blooms",
				text = {
					"Add {V:1}#2#{} to",
					"{C:attention}#1#{} selected cards",
					"in your hand",
				},
			},
			["c_rgmc_aux_daggers"] = {
				name = "Essence of Daggers",
				text = {
					"Add {V:1}#2#{} to",
					"{C:attention}#1#{} selected cards",
					"in your hand",
				},
			},
			["c_rgmc_aux_solution"] = {
				name = "Solution",
				text = {
                    "Select #1# cards",
                    "Randomly chooses 1 card from selection",
                    "Rank {C:attention}X{} now equals",
                    "the selected card's rank",
				},
			},
			["c_rgmc_aux_ethereal"] = {
				name = "Ethereal",
				text = {
                    "{C:green}+#1# voiding limit{}",
                    "for next {C:attention}Booster Pack{}"
				},
			},
			["c_rgmc_aux_fast_forward"] = {
				name = "Fast Forward",
				text = {
                    "Instantly activates held",
                    "{C:attention}Cine Cards{}",
                    "and converts #1# random cards",
                    "into {C:attention}Promo{} cards"
				},
			},
			["c_rgmc_aux_joviality"] = {
				name = "Joviality",
				text = {
					"???",
				},
			},
			["c_rgmc_aux_schematic"] = {
				name = "Schematic",
				text = {
					"???",
				},
			},
			["c_rgmc_aux_ponder"] = {
				name = "Ponder",
				text = {
					"???",
				},
			},
			["c_rgmc_aux_32"] = {
				name = "The Thirty-Two",
				text = {
					"???",
				},
			},
		},
        Planet = {
            c_rgmc_tatooine = {
                name = "Tatoiine",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_genosis = {
                name = "Genosis",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_jakku = {
                name = "Jakku",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_planet_exe = {
                name = "Planet.exe",
                text = {
                    "Gives {C:attention}most played{} hand",
                    "{X:mult,C:white}X#2#{} Mult and {X:chips,C:white}X#3#{} Chips",
                    "per {C:cry_code}Code{} Card executed{}",
                    "this Ante",
                    "{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} and {X:mult,C:white}X#5#{C:inactive})"
                },
            },
            c_rgmc_helios = {
                name = "Helios",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_lobster = {
                name = "Space Lobster",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_nowhere = {
                name = "Nowhere.",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_wormhole = {
                name = "Wormhole!",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_everywhere = {
                name = "Everywhere?!?",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
        },
        MiscRGMC = {
            c_rgmc_toga_mail = {
                name = "Mail",
                text = {
                    "{C:attention}+1{} consumable slot",
                    "Contains {C:attention}#1#{}"
                },
            }
        },
        SpatiaPlanet = {
            c_rgmc_rocket = {
                name = "Rocket Ship",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                    "This {C:orange}Ante{}'s {C:rgmc_unusual}Pick 5{} are:",
                    "{C:attention}#5#{} of {V:2}#6#{}, {C:attention}#7#{} of {V:3}#8#{}",
                    "{C:attention}#9#{} of {V:4}#10#{}, {C:attention}#11#{} of {V:5}#12#{}",
                    "and {C:attention}#13#{} of {V:6}#14#{}",
                },
            },
            c_rgmc_rigel = {
                name = "Rigel IV",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_aquaworld = {
                name = "Aquaworld",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_prometheus = {
                name = "Prometheus IX",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_tartarus = {
                name = "Tartarus II",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_varakkis = {
                name = "Varakkis",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#7#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#8#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_jurassika = {
                name = "Jurassika",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#7#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#8#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_globulos = {
                name = "Globulos",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_xykulix = {
                name = "Xykulix",
                text = {
                    {
                        "Levels up a {C:attention}random{} poker hand",
                        "of {C:attention}5{} cards {C:inactive}(or greater!)"
                    },
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#3#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#4#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_blue_moon = {
                name = "Blue Moon",
                text = {
                    "{S:0.8}({S:0.8,V:2}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2# {C:inactive}Sub-Hand{}",
                    "{X:mult,C:white}X#3#{} Mult and",
                    "{X:chips,C:white}X#4#{} Chips",
                },
            },
            c_rgmc_blood_moon = {
                name = "Blood Moon",
                text = {
                    "{S:0.8}({S:0.8,V:2}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2# {C:inactive}Sub-Hand{}",
                    "{X:mult,C:white}X#3#{} Mult and",
                    "{X:chips,C:white}X#4#{} Chips",
                },
            },
            c_rgmc_harvest_moon = {
                name = "Harvest Moon",
                text = {
                    "{S:0.8}({S:0.8,V:2}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2# {C:inactive}Sub-Hand{}",
                    "{X:mult,C:white}X#3#{} Mult and",
                    "{X:chips,C:white}X#4#{} Chips",
                },
            },
            c_rgmc_crescent_moon = {
                name = "Waxing Crescent",
                text = {
                    "{S:0.8}({S:0.8,V:2}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2# {C:inactive}Sub-Hand{}",
                    "{X:mult,C:white}X#3#{} Mult and",
                    "{X:chips,C:white}X#4#{} Chips",
                },
            },
            c_rgmc_gibbous_moon = {
                name = "Gibbous",
                text = {
                    "{S:0.8}({S:0.8,V:2}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2# {C:inactive}Sub-Hand{}",
                    "{X:mult,C:white}X#3#{} Mult and",
                    "{X:chips,C:white}X#4#{} Chips",
                },
            },
            c_rgmc_new_moon = {
                name = "Gibbous",
                text = {
                    "{S:0.8}({S:0.8,V:2}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2# {C:inactive}Sub-Hand{}",
                    "{X:mult,C:white}X#3#{} Mult and",
                    "{X:chips,C:white}X#4#{} Chips",
                },
            },
            c_rgmc_terra = {
                name = "Terra",
                text = {
                    "Gives {C:attention}most played{} hand",
                    "{C:inactive}(Currently {C:attention,E:1}#1#{}{C:inactive})",
                    "{X:mult,C:white}X#2#{} Mult and {X:chips,C:white}X#3#{} Chips",
                    "per {C:tarot}Tarot{} Card used{}",
                    "this Ante",
                    "{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} and {X:mult,C:white}X#5#{C:inactive})"
                },
            },
            c_rgmc_luna = {
                name = "Luna",
                text = {
                    "Gives {C:attention}most played{} hand",
                    "{C:inactive}(Currently {C:attention,E:1}#1#{}{C:inactive})",
                    "{X:mult,C:white}X#2#{} Mult and {X:chips,C:white}X#3#{} Chips",
                    "per {C:spectral}Spectral{} Card used{}",
                    "this Ante",
                    "{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} and {X:mult,C:white}X#5#{C:inactive})"
                },
            },
            c_rgmc_pagoon = {
                name = "Pagoon",
                text = {
                    "Gives {C:attention}most played{} hand",
                    "{C:inactive}(Currently {C:attention,E:1}#1#{}{C:inactive})",
                    "{X:mult,C:white}X#2#{} Mult and {X:chips,C:white}X#3#{} Chips",
                    "per {C:cosmatarot}Cosma{} Tarot used{}",
                    "this Ante",
                    "{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} and {X:mult,C:white}X#5#{C:inactive})"
                },
            },
        },
        PotentiaCrystal = {
            c_rgmc_enori = {
                name = "Enori Crystal",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{}{S:0.8,C:rgmc_potentiacrystal}#2#{}{S:0.8}){} Empower",
                    "{C:attention}#3# {C:inactive}Sub-Hand{}",
					"{C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
            c_rgmc_voide = {
                name = "Voide Crystal",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{}{S:0.8,C:rgmc_potentiacrystal}#2#{}{S:0.8}){} Empower",
                    "{C:attention}#3# {C:inactive}Sub-Hand{}",
					"{C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
            c_rgmc_palis = {
                name = "Palis Crystal",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{}{S:0.8,C:rgmc_potentiacrystal}#2#{}{S:0.8}){} Empower",
                    "{C:attention}#3# {C:inactive}Sub-Hand{}",
					"{C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
            c_rgmc_restonia = {
                name = "Restonia Crystal",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{}{S:0.8,C:rgmc_potentiacrystal}#2#{}{S:0.8}){} Empower",
                    "{C:attention}#3# {C:inactive}Sub-Hand{}",
					"{C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
            c_rgmc_diamatine = {
                name = "Diamatine Crystal",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{}{S:0.8,C:rgmc_potentiacrystal}#2#{}{S:0.8}){} Empower",
                    "{C:attention}#3# {C:inactive}Sub-Hand{}",
					"{C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
            c_rgmc_emeradic = {
                name = "Emeradic Crystal",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{}{S:0.8,C:rgmc_potentiacrystal}#2#{}{S:0.8}){} Empower",
                    "{C:attention}#3# {C:inactive}Sub-Hand{}",
					"{C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
            c_rgmc_elevatium = {
                name = "Elevatium",
                text = {
                    "Empower every",
                    "{C:legendary,E:1}subhand",
					"by {C:rgmc_potentiacrystal,E:1}+#4#{} Atomic Power"
                },
            },
        },
		Sleeve = {
			sleeve_rgmc_hexing_sleeve = {
				name = "Hexing Sleeve",
				text = deck_text.hexing
			},
			sleeve_rgmc_hexing_sleeve_dd = { -- (Hexing + Hexing)
				name = "Hexing Sleeve +",
				text = {
					"Readds ranks {C:attention}2{} through {C:attention}5{}",
                    "Converts {C:attention}excluded{} suits",
                    "into {C:attention}included{} suits",
                    "{C:inactive,s:0.6}({C:rgmc_voids,s:0.6}Voids{C:inactive,s:0.6} and {C:rgmc_lanterns,s:0.6}Lanterns{C:inactive,s:0.6} not included)"
				},
			},
			sleeve_rgmc_hexing_sleeve_ad = { -- (Hexing + Abandoned)
				name = "Hexing Sleeve +",
				text = {
                    "Start run with base suits",
                    "plus {V:1}#1#{} and {V:2}#2#{}",
                    "Removes {C:attention}2s{}"
				},
			},
			sleeve_rgmc_sangria_sleeve = {
				name = "Sangria Sleeve",
				text = deck_text.two_suit
			},
			sleeve_rgmc_sangria_sleeve_dd = { -- (Sangria + Sangria)
				name = "Sangria Sleeve +",
				text = deck_text.two_suit_dd
			},
			sleeve_rgmc_sangria_sleeve_pl = { -- (Merlot/Hexing + Sangria)
				name = "Sangria Sleeve +",
				text = {
                    "Add {C:attention}#3# {V:1}#1#",
                    "and {C:attention}#3# {V:2}#2#",
                    "to deck",
                    "{V:1}#1#{} and {V:2}#2#{} appear",
                    "approximately {C:attention}2X{} more often"
                }
			},
			sleeve_rgmc_micro_sleeve = {
				name = "Micro Sleeve",
				text = deck_text.micro
			},
			sleeve_rgmc_micro_sleeve_dd = {
				name = "Micro Sleeve +",
				text = deck_text.micro
			},
			sleeve_rgmc_capital_sleeve = {
				name = "Capital Sleeve",
				text = deck_text.capital
			},
			sleeve_rgmc_capital_sleeve_alt = {
				name = "Capital Sleeve +",
				text = {
					"Takes {C:money}#1#{} from",
                    "all earnings",
                    "{C:green}#2# in #3#{} chance to",
                    "{C:attention}receive{} 1.5X of all",
                    "{C:attention}lost earnings{C:inactive}(currently {C:money}$#4#{C:inactive})"
				},
			},
			sleeve_rgmc_cross_sleeve = {
				name = "Cross Sleeve",
				text = {
                    "{C:green}#1# in #2#{} chance scored cards",
                    "are {C:red}crossed{}",
                    "Resets held {C:red}crossed{} cards",
                    "at end of {C:attention}Blind"
                }
			},
			sleeve_rgmc_cross_sleeve_alt = {
				name = "Cross Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_merlot_sleeve = {
				name = "Merlot Sleeve",
				text = deck_text.two_suit
			},
			sleeve_rgmc_merlot_sleeve_alt = {
				name = "Merlot Sleeve +",
				text = deck_text.two_suit_dd
			},
			sleeve_rgmc_merlot_sleeve_pl = {
				name = "Merlot Sleeve +",
				text = {
                    "Add {C:attention}#3# {V:1}#1#",
                    "and {C:attention}#3# {V:2}#2#",
                    "to deck",
                    "{V:1}#1#{} and {V:2}#2#{} appear",
                    "approximately {C:attention}2X{} more often"
                }
			},
			sleeve_rgmc_giga_sleeve = {
				name = "Giga Sleeve",
				text = deck_text.giga
			},
			sleeve_rgmc_giga_sleeve_alt = {
				name = "Giga Sleeve +",
				text = deck_text.giga
			},
			sleeve_rgmc_mad_sleeve = {
				name = "Mad Sleeve",
				text = {
					"Adds {C:rgmc_unusual}Madcap{} deck features",
                    "regardless of Deck",
                    "{C:inactive}(Music, etc.)"
				},
			},
        },
        CosmaTarot = {
            c_rgmc_demise = {
                name = 'Demise',
                text = {
                    "Spawns a random",
                    "{C:cosmatarot}Cosma Tarot{}",
                    "{C:green}#1# in #2#{} chance",
                    "to instead copy",
                    "last used {C:cosmatarot}Cosma Tarot",
                    "{C:inactive}(Currently {C:attention}#3#{C:inactive})",
                    "{s:0.8,C:cosmatarot}Demise{s:0.8} excluded"
                }
            },
            c_rgmc_crow = {
                name = 'The Crow',
                text = {
                    "Randomly select {C:attention}#1#{} cards",
                    "and {C:attention}convert{} them",
                    "to {V:1}#2#",
                    "If converted card is",
                    "already {V:1}#3#{},",
                    "add {C:mult}+#4#{} permanent Mult"
                }
            },
            c_rgmc_swan = {
                name = 'The Swan',
                text = {
                    "Randomly select {C:attention}#1#{} cards",
                    "and {C:attention}convert{} them",
                    "to {V:1}#2#",
                    "If converted card is",
                    "already {V:1}#3#{},",
                    "add {X:mult,C:white}X#4#{} permanent Mult"
                }
            },
            c_rgmc_peacock = {
                name = 'The Peacock',
                text = {
                    "Randomly select {C:attention}#1#{} cards",
                    "and {C:attention}convert{} them",
                    "to {V:1}#2#",
                    "If converted card is",
                    "already {V:1}#3#{},",
                    "add {C:money}X#4#{} cash bonus"
                }
            },
            c_rgmc_pelican = {
                name = 'The Pelican',
                text = {
                    "Randomly select {C:attention}#1#{} cards",
                    "and {C:attention}convert{} them",
                    "to {V:1}#2#",
                    "If converted card is",
                    "already {V:1}#3#{},",
                    "add {C:chips}+#4#{} permanent Chips"
                }
            },
            c_rgmc_phoenix = {
                name = 'The Phoenix',
                text = {
                    "Randomly select {C:attention}#1#{} card(s) and",
                    "{C:attention}halves{} their {C:chips}Chips{}",
                    "Converted card gains {C:attention}X#2#{}",
                    "their {C:chips}Chip{} value as {C:mult}Mult{}"
                }
            },
            c_rgmc_soulmates = {
                name = 'The Soulmates',
                text = {
                    "Randomly select {C:attention}#1#{} cards",
                    "and {C:attention}convert{} them",
                    "to a random {C:attention}suit{}",
                    "played this {C:attention}Blind",
                }
            },
            c_rgmc_spirit_plane = {
                name = 'The Spirit Plane',
                text = {
                    "Randomly select {C:attention}#1#{} cards",
                    "and {C:attention}apply{} random {C:attention}enhancements{}",
                    "from {C:attention}deck",
                    "If {C:red}no{} enhancements",
                    "exist in {C:attention}deck{},",
                    "convert cards to any",
                    "random {C:attention}enhancements{}"
                }
            },
            c_rgmc_orbs = {
                name = 'The Orbs',
                text = {
                    {"Randomly select {C:attention}#1#{} cards",
                    "If card has no {C:attention}enhancement{},",
                    "apply a {C:attention}random{} enhancement",
                    "If card has an enhancement",
                    "with supported {C:rgmc_unusual}counterpart{},",
                    "convert card into counterpart",},
                    {"{C:green}#2# in #3#{} chance to instead",
                    "{C:attention}destroy{} selected card"}
                }
            },
            c_rgmc_cosmic_tree = {
                name = 'The Cosmic Tree',
                text = {
                    "Gain {C:rgmc_luxury}£#1#{} for every {C:attention}3{}",
                    "unique {C:attention}ranks{} in deck",
                    "and {C:rgmc_luxury}£#2#{} for every {C:attention}2{}",
                    "unique {C:attention}suits{} in deck",
                    "{C:inactive}(Currently {C:rgmc_luxury}£#3#{C:inactive})"
                }
            },
            c_rgmc_life_map = {
                name = 'The Life Map',
                text = {
                    "{C:green}#1# in #2#{} chance to reroll",
                    "{C:attention}rightmost{} Joker into",
                    "one of a higher {C:attention}rarity"
                }
            },
            c_rgmc_karma = {
                name = 'Karma',
                text = {
                    "Randomly select {C:attention}#1#{} card(s)",
                    "reduce {C:attention}higher{} rank(s) by {C:attention}+#2#{}",
                    "and increase {C:attention}lower{} rank(s) by {C:attention}-#2#{}"
                }
            },
            c_rgmc_sacrifice= {
                name = 'Sacrifice',
                text = {
                }
            },
            c_rgmc_past_lives = {
                name = 'Past Lives',
                text = {
                    "Creates a base",
                    "{C:attention}previously destroyed{} Joker",
                    "{C:inactive}(Must have room)",
                }
            },
            c_rgmc_maze = {
                name = 'The Maze',
                text = {
                    "{C:attention}Shuffles{} the ranks and suits of",
                    "all cards {C:attention}in hand{}",
                }
            },
            c_rgmc_vessel = {
                name = 'The Vessel',
                text = {
                    "Randomly select {C:attention}#1#{} Joker(s)",
                    "by {X:dark_edition,C:white}X#2#{} and",
                    "apply {C:rgmc_evil}Giant{} sticker"
                }
            },
            c_rgmc_shore = {
                name = 'The Shore',
                text = {
                    "Randomly select {C:attention}#1#{} card(s)",
                    "and apply {C:attention}Shielding{},",
                    "{C:attention}Chipped{}, or {C:attention}Multed{} sticker"
                }
            },
            c_rgmc_veil = {
                name = 'The Veil',
                text = {
                    "Randomly select {C:attention}#1#{}",
                    "{C:rgmc_light}Light{} cards,",
                    "then {C:cosmatarot,S:1}Invert{} them",
                    "into their {C:rgmc_dark}Dark{}",
                    "counterparts"
                }
            },
            c_rgmc_bridge = {
                name = 'The Bridge',
                text = {
                    "Randomly select {C:attention}#1#{}",
                    "{C:rgmc_dark}Dark{} cards,",
                    "then {C:cosmatarot,S:1}Invert{} them",
                    "into their {C:rgmc_light}Light{}",
                    "counterparts"
                }
            },
            c_rgmc_pathways = {
                name = 'Infinite Pathways',
                text = {
                    "For the next {C:attention}Shop{}, gives a choice",
                    "between {C:attention}+1{} Booster, {C:attention}+1{} Shop Item,",
                    "and {C:attention}+1{} Booster",
                    "{C:inactive}(Can only choose one)"
                }
            },
            c_rgmc_unknown = {
                name = 'The Unknown',
                text = {
                    "Creates a random {C:dark_edition}Negative",
                    "consumable, Joker, or card and",
                    
                    "{C:inactive}({C:attention}Values {C:inactive}are randomized",
                    "{C:inactive}between {C:attention}X#1#{C:inactive} and {C:attention}X#2#{C:inactive})",
                }
            },
            c_rgmc_life_on_earth  = {
                name = 'Life on Earth',
                text = {
                    "Randomly select {C:attention}#1#{} cards,",
                    "then {C:rgmc_unusual,S:1}convert{} them",
                    "into {V:1}#2#{} or {V:2}#3#{}"
                }
            },
            c_rgmc_sleeping_ships = {
                name = 'Sleeping Ships',
                text = {
                    "Creates an {C:rgmc_unusual, E:1}Unusual{} Joker",
                    "{C:inactive}(Must have room)",
                }
            },
            c_rgmc_aversion = {
                name = 'Aversion',
                text = {
                    "Creates a {C:rgmc_chaotic, E:1}Chaotic{} Joker",
                    "and {C:red}destroy{} all other Jokers",
                    "{C:inactive}Would you like to",
                    "{C:inactive}play my little game?{}"
                }
            },
            -- Bonus Cosmas?!
            c_rgmc_conundrum = { -- Eclipse
                name = 'Pushing Onwards',
                text = {
					"Apply {C:dark_edition}Flipped{} edition",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
			c_rgmc_patience = { -- Blessing
				name = "Patience",
                text = {
                    'Upon using {C:attention}Tarot{},',
                    '{C:green}#1# in #2# chance{} to',
                    'create #3# {C:dark_edition}Negative{} copies',
                    'and {C:red}self-destruct{}',
                    "{s:0.8,C:cosmatarot}Patience{s:0.8} excluded"
                }
			},
			c_rgmc_sleight_of_hand = { -- Seraph
				name = "Sleight of Hand",
                text = {
					"Apply random",
                    "{C:attention}Hand{} seal on",
					"{C:attention}#1#{} selected card(s)",
                }
			},
        },
        Tarot = {
			c_rgmc_girder = { -- ferrous
				name = "Girder",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_filament = { -- wolfram
				name = "Filament",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_polish = { -- lustrous
				name = "Polish",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_providence = { -- random edition to cards
				name = "Providence",
                text = {
                    "#1# in #2# chance to",
                    "apply random {X:dark_edition,C:white}edition{}",
					"to #3# {C:attention}random{} cards",
                    "in hand"
                }
			},
			c_rgmc_fractal = {
				name = "Fractal",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_resonate = {
				name = "Resonate",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_burden = {
				name = "Burden",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_wealth = {
				name = "Wealth",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_vapour = {
				name = "Vapour",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
        },
        Rotarot = {
			c_rgmc_rot_girder = {    -- magnet
				name = "Girder!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_filament = {  --signal
				name = "Filament!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_polish = {    -- crystaltine
				name = "Polish!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_providence = {
				name = "Providence!",
                text = {
                    "#1# in #2# chance to apply {X:edition}edition{}",
					"to #3# {C:attention}random{} cards",
                    "{C:inactive}All editions are weighted equally...{}"
                }
			},
			c_rgmc_rot_fractal = { -- ?!?
				name = "Fractal!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_resonate = {
				name = "Resonate!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_burden = {
				name = "Burden!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_wealth = {
				name = "Wealth!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_vapour = {
				name = "Vapour!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
        },
        Rotumbral = {
			c_rgmc_rot_umbral_graduate = {
				name = "Graduate?!",
                text = {
                    "Copies the next",
                    "{C:rgmc_rotumbral_g,X:rgmc_rotumbral_p} 90-Degree  Rotated  Umbral {} card",
                    "used during this run",
                    "{s:0.8,C:rgmc_rotumbral_g,X:rgmc_rotumbral_p} Graduate?! {s:0.8} excluded",
                }
			},
			c_rgmc_rot_umbral_realist = {
				name = "Realist?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_tribal = {
				name = "Tribal?!",
                text = {
                    "Create a {C:spatiaplanet}Spatia Planet{}",
                    "for the selected {C:attention}poker hand",
                }
			},
			c_rgmc_rot_umbral_gambit = {
				name = "Gambit?!",
                text = {
                    "Converts up to {C:attention}#1#{} random cards",
                    "in hand into a",
                    "random {C:attention}Special{} rank"
                }
			},
			c_rgmc_rot_umbral_kingpin = {
				name = "Kingpin?!",
                text = {
                    "Apply {C:rgmc_coronated}Coronated{} sticker",
                    "and random {C:attention}Seal",
                    "to {C:attention}#1#{} random cards",
                    "then bring them",
                    "to your hand"
                }
			},
			c_rgmc_rot_umbral_tea_time = {
				name = "Tea Time?!",
                text = {
                    "Enhances {C:attention}#1#",
                    "random cards in deck",
                    "to {C:attention}random Tea Cards{}",
                }
			},
			c_rgmc_rot_umbral_break_up = {
				name = "Break Up?!",
                text = {
                    "Splits {C:attention}#1#{} random cards",
                    "into {C:attention}Pure Suit{} and {C:attention}Rank{} cards",
                    "{C:green}#2# in #3#{} chance",
                    "for generated {C:attention}Pure{} cards",
                    "to gain a {C:attention}random{} seal"
                }
			},
			c_rgmc_rot_umbral_public_transport = {
				name = "Public Transport?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_corruption = {
				name = "Corruption?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_fomo = {
				name = "Fear of Missing Out?!",
                text = {
                    "Creates a {C:attention}random{}",
                    "previously {C:attention}unpurchased Joker{}",
                    "that has appeared in the {C:attention}Shop{},",
                    "then sets money to {C:money}$0{}"
                }
			},
			c_rgmc_rot_umbral_misfortune = {
				name = "Misfortune?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_book_smart = {
				name = "Book Smart?!",
                text = {
                    "Create up to {C:attention}#1#{} random",
                    "{C:rgmc_rotumbral_g,X:rgmc_rotumbral_p} 90-Degree Rotated Umbral {} cards",
                    "{C:inactive}(Must have room){}"
                }
			},
			c_rgmc_rot_umbral_prisoner = {
				name = "Prisoner?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_overgrowth = {
				name = "Overgrowth?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_intrusive_thoughts = {
				name = "Instrusive Thoughts?!",
                text = {
                    {
                        "Multiply all Joker and consumable values",
                        "by {X:dark_edition,C:white}X#1#{}",
                        "but {C:green}fixed 1 in 2{} chance to",
                        "{C:rgmc_evil}destroy{} all held {C:red}Jokers{},",
                        "{C:red}consumeables{}, and {C:red}cards{}"
                    }
                }
			},
			c_rgmc_rot_umbral_weeping_angel = {
				name = "Weeping Angel?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_bunker = {
				name = "Bunker?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_rock = {
				name = "Rock?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_crust = {
				name = "Crust?!",
                text = {
                    "Give {C:attention}permanent{} bonus of {X:mult,C:white} X#1# {} Mult",
                    "to {C:attention}all {C:rgmc_blooms}Bloom{} cards in hand",
                }
			},
			c_rgmc_rot_umbral_mantle = {
				name = "Mantle?!",
                text = {
                    "Give {C:attention}permanent{} bonus of {X:chips,C:white} X#1# {} Chips",
                    "to {C:attention}all {C:rgmc_goblets}Goblet{} cards in hand",
                }
			},
			c_rgmc_rot_umbral_core = {
				name = "Core?!",
                text = {
                    "Give {C:attention}permanent{} bonus of {C:money}+$#1#{}",
                    "to {C:attention}all {C:rgmc_towers}Tower{} cards in hand",
                }
			},
			c_rgmc_rot_umbral_atmosphere = {
				name = "Atmosphere?!",
                text = {
                    "Give {C:attention}permanent{} bonus of {C:purple}+#1#{} Score",
                    "to {C:attention}all {C:rgmc_daggers}Dagger{} cards in hands",
                    "{C:inactive}(Next use will give {C:purple}+#2#{C:inactive} Score)"
                }
			},
			c_rgmc_rot_umbral_nyctophobia = {
				name = "Nyctophobia?!",
                text = {
                    "Creates {C:attention}#1# {}random",
                    "{C:dark_edition}Negative {}consumable{C:inactive}(s)",
                }
			},
			c_rgmc_rot_umbral_puzzle = {
				name = "Puzzle?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_electrify = {
				name = "Electrify?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_d1 = {
				name = "D1?!",
                text = {
                    "???"
                }
			},
			c_rgmc_rot_umbral_free_will = {
				name = "Free Will?!",
                text = {
                    "{C:blue}+#1#{} play limit",
                }
			},
        },
        Colour = {
            c_rgmc_carnation_pink = {
                name = "Carnation Pink",
                text = {
                    "Converts a random card in",
                    "hand to {C:rgmc_goblets}Goblets{} for every",
                    "{C:attention}#4#{} round this has been held",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                }
            },
            c_rgmc_cobalt_blue = {
                name = "Cobalt Blue",
                text = {
                    "Converts a random card in",
                    "hand to {C:rgmc_towers}Towers{} for every",
                    "{C:attention}#4#{} round this has been held",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                }
            },
            c_rgmc_olive_green = {
                name = "Olive Green",
                text = {
                    "Converts a random card in",
                    "hand to {C:rgmc_blooms}Blooms{} for every",
                    "{C:attention}#4#{} round this has been held",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                }
            },
            c_rgmc_venetian_red = {
                name = "Venetian Red",
                text = {
                    "Converts a random card in",
                    "hand to {C:rgmc_daggers}Daggers{} for every",
                    "{C:attention}#4#{} round this has been held",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                }
            },
            c_rgmc_celestial_blue = {
                name = "Celestial Blue",
                text = {
                    "Create a random {C:dark_edition}Negative{}",
                    "{C:rgmc_cosma}Cosma Tarot{} for every",
                    "{C:attention}#4#{} rounds this has been held",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                }
            },
            c_rgmc_torch_red = {
                name = "Torch Red",
                text = {
                "Gives a random card in",
                "hand {X:rgmc_gimmick,C:white}Infernal{} edition for every",
                "{C:attention}#4#{} round this has been held",
                "{C:green}#5# in #6# chance{} to instead",
                "{C:red}torch{} selected card",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_rose_gold = {
                name = "Rose Gold",
                text = {
                "Create {X:rgmc_gimmick,C:black}?!? Tag{} for",
                "every {C:attention}#4#{} rounds",
                "this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_iridescent_indigo = {
                name = "Iridescent Indigo",
                text = {
                "Create a {C:dark_edition}Negative{} {C:rgmc_unusual}Sleeping Ships{}",
                "card for every {C:attention}#4#{}",
                "rounds this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_sugar_plum = {
                name = "Sugar Plum",
                text = {
                "every {C:attention}#4#{} rounds",
                "this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_wenge = {
                name = "Wenge",
                text = {
                "A random held card",
                "gains {C:wenge}+#5#{} bonus chips",
                "card for every {C:attention}#4#{}",
                "rounds this has been held",
                "{C:inactive}({C:wenge}+#6#{C:inactive} bonus chips)",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_dark_magenta = {
                name = "Dark Magenta",
                text = {
                "Earn {C:rgmc_luxury}£#5#{}",
                "for every {C:attention}#4#{}",
                "rounds this has been held",
                "{C:inactive}({C:rgmc_luxury}+£#6#{C:inactive})",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_lunacy = {
                name = "Colour of Lunacy",
                text = {
                "??? for",
                "every {C:attention}#4#{} rounds",
                "this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
        },
        Spectral = {
            c_rgmc_oxidize = {
                name = 'Oxidize',
                text = {
					"Add a {C:rgmc_patina}Patina Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_reduct = {
                name = 'Reduct',
                text = {
					"Add a {C:rgmc_cuprum}Cuprum Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_misery = {
                name = 'Misery',
                text = {
					"Add an {C:rgmc_umber}Umber Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_reverb = {
                name = 'Reverb',
                text = {
					"Add a {C:rgmc_jade}Jade Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_ember = {
                name = 'Ignite',
                text = {
					"Add a {C:rgmc_ether}Ether Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_cosmos = {
                name = 'Cosmos',
                text = {
					"Add a {C:rgmc_seafoam}Seafoam Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_reprise = {
                name = 'Reprise',
                text = {
					"Add a {C:rgmc_cherry}Cherry Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_dichromacy = {
                name = 'Dichromacy',
                text = {
					"Add a {C:red}Anag{C:blue}lyph {C:red}Se{C:blue}al{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_duality = {
                name = 'Ambivalence',
                text = {
					"Add a {C:rgmc_sunrise}Sunrise Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_classicality = {
                name = 'Classicality',
                text = {
					"Add a {C:rgmc_midnight}Midnight Seal{}",
					"to {C:attention}#1#{} selected",
					"card(s) in your hand",
                }
            },
            c_rgmc_vici = {
                name = 'Veni, Vidi, Vici',
                text = {
					"Apply {C:dark_edition}Flipped{} edition",
					"to {C:attention}all{} non-editioned",
					"card(s) in your hand",
                }
            },
            c_rgmc_chalice = {
                name = 'Chalice',
                text = {
                    "Converts all {C:hearts}Hearts{} and",
					"{C:diamonds}Diamonds{} in hand",
                    "to {C:rgmc_goblets}Goblets{} and {C:rgmc_blooms}Blooms{}",
                }
            },
            c_rgmc_armoire = {
                name = 'Armoire',
                text = {
                    "Converts all {C:clubs}Clubs{} and",
					"{C:spades}Spades{} in hand",
                    "to {C:rgmc_towers}Towers{} and {C:rgmc_daggers}Daggers{}",
                }
            },
            c_rgmc_bluebell = {
                name = 'Bluebell',
                text = {
					"{C:blue}+#1#{} hand(s)",
                }
            },
            c_rgmc_amaryllis = {
                name = 'Amaryllis',
                text = {
					"{C:red}+#1#{} temporary discard(s)",
                }
            },
            c_rgmc_lowbrow = {
                name = 'Lowbrow',
                text = {
                    "Converts all cards in hand",
                    "to {C:attention}2{}s, {C:attention}3{}s, {C:attention}4{}s, or {C:attention}5{}s"
                }
            },
            c_rgmc_warp_speed = {
                name = "Warp Speed",
                text = {
                    "Upgrade every",
                    "{C:rgmc_unusual,E:1}Sub-Hand",
                    "by {C:attention}#1#{} level(s)"
                },
            },
            c_rgmc_aspire = {
                name = 'Aspire',
                text = {
                    "Converts all {C:tarot}Tarots{}",
                    "with a {E:1,C:cosmatarot}Cosma{} variant,",
                    "into said variant",
                }
            },
            c_rgmc_exchange = {
                name = 'Exchange',
                text = {
                    "Convert all your {C:money}money{}",
                    "to {C:rgmc_luxury}Luxury Points{}",
                    "{C:money}$#1#{} => {C:rgmc_luxury}£#2#{}"
                }
            },
            c_rgmc_shadow = {
                name = 'Your Shadow',
                text = {
                    "Summon a random",
                    "{C:eternal}Eternal{} Joker",
                    "{C:dark_edition}+#2#{} Joker slot{C:inactive}(s)"
                }
            },
            c_rgmc_voyage = {
                name = 'Voyage',
                text = {
                    "Adds a {C:attention}discounted",
                    "{C:spatiaplanet}Subhand{} voucher",
                    "to the next shop"
                }
            },
            c_rgmc_magnify = {
                name = 'Magnify',
                text = {
                    "Multiply {E:1,C:rgmc_bismuth}all values{}",
                    "of a random {C:attention}Joker",
                    "by {C:purple}X#1#{}",
                    "{C:dark_edition}-#2#{} Joker slot{C:inactive}(s)"
                }
            },
            c_rgmc_triplicate = {
                name = 'Triplicate',
                text = {
                    "Replaces up to {C:attention}#1#",
                    "held {C:attention}Double Tags{}",
                    "with {C:attention}Triple Tags{}"
                }
            },
            c_rgmc_elevate = {
                name = 'Elevate',
                text = {
                    "{C:potentiacrystal}Empower every",
                    "{C:rgmc_unusual,E:1}Sub-Hand",
                    "by {C:attention}#1#{} level(s)"
                }
            },
            c_rgmc_magic_hat = {
                name = "Magic Hat",
                text = {
                    "Level up {C:planet}#2#{}",
                    "by {C:attention}#3#{} levels",
                    "{C:attention}+#1#{} Ante"
                },
            },
        },
        Tag = {
            tag_rgmc_royal = {
                name = "Royal Tag",
                text = {
                    "Next Standard Pack opened",
                    "has only {C:attention}Exotic{} suits"
                }
            },
			tag_rgmc_perilous = {
				name = "Perilous Tag",
				text = {
					"Increase next {C:attention}blind requirements{}",
					"by {X:red,C:white}X#1#{}, but gain {C:money}$#2#{}"
				},
			},
            tag_rgmc_boomerang = {
				name = "Boomerang Tag",
				text = {
					"Reduce next {C:attention}blind{}",
                    "requirements by {X:red,C:white}X#1#{} and",
                    "add it to next {C:attention}blind{}"
				},
			},
            tag_rgmc_punisher= {
                name = "Punisher Tag",
				text = {
                    "Gain {C:money}$#1#{}, but make the",
                    "next {C:attention}Boss Blind {C:dark_edition}SUPER HARD!{}",
                    "{C:inactive}(=#2# hand(s), no discards){}"
				},
            },
            tag_rgmc_rainbow = {
                name = "?!? Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}?!?{}",
                    "{C:inactive}(Gives random edition)"
				},
            },
            tag_rgmc_legendary = {
                name = "Fabled Tag",
				text = {
					"Next {C:attention}Shop{}",
					"has a",
                    "{C:purple}Legendary{} Joker",
				},
            },
            tag_rgmc_unusual = {
                name = "Oddity Tag",
				text = {
                    "Next {C:attention}Shop{}",
					"has an",
                    "{C:rgnc_unusual}Unusual{} Joker",
				},
            },
            tag_rgmc_gimmick = {
                name = "Gimmick Tag",
				text = {
					"Next {C:attention}Shop{}",
					"has a",
                    "{C:rgmc_gimmick}Gimmick{} Joker",
				},
            },
            tag_rgmc_pandora = {
                name = "Pandora Tag",
				text = {
					"At start of next Blind,",
				},
            },
            tag_rgmc_decant = {
                name = "Decant Tag",
				text = {
					"Level up {C:planet}#1#{}",
                    "by {C:planet}+#2#{} levels,",
                    "but down {C:attention}#2#{} random",
                    "poker hand(s)",
				},
            },
            tag_rgmc_ponder = {
                name = "Ponder Tag",
				text = {
					"Copies bottom-most tag",
                    "{C:inactive}(Similar to Double Tag)",
				},
            },
            tag_rgmc_concept = {
                name = "Concept Tag",
				text = {
					"Copies above tag",
                    "upon its activation",
                    "{C:inactive}(Similar to Double Tag)",
				},
            },
            tag_rgmc_spam = {
                name = "SPAM! Tag",
				text = {
					"Shop has a",
					"free {C:rgmc_gimmick}SPAM!",
				},
            },
            tag_rgmc_commercial = {
                name = "Commercial Tag",
				text = {
					"Earn {C:money}NeoPoints{} by",
					"watching a {C:red}commercial{}",
				},
            },
			tag_rgmc_jackpot = {
				name = "Jackpot Tag",
				text = {
					"{C:green}#1# in #2#{} chance to",
                    "create a {C:cosmatarot}Cogito Tag{}",
                },
			},
            tag_promotion = {
                name = "Promotion Tag",
                text = {
                    "After defeating",
                    "the Boss Blind,",
                    "gain {C:rgmc_luxury}$#1#"
                }
            },
			tag_rgmc_cogito = {
				name = "Cogito Tag",
				text = {
					"Gives a free {C:cosmatarot}Cosma Pack",
					"with {C:rgmc_unusual,E:1}Sleeping Ships",
                    "{C:green}#1# in #2#{} chance to also",
                    "contain {C:rgmc_chaotic,E:1}Aversion",
				},
			},
			tag_rgmc_exchange = {
				name = "Exchange Tag",
				text = {
					"Sacrifice a random {C:attention}Joker{}",
                    "and gain a random Joker",
                    "of the next rarity",
				},
			},
			tag_rgmc_cosma = {
				name = "Cosmic Tag",
				text = {
					"Gives a free",
					"{C:cosmatarot}Cosma Pack",
				},
			},
            tag_rgmc_iridescent = {
                name = "Iridescent Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Iridescent{}",
				},
            },
            tag_rgmc_infernal = {
                name = "Infernal Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Infernal{}",
				},
            },
            tag_rgmc_disco = {
                name = "Disco Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Disco{}",
					"{C:inactive}(Groovy, man!)"
				},
            },
            tag_rgmc_chrome = {
                name = "Chrome Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Chrome{}",
					"{C:inactive}(Fuuuuuuture!)",
				},
            },
            tag_rgmc_galactic = {
                name = "Galactic Tag",
				text = {
					"Next base edition shop",
					"becomes {C:dark_edition}Galactic{}",
				},
            },
            tag_rgmc_abyssal = {
                name = "Abyssal Tag",
				text = {
					"Next base edition shop",
					"becomes {C:dark_edition}Abyssal{}",
				},
            },
            tag_rgmc_luxury = {
                name = "Luxury Tag",
				text = {
					"Next base edition shop",
					"becomes {C:dark_edition}Luxury{}",
				},
            },
			tag_rgmc_scoop= {
				name = "Scoop Tag",
				text = {
                    "{C:chips}+#1#{} Chips",
                    "until end of Blind",
				},
			},
			tag_rgmc_snack = {
				name = "Snack Tag",
				text = {
                    "{C:mult}+#1#{} Mult",
                    "until end of Blind",
				},
			},
			tag_rgmc_souper = {
				name = "Souper Tag",
				text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "until next {C:red}discard",
				},
			},
			tag_rgmc_anti_boomerang = {
				name = "Rebound",
				text = {
					"Increase {C:attention}blind requirements{}",
					"by {X:red,C:white}X#1#{}",
                    "{C:inactive}(Classified as an {C:attention}AnTag{C:inactive})"
				},
			},
            tag_rgmc_anti_punisher= {
                name = "Ransom AnTag",
				text = {
                    "Lose {C:money}$#1#{}, but",
                    "make the next {C:attention}Boss Blind{}",
                    "{C:dark_edition}\"SUPER EASY\"{}",
                    "{C:inactive}(+#2# hand size(s){}"
				},
            },
            tag_rgmc_anti_buffoon = {
                name = "Wiseacre AnTag",
				text = {
					"Increase next {C:attention}blind",
                    "requirements by {X:red,C:white}#1#%{}",
                    "per added {C:attention}Joker{} this run",
					"{C:inactive}(Currently +#2#%){}}"
				},
            },
            tag_rgmc_anti_ethereal = {
                name = "Corporeal AnTag",
				text = {
					"Increase next {C:attention}blind",
                    "requirements by {X:red,C:white}#1#%{}",
                    "per used {C:attention}Spectral{} card",
					"{C:inactive}(Currently +#2#%){}}"
				},
            },
            tag_rgmc_anti_charm = {
                name = "Spell AnTag",
				text = {
					"Increase next {C:attention}blind",
                    "requirements by {X:red,C:white}#1#%{}",
                    "per used {C:attention}Tarot{} card",
					"{C:inactive}(Currently +#2#%){}}"
				},
            },
            tag_rgmc_anti_meteor = {
                name = "Asteroid AnTag",
				text = {
					"Next blind, temporarily level down",
                    "a random poker hand #1# level for",
                    "every {C:attention}Planet{} card",
					"{C:inactive}(Currently +#2#%){}}"
				},
            },
            tag_rgmc_anti_juggle = {
                name = "Fumble AnTag",
				text = {
					"-#1# hand size next {C:attention}Blind{}",
                    "Sell {C:attention}Joker{} to",
                    "{C:red}disable{} Tag",
				},
            },
            tag_rgmc_anti_voucher = {
                name = "Inflation AnTag",
				text = {
					"Increase {C:attention}blind requirements{}",
					"by {X:red,C:white}#1#%{} per used {C:attention}Voucher{}",
					"{C:inactive}(Currently +#2#%){}}"
				},
            },
            tag_rgmc_anti_skip = {
                name = "Hasty AnTag",
                text = {
					"Increase {C:attention}blind requirements{}",
					"by {X:red,C:white}#1#%{} per Blind skipped",
					"{C:inactive}(Currently +#2#%){}}"
                }
            },
            tag_rgmc_anti_investment = {
                name = "Deficit AnTag",
                text = {
                    "After defeating a Boss Blind,",
                    "lose {C:money}$#1#",
                    "If in {C:red}debt{},",
                    "sell {C:attention}consumeables{}",
                    "and {C:attention}Jokers{} to break even"
                }
            },
            tag_rgmc_anti_top_up = {
                name = "Top-Down AnTag",
                text = {
                    "Create {C:attention}#1# {C:blue}Common{} Jokers",
                    "with {C:attention}Eternal{} stickers",
                    "{C:inactive}(Can overflow!)"
                }
            },
            tag_rgmc_anti_boss = {
                name = "Peon AnTag",
                text = {
                    "Disables rerolling",
                    "until the next Ante"
                }
            },
            tag_rgmc_anti_standard = {
                name = "Swindle AnTag",
                text = {
                    "Replaces #1#-#2# cards",
                    "in your deck with",
                    "{C:attention}debuffed{} cards"
                }
            },
            tag_rgmc_anti_garbage = {
                name = "Debris AnTag",
                text = {
                    "Steals {C:money}$#1#{} per",
                    "{C:red}discard{} used this run",
                    "{C:inactive}(Will give {C:money}$#2#{C:inactive})",
                }
            },
            tag_rgmc_promotion = {
                name = "Promotion Tag",
                text = {
                    "After defeating",
                    "the Boss Blind,",
                    "gain {C:rgmc_luxury}£#1#"
                }
            },
            tag_rgmc_twofer = {
                name = "Twofer Tag",
                text = {
                    "Adds {C:attention}#1#{} {C:voucher}Vouchers",
                    "to the next shop"
                }
            },
        },
        Voucher = {
            -- Overkill
			v_rgmc_combo_meal = {
				name = "Combo Meal",
				text = {
					"Spawns a {C:attention}Reward{}",
					"if {C:attention}total chips",
					"exceed {C:attention}X#1#{} blind chips"
				},
			},
			v_rgmc_supersize = {
				name = "Supersize",
				text = {
					"Spawns an extra {C:attention}Reward{}",
					"for every {X:dark_edition,C:white}^#1#{} Score",
					"above blind requirements",
                    "{C:inactive}(up to {C:attention}9{C:inactive} Rewards)"
				},
			},
            -- Common Jokers
			v_rgmc_everyman = {
				name = "Everyman",
				text = {
					"Each {C:blue}Common{} Joker give",
					"{X:rgmc_xscore,C:white}X#1#{} Score"
				},
			},
			v_rgmc_exceptional = {
				name = "Exceptional",
				text = {
					"Each {C:blue}Common{} Joker give",
					"{X:rgmc_purple,C:white}^#1#{} Score"
				},
			},
            -- Bonus/mult enhancements
			v_rgmc_big_bonus = {
				name = "Big Bonus",
				text = {
					"{C:chips}Chip{} enhancements",
                    "give {C:chips}+#1#{} Chips",
                    "per {C:attention}hand level"
				},
			},
			v_rgmc_massive_mult= {
				name = "Massive Mult",
				text = {
					"{C:mult}Mult{} enhancements",
                    "give {C:mult}+#1#{} Mult",
                    "per {C:attention}hand level"
				},
			},
            -- High Card
			v_rgmc_high_rise = {
				name = "High Rise",
				text = {
					"Playing {C:attention}High Card",
					"retriggers all",
                    "{C:attention}scoring{} cards",
					"{C:attention}#1# time(s){}"
				},
			},
			v_rgmc_high_roller = {
				name = "High Roller",
				text = {
					"Playing {C:attention}High Card{}",
					"retriggers all",
                    "{C:attention}held{} card effects",
					"{C:attention}#1# time(s){}"
				},
			},
            -- Mayhem
			v_rgmc_manifest = {
				name = "Manifest",
				text = {
                    "{C:rgmc_mayhem}+#1#{} Mayhem",
                    "{C:attention}+#2#{} Ante",
				},
			},
			v_rgmc_mindmelt = {
				name = "Mindmelt",
				text = {
                    "{C:rgmc_mayhem}+#1#{} Mayhem",
					"{C:attention}+#2#{} Ante",
				},
			},
			v_rgmc_joker = {
				name = "Joker",
				text = {
                    "{C:mult}+#1#{} Mult{C:inactive}...?"
				},
			},
            -- Cosma Tarots
			v_rgmc_cosma_merchant = {
				name = "Cosmic Merchant",
				text = {
                    "{C:cosmatarot}Cosma Tarot{} cards",
                    "appear #1#X more frequently",
                    "in the shop"
				},
			},
			v_rgmc_cosma_tycoon = {
				name = "Cosmic Tycoon",
				text = {
                    "{C:cosmatarot}Cosma Tarot{} cards",
                    "appear #1#X more frequently",
                    "in the shop"
				},
			},
            -- Spatia/Potentia
			v_rgmc_spatia_traveller = {
				name = "Spatial Traveller",
				text = {
                    "{C:spatiaplanet}Spatia Planet{} cards",
                    "may appear in the shop",
				},
			},
			v_rgmc_true_potential = {
				name = "True Potential",
				text = {
                    "{C:spatiaplanet}Spatia Planet{} cards",
                    "are #1#X more likely",
                    "to contain {C:potentiacrystal}Potentia Crystals{}"
				},
			},
            -- Planet Leveling
			v_rgmc_stargazer = {
				name = "Stargazer",
				text = {
                    "When levelling up a",
                    "{C:attention}poker hand{},",
                    "upgrade the hand {C:attention}before{}",
                    "by half"
				},
			},
			v_rgmc_retrograde = {
				name = "Retrograde",
				text = {
                    "When levelling up a",
                    "{C:attention}poker hand{},",
                    "upgrade {C:attention}contained hands",
                    "by half"
				},
			},

			v_rgmc_bright_bulb= {
				name = "Bright Bulb",
				text = {
                    "Hands can gain additional",
                    "{C:chips}chips{} and {C:mult}mult{} from",
                    "playing {C:rgmc_light}Light{} subhands",
                    "{C:inactive}(Hand must contain {C:attention}#1# {C:inactive}cards",
                    "{C:inactive}with #2# containing {C:attention}light {C:inactive}suits)"
				},
			},
			v_rgmc_blacklight= {
				name = "Blacklight",
				text = {
                    "Hands can gain additional",
                    "{C:chips}chips{} and {C:mult}mult{} from",
                    "playing {C:rgmc_dark}Dark{} subhands",
                    "{C:inactive}(Hand must contain {C:attention}#1# {C:inactive}cards",
                    "{C:inactive}with #2# containing {C:attention}dark {C:inactive}suits)"
				},
			},
			v_rgmc_kings_crown= {
				name = "King's Crown",
				text = {
                    "Hands can gain additional",
                    "{C:chips}chips{} and {C:mult}mult{} from",
                    "playing {C:purple}High{} subhands",
                    "{C:inactive}(Hand must contain {C:attention}#1# {C:inactive}cards",
                    "{C:inactive}with #2# containing {C:attention}high {C:inactive}ranks)"
				},
			},
			v_rgmc_humble_gibus= {
				name = "Humble Gibus",
				text = {
                    "Hands can gain additional",
                    "{C:chips}chips{} and {C:mult}mult{} from",
                    "playing {C:green}Low{} subhands",
                    "{C:inactive}(Hand must contain {C:attention}#1# {C:inactive}cards",
                    "{C:inactive}with #2# containing {C:attention}low {C:inactive}ranks)"
				},
			},
			v_rgmc_shining_prism = {
				name = "Shining Prism",
				text = {
                    "Hands can gain additional",
                    "{C:chips}chips{} and {C:mult}mult{} from",
                    "playing {C:rgmc_bismuth}Prismatic{} subhands",
                    "{C:inactive}(Hand must contain {C:attention}#1# {C:inactive}cards",
                    "{C:inactive}with #2# {C:attention}unique suits {C:inactive})"
				},
			},
			v_rgmc_balance = {
				name = "Inner Balance",
				text = {
                    "Hands can gain additional",
                    "{C:chips}chips{} and {C:mult}mult{} from",
                    "playing {C:attention}Neutral{} subhands",
                    "{C:inactive}(Hand must contain {C:attention}#1# {C:inactive}cards",
                    "{C:inactive}with an equal number of",
                    "{C:inactive}light and dark suits)"
				},
			},
			v_rgmc_joker = {
				name = "Joker Voucher",
				text = {
                    "{C:mult}+#1#{} Mult{C:inactive}...?"
				},
			},
			v_rgmc_joker2 = {
				name = "Jester Voucher",
				text = {
                    "{C:mult}+#1#{} Mult{C:inactive}...?"
				},
			},
        },
		Stake = {
			stake_rgmc_wager_t1 = {
				name = "Crimson Wager",
				text = {
                    "Play on {C:cosmatarot}Madcap Mode",
                    "{s:0.8}(There's more {s:0.8,C:attention,E:1}options{s:0.8}!)"
                },
			},
			stake_rgmc_wager_t2 = {
				name = "Jade Wager",
				text = {
                    "Cards can be {C:attention}Eternal{},",
                    "{C:attention}Delayed{}, and {C:attention}Weakened{}",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t3 = {
				name = "Ebony Wager",
				text = {
                    "Cards can be {C:attention}Perishable{},",
                    "{C:attention}Faulty{}, and {C:attention}Irate{}",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t4 = {
				name = "Indigo Wager",
				text = {
                    "{C:rgmc_violet}Impound{} a random card",
                    "at end of Blind",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t5 = {
				name = "Violet Wager",
				text = {
                    "Cards can be {C:attention}Rental{},",
                    "{C:attention}Toxic{}, and {C:attention}Slashed{}",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t5_plus = {
				name = "Chartreuse Wager",
				text = {
                    "Cards can be {C:rgmc_chartreuse}Withering",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t6 = {
				name = "Saffron Wager",
				text = {
                    "{X:rgmc_saffron,C:white}Renovates{} the {C:attention}Shop{}",
                    "{s:0.8}Required score scales",
                    "{s:0.8}faster for each {C:attention}Ante",
                    "{s:0.6}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t7 = {
				name = "Aurum Wager",
				text = {
                    "Blinds can have Modifiers"
                },
			},
			stake_rgmc_wager_t8 = {
				name = "Tyrian Wager",
				text = {
                    "Boss Blinds have {C:rgmc_tyrian}Assists{}",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t9 = {
				name = "Platinum Wager",
				text = {
                    "After defeating Final Ante,",
                    "Take on {C:rgmc_platinum}The Gauntlet",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t9_plus = {
				name = "Malachite Wager",
				text = {
                    "{C:pow}-0.1{} Pow",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t10 = {
				name = "Iridium Wager",
				text = {
                    "Shops now face {C:rgmc_iridium}Inflation{}",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t11 = {
				name = "Vibranium Wager",
				text = {
                    "Shops now face {C:rgmc_vibranium}Shortages{}",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t12 = {
				name = "Unobtainium Wager",
				text = {
                    "{C:rgmc_unobtainium,E:1}?!?!?",
                    "{s:0.8}Required score scales",
                    "{s:0.8}faster for each {C:attention}Ante",
                    "{s:0.8}Applies all previous Stakes"
                },
			},
			stake_rgmc_wager_t13 = {
				name = "Neutronium Wager",
				text = {
                    "{C:rgmc_neutronium,E:1}?!?!?",
                },
			},
			stake_rgmc_wager_t14 = {
				name = "Red Matter Wager",
				text = {
                    "{C:rgmc_red_matter,E:1}?!?!?",
                },
			},
		},
        Other = {
			p_rgmc_cosma_normal1 = {
				name = "Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_cosma_normal2 = {
				name = "Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_cosma_jumbo = {
				name = "Jumbo Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_cosma_mega = {
				name = "Mega Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_spatia_normal1 = {
				name = "Spatia Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:spatiaplanet} Spatia Planet{} cards",
				},
			},
			p_rgmc_spatia_normal2 = {
				name = "Spatia Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:spatiaplanet} Spatia Planet{} cards",
				},
			},
			p_rgmc_spatia_jumbo = {
				name = "Jumbo Spatia Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:spatiaplanet} Spatia Planet{} cards",
				},
			},
			p_rgmc_spatia_mega = {
				name = "Mega Spatia Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:spatiaplanet} Spatia Planet{} cards",
				},
			},
			p_rgmc_cogito = {
				name = "Cogito Pack",
				text = {
					"Comes with a {C:rgmc_unusual}Sleeping Ships{}",
                    "and {C:rgmc_chaotic}Aversion{}",
					"{s:0.8,C:inactive}(Generated by Jackpot Tag)",
				},
			},
			p_rgmc_chipmult = {
				name = "Red Pill, Blue Pill",
				text = {
					"There are two Jokers:",
                    "One boosts {C:chips}Chips{}",
                    "the other boosts {C:mult}Mult{}",
                    "{C:red}Which {C:blue}pill{} do you take?",
                    "{C:inactive}(Must have room!)",
				},
			},
			p_rgmc_revival = {
				name = "Back From the Dead",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} {C:red}destroyed{}",
                    "(or {C:red}skipped{}) {C:attention}Jokers{}",
                    "/ {C:attention}consumeables {C:inactive}(must have room)",
				},
			},
			p_rgmc_food = {
				name = "Just a Quick Bite",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"delicious {C:dark_edition}Food {C:attention}Jokers",
                    "{C:inactive}(Must have room!)",
				},
			},
			p_rgmc_riff_raff = {
				name = "Riff-Raff",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:blue}Common {C:attention}Jokers",
                    "{C:inactive}(Must have room!)",
				},
			},
			p_rgmc_oops_all_spam = {
				name = "Oops! All SPAM",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}...",
					"{C:rgmc_gimmick}SPAM! Jokers?{}... What.",
                    "Who approved this.",
                    "What a stupid booster pack.",
                    "{C:inactive}(Must have room!)",
				},
			},
			p_rgmc_madcap_select = {
				name = "Madcap Select",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:rgmc_bismuth}Madcap{} mod exclusives",
                    "May contain some rather",
                    "{C:rgmc_unusual}Unusual{} surprises...",
                    "{C:inactive}(Must have room!)",
				},
			},
			p_rgmc_luxury_normal1 = {
				name = "Luxury Pack",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:red}Luxurious{} goodies",
				},
			},
			p_rgmc_luxury_normal2 = {
				name = "Luxury Pack",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:red}Luxurious{} goodies",
				},
			},
			p_rgmc_luxury_jumbo = {
				name = "Jumbo Luxury Pack",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:red}Luxurious{} goodies",
				},
			},
			p_rgmc_luxury_mega = {
				name = "Mega Luxury Pack",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:red}Luxurious{} goodies",
				},
			},
            rgmc_suit_info_light = {
				name = "Light Suits",
				text = {
					"{C:hearts}Hearts{}, {C:diamonds}Diamonds{},",
					"{C:rgmc_goblets}Goblets{}, and {C:rgmc_blooms}Blooms{}"
				},
            },
            rgmc_suit_info_dark = {
				name = "Dark Suits",
				text = {
					"{C:spades}Spades{}, {C:clubs}Clubs{},",
					"{C:rgmc_towers}Towers{}, and {C:rgmc_daggers}Daggers{}"
				},
            },
            rgmc_info_voids = {
				name = "Void Suit",
				text = {
					"{C:rgmc_mayhem}+#1#{} Mayhem",
					"when scored"
				},
            },
            rgmc_info_lanterns = {
				name = "Lantern Suit",
				text = {
					"{C:rgmc_mayhem}#1#{} Mayhem",
					"when scored"
				},
            },
            rgmc_info_jumble = {
				name = "{C:red}Jumbled{}",
				text = {
					"This {C:attention}#1#{} of {C:attention}#2#{}",
                    "counts as a {C:green}#3#{} of {C:green}#4#{}"
				},
            },
            -- bismuth
			rgmc_bismuth_red = {
				name = "{C:red}Red{} Frame",
				text = {
                    "{X:mult,C:white}X#1#{} Mult"
				},
			},
			rgmc_bismuth_red_charged = {
				name = "{C:rgmc_bismuth}Charged {C:red}Red{} Frame",
				text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "per held {C:rgmc_bismuth}???{}"
				},
			},
			rgmc_bismuth_yellow = {
				name = "{C:gold}Gold{} Frame",
				text = {
                    "Earn {C:gold}#$1#",
                    "when scored"
				},
			},
			rgmc_bismuth_yellow_charged = {
				name = "{C:rgmc_bismuth}Charged {C:yellow}Gold{} Frame",
				text = {
                    "Earn {C:rgmc_luxury}+£#1#",
                    "when scored"
				},
			},
			rgmc_bismuth_green = {
				name = "{C:green}Green{} Frame",
				text = {
                    "Retrigger this",
                    "card {C:attention}#1#{} time(s)"
				},
			},
			rgmc_bismuth_green_charged = {
				name = "{C:rgmc_bismuth}Charged {C:green}Green{} Frame",
				text = {
                    "Retrigger adjacent cards",
                    "{C:attention}#1#{} time(s)"
				},
			},
			rgmc_bismuth_blue = {
				name = "{C:blue}Blue{} Frame",
				text = {
                    "{C:chips}+#1#{} Chips"
				},
			},
			rgmc_bismuth_blue_charged = {
				name = "{C:rgmc_bismuth}Charged {C:blue}Blue{} Frame",
				text = {
                    "Retrigger adjacent cards",
                    "{C:attention}#1#{} time(s)"
				},
			},
			rgmc_bismuth_purple = {
				name = "{C:rgmc_xscore}Purple{} Frame",
				text = {
                    "{X:rgmc_xscore,C:white}X#1#{} Score",
				},
			},
			rgmc_bismuth_purple_charged = {
				name = "{C:rgmc_bismuth}Charged {C:rgmc_xscore}Purple{} Frame",
				text = {
                    "{X:rgmc_xscore,C:white}^#1#{} Score",
				},
			},
            -- info for cool ass cards
            rgmc_info_infinity = {
                text = {
                    "Count as {C:rgmc_bismuth}every rank{}",
                    "{C:inactive,s:0.7}Only works with",
                    "{C:inactive,s:0.7}Madcap-supported mods!"
                }
            },
            rgmc_info_x = {
                text = {
                    "Count as a {C:rgmc_bismuth}random rank{}",
                    "This rank changes every {C:attention}Ante{}",
                    "{C:inactive,s:0.7}Only works with",
                    "{C:inactive,s:0.7}Madcap-supported mods!"
                }
            },
            rgmc_info_sum = {
                text = {
                    "{C:chips}+(SUM){} chips",
                    "{C:inactive,s:0.7}Equals the sum of",
                    "{C:inactive,s:0.7}all played {C:attention,S:0.7}number {C:inactive,S:0.7}ranks"
                }
            },
            rgmc_info_draw_2 = {
                text = {
                    "When scored,",
                    "draw {C:attention}2{} cards",
                    "{C:attention}before{} scoring",
                    "{C:inactive,s:0.7}Also counts as",
                    "{C:inactive,s:0.7}a {C:attention,S:0.7}2"
                }
            },
            rgmc_info_reverse = {
                text = {
                    "When scored, {C:attention}reverse",
                    "the scoring order",
                    "of played cards"
                }
            },
            rgmc_info_skip = {
                text = {
                    "When scored,",
                    "{C:attention}skip{} the next card",
                }
            },
            rgmc_info_0 = {
                text = {
                    "{C:blue}No{} chips",
                }
            },
            -- Chinese Takeout descriptions - yum!
            rgmc_chinese_null = {
				name = "Empty Box",
				text = {
					"... The box is empty."
				},
            },
            rgmc_chinese_effect1 = {
				name = "Just Fried Rice",
				text = {
					"{C:chips}+#1#{} Chips"
				},
            },
            rgmc_chinese_effect2 = {
				name = "Kung Pao",
				text = {
					"{C:mult}+#1#{} Mult"
				},
            },
            rgmc_chinese_effect3 = {
				name = "Veggies",
				text = {
					"{C:chips}+#1#{} Chips"
				},
            },
            rgmc_chinese_effect4 = {
				name = "Moo Shi Beef",
				text = {
					"{C:mult}+#1#{} Mult"
				},
            },
            rgmc_chinese_effect5 = {
				name = "Sichuan Shredded Pork",
				text = {
					"{C:chips}+#1#{} Chips"
				},
            },
            rgmc_chinese_effect6 = {
				name = "Orange Chicken",
				text = {
					"{X:mult,C:white}X#1#{} Mult"
				},
            },
            rgmc_chinese_effect7 = {
				name = "Wontons",
				text = {
					"{X:mult,C:white}X#1#{} Mult"
				},
            },
            rgmc_chinese_effect8 = {
				name = "General Tsao's Chicken",
				text = {
					"{X:rgmc_purple,C:white}X#1#{} Score"
				},
            },
            rgmc_chinese_effect9 = {
				name = "General Tsao's Chicken...?!",
				text = {
					"{X:rgmc_xscore,C:white}X#1#{} Score"
				},
            },

            -- Radioactive Chinese descriptions - yum?
            rgmc_rad_chinese_null = {
				name = "Empty Box",
				text = {
					"... The box is empty."
				},
            },
            rgmc_rad_chinese_effect1 = {
				name = "Radioactive Stir Fry",
				text = {
                    "{C:green}#2# in #3#{} chance for",
					"{X:rgmc_xscore,C:white}X#1#{} Score",
					"Otherwise,",
					"{X:rgmc_xscore,C:white}X#4#{} Score",
				},
            },
            rgmc_rad_chinese_effect2 = {
				name = "Sichuan Surprise",
				text = {
                    "{C:green}#2# in #3#{} chance for",
					"{X:chips,C:white}X#1#{} Chips",
					"Otherwise,",
					"{X:chips,C:white}X#4#{} Chips",
				},
            },
            rgmc_rad_chinese_effect3 = {
				name = "Rage-Filled Dumplings",
				text = {
                    "{C:green}#2# in #3#{} chance for",
					"{X:mult,C:white}X#1#{} Mult",
					"Otherwise,",
					"{X:mult,C:white}X#4#{} Mult",
				},
            },
            rgmc_rad_chinese_effect4 = {
				name = "Toxic Mu Shu",
				text = {
                    "{C:green}#2# in #3#{} chance for",
					"{X:chips,C:white}X#1#{} Chips",
					"Otherwise, gives",
					"{X:chips,C:white}X#4#{} Chips",
				},
            },
            rgmc_rad_chinese_effect5 = {
				name = "Thermonuclear Heartburn Tofu",
				text = {
                    "{C:green}#2# in #3#{} chance for",
					"{X:mult,C:white}X#1#{} Mult",
					"Otherwise, gives",
					"{X:mult,C:white}X#4#{} Mult",
				},
            },
            rgmc_rad_chinese_effect6 = {
				name = "Atomic Peking Duck",
				text = {
					"{X:rgmc_ecscore,C:white}^#1#{} Score",
					"{C:attention}Destroys{} all scored cards"
				},
            },
            rgmc_chinese_effect9 = {
				name = "General Tsao's Chicken...?!",
				text = {
					"{X:rgmc_xscore,C:white}X#1#{} Score"
				},
            },
            -- subhand descriptions
            rgmc_subhand_high = {
				name = "Low Subhand",
				text = {
					"Contains at least {C:attention}#1#{} cards",
                    "with ranks of {C:attention}#2#{} or higher"
				},
            },
            rgmc_subhand_low = {
				name = "Low Subhand",
				text = {
					"Contains at least {C:attention}#1#{} cards",
                    "with ranks of {C:attention}#2#{} or higher"
				},
            },
            rgmc_subhand_light = {
				name = "Light Subhand",
				text = {
					"Contains at least {C:attention}#1#{} cards",
                    "with {C:rgmc_light}Light{} Suits",
				},
            },
            rgmc_subhand_dark = {
				name = "Dark Subhand",
				text = {
					"Contains at least {C:attention}#1#{} cards",
                    "with {C:rgmc_dark}Dark{} Suits",
				},
            },
            rgmc_subhand_neutral = {
				name = "Neutral Subhand",
				text = {
					"Contains at least {C:attention}#1#{} cards",
                    "with an equal number",
                    "of {C:rgmc_light}Light{} and {C:rgmc_dark}Dark{} Suits",
				},
            },
            rgmc_subhand_dazzling = {
				name = "Dazzling Subhand",
				text = {
					"Contains at least {C:attention}#1#{} cards",
                    "with {C:rgmc_bismuth}unique{} enhancements",
				},
            },

            rgmc_accum_mult     = { name = "+Mult", text = { "{C:mult}+#1#{} Mult" } },
            rgmc_accum_chips    = { name = "+Chips", text = { "{C:mult}+#1#{} Chips" } },
            rgmc_accum_x_mult    = { name = "xMult", text = { "{X:mult,C:white}X#1#{} Mult" } },
            rgmc_accum_x_chips   = { name = "xChips", text = { "{X:chips,C:white}X#1#{} Chips" } },
            rgmc_accum_e_mult    = { name = "^Mult", text = { "{X:dark_edition,C:white}^#1#{} Mult" } },
            rgmc_accum_e_chips   = { name = "^Chips", text = { "{X:dark_edition,C:white}^#1#{} Chips" } },
            rgmc_accum_money    = { name = "$$$", text = {
                "Gain {C:money}$#1#{} at end of round"
            } },

            -- Slot [A] Stickers (Engraved, Perishable)
			rgmc_engraved = { -- Removed upon countdown ending
				name = "Engraved",
				text = {
                    "Gives {C:red}no{} {C:chips}chips{} or {C:mult}mult",
                    "{C:inactive}({C:attention}#1#{C:inactive} rounds remaining)"
				},
			},
			rgmc_faulty = {
				name = "Faulty",
				text = {
                    "Upon trigger attempt:",
                    "{C:green}#1# in #2#{} chance",
                    "to not trigger",
                    "{C:green}#1# in #3#{} chance",
                    "to retrigger"
				},
			},
			rgmc_shielded = {
				name = "Shielded",
				text = {
                    "Cannot be {C:attention}debuffed{} or {C:attention}destroyed{}"
				},
			},
			rgmc_weakened = {
				name = "Weakened",
				text = {
                    "Will not trigger during {C:attention}Boss Blinds{}"
				},
			},
			rgmc_weakened_active = {
				name = "Weakened (Active)",
				text = {
                    "Will not trigger during {C:attention}Boss Blinds{}",
                    "{C:inactive}(Currently {C:red}active{C:inactive}!)"
				},
			},
			rgmc_unstable = {
				name = "Unstable",
				text = {
                    "???"
				},
			},

            -- Slot [B] (Rental?)
			rgmc_delayed = {
				name = "Delayed",
				text = {
                    "If triggered, activate",
                    "at {C:attention}end{} of scoring"
				},
			},
			rgmc_toxic = {
				name = "Toxic",
				text = {
                    "Prevents {C:attention}adjacent{} cards",
                    "from triggering"
				},
			},
			rgmc_irate = {
				name = "Irate",
				text = {
                    "{C:red}+#1#X{} blind size",
                    "when triggered"
				},
			},
            rgmc_diluted = {
				name = "Diluted",
				text = {
                    "{C:potentiacrystal}-1{} Potentia to",
                    "all played {C:spatiaplanet}Subhands",
                    "when held in hand"
				},
			},

            --- Slot [C]
            -- Positive
            rgmc_positive = {
				name = "Positive",
				text = {
                    "{C:attention}-#1#{} Joker Slot{C:inactive}(s)"
				},
			},
            rgmc_positive_consumable = {
				name = "Positive",
				text = {
                    "{C:attention}-#1#{} consumable Slot{C:inactive}(s)"
				},
			},
            rgmc_positive_card = {
				name = "Positive",
				text = {
                    "{C:attention}-#1#{} hand size"
				},
			},
            -- Negative
            rgmc_negative = {
				name = "Negative",
				text = {
                    "{C:attention}+#1#{} Joker Slot{C:inactive}(s)"
				},
			},
            rgmc_negative_consumable = {
				name = "Negative",
				text = {
                    "{C:attention}+#1#{} consumable Slot{C:inactive}(s)"
				},
			},
            rgmc_negative_card = {
				name = "Positive",
				text = {
                    "{C:attention}+#1#{} hand size"
				},
			},
            -- Invisible
            rgmc_invisible = {
				name = "Invisible",
				text = {
                    "Not counted as a {C:attention}Joker",
                    "by other items"
				},
			},
            rgmc_invisible_consumable = {
				name = "Invisible",
				text = {
                    "Not counted as a {C:attention}consumable",
                    "by other items"
				},
			},
            rgmc_invisible_card = {
				name = "Invisible",
				text = {
                    "Not counted as a {C:attention}card",
                    "by other items"
				},
			},
            -- Stereo
            rgmc_stereo = {
				name = "Stereo",
				text = {
                    "This {C:attention}Joker{} is",
                    "counted {C:attention}twice",
                    "by other items"
				},
			},
            rgmc_stereo_consumable = {
				name = "Stereo",
				text = {
                    "This {C:attention}consumable{} is",
                    "counted {C:attention}twice",
                    "by other items"
				},
			},
            rgmc_stereo_card = {
				name = "Stereo",
				text = {
                    "This {C:attention}card{} is",
                    "counted {C:attention}twice",
                    "by other items"

				},
			},
            -- Lucky
            rgmc_lucky = {
				name = "Lucky",
				text = {
                    "{C:green}+#1#{} Numerator",
                    "for all probabilities"
				},
			},
            rgmc_lucky_card = {
				name = "Lucky",
				text = {
                    "{C:green}+#1#{} Numerator",
                    "for all probabilities",
                    "while {C:attention}held{} in hand"
				},
			},
            rgmc_unlucky = {
				name = "Unlucky",
				text = {
                    "{C:red}+#1#{} Denominator",
                    "for all probabilities"
				},
			},
            rgmc_unlucky_card = {
				name = "Unlucky",
				text = {
                    "{C:red}+#1#{} Denominator",
                    "for all probabilities",
                    "while {C:attention}held{} in hand"
				},
			},
            rgmc_slashed = {
				name = "Slashed",
				text = {
                    "{C:attention}-1{} level to",
                    "all played {C:planet}Poker Hands{}",
                    "when held in hand"
				},
			},
            rgmc_chained = {
				name = "Chained",
				text = {
                    "{C:attention}-1{} level to",
                    "all played {C:spatiaplanet}Subhands",
                    "when held in hand"
				},
			},
            rgmc_shichi = {
				name = "Shichi",
				text = {
                    "First probability roll",
                    "is {C:green,E:1}guaranteed{} each {C:attention}Blind",
				},
			},

            --- Slot [D]
			rgmc_twinkling = {
				name = "Twinkling",
				text = {
                    "Upon removing sticker,",
                    "Remove {C:dark_edition}Edition{}",
                    "{C:inactive}({C:attention}#2#{C:inactive} rounds remaining)"
				},
			},
			rgmc_immutable = {
				name = "Immutable",
				text = {
                    "Cannot change {C:attention}rank{} or {C:attention}suit",
                    "{C:inactive}({C:attention}#2#{C:inactive} rounds remaining)"
				},
			},
			rgmc_painted = {
				name = "Painted",
				text = {
                    "Gains a random, immutable {C:attention}Enhancement{}",
                    "at start of {C:attention}Blind",
                    "{C:inactive}(Cannot change Enhancements)",
				},
			},
            rgmc_coronated = {
				name = "Coronated",
				text = {
                    "Upon drawing cards,",
                    "randomly select one",
                    "{C:attention}Coronated{} card",
                    "and {C:attention}draw it first",
                    "{C:inactive}King me!"
				},
			},
			rgmc_no_hearts = {
				name = "No Hearts",
				text = {
                    "If scored hand",
                    "contains {C:hearts}Hearts{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_spades = {
				name = "No Spades",
				text = {
                    "If scored hand",
                    "contains {C:spades}Spades{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_diamonds = {
				name = "No Diamonds",
				text = {
                    "If scored hand",
                    "contains {C:diamonds}Diamonds{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_clubs = {
				name = "No Clubs",
				text = {
                    "If scored hand",
                    "contains {C:clubs}Clubs{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_goblets = {
				name = "No Goblets",
				text = {
                    "If scored hand",
                    "contains {C:rgmc_goblets}Goblets{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_towers = {
				name = "No Towers",
				text = {
                    "If scored hand",
                    "contains {C:rgmc_towers}Towers{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_blooms = {
				name = "No Blooms",
				text = {
                    "If scored hand",
                    "contains {C:rgmc_blooms}Blooms{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},
			rgmc_no_daggers = {
				name = "No Daggers",
				text = {
                    "If scored hand",
                    "contains {C:rgmc_daggers}Daggers{},",
                    "{C:red}debuff{} this card",
                    "for the entire {C:attention}Blind",
				},
			},

            -- Slot [E]
			rgmc_clown = { -- From Catch the Clown!
				name = "spr_clown",
				text = {
                    "{C:attention}IF{} caught {C:attention}THEN{}",
                    "chips {C:chips}+= 60{}",
				},
			},

            -- Slot [F]
            rgmc_unity = {
				name = "Unity",
				text = {
                    "When this card is {C:attention}altered{},",
                    "modify all {C:attention}Unity{} cards",
                    "in the {C:attention}same{} manner"
				},
			},

            -- Seal descriptions
            rgmc_patina_seal = {
				name = "Patina Seal",
				text = {
					"This card is placed closer",
                    "to {C:attention}front{} of deck",
                    "{C:inactive,s:0.7}(Rolls #3# times",
                    "{C:inactive,s:0.7}with a #1# in #2# chance to",
                    "{C:inactive,s:0.7}advance one position)",
				},
			},
            rgmc_cuprum_seal = {
				name = "Cuprum Seal",
				text = {
					"This card is placed closer",
                    "to {C:attention}rear{} of deck",
                    "{C:inactive,s:0.7}(Rolls #3# times",
                    "{C:inactive,s:0.7}with a #1# in #2# chance to",
                    "{C:inactive,s:0.7}move back one position)",
				},
			},
            rgmc_bronze_seal = {
				name = "Cuprum Seal",
				text = {
					"This card is placed closer",
                    "to {C:attention}rear{} of deck",
                    "{C:inactive,s:0.7}(Rolls #3# times",
                    "{C:inactive,s:0.7}with a #1# in #2# chance to",
                    "{C:inactive,s:0.7}move back one position)",
				},
			},
            rgmc_jade_seal = {
				name = "Jade Seal",
				text = {
                    "When this card is played",
                    "and scores, {C:green}#1# in #2#{} chance",
                    "to {C:attention}return{} to hand",
                }
			},
            rgmc_cherry_seal = {
				name = "Cherry Seal",
				text = {
                    "When this card is played",
                    "and scores, it {C:attention}returns{} and ",
                    "scores {C:green}again{} next hand",
                }
			},
            rgmc_accent_seal = {
				name = "Accent Seal",
				text = {
                    "If {C:attention}held{} in hand at end of round",
                    "levels up applicable {C:attention}subhands{}",
                    "of winning poker hand by {C:attention}#1#{}"
                }
			},
            rgmc_seafoam_seal = {
				name = "Seafoam Seal",
				text = {
                    "{C:green}#1# in #2# chance to{}",
                    "create a {C:rgmc_cosma}Cosma{} card",
                    "when {C:attention}discarded",
                    "{C:inactive}(Must have room)",
                }
			},
            rgmc_ether_seal = {
				name = "Ether Seal",
				text = {
                    "#1# in #2# chance to create a",
                    "random {C:spectral}Spectral{} card",
                    "if {C:attention}held{} in hand at end of round",
                    "{C:inactive}(Must have room)",
                }
			},
            rgmc_anaglyph_seal = {
				name = "Anaglyphic Seal",
				text = {
                    "If {C:attention}held{} in hand at end of round",
                    "{C:green}#1# in #2#{} chance to",
                    "spawn a {C:red}Double {C:blue}Tag{}"
                }
			},
            rgmc_sunrise_seal = {
				name = "Sunrise Seal",
				text = {
                    "Upon discarding, switch suit to",
                    "{C:rgmc_light}Light{} or {C:rgmc_dark}Dark{} equivalent",
                    "{C:inactive}(Does nothing if",
                    "{C:inactive}no equivalent exists)",
                }
			},
            rgmc_midnight_seal = {
				name = "Midnight Seal",
				text = {
                    "Upon discarding, switch suit to",
                    "{C:attention}parallel equivalent{}",
                    "{C:inactive}(Does nothing if",
                    "{C:inactive}no equivalent exists)",
                }
			},
            rgmc_umber_seal = {
				name = "Umber Seal",
				text = {
                    "When this card is {C:attention}discarded{},",
                    "draw {C:attention}#1#{} extra cards",
                }
			},
        },
        Partner = {
			pnr_rgmc_snacky = {
                name = "Snacky Shark",
                text = {
                    "Provides a random",
                    "{C:attention}stat boost{} every Blind",
                    "Straight from",
                    "General Tsao himself!",
                },
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_manganese = {
                name = "Manganese",
                text = {
                    "First scored card with",
                    "{C:diamonds}Diamond{} suit gives",
                    "{X:mult,C:white}#1#{} Mult / {X:chips,C:white}#2#{} Chips",
                    "if suceeding",
                    "{C:clubs}Clubs{} / {C:spades}Spades{}"
                },
                unlock = { -- trigger
                    "???",
                },
            },
			pnr_rgmc_traveller = {
                name = "Traveller",
                text = {
                    "Upon using a {C:planet}Planet{} card",
                    "level up the last played",
                    "{C:attention}poker hand by #1# level(s)",
                    "{C:inactive}(Currently {C:attention}#2# {C:inactive})"
                },
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_paschal = {
                name = "Paschal",
                text = {
                    "Upon selecting blind,",
                    "apply random {C:attention}enhancement",
                    "to random playing {C:attention}card",
                },
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_squeezy = {
                name = "Squeezy",
                text = {
                    "At end of hand, gives",
                    "{X:mult,C:white}X#1#{} Mult for",
                    "every {C:chips}+#2#{} Chips scored",
                    "after base chips"
                },
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_foolish = {
                name = "Foolish",
                text = {
                    "Applies {C:attention}Clown{}",
                    "to random card each {C:attention}Blind",
                    "Catch the clown to",
                    "earn a {C:attention}reward",
                    "Miss the clown and",
                    "suffer a {C:red}punishment"
                },
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_aces = {
                name = "Aces",
                text = {
                    "On first hand of",
                    "{C:attention}Blind{}, {C:attention}Aces{} are",
                    "considered {C:attention}#1#s{}",
                    "{C:inactive}(Rank changes",
                    "{C:inactive}each Blind)"
                },
                unlock = {
                    "???",
                },
            },
        },
    },
	misc = {
		suits_singular = {
            rgmc_goblets    = 'Goblet',
            rgmc_towers     = 'Tower',
            rgmc_blooms     = 'Bloom',
            rgmc_daggers    = 'Dagger',
            rgmc_voids      = 'Void',
            rgmc_lantern    = 'Lantern',
		},
		suits_plural = {
            rgmc_goblets    = 'Goblets',
            rgmc_towers     = 'Towers',
            rgmc_blooms     = 'Blooms',
            rgmc_daggers    = 'Daggers',
            rgmc_voids      = 'Voids',
            rgmc_lanterns   = 'Lanterns',
		},
        ranks = {
            -- unstb
            ["rgmc_0"]          = "0",
            ["rgmc_0.5"]        = "Half",
            ["rgmc_1"]          = "1",
            ["rgmc_11"]         = "11",
            ["rgmc_12"]         = "12",
            ["rgmc_13"]         = "13",
            ["rgmc_20"]         = "20",
            ["rgmc_21"]         = "21",
            ["rgmc_25"]         = "25",
            -- Fibonacci ranks
            ["rgmc_34"]         = "34",
            ["rgmc_55"]         = "55",
            ["rgmc_Phi"]        = "Golden Ratio",
            -- Funny numbers
            ["rgmc_10.5"]       = "10 and a Half",
            ["rgmc_24"]         = "24",
            -- Base2 numbers
            ["rgmc_32"]         = "32",
            ["rgmc_64"]         = "64",
            ["rgmc_128"]        = "128",
            -- Uno cards
            ["rgmc_Draw2"]      = "Draw 2",
            ["rgmc_Skip"]       = "Skip",
            ["rgmc_Reverse"]    = "Reverse",
            -- And the rest!
            ["rgmc_16"]         = "16",
            ["rgmc_52"]         = "52",
            ["rgmc_Knight"]     = "Knight",
            ["rgmc_X"]          = "X",
            ["rgmc_Sum"]        = "Sum",
            ["rgmc_Infinity"]   = "Infinity",
            ["rgmc_Madcap"]     = "M",
        },
        challenge_names={
            c_rgmc_pickys_challenge = "Picky's Challenge",
            c_rgmc_rios_challenge   = "Rio's Challenge",
            c_rgmc_recession        = "The Recession",
            c_rgmc_heartless        = "Heartless!",
            c_rgmc_crunch_numbers   = "Crunch the Numbers",
            c_rgmc_rocket_man       = "Rocket Man",
        },
		dictionary = {
			b_read_mail = "READ",
			b_luxury_shoppe_1        = "To Luxury",
			b_luxury_shoppe_2        = "Shoppe",
			ph_luxury                = "For the worthy",
            ph_luxury_bonus          = "Luxury Bonus!",

			b_impound_shop_1         = "To Impound",
			b_impound_shop_2         = "Center",

            rgmc_patina_seal         = "Patina Seal",
            rgmc_bronze_seal         = "Cuprum Seal",
            rgmc_ether_seal          = "Ether Seal",
            rgmc_umber_seal          = "Umber Seal",
            rgmc_jade_seal           = "Jade Seal",
            rgmc_cherry_seal         = "Cherry Seal",

            
            b_rotumbral_cards        = "90 Degree Rotated Umbral Cards",
            k_rotumbral              = "90 Degree Rotated Umbral Card",
            k_rotumbral_pack         = "90 Degree Rotated Umbral Pack",

            -- editions
			rgmc_iridescent          = "Iridescent",
			rgmc_infernal            = "Infernal",
			rgmc_chrome              = "Chrome",
			rgmc_disco               = "Disco",
			rgmc_phasing             = "Phasing",
			rgmc_galactic            = "Galactic",
			rgmc_abyssal             = "Abyssal",
			rgmc_luxury              = "Luxury",
			rgmc_flipped             = "Flipped",

			-- text
			rgmc_mayhem              = "Mayhem",
            rgmc_minus_round         = "-1 Round",
			rgmc_what                = "what",
			rgmc_enabled_ex          = "Enabled!",
			rgmc_flipped_ex          = "Flipped!",
			rgmc_shield_removed_ex   = "Un-Shielded!",
			rgmc_removed_ex          = "Removed!",
			rgmc_balanced            = "Balanced",
			rgmc_ace_ex              = "Ace!",
			rgmc_cjokey_ex           = "Chicken Jockey!",
			rgmc_inactive            = "Inactive",
			k_yeah_ex                = "Yeah!",

			-- temp hand/discard
			k_t_hands_plus           = "+#1# Temp. Hands",
			k_t_discards_plus        = "+#1# Temp. Discards",

			-- chinese! chinese!
            rgmc_chinese_line1      = "Just fried rice",
            rgmc_chinese_line2      = "Mmm, Kung Pao!",
            rgmc_chinese_line3      = "Sichuan Shredded Pork!!",
            rgmc_chinese_line4      = "Mo Shi Beef!",
            rgmc_chinese_line5      = "Ick, mostly veggies",
            rgmc_chinese_line6      = "Hmm, tastes kind of citrusy",
            rgmc_chinese_line7      = "Joy! Wontons!",
            rgmc_chinese_line8      = "General Tsao has outdone himself",

			-- chinese! chinese!
            rgmc_rad_chinese_line1      = "Radioactive Energy!!",
            rgmc_rad_chinese_line2      = "Sichuan Surprise!",
            rgmc_rad_chinese_line3      = "Filling... with... RAGE!!",
            rgmc_rad_chinese_line4      = "Yuck, Toxic Mu Shu!",
            rgmc_rad_chinese_line5      = "Ouch, Thermonuclear Heartburn!",
            rgmc_rad_chinese_line6      = "Atomic Peking Duck?!!",

            -- text
            rgmc_spam               = "SPAM",
            rgmc_maps               = "MAPS",
            rgmc_spam_ex            = "SPAM!",
            rgmc_spam_deathex       = "ONOS!",

            -- planets
            rgmc_rocket             = "Space Vehicle",
            rgmc_space_lobster      = "Boss Spacecraft",
            rgmc_planet_alt         = "Alt. Reality Planet",
            rgmc_anomality          = "Anomality?!",
            rgmc_moon               = "Moon",
            rgmc_emp_crystal        = "Empowered Crystal",

            -- subhands
            ml_sh_light             = "Light",
            ml_sh_dark              = "Dark",
            ml_sh_balanced          = "Neutral",
            ml_sh_spectrum          = "Prismatic",
            ml_sh_high              = "High",
            ml_sh_low               = "Low",

            k_mission_accomplished  = "Mission Accomplished!",
            k_mission_in_progress   = "Mission in Progress...",
            k_mission_failed        = "Mission Failed...",
            k_empowered             = "Empowered",

            k_costs                 = "Costs",
            k_luxury_pts            = "Luxe",
            ['£']                   = '£',

            -- Config
            ui_rgmc_requires_restart    = "Requires Restart",


            ui_rgmc_subhands            = "Subhands",
            ui_rgmc_luxury              = "Luxury Points",

            ui_rgmc_cosma               = "Cosma Tarots",
            ui_rgmc_spatia              = "Spatia Planets",
            ui_rgmc_potentia            = "Potentia Crystals",
            ui_rgmc_tarot               = "New Tarots",
            ui_rgmc_planet              = "New Planets",
            ui_rgmc_spectral            = "New Spectrals",

            ui_rgmc_ranks1              = "Static Ranks",
            ui_rgmc_ranks2              = "Dynamic Ranks",
            ui_rgmc_ranks3              = "High Ranks",
            ui_rgmc_ranks4              = "UNO Ranks",

            ui_rgmc_deck                = "Decks",
            ui_rgmc_booster             = "Boosters",
            ui_rgmc_voucher             = "Vouchers",
            ui_rgmc_stake               = "Stakes",
            ui_rgmc_tag                 = "Tag",
            ui_rgmc_wip                 = "WIP Content",

            ui_rgmc_suits1              = "Parallel Suits",
            ui_rgmc_suits2              = "Chaotic Suits",
            ui_rgmc_rarities            = "Rarities",
            ui_rgmc_unusual             = "Unusual",
            ui_rgmc_gimmick             = "Gimmick",
            ui_rgmc_chaotic             = "Chaotic",


            -- Rarities
			k_rgmc_unusual   = "Unusual",
			k_rgmc_gimmick   = "Gimmick",
			k_rgmc_chaotic   = "Chaotic",
			k_rgmc_felinus   = "Felinus",

            b_subhands      = "Subhands",
			k_rgmc_luxury_bonus      = "Luxury Bonus",

			k_cosmatarot             = "Cosma Tarot",
			b_cosmatarot_cards       = "Cosma Tarots",
			k_spatiaplanet           = "Spatia Planet",
			b_spatiaplanet_cards     = "Spatia Planets",
			k_antispectral           = "Sinister Card",
			b_antispectral_cards     = "Sinister Cards",
			k_potentiacrystal        = "Potentia Crystal",
			b_potentiacrystal_cards  = "Potentia Crystals",
			k_miscrgmc               = "Misc. Card (Madcap)",
			b_miscrgmc_cards         = "Misc. Cards (Madcap)",

			k_rgmc_cosma_pack    = "Cosma Pack",
			k_rgmc_spatia_pack   = "Spatia Pack", -- includes potentia crystals too?!
			k_rgmc_variety_pack  = "Variety Pack",
			k_rgmc_reward_pack   = "Reward Pack",
			k_rgmc_ruinous_pack  = "Ruinous Pack",

			a_discard_plus   = "+#1# Discard",
			a_discard_minus  = "-#1# Discard",

			a_hand_plus      = "+#1# Hand",
			a_hand_minus     = "-#1# Hand",
            k_plus_bismuth   = "+1 Bismuth",
            k_plus_cosma     = "+1 Cosma",
            k_plus_variety   = "+1 Item",
            k_rounds         = "Rounds",
            k_plus_antispectral     = "+1 Anti-Spectral",

            k_left_lc       = "left",
            k_right_lc      = "right",

            rgmc_debuff_multiblind = "Conflicts with current blind abilities!",

            -- idk
            rgmc_lobster_sub        = {
                "With A Mornay Sauce",
                "Garnished With Truffle Pâté," ,
                "Brandy and a Fried Egg On Top"
            }
		},
        poker_hand_descriptions = {
            rgmc_pyramid = {
                "Three or more groups of cards",
                "of descending rank and",
                "ascending quantity",
                "(Can be inverted!)"
            },
            rgmc_pyramid_flush = {
                "Three or more groups of cards",
                "of descending rank,",
                "ascending quantity, and",
                "identical suit",
                "(Can be inverted!)"
            },
            rgmc_pyramid_spectrum = {
                "Three or more groups of cards",
                "of descending rank",
                "and rank, containing five",
                "or more suits",
                "(Can be inverted!)"
            },
            rgmc_blazer = {
                "5 face cards containing",
                "at least 3 unique ranks"
            },
            rgmc_kaleidoscope = {
                "5 Bismuth Cards"
            },
            rgmc_pick_five = {
                "5 random ranks chosen",
                "at the start of each Ante"
            },
            rgmc_infoak = {
                "5 Infinity cards"
            },
            rgmc_infoak_flush = {
                "5 Infinity cards",
                "of the same suit"
            },
            rgmc_nohand = {
                "Oops, no possible hand!"
            },
        },
        poker_hands= {
            rgmc_pyramid                    = "Pyramid",
            rgmc_pyramid_flush              = "Flush Pyramid",
            rgmc_pyramid_spectrum           = "Spectrum Pyramid",
            rgmc_blazer                     = "Blazer",
            rgmc_pick_five                  = "Pick 5",
            rgmc_kaleidoscope               = "Kaleidoscope",
            rgmc_noak                       = "None of a Kind",
            rgmc_noak_flush                 = "Flush None",
            rgmc_infoak                     = "Infinitum",
            rgmc_infoak_flush               = "Fluxus Infinitum",
            rgmc_nohand                     = "No Hand",
        },
		labels = {
            rgmc_engraved            = "Engraved",
            rgmc_faulty              = "Faulty",
			rgmc_shielded            = "Shielded",
			rgmc_weakened            = "Weakened",
			rgmc_unstable            = "Unstable",
			rgmc_delayed             = "Delayed",
			rgmc_toxic               = "Toxic",
			rgmc_irate               = "Irate",
            rgmc_positive            = "Positive",
            rgmc_negative            = "Negative",
            rgmc_invisible           = "Invisible",
            rgmc_stereo              = "Stereo",
            rgmc_lucky               = "Lucky!",
            rgmc_unlucky             = "Unlucky",
			rgmc_twinkling           = "Twinkling",
			rgmc_immutable           = "Immutable",
			rgmc_painted             = "Painted",
            rgmc_clown               = "[spr_clown]",
            rgmc_slashed             = "Slashed",
            rgmc_chained             = "Chained",
            rgmc_diluted             = "Diluted",
            rgmc_shichi              = "Shichi",
            rgmc_coronated           = "Coronated",
            rgmc_unity               = "Unity",

			rgmc_iridescent          = "Iridescent",
			rgmc_infernal            = "Infernal",
			rgmc_chrome              = "Chrome",
			rgmc_disco               = "Disco",
			rgmc_phasing             = "Phasing",
			rgmc_galactic            = "Galactic",
			rgmc_abyssal             = "Abyssal",
			rgmc_luxury              = "Luxury",
			rgmc_flipped             = "Flipped",

			rgmc_patina_seal    = "Patina Seal",
			rgmc_bronze_seal    = "Cuprum Seal",
			rgmc_jade_seal      = "Jade Seal",
			rgmc_umber_seal     = "Umber Seal",
			rgmc_ether_seal     = "Ether Seal",
			rgmc_cherry_seal    = "Cherry Seal",
			rgmc_seafoam_seal   = "Seafoam Seal",
			rgmc_sunrise_seal   = "Sunrise Seal",
			rgmc_midnight_seal  = "Midnight Seal",
			rgmc_anaglyph_seal  = "Anaglyphic Seal",
			rgmc_obsidian_seal  = "Obsidian Seal",

			rgmc_unstb_goblets_seal      = "Goblet Seal",
			rgmc_unstb_towers_seal       = "Tower Seal",
			rgmc_unstb_blooms_seal       = "Bloom Seal",
			rgmc_unstb_daggers_seal      = "Dagger Seal",
			rgmc_unstb_voids_seal        = "Void Seal",
			rgmc_unstb_lanterns_seal     = "Lantern Seal",
			rgmc_unstb_dark_suit_seal    = "Dark Suit Seal",
			rgmc_unstb_light_suit_seal   = "Light Suit Seal",
		},
		v_dictionary = {
            capitalism_money    = "Boss Capital ($#1#)",
            --[[
            k_riftraft_buy = {
                "Buy & Void", 
                "for $#3#",
                "(#1#/#2#)"
            },
            k_riftraft_send = {
                "Void!",
            },
            k_riftraft_nope = { 
                "Nope!" 
            },
            k_riftraft_limit_reached = {
                "Voiding Limit",
                "Reached!",
                "(#1#/#2#)"
            },]]
		},
    },
}
