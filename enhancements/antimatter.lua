SMODS.Enhancement({
    key = "antimatter",
    atlas = "Extras",
    pos = { x = 2, y = 1 },
    config = {
        extra =
        {
            x_mult = 0.5,
            change = 0.5,
            odds = 3,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card and card.ability.extra.x_mult or self.config.extra.x_mult, card and card.ability.extra.change or self.config.extra.change, G.GAME.probabilities.normal, card.ability.extra.odds }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            if pseudorandom('antimatter') < G.GAME.probabilities.normal / card.ability.extra.odds and card.ability.extra.x_mult < 3 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        card.ability.extra.x_mult = card:scale_value(card.ability.extra.x_mult, card.ability.extra.change)
                        return true
                    end
                }))
            end
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end
})
