local Tinkr = ...
local wowex = {}
local Util = Tinkr.Util
local Evaluator = Util.Evaluator
local Routine = Tinkr.Routine

Tinkr:require('scripts.cromulon.libs.Libdraw.Libs.LibStub.LibStub', wowex) --! If you are loading from disk your rotaiton. 
Tinkr:require('scripts.cromulon.libs.Libdraw.LibDraw', wowex) 
Tinkr:require('scripts.cromulon.libs.AceGUI30.AceGUI30', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-BlizOptionsGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-DropDownGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Frame' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-InlineGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-ScrollFrame' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-SimpleGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TabGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TreeGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Window' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Button' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-CheckBox' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-ColorPicker' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown-Items' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-EditBox' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Heading' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Icon' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-InteractiveLabel' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Keybinding' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Label' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-MultiLineEditBox' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Slider' , wowex)
Tinkr:require('scripts.cromulon.system.configs' , wowex)
Tinkr:require('scripts.cromulon.libs.libCh0tFqRg.libCh0tFqRg' , wowex)
Tinkr:require('scripts.cromulon.libs.libNekSv2Ip.libNekSv2Ip' , wowex)
Tinkr:require('scripts.cromulon.libs.CallbackHandler10.CallbackHandler10' , wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-20' , wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-pins-20' , wowex)
Tinkr:require('scripts.cromulon.interface.uibuilder' , wowex)
Tinkr:require('scripts.cromulon.interface.buttons' , wowex)

--A simple solo/farming TBC Retribution Paladin routine
--Once in-game use /routine load rexret

--Buttons Loading
mybuttons.On = false
mybuttons.Cooldowns = false
mybuttons.MultiTarget = false
mybuttons.Interupts = false
mybuttons.Settings = false

Routine:RegisterRoutine(function()
    
    --Define resource types if needed
    --local hp = power(PowerType.HolyPower)

    --Don't spam in the GCD
    if gcd() > latency() then 
        return 
    end

    function checkdebuff(spellname, unit)
        local unit = unit or player
        if not spellname then return false end
        if (not UnitExists(unit) or UnitIsDeadOrGhost(unit)) then return false end
        for i = 1, 40 do
            local _, _, count, _, _, _, _, _, _, spellId, _, _, _, _, _ = UnitDebuff(unit,i)
            local buffname, _ = GetSpellInfo(spellId)
            if buffname == spellname then return true end
        end
        return false
    end
    
    local function in_combat_function()

        --Mounted Check
        if mounted() then
            return
        end
        
        --Target Alive, Target Enemy, Player Alive, Player Not Channeling
        if alive('target') and enemy('target') and alive('player') and not channeling('player') then

            --Bubble Heal in Emergencies
            local bubblehealhealth = wowex.config.read('bubbleheal', 15)
            if health('player') <= bubblehealhealth then
                return cast(DivineShield, 'player')
            end
            if buff(DivineShield, 'player') and health('player') <= 90 then
                return cast(HolyLight, 'target')
            end

            --Seal Management - for when you need to Judge during combat
            local openseal = wowex.config.read('openseal', 'Wisdom')
            if openseal ~= 'None' then 

                if openseal == "Command" and not buff(SealOfCommand, 'player') then
                    return cast(SealOfCommand, 'player')
                end
                if openseal == "Crusader" and not buff(SealOfTheCrusader, 'player') and not checkdebuff('Judgement of the Crusader', 'target') then
                    return cast(SealOfTheCrusader, 'player')
                end
                if openseal == "Justice" and not buff(SealOfJustice, 'player') and not checkdebuff('Judgement of Justice', 'target') then
                    return cast(SealOfJustice, 'player')
                end
                if openseal == "Light" and not buff(SealOfLight, 'player') and not checkdebuff('Judgement of Light', 'target') then
                    return cast(SealOfLight, 'player')
                end    
                if openseal == "Righteousness" and not buff(SealOfRighteousness, 'player') then
                    return cast(SealOfRighteousness, 'player')
                end
                if openseal == "Wisdom" and not buff(SealOfWisdom, 'player') and not checkdebuff('Judgement of Wisdom', 'target') then
                    return cast(SealOfWisdom, 'player')
                end

            end

            --Judgement of Opening Seal
            local openseal = wowex.config.read('openseal', 'Wisdom')
            if openseal ~= 'None' then 

                if openseal == "Command" and buff(SealOfCommand, 'player') then
                    return cast(Judgement, 'target')
                end
                if openseal == "Crusader" and buff(SealOfTheCrusader, 'player') and not checkdebuff('Judgement of the Crusader', 'target') then
                    return cast(Judgement, 'target')
                end
                if openseal == "Justice" and buff(SealOfJustice, 'player') and not checkdebuff('Judgement of Justice', 'target') then
                    return cast(Judgement, 'target')
                end
                if openseal == "Light" and buff(SealOfLight, 'player') and not checkdebuff('Judgement of Light', 'target') then
                    return cast(Judgement, 'target')
                end
                if openseal == "Righteousness" and buff(SealOfRighteousness, 'player') then
                    return cast(Judgement, 'target')
                end
                if openseal == "Wisdom" and buff(SealOfWisdom, 'player') and not checkdebuff('Judgement of Wisdom', 'target') then
                    return cast(Judgement, 'target')
                end

            end

            --Seal Management - during combat
            local combatseal = wowex.config.read('combatseal', 'Command')
            if combatseal ~= 'None' then 

                if combatseal == "Command" and not buff(SealOfCommand, 'player') then
                    return cast(SealOfCommand, 'player')
                end  
                if combatseal == "Righteousness" and not buff(SealOfRighteousness, 'player') then
                    return cast(SealOfRighteousness, 'player')
                end

            end

            --Judgement
            local judgementcheck = wowex.config.read('judgeincombat', 'false')
            if judgementcheck and castable(Judgement) then
                return cast(Judgement, 'target')
            end

            --Crusader Strike
            local crusadercheck = wowex.config.read('crusader', 'true')
            if crusadercheck and castable(CrusaderStrike) then
                return cast(CrusaderStrike, 'target')
            end

            --Consecration for AOE
            local consecrationcheck = wowex.config.read('consecration', 'false')
            if consecrationcheck and castable(Consecration) and enemiesAround('player', 8) >= 2 then
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

            --Seal Management - to open combat with
            local openseal = wowex.config.read('openseal', 'Wisdom')
            if openseal ~= 'None' then 
            
                if openseal == "Command" and castable(SealOfCommand) and not buff(SealOfCommand, 'player') then
                    return cast(SealOfCommand, 'player')
                end
                if openseal == "Crusader" and castable(SealOfTheCrusader) and not buff(SealOfTheCrusader, 'player') then
                    return cast(SealOfTheCrusader, 'player')
                end
                if openseal == "Justice" and castable(SealOfJustice) and not buff(SealOfJustice, 'player') then
                    return cast(SealOfJustice, 'player')
                end
                if openseal == "Light" and castable(SealOfLight) and not buff(SealOfLight, 'player') then
                    return cast(SealOfLight, 'player')
                end
                if openseal == "Righteousness" and castable(SealOfRighteousness) and not buff(SealOfRighteousness, 'player') then
                    return cast(SealOfRighteousness, 'player')
                end
                if openseal == "Wisdom" and castable(SealOfWisdom) and not buff(SealOfWisdom, 'player') then
                    return cast(SealOfWisdom, 'player')
                end
            
            end

        end    
        
        if alive('player') and not channeling('player') then

            --Aura Management
            aura = wowex.config.read('aura', 'Sanctity')
            if aura ~= "None" then

                if aura == "Concentration" and castable(ConcentrationAura) and not buff(ConcentrationAura, 'player') then
                    return cast(ConcentrationAura, 'player')
                end
                if aura == "Crusader" and castable(CrusaderAura) and not buff(CrusaderAura, 'player') then
                    return cast(CrusaderAura, 'player')
                end
                if aura == "Devotion" and castable(DevotionAura) and not buff(DevotionAura, 'player') then
                    return cast(DevotionAura, 'player')
                end
                if aura == "FireRes" and castable(FireResistanceAura) and not buff(FireResistanceAura, 'player') then
                    return cast(FireResistanceAura, 'player')
                end
                if aura == "FrostRes" and castable(FrostResistanceAura) and not buff(FrostResistanceAura, 'player') then
                    return cast(FrostResistanceAura, 'player')
                end
                if aura == "Sanctity" and castable(SanctityAura) and not buff(SanctityAura, 'player') then
                    return cast(SanctityAura, 'player')
                end
                if aura == "ShadowRes" and castable(ShadowResistanceAura) and not buff(ShadowResistanceAura, 'player') then
                    return cast(ShadowResistanceAura, 'player')
                end
            
            end

            --Blessings Management
            blessing = wowex.config.read('blessing', 'Wisdom')
            if aura ~= "None" then

                if blessing == "Kings" and castable(BlessingOfKings) and not buff(BlessingOfKings, 'player') then
                    return cast(BlessingOfKings, 'player')
                end
                if blessing == "Light" and castable(BlessingOfLight) and not buff(BlessingOfLight, 'player') then
                    return cast(BlessingOfLight, 'player')
                end
                if blessing == "Might" and castable(BlessingOfMight) and not buff(BlessingOfMight, 'player') then
                    return cast(BlessingOfMight, 'player')
                end
                if blessing == "Salvation" and castable(BlessingOfSalvation) and not buff(BlessingOfSalvation, 'player') then
                    return cast(BlessingOfSalvation, 'player')
                end
                if blessing == "Wisdom" and castable(BlessingOfWisdom) and not buff(BlessingOfWisdom, 'player') then
                    return cast(BlessingOfWisdom, 'player')
                end

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

local retpal_settings = {
    key = "tinkr_configs",
    title = "Cromulon / Tinkr Platform",
    width = 600,
    height = 500,
    color = "F58CBA",
    resize = true,
    show = false,
    table = {
        {
            key = "heading",
            type = "heading",
            text = "Rex Retribution Paladin"
        },
        {
            key = "heading",
            type = "heading",
            text = "Auras and Blessings"
        },
        {
            key = "aura",
            width = 200,
            label = "Aura",
            text = "Aura to use",
            type = "dropdown",
            options = {"Concentration", "Crusader", "Devotion", "FireRes", "FrostRes", "Sanctity", "ShadowRes", "None"}
        },
        {
            key = "blessing",
            width = 200,
            label = "Blessing",
            text = "Blessing to use",
            type = "dropdown",
            options = {"Kings", "Light", "Might", "Salvation", "Wisdom", "None"}
        },
        {
            key = "heading",
            type = "heading",
            text = "Seals for Opening Combat and During Combat"
        },
        {
            key = "openseal",
            width = 200,
            label = "Opening Seal",
            text = "Seal to open combat",
            type = "dropdown",
            options = {"Command", "Crusader", "Justice", "Light", "Righteousness", "Wisdom", "None"}
        },
        {
            key = "combatseal",
            width = 200,
            label = "Combat Seal",
            text = "Seal to use in combat",
            type = "dropdown",
            options = {"Command", "Righteousness", "None"}
        },
        {
            key = "heading",
            type = "heading",
            text = "Combat Options"
        },
        {
            key = "judgeincombat",
            type = "checkbox",
            text = "Judgement",
            desc = "on CD"
        },
        {
            key = "crusader",
            type = "checkbox",
            text = "Crusader Strike",
            desc = "on CD"
        },
        {
            key = "consecration",
            type = "checkbox",
            text = "Consecration",
            desc = "on CD for AOE"
        },
        {
            key = "heading",
            type = "heading",
            text = "Defensives"
        },
        {
            key = "bubbleheal",
            type = "slider",
            text = "bubbleheal",
            label = "Bubble Heal at",
            min = 1,
            max = 100,
            step = 1
        }
    }
}

wowex.build_rotation_gui(retpal_settings)

local custom_buttons = {
}

wowex.button_factory(custom_buttons)