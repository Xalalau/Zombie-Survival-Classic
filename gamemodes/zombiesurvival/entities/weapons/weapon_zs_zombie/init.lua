AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.ZombieOnly = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

-- This is to get around that dumb thing where the view anims don't play right.
SWEP.SwapAnims = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
	self.Owner.ZomAnim = math.random(1, 3)
end

-- This is kind of unique. It does a trace on the pre swing to see if it hits anything
-- and then if the after-swing doesn't hit anything, it hits whatever it hit in
-- the pre-swing, as long as the distance is low enough.

function SWEP:Think()
	if not self.NextHit then return end
	if CurTime() < self.NextHit then return end
	self.NextHit = nil

	local pl = self.Owner

	local trace = pl:TraceLine(85, MASK_SHOT)

	local ent = nil
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(pl:GetShootPos()) < 125 then
		ent = self.PreHit
		trace.Hit = true
	end

	if trace.Hit then
		pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
	end

	pl:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	self.PreHit = nil

	if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local damage = 30 -- + 15 * math.min(GetZombieFocus(pl:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.3, 1)
			local phys = ent:GetPhysicsObject()
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD then
					local vel = pl:GetAimVector() * 400
					vel.z = 100
					ent:SetVelocity(vel)
				end
			elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 650 * pl:GetAimVector()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(pl:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(pl)
			end
			ent:TakeDamage(damage, pl, self)
		end
	end
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end

	self.SwapAnims = not self.SwapAnims
	self.Owner:RestartGesture(ACT_MELEE_ATTACK1)
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextYell = self.NextSwing
	self.NextHit = CurTime() + 0.6
	local trace = self.Owner:TraceLine(85, MASK_SHOT)
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	if 0 < self.Owner:GetVelocity():Length() then
		self.Owner:RestartGesture(ACT_WALK_ON_FIRE)
	else
		self.Owner:RestartGesture(ACT_IDLE_ON_FIRE)
	end

	self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav")
	self.NextYell = CurTime() + 2
end

function SWEP:Reload()
	return false
end
