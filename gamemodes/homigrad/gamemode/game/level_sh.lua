LevelList = {}

function TableRound(name)
	return _G[(name or roundActiveName) or "homicide"]
end

timer.Simple(0, function()
	if roundActiveName == nil then
		if GetConVar("hg_ConstructOnly"):GetBool() == true then
			roundActiveName = "construct"
			roundActiveNameNext = "construct"
		
		elseif GetConVar("hg_hl2Only"):GetBool() == true then
			roundActiveName = "hl2"
			roundActiveNameNext = "hl2"
		else
			roundActiveName = "homicide"
			roundActiveNameNext = "homicide"
		end
	end
end)