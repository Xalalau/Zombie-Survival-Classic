AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Deployed = false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(false)
	self:GetOwner():DrawWorldModel(false)

	if self.Deployed then return end
	self.Deployed = true

	local effectdata = EffectData()
		effectdata:SetEntity(self:GetOwner())
	util.Effect("chemzombieambient", effectdata)
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end
