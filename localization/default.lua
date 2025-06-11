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
					"above #2#X of blind requirements",
				},
			},
			b_rgmc_sangria = {
				name = "Sangria Deck",
				text = {
					"Start run with {C:attention}26 {C:rgmc_cups}Goblets",
					"and {C:attention} 26 {rgmc_shields}Towers in deck"
				},
			},
			b_rgmc_micro = {
				name = "Micro Deck",
				text = {
					"Start run with {C:attention}26 {C:rgmc_cups}Goblets",
					"and {C:attention} 26 {rgmc_shields}Towers in deck"
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
				name = "Disco",
				text = {
					"?!?",
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
                    "Gains {C:chips}+#1#{} Chips per played hand",
                    "{C:green}#2# in #3#{} chance to {C:red}reset{}",
                    "at {C:attention}end{} of Blind",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive})"
                },
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
                    "For each scored {C:rgmc_cups}Goblet{} card,",
                    "{C:green}#1# in #2#{} chance",
                    "this Joker gains {C:mult}+#3# Mult",
                    "Resets at end of {C:attention}Ante",
                    "{C:inactive}(Currently {C:mult}+#4# {C:inactive} Mult)"
                },
            },
            j_rgmc_toughened_shungite = {
                name = "Toughened Shungite",
                text = {
                    "For each scored {C:rgmc_shields}Tower{} card,",
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
                    "Each scored {C:attention}4{} or {C:attention}9{}",
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
            j_rgmc_pretentious_joker = {
                name = "Pretentious Joker",
                text = {
                    'Played cards with',
                    '{C:rgmc_cups}#2#{} suit give',
                    '{C:mult}+#1#{} Mult when scored',
                },
            },
            j_rgmc_deceitful_joker = {
                name = "Deceitful Joker",
                text = {
                    'Played cards with',
                    '{C:rgmc_shields}#2#{} suit give',
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
                    "Each scored {C:attention}Ace{},",
                    "{C:attention}5{}, or {C:attention}Queen{} gives",
                    "{C:mult}+#1#{} Mult",
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
                    "{C:inactive,s:0.7}(Clubs, Spades, etc.)"
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
        },
        Planet = {
            c_rgmc_p_pikari = {
                name = "Pikari",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_p_suojata = {
                name = "Suojata",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_p_kukinta = {
                name = "Kukinta",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_p_veitsi = {
                name = "Veitsi",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_p_tyhja = {
                name = "Tyhjä",
                text = {
					"({V:1}lvl.#3#{})({V:2}lvl.#4#{})",
					"Level up",
					"{C:attention}#1#{}",
					"and {C:attention}#2#{},",
                },
            },
            c_rgmc_p_rigel_iv = {
                name = "Rigel IV",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_aquaworld = {
                name = "Aquaworld",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_prometheus_ix = {
                name = "Prometheus IX",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_tartarus_ii = {
                name = "Tartarus II",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_asteroid_belt = {
                name = "Asteroid Belt",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_varakkis = {
                name = "Varakkis",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_jurassika = {
                name = "Jurassika",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_globulos = {
                name = "Globulos",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_xykulix = {
                name = "Xykulix",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chip#<s>4#",
                },
            },
            c_rgmc_p_blue_moon = {
                name = "Blue Moon",
                text = {
					"({V:1}lvl.#6#{})({V:2}lvl.#7#{})({V:3}lvl.#8#{})({V:4}lvl.#8#{})",
					"Level up",
					"{C:attention}#1#{}, {C:attention}#2#{},",
					"{C:attention}#3#{}, and {C:attention}#4#{}",
                },
            },
            c_rgmc_p_blood_moon = {
                name = "Blood Moon",
                text = {
					"({V:1}lvl.#5#{})({V:2}lvl.#6#{})({V:3}lvl.#7#{})({V:4}lvl.#8#{})",
					"Level up",
					"{C:attention}#1#{}, {C:attention}#2#{},",
					"{C:attention}#3#{}, and {C:attention}#4#{}",
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
			c_rgmc_polish = {
				name = "Polish",
                text = {
                    'Enhances up to {C:attention}#1#{}',
                    'selected cards to',
                    '{C:attention}#2#s'
                }
			},
			c_rgmc_providence = {
				name = "Providence",
                text = {
                    "#1# in #2# chance to apply {X:edition}edition{}",
					"to #3# {C:attention}random{} cards"
                }
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
            tag_rgmc_edition_iridescent = {
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
		},
		suits_plural = {
            rgmc_goblets    = 'Goblets',
            rgmc_towers     = 'Towers',
            rgmc_blooms     = 'Blooms',
            rgmc_daggers    = 'Daggers',
            rgmc_voids      = 'Voids',
		},
        ranks = {
            ["rgmc_knight"]     = "Knight",
            ["rgmc_sum"]        = "Sum",
            ["rgmc_10.5"]       = "10 and a Half",
        },
		dictionary = {
            rgmc_patina_seal        = "Patina Seal",
            rgmc_bronze_seal        = "Bronze Seal",
            rgmc_cream_seal         = "Cream Seal",
            rgmc_umber_seal         = "Umber Seal",
            rgmc_jade_seal          = "Jade Seal",
			rgmc_iridescent         = "Iridescent",
			rgmc_infernal           = "Infernal",
			rgmc_chrome             = "Chrome",
			rgmc_disco              = "Disco",
			rgmc_phasing            = "Phasing",
			-- text
			rgmc_minus_round         = "-1 Round",
			rgmc_what                = "what",
			rgmc_enabled_ex          = "Enabled!",
			rgmc_shield_removed_ex   = "Un-Shielded!",
			rgmc_balanced            = "Balanced",
			rgmc_ace_ex              = "Ace!",
			rgmc_inactive            = "Inactive",
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
		},
        poker_hand_descriptions = {
            rgmc_pyramid = {
                "Six card",
            },
        },
        poker_hands= {
            rgmc_pyramid                    = "Pyramid",
            rgmc_pyramid_flush              = "Flush Pyramid",
            rgmc_pyramid_spectrum           = "Spectrum Pyramid",
            rgmc_spectrum_dark              = "Dark Spectrum",
            rgmc_spectrum_dark_straight     = "Dark Straight Spectrum",
            rgmc_spectrum_dark_house        = "Dark Spectrum House",
            rgmc_spectrum_dark_five         = "Dark Spectrum Five",
            rgmc_spectrum_dark_pyramid      = "Dark Spectrum Pyramid",
            rgmc_spectrum_light             = "Light Spectrum",
            rgmc_spectrum_light_straight    = "Light Straight Spectrum",
            rgmc_spectrum_light_house       = "Light Spectrum House",
            rgmc_spectrum_light_five        = "Light Spectrum Five",
            rgmc_spectrum_light_pyramid     = "Light Spectrum Pyramid",
            rgmc_kaleidoscope               = "Kaleidoscope",
            rgmc_kaleidoscope_cluster       = "Clusterscope",           -- not official
            rgmc_noak                       = "None of a Kind",
            rgmc_noak_flush                 = "Flush None",
            rgmc_infoak                     = "Infinity of a Kind",
            rgmc_infoak_flush               = "Fluxus Infinitum",
            rgmc_infoak_cluster             = "Coetus Infinitum",       -- not official
            rgmc_throak                     = "Thrive of a Kind",       -- ?!?
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
			rgmc_iridescent     = "Iridescent",
			rgmc_infernal       = "Infernal",
			rgmc_chrome         = "Chrome",
			rgmc_disco          = "Disco",
			rgmc_phasing        = "Phasing",
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
