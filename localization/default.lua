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
			b_rgmc_pale = {
				name = "Pale Deck",
				text = {
					"{C:attention}#1#{} hand size, #2# hand(s)",
					"At start of {C:attention}Blind{},",
					"apply {C:attention}Negative{} and {C:attention}Twinkling{}",
					"to #3# cards"
				},
			},
			b_rgmc_hexing = {
				name = "Hexing Deck",
				text = {
					"Start with {C:attention}Special{} suits",
					"(Removes ranks {C:attention}2{} through {C:attention}5{!)"
				},
			},
			b_rgmc_target = {
				name = "Target Deck",
				text = {
					"At end of Blind, gain a",
					"reward or punishment",
					"if score is within #1#X or",
					"above #2#X of,",
					"blind requirements",
				},
			},
			b_rgmc_sangria = {
				name = "Sangria Deck",
				text = {
					"Start run with",
                    "{C:attention}26 {C:rgmc_goblets}Goblets",
					"and {C:attention} 26 {rgmc_towers}Towers{}",
                    "in deck"
				},
			},
			b_rgmc_merlot = {
				name = "Merlot Deck",
				text = {
					"Start run with",
                    "{C:attention}26 {C:rgmc_blooms}Blooms",
					"and {C:attention} 26 {rgmc_daggers}Daggers{}",
                    "in deck",
				},
			},
			b_rgmc_micro = {
				name = "Micro Deck",
				text = {
					"{C:attention}#1#{} hand size",
					"{C:attention}#2#{} play limit",
					"{C:attention}X#3#{} blind size"
				},
			},
			b_rgmc_giga = {
				name = "Giga Deck",
				text = {
					"{C:attention+#1#{} hand size",
					"{C:attention}#2#{} play limit",
					"{C:attention}X#3#{} blind size"
				},
			},
			b_rgmc_mayhem = {
				name = "Deck of Mayhem",
				text = {
					"Start with {C:attention}#1# {C:rgmc_mayhem}Mayhem{}",
                    "{C:rgmc_mayhem}Mayhem{} increases and decreases",
                    "{C:attention}X#2#{} as fast{}",
                    "{C:rgmc_voids}Void{} cards appear",
                    "#3#X as often"
				},
			},
			b_rgmc_lunacy = {
				name = "Deck of Lunacy",
				text = {
					"Start with {C:attention}maximum {C:rgmc_mayhem}Mayhem{}",
					"Finisher Blinds appear,",
					"every {C:attention}#1#{} ante(s)",
					"Win on Ante {C:attention}#2#",
				},
			},
			b_rgmc_jumble = {
				name = "Jumble Deck",
				text = {
					"After defeating each {C:attention}Boss Blind{},",
					"ranks in deck are {C:attention}jumbled{}"
				},
			},
			b_rgmc_cross = {
				name = "Cross Deck",
				text = {
					"Played cards are {C:attention}permanently debuffed{}",
					"Held cards at end of round are {C:green}reset{}",
					"{C:attention}+#1#{} hand size"
				},
			},
			b_rgmc_capital = {
				name = "Capital Deck",
				text = {
                    "Start with {C:money}$#1#{}",
					"{C:attention}Bosses{} reward {X:money,C:white}X#2#{} Money",
					"{C:attention}Blinds{} and {C:attention}Shops{}",
					"cost {C:money}$#3#{}/{C:money}$#4#{} to enter",
					"If you reach {C:red}$#5#{}, you {C:red}lose{}!"
				},
			},
			b_rgmc_communist = {
				name = "Communist Deck",
				text = {
                    "{C:money}Money{}? {C:attention}No{}, comrade.",
                    "All items are {C:money}free{}, but greed",
                    "is swiftly {C:attention}punished{}",
				},
			},
        },
        Edition = {
			e_rgmc_iridescent = {
				name = "Iridescent",
				text = {
					"Redistributes {C:chips}chips{} and {C:mult}mult",
					"in a 70-30 split"
				},
			},
			e_rgmc_infernal = {
				name = "Infernal",
				text = {
					"{X:purple,C:white}X#1#{}... Score?",
					"{C:green}#2# in #3#{} chance to",
					"burn up upon",
                    "end of round"
				},
			},
			e_rgmc_chrome = {
				name = "Chrome",
				text = {
					"{X:purple,C:white}X#1#{}... Score?"
				},
			},
			e_rgmc_disco= {
				name = "Disco",
				text = {
					"Gives either {C:chips}+#1#{} Chips,",
					"{C:mult}+#2#{} Mult, {X:mult,C:white}X#3#{} Mult,",
					"{C:money}$#4#{}, {X:purple,C:white}X#5#{} Score,",
					"or {X:money,C:white}X#6#{} Money",
				},
			},
			e_rgmc_galactic = {
				name = "Galactic",
				text = {
					"{C:chips}+#4#{} Chips",
                    "{C:inactive}(Gives {X:planet,C:white}0.5X{}{C:inactive}chip value times",
                    "{C:planet}level{} of {C:attention}last played{C:inactive} Poker Hand -",
                    "{C:inactive}currently{C:attention} #1#{C:inactive})",
                    "({C:chips}(#2# / 2){C:inactive} x {C:planet}#3#{C:inactive})",
				},
			},
			e_rgmc_abyssal = {
				name = "Abyssal",
				text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}(Gives {X:mult,C:white}X#2#{C:inactive} Mult",
                    "{C:inactive}per {C:purple}Mayhem{C:inactive})",
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
					"{C:chips}+#1#{} Chips",
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
                    "Negative cards are",
                    "always drawn face down",
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
            bl_rgmc_din = {
                name = "The Din",
                text = {
                    "+#1# Temporary Mayhem",
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
            bl_rgmc_chaos_boss0 = {
                name = "Danger!",
                text = {
                    "#1# is approaching...",
                },
            },
            bl_rgmc_chaos_boss1 = {
                name = "Insanus Infinitus",
                text = {
                    "(#1# left)"
                },
            },
            --[[
                The Final Boss - 5 Phases

                ALL PHASES:
                    - You cannot run out of hands - instead, destroy cards at random

                PHASE 1: Bixbite Beetroot
                    - Randomizes card suit, rank, enhancement, seal, and edition
                        based on weight system - think "controlled chaos".
                    - You cannot play the same hand twice in a row. (Debuff Hand)
                    - After beating Blind, this Blind
                        harnesses the <Fifth Dimension> and
                        splits into three timelines (Red, Green, Blue).
                        Proceed to Phase 2.

                PHASE 2: Beta Rubra (Red Beet)
--                     -

                PHASE 3: Beta Viridis (Green Beet)
                    -

                PHASE 4: Beta Caerulea (Blue Beet)
                    -

                PHASE 5: Sateenkaarijuuri (The Rainbow Beet)
                    - The "split timelines" are brought together,
                        merging copies together

            ]]
            bl_rgmc_final_beet = {
                name = "Bixbite Beetroot",
                text = {
                    "Face the power of",
                    "Absolute Madcap"
                }
            },
            bl_rgmc_beet_red = {
                name = "Beta Rubra",
                text = {
                    "?!?"
                }
            },
            bl_rgmc_beet_green = {
                name = "Beta Viridis",
                text = {
                    "?!?"
                }
            },
            bl_rgmc_beet_blue = {
                name = "Beta Caerulea",
                text = {
                    "?!?"
                }
            },
            bl_rgmc_beet_final = {
                name = "Sateenkaarijuuri",
                text = {
                    "It ends now."
                }
            },
            -- more fluff compat: dx blinds
            bl_rgmc_bottle_dx = {
                name = "The Bottle DX",
                text = {
                    "All non-Goblet cards",
                    "are debuffed"
                }
            },
            bl_rgmc_sword_dx = {
                name = "The Sword DX",
                text = {
                    "All non-Tower cards",
                    "are debuffed"
                }
            },
            bl_rgmc_keyhole_dx = {
                name = "The Keyhole DX",
                text = {
                    "Playing a regular hand",
                    "destroys all cards"
                }
            },
            bl_rgmc_ladder_dx = {
                name = "The Ladder DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_levy_dx = {
                name = "The Levy DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_grave_dx = {
                name = "The Grave DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_jest_dx = {
                name = "The Jest DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_elevator_dx = {
                name = "The Elevator DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_sum_dx = {
                name = "The Sum DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_statue_dx = {
                name = "The Statue DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_cheap_dx = {
                name = "The Cheap DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_ricochet_dx = {
                name = "The Ricochet DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_coil_dx = {
                name = "The Coil DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_final_blindfold_dx = {
                name = "Beige Blindfold DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_final_hoop_dx = {
                name = "Han Purple Hoop DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_final_pin_dx = {
                name = "Han Purple Hoop DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_final_chimes_dx = {
                name = "Wisteria Chimes DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_halo_dx = {
                name = "The Halo DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_spiral_dx = {
                name = "The Spiral DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_carousel_dx = {
                name = "The Carousel DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_axe_dx = {
                name = "The Axe DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_rust_dx = {
                name = "The Rust DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_figure__dx = {
                name = "The Figure DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_factor__dx = {
                name = "The Factor DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_gyre_dx = {
                name = "The Gyre DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_bowler_dx = {
                name = "The Bowler DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_din_dx = {
                name = "The Din DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_flip_dx = {
                name = "The Flip DX",
                text = {
                    "???"
                }
            },
            bl_rgmc_switch_dx = {
                name = "The Switch DX",
                text = {
                    "???"
                }
            },
        },
        Joker = {
            j_rgmc_thorium_joker = {
                name = "Thorium Joker",
                text = {
                    "Scored cards from {C:attention}2{} to {C:attention}9{}",
                    "have a {C:green}#1# in #2#{} chance",
                    "of changing ranks",
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
                    "with no chance of breaking",
                    "{C:green}#1# in #2#{} chance this card is",
                    "destroyed at end of {C:attention}round{}",
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
                    "gives {X:chips,C:white}X#1#{} Chips",
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
                    "{X:mult,C:white}X#2#{} Mult for",
                    "{C:attention}first{} hand of round",
                    "{C:inactive}(#1# slices left)"
                }
            },
            j_rgmc_house_of_cards = {
                name = "House of Cards",
                    text = {
                    {
                        "Gains {C:chips}+#1#{} Chips per played hand",
                        "{C:green}#2# in #3#{} chance to {C:red}reset{}",
                        "at {C:attention}end{} of Blind",
                        "{C:inactive}(Currently {C:chips}+#4#{C:inactive})"
                    },
                    {
                        "{C:red}Reset{} chance incrases by",
                        "#5# per used {C:red}discard{}"
                    }
                }
            },
            j_rgmc_cup_of_joeker = {
                name = "Cup O' Joeker",
                text = {
                    "If Blind is beaten",
                    "in {C:attention}first{} hand,",
                    "create a {C:attention}consumable{}"
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
                    "Each {C:attention}Knight{} held in hand",
                    "gives {X:chips,C:white}X#1#{} Chips"
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
                    "{X:mult,C:white}X#1#{} Mult against {C:attention}Big{} Blinds",
                    "Lose {X:mult,C:white}X#2#{} Mult",
                    "when Blind is {C:attention}skipped",
                    "({C:attention}#3#{})"
                },
            },
            j_rgmc_plentiful_ametrine = {
                name = "Plentiful Ametrine",
                text = {
                    "For each scored {C:rgmc_goblets}Goblet{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:mult}+#3# Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {C:mult}+#4# {C:inactive} Mult)"
                },
            },
            j_rgmc_toughened_shungite = {
                name = "Toughened Shungite",
                text = {
                    "For each scored {C:rgmc_towers}Tower{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:chips}+#3# Chips",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {C:chips}+#4# {C:inactive} Chips)"
                },
            },
            j_rgmc_jimbos_funeral = {
                name = "Jimbo's Funeral",
                text = {
                    "After playing {C:attention}final hand{},",
                    "convert all {C:red}Discards{} to {C:blue}Hands{}",
                    "{C:inactive}(Resets at end of Blind)"
                },
                quote = {
                    "Wearing all black for a reason",
                }
            },
            j_rgmc_quick_brown_fox = {
                name = "Quick Brown Fox",
                text = {
                    "Gains {C:chips}+#1#{} Chips for every unique",
                    "rank played this {C:attention}Ante",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                },
                quote = {
                    "I Hate This Joker :("
                }
            },
            j_rgmc_penrose_stairs = {
                name = "Penrose Stairs",
                text = {
                    "Each scored card has a {C:green}#1# in #2#{} chance",
                    "to increase in rank {C:attention}#3#{} times",
                    "{C:inactive}(e.g. 10 -> J)"
                },
            },
            j_rgmc_joker_squared = {
                name = "Joker Squared",
                text = {
                    "Each scored {C:attention}square number{} rank",
                    "gives {C:mult}+#1#{} Mult",
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
                    "gain {C:chips}+6{} Chips",
                    "{C:inactive,s:0.9}(Currently {C:chips,s:0.9}+#1#{C:inactive,s:0.9})"
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
                    '{C:rgmc_goblets}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_deceitful_joker = {
                name = "Deceitful Joker",
                text = {
                    'Played cards with',
                    '{C:rgmc_towers}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_barbershop_joker = {
                name = "Barbershop Joker",
                text = {
                    'Played cards with',
                    '{C:purple}#1#{} suit give',
                    '{C:mult}+#2#{} Mult when scored',
                    'Suit changes after each scored {C:attention}Hand{}'
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
                    "At end of Blind, apply {C:attention}random Edition",
                    "to {C:attention}#1#{} unscored card(s)",
                    "in {C:attention}winning{} hand",
                },
                idea = {"Caligula"},
            },
            j_rgmc_bluenana = {
                name = "Blue Java",
                text = {
                    "{X:chips,C:white}X#1#{} Chips",
                    "{C:green}#2# in #3#{} chance this card is",
                    "destroyed at end of {C:attention}round{}",
                },
            },
            j_rgmc_redd_dacca = {
                name = "Red Dacca",
                text = {
                    "{X:dark_edition,C:white}^#1#{} Mult",
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
                    "Each scored {C:attention}pentagonal number{} rank",
                    "gives {C:mult}+#1#{} Mult",
                },
            },
            j_rgmc_null_and_void = {
                name = "Null and Void",
                text = {
                    "Before scoring,",
                    "debuffs the next {C:attention}#1#{} Jokers(s)",
                    "to the right",
                },
            },
            j_rgmc_lady_liberty = {
                name = "Lady Liberty",
                text = {
                    "Upon playing first {C:attention}Hand{},",
                    "apply a {C:attention}Patina Seal{} to",
                    "{C:attention}first played card{}",
                },
            },
            j_rgmc_vari_seala = {
                name = "Vari-Seala",
                text = {
                    "Scoring cards with {C:attention}Seals{}",
                    "have a {C:green}#1# in #2#{} chance to",
                    "copy Seal(s) to {C:attention}#3#{} random played card(s){}"
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
                   "Gains {C:white,X:chips}X#1#{} Chips for",
                   "every {C:white,X:mult}X#2#{} Mult scored",
                   "{C:inactive,s:0.8}Disappears in {C:attention,s:0.8}#3# {C:inactive,s:0.7}round(s)"
                },
            },
            j_rgmc_three_trees = {
                name = "Three Trees",
                text = {
                    "If played hand contains",
                    "a {C:attention}light{} suit, a {C:attention}dark{} suit,",
                    "and a {C:attention}special suit{}, gives {X:mult,C:white}X3{} Mult",
                    "{C:inactive,s:0.7}(Requires at least three suits)"
                },
            },
            j_rgmc_shovel_joker = {
                name = "Shovel Joker",
                text = {
                    "Scored {C:attention}Knights{} with {C:attention}dark suits{}",
                    "give {C:mult}2X{} Mult",
                    "{C:inactive,s:0.7}({C:clubs}Clubs{}, {C:spades}Spades{}, etc.)"
                },
            },
            j_rgmc_rhodochrosite = {
                name = "Rhodochrosite",
                text = {
                    "Scored cards with #1 suit",
                    "give {C:mult}+#4#{} Mult / {C:chips}+#5#{} Chips if",
                    "played after #2# / #3#"
                },
            },
            j_rgmc_waveworx = {
                name = "Waveworx",
                text = {
                    "First hand of round",
                    "counts as {C:attention}Straight",
                },
            },
            j_rgmc_miracle_pop = {
                name = "Miracle Pop",
                text = {
                    "Gains {C:chips}+#3#{} / {C:chips}+#4#{} Chips per",
                    "scored #1# / #2#",
                    "When {C:attention}sold, distribute {C:chips}#5#{} chips{}",
                    "among {C:attention}#6#{} cards in {C:attention}hand",
                    "{C:inactive}(or {C:chips}+#7#{} {C:inactive}bonus chips)"
                },
            },
            j_rgmc_doom_bunny = {
                name = "Doom Bunny",
                text = {
                    "Scored {C:attention}Wild{} Cards change into",
                    "a {C:attention}random rank{} from the deck",
                    "(Copies {C:attention}Editions{} and {C:attention}Seals{})"
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
                    "{C:attention}Aces{} are considered as {C:attention}#1#{}",
                    "(Can count as either an",
                    "{C:attention}Ace{}, {C:attention}King{}, or {C:attention}Queen{}",
                    "depending on which has",
                    "{C:attention}fewest{} cards in deck",
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
                    "converted to {C:rgmc_goblets}Goblets",
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "per {C:attention}converted{} card",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive})"
                },
            },
            j_rgmc_legend_bobby = {
                name = "Bobby Khan",
                text = {
                    "Destroys scored {C:attention}light{} suit cards",
                    "Base {C:chips}chips{} are split between",
                    "all {C:attention}dark{} suit cards",
                    "{C:rgmc_towers}Towers{} gain #2#X value"
                },
            },
            j_rgmc_legend_lollipop = {
                name = "Retro Lollipop",
                text = {
                    { "Whenever a {C:attention}Food Joker{} gets a,",
                    "stat decrease, this {C:attention}Joker{} gains",
                    "the {C:green}inverse{} of its loss",
                    "{C:inactive}Applies to most Food Jokers{}" },
                },
            },
            j_rgmc_twinkle_of_contagion = {
                name = "Twinkle of Contagion",
                text = {
                    "Scoring cards with {C:attention}Editions{}",
                    "have a {C:green}#1# in #2#{} chance to",
                    "transfer Edition to a {C:attention}random played card{}",
                    "If no cards in deck have {C:attention}Polychrome{},",
                    "apply {C:attention}Polychrome{} to one base edition card"
                },
            },
            j_rgmc_conspiracy_wizard = {
                name = "Conspiracy Wizard",
                text = {
                    "A {C:attention}#3#{} rank gives {C:mult}+#1#{} Mult",
                    "A {C:attention}#4#{} suit gives {C:chips}+#2#{} Chips"
                },
            },
            j_rgmc_continuum = {
                name = "Continuum",
                text = {
                    "Scored {C:attention}8{}s {C:attention}retrigger{}",
                    "all previously scored cards"
                },
            },
            j_rgmc_six_shooter = {
                name = "Six Shooter",
                text = {
                    "{C:green}#1# in #2#{} chance for",
                    "each scored {C:attention}6{} to",
                    "get {C:red}shot{} and",
                    "give this {C:attention}Joker{} {C:chips}+#3#{} Chips}",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive})"
                },
            },
            j_rgmc_easter_egg = {
                name = "Easter Egg",
                text = {
                    "{C:attention}Sell this Joker to",
                    "apply {C:attention}random editions{}",
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
                        "{C:rgmc_gimmick,E:1}+#1#{} #2# / {C:rgmc_gimmick,E:1}+#3#{} #4#",
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
                    "{C:attention}#2#{} time(s)",
                    "{C:inactive}(Rank changes each round){}"
                },
            },
            j_rgmc_joker_in_binary = {
                name = "Joker In Binary",
                text = {
                    "Played {C:attention}1s{} and {C:attention}0s{}",
                    "give {C:chips}+#1#{} Chips when scored",
                },
            },
            j_rgmc_captain_viridian = {
                name = "Captain Viridian",
                text = {
                    "{C:rgmc_flipped}Flipped{} cards give",
                    "{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance to {c:rgmc_flipped}Flip{}",
                    "{C:attention}scoring{} cards on {C:attention}first{}",
                    "{C:blue}hand{} or {C:red}discard"
                },
            },
            j_rgmc_balutro = {
                name = "Balutro",
                text = {
                    "If all {C:attention}scored{} cards include",
                    "digits of {C:attention}1{}, {C:attention}2{}, or {C:attention}5{}",
                    "retrigger {C:attention}all{} cards"
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
                        "I am {C:money}$400,000{} in {C:red}dept{} to {C:attention}Clown College{}",
                    }
                },
            },
            j_rgmc_all_star_joker = {
                name = "All-Star Joker",
                text = {
                   "If ranks of scored cards equals {C:attention}#1#{},",
                   "gain {C:money}$#2#{} at end of round",
                   "for each {C:attention}Joker",
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
                    "This Joker gives {C:mult}+#1#{} Mult",
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
                name = "Nope Joker",
                text = {
                    "When {C:blue}playing{} or {C:red}discarding{},",
                    "{C:green}#1# in {} ({C:green}#2#{} / {C:green}#3#{}) chance to",
                    "gain / lose a {C:blue}hand{}/{C:red}discard{}"
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
                    '#2# suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_arrogant_joker = {
                name = "Arrogant Joker",
                text = {
                    'Played cards with',
                    '#2# suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_vibrant_tourmaline= {
                name = "Vibrant Tourmaline",
                text = {
                    "For each scored #1# card,",
                    "{C:green}#2# in #3#{} chance",
                    "this Joker gains {C:money}$#4#",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently gives",
                    "{C:money}$#5# {C:inactive} at end of round)"
                },
            },
            j_rgmc_obsidian_blade = {
                name = "Obsidian Blade",
                text = {
                    "For each scored #1# card,",
                    "{C:green}#2# in #3#{} chance",
                    "this Joker gains {X:mult,C:white}X#4#{} Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {X:mult,C:white}X#5# {C:inactive} Mult)"
                },
            },
            j_rgmc_jestrogen = {
                name = "Jestrogen",
                text = {
                    "{C:green}#1# in #2# chance for",
                    "each scored {C:attention}#3#{} to",
                    "gain {C:chips}+#4#{} bonus chips",
                    "and become an {C:attention}Immutable{} #5#",
                },
            },
            j_rgmc_radioactive_chinese = {
                name = "Radioactive Chinese?!?",
                text = {
                    "Provides a \"{C:rgmc_unusual,E:1}awesome {C:attention}treat{}\"",
                    "at start of Blind",
                    "{C:green}#2# in #3#{} chance to obtain a",
                    "{C:attention}negative{} effect",
                    "{C:inactive,s:0.7}({}{C:red}#1#{}{C:inactive} rounds remaining)"
                },
            },
            j_rgmc_sanguine = {
                name = "Sanguine",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "if hand contains a scoring",
                    "{C:rgmc_goblets}Goblet{} and {C:rgmc_daggers}Dagger{}"
                },
            },
            j_rgmc_stonebound = {
                name = "Stonebound",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "if hand contains a scoring",
                    "{C:rgmc_towers}Tower{} and {C:rgmc_blooms}Bloom{}"
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
                    "Scored {C:attention}Stone{} cards",
                    "give {C:mult}+#1#{} Mult",
                    "{C:green}#2# in #3#{} chance this card is",
                    "destroyed at end of {C:attention}round{}",
                },
            },
            j_rgmc_formation = {
                name = "The Formation",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                },
            },
            j_rgmc_penumbral = {
                name = "The Penumbral",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contains",
                    "a {C:rgmc_dark}Dark Spectrum#"
                },
            },
            j_rgmc_photovoltaic = {
                name = "The Photovoltaic",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contains",
                    "a {C:rgmc_light}Light Spectrum"
                },
            },
            j_rgmc_palette = {
                name = "The Palette",
                text = {
                    "{X:chips,C:white} X#1# {} Chips",
                    "if scoring hand contains",
                    "{C:attention}5{} unique {C:attention}enhancements",
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
                    },
                    { "\"Eureka Tary\"" }
                },
            },
            j_rgmc_microfiche = {
                name = "Microfiche",
                text = {
                    "This Joker gains {X:chips,C:white}X#1#{} Chips",
                    "for every scored rank under {C:attention}2{}",
					"{C:inactive,s:0.9}(Currently {X:chips,C:white}X#2#{C:inactive,s:0.9})"
                },
            },
            j_rgmc_squash_keychain = {
                name = "Squash Keychain",
                text = {
                    "Using a base edition {C:tarot}#1#{}",
                    "creates a {C:dark_edition}Negative{} copy",
					"{C:inactive,s:0.9}(Upon triggering, change target tarot)",
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
            j_rgmc_x_ray_vision = {
                name = "X-Ray Vision",
                text = {
                    "{C:green}#1# in #2# chance",
                    "for each {C:attention}card{} drawn to be",
                    "{C:rgmc_unusual,E:1}highest value{} card in your",
                    "remaining deck",
                    "{C:inactive}(Calculates enhancements, editions, etc.)"
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
                    "give {C:rgmc_mayhem}+#1#{} {C:rgmc_unusual,E:1}Mayhem{}",
                },
            },
            j_rgmc_liberty_bell = {
                name = "Liberty Bell",
                text = {
                    "Upon playing first {C:red}Discard{},",
                    "apply a {C:rgmc_bronze}Bronze Seal{} to",
                    "{C:attention}first discarded card{}",
                },
            },
            j_rgmc_chicken_jokey = {
                name = "Chicken Jokey!",
                text = {
                    "Every {C:attention}#1#{} Blinds, create",
                    "an {C:attention}Popcorn{C:inactive} (#2#/#1#)",
                    "with {C:attention}Perishable() sticker",
                    "{C:inactive}I... am Joker"
                },
            },
            j_rgmc_jegg_jarton = {
                name = "Jegg Jarton",
                text = {
                    "Every {C:attention}#1#{} Blinds, create",
                    "an {C:attention}Egg{C:inactive} (#2#/#1#)",
                    "with {C:attention}Perishable() sticker",
                    "{C:inactive}So much to do, so much to see!"
                },
            },
            j_rgmc_talking_bacteria_john = {
                name = "Talking Bacteria John",
                text = {
                    "At start of blind, {C:green}#1# in #2#",
                    "chance to {C:attention}copy{} a card",
                    "{C:inactive}A rather annoying pest."
                },
            },
            j_rgmc_meatball = {
                name = "Meatball",
                text = {
                    "{C:mult}+#1#{} Meat",
                    "{C:inactive}... what the hell is a \"Meat\"?"
                },
            },
            -- Finity compat
            j_rgmc_finity_blindfold = {
                name = "Beige Blindfold",
                text = {
                    "Skipping a Blind creates",
                    "{C:attention}#1#{} additional copies",
                    "Gains {C:attention}+#2#{} Power after",
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
            -- Cryptid compat
            j_rgmc_cry_thad= {
                name = "Thad",
                text = {
                    "{C:cry_epic}Force trigger{}",
                    "the {C:attention}leftmost{} Joker",
                    "{C:attention}#1#{} time(s)",
                },
            },
            j_rgmc_cry_doredom= {
                name = "Doredom",
                text = {
                    "{C:green}1 in 3{} chance to {C:cry_epic}force trigger{}",
                    "each Joker {C:inactive}(per Joker)",
                },
            },
            j_rgmc_cry_danvas = {
                name = "Demivas",
                text = {
                    "{C:cry_epic}Force trigger{} all Jokers to the left",
                    "once for {C:attention}every{} {C:red}Rare{} Joker",
                    "(or greater) to the right of this Joker",
                },
            },
            j_rgmc_cry_spolly_spoker = {
                name = "Spolly Spoker",
                text = {
                    "{C:rgmc_gimmick}Gimmick{} Jokers count as {c:cry_jolly}Jolly{}",
                    "{C:chips}+#1#{} Chips per {C:rgmc_gimmick}Gimmick{} Joker",
                },
            },
            j_rgmc_cry_spectrum_m = {
                name = "Spectru M",
                text = {
                    "If played hand contains a {C:planet}Spectrum",
                    "Retriggers all {c:cry_jolly}Jolly{} Jokers",
                },
            },
            j_rgmc_cry_madjong = {
                name = "Madjong Tile",
                text = {
                    "{C:green}#1# in #2# chance to create a",
                    "{c:cry_jolly}Jolly{} {c:rgmc_gimmick}Gimmick{} Joker",
                    "upon selecting blind",
                },
            },
            j_rgmc_cry_candy_mittles = {
                name = "Mittles",
                text = {
                    "When sold, adjacent {C:attention}Jokers{}",
                    "become {C:dark_edition}Disco{}",
                },
            },
            j_rgmc_cry_candy_warhead = {
                name = "Warhead",
                text = {
                    "For the next {C:attention}#1#{} rounds,",
                    "cards give {C:rgmc_mayhem}+#2#{} Mayhem",
                    "when {C:attention}retriggered{}",
                },
            },
            j_rgmc_cry_candy_fudgemallow = {
                name = "Fudgemallow",
                text = {
                    "Sell this card to",
                    "permanently gain {C:attention}+#1#{}",
                    "card voiding limit",
                    "{C:inactive}(Currently {C:attention}#2# {C:inactive}Voiding Limit{}",
                },
            },
            j_rgmc_cry_curse_mad = {
                name = "MAD!",
                text = {
                    "STOP POSTING ABOUT {C:red}OBELISK{}!!",
                    "I'M {C:blue}TIRED{} OF SEEING IT!!",
                    "MY {C:attention}FRIENDS{} ON {C:riftraft_void}VOID{} SEND ME {C:red}OBELISK{},",
                    "ON {C:attention}RIFT PACKS{} IT'S F***ING {C:red}OBELISK{}!"
                },
            },
            j_rgmc_cry_pcall  = {
                name = "PCALL()",
                text = {
                    "Instead of {C:cry_code}crashing{} and",
                    "other {C:red}crash{} instances",
                    "spawns a {C:rgmc_gimmick}SPAM!{}",
                },
            },
            j_rgmc_cry_cursed_orb  = {
                name = "Oops! All Orbs",
                text = {
                    "Every {C:attention}8{} Antes, replace{}",
                    "the Finisher {C:attention}Blind{} with",
                    "{C:cry_exotic}Obsidian Orb{}",
                    "{C:red}Self-Destructs{} upon defeating",
                    "{C:cry_exotic}Obsidian Orb{}",
                },
            },
            -- Rift-Raft
            j_rgmc_riftraft_17 = {
                name = "17",
                text = {
                    {
                        "This Joker gives {C:mult}+#1#{} Mult",
                        "per card {C:red}destroyed{}",
                        "in the {C:riftraft_void}Void",
                        "{C:inactive}(Currently {C:mult}+#2# {C:inactive} Mult)",
                    }
                },
            },
            j_rgmc_riftraft_invert = {
                name = "Invert",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance for {C:attention}consumables{},",
                        "upon {C:attention}, to create a {C:dark_edition}Negative{} copy",
                        "in the {C:riftraft_void}Void{}",
                        "{C:inactive}(Only applies to {C:riftraft_void}voidable{C:inactive}cards)",
                    }
                },
            },
            j_rgmc_riftraft_tardis = {
                name = "TARDIS",
                text = {
                    {
                        "{C:attention}+#1#{} Voiding Limit",
                        "{C:inactive}(Currently {C:attention}#2# {C:inactive}Voiding Limit{}",
                    },
                    {
                        "\"It's bigger on the inside.\""
                    }
                },
            },
            j_rgmc_riftraft_minus_world = {
                name = "Minus World",
                text = {
                    "{C:green}#1# in #2#{} chance for cards",
                    "{C:attention}drawn{} from the {C:riftraft_void}Void",
                    "to become {C:dark_edition}Glitched"
                },
            },
            j_rgmc_riftraft_memory_leak = {
                name = "Minus World",
                text = {
                    "Upon selecting Blind,",
                    "draw a random {C:dark_edition} card from",
                    "the {C:riftraft_void}Void",
                },
            },
            -- Vanilla modification?!
            j_seance_new = {
                name = "Séance",
                text = {
                    "If {C:attention}poker hand{} contains a",
                    "{C:attention}#1#{} or {C:attention}#2#{},",
                    "create a random {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)"
                }
            },
            j_four_fingers_new = {
                name = "Four Fingers",
                text = {
                    "All {C:attention}Flushes{},",
                    "{C:attention}Spectrums{}, and {C:attention}Straights{}",
                    "can be made with {C:attention}4{} cards"
                }
            },
        },
        Enhanced = {
			m_rgmc_ferrous = {
				name = "Ferrous Card",
				text = {
                    "{C:chips}+#1#{} bonus chips",
                    "Gains {C:chips}+#2#{} chips",
                    "if held in hand at",
                    "end of {C:attention}round{}",
				},
			},
			m_rgmc_wolfram = {
				name = "Wolfram Card",
				text = {
                    "{C:mult}+#1#{} bonus mult",
                    "Gains {C:mult}+#2#{} mult",
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
                    "No rank or suit",
                    "Card always scores",
                    "{C:purple}X#1#{} Score",
                    "when held in hand",
                    "When played in winning hand,",
                    "convert to {C:attention}Bismuth{}",
				},
			},
			m_rgmc_volatile = {
				name = "Volatile Card",
				text = {
                    "Card always scores",
                    "{X:purple,C:white}X#1# Score{}",
                    "{C:green}#2# in #3#{} chance to",
                    "destroy itself and adjacent cards",
                    "upon {C:blue}play{} or {C:red}discard{}",
				},
			},
			m_rgmc_bismuth = {
				name = "Bismuth Card",
				text = {
                    "Gains {C:attention}1{} of {C:attention}5{}",
                    "random powers at start of Blind",
				},
			},
			m_rgmc_quartz = {
				name = "Quartz Card",
				text = {
                    "Copies effects of",
                    "{C:attention}leftmost{} card in hand",
				},
			},
			m_rgmc_lazurite = {
				name = "Lazurite Card",
				text = {
                    "Copies rank and suit of",
                    "card to its {C:attention}right{}",
				},
			},
			m_rgmc_rutile = {
				name = "Rutile Card",
				text = {
                    "{C:money}+$#1#{} when {C:attention}scored",
                    "Gains {C:money}$#2#{} mult",
                    "if held in hand at",
                    "end of {C:attention}round{}",
                    "({C:green}#3# in #4#{} chance to",
                    "lose {C:money}$#5#{} of value",
                    "when {C:attention}scored)",
				},
			},
			m_rgmc_mythril = {
				name = "Mythril Card",
				text = {
                    "{C:green}#1# in #3#{} chance for",
                    "{X:chips,C:white}X#2#{} Chips",
                    "{C:green}#1# in #4#{} chance for",
                    "{X:chips,C:white}X#5#{} Chips",
				},
			},
			m_rgmc_pyrite = {
				name = "Pyrite Card",
				text = {
                    "{C:green}#1# in #2#{} chance to",
                    "increase {C:green}probability{}",
                    "by #3# for duration of {C:attention}Blind{}"
				},
			},
			m_rgmc_carbonado = {
				name = "Carbonado Card",
				text = {
                    "{X:dark_edition,C:white} ^#1# {} Mult",
                    "while this card",
                    "stays in hand.",
                    "{C:green}#2# in #3#{} chance to",
                    "destroy card at end of {C:attention}round{}",
				},
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
            c_rgmc_pikari = {
                name = "Pikari",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_suojata = {
                name = "Suojata",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_kukinta = {
                name = "Kukinta",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_veitsi = {
                name = "Veitsi",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_tyhja = {
                name = "Tyhjä",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_rigel_iv = {
                name = "Rigel IV",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_aquaworld = {
                name = "Aquaworld",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_prometheus_ix = {
                name = "Prometheus IX",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_tartarus_ii = {
                name = "Tartarus II",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_varakkis = {
                name = "Varakkis",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_jurassika = {
                name = "Jurassika",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_globulos = {
                name = "Globulos",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_xykulix = {
                name = "Xykulix",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_blue_moon = {
                name = "Blue Moon",
                text = {
					"({V:1}lvl.#6#{})({V:2}lvl.#7#{})({V:3}lvl.#8#{})({V:4}lvl.#8#{})",
					"Level up",
					"{C:attention}#1#{}, {C:attention}#2#{},",
					"{C:attention}#3#{}, and {C:attention}#4#{}",
                },
            },
            c_rgmc_blood_moon = {
                name = "Blood Moon",
                text = {
					"({V:1}lvl.#5#{})({V:2}lvl.#6#{})({V:3}lvl.#7#{})({V:4}lvl.#8#{})",
					"Level up",
					"{C:attention}#1#{}, {C:attention}#2#{},",
					"{C:attention}#3#{}, and {C:attention}#4#{}",
                },
            },
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
            c_rgmc_rocket = {
                name = "Rocket Ship",
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
                    "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
                    "per {C:attention}Planet{} Card used{}",
                    "this Ante",
                    "{C:inactive}(Currently {C:chips}+#3{C:inactive} and {C:mult}+#4{C:inactive})"
                },
            },
            c_rgmc_planet_terra = {
                name = "Terra",
                text = {
                    "Gives {C:attention}most played{} hand",
                    "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
                    "per {C:attention}Tarot{} Card used{}",
                    "this Ante",
                    "{C:inactive}(Currently {C:chips}+#3{C:inactive} and {C:mult}+#4{C:inactive})"
                },
            },
            c_rgmc_planet_luna = {
                name = "Luna",
                text = {
                    "Gives {C:attention}most played{} hand",
                    "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
                    "per {C:attention}Spectral{} Card used{}",
                    "this Ante",
                    "{C:inactive}(Currently {C:chips}+#3{C:inactive} and {C:mult}+#4{C:inactive})"
                },
            },
            c_rgmc_planet_sol_3 = {
                name = "Sol III",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_planet_lobster = {
                name = "Space Lobster",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_planet_nowhere = {
                name = "Nowhere.",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_planet_wormhole = {
                name = "Wormhole!",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_rgmc_planet_everywhere = {
                name = "Everywhere?!?",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
        },
		Sleeve = {
			sleeve_rgmc_pale_sleeve = {
				name = "Pale Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_pale_sleeve_alt = {
				name = "Pale Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_hexing_sleeve = {
				name = "Hexing Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_hexing_sleeve_alt = {
				name = "Hexing Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_sangria_sleeve = {
				name = "Sangria Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_sangria_sleeve_alt = {
				name = "Sangria Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_target_sleeve = {
				name = "Target Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_target_sleeve_alt = {
				name = "Target Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_micro_sleeve = {
				name = "Micro Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_micro_sleeve_alt = {
				name = "Micro Sleeve +",
				text = {
					"W.I.P.",
				},
			},
        },
        CosmaTarot = {
            c_rgmc_demise = {
                name = 'Demise',
                text = {
                    '???'
                }
            },
            c_rgmc_crow = {
                name = 'The Crow',
                text = {
                    '???'
                }
            },
            c_rgmc_swan = {
                name = 'The Swan',
                text = {
                    '???'
                }
            },
            c_rgmc_peacock = {
                name = 'The Peacock',
                text = {
                    '???'
                }
            },
            c_rgmc_pelican = {
                name = 'The Pelican',
                text = {
                    '???'
                }
            },
            c_rgmc_phoenix = {
                name = 'The Phoenix',
                text = {
                    '???'
                }
            },
            c_rgmc_soulmates = {
                name = 'The Soulmates',
                text = {
                    '???'
                }
            },
            c_rgmc_spirit_plane = {
                name = 'The Spirit Plane',
                text = {
                    '???'
                }
            },
            c_rgmc_orbs = {
                name = 'The Orbs',
                text = {
                    '???'
                }
            },
            c_rgmc_cosmic_tree = {
                name = 'The Cosmic Tree',
                text = {
                    '???'
                }
            },
            c_rgmc_life_map = {
                name = 'The Life Map',
                text = {
                    '???'
                }
            },
            c_rgmc_karma = {
                name = 'Karma',
                text = {
                    '???'
                }
            },
            c_rgmc_sacrifice= {
                name = 'Sacrifice',
                text = {
                    '???'
                }
            },
            c_rgmc_past_lives = {
                name = 'Past Lives',
                text = {
                    '???'
                }
            },
            c_rgmc_maze = {
                name = 'The Maze',
                text = {
                    '???'
                }
            },
            c_rgmc_vessel = {
                name = 'The Vessel',
                text = {
                    '???'
                }
            },
            c_rgmc_shore = {
                name = 'The Shore',
                text = {
                    '???'
                }
            },
            c_rgmc_veil = {
                name = 'The Veil',
                text = {
                    '???'
                }
            },
            c_rgmc_bridge = {
                name = 'The Bridge',
                text = {
                    '???'
                }
            },
            c_rgmc_pathways = {
                name = 'Pathways',
                text = {
                    '???'
                }
            },
            c_rgmc_unknown = {
                name = 'The Unknown',
                text = {
                    '???'
                }
            },
            c_rgmc_life_on_earth  = {
                name = 'Life on Earth',
                text = {
                    '???'
                }
            },
            c_rgmc_sleeping_ships = {
                name = 'Sleeping Ships',
                text = {
                    '???'
                }
            },
            c_rgmc_aversion = {
                name = 'Aversion',
                text = {
                    '???'
                }
            },

        },
        AntiSpectral = {
            c_rgmc_anti_familiar= {
                name = 'Familiar...?',
                text = {
                    "Destroys {C:red}#1#{} {C:attention}face{} cards",
                    "from your deck"
                }
            },
            c_rgmc_anti_grim= {
                name = 'Grim...?',
                text = {
                    "Destroys {C:red}#1#{} of",
                    "your highest rank",
                    "from your deck"
                }
            },
            c_rgmc_anti_incantation = {
                name = 'Incantation...?',
                text = {
                    "Destroys {C:red}#1#{} of your",
                    "{C:attention}lowest number{} rank",
                    "from your deck"
                }
            },
            c_rgmc_anti_talisman= {
                name = 'Incantation...?',
                text = {
                    "Disables blind rewards and",
                    "interest for {C:attention}#1#{} rounds",
                    "Gives {C:money}#2#{} afterwards",
                }
            },
            c_rgmc_anti_aura = {
                name = 'Aura...?',
                text = {
                    "Disables and debuffs editions",
                    "for {C:attention}#1#{} rounds",
                    "Gives {C:money}#2#{} for",
                    "each card debuffed",
                }
            },
            c_rgmc_anti_wraith = {
                name = 'Wraith...?',
                text = {
                    "Debuffs all {C:attention}Jokers{}",
                    "above {C:green}Uncommon{} rarity",
                    "Gives {C:money}#2#{} for",
                    "each Joker debuffed",
                }
            },
            c_rgmc_anti_sigil = {
                name = 'Sigil...?',
                text = {
                    "Destroys {C:red}#1#{} of",
                    "{C:attention}???{} {C:attention}suit{}",
                    "from your deck",
                }
            },
            c_rgmc_anti_ouija = {
                name = 'Ouija...?',
                text = {
                    "Destroys {C:red}#1#{} of",
                    "{C:attention}???{} {C:attention}rank{}",
                    "from your deck",
                }
            },
            c_rgmc_anti_ectoplasm = {
                name = 'Ectoplasm...?',
                text = {
                    "I forgot.",
                }
            },
            c_rgmc_anti_immolate = {
                name = 'Immolate...?',
                text = {
                    "Creates {C:attention}#1#{} {C:rgmc_stone}Stone{} cards",
                    "{C:money}-$#2#{}",
                }
            },
            c_rgmc_anti_ankh = {
                name = 'Ankh...?',
                text = {
                    "Creates an {C:attention}Eternal",
                    "{C:attention}Engraved{} copy of",
                    "a random held {C:attention}Joker{}",
                }
            },
            c_rgmc_anti_deja_vu = {
                name = 'Deja Vu...?',
                text = {
                    "Disables {C:attention}retriggering{}",
                    "for {C:attention}#1#{} rounds",
                    "Gain {C:money}$#2#{} afterwards",
                }
            },
            c_rgmc_anti_hex = {
                name = 'Hex...?',
                text = {
                    "Removes editions and",
                    "enhancements from",
                    "{C:attention}#1#{} cards",
                }
            },
            c_rgmc_anti_trance = {
                name = 'Trance...?',
                text = {
                    "Remove {C:attention}#1#{} levels",
                    "from {C:planet}#2#{}",
                    "Add {C:attention}#3{} levels to {C:planet}#1#{}",
                    "lowest scoring hands",
                }
            },
            c_rgmc_anti_medium = {
                name = 'Medium...?',
                text = {
                    "Disable {C:purple}consumables{}",
                    "for {C:attention}#1#{} rounds",
                    "{C:attention}+#2#{} consumable slots",
                    "afterwards",
                }
            },
            c_rgmc_anti_cryptid = {
                name = 'Cryptid...?',
                text = {
                    "{C:attention}+#1#{} Ante",
                    "{C:dark_edition}+#2#{} Joker slots",
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
                    "#1# in #2# chance to apply {X:edition}edition{}",
					"to #3# {C:attention}random{} cards"
                }
			},
			c_rgmc_fractal = { -- bismuth
				name = "Fractal",
                text = {
                    "#1# in #2# chance to apply {X:edition}edition{}",
					"to #3# {C:attention}random{} cards"
                }
			},
			c_rgmc_heaven = { -- heaven
				name = "Heaven",
                text = {
                    "#1# in #2# chance to apply {X:edition}edition{}",
					"to #3# {C:attention}random{} cards"
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
			c_rgmc_rot_heaven = { -- energium (copies leftmost card)
				name = "Heaven!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
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
                "Create an {X:rgmc_gimmick,C:black}?!? Tag{} for",
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
                "Adds {C:mayhem}+#5#{} Mayhem",
                "every {C:attention}#4#{} rounds",
                "this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_fake_orange = {
                name = "\"Orange\"",
                text = {
                "Create a {C:dark_edition}SPAM!{}",
                "card for every {C:attention}#4#{}",
                "rounds this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_imaginary = {
                name = "Imaginary",
                text = {
                "??? for",
                "every {C:attention}#4#{} rounds",
                "this has been held",
                "{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
                },
            },
            c_rgmc_atomic_tangerine = {
                name = "Atomic Tangerine",
                text = {
                "Create an {C:rgmc_gimmick}Gimmick Tag{} for",
                "every {C:attention}#4#{} rounds",
                "this has been held",
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
					"card#<s>1# in your hand",
                }
            },
            c_rgmc_reduct = {
                name = 'Reduct',
                text = {
					"Add a {C:rgmc_bronze}Bronze Seal{}",
					"to {C:attention}#1#{} selected",
					"card#<s>1# in your hand",
                }
            },
            c_rgmc_encore = {
                name = 'Encore',
                text = {
					"Add a {C:rgmc_jade}Jade Seal{}",
					"to {C:attention}#1#{} selected",
					"card#<s>1# in your hand",
                }
            },
            c_rgmc_reverb = {
                name = 'Reverb',
                text = {
					"Add an {C:rgmc_umber}Umber Seal{}",
					"to {C:attention}#1#{} selected",
					"card#<s>1# in your hand",
                }
            },
            c_rgmc_ember = {
                name = 'Ember',
                text = {
					"Add a {C:rgmc_cream}Ether Seal{}",
					"to {C:attention}#1#{} selected",
					"card#<s>1# in your hand",
                }
            },
            c_rgmc_chalice = {
                name = 'Chalice',
                text = {
                    "Converts all {C:hearts}Hearts{} and",
					"{C:diamonds}Diamonds{} in hand",
                    "to {C:rgmc_goblets}Goblets{}",
                }
            },
            c_rgmc_armoire = {
                name = 'Armoire',
                text = {
                    "Converts all {C:clubs}Clubs{} and",
					"{C:spades}Spades{} in hand",
                    "to {C:rgmc_towers}Towers{}",
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
            c_rgmc_madcrap = {
                name = 'Madcrap',
                text = {
                    "Converts all cards in hand",
                    "to {C:attention}2{}s, {C:attention}3{}s, {C:attention}4{}s, or {C:attention}5{}s"
                }
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
                    "next {Cattention}Boss Blind {C:dark_edition}SUPER HARD!{}",
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
                    "gain {C:rgmc_mayhem}+1{} Mayhem"
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
                    "create a {C:rgmc_cosmatarot}Cogito Tag{}",
                },
			},
			tag_rgmc_cogito = {
				name = "Cogito Tag",
				text = {
					"Gives a free {C:rgmc_cosmatarot}Cosma Pack",
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
			tag_rgmc_xchips = {
				name = "Chippy Tag",
				text = {
					"Gain {X:chips,C:white}X#1#{} Chips",
					"during the {C:attention}next blind{}"
				},
			},
			tag_rgmc_xmult = {
				name = "Multy Tag",
				text = {
					"Gain {X:mult,C:white}X#1#{} Mult",
					"during the {C:attention}next blind{}"
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
                    "make the next {Cattention}Boss Blind{}",
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
            tag_rgmc_target_mk1 = {
				name = "Reward Tag I",
				text = {
					"Gives a free",
					"{C:attention}R.G. Booster{}"
				},
			},
            tag_rgmc_target_mk2 = {
				name = "Reward Tag II",
				text = {
					"Gives a free",
					"{C:attention}Mega R.G. RGBooster{}"
				},
			},
            tag_rgmc_anti_target_mk1 = {
				name = "Punish AnTag I",
				text = {
					"At end of Blind,",
                    "create a random {C:attention}AnTag{}"
				},
			},
            tag_rgmc_anti_target_mk2 = {
				name = "Punish AnTag II",
				text = {
					"At end of Blind,",
                    "level down #1#,",
                    "random poker hands"
				},
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
					"for every {C:dark_edition}^#1#{} score",
					"above blind requirement",
                    "{C:inactive}(up to {C:attention}9{C:inactive} Rewards)"
				},
			},
            -- Common Jokers
			v_rgmc_everyman = {
				name = "Everyman",
				text = {
					"{C:blue}Common{} Jokers give...",
					"{X:purple,C:white}X#1#{} Score?"
				},
			},
			v_rgmc_exceptional = {
				name = "Exceptional",
				text = {
					"{C:blue}Common{} Jokers give...",
					"{X:purple,C:white}^#1#{} Score?!"
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
					"retriggers all {C:attention}scoring{} cards",
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
					"The game gets {C:rgmc_mayhem}madder{}...",
                    "({C:rgmc_mayhem}+#1#{} Mayhem)",
                    "{C:attention}+#2#{} Ante",
				},
			},
			v_rgmc_mindmelt = {
				name = "Mindmelt",
				text = {
					"Your mind begins to {C:rgmc_mayhem}melt{}...",
                    "({C:rgmc_mayhem}+#1#{} Mayhem)",
					"{C:attention}+#2#{} Ante",
				},
			},
            -- Void/Lantern suits
			v_rgmc_chiaroscuro = {
				name = "Chiaroscuro",
				text = {
					"{C:rgmc_voids}Void{} suits are",
                    "{C:attention}2X{} more likely",
                    "to appear"
				},
			},
			v_rgmc_tenebrism = {
				name = "Tenebrism",
				text = {
					"{C:rgmc_lanterns}Lantern{} suits are",
                    "{C:attention}4X{} more likely",
                    "to appear"
				},
			},
            -- Cosma Tarots
			v_rgmc_cosma_merchant = {
				name = "Cosmic Merchant",
				text = {
                    "{C:cosmatarot}Tarot{} cards",
                    "may appear in the {C:attention}Shop",
				},
			},
			v_rgmc_cosma_tycoon = {
				name = "Cosmic Tycoon",
				text = {
                    "After clearing a Boss Blind,",
                    "Add a {C:rgmc_cosmatarot}Cosma Pack{} to",
                    "the next {C:attention}Shop{}"
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
            -- Painted/Twinkling
			v_rgmc_brush_strokes = {
				name = "Brush Strokes",
				text = {
                    "Playing cards can",
                    "appear in shop with",
                    "{C:rgmc_unusual}Painted{} and {C:attention}Entropic{}"
				},
			},
			v_rgmc_little_star = {
				name = "Little Star",
				text = {
                    "{C:inactive}Twinkle, twinkle...{}",
                    "Playing cards can",
                    "appear in shop with",
                    "{C:rgmc_unusual}Twinkling{} and {C:attention}Entropic{}"
				},
			},
        },
        Other = {
			p_rgmc_cosma = {
				name = "Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_cosma_jumbo = {
				name = "Jumbo Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_cosma_mega = {
				name = "Mega Cosma Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_cosmatarot} Cosma Tarot{} cards",
				},
			},
			p_rgmc_cogito = {
				name = "Cogito Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_cosmatarot} Cosma Tarot{} card#<s>2#",
					"{s:0.8,C:inactive}(Generated by Jackpot Tag)",
				},
			},
			p_rgmc_reward_mk1 = {
				name = "Jumbo Reward Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_unusual} Rewards{}",
				},
			},
			p_rgmc_reward_mk2 = {
				name = "Mega Reward Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_unusual} Rewards{}",
				},
			},
			p_rgmc_ruinous_mk1 = {
				name = "Jumbo Ruinous Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:attention} Anti-Spectral{} cards",
                    "({C:attention}Unskippable{}!)",
				},
			},
			p_rgmc_ruinous_mk2 = {
				name = "Mega Ruinous Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:attention} Anti-Spectral{} cards",
                    "({C:attention}Unskippable{}!)",
				},
			},
			p_rgmc_chip_mult = {
				name = "Variety Pack: Red Pill, Blue Pill",
				text = {
					"There are two Jokers:",
                    "One boosts {C:chips}Chips{}",
                    "the other boosts {c:mult}Mult{}.",
                    "({C:attention}Unskippable{}!)",
				},
			},
			p_rgmc_revival = {
				name = "Variety Pack: Back From the Dead",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} {C:red}destroyed{}",
                    "(or {C:red}skipped{}) {C:attention}Jokers{}",
                    "/ {C:attention}consumeables {C:inactive}(must have room)",
				},
			},
			p_rgmc_food = {
				name = "Variety Pack: Just a Quick Bite...",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"delicious {C:dark_edition}Food {C:attention}Jokers",
                    "{C:inactive}(must have room)",
				},
			},
			p_rgmc_common = {
				name = "Variety Pack: Riff-Raff",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:blue}Common {C:attention}Jokers",
                    "{C:inactive}(must have room)",
				},
			},
			p_rgmc_misprint = {
				name = "Variety Pack: Factory Error",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:rgmc_mayhem}factory error {C:attention}Jokers",
                    "{C:inactive}(must have room)",
				},
			},
			p_rgmc_spam = {
				name = "Variety Pack: Oops! All SPAM",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}...",
					"{C:rgmc_gimmick}SPAM! Jokers? ... What.",
                    "Who approved this.",
                    "{C:inactive}(must have room)",
				},
			},
			p_rgmc_madcap_select = {
				name = "Variety Pack: Madcap Select",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:rgmc_mayhem}Madcap{} mod exclusives!",
                    "{C:inactive}(must have room)",
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
            rgmc_suit_info_void = {
				name = "Void Suit",
				text = {
					"{C:rgmc_mayhem}+#1#{} Mayhem",
					"when scored"
				},
            },
            rgmc_suit_info_lantern = {
				name = "Lantern Suit",
				text = {
					"{C:rgmc_mayhem}-#1#{} Mayhem",
					"when scored"
				},
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
					"{X:purple,C:white}X#1#{}... Score?"
				},
            },
            rgmc_chinese_effect9 = {
				name = "General Tsao's Chicken...?!",
				text = {
					"{X:purple,C:white}X#1#{}... Score?"
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
					"{X:purple,C:white}X#1#{} Score",
					"Otherwise,",
					"{X:purple,C:white}X#4#{} Score",
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

            -- Lollipop accumulate

            rgmc_accum_mult     = { name = "+Mult", text = { "{C:mult}+#1#{} Mult" } },
            rgmc_accum_chips    = { name = "+Chips", text = { "{C:mult}+#1#{} Chips" } },
            rgmc_accum_x_mult    = { name = "xMult", text = { "{X:mult,C:white}X#1#{} Mult" } },
            rgmc_accum_x_chips   = { name = "xChips", text = { "{X:chips,C:white}X#1#{} Chips" } },
            rgmc_accum_e_mult    = { name = "^Mult", text = { "{X:dark_edition,C:white}^#1#{} Mult" } },
            rgmc_accum_e_chips   = { name = "^Chips", text = { "{X:dark_edition,C:white}^#1#{} Chips" } },
            rgmc_accum_money    = { name = "$$$", text = {
                "Gain {C:money}$#1#{} at end of round"
            } },

            -- Sticker descriptions
			rgmc_shielded = {
				name = "Shielded",
				text = {
                    "Cannot be {C:attention}debuffed{} or {C:attention}destroyed{}",
                    "for {C:attention}#1#{} rounds",
                    "{C:inactive}({C:attention}#2#{C:inactive} remaining)"
				},
			},
			rgmc_painted = {
				name = "Painted",
				text = {
                    "Gains a random, immutable {C:attention}Enhancement{}",
                    "at start of {C:attention}Blind",
                    "{C:inactive}(Cannot change Enhancements)"
				},
			},
			rgmc_twinkling = {
				name = "Twinkling",
				text = {
                    "Removes {C:attention}Edition{} and {C:attention}this Sticker{}",
                    "at end of {C:attention}Blind",
                    "{C:inactive}(Cannot change Editions)"
				},
			},
			rgmc_engraved = {
				name = "Engraved",
				text = {
                    "Gives {C:red}no{} {C:chips}chips{} or {C:mult}mult",
                    "{C:inactive}({C:attention}#1#{C:inactive} round(s) remaining)"
				},
			},
			rgmc_bismuth_red = {
				name = "Bismuth - Red Frame",
				text = {
                    "???"
				},
			},
			rgmc_bismuth_yellow = {
				name = "Bismuth - Yellow Frame",
				text = {
                    "???"
				},
			},
			rgmc_bismuth_green = {
				name = "Bismuth - Green Frame",
				text = {
                    "???"
				},
			},
			rgmc_bismuth_blue = {
				name = "Bismuth - Blue Frame",
				text = {
                    "???"
				},
			},
			rgmc_bismuth_purple = {
				name = "Bismuth - Purple Frame",
				text = {
                    "???"
				},
			},
			rgmc_clowned = {
				name = "Clowned",
				text = {
                    "Gives its parent {C:attention}Joker",
                    "{C:chips}+20{} Chips when card is played",
                    "Takes {C:chips}-15{} Chips",
                    "from parent {C:attention}Joker",
                    "if {C:blue}drawn{} and {C:red}not{} played",
				},
			},
            rgmc_bronze_seal = {
				name = "Cuprum Seal",
				text = {
					"This card is placed closer",
					"to {C:attention}rear of deck{}"
				},
			},
            -- Seal descriptions
            rgmc_patina_seal = {
				name = "Patina Seal",
				text = {
					"This card is placed closer",
					"to {C:attention}front of deck{}"
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
                    "and scores, {C:attention}stays in hand and",
                    "scores {C:green}again{} next hand",
                    "{C:inactive}(Currently #1#!)"
                }
			},
            rgmc_accent_seal = {
				name = "Accent Seal",
				text = {
                    "If {C:attention}held{} in hand at end of round",
                    "levels up applicable {C:attention}subhands{}",
                    "of winning poker hand by {C:attention}1{}"
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
            rgmc_cream_seal = {
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
                    "create a {C:attention}#1#{}",
                }
			},
            rgmc_sunset_seal = {
				name = "Sunset Seal",
				text = {
                    "If {C:attention}held{} in hand at end of round",
                    "swap suits to #1#",
                    "{C:inactive}(Switches between light",
                    "and dark suits)",
                }
			},
            rgmc_midnight_seal = {
				name = "Midnight Seal",
				text = {
                    "If {C:attention}held{} in hand at end of round",
                    "swap suits to #1#",
                    "{C:inactive}(Switches between base",
                    "and new suits)",
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
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_traveller = {
                name = "Traveller",
                text = {
                    "Upon using a {C:planet}Planet{} cards",
                    "level up the last played",
                    "{C:attention}poker hand by #1# level(s)",
                    "{C:inactive}{Currently {C:attention}#2# {C:inactive})"
                },
                unlock = {
                    "???",
                },
            },
			pnr_rgmc_paschal = {
                name = "Paschal",
                text = {
                    "Upon selecting blind,",
                    "apply {C:dark_edition}random edition",
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
                    "{C:inactive}each Blind"
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
            ["rgmc_0"]          = "0",
            ["rgmc_0.5"]        = "Half",
            ["rgmc_1"]          = "1",
            ["rgmc_10.5"]       = "10 and a Half",
            ["rgmc_11"]         = "11",
            ["rgmc_12"]         = "12",
            ["rgmc_13"]         = "13",
            ["rgmc_14"]         = "14",
            ["rgmc_15"]         = "15",
            ["rgmc_16"]         = "16",
            ["rgmc_20"]         = "20",
            ["rgmc_21"]         = "21",
            ["rgmc_24"]         = "24",
            ["rgmc_25"]         = "25",
            ["rgmc_32"]         = "32",
            ["rgmc_64"]         = "64",
            ["rgmc_128"]        = "128",
            ["rgmc_Knight"]     = "Knight",
            ["rgmc_x"]          = "X",
            ["rgmc_Sum"]        = "Sum",
            ["rgmc_Infinity"]   = "Infinity",
        },
		dictionary = {
            rgmc_patina_seal         = "Patina Seal",
            rgmc_bronze_seal         = "Cuprum Seal",
            rgmc_cream_seal          = "Ether Seal",
            rgmc_umber_seal          = "Umber Seal",
            rgmc_jade_seal           = "Jade Seal",
            rgmc_cherry_seal         = "Cherry Seal",

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

			-- temp hand/discard
			rgmc_temp_hand_plus          = "+1 Temp. Hand",
			rgmc_temp_discard_plus       = "+1 Temp. Discard",
			rgmc_temp_hand_minus_ex      = "Temp. Hand Used!",
			rgmc_temp_discard_minus_ex   = "Temp. Discard Used!",

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

            rgmc_compat_cryptid     = "+ Cryptid!",
            rgmc_compat_finity      = "+ Finity!",

            -- text
            rgmc_spam               = "SPAM",
            rgmc_maps               = "MAPS",
            rgmc_spam_ex            = "SPAM!",
            rgmc_spam_deathex       = "ONOS!",

            -- planets
            rgmc_rocket             = "Space Vehicle",
            rgmc_space_lobster      = "Boss Spacecraft",
            rgmc_planet_alt         = "Alt. Reality Planet",
            rgmc_anomality          = "Anomality",

            -- subhands
            ml_sh_light             = "Light",
            ml_sh_dark              = "Dark",
            ml_sh_high              = "High",
            ml_sh_low               = "Low",

            -- Rarities
			k_cry_epic       = "Epic",
			k_cry_exotic     = "Exotic",
			k_cry_candy      = "Candy",
			k_cry_cursed     = "Cursed",
			k_rgmc_unusual   = "Unusual",
			k_rgmc_gimmick   = "Gimmick",
			k_rgmc_chaotic   = "Chaotic",
			k_rgmc_felinus   = "Felinus",
			k_cosmatarot             = "Cosma Tarot",
			k_antispectral           = "Anti-Spectral Tarot",
			b_cosmatarot_cards       = "Cosma Tarots",
			b_antispectral_cards     = "Anti-Spectral Tarots",


			k_rgmc_cosma_pack    = "Cosma Pack",
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
                "ascending quantity"
            },
            rgmc_pyramid_flush = {
                "Three or more groups of cards",
                "of descending rank,",
                "ascending quantity, and",
                "identical suit"
            },
            rgmc_pyramid_spectrum = {
                "Three or more groups of cards",
                "of descending rank",
                "and rank, containing five",
                "or more suits"
            },
            rgmc_blazer = {
                "5 face cards containing",
                "at least 3 unique ranks"
            },
            rgmc_blazer_flush = { -- not used
                "5 face cards",
                "of the same suit, containing",
                "at least 3 unique ranks",
            },
            rgmc_blazer_spectrum = { -- not used
                "5 face cards",
                "of different suits",
                "containing at least",
                "3 unique ranks",
            },
            rgmc_kaleidoscope = {
                "5 Bismuth Cards"
            },
            rgmc_pick_five = {
                "5 random ranks chosen",
                "at the start of each Ante"
            },
            rgmc_noak = {
                "5 cards of another poker hand",
                "whose cumulative rank equals 0"
            },
            rgmc_infoak = {
                "5 Infinity cards"
            },
            rgmc_infoak_flush = {
                "5 Infinity cards",
                "of the same suit"
            },
        },
        poker_hands= {
            rgmc_pyramid                    = "Pyramid",
            rgmc_pyramid_flush              = "Flush Pyramid",
            rgmc_pyramid_spectrum           = "Spectrum Pyramid",
            rgmc_spectrum_dark              = "Dark Spectrum",
            rgmc_spectrum_straight_dark     = "Dark Straight Spectrum",
            rgmc_spectrum_house_dark        = "Dark Spectrum House",
            rgmc_spectrum_five_dark         = "Dark Spectrum Five",
            rgmc_spectrum_light             = "Light Spectrum",
            rgmc_spectrum_straight_light    = "Light Straight Spectrum",
            rgmc_spectrum_house_light       = "Light Spectrum House",
            rgmc_spectrum_five_light        = "Light Spectrum Five",
            rgmc_blazer                     = "Blazer",
            rgmc_pick_five                      = "Pick 5",
            rgmc_kaleidoscope               = "Kaleidoscope",
            rgmc_noak                       = "None of a Kind",
            rgmc_noak_flush                 = "Flush None",
            rgmc_infoak                     = "Infinitum",
            rgmc_infoak_flush               = "Fluxus Infinitum",
        },
		labels = {
            rgmc_shielded           = "Shielded",
            rgmc_painted            = "Painted",
            rgmc_twinkling          = "Twinkling",
            rgmc_engraved           = "Engraved",
            rgmc_immutable          = "Immutable",
            rgmc_rand               = "Rand",
            rgmc_spatial            = "Spatial",
            rgmc_transient          = "Transient",
            rgmc_flippant           = "Flippant",
            rgmc_entropic           = "Entropic",
            rgmc_bismuth_red        = "Red (Bismuth)",
            rgmc_bismuth_yellow     = "Yellow (Bismuth)",
            rgmc_bismuth_green      = "Green (Bismuth)",
            rgmc_bismuth_blue       = "Blue (Bismuth)",
            rgmc_bismuth_purple     = "Purple (Bismuth)",
            rgmc_clown              = "Clowned",

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
			rgmc_bronze_seal    = "Bronze Seal",
			rgmc_jade_seal      = "Jade Seal",
			rgmc_umber_seal     = "Umber Seal",
			rgmc_cream_seal     = "Cream Seal",
			rgmc_cherry_seal    = "Patina Seal",
			rgmc_seafoam_seal   = "Bronze Seal",
			rgmc_sunset_seal    = "Sunset Seal",
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
		},
    },
}
