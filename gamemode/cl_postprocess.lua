DISABLE_PP = false
CreateClientConVar("_disable_pp", 0, true, false)
CreateClientConVar("_zs_enablefilmgrain", 1, true, false)
CreateClientConVar("_zs_enablecolormod", 1, true, false)
CreateClientConVar("_zs_filmgrainopacity", 16, true, false)
//CreateClientConVar("_zs_enablemotionblur", 1, true, false)

DISABLE_PP = util.tobool(GetConVarNumber("_disable_pp"))
local FILM_GRAIN = util.tobool(GetConVarNumber("_zs_enablefilmgrain"))
local FILM_GRAIN_OPACITY = GetConVarNumber("_zs_filmgrainopacity")
local COLOR_MOD = util.tobool(GetConVarNumber("_zs_enablecolormod"))
//local MOTION_BLUR = util.tobool(GetConVarNumber("_zs_enablemotionblur"))

local tex_MotionBlur = render.GetMoBlurTex0()

local MotionBlur = 0.0

ColorModify = {}
ColorModify["$pp_colour_addr"] = 0
ColorModify["$pp_colour_addg" ] = 0
ColorModify["$pp_colour_addb" ] = 0
ColorModify["$pp_colour_brightness" ] = 0
ColorModify["$pp_colour_contrast" ] = 1
ColorModify["$pp_colour_colour" ] = 1
ColorModify["$pp_colour_mulr" ] = 0
ColorModify["$pp_colour_mulg" ] = 0
ColorModify["$pp_colour_mulb" ] = 0

local CURRENTGRAIN = 1

local matFilmGrain = {}
for _, filename in pairs(file.Find("../materials/zombiesurvival/filmgrain?.vtf")) do
	table.insert(matFilmGrain, surface.GetTextureID("zombiesurvival/"..string.sub(filename, 1, -5)))
end

if render.GetDXLevel() >= 90 then
	function GM:RenderScreenspaceEffects()
		if DISABLE_PP then return end

		if COLOR_MOD then
			DrawColorModify(ColorModify)
		end

		/*if MOTION_BLUR and MotionBlur > 0 then
			DrawMotionBlur(1 - MotionBlur, 1.0, 0.0)
			MotionBlur = MotionBlur - 0.3 * FrameTime()
		end*/

		if FILM_GRAIN then
			surface.SetTexture(matFilmGrain[math.floor(CURRENTGRAIN)])
			surface.SetDrawColor(225, 225, 225, FILM_GRAIN_OPACITY)
			surface.DrawTexturedRect(0, 0, w, h)

			CURRENTGRAIN = CURRENTGRAIN + FrameTime() * 25
			if CURRENTGRAIN >= 6 then
				CURRENTGRAIN = 1
			end
		end

		if MySelf:IsValid() then
			if not MySelf:Alive() then
				DeadC()
			elseif MySelf:Team() == TEAM_HUMAN then
				if MySelf:Health() <= 30 then
					ColorModify["$pp_colour_addr"] = math.Approach(ColorModify["$pp_colour_addr"], 0.12, FrameTime() * 0.04)
					ColorModify["$pp_colour_mulr"] = 1
					MotionBlur = 0.4
				else
					ColorModify["$pp_colour_addr"] = 0
					//ColorModify["$pp_colour_mulr"] = 1 + NearZombies * 0.04
					//ColorModify["$pp_colour_brightness"] = NearZombies * 0.005
				end
			end
		end
	end
else
	function GM:RenderScreenspaceEffects()
	end
end

local texPoison = surface.GetTextureID("Decals/decal_birdpoop004.vmt")

local function PaintBlindness()
	surface.SetTexture(texPoison)
	surface.SetDrawColor(40, 255, 40, math.min(230, (MySelf.Blindness - CurTime()) * 90))
	surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, w * 0.9, h * 0.9, MySelf.BlindRotate)

	MySelf.BlindRotate = MySelf.BlindRotate + FrameTime() * 15
	if MySelf.BlindRotate > 360 then
		MySelf.BlindRotate = MySelf.BlindRotate - 360
	end

	if CurTime() > MySelf.Blindness then
		MySelf.Blindness = nil
		MySelf.BlindRotate = nil
		hook.Remove("HUDPaint", "EyePoison")
	end
end

function EyePoisoned()
	MySelf.Blindness = CurTime() + math.random(14, 18)
	MySelf.BlindRotate = 0
	PoisEff()

	hook.Add("HUDPaint", "EyePoison", PaintBlindness)
end

local function DecayPoisonedEffect()
	ColorModify["$pp_colour_addg"] = math.Approach(ColorModify["$pp_colour_addg"], 0, FrameTime() * 0.5)
	ColorModify["$pp_colour_brightness"] = math.Approach(ColorModify["$pp_colour_brightness"], 0, FrameTime() * 0.5)

	if ColorModify["$pp_colour_addg"] <= 0 then
		timer.Destroy("poison")
	end
end

function PoisEff()
	ColorModify["$pp_colour_addg"] = 0.25
	ColorModify["$pp_colour_brightness"] = 0.25
	timer.Create("poison", 0, 0, DecayPoisonedEffect)
end

function DeadC()
	MotionBlur = 0.91
	//render.SetMaterial(matBlurEdges)
	//render.UpdateScreenEffectTexture()
	//render.DrawScreenQuad()
	//render.DrawScreenQuad()
	//render.DrawScreenQuad()
	ColorModify["$pp_colour_addr"] = 0.3
	ColorModify["$pp_colour_addg"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_brightness"] = 0
	ColorModify["$pp_colour_contrast"] = 1
	ColorModify["$pp_colour_colour"] = 1
	ColorModify["$pp_colour_mulr"] = 0
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_mulb"] = 0
	DLV = nil
end

function DoZomC()
	ColorModify["$pp_colour_brightness"] = -0.05
	ColorModify["$pp_colour_contrast"] = 1.5
	ColorModify["$pp_colour_colour"] = 1
	ColorModify["$pp_colour_addr"] = 0
	ColorModify["$pp_colour_addg"] = 0.15
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_mulr"] = 50
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_mulb"] = 0
	DLV = nil
	MotionBlur = 0
end

function ZomC()
	GAMEMODE:ResetWaterAndCramps()
	hook.Remove("Think", "ApproachDLC")
	timer.Simple(0.3, DoZomC)
end

local function ApproachDLVC()
	local ft = FrameTime()
	ColorModify["$pp_colour_mulr"] = math.Approach(ColorModify["$pp_colour_mulr"], -15, ft * 30)
	ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 0, ft)
	ColorModify["$pp_colour_brightness"] = math.Approach(ColorModify["$pp_colour_brightness"], -0.17, ft * 0.25)
	ColorModify["$pp_colour_contrast"] = math.Approach(ColorModify["$pp_colour_contrast"], -5, ft * 5)
	ColorModify["$pp_colour_addg"] = math.Approach(ColorModify["$pp_colour_addg"], -0.02, ft)
	ColorModify["$pp_colour_mulb"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_addr"] = 0
	if ColorModify["$pp_colour_mulr"] == -15 and ColorModify["$pp_colour_contrast"] == -5 and ColorModify["$pp_colour_addg"] == -0.02 and ColorModify["$pp_colour_brightness"] == -0.17 and ColorModify["$pp_colour_colour"] == 0 then
		hook.Remove("Think", "ApproachDLC")
		DLV = true
	end
end

function DLVC()
	hook.Add("Think", "ApproachDLC", ApproachDLVC)
end

function DoDLC()
	ColorModify["$pp_colour_mulr"] = -15
	ColorModify["$pp_colour_colour"] = 0
	ColorModify["$pp_colour_brightness"] = -0.17
	ColorModify["$pp_colour_contrast"] = -5
	ColorModify["$pp_colour_addg"] = -0.02
	ColorModify["$pp_colour_mulb"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_addr"] = 0
end

function DoHumC()
	ColorModify["$pp_colour_addr"] = 0
	ColorModify["$pp_colour_addg"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_brightness"] = -0.08
	ColorModify["$pp_colour_contrast"] = 1.25
	ColorModify["$pp_colour_colour"] = 1
	ColorModify["$pp_colour_mulr"] = 0
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_mulb"] = 0
	DLV = nil
	HCView = nil
end

function HumC()
	hook.Remove("Think", "ApproachDLC")
	timer.Simple(0.3, DoHumC)
end

local function DisablePP(sender, command, arguments)
	DISABLE_PP = util.tobool(arguments[1])

	if DISABLE_PP then
		RunConsoleCommand("_disable_pp", "1")
		MySelf:ChatPrint("Post process disabled.")
	else
		RunConsoleCommand("_disable_pp", "0")
		MySelf:ChatPrint("Post process enabled.")
	end
end
concommand.Add("disable_pp", DisablePP)
/*
local function ZS_EnableMotionBlur(sender, command, arguments)
	MOTION_BLUR = util.tobool(arguments[1])

	if MOTION_BLUR then
		RunConsoleCommand("_zs_enablemotionblur", "1")
		MySelf:ChatPrint("Motion Blur enabled.")
	else
		RunConsoleCommand("_zs_enablemotionblur", "0")
		MySelf:ChatPrint("Motion Blur disabled.")
	end
end
concommand.Add("zs_enablemotionblur", ZS_EnableMotionBlur)*/

local function ZS_EnableFilmGrain(sender, command, arguments)
	FILM_GRAIN = util.tobool(arguments[1])

	if FILM_GRAIN then
		RunConsoleCommand("_zs_enablefilmgrain", "1")
		MySelf:ChatPrint("Film Grain enabled.")
	else
		RunConsoleCommand("_zs_enablefilmgrain", "0")
		MySelf:ChatPrint("Film Grain disabled.")
	end
end
concommand.Add("zs_enablefilmgrain", ZS_EnableFilmGrain)

local function ZS_EnableColorMod(sender, command, arguments)
	COLOR_MOD = util.tobool(arguments[1])

	if COLOR_MOD then
		RunConsoleCommand("_zs_enablecolormod", "1")
		MySelf:ChatPrint("Color Mod enabled.")
	else
		RunConsoleCommand("_zs_enablecolormod", "0")
		MySelf:ChatPrint("Color Mod disabled.")
	end
end
concommand.Add("zs_enablecolormod", ZS_EnableColorMod)

local function ZS_FilmGrainOpacity(sender, command, arguments)
	FILM_GRAIN_OPACITY = arguments[1]

	RunConsoleCommand("_zs_filmgrainopacity", FILM_GRAIN_OPACITY)
end
concommand.Add("zs_filmgrainopacity", ZS_FilmGrainOpacity)
