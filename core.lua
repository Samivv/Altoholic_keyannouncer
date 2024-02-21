-- Author discord @alieni


local frame = CreateFrame("Frame")
-- Gotta have this addon for it to work.
if not IsAddOnLoaded("DataStore") then
   print("DataStore addon is not loaded")
   return
end

local function printKeystones()
   local x = DataStore:GetCharacters()
   local keystones = {}

   for k,v in pairs(x) do
      local level = DataStore:GetKeystoneLevel(v)
      local name = DataStore:GetKeystoneName(v)
      if level == 0 then
         -- do nothing (fix so characters won't show up without a key...)
      else
         table.insert(keystones, {level = level, name = name, character = k})
      end
   end

   --if no keys in keystones table = rip
   if next(keystones) == nil then
      print("You have no keys on your characters on this realm")
      return
   end

   -- Sort the keystones from highest to lowest
   table.sort(keystones, function(a, b) return a.level > b.level end)

   -- Print the sorted keystones
   for _, keystone in ipairs(keystones) do
      local message = "["..keystone.level.."]".. " " .."["..keystone.name.."]".. " " .."["..keystone.character.."]"
      --if player is in party, send the message to party chat
      if IsInGroup() then
         SendChatMessage(message,"PARTY")
      else
      --if not in party
      print(message)
      end
   end
end

SLASH_AVAIMET1 = "/aks"
SlashCmdList["AVAIMET"] = printKeystones


local myAddonFrame = CreateFrame("Frame")
myAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
myAddonFrame:RegisterEvent("ADDON_LOADED")
myAddonFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "PLAYER_ENTERING_WORLD" then 
        print("|cFFFF0000---------------------------------------------|r")
        print("|cFFFF0000[AltKeySharing] Sharing keys enabled /aks |r")
        print("|cFFFF0000---------------------------------------------|r")
    elseif event == "ADDON_LOADED" and addonName == "Altoholic_Summary" then
        local button = CreateFrame("Button", nil, AltoholicFrame.TabSummary, "GameMenuButtonTemplate")
        button:SetPoint("BOTTOMRIGHT", AltoholicFrame.TabSummary, "BOTTOMRIGHT", GetScreenWidth()*-0.135, 0)
        button:SetSize(97, 30)
        button:SetText("Share keys")
        button:SetScript("OnClick", printKeystones)
        button:SetScript("OnEnter", function(self)
         GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
         GameTooltip:SetText("Click to share your alts' m+ keys to party. (if you are in group)", nil, nil, nil, nil, true)
         GameTooltip:Show()
     end)
     
     button:SetScript("OnLeave", function(self)
         GameTooltip:Hide()
     end)
    end
end)