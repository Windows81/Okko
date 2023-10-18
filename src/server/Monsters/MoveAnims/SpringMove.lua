local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local BaseMove = require(script.Parent.BaseMove)
local SpringMove = ObjectOrientate(BaseMove)

function SpringMove:init(...)
	BaseMove.init(self, ...)
	local targett = Instance.new('Part')
	targett.Shape = Enum.PartType.Ball
	targett.Size = Vector3.new(1, 1, 1)
	targett.CanCollide = false
	targett.Transparency = 1
	targett.Anchored = true
	local attachment = Instance.new('Attachment', targett)
	local spring = Instance.new('SpringConstraint', attachment)
	spring.Attachment0 = attachment
	spring.FreeLength = 1e-1
	spring.Stiffness = 5000
	spring.Damping = 500
	self.Spring = spring
	self.Target = targett
	self.Janitor:Add(targett)
	self.Janitor:Add(attachment)
	self.Janitor:Add(spring)
end

function SpringMove:perform(obj: Model, cframe: CFrame): nil
	self.Spring.Attachment1 = obj.PrimaryPart:FindFirstChild('RootAttachment')
	self.Target.CFrame = cframe
	self.Target.Parent = obj
	repeat task.wait() until self.Spring.CurrentLength < 4
	task.wait(5e-1)
end

return SpringMove