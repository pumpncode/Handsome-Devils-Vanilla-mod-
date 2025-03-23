SMODS.Joker{
    key = "dark_idol",
    config = {
        extra = {
            mult = 0.5,
            total = 1,
        }
    },
    rarity = 2,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, G.GAME.current_round.dark_idol.rank,
        localize(G.GAME.current_round.dark_idol.suit, "suits_plural"), card.ability.extra.total, colours = { G.C.SUITS[G.GAME.current_round.dark_idol.suit] } } }
    end,
    atlas = "Jokers",
    pos = { x = 8, y = 3 },
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_comat = true,
    calculate = function(self, card, context)
        local destroy = {}
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:get_id() == G.GAME.current_round.dark_idol.id and
            context.other_card:is_suit(G.GAME.current_round.dark_idol.suit) then
                card.ability.extra.total = card.ability.extra.total + card.ability.extra.mult
                card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.total}}})
                context.other_card.mark_destroy = true
            end
        end
        if context.destroying_card and context.destroying_card.mark_destroy then
            return {
                remove = true
            }
        end
        if context.joker_main and card.ability.extra.total > 1 then
            return {
                xmult = card.ability.extra.total
            }
        end
    end
}

local init_ret = Game.init_game_object
function Game:init_game_object()
	local ret = init_ret(self)
	ret.current_round.dark_idol = { suit = 'Spades', rank = 'Ace' }
	return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
	-- The suit changes every round, so we use reset_game_globals to choose a suit.
	G.GAME.current_round.dark_idol = { suit = 'Spades', rank = 'Ace' }
	local valid_dark_idol_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then -- Abstracted enhancement check for jokers being able to give cards additional enhancements
			valid_dark_idol_cards[#valid_dark_idol_cards + 1] = v
		end
	end
	if valid_dark_idol_cards[1] then
		local dark_idol_card = pseudorandom_element(valid_dark_idol_cards, pseudoseed('dark_idol' .. G.GAME.round_resets.ante))
		G.GAME.current_round.dark_idol.suit = dark_idol_card.base.suit
        G.GAME.current_round.dark_idol.rank = dark_idol_card.base.value
        G.GAME.current_round.dark_idol.id = dark_idol_card.base.id
	end
end