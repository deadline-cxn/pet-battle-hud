--[[  Smashed Library by Deadline (Dalaran - Deadlidin / Jodra)  ]]--

RFCC="|cffff2020"
WFCC="|cffffffff"
DFCC="|cff888888"
NFCC="|cffffd200"
PFCC="|cffA335EE"
GFCC="|cff1EFF00"
BFCC="|cff0070ff"
LFCC="|cff9D9D9D"
YFCC="|cffffff00"
OFCC="|cffFF8000"
TFCC="|cffE6CC80"
VFCC="|cffE19a33"
JFCC="|cfff0f090"

smldb={}
smldb.rarity={}
smldb.rarity[0]={}
smldb.rarity[0].name="WTF"
smldb.rarity[0].color=RFCC
smldb.rarity[1]={}
smldb.rarity[1].name="Poor"
smldb.rarity[1].color=LFCC
smldb.rarity[2]={}
smldb.rarity[2].name="Common"
smldb.rarity[2].color=WFCC
smldb.rarity[3]={}
smldb.rarity[3].name="Uncommon"
smldb.rarity[3].color=GFCC
smldb.rarity[4]={}
smldb.rarity[4].name="Rare"
smldb.rarity[4].color=BFCC
smldb.rarity[5]={}
smldb.rarity[5].name="Epic"
smldb.rarity[5].color=PFCC
smldb.rarity[6]={}
smldb.rarity[6].name="Legendary"
smldb.rarity[6].color=OFCC
smldb.rarity[7]={}
smldb.rarity[7].name="Other"
smldb.rarity[7].color=TFCC

smldb.pet_type={}
smldb.pet_type.baseicon="INTERFACE/TARGETINGFRAME/PetBadge-"
smldb.pet_type[0]="Error"
smldb.pet_type[1]="Humanoid"
smldb.pet_type[2]="Dragon"
smldb.pet_type[3]="Flying"
smldb.pet_type[4]="Undead"
smldb.pet_type[5]="Critter"
smldb.pet_type[6]="Magical"
smldb.pet_type[7]="Elemental"
smldb.pet_type[8]="Beast"
smldb.pet_type[9]="Water"
smldb.pet_type[10]="Mechanical"

smldb.FACTION_STANDING = {}
smldb.FACTION_STANDING[0] = "|cffcc0000(can't determine)"
smldb.FACTION_STANDING[1] = "|cffcc0000Hated"
smldb.FACTION_STANDING[2] = "|cffff0000Hostile"
smldb.FACTION_STANDING[3] = "|cfff26000Unfriendly"
smldb.FACTION_STANDING[4] = "|cffe4e400Neutral"
smldb.FACTION_STANDING[5] = "|cff33ff33Friendly"
smldb.FACTION_STANDING[6] = "|cff5fe65dHonored"
smldb.FACTION_STANDING[7] = "|cff53e9bcRevered"
smldb.FACTION_STANDING[8] = "|cff2ee6e6Exalted"
smldb.FACTION_STANDING[9] = "|cffcc0000(can't determine)"

smldb.ITEM_QUALITY = {}
smldb.ITEM_QUALITY[0] = "|cff9d9d9dPoor"
smldb.ITEM_QUALITY[1] = "|cffffffffCommon"
smldb.ITEM_QUALITY[2] = "|cff1eff00Uncommon"
smldb.ITEM_QUALITY[3] = "|cff0070ffRare"
smldb.ITEM_QUALITY[4] = "|cffa335eeEpic"
smldb.ITEM_QUALITY[5] = "|cffff8000Legendary"
smldb.ITEM_QUALITY[6] = "|cffff0000Artifact"
smldb.ITEM_QUALITY[7] = "|cfe6cc80Heirloom"

--[sml_round]------------------------------------------------------------
function sml_round(what, precision)
  return math.floor((what*math.pow(10,precision)+0.5) / math.pow(10,precision))
end

--[sml_nargify]----------------------------------------------------------
function sml_nargify(text)
	if type(text) == "string" and text:len() > 0 then
		if( text ~= nil ) then
			-- print(text);
			cmd=text
			for mesg,arg2 in string.gmatch(text, "(.+) (.+)") do
				text=mesg
				arg1=arg2
			end
			narg=nil
			narg={}
			if( text ~= nil ) then
				numarg=0
				for word in string.gmatch(cmd, "%w+") do
				narg[numarg]=strlower(word)
				if(narg[numarg]=="") then
					narg[numarg]=nil
					numarg=numarg-1
				end
				numarg=numarg+1
				end
				return narg,numarg
			end
		end
	end
end

--[sml_ingroup]----------------------------------------------------------
function sml_ingroup()
  if( 	( UnitInParty("player") == 1 ) or
	( IsInRaid()==true) ) then
	return true
  end
  return false
end

--[sml_maketrue]---------------------------------------------------------
function sml_maketrue(x)
  if( ( x == "on" ) or ( x == "true" ) or ( x == "yes" ) or ( x == "1" ) or ( x == 1 ) or ( x == true )) then
	return true
  end
  return false
end

--[table.contains]-------------------------------------------------------
function table.contains( table, element )
  for _, value in pairs( table ) do if value == element then return true end end
  return false
end

--[sml_print]------------------------------------------------------------
function sml_print(addon,msg)
  msg=tostring( msg )
  if(addon~=nil) then
	DEFAULT_CHAT_FRAME:AddMessage(RFCC..tostring(addon).." >> "..YFCC..tostring(msg))
  else
	DEFAULT_CHAT_FRAME:AddMessage(YFCC..tostring(msg))
  end
end
--[sml_Dprint]-----------------------------------------------------------
function sml_dprint(debug_status,addon,msg)
  if msg == nil then msg = "nil" end
  msg=tostring(GetTime()..">"..msg)
  for i = 1,10 do
	local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i)
	if( name ~= nil ) then
	  if( name == addon ) then
		smldb.ChatFrame=getglobal( "ChatFrame"..i )
	  end
	end
  end
  if( smldb.ChatFrame == nil ) then
	smldb.ChatFrame=DEFAULT_CHAT_FRAME
  end
  if( debug_status == 1 ) then
	if( smldb.ChatFrame['AddMessage'] ~= nil ) then
	  smldb.ChatFrame:AddMessage(RFCC.."PBHUD_DEBUG>> "..YFCC..tostring(msg))
	else
	  DEFAULT_CHAT_FRAME:AddMessage(RFCC.."PBHUD_DEBUG>> "..YFCC..tostring(msg))
	end
  end
end
--[sml_tell]-------------------------------------------------------------
function sml_tell(player,msg)
  bsMsg(player,msg,"WHISPER")
end

--[sml_msg]--------------------------------------------------------------
function sml_msg(player,msg,where)
  SendChatMessage(msg, where, GetDefaultLanguage("player"), player)
end

--[eof]------------------------------------------------------------------
