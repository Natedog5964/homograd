if SERVER then return end
local function CreateHeader(panel, text)
    local label = vgui.Create("DLabel", panel)
    label:SetText(text)
    label:SetFont("DermaLarge")
    label:SetTextColor(Color(0, 0, 0))
    label:SizeToContents()
    panel:AddItem(label)
end

hook.Add("PopulateToolMenu", "Homograd_Settings_Menu", function()
    spawnmenu.AddToolMenuOption("Options", "Homograd", "Homograd_Settings", "Homograd Settings", "", "", function(panel)
        panel:ClearControls()
		
		CreateHeader(panel, "Camera")
		
        panel:CheckBox("Bodycam", "hg_bodycam")
        panel:ControlHelp("Turn Bodycam mode on or off.")
		
		panel:CheckBox("Chest Fake Cam", "hg_fakecam_mode")
        panel:ControlHelp("Makes camera when faked fixed to your head (so you cant look around with your mouse).")
		
        local FOVSlider = panel:NumSlider("FOV", "hg_fov", 70, 120, 1)
        FOVSlider:SetTooltip("Sets your FOV ,default is 120.")
        panel:ControlHelp("Your FOV.")
        panel:Help("")
		
		CreateHeader(panel, "Misc")
		
		local ScopeSpeedSlider = panel:NumSlider("Sniper Scoped Speed", "hg_scopespeed", 0.1, 10, 1)
        FOVSlider:SetTooltip("Defaults to 0.5.")
        panel:ControlHelp("Changes the speed of snipers scopes when zoomed in.")
        panel:Help("")
		
		panel:CheckBox("Death Screen", "hg_deathscreen")
        panel:ControlHelp("Turn Homigrad Death Screen on or off.")
		
        local resetBtn = panel:Button("Reset to Defaults")
        resetBtn.DoClick = function()
            RunConsoleCommand("hg_bodycam", "0")
            RunConsoleCommand("hg_fov", "120")
            RunConsoleCommand("hg_scopespeed", "0.5")
			RunConsoleCommand("hg_fakecam_mode", "0")
			RunConsoleCommand("hg_deathscreen", "1")
			
            timer.Simple(0.1, function()
                if IsValid(panel) then
                    spawnmenu.ActivateTool("Homograd_Settings")
                end
            end)
            
            notification.AddLegacy("Homograd settings reset to defaults!", NOTIFY_GENERIC, 3)
            surface.PlaySound("buttons/button15.wav")
        end
    
        
        panel:Help("")
        panel:Help("Homograd is peak.")
    end)
end)

concommand.Add("reload_Homograd_options", function()
    RunConsoleCommand("spawnmenu_reload")
    timer.Simple(0.1, function()
        g_SpawnMenu:Open()
        spawnmenu.ActivateToolPanel(0, "Homograd_Settings_Menu")
    end)
end)
