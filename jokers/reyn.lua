local jokerInfo = {
	name = 'Bunch Of Jokers',
	config = {},
	--[[text = {
		"Create a {C:purple}Judgement{} card",
		"when {C:attention}Blind{} is selected",
		"{C:inactive}(Must have room){}",
	},]]--
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true
}

function jokerInfo.tooltip(self, info_queue)
	info_queue[#info_queue+1] = G.P_CENTERS.c_judgement
end

--[[
function jokerInfo.loc_vars(self, info_queue, card)
	return { G.GAME.probabilities.normal }
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)

end
]]--

function jokerInfo.calculate(self, card, context)
	if context.setting_blind and not self.getting_sliced and not self.debuff and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = (function()
				G.E_MANAGER:add_event(Event({
					func = function() 
						local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_judgement', 'car')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end}))   
					card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "+1 Judgement", colour = G.C.PURPLE})                       
				return true
			end)}))
	end
end



return jokerInfo
	