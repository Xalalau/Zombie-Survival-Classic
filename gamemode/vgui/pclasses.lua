local function SwitchClass(btn)
	RunConsoleCommand("zs_class", btn.Class.Name)
	surface.PlaySound("buttons/button15.wav")
	pClasses:SetVisible(false)
end

function MakepClasses()
	if pClasses then
		pClasses:Remove()
		pClasses = nil
	end

	local Window = vgui.Create("DFrame")
	Window:SetPos(w * 0.25, h * 0.025)
	Window:SetSize(w * 0.5, h * 0.95)
	Window:SetTitle(" ")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetCursor("pointer")
	pClasses = Window

	surface.SetFont("HUDFontAA")
	local tw, th = surface.GetTextSize("Choose a class...")
	local label = vgui.Create("DLabel", Window)
	label:SetPos(w * 0.25 - tw * 0.5, 21)
	label:SetSize(tw, th)
	label:SetFont("HUDFontAA")
	label:SetText("Choose a class...")
	label:SetTextColor(color_white)

	local y = 60

	for i, class in ipairs(ZombieClasses) do
		if not class.Hidden then
			local button = vgui.Create("SpawnIcon", Window)
			button:SetPos(16, y)
			button:SetSize(48, 48)
			button:SetModel(class.Model)
			button.Class = class
			button.OnMousePressed = SwitchClass

			surface.SetFont("HUDFontSmallAA")
			local tw, th = surface.GetTextSize(class.Name)
			local label = vgui.Create("DLabel", Window)
			label:SetPos(button:GetWide() + 24, y + 2)
			label:SetSize(tw, th)
			label:SetFont("HUDFontSmallAA")
			label:SetText(class.Name)
			if class.Threshold <= INFLICTION then
				label:SetTextColor(COLOR_LIMEGREEN)
			else
				label:SetTextColor(COLOR_RED)
			end

			local yy = y + 2 + th
			for i, line in ipairs(string.Explode("@", class.Description)) do
				surface.SetFont("Default")
				local tw, th = surface.GetTextSize(line)
				local label = vgui.Create("DLabel", Window)
				label:SetPos(button:GetWide() + 27, yy)
				label:SetSize(tw, th)
				label:SetFont("Default")
				label:SetText(line)
				label:SetTextColor(COLOR_GRAY)
				yy = yy + th + 1
			end

			y = y + button:GetTall() + 16
		end
	end
end
