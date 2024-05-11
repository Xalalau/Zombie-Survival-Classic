AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Headcrabs = 2

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	if not self.NextHit then return end

	if self.NextSwingAnim and CurTime() > self.NextSwingAnim then
		if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		self.SwapAnims = not self.SwapAnims
		self.NextSwingAnim = nil
	end

	if CurTime() < self.NextHit then return end

	self.NextHit = nil
	local trace = self.Owner:TraceLine(95, MASK_SHOT)
	local ent
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() and self.PreHit:GetPos():Distance(self.Owner:GetShootPos()) < 135 then
		ent = self.PreHit
		trace.Hit = true
	end

	local damage = 45 + 45 * math.min(GetZombieFocus(self.Owner:GetPos(), 300, 0.001, 0) - 0.3, 1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local phys = ent:GetPhysicsObject()
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD then
					local vel = self.Owner:EyeAngles():Forward() * 500
					vel.z = 120
					ent:SetVelocity(vel)
				end
			elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 600 * self.Owner:EyeAngles():Forward()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(self.Owner:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(self.Owner)
			end
			ent:TakeDamage(damage, self.Owner)
		end
	end

 	if trace.Hit then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 90, 80)
	end

	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, 80)
	self.PreHit = nil
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextSwingAnim = CurTime() + 0.6
	self.NextHit = CurTime() + 1
	local trace = self.Owner:TraceLine(95, MASK_SHOT)
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	if self.Headcrabs <= 0 then
		self.Owner:EmitSound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav")
		self.NextYell = CurTime() + 2
		return
	end
	self.Owner:SetAnimation(PLAYER_SUPERJUMP)
	self.Owner:EmitSound("npc/zombie_poison/pz_throw"..math.random(2,3)..".wav")
	GAMEMODE:SetPlayerSpeed(self.Owner, 1)
	self.NextYell = CurTime() + 4
	timer.Simple(1, ThrowHeadcrab, self.Owner, self)
end

function SWEP:Reload()
	return false
end
