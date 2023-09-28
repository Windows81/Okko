local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local BaseMove = require(script.Parent.BaseMove)
local class = ObjectOrientate(BaseMove)

function class:init()
	BaseMove.init(self)
	local targett = Instance.new('Part')
	targett.Shape = Enum.PartType.Ball
	targett.Size = Vector3.new(1, 1, 1)
	targett.CanCollide = false
	targett.Transparency = 1
	targett.Anchored = true
	local attachment = Instance.new('Attachment', targett)
	local spring = Instance.new('SpringConstraint', attachment)
	spring.Attachment1 = attachment
	spring.FreeLength = 1e-1
	spring.Stiffness = 1e4
	spring.Damping = 3e3
	self.Spring = spring
	self.Target = targett
	self.Janitor:Add(targett)
	self.Janitor:Add(attachment)
	self.Janitor:Add(spring)
end

function class:perform(obj: Model, cframe: CFrame): nil
	self.Spring.Attachment0 = obj.PrimaryPart:FindFirstChild('RootAttachment')
	self.Target.CFrame = cframe
	self.Target.Parent = obj
	repeat task.wait() until self.Spring.CurrentLength < 1
end

return class