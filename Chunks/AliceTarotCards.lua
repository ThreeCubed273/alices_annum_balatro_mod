-- DEFINES FUNCTIONALITY OF TAROT CARDS

badge_minorarcana = function(self, card, badges)
	badges[#badges + 1] = create_badge('Minor Arcana', HEX('A782D1'), G.C.WHITE, 1.2)
end

-- Atlas

SMODS.Atlas({
    key = "Alice Arcana Atlas",
    path = "Alice Arcana Atlas.png",
    px = 71,
    py = 95
})

if alice_annum_mod.config.alice_tarot_cards then
	-- ACE OF CUPS
	-- DONE
	SMODS.Consumable {
		key = 'arcana_aof_cups',
		loc_txt = {
			name = 'Ace of Cups',
			text = {'{C:attention}Upgrades{} edition of up to',
			'{C:attention}2{} selected cards in hand',
			'{C:inactive}(Edition order found in collection)'}
		},
		set = ('Tarot'),
		atlas = "Alice Arcana Atlas",
		set_card_type_badge = badge_minorarcana,
		pos = { x = 0, y = 0 },
		cost = 4,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return #G.hand.highlighted >= 1 and #G.hand.highlighted <= 2
		end,
		use = function(self, card, area, copier)
			for k, v in ipairs(G.hand.highlighted) do
				--sendDebugMessage(tostring(G.hand.highlighted))
				local sel_card = G.hand.highlighted[k] 
				--sendDebugMessage(tostring(G.hand.highlighted[k]))
				local found_edition = 1
				if sel_card.edition then
					for i, v in ipairs(G.P_CENTER_POOLS.Edition) do
						if v.key == sel_card.edition.key then
							--sendDebugMessage(tostring(sel_card.edition.key))
							found_edition = i
							break
						end
					end
				end
				found_edition = found_edition + 1
				--sendDebugMessage(tostring(found_edition))
				if found_edition > #G.P_CENTER_POOLS.Edition then found_edition = found_edition - #G.P_CENTER_POOLS.Edition end
				sel_card:set_edition(G.P_CENTER_POOLS.Edition[found_edition].key, nil, nil)
			end
		end
	}
	
	-- ACE OF WANDS
	-- 
	SMODS.Consumable {
		key = 'arcana_aof_wands',
		loc_txt = {
			name = 'Ace of Wands',
			text = {'Add a {C:attention}random{} enhancement',
			'to up to {C:attention}3{} cards held in hand'}
		},
		set = ('Tarot'),
		atlas = "Alice Arcana Atlas",
		set_card_type_badge = badge_minorarcana,
		pos = { x = 1, y = 0 },
		cost = 4,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return #G.hand.highlighted >= 1 and #G.hand.highlighted <= 3
		end,
		use = function(self, card, area, copier)
			for k, v in ipairs(G.hand.highlighted) do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					play_sound('tarot1')
					v:juice_up(0.3, 0.5)
				return true end }))
				local rand_enhancement = pseudorandom_element(G.P_CENTER_POOLS["Enhanced"], pseudoseed('seed'))
				--sendDebugMessage(tostring(rand_enhancement.key))
				v:set_ability(rand_enhancement, true, nil)
			end
		end
	}
	 
	---- ACE OF PENTACLES
	
	SMODS.Consumable {
		key = 'arcana_aof_pentacles',
		loc_txt = {
			name = 'Ace of Pentacles',
			text = {'Sell {C:attention}3{} ranks of up',
			'to {C:attention}3{} selected cards',
			'{C:inactive}(Gain {}{C:money}1${}{C:inactive} for each rank sold){}',
			'{C:inactive}(Does not decrease rank below 2){}'}
		},
		set = ('Tarot'),
		atlas = "Alice Arcana Atlas",
		set_card_type_badge = badge_minorarcana,
		pos = { x = 2, y = 0 },
		cost = 4,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return #G.hand.highlighted >= 1 and #G.hand.highlighted <= 3 
		end,
		use = function(self, card, area, copier)
			local total_rank = 0
			for k, v in ipairs(G.hand.highlighted) do
				local sel_card = G.hand.highlighted[k]
				local card_rank = sel_card:get_id()
				if card_rank >= 5 then
					card_rank = 5
				end
				total_rank = total_rank + (card_rank - 2)
				if card_rank ~= 2 then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 1.2,
					func = function()
							-------------
							--sendDebugMessage('delta')
							local _card = v
							local suit_prefix = string.sub(_card.base.suit, 1, 1)..'_'
							local rank_suffix = v.base.id - (card_rank - 2)
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
							local percent = 1.15 - (k - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
							play_sound('card1', percent)
							v:flip()
						return true
					end}))
				end
			end
			for k, v in ipairs(G.hand.highlighted) do
				--sendDebugMessage('alpha')
				if v.base.id ~= 2 then
					--sendDebugMessage('beta')
					G.E_MANAGER:add_event(Event({
					delay = 0.2,
					trigger = 'before',
					func = function()
						local percent = 1.15 - (k - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
						play_sound('tarot2', percent)
						--sendDebugMessage('gamma')
						v:flip()
					return true end }))
					delay(0.4)
				end
			end
			if total_rank > 0 then
				ease_dollars(total_rank)
			end
		end
	}
		
	-- ACE OF SWORDS 
	SMODS.Consumable {
		key = 'arcana_aof_swords',
		loc_txt = {
			name = 'Ace of Swords',
			text = {'{C:attention}Disables{} Boss Blind,',
			'sets hands remaining to {C:attention}1{}'}
		},
		set = ('Tarot'),
		atlas = "Alice Arcana Atlas",
		set_card_type_badge = badge_minorarcana,
		pos = { x = 3, y = 0 },
		cost = 4,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return G.GAME.blind
		end,
		use = function(self, card, area, copier)
			G.GAME.blind:disable()
			play_sound('timpani')
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
			ease_hands_played(-G.GAME.current_round.hands_left + 1)
		end
	}
end