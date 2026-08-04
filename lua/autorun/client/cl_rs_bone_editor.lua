hiddenBones = hiddenBones or {}
eyeoffset = eyeoffset or 0

local IsEditorOpen = false
local editorFrame = nil

local function GetHomigradTrueModel()
    local ply = LocalPlayer()
    if not IsValid(ply) then return "models/player/kleiner.mdl" end
	local ragdoll = ply:GetNWEntity("Ragdoll")
    if IsValid(ragdoll) then
        return ragdoll:GetModel() or "models/player/kleiner.mdl"
    end
    return ply:GetModel() or "models/player/kleiner.mdl"
end

local function Homigrad_BoneProcessor(ent)
    if not IsValid(ent) then return end
	
    if hiddenBones then
        for boneName, shouldHide in pairs(hiddenBones) do
            local bIndex = ent:LookupBone(boneName)
            if bIndex and bIndex ~= -1 then
                if shouldHide == true then
                    ent:ManipulateBoneScale(bIndex, Vector(0, 0, 0))
                else
                    ent:ManipulateBoneScale(bIndex, Vector(1, 1, 1))
                end
            end
        end
    end
end

hook.Add("PrePlayerDraw", "RS_Homigrad_CorePlayerSync", function(ply)
    if ply == LocalPlayer() then
        Homigrad_BoneProcessor(ply)
    end
end)

hook.Add("PostDrawOpaqueRenderables", "RS_Homigrad_CoreForceSync", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    Homigrad_BoneProcessor(ply) 

    local ragdoll = ply:GetNWEntity("Ragdoll")
    if IsValid(ragdoll) then
        local mdl = ragdoll:GetModel() or "models/player/kleiner.mdl"
        local cleanName = string.lower(mdl:match("([^/]+)%.mdl$") or "default")
        local path = "homigrad/bone_config/" .. cleanName .. ".json"
        
        if file.Exists(path, "DATA") then
            local data = util.JSONToTable(file.Read(path, "DATA") or "")
            if data then 
				hiddenBones = data.hiddenBones or {} 
				eyeoffset = data.eyeoffset or 0
			end
        end

        -- 3. Force bone destruction onto Homigrad active ragdoll
        Homigrad_BoneProcessor(ragdoll) 
    end
end)

-- Load Configuration Profile
function LoadConfigForModel(modelPath)
    local cleanName = string.lower(modelPath:match("([^/]+)%.mdl$") or "default")
    local path = "homigrad/bone_config/" .. cleanName .. ".json"
    
    if file.Exists(path, "DATA") then
        local raw = file.Read(path, "DATA")
        local data = util.JSONToTable(raw)
        if data and type(data) == "table" then
            hiddenBones = data.hiddenBones or {}
			eyeoffset = data.eyeoffset or 0
            return
        end
    end
    
    -- Default targets if no user JSON profile exists yet
    hiddenBones = {
        ["ValveBiped.Bip01_Head1"] = true,
        ["bip_head"] = true,
        ["head"] = true,
        ["Head"] = true
    }
	eyeoffset = 0
end

-- Save Configuration Profile
local function SaveConfigForModel(modelPath)
    local cleanName = string.lower(modelPath:match("([^/]+)%.mdl$") or "default")
	
    if not file.Exists("homigrad/bone_config/", "DATA") then file.CreateDir("homigrad/bone_config/") end
    
	local outputData = { 
        hiddenBones = hiddenBones,
        eyeoffset = eyeoffset 
    }
    file.Write("homigrad/bone_config/" .. cleanName .. ".json", util.TableToJSON(outputData))
end

timer.Create("RS_ModelConfigTracker", 0.5, 0, function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    local currentModel = GetHomigradTrueModel()
    if currentModel ~= (ply.RS_LastTrackedModel or "") then
        ply.RS_LastTrackedModel = currentModel
        LoadConfigForModel(currentModel)
    end
end)

-- Main Menu Constructor
local function OpenBoneEditor()
    if IsEditorOpen and IsValid(editorFrame) then return end
    IsEditorOpen = true

    local currentModel = GetHomigradTrueModel()
    LoadConfigForModel(currentModel)

    editorFrame = vgui.Create("DFrame")
    editorFrame:SetSize(450, 520)
    editorFrame:Center()
    editorFrame:SetTitle("Bone Menu")
    editorFrame:MakePopup()
    editorFrame.OnClose = function() IsEditorOpen = false end
    editorFrame.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(30, 30, 35, 250))
        draw.RoundedBoxEx(6, 0, 0, w, 30, Color(45, 45, 50, 255), true, true, false, false)
    end

    local lblModel = vgui.Create("DLabel", editorFrame)
    lblModel:SetText("Current Model: " .. (currentModel:match("([^/]+)$") or "Unknown"))
    lblModel:Dock(TOP)
    lblModel:DockMargin(15, 10, 15, 10)
    lblModel:SetFont("DermaDefaultBold")
    lblModel:SetTextColor(Color(255, 255, 255))
	
	local sliderOffset = vgui.Create("DNumSlider", editorFrame)
    sliderOffset:Dock(TOP)
    sliderOffset:DockMargin(15, 5, 15, 5)
    sliderOffset:SetText("Eye Offset:")
    sliderOffset:SetMinMax(-25, 25)
    sliderOffset:SetDecimals(0)
    sliderOffset:SetValue(eyeoffset)
    
    if IsValid(sliderOffset.Label) then
        sliderOffset.Label:SetTextColor(Color(220, 220, 220))
    end
    
    sliderOffset.OnValueChanged = function(_, val)
        eyeoffset = math.Round(val)
        SaveConfigForModel(currentModel)
    end

    local boneList = vgui.Create("DListView", editorFrame)
    boneList:Dock(FILL)
    boneList:DockMargin(15, 0, 15, 15)
    boneList:SetMultiSelect(false)
    boneList:AddColumn("Status"):SetMaxWidth(100)
    boneList:AddColumn("Bone Name")

    local targetEnt = LocalPlayer():GetNWEntity("Ragdoll")
    if not IsValid(targetEnt) then targetEnt = LocalPlayer() end

    if IsValid(targetEnt) then
        local count = targetEnt:GetBoneCount() or 0
        if count > 0 then
            for i = 0, count - 1 do
                local bName = targetEnt:GetBoneName(i)
                if bName and bName ~= "__INVALIDBONE__" and bName ~= "" then
                    if hiddenBones[bName] == nil then
                        hiddenBones[bName] = false
                    end

                    local isHidden = (hiddenBones[bName] == true) and "[ X ] Hidden" or "[   ] Visible"
                    local row = boneList:AddLine(isHidden, bName)
                    
                    if IsValid(row) then
                        local cell1 = row:GetChild(1)
                        local cell2 = row:GetChild(2)
                        if IsValid(cell1) and IsValid(cell2) then
                            if hiddenBones[bName] == true then
                                cell1:SetTextColor(Color(255, 100, 100))
                                cell2:SetTextColor(Color(255, 100, 100))
                            else
                                cell1:SetTextColor(Color(150, 255, 150))
                                cell2:SetTextColor(Color(220, 220, 220))
                            end
                        end
                    end
                end
            end
        end
    end

    boneList.OnRowSelected = function(_, rowIndex, row)
        if not IsValid(row) then return end
        local bName = row:GetValue(2)
        local cell1 = row:GetChild(1)
        local cell2 = row:GetChild(2)
        
        if hiddenBones[bName] == true then
            hiddenBones[bName] = false
            row:SetValue(1, "[   ] Visible")
            if IsValid(cell1) and IsValid(cell2) then
                cell1:SetTextColor(Color(150, 255, 150))
                cell2:SetTextColor(Color(220, 220, 220))
            end
        else
            hiddenBones[bName] = true
            row:SetValue(1, "[ X ] Hidden")
            if IsValid(cell1) and IsValid(cell2) then
                cell1:SetTextColor(Color(255, 100, 100))
                cell2:SetTextColor(Color(255, 100, 100))
            end
        end
        
        SaveConfigForModel(currentModel)
    end
end

concommand.Add("hg_bone_editor", OpenBoneEditor)
