-- Filename: petbattlehud.lua Author  : Smashed - Bladefist
------------------------------------------------------------------------
function PBHUD_ResetLog()
  PBHUD_db.LOG=nil
  PBHUD_db.LOGLINE=1
end
------------------------------------------------------------------------
function PBHUD_OnUpdate(self)
  if( PBHUD_db~=nil ) then
	if( PBHUD_db.b_party_hide ) then
	  local ingroup=sml_ingroup()
	  if( ingroup ) then
		PBHUD:Hide()
	  else
		PBHUD:Show()
	  end
	end
	if( PBHUD_db.FlashTimer==nil ) then
	  PBHUD_db.FlashTimer=GetTime()
	end
	if( PBHUD_db.Initiate_PetsMissing~=nil ) then
	  if( (GetTime()-PBHUD_db.Initiate_PetsMissing)>5 ) then
		PBHUD_db.Initiate_PetsMissing=nil
		PBHUD_PetsMissing()
	  end
	end
	if( (GetTime() - PBHUD_db.FlashTimer)>1 ) then
	  PBHUD_UpdatePetHUD()
	  PBHUD_db.FlashTimer=GetTime()
	  if( PBHUD_db.DColor==nil ) then
		PBHUD_db.DColor=1
	  end
	  if( PBHUD_db.DColor==1 ) then
		PBHUD_db.DColor=0
		PBHUDPet1DeadIcon:SetVertexColor(1,0,0)
		PBHUDPet2DeadIcon:SetVertexColor(1,0,0)
		PBHUDPet3DeadIcon:SetVertexColor(1,0,0)
	  else
		PBHUD_db.DColor=1
		PBHUDPet1DeadIcon:SetVertexColor(1,1,0)
		PBHUDPet2DeadIcon:SetVertexColor(1,1,0)
		PBHUDPet3DeadIcon:SetVertexColor(1,1,0)
	  end
	end
  end
end
------------------------------------------------------------------------
function PBHUD_SaveTable(table)
  PBHUD_db.tables[tostring(table)]={}
  for k,v in pairs(table) do
	PBHUD_db.tables[tostring(table)][k]={}
	if( string.find(tostring(v),"table:") ) then
	  PBHUD_db.tables[tostring(table)][k]=PBHUD_SaveTable(v)
	else
	  PBHUD_db.tables[tostring(table)][k]=v
	end
  end
  return PBHUD_db.tables[tostring(table)]
end
------------------------------------------------------------------------
function PBHUD_SaveStuff()
  PBHUD_db.FlashTimer=nil
  PBHUD_db.PBHUD_ChatFrame=nil
  PBHUD_db.DColor=nil
end
------------------------------------------------------------------------
function PBHUD_OnLoad(self)
  PBHUD_Version 	= "Pet Battle HUD v"..GetAddOnMetadata("petbattlehud", "Version")
  PBHUD_Author	= GetAddOnMetadata("petbattlehud", "Author")
  SLASH_PBHUD1 = "/petbattlehud"
  SLASH_PBHUD2 = "/pbh"
  SlashCmdList["PBHUD"] = function(msg) PBHUD_CommandHandler(msg) end
  self:RegisterEvent("VARIABLES_LOADED")
  self:RegisterEvent("PLAYER_LOGOUT")
  self:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
  self:RegisterEvent("PET_BATTLE_OPENING_START")
  self:RegisterEvent("PET_BATTLE_CLOSE")
  self:RegisterEvent("PET_BATTLE_OVER")
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  self:RegisterEvent("GROUP_JOINED")
  self:RegisterEvent("PARTY_CONVERTED_TO_RAID")
  self:RegisterEvent("PARTY_INVITE_CANCEL")
  self:RegisterEvent("PARTY_INVITE_REQUEST")
  self:RegisterEvent("PARTY_LEADER_CHANGED")
  self:RegisterEvent("PARTY_LFG_RESTRICTED")
  self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
  self:RegisterEvent("PARTY_MEMBERS_CHANGED")
  self:RegisterEvent("PARTY_MEMBER_DISABLE")
  self:RegisterEvent("PARTY_MEMBER_ENABLE")
end
------------------------------------------------------------------------
function PBHUD_OnEvent(self, event, ...)
  local argz = {}
  argz[0], argz[1], argz[2], argz[3], argz[4], argz[5], argz[6], argz[7], argz[8], argz[9], argz[10], argz[11], argz[12], argz[13], argz[14], argz[15], argz[16], argz[17], argz[18], argz[19],argz[20], argz[21], argz[22], argz[23], argz[24], argz[25], argz[26], argz[27], argz[28], argz[29] = ...
  local argztxt=""
  for ari=0,29 do
	if(argz[ari]~=nil) then
	  argztxt=argztxt.." argz["..ari.."]=["..tostring(argz[ari]).."]"
	end
	if(argz[ari]==nil) then
	  argz[ari]="(nil)"
	end
  end
  local narg=nil
  narg={}
  local numarg=0
  if(argz[0]~=nil) then
	for word in string.gmatch(argz[0], "%w+") do
	  narg[numarg]=string.lower(word)
	  if(narg[numarg]=="") then
		narg[numarg]=nil
		numarg=numarg-1
	  end
	  numarg=numarg+1
	end
  end
  local otxt=" "
  local oti=0
  for oti = 0,numarg do
	if(narg[oti]~=nil) then
	  otxt=otxt.." ("..oti..":"..narg[oti]..")"
	end
  end
  if (event == "VARIABLES_LOADED") then
	if( not PBHUD_Profile ) then
	  PBHUD_Profile={}
	end
	if( not PBHUD_Profile[GetRealmName()] ) then
	  PBHUD_Profile[GetRealmName()]={}
	end
	if( not PBHUD_Profile[GetRealmName()][UnitName("player")] ) then
	  PBHUD_Profile[GetRealmName()][UnitName("player")]={}
	end
	if( not PBHUD_db ) then
	  PBHUD_db = PBHUD_Profile[GetRealmName()][UnitName("player")]
	end
	if( PBHUD_db) then
	  if( PBHUD_db.Debug==nil ) then
		PBHUD_db.Debug = false
	  end
	  if( PBHUD_db.tables==nil ) then
		PBHUD_db.tables={}
	  end
	  if(PBHUD_db.b_show_missing==nil) then
		PBHUD_db.b_show_missing=true
	  end
	  if(PBHUD_db.b_show_only_missing==nil) then
		PBHUD_db.b_show_only_missing=false
	  end
	  if(PBHUD_db.b_party_hide==nil) then
		PBHUD_db.b_party_hide=true
	  end
	  PBHUD_db["Version"]	= PBHUD_Version
	  PBHUD_db["Name"]	  	= UnitName("player")
	  PBHUD_db["Server"]	= GetRealmName()
	  PBHUD_db["Locale"]	= GetLocale()
	  PBHUD_db["Race"],
	  PBHUD_db["RaceEn"]  	= UnitRace("player")
	  PBHUD_db["Class"],
	  PBHUD_db["ClassEn"] 	= UnitClass("player")
	  PBHUD_db["FactionEn"],
	  PBHUD_db["Faction"] 	= UnitFactionGroup("player")
	  PBHUD_db.Enabled    	= true
	  if(PBHUD_db.PetTeam == nil) then
		PBHUD_db.PetTeam = {}
	  end
	  sml_print("Pet Battle HUD",PBHUD_db.Version.." by Smashed (Bladefist - Alliance) loaded. For help type /pbh help")
	  PBHUDOptionsFramePanel1MissingPets:SetChecked(PBHUD_db.b_show_missing)
	  PBHUDOptionsFramePanel1MissingPets:SetChecked(PBHUD_db.b_show_only_missing)
	  PBHUDOptionsFramePanel1PartyHide:SetChecked(PBHUD_db.b_party_hide)
	end
  end
  ------------------------------------------------------------------------
  if (event == "PLAYER_LOGOUT") then
	PBHUD_SaveStuff()
  end
  ------------------------------------------------------------------------
  if (event == "CHAT_MSG_PET_BATTLE_COMBAT_LOG") then
	for _, dmg, _, petname in string.gmatch(argz[0], "(.+)dealt (%d+) damage to your (.+)|t(.+) (%(+)(.+).") do
	  sml_dprint(PBHUD_db.Debug,"PBHUD","SPECIAL ATTACK")
	  PBHUD_PetDamage(petname,dmg)
	  return
	end
	for _, dmg, _, petname in string.gmatch(argz[0], "(.+)dealt (%d+) damage to your (.+)|t(.+).") do
	  PBHUD_PetDamage(petname,dmg)
	end
	for _, heal, _, petname in string.gmatch(argz[0], "(.+)healed (%d+) damage from your (.+)|t(.+).") do
	  PBHUD_PetHeal(petname,heal)
	end
  end
  ------------------------------------------------------------------------
  if (event == "PET_BATTLE_OPENING_START") then
	PBHUD_db.InCombat=true
	PBHUD_ResetLog()
  end
  ------------------------------------------------------------------------
  if (event == "PET_BATTLE_OVER") then
	PBHUD_db.InCombat=false
  end
  ------------------------------------------------------------------------
  if (event == "PET_BATTLE_CLOSE") then
	PBHUD_db.Initiate_PetsMissing=GetTime()
	PBHUD_db.InCombat=false
  end
  ------------------------------------------------------------------------
  if (event == "COMPANION_LEARNED") then
  end
  ------------------------------------------------------------------------
  if (event == "ZONE_CHANGED_NEW_AREA") then
	PBHUD_PetsMissing()
  end
end
------------------------------------------------------------------------
function PBHUD_PetHeal(petname,heal)
  if(petname==nil) then
	return
  end
  if(heal==nil) then
	return
  end
  local petslot=PBHUD_GetPetSlotByName(petname)
  if(petslot==nil) then
	return
  end
  PBHUD_db.PetTeam[petslot].hp=PBHUD_db.PetTeam[petslot].hp+heal
  if(PBHUD_db.PetTeam[petslot].hp>PBHUD_db.PetTeam[petslot].maxhp) then
	PBHUD_db.PetTeam[petslot].hp=PBHUD_db.PetTeam[petslot].maxhp
  end
  PBHUD_UpdatePetHUD()
end
------------------------------------------------------------------------
function PBHUD_PetDamage(petname,dmg)
  local gspid=C_PetJournal.GetSummonedPetGUID()
  if( gspid==nil ) then
	gspid="0"
  end
  sml_dprint(PBHUD_db.Debug,"PBHUD",	"PBHUD_PetDamage() ->".." petname: "..petname.." Summoned pet ID: "..tostring(gspid))
  if( petname==nil ) then
	return
  end
  if( dmg==nil ) then
	return
  end
  local petslot=PBHUD_GetPetSlotByName(petname)
  if( petslot==nil ) then
	return
  end
  PBHUD_db.PetTeam[petslot].hp=PBHUD_db.PetTeam[petslot].hp-dmg
  if( PBHUD_db.PetTeam[petslot].hp<0 ) then
	PBHUD_db.PetTeam[petslot].hp=0
  end
  PBHUD_UpdatePetHUD()
end
------------------------------------------------------------------------
function PBHUD_GetPetSlotByName(petname)
  for i=1,3 do
	if(petname==PBHUD_db.PetTeam[i].name) then
	  return i
	end
  end
  return 0
end
------------------------------------------------------------------------
function PBHUD_PetsMissing()
  C_PetJournal.ClearSearchFilter()
  local zone=GetZoneText()
  local nopets=""
  for i=1,C_PetJournal.GetNumPets(false) do
	local petID,speciesID,owned,customName,level,favorite,isRevoked,speciesName,icon,petType,companionID,tooltip,description,isWild,canBattle,isTradeable,isUnique=C_PetJournal.GetPetInfoByIndex(i)
	if string.find( tooltip, zone ) then
	  if( string.find( tooltip, "Pet Battle:" ) ) then
		if( owned==false ) then
		  sml_dprint(PBHUD_db.Debug,"PBHUD","petID["..tostring(petID).."]".." tooltip["..tostring(tooltip).."] description["..description.."]")
		  if( nopets~="" ) then
			nopets=nopets..WFCC..","..OFCC..speciesName
		  else
			nopets=OFCC..speciesName
		  end
		  for _,season in string.gmatch(tooltip,"(.+)Season: |r(.+)") do
			if( season~=nil ) then
			  nopets=nopets..WFCC.."("..RFCC.."SEASON: "..season..WFCC..")"..YFCC
			end
		  end
		  for _,weather in string.gmatch(tooltip,"(.+)Weather: |r(.+)") do
			if ( weather~=nil ) then
			  nopets=nopets..WFCC.."("..RFCC.."WEATHER: "..weather..WFCC..")"..YFCC
			end
		  end
		end
	  end
	end
  end
  if(PBHUD_db.b_show_missing==true) then
	if(nopets=="") then
	  if(PBHUD_db.b_show_only_missing==false) then
		sml_print("Pet Battle HUD","You have all the capturable pets from "..zone.."!")
	  end
	else
	  sml_print("Pet Battle HUD","Capturable pets from "..zone.." you don't have: "..nopets)
	end
  end
end
------------------------------------------------------------------------
function PBHUD_UpdatePetHUD()
  for slot = 1,3 do
	local pet = {}
	if(pet~=nil) then
	  pet.abilities = {}
	  pet.petID, pet.abilities[1], pet.abilities[2], pet.abilities[3] = C_PetJournal.GetPetLoadOutInfo(slot)
	  if(pet.petID~=nil) then
		local speciesID,
		customName,
		level,
		xp,
		maxxp,
		displayID,
		favorite,
		name,
		icon,
		petType,
		creatureID
		= C_PetJournal.GetPetInfoByPetID(pet.petID)
		local hp,
		maxhp,
		power,
		speed,
		rarity
		= C_PetJournal.GetPetStats(pet.petID)
		if( PBHUD_db.PetTeam[slot]==nil ) then
		  PBHUD_db.PetTeam[slot]={}
		end
		PBHUD_db.PetTeam[slot].petID=pet.petID
		----------------------------------------[If in combat use stored stats, else update pet stats]
		if(PBHUD_db.InCombat~=true) then
		  PBHUD_db.PetTeam[slot].petType=petType
		  PBHUD_db.PetTeam[slot].displayID=displayID
		  PBHUD_db.PetTeam[slot].speciesID=speciesID
		  PBHUD_db.PetTeam[slot].icon=icon
		  PBHUD_db.PetTeam[slot].power=power
		  PBHUD_db.PetTeam[slot].speed=speed
		  PBHUD_db.PetTeam[slot].rarity=rarity
		  PBHUD_db.PetTeam[slot].name=name
		  if(customName~=nil) then
			PBHUD_db.PetTeam[slot].name=customName
			if(PBHUD_db.PetAlias==nil) then
			  PBHUD_db.PetAlias={}
			end
			PBHUD_db.PetAlias[customName]=PBHUD_db.PetTeam[slot].name
		  end
		  PBHUD_db.PetTeam[slot].hp=hp
		  PBHUD_db.PetTeam[slot].maxhp=maxhp
		  PBHUD_db.PetTeam[slot].level=level
		  PBHUD_db.PetTeam[slot].xp=xp
		  PBHUD_db.PetTeam[slot].maxxp=maxxp
		end
		if( speciesID==nil ) then speciesID="(nil)" end
		if( creatureID==nil ) then creatureID="(nil)" end
		if( PBHUD_db.PetTeam[slot].petType==nil ) then PBHUD_db.PetTeam[slot].petType=0 end
		if( PBHUD_db.PetTeam[slot].displayID==nil ) then PBHUD_db.PetTeam[slot].displayID=0 end
		if( PBHUD_db.PetTeam[slot].speciesID==nil ) then PBHUD_db.PetTeam[slot].speciesID=0 end
		if( PBHUD_db.PetTeam[slot].name==nil ) then PBHUD_db.PetTeam[slot].name="unknown" end
		if( PBHUD_db.PetTeam[slot].icon==nil ) then PBHUD_db.PetTeam[slot].icon="(nil)" end
		if( PBHUD_db.PetTeam[slot].power==nil ) then PBHUD_db.PetTeam[slot].power="(nil)" end
		if( PBHUD_db.PetTeam[slot].speed==nil ) then PBHUD_db.PetTeam[slot].speed="(nil)" end
		if( PBHUD_db.PetTeam[slot].rarity==nil ) then PBHUD_db.PetTeam[slot].rarity=1 end
		if( PBHUD_db.PetTeam[slot].hp==nil ) then PBHUD_db.PetTeam[slot].hp=1 end
		if( PBHUD_db.PetTeam[slot].maxhp==nil ) then PBHUD_db.PetTeam[slot].maxhp=100 end
		if( PBHUD_db.PetTeam[slot].level==nil ) then PBHUD_db.PetTeam[slot].level=1 end
		if( PBHUD_db.PetTeam[slot].xp==nil ) then PBHUD_db.PetTeam[slot].xp=1 end
		if( PBHUD_db.PetTeam[slot].maxxp==nil ) then PBHUD_db.PetTeam[slot].maxxp=100 end
		if( PBHUD_db.PetTeam[slot].level==nil ) then PBHUD_db.PetTeam[slot].level=0 end
		if( PBHUD_db.PetTeam[slot].xp==nil ) then PBHUD_db.PetTeam[slot].xp=0 end
		if( PBHUD_db.PetTeam[slot].maxxp==nil ) then PBHUD_db.PetTeam[slot].maxxp=100 end
		PBHUD_db.PetTeam[slot].xp_prct = (PBHUD_db.PetTeam[slot].xp/PBHUD_db.PetTeam[slot].maxxp)*100
		if( PBHUD_db.PetTeam[slot].xp_prct>100 ) then PBHUD_db.PetTeam[slot].xp_prct=100 end
		if( PBHUD_db.PetTeam[slot].xp==0 ) then PBHUD_db.PetTeam[slot].xp_prct=1 end
		if( PBHUD_db.PetTeam[slot].hp==nil ) then PBHUD_db.PetTeam[slot].hp=0 end
		if( PBHUD_db.PetTeam[slot].maxhp==nil ) then PBHUD_db.PetTeam[slot].maxhp=100 end
		PBHUD_db.PetTeam[slot].hp_prct = (PBHUD_db.PetTeam[slot].hp/PBHUD_db.PetTeam[slot].maxhp)*100
		if( PBHUD_db.PetTeam[slot].hp_prct>100 ) then PBHUD_db.PetTeam[slot].hp_prct=100 end
		if( PBHUD_db.PetTeam[slot].hp==0 ) then
		  if(_G["PBHUDPet"..slot.."DeadIcon"]~=nil) then _G["PBHUDPet"..slot.."DeadIcon"]:Show() end
		  PBHUD_db.PetTeam[slot].hp_prct=1
		else
		  if( _G["PBHUDPet"..slot.."DeadIcon"]~=nil ) then _G["PBHUDPet"..slot.."DeadIcon"]:Hide() end
		end
		if( tonumber(PBHUD_db.PetTeam[slot].level)<10) then
		  if( string.find(PBHUD_db.PetTeam[slot].level," ")) then
		  else
			PBHUD_db.PetTeam[slot].level=" "..PBHUD_db.PetTeam[slot].level
		  end
		end
		if( smldb~=nil ) then
		  _G["PBHUDPet"..slot.."TypeBubble"]:SetTexture(smldb.pet_type.baseicon..smldb.pet_type[PBHUD_db.PetTeam[slot].petType])
		  _G["PBHUDPet"..slot.."NameText"]:SetText(smldb.rarity[PBHUD_db.PetTeam[slot].rarity].color..PBHUD_db.PetTeam[slot].name)
		end
		_G["PBHUDPet"..slot.."Texture"]:SetTexture(PBHUD_db.PetTeam[slot].icon)
		_G["PBHUDPet"..slot.."LevelText"]:SetText(WFCC..PBHUD_db.PetTeam[slot].level)
		_G["PBHUDPet"..slot.."HPText"]:SetText(tostring(PBHUD_db.PetTeam[slot].hp).."/"..tostring(PBHUD_db.PetTeam[slot].maxhp))
		_G["PBHUDPet"..slot.."XPText"]:SetText(tostring(PBHUD_db.PetTeam[slot].xp).."/"..tostring(PBHUD_db.PetTeam[slot].maxxp))
		_G["PBHUDPet"..slot.."XPTexture"]:SetWidth(PBHUD_db.PetTeam[slot].xp_prct)
		_G["PBHUDPet"..slot.."HPTexture"]:SetWidth(PBHUD_db.PetTeam[slot].hp_prct)
		_G["PBHUDPet"..slot.."SpeedText"]:SetText(PBHUD_db.PetTeam[slot].speed)
		_G["PBHUDPet"..slot.."PowerText"]:SetText(PBHUD_db.PetTeam[slot].power)
	  end
	end
  end
end
------------------------------------------------------------------------
function PBHUD_ShowHelp(msg)
  sml_print("Pet Battle HUD","------------------------------------------------------------------------")
  sml_print(nil,"Pet Battle HUD by Smashed @ Bladefist / US --- Help:")
  sml_print(nil,"------------------------------------------------------------------------")
  sml_print(nil,"/pbh show.............displays interface")
  sml_print(nil,"/pbh hide.............hides interface")
  sml_print(nil,"/pbh debug............toggle debugging information")
  sml_print(nil,"/pbh missing on/off...toggle missing pet messages")
end
------------------------------------------------------------------------
function PBHUD_CommandHandler(msg)
  local cmd=msg
  for mesg,arg2 in string.gmatch(msg, "(.+) (.+)") do
	msg=mesg
	arg1=arg2
  end
  narg=nil
  narg={}
  if(msg~=nil) then
	numarg=0
	for word in string.gmatch(cmd, "%w+") do
	  narg[numarg]=word
	  if(narg[numarg]=="") then
		narg[numarg]=nil
		numarg=numarg-1
	  end
	  if(PBHUD_db.Debug==true) then
		sml_print(nil,numarg.." ["..narg[numarg].."]")
	  end
	  numarg=numarg+1
	end
  end
  if(msg=="help") or ( msg == "" ) or ( msg == "?" ) then PBHUD_ShowHelp() end
  if(msg=="show") then PBHUD:Show() end
  if(msg=="hide") then PBHUD:Hide() end
  if(msg=="debug") then
	if( PBHUD_db.Debug==true ) then
	  PBHUD_db.Debug=false sml_print("PBHUD","Debugging off")
	else
	  PBHUD_db.Debug=true sml_print("PBHUD","Debugging on")
	end
  end
  if(narg[0]=="missing") then PBHUD_SetShowMissing(narg[1]) end
end
------------------------------------------------------------------------
function PBHUD_SetShowMissing(x)
  x=sml_maketrue(x)
  PBHUD_db.b_show_missing=x
  sml_print("PBHUD","Show Missing Pets: "..tostring(PBHUD_db.b_show_missing))
end
------------------------------------------------------------------------
function PBHUD_SetShowOnlyMissing(x)
  x=sml_maketrue(x)
  PBHUD_db.b_show_only_missing=x
  sml_print("PBHUD","Show Only Missing Pets: "..tostring(PBHUD_db.b_show_only_missing))
end
------------------------------------------------------------------------
function PBHUD_SetPartyHide(x)
  x=sml_maketrue(x)
  PBHUD_db.b_party_hide=x
  sml_print("PBHUD","Party Hide "..tostring(PBHUD_db.b_party_hide))
end
------------------------------------------------------------------------
function PBHUDOptions_Toggle()
  PBHUDOptionsFrame:Show()
end
------------------------------------------------------------------------
