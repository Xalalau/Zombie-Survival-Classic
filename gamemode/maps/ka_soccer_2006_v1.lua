hook.Add("InitPostEntity", "DestroyTHurts", function()
	for _, ent in pairs(ents.FindByClass("trigger_hurt")) do
		ent:Remove()
	end
	hook.Remove("InitPostEntity", "DestroyTHurts")
end)
