local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "Cryptid", "Cryptid"

if mod_loaded(mod_id) then -- load the items

	-- create the joker atlas
	list[#list+1] = MadLib.create_atlas('jokers_cryptid', 'jokers_cryptid.png')

	local get_pos = function(_y,_x)
		return {
			x = _x,
			y = _y
		}
	end

	-- cryptid specific jokers
	local thad = {
		object_type = "Joker",
		name = "cry_thad",
		key = "cry_thad",
		pos = get_pos(0,0),
		config = {
			extra = { retriggers = 1 },
			immutable = { max_retriggers = 25 },
		},
		rarity = 'cry_epic',
		generate_ui = Madcap.Funcs.generate_special_ui,
		long_title = {
			"The Demicolon Chad"
		},
		cost = 21,
		blueprint_compat = false,
		demicoloncompat = true,
		loc_vars = function(self, info_queue, card)
			card.ability.demicoloncompat_ui = card.ability.demicoloncompat_ui or ""
			card.ability.demicoloncompat_ui_check = nil
			local check = card.ability.check
			return {
				vars = { math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers) },
				main_end = (card.area and card.area == G.jokers)
						and {
							{
								n = G.UIT.C,
								config = { align = "bm", minh = 0.4 },
								nodes = {
									{
										n = G.UIT.C,
										config = {
											ref_table = card,
											align = "m",
											-- colour = (check and G.C.cry_epic or G.C.JOKER_GREY),
											colour = card.ability.colour,
											r = 0.05,
											padding = 0.08,
											func = "blueprint_compat",
										},
										nodes = {
											{
												n = G.UIT.T,
												config = {
													ref_table = card.ability,
													ref_value = "demicoloncompat",
													colour = G.C.UI.TEXT_LIGHT,
													scale = 0.32 * 0.8,
												},
											},
										},
									},
								},
							},
						}
					or nil,
			}
		end,
		atlas = 'jokers_cryptid',
		update = function(self, card, front)
			local other_joker = nil
			if G.STAGE == G.STAGES.RUN then
				if G.jokers.cards[1] ~= card then
					other_joker = G.jokers.cards[1]
				end
				local m = Cryptid.demicolonGetTriggerable(other_joker)
				if m[1] and not m[2] then
					card.ability.demicoloncompat = "Comthaddable!"
					card.ability.check = true
					card.ability.colour = G.C.RGMC_GIMMICK
				elseif m[2] then
					card.ability.demicoloncompat = "Dangerous!"
					card.ability.check = true
					card.ability.colour = G.C.MULT
				else
					card.ability.demicoloncompat = "Uncomthaddable"
					card.ability.check = false
					card.ability.colour = G.C.BLACK
				end
			end
		end,
		calculate = function(self, card, context)
			if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
				-- the chad part
				if
					G.jokers.cards[1] ~= card
					and Cryptid.demicolonGetTriggerable(G.jokers.cards[1])[1]
				then -- retrigger self if
					local me = card
					return {
						message = localize("k_again_ex"),
						repetitions = to_number(
							math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers)
						),
						card = me,
					}
				else
					return nil, true
				end
			end

			-- the demicolon part
			if
				((context.joker_main and not context.blueprint) or context.forcetrigger)
				and G.jokers.cards[1] ~= card
			then
				if Cryptid.demicolonGetTriggerable(G.jokers.cards[1])[1] then
					local results = Cryptid.forcetrigger(G.jokers.cards[1], context)
					if results and results.jokers then
						results.jokers.message = localize("cry_demicolon")
						results.jokers.colour = G.C.RARITY.cry_epic
						results.jokers.sound = "cry_demitrigger"
						return results.jokers
					end
					return {
						message = localize("cry_demicolon"),
						colour = G.C.RARITY.cry_epic,
						sound = "cry_demitrigger",
					}
				end
			end
		end,
	}

	-- cryptid specific jokers
	local danvas = {
		object_type = "Joker",
		name = "cry_danvas",
		key = "cry_danvas",
		pos = get_pos(0,1),
		config = {
			immutable = {
				min_rarity 			= 'Legendary',
				max_retriggers 		= 20,
				current_retriggers 	= 0,
				target_list = {

				}
			},
		},
		rarity = 4,
		generate_ui = Madcap.Funcs.generate_special_ui,
		long_title = {
			"The Demicolon Canvas"
		},
		cost = 21,
		blueprint_compat = false,
		demicoloncompat = false,
		loc_vars = function(self, info_queue, card)
			return { vars = {} }
		end,
		atlas = 'jokers_cryptid',
		calculate = function(self, card, context)
			if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then


				local num_retriggers = 0
				for i = 1, #G.jokers.cards do
					if
						card.T.x + card.T.w / 2 < G.jokers.cards[i].T.x + G.jokers.cards[i].T.w / 2
						and G.jokers.cards[i].config.center.rarity ~= 1
						and (G.jokers.cards[i].config.center.rarity ~= "cry_candy" or Card.get_gameset(card) ~= "modest")
					then
						num_retriggers = num_retriggers + 1
					end
				end


				if
					context.other_card
					and context.other_card ~= card
					and Cryptid.demicolonGetTriggerable(card)[1]
				then -- retrigger self if
					return {
						message = localize("k_again_ex"),
						repetitions = to_number(
							math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers)
						),
						card = card,
						func = function()
							local results = Cryptid.forcetrigger(G.jokers.cards[1], context)
							if results and results.jokers then
								results.jokers.message = localize("cry_demicolon")
								results.jokers.colour = G.C.RARITY.cry_epic
								results.jokers.sound = "cry_demitrigger"
								return results.jokers
							end
							return {
								message = localize("cry_demicolon"),
								colour = G.C.RARITY.cry_epic,
								sound = "cry_demitrigger",
							}
						end
					}
				else
					return nil, true
				end
			end

			-- the demicolon part
			if
				((context.joker_main and not context.blueprint) or context.forcetrigger)
				and G.jokers.cards[1] ~= card
			then
				if Cryptid.demicolonGetTriggerable(G.jokers.cards[1])[1] then
					local results = Cryptid.forcetrigger(G.jokers.cards[1], context)
					if results and results.jokers then
						results.jokers.message = localize("cry_demicolon")
						results.jokers.colour = G.C.RARITY.cry_epic
						results.jokers.sound = "cry_demitrigger"
						return results.jokers
					end
					return {
						message = localize("cry_demicolon"),
						colour = G.C.RARITY.cry_epic,
						sound = "cry_demitrigger",
					}
				end
			end
		end,
	}

	local jokers = {
		thad,
		danvas,
	}

	for i=1, #jokers do
		jokers[i].object_type = "Joker"
		jokers[i].order = 1000+i-1
		jokers[i].set_card_type_badge = function(self, card, badges)
			badges[#badges+1] = create_badge(localize("rgmc_compat_cryptid"), mod_colour, nil, 1.2)
		end
		list[#list+1] = jokers[i]
	end



	-- Pikari
	local pikari = {
		key = "rgmc_pikari",
		pos = get_pos(2,0),
		config = {
			hand_types = {
				"rgmc_spectrum_light",
				"rgmc_spectrum_house_light",
			}
		},
		cost = 8,
		aurinko = true,
		atlas = "planets",
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, center)
			return MadLib.get_planet_list_vars(self.config.hand_types)
		end,
		use = function(self, card, area, copier)
			Cryptid.suit_level_up(card, copier, 1, card.config.center.config.hand_types)
		end,
		bulk_use = function(self, card, area, copier, number)
			Cryptid.suit_level_up(card, copier, number, card.config.center.config.hand_types)
		end,
		calculate = MadLib.calculate_observatory_xmult(self, card, context)
	}

	-- Suojata
	local suojata = {
		key = "rgmc_suojata",
		pos = get_pos(2,1),
		config = {
			hand_types = {
				"rgmc_spectrum_dark",
				"rgmc_spectrum_house_dark",
			}
		},
		cost = 8,
		aurinko = true,
		atlas = "planets",
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, center)
			return MadLib.get_planet_list_vars(self.config.hand_types)
		end,
		use = function(self, card, area, copier)
			Cryptid.suit_level_up(card, copier, 1, card.config.center.config.hand_types)
		end,
		bulk_use = function(self, card, area, copier, number)
			Cryptid.suit_level_up(card, copier, number, card.config.center.config.hand_types)
		end,
		calculate = MadLib.calculate_observatory_xmult(self, card, context)
	}

	-- Kukinta
	local kukinta = {
		key = "rgmc_kukinta",
		pos = get_pos(2,2),
		config = {
			hand_types = {
				"rgmc_spectrum_straight_light",
				"rgmc_spectrum_five_light",
			}
		},
		cost = 9,
		aurinko = true,
		atlas = "planets",
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, center)
			return MadLib.get_planet_list_vars(self.config.hand_types)
		end,
		use = function(self, card, area, copier)
			Cryptid.suit_level_up(card, copier, 1, card.config.center.config.hand_types)
		end,
		bulk_use = function(self, card, area, copier, number)
			Cryptid.suit_level_up(card, copier, number, card.config.center.config.hand_types)
		end,
		calculate = MadLib.calculate_observatory_xmult(self, card, context)
	}

	-- Kukinta
	local veitsi = {
		key = "rgmc_veitsi",
		pos = get_pos(2,3),
		config = {
			hand_types = {
				"rgmc_spectrum_straight_dark",
				"rgmc_spectrum_five_dark",
			}
		},
		cost = 9,
		aurinko = true,
		atlas = "planets",
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, center)
			return MadLib.get_planet_list_vars(self.config.hand_types)
		end,
		use = function(self, card, area, copier)
			Cryptid.suit_level_up(card, copier, 1, card.config.center.config.hand_types)
		end,
		bulk_use = function(self, card, area, copier, number)
			Cryptid.suit_level_up(card, copier, number, card.config.center.config.hand_types)
		end,
		calculate = MadLib.calculate_observatory_xmult(self, card, context)
	}

	-- Tyhja
	local tyhja = {
		key = "rgmc_tyhja",
		pos = get_pos(2,4),
		config = {
			hand_types = {
				"rgmc_pyramid",
				"rgmc_pyramid_flush",
				"rgmc_pyramid_spectrum",
			}
		},
		cost = 10,
		aurinko = true,
		atlas = "planets",
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, center)
			return MadLib.get_planet_list_vars(self.config.hand_types)
		end,
		use = function(self, card, area, copier)
			Cryptid.suit_level_up(card, copier, 1, card.config.center.config.hand_types)
		end,
		bulk_use = function(self, card, area, copier, number)
			Cryptid.suit_level_up(card, copier, number, card.config.center.config.hand_types)
		end,
		calculate = MadLib.calculate_observatory_xmult(self, card, context)
	}

	local planets = {
		--pikari,
		--suojata,
		--kukinta,
		--veitsi,
		--tyhja
	}

	for i=1, #planets do
		planets[i].object_type = "Consumable"
		planets[i].set = "Planet"
		planets[i].dependencies = { items = { "set_cry_planet", }}
		planets[i].order = 1000+i-1
		list[#list+1] = planets[i]
	end
end

return {
    name = mod_name .. " Compatability",
    init = function() -- does the non item stuff ig?
		if not mod_loaded(mod_id) then
			tell(mod_name .. "is not loaded - skipping!")
			return false
		end
			-- Add Epic, Exotic, Candy, and Cursed rarities to table
			MadLib.RarityValues['cry_exotic'] = {
				name = 'Exotic',
				value = 6,
				special = true,
			}

			MadLib.RarityValues['cry_epic'] = {
				name = 'Epic',
				value = 4.2, -- nice
				special = true,
			}

			MadLib.RarityValues['cry_candy'] = {
				name = 'Candy',
				value = 2.5,
				special = true,
			}

			MadLib.RarityValues['cry_cursed'] = {
				name = 'Cursed',
				value = 0.5,
				special = true,
			}

		return true
    end,
    items = list
}
