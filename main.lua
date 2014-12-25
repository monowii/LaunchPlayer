--PlayerLaunch by monowii (22/12/2012)

function Initialize(Plugin)
	Plugin:SetName("LaunchPlayer")
	Plugin:SetVersion(1)
	
	cRoot:Get():GetPluginManager().AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMove)
	cRoot:Get():GetPluginManager().AddHook(cPluginManager.HOOK_UPDATING_SIGN, OnUpdatingSign)

	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
	if Player == nil then return false end

	if Line1 == "[LaunchPlayer]" then
		if not Player:HasPermission("LaunchPlayer.admin") then
			Player:SendMessage("§cYou don't have permission to place this sign !")
			return true
		end
	end
end

local floor = math.floor
function OnPlayerMove(Player, OldPosition, NewPosition)
	-- If the player is on the same block
	if floor(OldPosition.x) == floor(NewPosition.x) and floor(OldPosition.y) == floor(NewPosition.y) and floor(OldPosition.z) == floor(NewPosition.z) then
		return false
	end

	--If the player step on a stone pressure plate
	if Player:GetWorld():GetBlock(floor(NewPosition.x), floor(NewPosition.y), floor(NewPosition.z)) == 70 then

		--If there is a sign two blocks under the stone pressure plate
		if Player:GetWorld():GetBlock(floor(NewPosition.x), floor(NewPosition.y) - 2, floor(NewPosition.z)) == 63 then
			
			Player:GetWorld():DoWithBlockEntityAt(floor(NewPosition.x), floor(NewPosition.y) - 2, floor(NewPosition.z),
				function (blockEntity)
					local Sign = tolua.cast(blockEntity, "cSignEntity")

					if Sign:GetLine(0) == "[LaunchPlayer]" then
						
						local Directions = splitStringBySpaces(Sign:GetLine(1))
						
						if #Directions == 3 then
							if tonumber(Directions[1]) ~= nil and tonumber(Directions[2]) ~= nil and tonumber(Directions[3]) ~= nil then
								Player:SetSpeed(Directions[1], Directions[2], Directions[3])
								Player:SendMessage("Whoooos!")
							end
						end
					end
				end
			)
		end
	end
end

function splitStringBySpaces(string)
	t = {}
	i = 1
	for token in string.gmatch(string, "[^%s]+") do
		t[i] = token
		i = i + 1
	end
	return t
end
