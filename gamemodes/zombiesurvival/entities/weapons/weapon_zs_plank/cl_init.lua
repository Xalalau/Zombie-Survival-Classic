include("shared.lua")

SWEP.PrintName = "Plank"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 57
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 0
SWEP.SlotPos = 3

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Think()
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
end
