local jokerInfo = {
	name = 'Deathcard',
	config = {
		id = nil,
		timesSold = nil,
		extra = {
			money_mod = 5,
			mult = 0,
			mult_mod = 10
		},
	},
	rarity = 3,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.money_mod, card.ability.extra.mult, card.ability.extra.mult_mod} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_deathcard" })
	if not card.ability.id then
		if not G.GAME.uniqueDeathcardsAcquired then
			G.GAME.uniqueDeathcardsAcquired = 1
		else
			G.GAME.uniqueDeathcardsAcquired = G.GAME.uniqueDeathcardsAcquired + 1
		end
		card.ability.id = G.GAME.uniqueDeathcardsAcquired
	end
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
			colour = G.C.MULT,
			mult_mod = card.ability.extra.mult,
			card = card
		}
	end
	if context.selling_self then
		local stop = false
		if G.GAME.deathsold then
			for i, v in ipairs(G.GAME.deathsold) do
				if v['id'] == card.ability.id then
					stop = true
				end
			end
		end
		if not stop then
			if card.ability.timesSold then
				card.ability.timesSold = card.ability.timesSold + 1
			else
				card.ability.timesSold = 1
			end
			if not G.GAME.deathsold then
				G.GAME.deathsold = {}
			end
			G.GAME.deathsold[#G.GAME.deathsold+1] = {id=card.ability.id, timesSold=card.ability.timesSold}
			if G.GAME.spawnDeathcards then
				G.GAME.spawnDeathcards = G.GAME.spawnDeathcards + 1
			else
				G.GAME.spawnDeathcards = 1
			end
		end
	end
end

function jokerInfo.update(self, card)
	if card.area.config.type == "shop" and G.GAME.deathsold then
		if #G.GAME.deathsold > 0 and not card.ability.id and not card.ability.timesSold then
			local death = G.GAME.deathsold[1]
			local id = death['id']
			card.ability.id = id
			local timesSold = death['timesSold']
			card.ability.timesSold = timesSold
			local newcost = card.cost + (card.ability.extra.money_mod * card.ability.timesSold)
			card.cost = newcost
			local newmult = card.ability.extra.mult + (card.ability.extra.mult_mod * card.ability.timesSold)
			card.ability.extra.mult = newmult
			table.remove(G.GAME.deathsold, 1)
		end
	end
end

return jokerInfo
	