AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 7

	local pl = self:GetOwner()
	local aimvec = pl:GetAimVector()
	aimvec.z = math.max(aimvec.z, 0.2)
	aimvec = aimvec:Normalize()
	local vStart = pl:GetShootPos() + Vector(0,0,-48)
	local tr = util.TraceLine({start=vStart, endpos=vStart + pl:GetAimVector() * 30, filter=pl})
	if tr.Hit then
		self:SetPos(tr.HitPos + tr.HitNormal * 4)
	else
		self:SetPos(tr.HitPos)
	end
	self:SetModel("models/props/cs_italy/orange.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	//self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:ApplyForceCenter(aimvec * 2500)
		phys:SetMass(4)
		phys:SetMaterial("metal")
	end
	pl:EmitSound("weapons/crossbow/bolt_fly4.wav", 90, 150)
end

function ENT:Think()
	if CurTime() > self.DieTime then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local hitent = data.HitEntity

	if hitent and hitent.SendLua and hitent:Team() ~= TEAM_UNDEAD then
		local owner = self:GetOwner()
		if owner and owner:IsValid() and owner:Team() == TEAM_UNDEAD then
			hitent:TakeDamage(10, owner)
		else
			hitent:TakeDamage(10, self)
		end

		local attach = hitent:GetAttachment(1)
		if attach then
			if data.HitPos:Distance(hitent:GetAttachment(1).Pos) < 25 then
				//hitent:SendLua("EyePoisoned()")
				if hitent.Female then
					hitent:EmitSound("vo/npc/Alyx/uggh02.wav")
				else
					hitent:EmitSound("vo/ravenholm/monk_death07.wav")
				end
				local timername = tostring(hitent).."poisonedby"..tostring(self)
				timer.Create(timername, 1, math.random(3, 5), DoPoisoned, hitent, owner, timername)
				hitent:SendLua("PoisEff()")
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(data.HitPos)
	util.Effect("spithit", effectdata)

	phys:EnableMotion(false)
	self.DieTime = 0
	function self:PhysicsCollide() end
end

function ENT:Touch(ent)
	if ent ~= self:GetOwner() then
		self:PhysicsCollide({HitEntity=ent, HitPos=self:GetPos()}, self:GetPhysicsObject())
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
