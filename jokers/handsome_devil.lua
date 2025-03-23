SMODS.Joker {
    key = "handsome_devil",
    config = {
        extra = {
            denom = 4,
            rates = {
                {name = "e_foil", weight = 32},
                {name = "e_holo", weight = 32},
                {name = "e_polychrome", weight = 32},
                {name = "e_negative", weight = 4}
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue + 1] = {key = 'e_negative_playing_card', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit}}
        return { vars = { G.GAME.probabilities.normal, card.ability.extra.denom } } end,
    atlas = "Jokers",
    pos = { x = 5, y = 0 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.repetition and not context.blueprint then
            local add_e = {}
            for i, v in ipairs(context.scoring_hand) do
                if pseudorandom("handsome") < G.GAME.probabilities.normal / card.ability.extra.denom then
                    if v:get_id() == 11 and not v.edition then
                        add_e[#add_e+1] = v
                        v:juice_up()
                    end
                end
            end
            if #add_e > 0 then
                for i, v in ipairs(add_e) do
                    v:set_edition(poll_edition("hnds_hnds", nil, false, true, card.ability.extra.rates), true)
                end
                card:juice_up()
                return {
                    message = localize('k_hnds_handsome'),
                    colour = G.C.dark_edition,
                    card = card
                }
            end
        end
    end
}