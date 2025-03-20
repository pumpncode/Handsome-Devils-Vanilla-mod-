SMODS.Consumable {
	key = 'collision',
	set = 'Spectral',
	config = {
		extra = {
			cards = 2,
			key = 'm_hnds_antimatter'
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[self.config.extra.key]
		return { vars = { card.ability.extra.cards } }
	end,
	discovered = true,
	atlas = 'Consumables',
	pos = { x = 3, y = 1 },
	cost = 4,
	use = function(self, card, context, copier)
		local used_consumable = copier or card

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				used_consumable:juice_up(0.3, 0.5)
				return true
			end,
		}))
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound("card1", percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				for i = 1, #G.hand.highlighted do
					G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_hnds_antimatter)
				end
				used_consumable:juice_up(0.3, 0.5)
				return true
			end
		}))

		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound("tarot2", percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end
	end,
	can_use = function(self, card)
		if G.STATE == G.STATES.SELECTING_HAND and G.GAME.current_round.hands_left <= 1 then
			return false
		end
		if G.hand and #G.hand.highlighted <= card.ability.extra.cards and #G.hand.highlighted > 0 then
			return true
		end
	end
}
