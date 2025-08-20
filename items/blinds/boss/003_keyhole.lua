Madcap.KeyholeWhitelist = {
    'High Card',
    'Pair',
    'Two Pair',
    'Three of a Kind',
    'Four of a Kind',
    'Straight',
    'Flush',
    'Full House',
    'Straight Flush',
    'Royal Flush'
}

return {
    data = {
        object_type = 'Blind',
        key     = 'keyhole',
        atlas   = "blinds",
        pos     = MLIB.coords(2),
        boss_colour = HEX('C6A839'),
        in_pool = function(self) return true end,
        debuff_hand = function(self, cards, hand, handname, check)
            return not MadLib.list_matches_one(Madcap.KeyholeWhitelist, function(v) return handname == v end)
        end
    }
}
