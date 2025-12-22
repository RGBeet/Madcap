Madcap = {}

assert(SMODS.load_file("lib/pre.lua"))()
assert(SMODS.load_file("lib/scoring.lua"))()
assert(SMODS.load_file("lib/hooks.lua"))()

assert(SMODS.load_file("lib/card.lua"))()
assert(SMODS.load_file("lib/ui.lua"))()

assert(SMODS.load_file("lib/subhands.lua"))()
assert(SMODS.load_file("lib/shop.lua"))()
assert(SMODS.load_file("lib/impound.lua"))()
assert(SMODS.load_file("lib/luxury_points.lua"))()
assert(SMODS.load_file("lib/temp_hands_discards.lua"))()

assert(SMODS.load_file("lib/modded_override.lua"))()

assert(SMODS.load_file("lib/crossmod.lua"))()
assert(SMODS.load_file("lib/update.lua"))()
assert(SMODS.load_file("lib/temp_hands_discards.lua"))()
assert(SMODS.load_file("lib/state_events.lua"))()
assert(SMODS.load_file("lib/misc_functions.lua"))()
assert(SMODS.load_file("lib/load_content.lua"))()
assert(SMODS.load_file("lib/joker_display.lua"))()

----------------------------------------------
------------MOD CODE END----------------------
