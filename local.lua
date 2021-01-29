--//Astraltempus
local plr = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local infoFolder = ReplicatedStorage:WaitForChild("InfoFolder")
local name = plr.Name
local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Loader"))
local DataSync = require("DataSync")
local Cache = {}
local Manager = require("Manager")
local DataSync = require("DataSync")
local Store = DataSync.GetStore("PlayerData")
local file = Store:GetFile(plr.UserId)
local player = game.Players.LocalPlayer
local level = file:GetData("Level")
local CurrentXP = file:GetData("CurrentXP")
local RequiredXP = file:GetData("RequiredXP")
local Credits = file:GetData("Credits")
local PlayerGui = script.Parent.Parent.PlayerGui
local ProgressCount = PlayerGui.LevelGui.Main.ProgressCount
local CreditCount = PlayerGui.LevelGui.Main.CreditCount
local LevelCount = PlayerGui.LevelGui.Main.LevelCount
local XPbar = PlayerGui.LevelGui.Main.XPReq
local bar = PlayerGui.LevelGui.Main.ProgressLimit.Clipping
wait(0.5)
------------------------------------------------------------------------------------------------
local percentage = (CurrentXP/RequiredXP)
ProgressCount.Text = math.floor(percentage).."%"
CreditCount.Text = "Credit: "..Credits
LevelCount.Text = "Level "..level
XPbar.Text = CurrentXP.."/"..RequiredXP
bar:TweenSize(UDim2.new(percentage,0,1,0), "In", "Linear", 0.5)
------------------------------------------------------------------------------------------------
local function GetAndImport()
	level = file:GetData("Level")
	CurrentXP = file:GetData("CurrentXP")
	RequiredXP = file:GetData("RequiredXP")
	if CurrentXP >= RequiredXP then
		wait(0.5)		
		local percentage = (CurrentXP/RequiredXP)
		bar:TweenSize(UDim2.new(percentage,0,1,0), "In", "Linear", 0.5)
		XPbar.Text = CurrentXP.."/"..RequiredXP
		ProgressCount.Text = math.floor(percentage).."%"
		CreditCount.Text = "Credit: "..Credits
		LevelCount.Text = "Level "..level
	else 
		wait(0.5)	
		local Credits = file:GetData("Credits")
		local percentage = (CurrentXP/RequiredXP)
		bar:TweenSize(UDim2.new(percentage,0,1,0), "In", "Linear", 0.5)
		XPbar.Text = CurrentXP.."/"..RequiredXP
		ProgressCount.Text = math.floor(percentage).."%"
		CreditCount.Text = "Credit: "..Credits
		LevelCount.Text = "Level "..level
	end
end
------------------------------------------------------------------------------------------------
Store:Subscribe(plr.UserId, {"CurrentXP"}, function(data)
	GetAndImport()
end)
Store:Subscribe(plr.UserId, {"Level"}, function(data)
	GetAndImport()
end)
------------------------------------------------------------------------------------------------
player.CharacterAdded:Connect(function(player)
	wait(0.5)	
	CurrentXP = file:GetData("CurrentXP")
	RequiredXP = file:GetData("RequiredXP")
	local Credits = file:GetData("Credits")
	local percentage = (CurrentXP/RequiredXP)
	bar:TweenSize(UDim2.new(percentage,0,1,0), "In", "Linear", 0.5)
	XPbar.Text = CurrentXP.."/"..RequiredXP
	ProgressCount.Text = math.floor(percentage).."%"
	CreditCount.Text = "Credit: "..Credits
	GetAndImport()
end)
