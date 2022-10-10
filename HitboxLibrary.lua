--!nonstrict

--[[

__________________________________________________________________________________________________________________________________________________


	Author - rsxpct
	
	Author Contacts
	[
		Discord: rsxpct#0001
		Twitter: twitter.com/dev_rsxpct
		Gmail: rsxpct2@gmail.com
	]

__________________________________________________________________________________________________________________________________________________

	
												[ Example Code ]
												
	
		local HitboxService = require(HitboxServiceDirectory)
	
	
		local Hitbox = HitboxService.new(Type, DataTable)
		
		Hitbox.OnHit = function(HitCharacters, HitParts)
			print("Hey, We hit a part.")
		end
		
		Hitbox:Start()
	

__________________________________________________________________________________________________________________________________________________


													[ API ]
	
		
		[ Functions ]
		
			[ HitboxService.new ]
			
				Type: String
			
					Compatible Types 
				
					[
			
						Spatial Query - Aliases: 'SQ', 'SpatialQuery', 'Spatial Query'
					
						More Soon.
				
					]
				
				________________________________________________________________________________________
				
				Data: Table
				
					Compatible Types:
					
					
					
						Spatial Query Types:
						
							
						
								Size: Vector3
								Position: CFrame
								Parameters: OverlapParams
						
						
						
						More Soon.
				________________________________________________________________________________________			
						
			[ Hitbox.OnHit ]
			
				Type: function
					
					Example Code:
						
						Hitbox.OnHit = function()
							print("Hey, We hit a part.")
						end
						
						
						
						
			
	____________________________________________________________________________________________________________________	
		
		[ Variables ]
		
			Hitbox.User: Player
			
			Hitbox.HitCharacters: Table provided by the OnHit function
			Hitbox.HitParts: Table provided by the OnHit function
			
			Hitbox.FilterByCharacters: boolean
			Hitbox.HitUser: boolean
			Hitbox.DebugHitbox: boolean
			Hitbox.DebugTime: boolean
			
			
			
			
			
__________________________________________________________________________________________________________________________________________________


--]]

local Debris = game:GetService("Debris")

local HitboxService = {}
HitboxService.__index = HitboxService

function HitboxService.new(Type: string, Data)
	assert(type(Type) == "string", "[HITBOX SERVICE] | ERROR, PLEASE PROVIDE A STRING FOR THE FIRST PARAMETER | [HITBOX SERVICE]")
	assert(type(Data) == "table", "[HITBOX SERVICE] | ERROR, PLEASE PROVIDE A STRING FOR THE FIRST PARAMETER | [HITBOX SERVICE]")
	
	local self = setmetatable({}, HitboxService)
	
	self.User = nil
	
	self.HitboxType = Type
	
	self.OnHit = nil -- REPLACE WITH FUNCTION
	
	self.HitCharacters = {}
	self.HitParts = {}
	
	self.FilterByCharacters = true
	self.HitUser = false
	self.DebugHitbox = false
	self.DebugTime = 1
	
	if Type == "SpatialQuery" or Type == "SQ" or Type == "Spatial Query" then
		if Data["Size"] and Data["Position"] and Data["Parameters"] then
			self.Size = Data["Size"]
			self.Position = Data["Position"]
			self.Parameters = Data["Parameters"]
		else
			error("[HITBOX SERVICE] | YOU DID NOT PROVIDE PROPER DATA | [HITBOX SERVICE]")
		end
	end
	
	return self
end

function HitboxService:Start()
	if self.HitboxType == "SpatialQuery" or self.HitboxType == "SQ" or self.HitboxType == "Spatial Query" then
		
		local Hitbox = workspace:GetPartBoundsInBox(self.Position, self.Size, self.Parameters)
		self.Hitbox = Hitbox
		
		if self.DebugHitbox == true then
			local DebugPart = Instance.new("Part")
			DebugPart.Size = self.Size
			DebugPart.CFrame = self.Position
			DebugPart.Anchored = true
			DebugPart.CanCollide = false
			DebugPart.Color = Color3.new(255, 0, 0)
			DebugPart.Transparency = 0.5
			
			DebugPart.Parent = workspace.Debris
			
			Debris:AddItem(DebugPart, self.DebugTime)
		end
		
		local HitParts = {}
		local HitCharacters = {}
		
		for _, HitPart in ipairs(Hitbox) do
			if not table.find(HitParts, HitPart) then
				table.insert(HitParts, HitPart)
			end
			
			if self.FilterByCharacters == true then
				local Character = HitPart:FindFirstAncestorWhichIsA("Model")
				
				if Character then
					if Character:FindFirstChild("Humanoid") and not table.find(HitCharacters, Character) then
						if self.HitUser == false then
							assert(typeof(self.User) == "Player", "[HITBOX SERVICE] | ERROR, 'self.User' MUST BE A PLAYER OBJECT | [HITBOX SERVICE]")
							
							if self.User.Character ~= Character then
								table.insert(HitCharacters, Character)
								self:OnHit(self.OnHit)
							end
						else
							table.insert(HitCharacters, Character)
							self:OnHit(self.OnHit)
						end
					end
				end
			end
		end
		
		if self.FilterByCharacters == true then
			self.HitCharacters = HitCharacters
		else
			self.HitParts = HitParts
		end
	end
end

function HitboxService:OnHit(Callback)
	assert(type(Callback) == "function", "[HITBOX SERVICE] | ERROR, 'self.OnHit' MUST BE A FUNCTION | [HITBOX SERVICE]")
	
	Callback(self.HitCharacters, self.HitParts)
end

return HitboxService
