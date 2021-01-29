--//Astraltempus
local http = game:GetService("HttpService")
local webhook = "https://discord.com/api/webhooks/803609716244480041/n5L27azebDV7HB_4d2zq-8bS9AMFqos84gZi3Iyhktw8She6I1NBzl9i5V4di4Dwqv2U"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--// datastore loader
local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Loader"))
local DataSync = require("DataSync")
local Manager = require("Manager")
local DataSync = require("DataSync")
------------------------------------------------------------------------------------------------
local http = game:GetService("HttpService")
local webhook = "https://discord.com/api/webhooks/803609716244480041/n5L27azebDV7HB_4d2zq-8bS9AMFqos84gZi3Iyhktw8She6I1NBzl9i5V4di4Dwqv2U"
local Store = DataSync.GetStore("PlayerData", { -- first parameter is the key of the store
	["Level"] = 1,
	["CurrentXP"] = 0,
	["RequiredXP"] = 0,
	["Credits"] = 0
}):FilterKeys({ "RequiredXP" }) -- NO SAVE
local Cache = {}	
local Players = game:GetService("Players")
------------------------------------------------------------------------------------------------
local function PlayerAdded(plr)
	if Cache[plr] then
		return
	end
	local file = Store:GetFile(plr.UserId)
	Cache[plr] = file
	local level = file:GetData("Level")
	local RequiredXP = ((level+1)*2000)+(100*level)
	file:UpdateData("RequiredXP",RequiredXP)
	------------------------------------------------------------------------------------------------
	Store:Subscribe(plr.UserId, {"CurrentXP"}, function(data)
		local CloudRequired = file:GetData("RequiredXP")
		if data.Value >= CloudRequired then
			local newLevel = file:IncrementData("Level", 1):GetData("Level")
			local RequiredXP = ((newLevel+1)*2000)+(100*newLevel)
			file:UpdateData("RequiredXP",RequiredXP)
			file:UpdateData("CurrentXP",0)
			local DiscordLevelUpMsg = {
				["name"] = plr.Name..":"..plr.UserId,
				["content"] = plr.Name..":"..plr.UserId.." have leveled up to"..newLevel,
			}
			DiscordLevelUpMsg = http:JSONEncode(DiscordLevelUpMsg)
			http:PostAsync(webhook,DiscordLevelUpMsg)
			
		end
	end)
------------------------------------------------------------------------------------------------
	Manager.Wrap(function() --//AWARD MONEY EVERY 5 MINUTES
		while Manager.Wait(300) and Cache[plr] do
			file:IncrementData("CurrentXP", 500)
			file:IncrementData("Credits",499)
		end
	end)
end
------------------------------------------------------------------------------------------------
local function PlayerRemoving(plr)
	if not Cache[plr] then
		return
	end -- if not file exists, dont do anything
	local file = Cache[plr] -- grab the player file
	file:SaveData() 
	wait(0.5)
	Cache[plr] = nil -- uncache the file and free up memory
end
------------------------------------------------------------------------------------------------
Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
for index, plr in pairs(Players:GetPlayers()) do
	PlayerAdded(plr)
end
