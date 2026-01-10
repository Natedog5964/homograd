
local function BuildScaledFonts()
    local s = ScrH() / 1080
    if s < 0.1 then s = 1.0 end 

    surface.CreateFont("BloodFont1", { 
        font = "Arial",
        size = math.Round(60 * s),
        weight = 800,
        additive = true
    })
    
    surface.CreateFont("DermaLarge1", {
        font = "DermaLarge", 
        size = math.Round(20 * s), 
        weight = 900,
    })
end

BuildScaledFonts()
hook.Add("OnScreenSizeChanged", "FixBloodFontRes", BuildScaledFonts)
hook.Add("InitPostEntity", "FixBloodFontOnJoin", BuildScaledFonts)

hook.Add("HUDPaint", "DrawBloodAsHealth", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end

    local s = ScrH() / 1080
    local currentBlood = blood or 5000 
    
    local x = 45 * s
    local y = ScrH() - (78 * s)
	
	local Bloodx = 55 * s
    local Bloody = ScrH() - (70 * s)
	
	local numx = 130 * s
    local numy = ScrH() - (95 * s)
	
	draw.RoundedBox(15 * s, x - (10 * s), y - (30 * s), 230 * s, 80 * s, Color(0, 0, 0, 200))

    draw.SimpleText(math.Round(currentBlood), "BloodFont1", numx, numy, Color(255, 50, 50, 255))
	draw.SimpleText("BLOOD: ", "DermaLarge1", Bloodx, Bloody, Color(255, 50, 50, 255))
end)
