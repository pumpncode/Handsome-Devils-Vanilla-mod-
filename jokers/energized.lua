SMODS.Joker {
    key = 'energized',
    atlas = 'Jokers',
    pos = { x = 9, y = 3 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config =
    { extra = {
        repetitions = 4,
        odds = 2,
        joker_triggered = false
    }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions, G.GAME.probabilities.normal, card.ability.extra.odds } }
    end,
    calculate = function(card, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(card, eval, true)
        end
        if context.destroying_card and not context.blueprint and card.ability.extra.joker_triggered == true then
            card.ability.extra.joker_triggered = false
            return true
        end
        if not card.debuff then
            if context.cardarea == G.play and context.repetition and #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                return {
                    message = localize('k_hnds_energized'),
                    colour = G.C.FILTER,
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
        if context.destroy_card and context.cardarea == G.play then
            if pseudorandom('energized') < G.GAME.probabilities.normal / card.ability.extra.odds then
                card.ability.extra.joker_triggered = true
                return {
                    remove = true,
                    message = localize('k_hnds_zapped'),
                    colour = G.C.MULT,
                }
            end
        end
    end
}
