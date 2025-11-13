function mod_loaded(mod_id)
	return SMODS.find_mod(mod_id)
end

function print_debug_text(text,prefix)
	if not Madcap.Data.devmode then return false end
	local finished_text
	if type(text) == 'string' then
		finished_text = "[MADCAP] - "..(prefix and prefix..' ' or '')..(text or '???')
	else
		print(text)
		finished_text = "[MADCAP] - TEXT TYPE IS "..type(text)
	end
	print(finished_text)
end

function tell(text)
   print_debug_text(text)
end

function tell_error(text)
	print_debug_text(text..' - ERROR!')
	return false
end

function tell_stat(text,stat)
    print_debug_text(text..": "..tostring(stat))
end

function tell_list(text,list)
    print_debug_text(text..":")
    print(list)
end

Madcap = {
	Funcs 		= { },
	JokerLists 	= { },
	Orders = {
		Blind		= 0,
		Booster		= 0,
		Consumable	= 0,
		Deck		= 0,
		Edition		= 0,
		Enhancement = 0,
		Joker		= 0,
		Seal		= 0,
		Sleeve		= 0,
		Tag			= 0,
		Voucher		= 0,
	},
	Lists = {
		AnTags = {},
		AnTagConversions = {
			['boomerang'] = 'anti_boomerang',
		},
		BismuthValues = {
			Red 	= 1.7, 	-- XMult
			Blue 	= 1.5, 	-- XChips
			Green	= 1,	-- Repetitions
			Purple 	= 1.5,	-- XScore
			Yellow 	= 5		-- Money
		},
		RoshamboKeys = {
			'm_stone',
			'm_lucky',
			'm_steel'
		},
		RoshamboValues = {
			['bonus'] 		= { 50.0, 0.0 }, 	-- rock
			['mult'] 		= { 20.0, 0.0 }, 	-- paper
			['p_dollars'] 	= { 20.0, 0.0 }, 	-- paper
			['h_x_mult'] 	= { 1.5, 1.0 },	-- scissors
		},
		Moons = {
			Mult = {
				'vulcanoid',
				'zoozve',
				'luna',
				'phobos',
				'europa',
				'titan',
				'umbriel',
				'triton',
				'nix',
				'planet_nine',
				'pallas',
				'dysnomia',
				'paper_weywot',
				'paper_namaka',
				'paper_ilmare',
				'paper_salacia',
			},
			Chips = {
				'phaethon',
				'2013_nd15',
				'kamooalewa',
				'deimos',
				'callisto',
				'iapetus',
				'oberon',
				'proteus',
				'charon',
				'nibiru',
				'2000_eu16',
				'kuiper',
				'paper_ixion',
				'paper_hiiaka',
				'paper_varda',
				'paper_mk2',
			}
		},
		Enhancements = {
			Chips = {
				'bonus',
				'stone',
				'rgmc_wolfram'
			},
			Mult = {
				'mult',
				'lucky',
				'rgmc_wolfram'
			},
			XMult = {
				'glass',
				'steel',
				'rgmc_lustrous'
			},
			Money = {
				'gold',
				'lucky',
				'rgmc_deluxe',
			},
		},
	},
	Data = {
		seed		= 'rgmc', 	-- primary seed for random stuff
		devmode 	= true, 	-- When true, enables all the debug text and unfinished content.
	},
}

Madcap.BlankVar = { vars = {} }

-- Quick fix for colors. TODO: Bring back working gradients!!!
G.C.RGMC_UNUSUAL 	= HEX('FFC0CB')
G.C.RGMC_CHAOTIC 	= HEX('003F34')
G.C.RGMC_GIMMICK 	= HEX('F69600')
G.C.RGMC_LUXURY 	= HEX('D34B08')

-- Rarities
SMODS.Rarity{ -- Unusual: not quite Epic Jokers, but not quite Legendary.
    key = "unusual",
    badge_colour = G.C.RGMC_UNUSUAL,
	badge_text_colour = HEX('1E2729'),
    polls = { ["Joker"] = { rate = 0 } },
}

SMODS.Rarity{ -- Gimmick: used for Jokers not normally obtainable in regular decks.
    key = "gimmick",
    badge_colour = G.C.RGMC_GIMMICK,
    polls = { ["Joker"] = { rate = 0.5 } },
}

SMODS.Rarity{ -- Unusual: not quite Epic Jokers, but not quite Legendary.
    key = "chaotic",
    badge_colour = G.C.RGMC_CHAOTIC,
    polls = { ["Joker"] = { rate = 0 } },
}

mfuncs 	= Madcap.Funcs
mjokers	= Madcap.JokerLists

-- enabled type stuff
local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!
MadcapConfig = SMODS.current_mod.config          	-- loading configuration
Madcap.enabled = copy_table(MadcapConfig)      		-- what is enabled?

-- Challenge descriptions
function SMODS.current_mod.process_loc_text()
    G.localization.misc.v_text.ch_c_rgmc_rule_rio = {
        "{C:attention}Aces{}, {C:attention}Kings{}, and {C:attention}Queens{} are {C:attention}3X{} more likely to appear{}"
    }
    G.localization.misc.v_text.ch_c_rgmc_rule_waveworx = {
        "{C:attention}All{} hands (except {C:attention}Straight{}) are {C:rgmc_evil}downgraded{} to Level {C:attention}0{}"
    }
    G.localization.misc.v_text.ch_c_bankrupt_kill = {
        "Going {C:attention}bankrupt{} results in an {C:rgmc_evil}automatic loss{}!"
    }
    G.localization.misc.v_text.ch_c_rgmc_rule_halved_interest = {
        "Base {C:attention}interest{} and interest {C:attention}cap{} are {C:rgmc_evil}reduced{} by {C:rgmc_evil}X0.5{}"
    }
end

-- Edition decks
if Cryptid and Cryptid.edeck_sprites then
    local cryptid_atlas = "rgmc_cryptid_decks"
    Cryptid.edeck_sprites.enhancement.m_rgmc_ferrous = { atlas = cryptid_atlas, pos = { x = 0, y = 0} }
    Cryptid.edeck_sprites.enhancement.m_rgmc_wolfram = { atlas = cryptid_atlas, pos = { x = 1, y = 0} }
    Cryptid.edeck_sprites.enhancement.m_rgmc_lustrous = { atlas = cryptid_atlas, pos = { x = 2, y = 0} }
    Cryptid.edeck_sprites.seal.rgmc_patina = { atlas = cryptid_atlas, pos = { x = 0, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_bronze = { atlas = cryptid_atlas, pos = { x = 1, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_jade = { atlas = cryptid_atlas, pos = { x = 2, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_cream = { atlas = cryptid_atlas, pos = { x = 3, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_umber = { atlas = cryptid_atlas, pos = { x = 4, y = 2} }
    Cryptid.edeck_sprites.edition.rgmc_iridescent = { atlas = cryptid_atlas, pos = { x = 1, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_infernal = { atlas = cryptid_atlas, pos = { x = 0, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_chrome = { atlas = cryptid_atlas, pos = { x = 3, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_disco = { atlas = cryptid_atlas, pos = { x = 2, y = 1} }
    Cryptid.edeck_sprites.suit.rgmc_goblets = { atlas = cryptid_atlas, pos = { x = 3, y = 0} }
    Cryptid.edeck_sprites.suit.rgmc_towers = { atlas = cryptid_atlas, pos = { x = 4, y = 0} }
end

function Madcap.Funcs.CheckLoadTables(_f,_t)
	return type(_f) == 'table'
		and type(_t) == 'table'
end

function Madcap.Funcs.LoadSounds(_f,_t)
	if not Madcap.Funcs.CheckLoadTables(_f,_t) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		if w.list then
			MadLib.loop_func_list(_f,function(v,i)
				v.object_type = "Sound"
				_t[#_t+1] = v
			end)
		else
			w.object_type = "Sound"
			_t[#_t+1] = w
		end
    end)
end

get_pos = MLIB.coords
Madcap.MayhemValues = {
	['AddMult'] 		= { factor = 1, round = true },
	['AddChips'] 		= { factor = 1, round = true },
	['AddScore'] 		= { factor = 1, round = true },
	['MultiMult'] 		= { factor = 1, level = 1, multiply = true },
	['MultiChips'] 		= { factor = 0.8, level = 1, multiply = true },
	['MultiScore'] 		= { factor = 0.8, level = 1, multiply = true },
	['ExpMult'] 		= { factor = 0.5, level = 2, multiply = true },
	['ExpChips'] 		= { factor = 0.5, level = 2, multiply = true },
	['ExpScore'] 		= { factor = 0.5, level = 2, multiply = true },
	['AddMoney'] 		= { factor = 1.5, round = true },
	['HandSize']		= { factor = 0.5, level = 1, round = true, type = 'hand_size'},
	['PlayHands']		= { factor = 0.5, round = true },
	['PlayDiscards'] 	= { factor = 0.5, round = true },
	['Retriggers'] 		= { factor = 0.25, round = true },
	['AddLuxury'] 		= { factor = 0.8, round = true },
	['AddCards'] 		= { factor = 0.8, level = 2, round = true },
	['JokerSlots']		= { factor = 0.5, level = 1, round = true, type = 'joker_slots' },
	['VoucherLimit']	= { factor = 0.5, level = 2, round = true, type = 'voucher_limit' },
	['BoosterLimit']	= { factor = 0.5, level = 2, round = true, type = 'booster_limit' },
	['MaxMayhem']		= { factor = 1, level = 1, round = true, type = 'max_mayhem' },
	['Mayhem']			= { factor = 1, level = 1, type = 'add_mayhem' },
	['Probability']		= { factor = 1, },
	['Choose']			= { factor = 0.5, round = true },
	['Misc']			= { factor = 1, }
}

local mlibmv = Madcap.MayhemValues

Madcap.MayhemConversions = {
	['cry_prob']		= mlibmv['Probability'],
	['odds']			= mlibmv['Probability'],
	['dollars']			= mlibmv['AddMoney'],
	['h_size']			= mlibmv['HandSize'],
	['h_mod']			= mlibmv['HandSize'],
	['handsize']		= mlibmv['HandSize'],
	['hand']			= mlibmv['PlayHands'],
	['hands']			= mlibmv['PlayHands'],
	['hand_mod']		= mlibmv['PlayHands'],
	['adds_hands']		= mlibmv['PlayHands'], -- UnStable?
	['discard']			= mlibmv['PlayDiscards'],
	['discards']		= mlibmv['PlayDiscards'],
	['discard_mod']		= mlibmv['PlayDiscards'],
	['discard_size']	= mlibmv['PlayDiscards'], -- UnStable?
	['extra']			= mlibmv['Misc'],
	['jokerslots']		= mlibmv['JokerSlots'],
	['joker_slots']		= mlibmv['JokerSlots'],
	['voucher_limit']	= mlibmv['VoucherLimit'],
	['booster_limit']	= mlibmv['BoosterLimit'],
	['extra_choices']	= mlibmv['ExtraChoices'],
	['max_mayhem']		= mlibmv['MaxMayhem'],
	['add_mayhem']		= mlibmv['Mayhem'],
	['retriggers']		= mlibmv['Retriggers'],
	['repetitions']		= mlibmv['Retriggers'],
	['xmult']			= mlibmv['MultiMult'],
	['x_mult']			= mlibmv['MultiMult'],
	['h_x_mult']		= mlibmv['MultiMult'],
	['xchips']			= mlibmv['MultiChips'],
	['x_chips']			= mlibmv['MultiChips'],
	['h_x_chips']		= mlibmv['MultiChips'],
	['perma_x_mult']		= mlibmv['MultiMult'],
	['perma_h_x_mult']		= mlibmv['MultiMult'],
	['perma_x_chips']		= mlibmv['MultiChips'],
	['perma_h_x_chips']		= mlibmv['MultiChips'],
	['max_highlighted']	= mlibmv['Choose'],
	['choose']			= mlibmv['Choose'],
}

--
local function loop_keys_add(list, target, value)
	MadLib.loop_func(list, function(k) target[k] = value end)
end

loop_keys_add({ 'mult', 'mult_mod', 'perma_mult', 'perma_h_mult', 's_mult', 't_mult', 'h_mult' },
	Madcap.MayhemConversions,  mlibmv['AddMult'])
loop_keys_add({ 'chips', 'chip_mod', 'perma_bonus', 'perma_h_chips', 't_chips', 'h_chips', 'bonus' },
	Madcap.MayhemConversions,  mlibmv['AddChips'])
loop_keys_add({ 'score', 'score_mod', 'perma_score', 'perma_h_score' },
	Madcap.MayhemConversions,  mlibmv['AddScore'])
loop_keys_add({ 'dollars', 'h_dollars', 'p_dollars', 'perma_p_dollars', 'perma_h_dollars' },
	Madcap.MayhemConversions,  mlibmv['AddMoney'])
loop_keys_add({ 'h_size', 'h_mod', 'handsize', 'hand_size', },
	Madcap.MayhemConversions,  mlibmv['HandSize'])
loop_keys_add({ 'd_size', 'discard_size', 'discards', 'discard', 'discard_mod' },
	Madcap.MayhemConversions,  mlibmv['PlayDiscards'])
loop_keys_add({ 'hands', 'hand_mod', 'hand' },
	Madcap.MayhemConversions,  mlibmv['PlayHands'])
loop_keys_add({ 'extra_value', 'hands_played_at_create' },
	Madcap.MayhemConversions,  mlibmv['Misc'])

if next(SMODS.find_mod("Pacdam")) or next(SMODS.find_mod("pacdam")) then
	tell('Pacdam loaded!')
	Madcap.MayhemValues['AddPow'] = { factor = 0.5, level = 2, multiply = true }
	loop_keys_add({ 'pow', 'pow_mod', 'perma_pow', 'pow_decay' },
		Madcap.MayhemConversions,  mlibmv['AddPow'])
end

if AKYRS then
	loop_keys_add({ 'akyrs_perma_h_score', 'akyrs_perma_score',  },
		Madcap.MayhemConversions,  mlibmv['AddScore'])
end

Madcap.MayhemBlacklist = {
	id 						= false,
	order					= false,
	qty 					= false,
	colour 					= false,
	immutable 				= false,
	suit_nominal 			= false,
	base_nominal 			= false,
	face_nominal 			= false,
	times_played 			= false,
	selected_d6_face 		= false,
	cry_hook_id				= false,
	suit_nominal_original 	= false,
	cry_prob				= false,
	entr_times_played		= false,
	value_mults				= false
}

-- Blacklisted because there would be no effect
Madcap.MayhemJokersBlacklist = {
	'j_four_fingers',
	'j_splash',
	'j_pareidolia',
	'j_riff_raff',
	'j_diet_cola',
	'j_luchador',
	'j_shortcut',
	'j_mr_bones',
	'j_chicot',
	'j_blueprint',
	'j_brainstorm',
	'j_smeared',
	'j_midas_mask',
	'j_ring_master'
}

-- used to define what extra means for the vanilla jokers (which work differently?)
-- also works with any joker that has undefined variables.
Madcap.DefineExtras = {
	['j_loyalty_card'] 		= { ['every'] = mlibmv['Misc'] }, -- every ? rounds
	['j_8_ball'] 			= { ['extra'] = mlibmv['Probability'] }, -- 1 in ? chance
	['j_misprint'] 			= { ['max'] = mlibmv['AddMult'], ['min'] = mlibmv['AddMult'] }, -- min and max mult
	['j_chaos'] 			= { ['extra'] = mlibmv['Misc'] }, -- reroll
	['j_fibonacci'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_steel_joker'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_scary_face'] 		= { ['extra'] = mlibmv['AddChips'] },
	['j_abstract'] 			= { ['extra'] = mlibmv['AddChips'] },
	['j_delayed_grat'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_hack'] 				= { ['extra'] = mlibmv['Retriggers'] },
	['j_even_steven'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_odd_todd'] 			= { ['extra'] = mlibmv['AddChips'] },
	['j_business'] 			= { ['extra'] = mlibmv['Probability'] },
	['j_egg'] 				= { ['extra'] = mlibmv['AddMoney'] },
	['j_burglar'] 			= { ['extra'] = mlibmv['PlayHands'] },
	['j_blackboard'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_supernova'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_ride_the_bus'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_space'] 			= { ['extra'] = mlibmv['Probability'] },
	['j_blue_joker']	 	= { ['extra'] = mlibmv['AddChips'] },
	['j_constellation']		= { ['extra'] = mlibmv['AddChips'] },
	['j_red_card']			= { ['extra'] = mlibmv['AddMult'] },
	['j_madness']			= { ['extra'] = mlibmv['MultiMult'] },
	['j_riff_raff']			= { ['extra'] = mlibmv['JokerSlots'] },
	['j_vagabond'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_baron'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_cloud_9'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_obelisk'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_photograph'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_gift'] 				= { ['extra'] = mlibmv['AddMoney'] },
	['j_erosion'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_mail'] 				= { ['extra'] = mlibmv['AddMoney'] },
	['j_to_the_moon'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_hallucination'] 	= { ['extra'] = mlibmv['Probability'] },
	['j_fortune_teller'] 	= { ['extra'] = mlibmv['AddMult'] },
	['j_stone'] 			= { ['extra'] = mlibmv['AddChips'] },
	['j_golden'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_lucky_cat'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_baseball'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_bull'] 				= { ['extra'] = mlibmv['AddChips'] },
	['j_trading'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_flash'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_popcorn'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_trousers'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_ancient'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_ramen'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_seltzer'] 			= { ['extra'] = mlibmv['Retriggers'] },
	['j_smiley'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_campfire'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_ticket'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_acrobat'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_sock_and_buskin'] 	= { ['extra'] = mlibmv['Retriggers'] },
	['j_throwback'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_hanging_chad'] 		= { ['extra'] = mlibmv['Retriggers'] },
	['j_rough_gem'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_arrowhead'] 		= { ['extra'] = mlibmv['AddChips'] },
	['j_onyx_agate'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_glass'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_flower_pot'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_idol'] 				= { ['extra'] = mlibmv['MultiMult'] },
	['j_seeing_double'] 	= { ['extra'] = mlibmv['MultiMult'] },
	['j_matador'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_hit_the_road'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_invisible'] 		= { ['extra'] = mlibmv['Misc'] }, -- rounds
	['j_satellite'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_shoot_the_moon'] 	= { ['extra'] = mlibmv['AddMult'] },
	['j_drivers_license'] 	= { ['extra'] = mlibmv['MultiMult'] },
	['j_caino'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_triboulet'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_cry_soccer'] 		= { ['holygrail'] = mlibmv['Misc'] }, -- One For All
	['c_emperor'] 			= { ['tarots'] = mlibmv['Misc'] },
	['c_hermit'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['c_temperance'] 		= { ['extra'] = mlibmv['AddMoney'] },
}

SMODS.ConsumableType({
    key = "CosmaTarot",
    primary_colour = HEX("69FFAA"),
    secondary_colour = HEX("1F8268"),
    collection_rows = { 5, 6 },
    shop_rate = 0.5,
    loc_txt = {},
    default = "c_rgmc_orbs",
    can_stack = true,
    can_divide = true,
})

SMODS.ConsumableType({
    key = "SpatiaPlanet",
    primary_colour = HEX("5024FF"),
    secondary_colour = HEX("2600C1"),
    collection_rows = { 4, 2 },
    shop_rate = 0.75,
    --loc_txt = {},
    default = "c_rgmc_rocket",
    can_stack = true,
    can_divide = true,
})

SMODS.ConsumableType({
    key = "PotentiaCrystal",
    primary_colour = HEX("917ECC"),
    secondary_colour = HEX("FEA600"),
    collection_rows = { 3, 2 },
    shop_rate = 0.10,
    --loc_txt = {},
    default = "c_rgmc_diamatine",
    can_stack = true,
    can_divide = true,
})

SMODS.ConsumableType{
    key = "MiscRGMC",
    shop_rate = 0,
    primary_colour = HEX("F23D88"),
    secondary_colour = HEX("B72E67"),
}

-- 90 degree rotated umbrals

--[[
if 
	SMODS.find_mod("aikoyorisshenanigans")
	and SMODS.find_mod("MoreFluff")
then
	SMODS.ConsumableType({
		key = "Rotumbral",
		primary_colour = HEX("b5d852"),
		secondary_colour = HEX("ff759a"),
		collection_rows = { 4, 5 },
		shop_rate = 3,
		default = "c_rgmc_rot_umbral_graduate",
		can_stack = true,
		can_divide = true,
	})
end]]

SMODS.ObjectType({
	object_type = "ObjectType",
	key 	= "MadcapJoker",
	default = "j_rgmc_joker_squared",
	cards = {},
})

SMODS.ObjectType({
	object_type = "ObjectType",
	key 	= "ChipsJoker",
	default = "j_ice_cream",
	cards = {},
})

SMODS.ObjectType({
	object_type = "ObjectType",
	key 	= "MultJoker",
	default = "j_popcorn",
	cards = {},
})

Madcap.GoldenHouseFuncs = {
    ['c_black_hole'] = function(t)
        local chips, mult = 0, 0

        -- Loop through all visible
        MadLib.loop_func(G.GAME.hands, function(v)
            if v.visible then
                chips   = chips + v.chips/2
                mult    = mult + v.mult/2
            end
        end)

        return chips, mult
    end,
    ['c_cry_planetlua'] = function(t)
        local chips, mult = 0, 0

        if SMODS.pseudorandom_probability(t, 'golden_house', 1, 5) then
            -- Loop through all visible
            MadLib.loop_func(G.GAME.hands, function(v)
                if v.visible then
                    chips   = chips + v.chips/2
                    mult    = mult + v.mult/2
                end
            end)
        end

        return chips, mult
    end,
    ['c_cry_nstar'] = function(t)
        local chips, mult = 0, 0

        local random_hand = MadLib.get_random_poker_hand()
        local neutrons    = (G.GAME.neutronstarsusedinthisrun or 0) + 2
        chips   = (random_hand.chips / 2) * neutrons
        mult    = (random_hand.mult / 2) * neutrons
        return chips, mult
    end,
}

-- For the Red Pill, Blue Pill
MadLib.loop_table(MadLib.JokerLists.Chips, function(key,list)
	tell('Looping through '..key)
	print(list)
    MadLib.loop_func(list, function(v)
        tell('Attempting to load "'..tostring(v).. '" as a Chip Joker')
        if not SMODS.Centers[v] then return end
        SMODS.Centers[v].pools = SMODS.Centers[v].pools or {}
		SMODS.Centers[v].pools['ChipsJoker'] = true
    end)
end)


MadLib.loop_table(MadLib.JokerLists.Mult, function(key,list)
	tell('Looping through '..key)
	print(list)
    MadLib.loop_func(list, function(v)
        tell('Attempting to load "'..tostring(v).. '" as a Mult Joker')
        if not SMODS.Centers[v] then return end
        SMODS.Centers[v].pools = SMODS.Centers[v].pools or {}
        SMODS.Centers[v].pools['MultJoker'] = true
    end)
end)

Madcap.CustomCashouts = {
	['capitalism_boss'] = {
		check = function()
			return G.GAME.last_blind
		end,
		get_money = function(d)
			return 99
		end,
	}
}

-- Taken from TOGA
if not togabalatro then togabalatro = {} end
Madcap.Lists.ChipMultSwap = togabalatro.chipmultopswap or {
	['chips'] 		= 'mult',
	['h_chips'] 	= 'h_mult',
	['chip_mod'] 	= 'mult_mod',
	['mult'] 		= 'chips',
	['h_mult'] 		= 'h_chips',
	['mult_mod'] 	= 'chip_mod',
	['x_chips'] 	= 'x_mult',
	['xchips'] 		= 'xmult',
	['Xchip_mod'] 	= 'Xmult_mod',
	['x_mult'] 		= 'x_chips',
	['xmult'] 		= 'xchips',
	['Xmult'] 		= 'xchips',
	['x_mult_mod'] 	= 'Xchip_mod',
	['Xmult_mod'] 	= 'Xchip_mod',
	-- Talisman.
	['e_mult'] 		= 'e_chips',
	['emult'] 		= 'echips',
	['ee_mult'] 	= 'ee_chips',
	['eemult'] 		= 'eechips',
	['eee_mult'] 	= 'eee_chips',
	['eeemult'] 	= 'eeechips',
	['hypermult'] 	= 'hyperchips',
	['hyper_mult'] 	= 'hyper_chips',
	['e_chips'] 	= 'e_mult',
	['echips'] 		= 'emult',
	['ee_chips'] 	= 'ee_mult',
	['eechips'] 	= 'eemult',
	['eee_chips'] 	= 'eee_mult',
	['eeechips'] 	= 'eeemult',
	['hyperchips'] 		= 'hypermult',
	['hyper_chips'] 	= 'hyper_mult',
	['Emult_mod'] 		= 'Echip_mod',
	['EEmult_mod'] 		= 'EEchip_mod',
	['EEEmult_mod'] 	= 'EEEchip_mod',
	['hypermult_mod'] 	= 'hyperchip_mod',
	['Echip_mod'] 		= 'Emult_mod',
	['EEchip_mod'] 		= 'EEmult_mod',
	['EEEchip_mod'] 	= 'EEEmult_mod',
	['hyperchip_mod'] 	= 'hypermult_mod',
}

Madcap.Lists.ChipModKeys = togabalatro.chipmodkeys or {
	['chips'] = 'add', ['h_chips'] = 'add', ['chip_mod'] = 'add',
	['x_chips'] = 'mult', ['xchips'] = 'mult', ['Xchip_mod'] = 'mult',
	['e_chips'] = 'mult', ['echips'] = 'mult', ['Echip_mod'] = 'mult',
	['ee_chips'] = 'mult', ['eechips'] = 'mult', ['EEchip_mod'] = 'mult',
	['eee_chips'] = 'mult', ['eeechips'] = 'mult', ['EEEchip_mod'] = 'mult',
	['hyperchips'] = 'mult', ['hyper_chips'] = 'mult', ['hyperchip_mod'] = 'mult',
}

Madcap.Lists.MultModKeys = togabalatro.multmodkeys or {
	['mult'] = 'add', ['h_mult'] = 'add', ['mult_mod'] = 'add',
	['x_mult'] = 'mult', ['xmult'] = 'mult', ['Xmult'] = 'mult', ['x_mult_mod'] = 'mult', ['Xmult_mod'] = 'mult',
	['e_mult'] = 'mult', ['emult'] = 'mult', ['Emult_mod'] = 'mult',
	['ee_mult'] = 'mult', ['eemult'] = 'mult', ['EEmult_mod'] = 'mult',
	['eee_mult'] = 'mult', ['eeemult'] = 'mult', ['EEEmult_mod'] = 'mult',
	['hypermult'] = 'mult', ['hyper_mult'] = 'mult', ['hypermult_mod'] = 'mult',
}

Madcap.MicroDeckList = { -- 4 cards or less!
    ['High Card']           = 1,
    ['Pair']                = 2,
    ['Three of a Kind']     = 3,
    ['Two Pair']            = 4,
    ['Four of a Kind']      = 4,
}

Madcap.DeckConfigs = {
	micro = {
		base 		= { hand_size = -2, hand_play_limit = -1, ante_scaling = 0.5, subhand_req = -1 },
		sleeve_plus	= { hand_size = -1, hand_play_limit = -1, ante_scaling = 0.8, subhand_req = -1 },
		sleeve		= { hand_size = -1, hand_play_limit = -1, ante_scaling = 0.6, subhand_req = -1 }
	},
	hexing = { -- deal with this shit in sleeves
		base = {
			starting_suits = { 'Hearts', 'Spades', 'Diamonds', 'Clubs', 'rgmc_goblets', 'rgmc_towers' },
        	starting_ranks = { '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }	
		},
	},
	sangria = {
		base = {
            starting_suits = {'rgmc_goblets','rgmc_towers'}, -- new suits!
            starting_suits_doubles = true -- 2 of each suit/rank combo
		},
	},
	merlot = {
		base = {
            starting_suits = {'rgmc_blooms','rgmc_daggers'}, -- new suits!
            starting_suits_doubles = true -- 2 of each suit/rank combo
		},
	}
}

Madcap.DeckFuncs = {
	micro = {
		apply = function(self, back)
            Madcap.Funcs.init_deck('hexing', { finishers = { 'bl_rgmc_final_chimes' }})
			if G.GAME.hands['Straight Flush'].visible then
				for k, v in pairs(Madcap.MicroDeckList) do
					if G.GAME.hands[k] then G.GAME.hands[k].visible = (v <= G.GAME.starting_params.play_limit) end
				end
			end
        end,
	},
	sangria = {
		apply = function(self)
            Madcap.Funcs.init_deck('sangria', {
                finishers       = { 'bl_rgmc_final_moon' } -- force Macchiato Moon
            })
            G.GAME.Exotic = true -- Exotic Suits show up!
            Madcap.Funcs.set_subhand('light',true)
        end
	}
}