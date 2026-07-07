SWEP.Base = "weapon_hg_grenade_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("'MK3A2' Fragmentation Grenade")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("Grenade used by the Combine.\nSomeone broke the indicator light...")
	SWEP.Category = language.GetPhrase("HL3")
	SWEP.IconOverride = "materials/items_icons/hl3nadeicon.png"
end

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/w_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"

SWEP.Grenade = "ent_hgjack_hl2nade"