gMiss = LibStub("AceAddon-3.0"):NewAddon("gMiss" , "AceConsole-3.0")

local AceGUI = LibStub("AceGUI-3.0")
local libS = LibStub("AceSerializer-3.0")

local mIPTBL = {}

--[[FUNCTIONS]]--
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end


--[[Custom]]--
function gMiss:loadFrame(input)
	-- REMOVE UNDER
	mIPTBL = {}
	mIP = ''
	GarrisonLandingPage_Toggle()
		if (not GarrisonMissionFrame) then
			gMiss:Print("Must be viewing Command Table.")
		return
	end
	
	GarrisonMissionList_UpdateMissions()
	
	local Missions = GarrisonMissionFrame.MissionTab.MissionList.inProgressMissions
	local NumMissions = #Missions
	
	C_Garrison.GetInProgressMissions(Missions)
	
	if (NumMissions == 0) then
		return
	end
	
	for i = 1, NumMissions do
		local Mission = Missions[i]
		local TimeLeft = Mission.timeLeft:match("%d")
		
		if (Mission.inProgress and (TimeLeft ~= "0")) then
			table.insert(mIPTBL, "["..Mission.name.."|"..Mission.timeLeft.."]")
		end
	end
	
	local Available = GarrisonMissionFrame.MissionTab.MissionList.availableMissions
	local NumAvailable = #Available
	mIP = table.tostring(mIPTBL)
	
	
  -- Process the slash command ('input' contains whatever follows the slash command)
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("Garrison Mission Parser")
	frame:SetStatusText("Paste this on the gMission Page.")
	frame:SetLayout("Fill")
	_G["gMissFrame"] = frame
	tinsert(UISpecialFrames, "gMissFrame")
	
	local editbox = AceGUI:Create("MultiLineEditBox")
	editbox:SetLabel("Missions:")
	editbox:SetText(mIP)
	editbox:SetMaxLetters(0)
	editbox:SetFocus()
	editbox:DisableButton(true)
	editbox:SetFullWidth(isFull)
	editbox:SetFullHeight(isFull)
	
	frame:AddChild(editbox)
	GarrisonLandingPage_Toggle()
end
--[[Chat Commands]]--
gMiss:RegisterChatCommand("gmiss", "loadFrame")