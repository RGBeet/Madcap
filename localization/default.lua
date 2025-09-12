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
                    "Start run with {C:attention}Echoes{} and {C:attention}Projection{}",
                    "{C:attention}-#1#{} hand size",
				},
			},
			b_rgmc_hexing = {
				name = "Hexing Deck",
				text = {
					"Start with {C:attention}Special{} suits",
					"Removes ranks {C:attention}2{} through {C:attention}5{}"
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
					"{C:blue}#2#{} play limit",
					"{C:attention}X#3#{} blind size"
				},
			},
			b_rgmc_giga = {
				name = "Giga Deck",
				text = {
					"{C:attention}+1#{} hand size",
					"{C:attention}+1#{} play limit",
					"{C:attention}X#3#{} blind size",
                    "Must play at least {C:attention}2{} cards"
				},
			},
			b_rgmc_cosmic = {
				name = "Cosmic Deck",
				text = {
					"???"
				},
			},
			b_rgmc_spatial = {
				name = "Cosmic Deck",
				text = {
					"???"
				},
			},
			b_rgmc_beetroot = {
				name = "Beetroot Deck",
				text = {
					"???"
				},
			},
			b_rgmc_argentum = {
				name = "Argentum Deck",
				text = {
					"???"
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
					"No words can describe the",
                    "madness contained within",
                    "the {C:rgmc_bismuth}Deck of Lunacy{}",
					"Combines most {C:attention}Vanilla{}",
                    "and {C:rgmc_madcap}Madcap{} mechanics{}",
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
					"Scored cards are {C:attention}",
                    "\"permanently\" debuffed{}",
					"Held cards at end of round",
                    "are {C:green}reset{}",
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
					"in a {C:chips}70{}-{C:mult}30{} split"
				},
			},
			e_rgmc_infernal = {
				name = "Infernal",
				text = {
					"{X:rgmc_xscore,C:white}X#1#{} Score",
					"{C:green}#2# in #3#{} chance to",
					"burn up upon",
                    "end of round"
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
					"or {X:money,C:white}X#6#{} Money",
				},
			},
			e_rgmc_galactic = {
				name = "Galactic",
				text = {
					"{C:chips}+#4#{} Chips",
                    "{C:inactive}(Gives {X:planet,C:white}0.5X{C:inactive} chip value times",
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
                    "{C:attention}#2#{} additional time(s)",
                    "Upon successful trigger,",
                    "change retrigger position"
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
                    "For each scored {C:rgmc_goblets}Goblet{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:mult}+#3#{} Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)"
                },
            },
            j_rgmc_toughened_shungite = {
                name = "Toughened Shungite",
                text = {
                    "For each scored {C:rgmc_towers}Tower{} card,",
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
                    "{C:attention}#2#{} time(s)",
                    "{C:inactive}(Rank changes each round){}"
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
                    "For each scored {V:1}#1#{} card,",
                    "{C:green}#2# in #3#{} chance",
                    "this Joker gains {C:money}$#4#",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently gives",
                    "{C:money}$#5#{C:inactive} at end of round)"
                },
            },
            j_rgmc_obsidian_blade = {
                name = "Obsidian Blade",
                text = {
                    "For each scored {V:1}#1#{} card,",
                    "{C:green}#2# in #3#{} chance",
                    "this Joker gains {X:mult,C:white}X#4#{} Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {X:mult,C:white}X#5# {C:inactive} Mult)"
                },
            },
            j_rgmc_jestrogen = {
                name = "Jestrogen",
                text = {
                    "If played hand contains a",
                    "{C:attention}#1#{} or {C:attention}#2#{}",
                    "{C:attention}retrigger{} all",
                    "scored {C:attention}#3#s",
                    "{C:attention}#4#{} time(s)"
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
                    "if played hand contains",
                    "a {C:rgmc_dark}Dark #2#"
                },
            },
            j_rgmc_photovoltaic = {
                name = "The Photovoltaic",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "if played hand contains",
                    "a {C:rgmc_light}Light #2#"
                },
            },
            j_rgmc_palette = {
                name = "The Palette",
                text = {
                    "{X:chips,C:white}X#1#{} Chips",
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
                    "apply a {C:rgmc_cuprum}Cuprum Seal{} to",
                    "{C:attention}first discarded card{}",
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
                    "If played hand contains",
                    "{C:attention}#1#{} or more unscoring cards",
                    "gain {C:money}$#2#",
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
                    "Rolls a {C:attention}D6{}",
                    "with values from",
                    "{C:attention}#1#{} through {C:attention}#2#",
                    "{C:mult}+(#3# × [D6]){} Mult"
                },
            },
            j_rgmc_whoopsie_doodles = {
                name = "Whoopsie Doodles!",
                text = {
                    "{s:0.8}There was a mixup at the",
                    "{C:blue,s:0.8}Mult{s:0.8} & {C:red,s:0.8}Chips{s:0.8} Factory!",
                    "{X:chips,C:white}X#1#{} Mult, {X:mult,C:white}X#2#{} Chips",
                    "{C:inactive({V:1}#3#{C:inactive} bites left)"
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
                    "retrigger the {C:attention}#2 {C:green}#3#{} times"
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
            j_rgmc_variegated = {
                name = "The Variegated",
                text = {
                    "{X:mult,C:white}X#1#{} Mult{}",
                    "per scored {C:rgmc_bismuth}Bismuth{} card",
                    "if hand contains at least",
                    "one {C:attention}other enhancement"
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
                    "Shops always have at least one {C:attention}Voucher{}",
                    "{C:rgmc_evil}+$#1#{} reroll cost"
                },
            },
            j_rgmc_action_replay = {
                name = "Action Replay",
                text = {
                    "When a card {C:attention}retriggers{}, this Joker",
                    "has a {C:green}#1# in #2#{} chance to",
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
                    "{X:mult,C:white}+#1#{} Mult",
                    "{C:green}#1# in #6#{} chance to",
                    "{C:rgmc_gimmick}1337{} the {C:attention}sausage{}",
                    "{C:inactive}Daddy, would you like",
                    "{C:inactive}some {C:attention}sausage{C:inactive}?"
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
                        "{X:dark_edition,C:white}^#1#{} Mult" 
                    },
                    { 
                        "Destroy a {C:attention}random{} card in",
                        "each {C:attention}played{} hand"
                    },
                    { 
                        "At end of {C:attention}Boss Blind{},",
                        "{C:rgmc_evil}destroy{} Joker to the left",
                        "If {C:red}no{} Joker is destroyed,",
                        "lose {C:dark_edition}-1{} Joker slot " 
                    },
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
            -- Redo
            j_8_ball = {
                name = "8-Ball",
                text = {
                    "{C:green}#1# in #2#{} chance for each",
                    "played {C:attention}#3#{} to create a",
                    "{C:tarot}Tarot{} card when scored",
                    "{C:inactive}(Must have room)"
                },
            },
            j_scholar = {
                name = "Scholar",
                text = {
                    "Played {C:attention}#1#s{}",
                    "give {C:chips}+#2#{} Chips",
                    "and {C:mult}+#3#{} Mult",
                    "when scored"
                }
            },
            j_sixth_sense = {
                name = "Sixth Sense",
                text = {
                    "If {C:attention}first hand{} of round is",
                    "a single {C:attention}#1#{}, destroy it and",
                    "create a {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)"
                }
            },
            j_superposition = {
                name = "Superposition",
                text = {
                    "Create a {C:tarot}Tarot{} card if",
                    "poker hand contains an",
                    "{C:attention}#1#{} and a {C:attention}#2#{}",
                    "{C:inactive}(Must have room)"
                }
            },
            j_baron = {
                name = "Baron",
                text = {
                    "Each {C:attention}#1#{}",
                    "held in hand",
                    "gives {X:mult,C:white}X#2#{} Mult",

                }
            },
            j_cloud_9 = {
                name = "Cloud 9",
                text = {
                    "Earn {C:money}$#1#{} for each",
                    "{C:attention}#2#{} in your {C:attention}full deck",
                    "at end of round",
                    "{C:inactive}(Currently {C:money}$#3#{}{C:inactive})"
                }
            },
            j_walkie_talkie = {
                name = "Walkie Talkie",
                text = {
                    "Each played {C:attention}#1#{} or {C:attention}#2#",
                    "gives {C:chips}+#3#{} Chips and", 
                    "{C:mult}+#4#{} Mult when scored"
                },
            },
            j_wee = {
                name = "Wee Joker",
                text = {
                    "This Joker gains",
                    "{C:chips}+#1#{} Chips for",
                    "each scored {C:attention}#2#",
                    "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
                },
                unlock = {
                    "Win a run in {E:1,C:attention}#1#",
                    "or fewer rounds"
                }
            },
            j_hit_the_road = {
                name = "Hit the Road",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "for every {C:attention}#2#{}",
                    "discarded this round",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)"
                },
                unlock = {
                    "Discard {E:1,C:attention}5",
                    "{E:1,C:attention}Jacks{} at the",
                    "same time"
                }
            },
            j_shoot_the_moon = {
                name = "Shoot the Moon",
                text = {
                    "Each {C:attention}#1#{}",
                    "held in hand",
                    "gives {C:mult}+#2#{} Mult",
                },
                unlock = {
                    "Play every {E:1,C:attention}Heart",
                    "in your deck in",
                    "a single round"
                }
            },
            j_triboulet = {
                name = "Triboulet",
                text = {
                    "Played {C:attention}#1#s{} and",
                    "{C:attention}#2#s{} each give",
                    "{X:mult,C:white}X#3#{} Mult when scored"
                },
                unlock = {
                    "{E:1,s:1.3}?????"
                }
            },
            -- More Fluff revisions
            j_mf_rosetinted = {
                name = "Rose-Tinted Glasses",
                text = {
                    "If {C:attention}first hand{} of round is",
                    "a single {C:attention}#1#{}, destroy it and",
                    "create a free {C:attention}Double Tag{}",
                }
            },
            j_mf_pixeljoker = {
                name = "Pixel Joker",
                text = {
                    "Played {C:attention}#1#s{}, {C:attention}#2#s{}",
                    "{C:attention}#3#s{} and {C:attention}#4#s{} each give",
                    "{X:mult,C:white}X#5#{} Mult when scored"
                },
            },
            j_mf_hallofmirrors = {
                name = "Hall of Mirrors",
                text = {
                    "{C:attention}+#1#{} hand size for",
                    "each {C:attention}#2#{} scored in",
                    "the current round",
                    "{C:inactive}(Currently {C:attention}+#3#{C:inactive} cards)"
                }
            },
            j_mf_jackofalltrades = {
                name = "Jack of All Trades",
                text = {
                    "Each {C:attention}#1#{} held",
                    "in hand gives {C:mult}+#2#{} Mult,",
                    "{C:chips}+#3#{} Chips, and {C:money}$#4#"
                },
            },
            j_mf_slotmachine = { 
                name = "Slot Machine",
                text = {
                    "{C:green}#1# in #2#{} chance to retrigger",
                    "scored {C:attention}#3#s{} {C:attention}#4#{} times",
                },
            },
            j_mf_bowlingball = {
                name = "Bowling Ball",
                text = {
                    "Played {C:attention}#1#s{}",
                    "give {C:chips}+#2#{} Chips",
                    "and {C:mult}+#3#{} Mult",
                    "when scored",
                    --art_credit("footlongdingledong"),
                }
            },
            -- All in Jest
            j_aij_atom = {
                name = "Atom",
                text = {
                    "If played hand is",
                    "a single {C:attention}#1#{},",
                    "level up {C:attention}#2#{} once",
                },
            },
            j_aij_nedda = {
                name = "Nedda",
                text = {
                    "{C:attention}#1#s{} held in hand",
                    "give {X:mult,C:white}X#2#{} Mult"
                },
                unlock = {
                    "?????"
                }
            },
            j_aij_silvio = {
                name = "Silvio",
                text = {
                    "Retrigger all {C:attention}#1#{}",
                    "once for each {C:attention}#2#{}",
                    "held in hand",
                },
                unlock = {
                    "?????"
                }
            },
            j_aij_soviet = { 
                name = "Soviet", 
                text = { 
                    "{C:mult}+#1#{} Mult if {C:attention}played hand{}",
                    "contains no {C:attention}Kings{}, {C:attention}Queens{},",
                    "or other {C:attention}\"Royal\"{} ranks"
                } 
            },
            j_aij_fatuus = {
                name = "Fatuus",
                text = {
                    'If first played hand of',
                    'round contains only {C:attention}Royal{} ranks,',
                    'apply a {C:blue}Blue Seal{}',
                    'to a random played card',
                },
            },
            j_aij_fou_du_roi = {
                name = "Fou du Roi",
                text = {
                    '{C:green}#1# in #2#{} chance to create a',
                    '{C:tarot}Tarot{} card if played hand',
                    'contains a {C:attention}Royal{} rank',
                    '{C:inactive}(Must have room)'
                },
                -- possible error: scored/played
            },
            j_aij_comedians_manifesto = { 
                name = "Comedian's Manifesto", 
                text = { 
                    "{C:attention}Royal{} ranks in",
                    "{C:attention}Standard Packs{} become",
                    "{C:attention}#1#s" 
                } 
            },
            j_aij_tetraphobia = {
                name = "Tetraphobia",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "per {C:attention}#2#{} discarded, resets",
                    "when a {C:attention}#2#{} is scored",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_aij_trypophobia = {
                name = "Trypophobia",
                text = {
                    "{C:mult}+#1#{} Mult if scored hand",
                    "contains only {C:attention}#2#s",
                    "and {C:attention}#3#s",
                },
            },
            j_aij_square_eyes = { 
                name = "Square Eyes", 
                text = {
                    "Scored {C:attention}#1#s{} and {C:attention}#2#s{}",
                    "give {C:mult}+#3#{} Mult",
                    "per {C:attention}#1#{} in played hand",
                    "and {C:mult}+#4#{} Mult",
                    "per {C:attention}#2#{} in played hand",
                } 
            },
            j_aij_lucky_seven = {
                name = "Lucky Seven",
                text = {
                    "Turn all scored",
                    "unenhanced {C:attention}#1#s{} into",
                    "{C:attention}Lucky Cards{}"
                },
            },
            j_aij_teeny_joker = {
                name = "Teeny Joker",
                text = {
                    "{C:chips}+#1#{} Chips if played hand",
                    "contains only {C:attention}#2#s{}",
                },
            },
            j_aij_mondrian_joker = {
                name = "Mondrian Joker",
                text = {
                    "{C:mult}+#1#{} Mult per {C:attention}#2#",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently{} {C:mult}+#3#{}{C:inactive} Mult)"
                },
            },
            j_aij_public_bathroom = {
                name = "Public Bathroom",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "per played {C:attention}#2#{} in a {C:attention}#3#{}",
                    "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)"
                },
            },
            j_aij_clowns_on_parade = {
                name = "Clowns on Parade",
                text = {
                    "This {C:attention}Joker{} gains {C:chips}+#1#{} Chips",
                    "if played hand contains",
                    "at least three {C:attention}#2#s{}",
                    "{C:inactive}(Currently{} {C:chips}+#3#{} {C:inactive}Chips){}"
                },
            },
            j_aij_hat_trick = { 
                name = 
                "Hat Trick", 
                text = { 
                    "Played {C:attention}#1#s{} give {C:mult}Mult{}",
                    "equal to the level of",
                    "{C:attention}#2#{}",
                    "when scored"
                } 
            },
            j_aij_flying_ace = {
                name = "Flying Ace",
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "per {C:attention}#2#{} of unique {C:attention}suit{}",
                    "scored this round",
                    "{C:inactive}(Currently{} {C:money}$#3#{}{C:inactive}){}"
                },
            },
            j_aij_tetrominoker = { 
                name = "Tetrominoker", 
                text = { 
                    "Scoring {C:attention}#1#s{} have a {C:green}#2# in #3#{}",
                    "chance to create a {C:attention}copy{}",
                    "of themselves" 
                } 
            },
            j_aij_angel_number = { 
                name = "Angel Number", 
                text = { 
                    "{C:attention}+#1#{} to all {C:green}listed",
                    "{C:green}probabilities{} for each {C:attention}#2#",
                    "scored this hand",
                    "{C:attention}Resets{} each hand",
                    "{C:inactive}(Currently{C:green}+#3#{C:inactive})"
                } 
            },
            j_aij_david = {
                name = "David",
                text = {
                    "This Joker gains {C:chips}+#1#{}",
                    "Chips if {C:attention}played hand{}",
                    "is only {C:spades}#4#{} {C:attention}#3#{}",
                    "{C:inactive}(Currently{} {C:chips}+#2#{C:inactive} Chips){}",
                },
            },
            j_aij_charles = {
                name = "Charles",
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{}",
                    "Mult if {C:attention}played hand{}",
                    "is only {C:hearts}#4#{} {C:attention}#3#{}",
                    "{C:inactive}(Currently{} {X:mult,C:white}X#2#{C:inactive} Mult){}",
                },
            },
            j_aij_cesar = {
                name = "Cesar",
                text = {
                    'Earn {C:money}$#1#{} at end of',
                    'round. Increases by {C:money}$#2#{}',
                    'if {C:attention}played hand{} is only',
                    '{C:diamonds}#4# {C:attention}#3#'
                },
            },
            j_aij_alexandre = {
                name = "Alexandre",
                text = {
                    "This Joker gains {C:mult}+#1#{}",
                    "Mult if {C:attention}played hand{}",
                    "is only {C:clubs}#4#{} {C:attention}#3#{}",
                    "{C:inactive}(Currently{} {C:mult}+#2#{C:inactive} Mult){}",
                },
            },
            j_aij_word_art = { 
                name = "Word Art", 
                text = { 
                    "{C:mult}+#1#{} Mult per {C:attention}letter{} rank",
                    "in played hand",
                    "{C:inactive,s:0.8}(e.g. Ace, King, Queen, Jack)"
                } 
            },
            j_aij_petrushka = {
                name = "Petrushka",
                text = {
                    "Gives {C:mult}+#1#{} Mult per",
                    "total {C:attention}nominal value{} of",
                    "all {C:attention}scored cards{}",
                    "{C:inactive}(A=14, K=13, Q=12, J=11)"
                },
            },
            j_aij_beanstalk = { 
                name = "Beanstalk", 
                text = { 
                    "{C:attention}#1#{} {C:attention}cannot{} be {C:red}debuffed",
                    "and {C:attention}always{} score" 
                } 
            },
            j_aij_mistigri = {
                name = "Mistigri",
                text = {
                    "{C:attention}+1{} hand size per {C:attention}#1#",
                    "{C:attention}#2#s{} held in hand"
                },
            },
            j_aij_taikomochi = { 
                name = "Taikomochi", 
                text = { 
                    "{C:attention}#2#s{} held in hand",
                    "give {C:chips}+#1#{} Chips"
                } 
            },
            -- Paperback
            j_paperback_jestrica = {
                name = "Jestrica",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "when a {C:attention}#2{} is scored",
                    "Resets if no {C:attention}#2#s{} are",
                    "scored in a round",
                    "(#4#)",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
                },
            },
            j_paperback_power_surge = {
                name = "Power Surge",
                text = {
                    "Played {C:attention}#1#s{} give",
                    "{X:mult,C:white}X#2#{} Mult when scored",
                    "{C:green}#3# in #4#{}",
                    "chance to {C:red}destroy{} a",
                    "card {C:attention}held in hand{}",
                }
            },
            j_paperback_emergency_broadcast = {
                name = "Emergency Broadcast",
                text = {
                    "Scored {C:attention}#1#s{} and {C:attention}#2#s{} give",
                    "{C:mult}+#3#{} Mult and {C:chips}+#4#{} Chips",
                },
            },
            j_paperback_one_sin_and_hundreds_of_good_deeds = {
                name = "One Sin and Hundreds of Good Deeds",
                text = {
                    "Scored {C:attention}#1#s{} and {C:attention}Rankless Cards{}",
                    "give {C:mult}+#2#{} Mult when scored",
                    "{C:inactive}''It feeds on evil''",
                },
            },
            j_paperback_one_sin_and_hundreds_of_good_deeds_fed = {
                name = "{C:red}One Sin and Hundreds of Good Deeds{}",
                text = {
                    "Scored {C:attention}#1#s{} and {C:attention}Rankless Cards{}",
                    "give {C:mult}+Mult{} for each",
                    "remaining card in deck when scored",
                    "{C:inactive}(Currently {C:mult}+#3#{}{C:inactive})",
                },
            },
            j_paperback_surfer = {
                name = "Surfer",
                text = {
                    "This Joker gains {C:chips}+#1#{} Chips",
                    "for every {C:attention}#2#{} held in hand",
                    "at {C:attention}end of round{}, and {C:chips}+#3#",
                    "Chips for every {C:attention}#2#{} scored",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive} chips)"
                }
            },
            j_paperback_plague_doctor = {
                name = "Plague Doctor",
                text = {
                    "If played hand is a #1#,",
                    "convert the scoring card into",
                    "an {C:attention}#2#{}. Each {C:attention}#2#{}",
                    "held in hand gives {X:mult,C:white}X#3#{} Mult"
                }
            },
            j_paperback_as_above_so_below = {
                name = "As Above, So Below",
                text = {
                    "Playing a five-card poker hand with an",
                    "{C:attention}#1#{} creates a {C:purple}Tarot{} card,",
                    "if poker hand also contains a {C:attention}#2#{}",
                    "create a {C:spectral}Spectral{} card instead",
                    "{C:inactive}(Must have room)"
                },
                unlock = {
                    "Play a {C:attention}Rapture{}"
                }
            },
            -- TOGA's Pack
			j_toga_winvista = {
				name = 'Windows Vista',
				text = {
					"If the played hand contains",
					"a single {C:attention}#1#{},",
                    "{C:red}destroy{} it and",
					"apply {C:dark_edition}#2#{} to",
					"a {C:attention}random{} Joker",
					"{C:inactive,s:0.8}(Ignores Jokers",
                    "{C:inactive,s:0.8}with {C:dark_edition,s:0.8}#3#{C:inactive,s:0.8} edition)",
				}
			},
			j_toga_win8 = {
				name = 'Windows 8',
				text = {
					"Played {C:attention}#1#s{} gain",
					"{C:attention}held in hand{}",
					"{X:mult,C:white}X#2#{} Mult"
				}
			},
			j_toga_y2kbug = {
				name = 'Y2K Bug',
				text = {
					"If the played hand contains a",
					"{C:attention}#1#{} and a {C:attention}#2#{}, scoring cards",
					"give {C:chips}+#3#{} Chips and {C:red}+#4#{} Mult",
					"{C:inactive,s:0.8}(Have you updated your system yet?){}",
				}
			},
			j_toga_mac_os_x = {
				name = 'Mac OS X',
				text = {
					"Held in hand {C:attention}#1#s{} and {C:attention}Xs{}",
					"give {X:chips,C:white}X#3#{} Chips"
				}
			},
			j_toga_solitairejoker = {
				name = 'Solitaire Joker',
				text = {
					"When playing a hand {C:attention}containing{} a {C:attention}#1#{},",
					"draw remaining {C:attention}#2#s{} in the deck to hand.",
					"Rank changes every round.",
					"{C:inactive,s:0.8}An Office regular.{}"
				}
			},
			j_toga_y2ksticker = {
				name = 'Y2K Sticker',
				text = {
					"{C:attention}#1#s{} are",
					"considered as",
					"{C:attention}face cards{}"
				}
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
                        "{C:mult}+4{} Mult",
                        "Counts as an {C:attention}#1#",
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
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_aquaworld = {
                name = "Aquaworld",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_prometheus = {
                name = "Prometheus IX",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_tartarus = {
                name = "Tartarus II",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_varakkis = {
                name = "Varakkis",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_jurassika = {
                name = "Jurassika",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_globulos = {
                name = "Globulos",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
                    }
                },
            },
            c_rgmc_xykulix = {
                name = "Xykulix",
                text = {
                    {
                        "{S:0.6}({S:0.6,V:1}lvl.#1#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#2#",
                        "{S:0.75,C:mult}+#3#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#4#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:2}lvl.#5#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#6#",
                        "{S:0.75,C:mult}+#7#{S:0.75} Mult and",
                        "{S:0.75,C:chips}+#8#{S:0.75} Chips",
                    },
                    {
                        "{S:0.6}({S:0.6,V:3}lvl.#9#{S:0.6}){S:0.75} Level up",
                        "{S:0.75,C:attention}#10# {C:inactive}Sub-Hand{}",
                        "{S:0.75,X:mult,C:white}X#11#{S:0.75} Mult and",
                        "{S:0.75,X:chips,C:white}X#12#{S:0.75} Chips",
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
			sleeve_rgmc_mayhem_sleeve = {
				name = "Sleeve of Mayhem",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_mayhem_sleeve_alt = {
				name = "Sleeve of Mayhem +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_capital_sleeve = {
				name = "Capital Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_capital_sleeve_alt = {
				name = "Capital Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_cross_sleeve = {
				name = "Cross Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_cross_sleeve_alt = {
				name = "Cross Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_merlot_sleeve = {
				name = "Merlot Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_merlot_sleeve_alt = {
				name = "Merlot Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_jumble_sleeve = {
				name = "Jumble Sleeve",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_jumble_sleeve_alt = {
				name = "Jumble Sleeve +",
				text = {
					"W.I.P.",
				},
			},
			sleeve_rgmc_mad_sleeve = {
				name = "Mad Sleeve",
				text = {
					"Adds {C:rgmc_unusual}Madcap{} deck features",
                    "regardless of Deck",
                    "{C:inactive}(Mayhem, music, etc.)"
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
                    "Gain {C:money}$#1#{} for every {C:attention}3{}",
                    "unique {C:attention}ranks{} in deck",
                    "and {C:money}$#2#{} for every {C:attention}2{}",
                    "unique {C:attention}suits{} in deck",
                    "{C:inactive}(Currently {C:money}$#3#{C:inactive})"
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
                    "Gain {C:rgmc_unusual,S:1}+#1#{} Mayhem",
                    "but {C:red}destroy{} {C:attention}#2#{} {C:attention}random{} Joker(s)",
                }
            },
            c_rgmc_past_lives = {
                name = 'Past Lives',
                text = {
                    "Creates a base",
                    "{C:attention}previously destroyed{} Joker",
                    "at the cost of {C:rgmc_unusual,E:1}-#1#{} Mayhem",
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
                    "{C:rgmc_mayhem,E:1}Mayhemize all values",
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
                name = 'Pathways',
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
                    "{C:rgmc_mayhem,E:1}Mayhemize{} its values",
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
                    "Destroys {C:red}#1#%{} of",
                    "your highest rank",
                    "from your deck",
                    "{C:inactive}(Will destroy {C:attention}#2#{C:inactive} #3#s)"
                }
            },
            c_rgmc_anti_incantation = {
                name = 'Incantation...?',
                text = {
                    "Destroys {C:red}#1#%{} of your",
                    "{C:attention}lowest{} number rank",
                    "from your deck",
                    "{C:inactive}(Will destroy {C:attention}#2#{C:inactive} #3#s)"
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
                    "for {C:attention}#1#{} round(s)",
                    "Gives {C:money}+#2#{} for",
                    "each Joker debuffed",
                }
            },
            c_rgmc_anti_sigil = {
                name = 'Sigil...?',
                text = {
                    "Chooses a random {C:attention}suit{}",
                    "from your deck and",
                    "destroys {C:red}#1#%{} of cards",
                    "matching selected suit"
                }
            },
            c_rgmc_anti_ouija = {
                name = 'Ouija...?',
                text = {
                    "Chooses a random {C:attention}rank{}",
                    "from your deck and",
                    "destroys {C:red}#1#%{} of cards",
                    "matching selected rank"
                }
            },
            c_rgmc_anti_ectoplasm = {
                name = 'Ectoplasm...?',
                text = {
                    "Debuffs {C:red}#1#{} random Jokers",
                    "for {C:attention}#1#{} round(s)",
                    "Gain {C:attention}+1{} hand size",
                    "afterwards"
                }
            },
            c_rgmc_anti_immolate = {
                name = 'Immolate...?',
                text = {
                    "Creates {C:attention}#1#{} {C:rgmc_vino}Vino{} cards",
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
                    "Removes {C:attention}editions{} and",
                    "{C:attention}enhancements{} from",
                    "{C:attention}all{} cards in deck",
                    "Gain {C:money}$#2#{} per {C:orange}edition{}",
                    "and {C:money}$#3#{} per {C:orange}enhancement{}",
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
                    "#1# in #2# chance to",
                    "apply random {X:dark_edition}edition{}",
					"to #3# {C:attention}random{} cards",
                    "in hand"
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
                name = 'Ember',
                text = {
					"Add a {C:rgmc_ether}Ether Seal{}",
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
                name = 'Duality',
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
            c_rgmc_conundrum = {
                name = 'Conundrum',
                text = {
					"Apply {C:dark_edition}Flipped{} edition",
					"to {C:attention}#1#{} selected",
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
            c_rgmc_magnify = {
                name = 'Magnify',
                text = {
                    "Multiply {E:1,C:rgmc_bismuth}all values{}",
                    "of a random {C:attention}Joker",
                    "by {C:purple}X#1#{}",
                    "{C:dark_edition}-#2#{} Joker slot{C:inactive}(s)"
                }
            },
            c_rgmc_shadow = {
                name = 'Shadow',
                text = {
                    "Summon a random",
                    "{C:eternal}Eternal{} Joker",
                    "{C:dark_edition}+#2#{} Joker slot{C:inactive}(s)"
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
            c_rgmc_voyage = {
                name = 'Voyage',
                text = {
                    "Adds a {C:attention}discounted",
                    "{C:spatiaplanet}Subhand{} voucher",
                    "to the next shop"
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
                    "create a {C:cosmatarot}Cogito Tag{}",
                },
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
            tag_promotion = {
                name = "Promotion Tag",
                text = {
                    "After defeating",
                    "the Boss Blind,",
                    "gain {C:rgmc_luxury}£#1#"
                }
            },
            tag_twofer = {
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
					"{C:inactive}The game gets madder...",
				},
			},
			v_rgmc_mindmelt = {
				name = "Mindmelt",
				text = {
                    "{C:rgmc_mayhem}+#1#{} Mayhem",
					"{C:attention}+#2#{} Ante",
					"{C:inactive}Your mind begins to melt...",
				},
			},
			v_rgmc_joker = {
				name = "Joker",
				text = {
                    "{C:mult}+#1#{} Mult{C:inactive}...?"
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
            -- Light/Dark
			v_rgmc_day_and_night = {
				name = "{C:rgmc_light}Day{} and {C:rgmc_dark}Night{}",
				text = {
                    "Hands can now gain additional",
                    "{C:chips}Chips{} and {C:mult}Mult{} from",
                    "{C:rgmc_light}Light{} and {C:rgmc_dark}Dark{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing {C:rgmc_light}Light{C:inactive}/{C:rgmc_dark}Dark{C:inactive} suits)"
				},
			},
			v_rgmc_midday = {
				name = "{C:rgmc_light}Midday",
				text = {
                    "Boosts the power of",
                    "{C:rgmc_light}Light{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing {C:rgmc_light}Light{C:inactive} suits)"
				},
			},
			v_rgmc_midnight = {
				name = "{C:rgmc_dark}Midnight",
				text = {
                    "Boosts the power of",
                    "{C:rgmc_dark}Dark{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing {C:rgmc_dark}Dark{C:inactive} suits)"
				},
			},
			v_rgmc_twilight = {
				name = "{C:rgmc_light}Twil{C:rgmc_dark}ight",
				text = {
                    "Further empowers",
                    "{C:attention}Light{} and {C:attention}Dark{} sub-hands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing {C:rgmc_light}Light{C:inactive}/{C:rgmc_dark}Dark{C:inactive} suits)"
				},
			},
            -- High/Low
			v_rgmc_ebb_and_flow = {
				name = "Ebb and Flow",
				text = {
                    "Hands can now gain additional",
                    "{C:chips}Chips{} and {C:mult}Mult{} from",
                    "{C:attention}High{} and {C:attention}Low{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing ranks",
                    "{C:attention}above #2#{C:inactive}/{C:attention}below #3#{C:inactive})"
				},
			},
			v_rgmc_eensy_weensy = {
				name = "Eensy Weensy",
				text = {
                    "Boosts the power of",
                    "{C:attention}Low{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing ranks",
                    "{C:attention}below #2#{C:inactive})"
				},
			},
			v_rgmc_extra_large = {
				name = "Extra Large",
				text = {
                    "Boosts the power of",
                    "{C:attention}High{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing ranks {C:attention}above #2#{C:inactive})"
				},
			},
			v_rgmc_median = {
				name = "The Median",
				text = {
                    "Further empowers",
                    "{C:attention}High{} and {C:attention}Low{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing ranks",
                    "{C:attention}above #2#{C:inactive}/{C:attention}below #3#{C:inactive})"
				},
			},
            -- Dazzling
			v_rgmc_radiance = {
				name = "Radiance",
				text = {
                    "Hands can now gain",
                    "additional {C:chips}Chips{} and {C:mult}Mult",
                    "from {C:rgmc_bismuth}Dazzling{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing {C:rgmc_bismuth}unique",
                    "{C:inactive} enhancements"
				},
			},
			v_rgmc_brilliance = {
				name = "Brilliance",
				text = {
                    "Boosts the power of",
                    "from {C:rgmc_bismuth}Dazzling{} subhands",
                    "{C:inactive}(At least {C:attention}#1#{C:inactive} cards",
                    "{C:inactive}containing {C:rgmc_bismuth}unique",
                    "{C:inactive} enhancements"
				},
			},
            -- AnTags
			v_rgmc_antimony = {
				name = "Antimony",
				text = {
                    "{C:red}AnTags{} have a",
                    "{C:green}#1# in #2#{} chance",
                    "to give {C:money}$#3#",
                    "upon {C:attention}activation{}"
				},
			},
			v_rgmc_antiquated = {
				name = "Antiquated",
				text = {
                    "{C:red}AnTags{} have a",
                    "{C:green}#1# in #2#{} chance",
                    "to spawn their {C:attention}counterpart{}",
                    "upon {C:attention}activation{}"
				},
			},
            -- Void and Lantern Suits
			v_rgmc_irregularity = {
				name = "Irregularity",
				text = {
                    "{C:rgmc_voids}Void{} and {C:rgmc_lanterns{}Lantern{} suits",
                    "appear {C:attention}#1#X{} more frequently"
				},
			},
			v_rgmc_voidup = {
				name = "Void Power",
				text = {
                    "{C:rgmc_voids}Voids{} are considered {C:attention}Dark{}",
                    "and add {C:dark_edition}X#1#{} Mayhem"
				},
			},
			v_rgmc_lanternup = {
				name = "Lantern Power",
				text = {
                    "{C:rgmc_lanterns}Lanterns{} are considered {C:attention}Light{}",
                    "and remove {C:dark_edition}X#1#{} Mayhem"
				},
			},
			v_rgmc_light_within_darkness = {
				name = "Light Within Darkness",
				text = {
                    "Further empowers the",
                    "{C:rgmc_voids}Void{} and {C:rgmc_lanterns}Lantern{}",
                    "suits"
				},
			},
            -- Rift Limit (Rift-Raft exclusive!)
			v_rgmc_raise_the_rift = {
				name = "Raise the Rift",
				text = {
                    "{C:dark_edition}+#1#{} Rifting Limit",
                    "{C:red}-#2#{} discard(s) each round",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive} cards per Blind)",
				},
			},
			v_rgmc_oculus_rift = {
				name = "Oculus Rift",
				text = {
                    "{C:dark_edition}+#1#{} Rifting Limit",
                    "{C:blue}-#1#{} discard(s) each round",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive} cards per Blind)",
				},
			},
            -- Event Passes
			v_rgmc_event1 = {
				name = "Absolute Mayhem",
				text = {
                    "Invokes {C:dark_edition}Stage 1{}",
                    "{C:inactive}(Buyer beware!!)",
				},
			},
			v_rgmc_event2 = {
				name = "Amorphous Maelstrom",
				text = {
                    "Invokes {C:dark_edition}Stage 2{}",
                    "{C:inactive}(Buyer beware!!)",
				},
			},
        },
        Other = {
			p_rgmc_cosma_normal = {
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
			p_rgmc_spatia_normal = {
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
					"{C:attention}#2#{C:rgmc_antispectral} Sinister{} Cards",
                    "({C:attention}Unskippable{}!)",
				},
			},
			p_rgmc_ruinous_mk2 = {
				name = "Mega Ruinous Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:rgmc_antispectral} Sinister{} Cards",
                    "({C:attention}Unskippable{}!)",
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
			p_rgmc_factory_error = {
				name = "Factory Error",
				text = {
					"Choose {C:attention}#1#{} of up to {C:attention}#2#{}",
					"{C:rgmc_mayhem, E:1}Factory Error {C:attention}Jokers",
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

            -- Sticker descriptions
			rgmc_shielded = {
				name = "Shielded",
				text = {
                    "Cannot be {C:attention}debuffed{} or {C:attention}destroyed{}",
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
                    "Upon removing sticker,",
                    "Remove {C:dark_edition}edition{}",
                    "{C:inactive}({C:attention}#2#{C:inactive} remaining)",
				},
			},
			rgmc_engraved = {
				name = "Engraved",
				text = {
                    "Gives {C:red}no{} {C:chips}chips{} or {C:mult}mult",
                    "{C:inactive}({C:attention}#1#{C:inactive} round(s) remaining)"
				},
			},
			rgmc_immutable = {
				name = "Immutable",
				text = {
                    "Cannot change {C:attention}rank{}"
				},
			},
			rgmc_positive = {
				name = "Positive",
				text = {
                    "{C:attention}-1{} hand size"
				},
			},
			rgmc_bismuth_red = {
				name = "{C:red}Red{} Frame",
				text = {
                    "{C:mult}+#1#{} Mult"
				},
			},
			rgmc_bismuth_yellow = {
				name = "{C:gold}Gold{} Frame",
				text = {
                    "Earn {C:gold}#$1#{}",
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
			rgmc_bismuth_blue = {
				name = "{C:blue}Blue{} Frame",
				text = {
                    "{C:chips}+#1#{} Chips"
				},
			},
			rgmc_bismuth_purple = {
				name = "{C:purple}Purple{} Frame",
				text = {
                    "{X:rgmc_xscore, C:white}X#1#{} Score",
                    "at {C:attention}end{} of scoring"
				},
			},
			rgmc_clown = {
				name = "spr_clown",
				text = {
                    "{C:attention}IF{} caught {C:attention}THEN{}",
                    "chips {C:chips}+= 60{}",
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
            rgmc_patina_seal         = "Patina Seal",
            rgmc_cuprum_seal         = "Cuprum Seal",
            rgmc_ether_seal          = "Ether Seal",
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
            rgmc_anomality          = "Anomality?!",
            rgmc_moon               = "Moon",
            rgmc_emp_crystal        = "Empowered Crystal",

            -- subhands
            ml_sh_light             = "Light",
            ml_sh_dark              = "Dark",
            ml_sh_balanced          = "Neutral",
            ml_sh_enhanced          = "Dazzling",
            ml_sh_high              = "High",
            ml_sh_low               = "Low",

            k_mission_accomplished  = "Mission Accomplished!",
            k_mission_in_progress   = "Mission in Progress...",
            k_mission_failed        = "Mission Failed...",

            k_costs                 = "Costs",
            k_luxury_pts            = "Luxury Points",
            ['£']                   = '£',

            -- Rarities
			k_rgmc_unusual   = "Unusual",
			k_rgmc_gimmick   = "Gimmick",
			k_rgmc_chaotic   = "Chaotic",
			k_rgmc_felinus   = "Felinus",

            
			k_rgmc_luxury_bonus      = "Luxury Bonus",

			k_cosmatarot             = "Cosma Tarot",
			b_cosmatarot_cards       = "Cosma Tarots",
			k_spatiaplanet           = "Spatia Planet",
			b_spatiaplanet_cards     = "Spatia Planets",
			k_antispectral           = "Sinister Card",
			b_antispectral_cards     = "Sinister Cards",
			k_potentiacrystal        = "Potentia Crystal",
			b_potentiacrystal_cards  = "Potentia Crystals",

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
            rgmc_blazer                     = "Blazer",
            rgmc_pick_five                  = "Pick 5",
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
			rgmc_cuprum_seal    = "Cuprum Seal",
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
