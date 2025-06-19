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
					"Start run with {C:attention}26 {C:rgmc_goblets}Goblets",
					"and {C:attention} 26 {rgmc_towers}Towers in deck"
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
					"Played cards are {C:rgmc_evil}permanently debuffed{}",
					"Held cards at end of round are {C:green}reset{}",
					"{C:attention}+#1#{} hand size"
				},
			},
			b_rgmc_capital = {
				name = "Capital Deck",
				text = {
                    "Start with {C:money}$#1#{} (Greed is good!)",
					"{C:attention}Boss Blinds{} reward {X:money,C:white}X#2{} Money",
					"{C:attention}Blinds{} and {C:attention}Shops{}",
					"cost {C:money}$#3#{} and {C:money}$#4#{} to enter",
					"If you go {C:red}bankrupt{}, you {C:rgmc_evil}lose{}!"
				},
			},
			b_rgmc_communist = {
				name = "Communist Deck",
				text = {
                    "{C:money}Money{}? {C:attention}No{}, comrade.",
                    "All items are {C:money}free{}, but greed",
                    "is swiftly {C:rgmc_evil}punished{}",
				},
			},
        },
        Edition = {
			e_rgmc_iridescent = {
				name = "Iridescent",
				text = {
					"Redistributes {C:chips}chips{} and {C:mult}",
					"in a 70-30 split"
				},
			},
			e_rgmc_infernal = {
				name = "Infernal",
				text = {
					"{X:purple,C:white}X#1#{}... Score?",
					"{C:green}#2# in #3#{} chance to",
					"burn up upon end of round"
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
			e_rgmc_phasing= {
				name = "Phasing",
				text = {
					"?!?",
				},
			},
			e_rgmc_galactic = {
				name = "Galactic",
				text = {
					"When triggered, apply",
					"{C:attention}#1#{} level(s) to a",
					"random hand type"
				},
			},
			e_rgmc_abyssal = {
				name = "Abyssal",
				text = {
					"Gives {X:mult,C:white}X#1#{} Mult per Chaos",
					"{C:inactive,s:0.9}(Currently {X:mult,C:white}X#2#{C:inactive,s:0.9})"
				},
			},
			e_rgmc_luxury = {
				name = "Luxury",
				text = {
					"Upon trigger, add {C:attention}1{} slot",
					"to next shop",
					"Takes {C:money}$#1#{} at end of round",
				},
			},
			e_rgmc_flipped= {
				name = "Flipped",
				text = {
					"{C:chips}+1{} Chips",
					"Counts as a {C:attention}Flipped{} card"
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
                    "in {C:attention}1{} hand,",
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
                    "{C:inactive,s:0.7}({C:clubs}Clubs, Spades, etc.)"
                },
            },
            j_rgmc_rhodochrosite = {
                name = "Rhodochrosite",
                text = {
                    "Scored cards with {C:diamonds}Diamond{} suit",
                    "give {C:mult}+6{} Mult / {C:chips}+30{} Chips if",
                    "played after {C:clubs}Clubs{} / {C:spades}Spades{}"
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
                    "Gains {C:chips}+#1#{} / {C:chips}+#2#{} Chips per",
                    "scored {C:hearts}Hearts{} / {C:rgmc_goblets}Goblets{}",
                    "When {C:attention}sold, distribute {C:chips}#3#{} chips{}",
                    "among {C:attention}#4#{} cards in {C:attention}hand",
                    "{C:inactive}(or {C:chips}+#5#{} {C:inactive}bonus chips)"
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
                    "(Can count as either an {C:attention}Ace{}, {C:attention}King{}, or {C:attention}Queen{}",
                    "depending on which has",
                    "{C:attention}fewest{} cards in deck"
                },
            },
            j_rgmc_legend_picky = {
                name = "Lemonade Picky",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "Increases by {X:attention,C:white}#2#%{} per completed {C:attention}Ante{}"
                },
                quote = {
                    "Time waits for those who wait"
                }
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
                        "Gains {X:rgmc_escore,C:white,E:1}^#1#{} Score",
                        "per {C:attention}1337ened{} {C:rgmc_gimmick,E:1}Gimmick{} Joker",
                        "{C:inactive}(Currently {X:rgmc_escore,C:white}^#2#{C:inactive})",
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
                    "Played {C:attention}1s{} and {C:attention}0s{} give #1# Chips when scored",
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
                   "gain {C:money}$#2#{} for each Joker"
                },
            },
            j_rgmc_golden_house = {
                name = "The Golden House",
                text = {
                    {
                        "Currently gives {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult"
                    },
                    {
                        "At start of Blind, destroy one random",
                        "{C:planet}Planet{} card, gaining the {C:chips}chips{} and {C:mult}mult{}",
                        "of its {C:attention}Poker Hand{}"
                    }
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
            j_rgmc_cry_thad= {
                name = "Thad",
                text = {
                    {
                        "{C:cry_epic}Force trigger{}",
                        "the {C:attention}leftmost{} Joker",
                        "{C:attention}#1#{} time(s)"
                    }
                },
            },
            j_rgmc_cry_danvas= {
                name = "Doredom",
                text = {
                    {
                        "{C:green}1 in 3{} chance to {C:cry_epic}force trigger{}",
                        "each Joker {C:inactive}(per Joker)"
                    }
                },
            },
            j_rgmc_cry_danvas = {
                name = "Demivas",
                text = {
                    {
                        "{C:cry_epic}Force trigger{} all Jokers to the left once for",
                        "{C:attention}every{} {C:red}Rare{} Joker",
                        "(or greater) to the right of this Joker"
                    }
                },
            },
            j_seance_ex = {
                name = "Séance",
                text = {
                    "If {C:attention}poker hand{} contains a",
                    "{C:attention}#1#{} or {C:attention}#2#{},",
                    "create a random {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)"
                }
            },
            j_four_fingers_ex = {
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
                    "Gains {X:mult,C:white} x#2# {} Mult",
                    "if held in hand at",
                    "end of {C:attention}round{}",
				},
			},
			m_rgmc_bismuth = {
				name = "Bismuth Card",
				text = {
                    "Gains {C:attention}1{} of {C:attention}5{}",
                    "random powers at start of Blind"
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
            c_rgmc_rocket_ship = {
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
            c_rgmc_planet_sol3 = {
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
        Tarot = {
			c_rgmc_girder = {
				name = "Girder",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_filament = {
				name = "Filament",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmcolish = {
				name = "Polish",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmcrovidence = {
				name = "Providence",
                text = {
                    "#1# in #2# chance to apply {X:edition}edition{}",
					"to #3# {C:attention}random{} cards"
                }
			},
        },
        Rotarot = {
			c_rgmc_rot_girder = {
				name = "Girder!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_filament = {
				name = "Filament!",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_rot_polish = {
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
					"Add a {C:rgmc_cream}Cream Seal{}",
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
					"Reduce next {C:attention}blind{} requirements",
					"by {X:red,C:white}X#1#{} and add it to",
					"following {C:attention}blind{}"
				},
			},
			tag_rgmc_anti_boomerang = {
				name = "Rebound (Debuff)",
				text = {
					"Increase {C:attention}blind requirements{}",
					"by {X:red,C:white}X#1#{}"
				},
			},
            tag_rgmc_punisher= {
                name = "Punisher Tag",
				text = {
                    "Gain {C:money}$#1#{}, but",
                    "make the next {Cattention}Boss Blind{}",
                    "{C:dark_edition}SUPER HARD!{}",
                    "{C:inactive}(=#2# hand(s), no discards){}"
				},
            },
            tag_rgmc_rainbow = {
                name = "?!? Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}?!?{}",
				},
            },
            tag_rgmc_edition_iridescent = {
                name = "Iridescent Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Iridescent{}",
				},
            },
            tag_rgmc_edition_infernal = {
                name = "Infernal Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Infernal{}",
				},
            },
            tag_rgmc_edition_disco = {
                name = "Disco Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Disco{}",
					"{C:inactive}(Groovy, man!)"
				},
            },
            tag_rgmc_edition_chrome = {
                name = "Chrome Tag",
				text = {
					"Next base edition shop",
					"Joker is free and",
					"becomes {C:dark_edition}Chrome{}",
					"{C:inactive}(Fuuuuuuture!)"
				},
            },
            tag_rgmc_edition_galactic = {
                name = "Galactic Tag",
				text = {
					"Next base edition shop",
					"becomes {C:dark_edition}Galactic{}",
				},
            },
            tag_rgmc_edition_abyssal = {
                name = "Abyssal Tag",
				text = {
					"Next base edition shop",
					"becomes {C:dark_edition}Abyssal{}",
				},
            },
            tag_rgmc_edition_luxury = {
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
            tag_rgmc_target_mk1 = {
				name = "Reward Tag I",
				text = {
					"Gives a free",
					"{C:attention}#1# Booster{}"
				},
			},
            tag_rgmc_target_mk2 = {
				name = "Reward Tag II",
				text = {
					"Gives a free",
					"{C:attention}#1# Booster{}"
				},
			},
        },
        Voucher = {
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
			v_rgmc_big_bonus = {
				name = "Big Bonus",
				text = {
					"{C:chips}Chip enhancements",
                    "give {C:chips}+#1#{} Chips",
                    "per {C:attention}hand level"
				},
			},
			v_rgmc_massive_mult= {
				name = "Massive Mult",
				text = {
					"{C:mult} enhancements",
                    "give {C:mult}+#1#{} Mult",
                    "per {C:attention}hand level"
				},
			},
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
					"retriggers all {C:attention}held{} card effects",
					"{C:attention}#1# time(s){}"
				},
			},
        },
        Other = {
            rgmc_chinese_null = {
				name = "Empty Box",
				text = {
					"What the h***?!"
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
				name = "Bronze Seal",
				text = {
					"This card is placed closer",
					"to {C:attention}rear of deck{}"
				},
			},
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
                    "and scores, {C:attention}return to hand{}",
                }
			},
            rgmc_cream_seal = {
				name = "Cream Seal",
				text = {
                    "#1# in #2# chance to create a",
                    "random {C:spectral}Spectral{} card",
                    "if {C:attention}held{} in hand at end of round",
                    "{C:inactive}(Must have room)"
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
            rgmc_lanterns    = 'Lanterns',
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
            ["rgmc_knight"]     = "Knight",
            ["rgmc_x"]          = "X",
            ["rgmc_sum"]        = "Sum",
            ["rgmc_inf"]        = "Infinity",
        },
		dictionary = {
            rgmc_patina_seal         = "Patina Seal",
            rgmc_bronze_seal         = "Bronze Seal",
            rgmc_cream_seal          = "Cream Seal",
            rgmc_umber_seal          = "Umber Seal",
            rgmc_jade_seal           = "Jade Seal",
            rgmc_obsidian_seal       = "Obsidian Seal",

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
			rgmc_shield_removed_ex   = "Un-Shielded!",
			rgmc_removed_ex          = "Removed!",
			rgmc_balanced            = "Balanced",
			rgmc_ace_ex              = "Ace!",
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

            -- text
            rgmc_spam               = "SPAM",
            rgmc_maps               = "MAPS",
            rgmc_spam_ex            = "SPAM!",
            rgmc_spam_deathex       = "ONOS!",

            -- planets
            rgmc_rocket             = "Space Vehicle",
            rgmc_space_lobster      = "Boss Spacecraft",
            rgmc_planet_alt         = "Alt. Reality Planet",
            rgmc_anomality           = "Anomality",

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
            rgmc_spectrum_dark = {
                "5 cards with different",
                "dark suits"
            },
            rgmc_spectrum_light = {
                "5 cards with different",
                "light suits"
            },
            rgmc_spectrum_straight_dark = {
                "A Straight containing",
                "5 cards with different",
                "dark suits"
            },
            rgmc_spectrum_straight_light = {
                "A Straight containing",
                "5 cards with different",
                "light suits"
            },
            rgmc_spectrum_house_dark = {
                "A Full House containing",
                "5 cards with different",
                "dark suits"
            },
            rgmc_spectrum_house_light = {
                "A Full House containing",
                "5 cards with different",
                "light suits"
            },
            rgmc_spectrum_five_dark = {
                "5 cards of the same rank",
                "with different dark suits"
            },
            rgmc_spectrum_five_light = {
                "5 cards of the same rank",
                "with different light suits"
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
            rgmc_pick5 = {
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
            rgmc_pick5                      = "Pick 5",
            rgmc_kaleidoscope               = "Kaleidoscope",
            rgmc_noak                       = "None of a Kind",
            rgmc_noak_flush                 = "Flush None",
            rgmc_infoak                     = "Infinitum",
            rgmc_infoak_flush               = "Fluxus Infinitum",
        },
		labels = {
            rgmc_shielded       = "Shielded",
            rgmc_painted        = "Painted",
            rgmc_twinkling      = "Twinkling",
            rgmc_engraved       = "Engraved",
            rgmc_immutable      = "Immutable",
            rgmc_rand           = "Rand",
            rgmc_spatial        = "Spatial",
            rgmc_transient      = "Transient",
            rgmc_flippant       = "Flippant",
            rgmc_entropic       = "Entropic",
            rgmc_bismuth_red    = "Red (Bismuth)",
            rgmc_bismuth_yellow = "Yellow (Bismuth)",
            rgmc_bismuth_green  = "Green (Bismuth)",
            rgmc_bismuth_blue   = "Blue (Bismuth)",
            rgmc_bismuth_purple = "Purple (Bismuth)",
            rgmc_clown          = "Clowned",

			rgmc_iridescent     = "Iridescent",
			rgmc_infernal       = "Infernal",
			rgmc_chrome         = "Chrome",
			rgmc_disco          = "Disco",
			rgmc_phasing        = "Phasing",

			rgmc_patina_seal    = "Patina Seal",
			rgmc_bronze_seal    = "Bronze Seal",
			rgmc_jade_seal      = "Jade Seal",
			rgmc_umber_seal     = "Umber Seal",
			rgmc_cream_seal     = "Cream Seal",
			rgmc_obsidian_seal  = "Obsidian Seal",
		},
		v_dictionary = {
			rgmc_Echip       = {"^#1# Chips"},
			rgmc_EEchip      = {"^^#1# Chips"},
			rgmc_Emult       = {"^#1# Mult"},
			rgmc_EEmult      = {"^^#1# Mult"},
			rgmc_xscore      = {"X#1# Score"},
			rgmc_Escore      = {"^#1# Score"},
			rgmc_EEscore     = {"^^#1# Score"},
		},
    },
}
