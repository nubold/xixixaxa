local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")
local HttpService = getService("HttpService")
local RunService = getService("RunService")

local useStudio = RunService:IsStudio() or false

local requestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

local function callSafely(func, ...)
	if func then
		local success, result = pcall(func, ...)
		if not success then
			return false
		else
			return result
		end
	end
end

local function ensureFolder(folderPath)
	if isfolder and not callSafely(isfolder, folderPath) then
		callSafely(makefolder, folderPath)
	end
end

local RayfieldFolder = "Witchassault"
local ConfigurationExtension = ".rfld"

local RayfieldLibrary = {}

function RayfieldLibrary:CreateWindow(Settings)
	local Passthrough = false

	if Settings.Discord and Settings.Discord.Enabled and Settings.Discord.Invite and not useStudio then
		ensureFolder(RayfieldFolder.."/Discord Invites")

		local inviteCode = tostring(Settings.Discord.Invite)
		local filePath = RayfieldFolder.."/Discord Invites/"..inviteCode..ConfigurationExtension

		if not callSafely(isfile, filePath) then
			if requestFunc then
				pcall(function()
					requestFunc({
						Url = 'http://127.0.0.1:6463/rpc?v=1',
						Method = 'POST',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = HttpService:JSONEncode({
							cmd = 'INVITE_BROWSER',
							nonce = HttpService:GenerateGUID(false),
							args = {code = inviteCode}
						})
					})
				end)
			end

			if Settings.Discord.RememberJoins then
				callSafely(writefile, filePath, "RememberJoins is true")
			end
		end
	end

	if (Settings.KeySystem) then
		if not Settings.KeySettings then
			Passthrough = true
		else
			local AttemptsRemaining = Settings.KeySettings.MaxAttempts or 5
			local objects = callSafely(game.GetObjects, game, "rbxassetid://11380036235")
			local KeyUI = useStudio and script.Parent:FindFirstChild('Key') or (objects and objects[1])

			if not KeyUI then
				Passthrough = true
				return RayfieldLibrary
			end

			KeyUI.Enabled = true

			if gethui then
				KeyUI.Parent = gethui()
			elseif syn and syn.protect_gui then 
				syn.protect_gui(KeyUI)
				KeyUI.Parent = CoreGui
			elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
				KeyUI.Parent = CoreGui:FindFirstChild("RobloxGui")
			elseif not useStudio then
				KeyUI.Parent = CoreGui
			end

			if gethui then
				for _, Interface in ipairs(gethui():GetChildren()) do
					if Interface.Name == KeyUI.Name and Interface ~= KeyUI then
						Interface.Enabled = false
						Interface.Name = "KeyUI-Old"
					end
				end
			elseif not useStudio then
				for _, Interface in ipairs(CoreGui:GetChildren()) do
					if Interface.Name == KeyUI.Name and Interface ~= KeyUI then
						Interface.Enabled = false
						Interface.Name = "KeyUI-Old"
					end
				end
			end

			local KeyMain = KeyUI:FindFirstChild("Main")
			if not KeyMain then
				Passthrough = true
				return RayfieldLibrary
			end

			if KeyMain:FindFirstChild("Title") then KeyMain.Title.Text = Settings.KeySettings.Title or Settings.Name or "Key System" end
			if KeyMain:FindFirstChild("Subtitle") then KeyMain.Subtitle.Text = Settings.KeySettings.Subtitle or "Key System" end
			if KeyMain:FindFirstChild("NoteMessage") then 
				KeyMain.NoteMessage.Text = Settings.KeySettings.Note or "No instructions"
				KeyMain.NoteMessage.TextWrapped = true
				KeyMain.NoteMessage.TextScaled = true
			end

			KeyMain.Size = UDim2.new(0, 467, 0, 175)
			KeyMain.BackgroundTransparency = 1
			if KeyMain:FindFirstChild("Shadow") and KeyMain.Shadow:FindFirstChild("Image") then KeyMain.Shadow.Image.ImageTransparency = 1 end
			if KeyMain:FindFirstChild("Title") then KeyMain.Title.TextTransparency = 1 end
			if KeyMain:FindFirstChild("Subtitle") then KeyMain.Subtitle.TextTransparency = 1 end
			if KeyMain:FindFirstChild("KeyNote") then KeyMain.KeyNote.TextTransparency = 1 end
			if KeyMain:FindFirstChild("Input") then
				KeyMain.Input.BackgroundTransparency = 1
				if KeyMain.Input:FindFirstChild("UIStroke") then KeyMain.Input.UIStroke.Transparency = 1 end
				if KeyMain.Input:FindFirstChild("InputBox") then KeyMain.Input.InputBox.TextTransparency = 1 end
			end
			if KeyMain:FindFirstChild("NoteTitle") then KeyMain.NoteTitle.TextTransparency = 1 end
			if KeyMain:FindFirstChild("NoteMessage") then KeyMain.NoteMessage.TextTransparency = 1 end
			if KeyMain:FindFirstChild("Hide") then KeyMain.Hide.ImageTransparency = 1 end

			TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 187)}):Play()
			if KeyMain:FindFirstChild("Shadow") and KeyMain.Shadow:FindFirstChild("Image") then
				TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
			end
			task.wait(0.05)
			if KeyMain:FindFirstChild("Title") then TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			if KeyMain:FindFirstChild("Subtitle") then TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			task.wait(0.05)
			if KeyMain:FindFirstChild("KeyNote") then TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			if KeyMain:FindFirstChild("Input") then
				TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				if KeyMain.Input:FindFirstChild("UIStroke") then TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 0}):Play() end
				if KeyMain.Input:FindFirstChild("InputBox") then TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			end
			task.wait(0.05)
			if KeyMain:FindFirstChild("NoteTitle") then TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			if KeyMain:FindFirstChild("NoteMessage") then TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			task.wait(0.15)
			if KeyMain:FindFirstChild("Hide") then TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {ImageTransparency = 0.3}):Play() end

			if KeyMain:FindFirstChild("Input") and KeyMain.Input:FindFirstChild("InputBox") then
				KeyMain.Input.InputBox.FocusLost:Connect(function()
					local enteredKey = KeyMain.Input.InputBox.Text
					if #enteredKey == 0 then return end
					local KeyFound = false

					if Settings.KeySettings.API then
						local success, response = pcall(function()
							return game:HttpGet(tostring(Settings.KeySettings.API) .. enteredKey)
						end)
						local respStr = tostring(response or ""):lower()
						if success and (respStr == "true" or respStr == "valid" or string.find(respStr, "success") or string.find(respStr, "valid")) then
							KeyFound = true
						end
					else
						if Settings.KeySettings.Key then
							for _, MKey in ipairs(Settings.KeySettings.Key) do
								if enteredKey == MKey then
									KeyFound = true
								end
							end
						end
					end

					if KeyFound then
						KeyUI:Destroy()
						Passthrough = true
					else
						if AttemptsRemaining == 0 then
							KeyUI:Destroy()
							Players.LocalPlayer:Kick("No Attempts Remaining")
							game:Shutdown()
						end
						KeyMain.Input.InputBox.Text = ""
						AttemptsRemaining = AttemptsRemaining - 1
						TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 467, 0, 175)}):Play()
						TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Position = UDim2.new(0.495,0,0.5,0)}):Play()
						task.wait(0.1)
						TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Position = UDim2.new(0.505,0,0.5,0)}):Play()
						task.wait(0.1)
						TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5,0,0.5,0)}):Play()
						TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 187)}):Play()
					end
				end)
			end

			if KeyMain:FindFirstChild("Hide") then
				KeyMain.Hide.MouseButton1Click:Connect(function()
					KeyUI:Destroy()
					Passthrough = true
				end)
			end
		end
	else
		Passthrough = true
	end

	if Settings.KeySystem then
		repeat task.wait() until Passthrough
	end

	local Window = {
		CreateTab = function()
			return {
				CreateLabel = function() end
			}
		end
	}

	return Window
end

function RayfieldLibrary:Destroy()
end

return RayfieldLibrary
