-- ALICE CONSUMABLES --

if alice_annum_mod.config.alice_fossil_jokers and alice_debug == false then
-- Anomalacaris / 'Odd Fossil'
-- All played poker hands are now straights or higher
	SMODS.Consumable {
		key = 'alice_anoma_con',
		set = 'alice_fossil_cards',
		loc_txt =
		{
			name = 'Anomalacaris Fossil',
			text = { 'Creates a {C:attention}unique{}',
			'{C:alice_fossil_tier,E:1}Fossil{} joker upon playing',
			'{C:attention}5 Straights{}',
			'{C:inactive}(Must have space){}',
			'{C:inactive}({C:attention}#1#{} remaining)'
			}
		},
		config = {extra = {counter = 5}},
		unlocked = true,
		discovered = true,
		atlas = 'Alice Cons',
		pos = { x = 0, y = 0 },	
		can_use = function(self, card)
			return card.ability.extra.counter <= 0
		end,
		--use = G.E_MANAGER:add_event(Event({trigger = 'before',
		--	delay = 0.0,
		--	func = function() local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'annum_key_anoma_joker')
		--		card:add_to_deck()
		--		G.jokers:emplace(card)
		--		--card:juice_up(0.8, 0.5)
		--	return true
		--	end})),
		loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.counter}} end,
		calculate = function(self, card, context)
			if context.joker_main and context.scoring_name == 'Straight' and card.ability.extra.counter > 0 then
				card.ability.extra.counter = card.ability.extra.counter - 1
			end
		end
	}
end