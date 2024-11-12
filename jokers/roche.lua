local jokerInfo = {
	name = 'Motorcyclist Joker',
	config = {gil = 13},
	--[[text = {
		"If round ends with exactly {C:money}$#1#{},",
		"create a {C:planet}Planet{} card for",
		"your most-used hand",
		"{C:inactive}(Must have room){}",
	},]]--
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist5", set = "Other"}
	return { vars = {card.ability.gil} }
end

local roche = SMODS.Sound({
	key = "roche",
	path = "roche.wav"
})

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not self.debuff and not context.individual and not context.repetition then
		if G.GAME.dollars == card.ability.gil then
			sendInfoMessage("Dollars is 13, activating Roche...")
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				sendInfoMessage("Space is available in consumables...")
				local card_type = 'Planet'
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				sendInfoMessage("Triggering function...")
				card:vic_say_stuff(2, nil, true, roche)
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					blockable = false,
					blocking = false,
					func = function()
						local speech_key = 'roche_voiceline'
						card:vic_add_speech_bubble(speech_key, 'bm', nil, {text_alignment = "cm"})
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 8,
							blocking = false,
							func = function()
								card:vic_remove_speech_bubble()
								return true
							end
						}))
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.0,
					func = (function()
						sendInfoMessage("Getting most played hand...")
						local _handname, _played, _order = 'High Card', -1, 100
                    	for k, v in pairs(G.GAME.hands) do
                        	if v.played > _played or (v.played == _played and _order > v.order) then 
                            	_played = v.played
								_order = v.order
                            	_handname = k
                        	end
                    	end
						sendInfoMessage("Most played hand: " .. _handname)
						local _planet = 0
						for k, v in pairs(G.P_CENTER_POOLS.Planet) do
							if v.config.hand_type == _handname then
								_planet = v.key
							end
						end
						sendInfoMessage("Creating " .. _planet .. " planet card...")
						local _card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
						sendInfoMessage("Adding " .. _planet .. " planet card to deck...")
						_card:add_to_deck()
						sendInfoMessage("Placing " .. _planet .. " in consumables...")
						G.consumeables:emplace(_card)
						G.GAME.consumeable_buffer = 0
						return true
					end)}))
				--sendInfoMessage("Sending +Planet message text...")
				--card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
				--ret.effect = true
			end
		end
	end
end



return jokerInfo
	