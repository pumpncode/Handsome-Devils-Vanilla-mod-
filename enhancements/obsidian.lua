SMODS.Enhancement({
    key = "obsidian",
    atlas = "Extras",
    pos = { x = 3, y = 1 },
    config = {
        extra =
        {
            odds = 3,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { G.GAME.probabilities.normal, card.ability.extra.odds }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            if pseudorandom('antimatter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                ease_dollars(-1)
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                local choice = pseudorandom_element({'Spectral', 'Planet', 'Tarot'}, pseudoseed('obsidian'))
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card(choice, G.consumeables)
                        card:set_edition('e_negative', true, flase)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = '-$1',
                }
            else
                ease_dollars(-1)
                return {
                    message = '-$1',
                }
            end
        end
    end
})
