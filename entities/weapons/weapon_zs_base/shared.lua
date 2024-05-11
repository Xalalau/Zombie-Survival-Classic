if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if CLIENT then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true

	surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
	surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

SWEP.Author			= "JetBoom"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15
SWEP.ConeMoving				= 0.03
SWEP.ConeCrouching			= 0.013

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "CombineCannon"

SWEP.WalkSpeed = 200

if SERVER then
	function SWEP:Deploy()
		local timername = tostring(self.Owner).."speedchange"
		timer.Destroy(timername)
		if self.WalkSpeed < self.Owner.WalkSpeed then
			GAMEMODE:SetPlayerSpeed(self.Owner, self.WalkSpeed)
		elseif self.WalkSpeed > self.Owner.WalkSpeed then
			timer.Create(timername, 1, 1, GAMEMODE.SetPlayerSpeed, GAMEMODE, self.Owner, self.WalkSpeed)
		end
		return true
	end

	function SWEP:Initialize()
		self:SetWeaponHoldType(self.HoldType)
	end
end

if CLIENT then
	function SWEP:Initialize()
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end

	self.Weapon:EmitSound(self.Primary.Sound)
	if self.Owner:GetVelocity():Length() > 25 then
		self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.ConeMoving)
	else
		if self.Owner:Crouching() then
			self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.ConeCrouching)
		else
			self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		end
	end
	
	self:TakePrimaryAmmo(1)
	self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0))

	if CLIENT then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

function SWEP:ZSShootBullet(dmg, numbul, cone)
	local owner = self.Owner

	local bullet = {}
	bullet.Num = numbul
	bullet.Src = owner:GetShootPos()
	bullet.Dir = owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 1
	bullet.Force = 2
	bullet.Damage = dmg
	if owner.ZSAwesomeTracer then
		bullet.TracerName = "ToolTracer"
	else
		bullet.TracerName = "AR2Tracer"
	end

	owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:MuzzleFlash()
	owner:SetAnimation(PLAYER_ATTACK1)
end

if CLIENT then
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
	end

	local scalebywidth = (ScrW() / 1024) * 10
	SWEP.CrossHairScale = 1
	function SWEP:DrawHUD()
		if not MySelf:IsValid() then return end

		local x = w * 0.5
		local y = h * 0.5

		local scale

		if MySelf:GetVelocity():Length() > 25 then
			scale = scalebywidth * self.ConeMoving
		else
			if MySelf:Crouching() then
				scale = scalebywidth * self.ConeCrouching
			else
				scale = scalebywidth * self.Primary.Cone
			end
		end

		if MySelf:KeyDown(IN_ZOOM) then
			scale = scale * 5
		end

		surface.SetDrawColor(0, 200, 0, 230)

		local dist = math.abs(self.CrossHairScale - scale)
		self.CrossHairScale = math.Approach(self.CrossHairScale, scale, FrameTime() * 2 + dist * 0.05)

		local dispscale = self.CrossHairScale

		local gap = 40 * dispscale
		local length = gap + 20 * dispscale
		surface.DrawLine(x - length, y, x - gap, y)
		surface.DrawLine(x + length, y, x + gap, y)
		surface.DrawLine(x, y - length, x, y - gap)
		surface.DrawLine(x, y + length, x, y + gap)

		surface.SetDrawColor(255, 0, 0, 230)
		surface.DrawRect(x - 1, y - 1, 2, 2)
	end
end

function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self.Weapon:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		//self.Weapon:DefaultReload( ACT_VM_RELOAD )
		return false
	end
	return true
end

function SWEP:SecondaryAttack()
end
