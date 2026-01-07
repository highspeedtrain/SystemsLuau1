local TrainService = {}

local TweenService = game:GetService("TweenService")

function TrainService.StartOperations()
	for _, train in ipairs(workspace:GetDescendants()) do
		if train:IsA("Model") and train:HasTag("Train") then
			TrainService.Operations(train)
		else
			warn(`{train.Name} is not a Model or doesn't have "Train" tag!`)
		end
	end
end

function TrainService.Operations(Train : Model)
	if not Train then return end

	local seat = Train:FindFirstChildOfClass("VehicleSeat")
	if not seat then return end

	local wheels = {}
	for _, inst : Instance in ipairs(Train:GetDescendants()) do
		if inst:IsA("HingeConstraint") and (inst.Name == "WheelL" or inst.Name == "WheelR") then
			inst.ActuatorType = Enum.ActuatorType.Motor
			inst.MotorMaxTorque = math.huge
			table.insert(wheels, inst)
		end
	end

	local tweens = {}
	local maxSpeed = Train:GetAttribute("Speed")
	local reverseSpeed = Train:GetAttribute("ReverseSpeed") or maxSpeed / 2

	seat:GetPropertyChangedSignal("Throttle"):Connect(function()
		local targetVelocity = 0
		for _, wheel : HingeConstraint in ipairs(wheels) do
			if wheel.Name == "WheelL" then
				if seat.Throttle == 1 then
					targetVelocity = maxSpeed
				elseif seat.Throttle == -1 then
					targetVelocity = -reverseSpeed
				else
					targetVelocity = 0
				end
			elseif wheel.Name == "WheelR" then
				if seat.Throttle == 1 then
					targetVelocity = -maxSpeed
				elseif seat.Throttle == -1 then
					targetVelocity = reverseSpeed
				else
					targetVelocity = 0
				end	
			end
			if tweens[wheel] then
				tweens[wheel]:Cancel()
			end
			local tween1 = TweenService:Create(wheel, TweenInfo.new(10, Enum.EasingStyle.Quad), {AngularVelocity = targetVelocity})
			tween1:Play()
			tweens[wheel] = tween1
		end
	end)
end

return TrainService

-- PLACE INSIDE OF MAIN SCRIPT
