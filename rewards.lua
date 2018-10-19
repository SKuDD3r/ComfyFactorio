-- Rewards Module
-- Made by: skudd3r for ComfyPlay
-- This module sets the rewards based on the killscore(score module)

local Event = require 'utils.event'
local Token = require 'utils.global_token'
local Task = require 'utils.Task'
local floor = math.floor
local sqrt = math.sqrt
local insert = table.insert


local rewards_loot = {
	[1] = {{name = "submachine-gun", count = 1, text = " Submachine Gun"}},
	[2] = {{name = "defender-capsule", count = 20, text = " Defender-Bots"}},
	[3] = {{name = "shotgun", count = 1, text = " Shotgun"}, {name = "shotgun-shell", count = 100, text = " Shotgun Shells"}},
	[4] = {{name = "heavy-armor", count = 1, text = " Heavy Armor"}},
	[5] = {{name = "grenade", count = 50, text = " Grenades"}},
	[6] = {{name = "land-mine", count = 50, text = " Landmines"}},
	[7] = {{name = "piercing-rounds-magazine", count = 400, text = " AP Rounds"}},
	[8] = {{name = "piercing-shotgun-shell", count = 100, text = " AP Shotgun Shells"}},
	[9] = {{name = "poison-capsule", count = 50, text = " Poison Capsule"}},
	[10] = {{name = "combat-shotgun", count = 1, text = " Combat Shotgun"}, {name = "computer", count = 1, text = " Teleporter Computer"}},
	[11] = {{name = "modular-armor", count = 1, text = " Modular Armor"}, {name = "solar-panel-equipment", count = 2, text = " Portable Solar Panel"}, {name = "battery-equipment", count = 1, text = " MK1 Battery"}, {name = "night-vision-equipment", count = 1, text = " Night Vision Goggles"}},
	[12] = {{name = "cluster-grenade", count = 20, text = " Cluster Grenades"}},
	[13] = {{name = "rocket-launcher", count = 1, text = " Rocket Launcher"}, {name = "rocket", count = 100, text = " Rockets"}},
	[14] = {{name = "slowdown-capsule", count = 20, text = " Slowdown Capsule"}, {name = "piercing-rounds-magazine", count = 400, text = " AP Rounds"}},
	[15] = {{name = "battery-equipment", count = 2, text = " MK1 Battery"}, {name = "solar-panel-equipment", count = 4, text = " Portable Solar Panel"}},
	[16] = {{name = "energy-shield-equipment", count = 1, text = " Energy Shield MK1"}, {name = "cluster-grenade", count = 20, text = " Cluster Grenades"}},
	[17] = {{name = "energy-shield-equipment", count = 1, text = " Energy Shield MK1"}, {name = "land-mine", count = 20, text = " Landmines"}},
	[18] = {{name = "exoskeleton-equipment", count = 1, text = " Exoskelet"}},
	[19] = {{name = "battery-mk2-equipment", count = 1, text = " Armor Battery Mk2"}},
	[20] = {{name = "power-armor", count = 1, text = " Power Armor MK1"}, {name = "computer", count = 1, text = " Teleporter Computer"}},
	[21] = {{name = "personal-roboport-equipment", count = 1, text = " Armor Roboport MK1"}, {name = "construction-robot", count = 10, text = " Construction-Bots"}},
	[22] = {{name = "personal-laser-defense-equipment", count = 1, text = " Personal Laser Defense"}},
	[23] = {{name = "rocket", count = 100, text = " Rockets"}, {name = "cluster-grenade", count = 20, text = " Cluster-Grenades"}},
	[24] = {{name = "explosive-rocket", count = 100, text = " Explosive Rockets"}, {name = "piercing-rounds-magazine", count = 400, text = " AP Rounds"}},
	[25] = {{name = "land-mine", count = 50, text = " Landmines"}, {name = "solar-panel-equipment", count = 2, text = " Portable Solar Panel"}},
	[26] = {{name = "flamethrower", count = 1, text = " Flamethrower"}, {name = "flamethrower-ammo", count = 100, text = " Flamethrower Rounds"}},
	[27] = {{name = "energy-shield-equipment", count = 2, text = " Energy Shield MK1"}, {name = "poison-capsule", count = 50, text = " Poison-Capsule"}},
	[28] = {{name = "exoskeleton-equipment", count = 1, text = " Exoskelet"}, {name = "battery-mk2-equipment", count = 1, text = " Armor Battery Mk2"}},
	[29] = {{name = "distractor-capsule", count = 40, text = " Distractor Bots"}},
	[30] = {{name = "fusion-reactor-equipment", count = 1, text = " Fusion Reactor"}, {name = "computer", count = 1, text = " Teleporter Computer"}},
	[31] = {{name = "uranium-rounds-magazine", count = 400, text = " Uranium Rounds"}},
	[32] = {{name = "destroyer-capsule", count = 40, text = " Destroyer Bots"}},
	[33] = {{name = "power-armor-mk2", count = 1, text = " Power Armor MK2"}},
	[34] = {{name = "exoskeleton-equipment", count = 1, text = " Exoskeleton"}},
	[35] = {{name = "energy-shield-mk2-equipment", count = 1, text = " Energy Shield MK2"}},
	[36] = {{name = "personal-roboport-mk2-equipment", count = 1, text = " Personal Roboport MK2"}},
	[37] = {{name = "personal-laser-defense-equipment", count = 1, text = " Personal Laser Defense"}},
	[38] = {{name = "fusion-reactor-equipment", count = 1, text = " Fusion Reactor"}},
	[39] = {{name = "atomic-bomb", count = 10, text = " Atomic Rockets"}},
	[40] = {{name = "computer", count = 1, text = " Teleporter Computer"}}
	}

--Callback to trigger the player level
local callback =
    Token.register(
    function(data)
        if #data.pos_list < 1 then return end
		for i=1, #data.pos_list, 1 do
			if data.pos_list[i].distance >= data.run then
				local splash = data.surface.create_entity({name = "water-splash", position = data.pos_list[i].position})
			end
		end
    end
)

local function reward_messages(data)
	local player = data.player
	local item_rewards = data.rewards
	--Check that the table isn't empty
	if #item_rewards < 1 then return end
	local print_text = ""
	--Loop through all of the rewards for this level and print out flying text
	for i=1, #item_rewards, 1 do
		local text_effect = player.surface.create_entity({name = "flying-text", position = {player.position.x, player.position.y + (i*0.5)}, text = item_rewards[i].text, color = {r=0.95, g=0.95, b=0.95}})
		if i > 1 then
			print_text = item_rewards[i].text .. " " .. print_text
		else
			print_text = item_rewards[i].text
		end
	end
	player.print("Kill Score Level " .. data.next_level .. " Achieved! Rewards: " .. print_text , { r=1.0, g=0.84, b=0.36})
end

local function kill_rewards(event)
	local player = event.cause.player 
	local score = global.score[player.force.name]
	local kill_score = score.players[player.name].killscore
	
	--If kill score isn't found don't run the other stuff
	if not kill_score then return end
	local surface = player.surface
	local center_position = surface.get_tile(player.position).position
	local current_level = global.rewards[player.name].level
	local next_level_score = ((3.5 + current_level+1)^2.7 / 10) * 100
	if kill_score >= next_level_score then
		local next_level = current_level + 1
		global.rewards[player.name].level = next_level
		
		--Get item rewards for this level
		local leveled_list = {}
		for _, v in pairs(rewards_loot[next_level]) do
			insert(leveled_list, {text = "+" .. v.count .. v.text})
		end
		reward_messages({player = player, rewards = leveled_list, next_level = next_level})
		
		--Insert Item rewards into players inventory
		local pinsert = player.insert
		for k, item in pairs(rewards_loot[next_level]) do
			pinsert({name = item.name, count = item.count})
		end

		--Creates the level up effect in a radius
		for i = 1, 5, 1 do
			local area = {}
			local pos_list = {}
			area = {left_top = {x = (center_position.x - i), y = (center_position.y - i)}, right_bottom = {x = (center_position.x + i + 1), y = (center_position.y + i + 1)}}
			for _, t in pairs(surface.find_tiles_filtered{area = area}) do
				local distance = floor(sqrt((center_position.x - t.position.x)^2 + (center_position.y - t.position.y)^2))
				if (distance <= i) then
					insert(pos_list, {position = {t.position.x+1, t.position.y+1}, distance = distance})
				end
			end
		--Sets each new timer for each tile expansions loop
		Task.set_timeout_in_ticks(10+i*10, callback, {pos_list = pos_list, surface = surface, run = i})
		end
	end
end

--change to on player joined, setup this way for testing atm
local function check_data(event)
	local player = game.players[event.player_index]
	if not global.rewards then global.rewards = {} end
	if not global.rewards[player.name] then global.rewards[player.name] = {level = 0} end	
end

Event.add(defines.events.on_entity_died, kill_rewards)
Event.add(defines.events.on_player_joined_game, check_data)