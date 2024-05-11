AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
	umsg.Start("RcHCScale")
		umsg.Entity(self.Owner)
	umsg.End()
end

function SWEP:Think()
	if self.Leaping then
		local owner = self.Owner
		if owner:OnGround() or 0 < owner:WaterLevel() then
			self.Leaping = false
			self.NextLeap = CurTime() + 0.75
		else
			local vStart = self.OwnerOffset + owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self.OwnerAngles
			tr.filter = owner
			local trace = util.TraceLine(tr)
			local ent = trace.Entity

			for _, fin in pairs(ents.FindInSphere(owner:GetShootPos() + owner:GetAimVector() * 15, 25)) do
				if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() then
					ent = fin
					break
				end
			end

			if ent:IsValid() then
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire("break", "", 0)
				else
					local damage = 6 + 6 * math.min(GetZombieFocus(owner:GetPos(), 300, 0.001, 0) - 0.3, 1)
					local phys = ent:GetPhysicsObject()

					if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
						local vel = damage * 600 * owner:EyeAngles():Forward()

						phys:ApplyForceOffset(vel, (ent:NearestPoint(owner:GetShootPos()) + ent:GetPos() * 2) / 3)
						ent:SetPhysicsAttacker(owner)
					end
					ent:TakeDamage(damage, owner)
				end
				self.Leaping = false
				self.NextLeap = CurTime() + 1
				owner:EmitSound("npc/headcrab/headbite.wav", 85, 115)
				owner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30)))
			elseif trace.HitWorld then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav", 85, 115)
				self.Leaping = false
				self.NextLeap = CurTime() + 1
			end
		end
	end
end

function SWEP:PrimaryAttack()
	self:SecondaryAttack()
end

SWEP.NextLeap = 0
function SWEP:PrimaryAttack()
	if self.Leaping or CurTime() < self.NextLeap or not self.Owner:OnGround() then return end
	self.Owner:Fire("IgnoreFallDamage", "", 0)

	local vel = self.Owner:GetAimVector()
	vel.z = math.max(0.4, vel.z)
	vel = vel:Normalize()

	local angles = self.Owner:GetAngles():Forward()
	angles.z = -0.1
	angles = angles:Normalize()

	self.OwnerAngles = angles * 48
	self.OwnerOffset = Vector(0, 0, 6)
	self.Owner:SetGroundEntity(NULL)
	self.Owner:SetLocalVelocity(vel * 600)
	self.Owner:EmitSound("npc/headcrab/attack"..math.random(1,3)..".wav", 85, 115)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self.Leaping = true
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end

	self.Owner:EmitSound("npc/headcrab/idle"..math.random(1,3)..".wav")
	self.NextYell = CurTime() + 2
end
