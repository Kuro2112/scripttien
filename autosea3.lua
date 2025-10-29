task.wait(4)

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

local plr = game.Players.LocalPlayer

if game.PlaceId ~= 7449423635 then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end
