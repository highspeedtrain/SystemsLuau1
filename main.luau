local TrainOperationService = require(script:FindFirstChild("TrainOperationService"))
local trains = workspace:GetDescendants()

for _, train : Model in ipairs(trains) do
	if train:IsA("Model") and train:HasTag("Train") then
		local seat = train:FindFirstChildOfClass("VehicleSeat")
		if not seat then 
			return 
		end
		seat:GetPropertyChangedSignal("Throttle"):Connect(TrainOperationService.StartOperations)
	else
		warn(`{train.Name} is not a Model or doesn't have "Train" tag!`)
	end
end
TrainOperationService.StartOperations()
