task.wait(4)
getgenv().team = "Marines" -- Pirates

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

local plr = game.Players.LocalPlayer

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        task.wait(3)
        local l_Remotes_0 = game.ReplicatedStorage:WaitForChild("Remotes");
        l_Remotes_0.CommF_:InvokeServer("SetTeam", getgenv().team);
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end

if game.PlaceId ~= 7449423635 then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end
