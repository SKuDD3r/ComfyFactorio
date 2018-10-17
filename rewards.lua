local Event = require 'utils.event'

local function kill_rewards(event)
	local score = global.score[player.force.name]
	
	for _, p in pairs(game.connected_players) do
		game.print("true")
		-- local killscore = 0
		-- if score.players[p.name].killscore then killscore = score.players[p.name].killscore
			-- if killscore > 1 then
				-- game.print("You the bestest")
			-- end
		-- end
	end
end

Event.add(defines.events.on_entity_died, kill_rewards)