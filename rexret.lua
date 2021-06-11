local Tinkr, wowex = ...
local Routine = Tinkr.Routine
local ooo = {}

--A simple solo/farming TBC Retribution Paladin routine
--Once in-game use /routine load rexret

Routine:RegisterSpellbook({
    JudgementOfWisdom = 20355,

}, Routine.Classes.Paladin)

Routine:RegisterRoutine(function()

    --Define resource types if needed
    --local hp = power(PowerType.HolyPower)

    --Don't spam in the GCD
    if gcd() > latency() then 
        return 
    end

    local function in_combat_function()

        --Mounted Check
        if mounted() then
            return
        end
        
        --Target Alive, Target Enemy, Player Alive, Player Not Channeling
        if alive('target') and enemy('target') and alive('player') and not channeling('player') then

            --print (enemiesAround('player'), 8)
            --Auto Attack
            --if not IsCurrentSpell(6603) then
            --    return cast(6603, 'target')
            --end

            --Seal of Wisdom
            if castable(SealOfWisdom) and not buff(SealOfWisdom, 'player') and not debuff(20355, 'target') then
                return cast(SealOfWisdom, 'player')
            end
            
            --Judgement
            if castable(Judgement) and buff(SealOfWisdom, 'player') and not debuff(20355, 'target') then
                return cast(Judgement, 'target')
            end

            --Seal of Command
            if castable(SealOfCommand) and not buff(SealOfCommand, 'player') and debuff(20355, 'target') then
                return cast(SealOfCommand, 'player')
            end

            --Judgement
            if castable(Judgement) and buff(SealOfCommand, 'player') and debuff(HammerOfJustice, 'target') then
                return cast(Judgement, 'target')
            end

            --Crusader Strike
            if castable(CrusaderStrike) then
                return cast(CrusaderStrike, 'target')
            end

            --Consecration for AOE
            if castable(Consecration) and enemiesAround('player', 8) >= 2 then
                return cast(Consecration)
            end

        end    

    end

    local function out_of_combat_function()

        --Mounted Check
        if mounted() then
            return
        end

        --Target Alive, Target Enemy, Player Alive, Player Not Channeling
        if alive('target') and enemy('target') and alive('player') and not channeling('player') then

            --Seal of Wisdom
            if castable(SealOfWisdom) and not buff(SealOfWisdom, 'player') and not debuff(20355, 'target') then
                return cast(SealOfWisdom, 'player')
            end

        end    
        
        if alive('player') and not channeling('player') then

            --Sanctity Aura
            if castable(SanctityAura) and not buff(SanctityAura, 'player') then
                return cast(SanctityAura, 'player')
            end

            --Blessing of Wisdom
            if castable(BlessingOfWisdom) and not buff(BlessingOfWisdom, 'player') then
                return cast(BlessingOfWisdom, 'player')
            end    

        end

    end

    if combat('player') then 
        in_combat_function() 
        return 
    else 
        out_of_combat_function()
        return 
    end 

end, Routine.Classes.Paladin, 'rexret')

--Buttons
--local myButton = CreateFrame("Button", "myFirstButton", UIParent, 'UIPanelButtonTemplate')
--    myButton:SetSize(50,50)
--    myButton:SetPoint("CENTER",200,0)
--    myButton:SetText('ON')
--    myButton:RegisterForClicks("LeftButtonUp")
--    myButton:SetScript("OnClick", function() Tinkr.Routine:Toggle() end)
--    myButton:SetAlpha(1)
--    myButton:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
--    myButton:SetScript("OnLeave", function(self) self:SetAlpha(0.2) end)

--Buttons Loading
local mybuttons = {}
mybuttons = {}
mybuttons.On = false
mybuttons.Cooldowns = false
mybuttons.MultiTarget = false
mybuttons.Settings = false
local CreateButton
do
  --  Drag Handlers
  local function OnDragStart(self)
    self:GetParent():StartMoving()
  end
  local function OnDragStop(self)
    self:GetParent():StopMovingOrSizing()
  end

  --  Tooltip Handlers
  local function OnEnter(self)
    if self.Tooltip then
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(self.Tooltip, 0, 1, 0.5, 1, 1, 1)
      GameTooltip:SetWidth(350)
      GameTooltip:Show()
    end
  end
  local function OnLeave(self)
    if GameTooltip:IsOwned(self) then
      GameTooltip:Hide()
    end
  end

  --  Button Generator (this will be assigned to the upvalue noted as a function prototype)
  local function CreateButton(parent, name, texture, text, tooltip)
    tooltip = tooltip or text --  If no tooltip, use button text
    local btn = CreateFrame("Button", name, parent, "SecureActionButtonTemplate")    --      Create our button
    btn:SetSize(40, 40)
    --Setup button text
    btn:SetNormalFontObject("GameFontNormalSmall") 
    btn:SetHighlightFontObject("GameFontHighlightSmall")
    btn:SetDisabledFontObject("GameFontDisableSmall")
    btn:SetText(text)
    --Setup button's backgorund, you can use :SetNormalTexture() and other functions to set state-based textures
    local tex = btn:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints(btn)
    tex:SetTexture(texture)
    btn.Texture = tex
    --Register handlers
    btn:RegisterForClicks("AnyUp") --   Register all buttons  
    btn:RegisterForDrag("LeftButton") --    Register for left drag
    btn:SetScript("OnDragStart", function(self)
        local f = frame:GetScript("OnDragStart") -- get the frame OnDragStart script
        f(frame) -- run it
      end)
    btn:SetScript("OnDragStop", function(self)
        local f = frame:GetScript("OnDragStop") -- get the frame OnDragStop script
        f(frame) -- run it
      end)
    btn:SetScript("OnDragStop", OnDragStop)
    btn:SetScript("OnEnter", OnEnter)
    btn:SetScript("OnLeave", OnLeave)
    btn.Tooltip = tooltip
    --Return our button
    return btn 
  end
end

local frame = CreateFrame("Frame", "wowex_buttons", UIParent, BackdropTemplateMixin and "BackdropTemplate")
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetSize(180, 50)
frame:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 2, right = 2, top = 2, bottom = 2},
})
frame:SetBackdropColor(0, 0, 0, 1)
frame:EnableMouse(true)
frame:SetScale(0.8)
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag("LeftButton") --   Register left button for dragging
frame:SetScript("OnDragStart", frame.StartMoving) --  Set script for drag start
frame:SetScript("OnDragStop", frame.StopMovingOrSizing) --    Set script for drag stop
frame:SetUserPlaced(true)

local CreateButton
do -- Prototype for function
  local function OnDragStart(self)   --  Drag Handlers
    self:GetParent():StartMoving()
  end
  local function OnDragStop(self)
    self:GetParent():StopMovingOrSizing()
  end
  local function OnEnter(self) --  Tooltip Handlers
    if self.Tooltip then
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(self.Tooltip, 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end
  end
  local function OnLeave(self)
    if GameTooltip:IsOwned(self) then
      GameTooltip:Hide()
    end
  end

  --Button Generator (this will be assigned to the upvalue noted as a function prototype)
  function CreateButton(parent, name, texture, text, tooltip) 
    tooltip = tooltip or text --  If no tooltip, use button text
    local btn = CreateFrame("Button", name, parent, "SecureActionButtonTemplate") --  Button Generator (this will be assigned to the upvalue noted as a function prototype)
    btn:SetSize(40, 40)

    btn:SetNormalFontObject("GameFontNormalSmall") --      Setup button text
    btn:SetHighlightFontObject("GameFontHighlightSmall")
    btn:SetDisabledFontObject("GameFontDisableSmall")
    btn:SetText(text)

    local tex = btn:CreateTexture(nil, "BACKGROUND") --      Setup button's backgorund, you can use :SetNormalTexture() and other functions to set state-based textures
    tex:SetAllPoints(btn)
    tex:SetTexture(texture)
    btn.Texture = tex

    btn:RegisterForClicks("AnyUp") --   Register all buttons  --      Register handlers
    btn:RegisterForDrag("LeftButton") --    Register for left drag
    btn:SetScript("OnDragStart", function(self)
       local f = frame:GetScript("OnDragStart") -- get the frame OnDragStart script
        f(frame) -- run it
      end)
    btn:SetScript("OnDragStop", function(self)
        local f = frame:GetScript("OnDragStop") -- get the frame OnDragStop script
        f(frame) -- run it
      end    )
    btn:SetScript("OnDragStop", OnDragStop)
    btn:SetScript("OnEnter", OnEnter)
    btn:SetScript("OnLeave", OnLeave)
    btn.Tooltip = tooltip

    return btn --      Return our button
  end
end

local button = CreateButton(frame, "onoff", "Interface\\Icons\\inv_misc_gem_bloodgem_02", nil, "Enable/Disable")
button:SetPoint("CENTER", wowex_buttons, "LEFT", 25, 0) 
button:SetScript("OnClick", function()
    if Routine.enabled == false then
      -- wowex.wowexStorage.write('rotation_toggle', true)
      ActionButton_ShowOverlayGlow(onoff)
      Routine.enabled = true 
      return
    else
      ActionButton_HideOverlayGlow(onoff)
      -- wowex.wowexStorage.write('rotation_toggle', false)
      Routine.enabled = false
      return
    end
  end)

local button = CreateButton(frame, "cds", "Interface\\Icons\\inv_misc_pocketwatch_02", nil, "Cooldowns")
button:SetPoint("TOP", onoff, "TOPRIGHT", 20, 0) 
button:SetScript("OnClick", function()
    if mybuttons.Cooldowns == false then
      ActionButton_ShowOverlayGlow(cds)
      mybuttons.Cooldowns = true
      return
    end
    if mybuttons.Cooldowns == true then
      ActionButton_HideOverlayGlow(cds)
      mybuttons.Cooldowns = false
      return
    end
  end)

local button = CreateButton(frame, "mt", "Interface\\Icons\\spell_holy_prayerofspirit", nil, "MultiTarget")
button:SetPoint("TOP", cds, "TOPRIGHT", 20, 0) 
button:SetScript("OnClick", function()
    if mybuttons.MultiTarget == false then
      ActionButton_ShowOverlayGlow(mt)
      mybuttons.MultiTarget = true
      return
    end
    if mybuttons.MultiTarget == true then
      ActionButton_HideOverlayGlow(mt)
      mybuttons.MultiTarget = false
      return
    end
  end)

local button = CreateButton(frame, "settings", "Interface\\Icons\\trade_engineering", nil, "Settings")
button:SetPoint("TOP", mt, "TOPRIGHT", 20, 0) 
button:SetScript("OnClick", function()
    if mybuttons.Settings == false then
      ActionButton_ShowOverlayGlow(settings)
      mybuttons.Settings = true
      --rot_panel:Show()
      return
    end
    if mybuttons.Settings == true then
      ActionButton_HideOverlayGlow(settings)
      mybuttons.Settings = false
      --rot_panel:Hide()
      return
    end
  end)