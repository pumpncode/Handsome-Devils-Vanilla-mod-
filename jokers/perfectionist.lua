local set_ability_ref = Card.set_ability
Card.set_ability = function(self, center, initial, delay_sprites)
    local ret = set_ability_ref(self, center, initial, delay_sprites)
    if self.ability and self.ability.set == "Enhanced" and center.set == "Enhanced" then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == "j_hnds_perfectionist" then
                self.ability.perma_mult = self.ability.perma_mult or 0
                self.ability.perma_mult = self.ability.perma_mult + G.P_CENTERS["j_hnds_perfectionist"].config.extra.mult
                card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.jokers.cards[i]:juice_up(0.6)
                    return true end
                }))
            end
        end
    end
    return ret
end

SMODS.Joker {
    key = "perfectionist",
    config = {
        extra = {
            mult = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } } end,
    atlas = "Jokers",
    pos = { x = 4, y = 1 },
    cost = 5,
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    calculate = function(self, card, context)
    end
}