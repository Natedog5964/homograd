local plyMeta = FindMetaTable("Player")

function plyMeta:HGTools_GetAccess( bSAdmin ) 
    if bSAdmin and self:IsSuperAdmin() then return true end
    if not bSAdmin and self:IsAdmin() then return true end
    return false
end

local function check(self, ent, ply)
    if not ply:HGTools_GetAccess() then return false end 
	if ( !IsValid( ent ) ) then return false end
	if ( ent:IsPlayer() ) then return true end
    local pEnt = RagdollOwner( ent )
    if ( ent:IsRagdoll() ) and pEnt and pEnt:IsPlayer() and pEnt:Alive() then return true end
end

properties.Add( "strip", {
	MenuLabel = "Strip", -- Name to display on the context menu
	Order = 3, -- The order to display this property relative to other properties
	MenuIcon = "icon16/basket_delete.png", -- The icon to display next to the property

	Filter = check,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
        Derma_Query(
            "The player will be stripped down to only their fists.",
            "Are you sure?",
            "Yes",
            function()
                self:MsgStart()
                    net.WriteEntity( ent )
                self:MsgEnd()
            end,
        	"No"
        )

	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()

		--if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end
        ent = RagdollOwner( ent ) or ent
		ent:StripWeapons( )
        ent:Give("weapon_hands")
		print(tostring(ply:Nick() or ply) .." has stripped ".. tostring(ent:Nick() or ent) .." of their weapons.")
	end 
} )

properties.Add( "fullstrip", {
	MenuLabel = "Full Strip", -- Name to display on the context menu
	Order = 4, -- The order to display this property relative to other properties
	MenuIcon = "icon16/lorry_delete.png", -- The icon to display next to the property

	Filter = check,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
        Derma_Query(
            "All weapons, including fists, will be stripped.",
            "Are you sure?",
            "Yes",
            function()
                self:MsgStart()
                    net.WriteEntity( ent )
                self:MsgEnd()
            end,
        	"No"
        )

	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()

		--if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end
        ent = RagdollOwner( ent ) or ent

		ent:StripWeapons( )
		print(tostring(ply:Nick() or ply) .." has full stripped ".. tostring(ent:Nick() or ent) .." of their weapons and fist.")
	end 
} )

properties.Add( "reset_org", {
	MenuLabel = "Reset organism", -- Name to display on the context menu
	Order = 5, -- The order to display this property relative to other properties
	MenuIcon = "icon16/heart_add.png", -- The icon to display next to the property

	Filter = check,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
         self:MsgStart()
            net.WriteEntity( ent )
        self:MsgEnd()
	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()

		--if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end
        ent = RagdollOwner( ent ) or ent
        
		Fullup( ent )
		print(tostring(ply:Nick() or ply) .." reset the health of ".. tostring(ent:Nick() or ent))
	end 
} )

properties.Add( "ragdollize", {
	MenuLabel = "Stun", -- Name to display on the context menu
	Order = 8, -- The order to display this property relative to other properties
	MenuIcon = "icon16/anchor.png", -- The icon to display next to the property

	Filter = check,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()

		if not self:Filter(ent, ply) then return end
        ent = RagdollOwner(ent) or ent
			print(tostring(ply:Nick() or ply) .." has stunned ".. tostring(ent:Nick() or ent))
			Stun(ent)
	end 
} )

properties.Add("killsilent", {
	MenuLabel = "Kill (Silent)",
	Order = 11,
	MenuIcon = "icon16/cross.png",

	Filter = check,
	Action = function( self, ent )
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()

		if ( !self:Filter( ent, ply ) ) then return end
        ent = RagdollOwner( ent ) or ent
		print(tostring(ply:Nick() or ply) .." has silently killed ".. tostring(ent:Nick() or ent))
		ent:Kill()
	end 
})

properties.Add( "setplayerclass", {
	MenuLabel = "Set player class", -- Name to display on the context menu
	Order = 15, -- The order to display this property relative to other properties
	MenuIcon = "icon16/tux.png", -- The icon to display next to the property

	Filter = function (self, ent, ply)
		if not ply:HGTools_GetAccess() then return false end 
		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return true end
		local pEnt = RagdollOwner( ent )
		if ( ent:IsRagdoll() ) and pEnt and pEnt:IsPlayer() and pEnt:Alive() then return false end
	end,
	
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
	end,
	PlayerClass = function( self, ent, name )
		self:MsgStart()
			net.WriteEntity( ent )
			net.WriteString( name )
		self:MsgEnd()
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()
		if not self:Filter(ent, ply) then return end -- this line was not here before
		local class = net.ReadString( )

		ent = RagdollOwner(ent) or ent
		if IsValid(ent) and ent:IsPlayer() and player.classList[class] then
			ent:SetPlayerClass(class)
		end
	end,
	MenuOpen = function( self, option, ent, tr )
		local submenu = option:AddSubMenu()

		for name, tbl in pairs(player.classList) do
			local opt = submenu:AddOption(name)
			opt:SetRadio(true)
			opt:SetChecked(ent.PlayerClassName == name)
			opt:SetIsCheckable(true)
			opt.OnChecked = function(s, checked)
				self:PlayerClass(ent, name)
			end	
		end
	end
} )

local function doorCheck(self, ent, ply)
    if not ply:IsAdmin() then return false end
    if not IsValid(ent) then return false end
    if not ent:GetClass():lower():find("door") then return false end
    return true
end

properties.Add( "door_toggle", {
    MenuLabel = "Toggle Door",
    Order = 7,
    MenuIcon = "icon16/door.png",
    Filter = doorCheck,
    Action = function(self, ent)
        self:MsgStart()
            net.WriteEntity(ent)
        self:MsgEnd()
    end,
    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        if not self:Filter(ent, ply) then return end
        ent:Fire("toggle")
    end
})

properties.Add( "door_lock", {
    MenuLabel = "Lock Door",
    Order = 8,
    MenuIcon = "icon16/lock.png",
    Filter = doorCheck,
    Action = function(self, ent)
        self:MsgStart()
            net.WriteEntity(ent)
        self:MsgEnd()
    end,
    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        if not self:Filter(ent, ply) then return end
        ent:Fire("lock")
    end
})

properties.Add( "door_unlock", {
    MenuLabel = "Unlock Door",
    Order = 9,
    MenuIcon = "icon16/lock_open.png",
    Filter = doorCheck,
    Action = function(self, ent)
        self:MsgStart()
            net.WriteEntity(ent)
        self:MsgEnd()
    end,
    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        if not self:Filter(ent, ply) then return end
        ent:Fire("unlock")
    end
})