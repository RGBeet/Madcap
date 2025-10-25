-- If Entropy is installed, replace this with Entropy's version!
return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_temporary",
        atlas   = 'stickers',
        pos     = MLIB.coords(5,4),
        badge_colour = HEX('F13938'),
        loc_vars = function(self, info_queue, card)
            return Madcap.BlankVar
        end,
        draw = function(self, card) -- Taken from Entropy (for now)
            local notilt = nil
            if card.area and card.area.config.type == "deck" then
                notilt = true
            end
            if not G.shared_stickers["entr_temporary2"] then
                G.shared_stickers["entr_temporary2"] =
                    Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["entr_stickers"], { x = 2, y = 1 })
            end -- no matter how late i init this, it's always late, so i'm doing it in the damn draw function

            G.shared_stickers[self.key].role.draw_major = card
            G.shared_stickers["entr_temporary2"].role.draw_major = card

            G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, notilt, card.children.center)

            card.hover_tilt = card.hover_tilt / 2 -- call it spaghetti, but it's what hologram does so...
            G.shared_stickers["entr_temporary2"]:draw_shader("dissolve", nil, nil, notilt, card.children.center)
            G.shared_stickers["entr_temporary2"]:draw_shader(
                "hologram",
                nil,
                card.ARGS.send_to_shader,
                notilt,
                card.children.center
            ) -- this doesn't really do much tbh, but the slight effect is nice
            card.hover_tilt = card.hover_tilt * 2
        end,
        apply = function(self, card, val)
            card.ability.rgmc_temporary = true
        end,
    }
}
