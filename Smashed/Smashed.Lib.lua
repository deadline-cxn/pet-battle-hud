--[[ 
Smashed Library 
by Smashed (Bladefist Alliance)
v 5.0.1.0
]]--


RFCC="|cffff2020"; WFCC="|cffffffff"; DFCC="|cff888888";
NFCC="|cffffd200"; PFCC="|cffA335EE"; GFCC="|cff1EFF00";
BFCC="|cff0070ff"; LFCC="|cff9D9D9D"; YFCC="|cffffff00";
OFCC="|cffFF8000"; TFCC="|cffE6CC80"; VFCC="|cffE19a33";


smldb={};
smldb.rarity={};
smldb.rarity[0]={};	
smldb.rarity[0].name="WTF";
smldb.rarity[0].color=RFCC;
smldb.rarity[1]={};
smldb.rarity[1].name="Poor";
smldb.rarity[1].color=LFCC;
smldb.rarity[2]={};
smldb.rarity[2].name="Common";
smldb.rarity[2].color=WFCC;
smldb.rarity[3]={};
smldb.rarity[3].name="Uncommon";
smldb.rarity[3].color=GFCC;
smldb.rarity[4]={};
smldb.rarity[4].name="Rare";
smldb.rarity[4].color=BFCC;
smldb.rarity[5]={};
smldb.rarity[5].name="Epic";
smldb.rarity[5].color=PFCC;
smldb.rarity[6]={};
smldb.rarity[6].name="Legendary";
smldb.rarity[6].color=OFCC;
smldb.rarity[7]={};
smldb.rarity[7].name="Other";
smldb.rarity[7].color=TFCC;

smldb.pet_type={};
smldb.pet_type.baseicon="INTERFACE/TARGETINGFRAME/PetBadge-";
smldb.pet_type[0]="Error";
smldb.pet_type[1]="Humanoid";
smldb.pet_type[2]="Dragon";
smldb.pet_type[3]="Flying";
smldb.pet_type[4]="Undead";
smldb.pet_type[5]="Critter";
smldb.pet_type[6]="Magical";
smldb.pet_type[7]="Elemental";
smldb.pet_type[8]="Beast";
smldb.pet_type[9]="Water";
smldb.pet_type[10]="Mechanical";



function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

--[sml_print]------------------------------------------------------------
function sml_print(addon,msg)
	msg=tostring(msg);
	if(addon~=nil) then
		DEFAULT_CHAT_FRAME:AddMessage(RFCC..tostring(addon).." >> "..YFCC..tostring(msg));
	else 
		DEFAULT_CHAT_FRAME:AddMessage(YFCC..tostring(msg));
	end
end

--[sml_Dprint]----------------------------------------------------------------------
function sml_Dprint(debug_status,addon,msg)
	msg=tostring(GetTime()..">"..msg);
	for i = 1,10 do local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);
		if(name~=nil) then
			if(name==addon) then
				smldb.ChatFrame=getglobal("ChatFrame"..i);
			end
		end
	end
	
	if(smldb.ChatFrame==nil) then
		smldb.ChatFrame=DEFAULT_CHAT_FRAME;
	end
	
	if(debug_status==1) then
		if(smldb.ChatFrame['AddMessage']~=nil) then
			smldb.ChatFrame:AddMessage(RFCC.."PBHUD_DEBUG>> "..YFCC..tostring(msg));
		else
			DEFAULT_CHAT_FRAME:AddMessage(RFCC.."PBHUD_DEBUG>> "..YFCC..tostring(msg));
		end
	end
end
