------- FOSSIL JOKERS -------

SMODS.Atlas({
    key = "Alice Fossil Jokers",
    path = "Alice Fossil Jokers.png",
    px = 71,
    py = 95
})

if alice_annum_mod.config.alice_fossil_jokers then

	SMODS.Joker {
		key = 'key_anoma_joker',
		loc_txt = {
			name = 'Anomalacaris',
			text = {'If played {C:attention}scoring hand{} contains a {C:attention}Straight{},',
			'all played cards for the rest of the round',
			'become {C:dark_edition}Polychrome{} cards.',
			'{C:inactive}(Does not replace editions){}',
			}
		},
		config = {extra = {active = 0}},
		rarity = 4,
		cost = 10,
		unlocked = true,
		discovered = true,
		blueprint_compat = true,
		atlas = "Alice Fossil Jokers",
		pos = { x = 0, y = 0 },
		soul_pos = { x = 1, y = 0 },
		loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.active}} end,
		calculate = function(card, self, context)
			if context.cardarea == G.jokers and context.before and not context.blueprint then	
				-- Check if first played hand is a straight
				if next(context.poker_hands['Straight']) and self.ability.extra.active == 0 then
					self.ability.extra.active = 1
				end
				
				-- Sets cards as polychrome
				if self.ability.extra.active == 1 then
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.FILTER})
					for k, v in ipairs(context.scoring_hand) do
						local scored_card = context.scoring_hand[k]
						if not (v.edition and v.edition.polychrome) then
							scored_card:set_edition({polychrome = true}, nil, true)
								G.E_MANAGER:add_event(Event({
								func = function()
									scored_card:juice_up()
									return true
								end
							})) 
						end
					end
				end	
			end 
			-- Deactivated polychrome effect after round ends.
			if context.end_of_round and not (context.individual or context.repetition) then
				self.ability.extra.active = 0
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.FILTER})
			end
		end
	}
	
end