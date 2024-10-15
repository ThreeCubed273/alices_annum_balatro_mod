------- JOKERS -------

return {
	sendDebugMessage('Jokers activated'),
	-- Venus Fly Trap
	SMODS.Joker {
	key = 'key_venus_fly_trap',
	config = {extra = { bonus = 0.50, current = 1.00 }},
	loc_txt = {
		name = 'Venus Fly Trap',
		text = { 
			"This joker gains {X:mult,C:white}X#1#{} Mult",
			"if played hand contains",
			"a {C:attention}Three of a Kind{}",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{} Mult)"
			}
		},
	rarity = 3,
	cost = 8,
	unlocked=true, 
    discovered=true, 
	blueprint_compat=true,
	atlas = 'Alice Atlas',
	pos = { x = 0, y = 0 },
	loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.bonus, card.ability.extra.current}} end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint
		and (next(context.poker_hands['Three of a Kind']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Flush House']))
		then
				card.ability.extra.current = card.ability.extra.current + card.ability.extra.bonus
				return {
					message = localize('k_level_up_ex')
				}
			else if context.joker_main and card.ability.extra.current > 1 and not context.before and not context.after then
				return {
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
					Xmult_mod = card.ability.extra.current
				}
				end
			end
		end
	},
	
	-- Octopus
	-- CODE CREDIT TO: nhhvhy 
	SMODS.Joker {
        key = 'key_octopus',
        config = {extra = { bonus = 8, current = 16 }}, --prev = 0
        loc_txt = {
            name = 'Octopus',
            text = { 'Gains {C:chips}+#1#{} Chips for',
            'each scoring {C:attention}8{}',
            '{C:inactive}(Currently {C:chips}+#2#{} Chips)'}
        },
        rarity = 3,
        cost = 8,
        unlocked=true,
        discovered=true,
		blueprint_compat=true,
        atlas = 'Alice Atlas',
        pos = { x = 1, y = 0 },
        loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.bonus, card.ability.extra.current}} end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and not context.blueprint then 
                local rank = context.other_card:get_id()
                if rank == 8 then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.bonus
					return {
						extra = {focus = card, message = '+'..tostring(card.ability.extra.bonus)..' Chips', colour = G.C.CHIPS},
						card = card
					}
                end
            end
            if context.cardarea == G.jokers and not context.before and not context.after then
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.current}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.current
                }
                end
            end
    },
	
	-- Sun Fish
	-- He is perfect
	SMODS.Joker {
	key = 'key_sun_fish',
	loc_txt = {
		name = 'Sun Fish',
		text = { 'Spawns {C:tarot}The Sun{} if',
		'played hand contains',
		'a {C:attention}Two Pair',
		'{C:inactive}(Must have room)'
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = true, 
    discovered = true, 
	blueprint_compat=true,
	atlas = 'Alice Atlas',
	pos = { x = 2, y = 0 },
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and not context.blueprint
		and (next(context.poker_hands['Two Pair']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Flush House']))
		and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({trigger = 'before',
					delay = 0.0,
					func = (function() local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_sun', nil)
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						card:juice_up(0.8, 0.5)
					return true
				end)}))
				return {
					message = localize('k_plus_tarot')
				}
			end
		end
	},
	
	-- Honey Bee
	-- Bugs: Fix timing?
	SMODS.Joker {
	key = 'key_honey_bee',
	loc_txt = {
		name = 'Honey Bee',
		text = {'Played {C:attention}6{}s',
		'become {C:attention}Gold{}',
		'when scored'
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = true, 
    discovered = true, 
	atlas = 'Alice Atlas',
	pos = { x = 3, y = 0 },
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and not context.blueprint then
			for k, v in ipairs(context.scoring_hand) do
				local rank = context.scoring_hand[k]:get_id()
                if rank == 6 then 
                    local six_card = context.scoring_hand[k]
					six_card:set_ability(G.P_CENTERS.m_gold, nil, true)
					G.E_MANAGER:add_event(Event({
					func = function()
						six_card:juice_up()
						return true
					end}))
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_gold'), colour = G.C.MONEY})
                end
            end
        end  
	end
	},
	
	-- Earth Worm
	-- Bugs: Fix cards displaying no art for a sec then turning
	SMODS.Joker {
	key = 'key_earth_worm',
	loc_txt = {
		name = 'Earth Worm',
		text = {
		'Cards {C:attention}held in hand{} that',
		'are {C:mult}not{} enhanced',
		'become {C:attention}Stone{} cards'
		}
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	atlas = 'Alice Atlas',
	pos = { x = 4, y = 0 },
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			local cards_changed = 0;
			for i=1, #G.hand.cards do
                local stone_card = G.hand.cards[i]
				if stone_card.ability.effect ~= 'Stone Card' and stone_card.ability.effect == 'Base' then
					cards_changed = cards_changed + 1
					stone_card:set_ability(G.P_CENTERS.m_stone, nil, true)
					G.E_MANAGER:add_event(Event({
					func = function()
						stone_card:juice_up()
						return true
					end}))
				end
            end
			if cards_changed >= 1 then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Stone', colour = G.C.PURPLE})
			end
        end  
	end
	},
	
	-- Pufferfish
	-- He's Perfect
	SMODS.Joker {
	key = 'key_pufferfish',
	loc_txt = {
		name = 'Pufferfish',
		text = { 
		'If played hand contains',
		'a single {C:attention}face{} card,',
		'destroy it and create a',
		'random {C:spectral}Spectral{} card',
		'{C:inactive}(Must have room)'
		}
	},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = true,
	blueprint_compat=true,
	atlas = 'Alice Atlas',
	pos = { x = 5, y = 0 },
	calculate = function(self, card, context)
		if context.destroying_card and #context.full_hand == 1 and not context.blueprint then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				local playcard = context.full_hand[1]
				local rank = playcard:get_id()
				if rank == 11 or rank == 12 or rank == 13 then
				G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'key_pufferfish')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						playcard:start_dissolve()
					return true
				end}))
				end
			end
		end
	end
	},
	
	-- Kiwi
	-- 'It's a feature'
	SMODS.Joker {
	key = 'key_kiwi',
	loc_txt = {
		name = 'Kiwi',
		text = {'{C:attention}Decreases{} rank of',
		'played cards by {C:attention}1{}',
		'after score is calculated',
		'{C:inactive}(Cannot go below 2)'
		}
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat=true,
	atlas = 'Alice Atlas',
	pos = { x = 6, y = 0 },
	calculate = function(card, self, context)
		if context.after and context.full_hand and not context.blueprint then
		--sendDebugMessage('a')
			for k, v in pairs(G.play.cards) do
			local kiwi_card = G.play.cards[k]
			local rank = kiwi_card:get_id()
			--sendDebugMessage(rank)
			--sendDebugMessage(tostring(kiwi_card))
				if rank ~= 2 then
					--sendDebugMessage('b')
					G.E_MANAGER:add_event(Event({
						--sendDebugMessage('b2'),
						trigger = 'after',
						delay = 1.2,
						func = function()
								-------------
								--sendDebugMessage('delta')
								local _card = v
								local suit_prefix = SMODS.Suits[_card.base.suit].card_key..'_'
								local rank_suffix = v.base.id - 1
								if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
								elseif rank_suffix == 10 then rank_suffix = 'T'
								elseif rank_suffix == 11 then rank_suffix = 'J'
								elseif rank_suffix == 12 then rank_suffix = 'Q'
								elseif rank_suffix == 13 then rank_suffix = 'K'
								elseif rank_suffix == 14 then rank_suffix = 'A'
								elseif rank_suffix == 15 then rank_suffix = 'A'
								end
								_card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
								--------------
								local percent = 1.15 - (k - 0.999) / (#G.play.cards - 0.998) * 0.3
								play_sound('card1', percent)
								--sendDebugMessage('c')
								v:flip()
							return true
						end}))
					--sendDebugMessage('d')
				end
			end
		for k, v in pairs(G.play.cards) do
			sendDebugMessage(tostring(G.play.cards))
			--sendDebugMessage('alpha')
				if v.base.id ~= 2 then
					sendDebugMessage('beta')
						G.E_MANAGER:add_event(Event({
						delay = 0.2,
						trigger = 'before',
						func = function()
							local percent = 1.15 - (k - 0.999) / (#G.play.cards - 0.998) * 0.3
							play_sound('tarot2', percent)
							--sendDebugMessage('gamma')
							v:flip()
						return true end }))
					delay(0.4)
				end
			end
		end
	end
	},
	
	-- Cactus
	-- 'Gain Mult from Club Chips'
	SMODS.Joker {
		key = 'key_cactus',
		loc_txt = {
			name = 'Cactus',
			text = {
			'Gains {C:mult}+Mult{} {C:attention}equal{}',
			'to {C:attention}scoring{} {C:clubs}Club{} cards {C:attention}rank{}',
			'{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}mult){}'
			}
		},
		rarity = 2,
		cost = 6,
		config = {extra = {current = 5.0}},
		unlocked = true,
		discovered = true,
		blueprint_compat=true,
		atlas = 'Alice Atlas',
		pos = { x = 7, y = 0 },
		loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.current}} end,
		calculate = function(card, self, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			local rank_increase = context.other_card:get_id()
			if context.other_card:is_suit("Clubs") then
				if rank_increase > 10 and rank_increase < 14 then
					rank_increase = 10
				elseif rank_increase == 14 then
					rank_increase = 11
				end
				self.ability.extra.current = self.ability.extra.current + rank_increase
				return {
					--message = ('+'..tostring(self.ability.extra.current)),
					extra = {focus = self, message = '+'..tostring(rank_increase)..' Mult', colour = G.C.MULT},
					card = card
					--card_eval_status_text(self, 'extra', nil, nil, nil, {message = '+'..tostring(rank_increase)..' Mult', colour = G.C.MULT}),
				}
			end
		end
		--if context.individual and context.calculate_joker then 
		--	return {
		--		--message = ('+'..tostring(self.ability.extra.current)),
		--		card = self,
		--		card_eval_status_text(self, 'extra', nil, nil, nil, {message = '+'..tostring(rank_increase)..' Mult', colour = G.C.MULT}),
		--		delay(0.5)
		--	}
		--end
		if context.cardarea == G.jokers and context.joker_main then
			return {
                  -- card_eval_status_text(card, 'extra', nil, nil, nil, {message = tostring(self.ability.extra.current)}),
				message = localize{type='variable',key='a_mult',vars={self.ability.extra.current}},
				mult_mod = self.ability.extra.current,
			}
			end
		end
	}
}
