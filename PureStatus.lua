--[[
Pure Status screen display

This code goes into unit -> start() filter of the programming board

    Make sure you name your screen slot: displayT1, displayT2, displayT3, displayT4, displayT5
    Make sure to link the core, and rename the slot core.
    Make sure to add a tick filter to unit slot, name the tick: updateTable
    In tick lua code, add: generateHtml()
    Add stop filter with lua code, add: displayOff()
    If you don't have a tier of pure containers, leave off the corresponding display
    Container Mass, and Volume can be changed individually under: Advanced > lua parameters.
    if you use Container Hubs, name the hub, don't name the containers, as that will cause issues, also Hub container weight is 0.
]]

unit.hide()
if displayT1 then displayT1.activate() end
if displayT2 then displayT2.activate() end
if displayT3 then displayT3.activate() end
if displayT4 then displayT4.activate() end
if displayT5 then displayT5.activate() end

function displayOff()
    if displayT1 then displayT1.clear() end
    if displayT2 then displayT2.clear() end
    if displayT3 then displayT3.clear() end
    if displayT4 then displayT4.clear() end
    if displayT5 then displayT5.clear() end
end

function generateHtml()

    elementsIds = core.getElementIdList()
    containers = {}
    pureData = {}

    function newContainer(_id)
        local container = 
        {
            id = _id;
            name = core.getElementNameById(_id);
            mass = core.getElementMassById(_id);
        }
        return container
    end

    for i = 1, #elementsIds do
        if core.getElementTypeById(elementsIds[i]) == "container" or core.getElementTypeById(elementsIds[i]) == "Container Hub" and string.match(core.getElementNameById(elementsIds[i]),"Pure") then
            table.insert(containers, newContainer(elementsIds[i]))
        end
    end

    for i = 1, #containers do
        table.insert(pureData, {pureContainer = containers[i].name, pureContainerMass = containers[i].mass})
    end

    function round(number,decimals)
        local power = 10^decimals
        return math.floor((number/1000) * power) / power
    end 

    function pureStatus(percent)
        if percent <= 25 then return "<th style=\"color: red;\">LOW</th>"
        elseif percent > 25 and percent < 50 then return "<th style=\"color: orange;\">LOW</th>"
        else return "<th style=\"color: green;\">GOOD</th>"
        end 
    end

    function hoStatus(percent)
        if percent <= 10 then return "<th style=\"color: orange;\">LOW</th>"
        elseif percent > 10 and percent < 70 then return "<th style=\"color: green;\">GOOD</th>"
        else return "<th style=\"color: red;\">PLEASE EMPTY</th>"
        end 
    end

--T1 Stuff

    -- PureAluminum Variables 
    local maxPureAluminum = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureAluminum = 2.70
    local PureAluminumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer,"Alumin") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureAluminum = round(math.ceil((PureContainerMass - PureAluminumContainerMass) / weightPureAluminum),1)
            percentPureAluminum = math.ceil(((math.ceil((massPureAluminum*1000) - 0.5)/maxPureAluminum)*100))
            statusPureAluminum = pureStatus(percentPureAluminum)
        end
    end
    if massPureAluminum == nil then
        massPureAluminum = 0
        percentAluminum = 0
        statusPureAluminum = 0
    end

    -- PureCarbon Variables
    local maxPureCarbon = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureCarbon = 2.27
    local PureCarbonContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer,"Carbon") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureCarbon = round(math.ceil((PureContainerMass - PureCarbonContainerMass) / weightPureCarbon),1)
            percentPureCarbon = math.ceil(((math.ceil((massPureCarbon*1000) - 0.5)/maxPureCarbon)*100))
            statusPureCarbon = pureStatus(percentPureCarbon)
        end
    end
    if massPureCarbon == nil then
        massPureCarbon = 0
        percentPureCarbon = 0
        statusPureCarbon = 0
    end

    -- PureIron Variables
    local maxPureIron = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureIron = 7.85
    local PureIronContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer,"Iron") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureIron = round(math.ceil((PureContainerMass - PureIronContainerMass) / weightPureIron),1)
            percentPureIron = math.ceil(((math.ceil((massPureIron*1000) - 0.5)/maxPureIron)*100))
            statusPureIron = pureStatus(percentPureIron)
        end
    end
    if massPureIron == nil then
        massPureIron = 0
        percentPureIron = 0
        statusPureIron = 0
    end

    -- Pure Silicon Variables
    local maxPureSilicon = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureSilicon = 2.33
    local PureSiliconContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Silicon") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureSilicon = round(math.ceil((PureContainerMass - PureSiliconContainerMass) / weightPureSilicon),1)
            percentPureSilicon = math.ceil(((math.ceil((massPureSilicon*1000) - 0.5)/maxPureSilicon)*100))
            statusPureSilicon = pureStatus(percentPureSilicon)
        end
    end
    if massPureSilicon == nil then
        massPureSilicon= 0
        percentPureSilicon = 0
        statusPureSilicon = 0
    end

    -- PureOxygen Variables 
    local maxPureOxygen = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureOxygen = 1
    local PureOxygenContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Oxygen") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureOxygen = round(math.ceil((PureContainerMass - PureOxygenContainerMass) / weightPureOxygen),1)
            percentPureOxygen = math.ceil(((math.ceil((massPureOxygen*1000) - 0.5)/maxPureOxygen)*100))
            statusPureOxygen = hoStatus(percentPureOxygen)
        end
    end
    if massPureOxygen == nil then
        massPureOxygen = 0
        percentPureOxygen = 0
        statusPureOxygen = 0
    end

    -- PureHydrogen Variables 
    local maxPureHydrogen = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureHydrogen = 0.07
    local PureHydrogenContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Hydrogen") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureHydrogen = round(math.ceil((PureContainerMass - PureHydrogenContainerMass) / weightPureHydrogen),1)
            percentPureHydrogen = math.ceil(((math.ceil((massPureHydrogen*1000) - 0.5)/maxPureHydrogen)*100))
            statusPureHydrogen = hoStatus(percentPureHydrogen)
        end
    end
    if massPureHydrogen == nil then
        massPureHydrogen = 0
        percentPureHydrogen = 0
        statusPureHydrogen = 0
    end

--T2 Stuff

    -- PureCalcium Variables 
    local maxPureCalcium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureCalcium = 1.55
    local PureCalciumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Calcium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureCalcium = round(math.ceil((PureContainerMass - PureCalciumContainerMass) / weightPureCalcium),1)
            percentPureCalcium = math.ceil(((math.ceil((massPureCalcium*1000) - 0.5)/maxPureCalcium)*100))
            statusPureCalcium = pureStatus(percentPureCalcium)
        end
    end
    if massPureCalcium == nil then
        massPureCalcium = 0
        percentPureCalcium = 0
        statusPureCalcium = 0
    end

    -- PureChromium Variables 
    local maxPureChromium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureChromium = 7.19
    local PureChromiumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Chromium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureChromium = round(math.ceil((PureContainerMass - PureChromiumContainerMass) / weightPureChromium),1)
            percentPureChromium = math.ceil(((math.ceil((massPureChromium*1000) - 0.5)/maxPureChromium)*100))
            statusPureChromium = pureStatus(percentPureChromium)
        end
    end
    if massPureChromium == nil then
        massPureChromium = 0
        percentPureChromium = 0
        statusPureChromium = 0
    end

    -- PureCopper Variables 
    local maxPureCopper = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureCopper = 8.96
    local PureCopperContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Copper") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureCopper = round(math.ceil((PureContainerMass - PureCopperContainerMass) / weightPureCopper),1)
            percentPureCopper = math.ceil(((math.ceil((massPureCopper*1000) - 0.5)/maxPureCopper)*100))
            statusPureCopper = pureStatus(percentPureCopper)
        end
    end
    if massPureCopper == nil then
        massPureCopper = 0
        percentPureCopper = 0
        statusPureCopper = 0
    end

    -- PureSodium Variables 
    local maxPureSodium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureSodium = 0.97
    local PureSodiumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Sodium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureSodium = round(math.ceil((PureContainerMass - PureSodiumContainerMass) / weightPureSodium),1)
            percentPureSodium = math.ceil(((math.ceil((massPureSodium*1000) - 0.5)/maxPureSodium)*100))
            statusPureSodium = pureStatus(percentPureSodium)
        end
    end
    if massPureSodium == nil then
        massPureSodium = 0
        percentPureSodium = 0
        statusPureSodium = 0
    end

--T3 Stuff

    -- PureLithium Variables 
    local maxPureLithium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureLithium = 0.53
    local PureLithiumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Lithium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureLithium = round(math.ceil((PureContainerMass - PureLithiumContainerMass) / weightPureLithium),1)
            percentPureLithium = math.ceil(((math.ceil((massPureLithium*1000) - 0.5)/maxPureLithium)*100))
            statusPureLithium = pureStatus(percentPureLithium)
        end
    end
    if massPureLithium == nil then
        massPureLithium = 0
        percentPureLithium = 0
        statusPureLithium = 0
    end

    -- PureNickel Variables
    local maxPureNickel = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureNickel = 8.91
    local PureNickelContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Nickel") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureNickel = round(math.ceil((PureContainerMass - PureNickelContainerMass) / weightPureNickel),1)
            percentPureNickel = math.ceil(((math.ceil((massPureNickel*1000) - 0.5)/maxPureNickel)*100))
            statusPureNickel = pureStatus(percentPureNickel)
        end
    end
    if massPureNickel == nil then
        massPureNickel = 0
        percentPureNickel = 0
        statusPureNickel = 0
    end

    -- PureSilver Variables
    local maxPureSilver = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureSilver = 10.49
    local PureSilverContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Silver") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureSilver = round(math.ceil((PureContainerMass - PureSilverContainerMass) / weightPureSilver),1)
            percentPureSilver = math.ceil(((math.ceil((massPureSilver*1000) - 0.5)/maxPureSilver)*100))
            statusPureSilver = pureStatus(percentPureSilver)
        end
    end
    if massPureSilver == nil then
        massPureSilver = 0
        percentPureSilver = 0
        statusPureSilver = 0
    end

    -- Pure Sulfur Variables
    local maxPureSulfur = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureSulfur = 1.82
    local PureSulfurContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Sulfur") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureSulfur = round(math.ceil((PureContainerMass - PureSulfurContainerMass) / weightPureSulfur),1)
            percentPureSulfur = math.ceil(((math.ceil((massPureSulfur*1000) - 0.5)/maxPureSulfur)*100))
            statusPureSulfur = pureStatus(percentPureSulfur)
        end
    end
    if massPureSulfur == nil then
        massPureSulfur = 0
        percentPureSulfur = 0
        statusPureSulfur = 0
    end

--T4 Stuff

    -- PureCobalt Variables 
    local maxPureCobalt = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureCobalt = 8.90
    local PureCobaltContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Cobalt") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureCobalt = round(math.ceil((PureContainerMass - PureCobaltContainerMass) / weightPureCobalt),1)
            percentPureCobalt = math.ceil(((math.ceil((massPureCobalt*1000) - 0.5)/maxPureCobalt)*100))
            statusPureCobalt = pureStatus(percentPureCobalt)
        end
    end
    if massPureCobalt == nil then
        massPureCobalt = 0
        percentPureCobalt = 0
        statusPureCobalt = 0
    end

    -- PureFluorine Variables
    local maxPureFluorine = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureFluorine = 1.70
    local PureFluorineContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Fluorine") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureFluorine = round(math.ceil((PureContainerMass - PureFluorineContainerMass) / weightPureFluorine),1)
            percentPureFluorine = math.ceil(((math.ceil((massPureFluorine*1000) - 0.5)/maxPureFluorine)*100))
            statusPureFluorine = pureStatus(percentPureFluorine)
        end
    end
    if massPureFluorine == nil then
        massPureFluorine = 0
        percentPureFluorine = 0
        statusPureFluorine = 0
    end

    -- PureGold Variables
    local maxPureGold = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureGold = 19.30
    local PureGoldContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Gold") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureGold = round(math.ceil((PureContainerMass - PureGoldContainerMass) / weightPureGold),1)
            percentPureGold = math.ceil(((math.ceil((massPureGold*1000) - 0.5)/maxPureGold)*100))
            statusPureGold = pureStatus(percentPureGold)
        end
    end
    if massPureGold == nil then
        massPureGold = 0
        percentPureGold = 0
        statusPureGold = 0
    end

    -- Pure Scandium Variables
    local maxPureScandium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureScandium = 2.98
    local PureScandiumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Scandium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureScandium = round(math.ceil((PureContainerMass - PureScandiumContainerMass) / weightPureScandium),1)
            percentPureScandium = math.ceil(((math.ceil((massPureScandium*1000) - 0.5)/maxPureScandium)*100))
            statusPureScandium = pureStatus(percentPureScandium)
        end
    end
    if massPureScandium == nil then
        massPureScandium = 0
        percentPureScandium = 0
        statusPureScandium = 0
    end

--T5 Stuff

    -- PureManganese Variables 
    local maxPureManganese = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureManganese = 7.21
    local PureManganeseContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Manganese") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureManganese = round(math.ceil((PureContainerMass - PureManganeseContainerMass) / weightPureManganese),1)
            percentPureManganese = math.ceil(((math.ceil((massManganeseCobalt*1000) - 0.5)/maxPureManganese)*100))
            statusPureManganese = pureStatus(percentPureManganese)
        end
    end
    if massPureManganese == nil then
        massPureManganese = 0
        percentPureManganese = 0
        statusPureManganese = 0
    end

    -- PureNiobium Variables
    local maxPureNiobium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureNiobium = 8.57
    local PureNiobiumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Niobium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureNiobium = round(math.ceil((PureContainerMass - PureNiobiumContainerMass) / weightPureNiobium),1)
            percentPureNiobium = math.ceil(((math.ceil((massPureNiobium*1000) - 0.5)/maxPureNiobium)*100))
            statusPureNiobium = pureStatus(percentPureNiobium)
        end
    end
    if massPureNiobium == nil then
        massPureNiobium = 0
        percentPureNiobium = 0
        statusPureNiobium = 0
    end

    -- PureTitanium Variables
    local maxPureTitanium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureTitanium = 4.51
    local PureTitaniumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Titanium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureTitanium = round(math.ceil((PureContainerMass - PureTitaniumContainerMass) / weightPureTitanium),1)
            percentPureTitanium = math.ceil(((math.ceil((massPureTitanium*1000) - 0.5)/maxPureTitanium)*100))
            statusPureTitanium = pureStatus(percentPureTitanium)
        end
    end
    if massPureTitanium == nil then
        massPureTitanium = 0
        percentPureTitanium = 0
        statusPureTitanium = 0
    end

    -- Pure Vanadium Variables
    local maxPureVanadium = 10400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPureVanadium = 6.00
    local PureVanadiumContainerMass = 1280 --export: This is the mass of the container.
    for k, v in pairs(pureData) do
        if string.match(pureData[k].pureContainer, "Vanadium") then
            local PureContainerMass = pureData[k].pureContainerMass
            massPureVanadium = round(math.ceil((PureContainerMass - PureVanadiumContainerMass) / weightPureVanadium),1)
            percentPureVanadium = math.ceil(((math.ceil((massPureVanadium*1000) - 0.5)/maxPureVanadium)*100))
            statusPureVanadium = pureStatus(percentPureVanadium)
        end
    end
    if massPureVanadium == nil then
        massPureVanadium = 0
        percentPureVanadium = 0
        statusPureVanadium = 0
    end

    if displayT1 then
        html = [[
        <div class="bootstrap">
        <h1 style="
            font-size: 8em;
            text-transform: capitalize;
        ">T1 Pure Status</h1>
        <table 
        style="
            margin-top: 10px;
            margin-left: auto;
            margin-right: auto;
            width: 98%;
            font-size: 4em;
            text-transform: capitalize;
        ">
            </br>
            <tr style="
                width: 100%;
                margin-bottom: 30px;
                background-color: blue;
                color: white;
                text-transform: capitalize;
            ">
                <th>Type</th>
                <th>Qty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Aluminium</th>
                <th>]]..massPureAluminum..[[KL]]..[[</th>
                <th>]]..percentPureAluminum..[[%</th>
                ]]..statusPureAluminum..[[
            </tr>
            <tr>
                <th>Pure Carbon</th>
                <th>]]..massPureCarbon..[[KL]]..[[</th>
                <th>]]..percentPureCarbon..[[%</th>
                ]]..statusPureCarbon..[[
            </tr>
            <tr>
                <th>Pure Iron</th>
                <th>]]..massPureIron..[[KL]]..[[</th>
                <th>]]..percentPureIron..[[%</th>
                ]]..statusPureIron..[[
            </tr>
            <tr>
                <th>Pure Silicon</th>
                <th>]]..massPureSilicon..[[KL]]..[[</th>
                <th>]]..percentPureSilicon..[[%</th>
                ]]..statusPureSilicon..[[
            </tr>
            <tr>
                <th>Pure Hydrogen</th>
                <th>]]..massPureHydrogen..[[KL]]..[[</th>
                <th>]]..percentPureHydrogen..[[%</th>
                ]]..statusPureHydrogen..[[
            </tr>
            <tr>
                <th>Pure Oxygen</th>
                <th>]]..massPureOxygen..[[KL]]..[[</th>
                <th>]]..percentPureOxygen..[[%</th>
                ]]..statusPureOxygen..[[
            </tr>
        </table>
        </div>
        ]]
        displayT1.setHTML(html)
    end

    if displayT2 then
        html = [[
        <div class="bootstrap">
        <h1 style="
            font-size: 8em;
            text-transform: capitalize;
        ">T2 Pure Status</h1>
        <table 
        style="
            margin-top: 10px;
            margin-left: auto;
            margin-right: auto;
            width: 98%;
            font-size: 4em;
            text-transform: capitalize;
        ">
            </br>
            <tr style="
                width: 100%;
                margin-bottom: 30px;
                background-color: blue;
                color: white;
                text-transform: capitalize;
            ">
                <th>Type</th>
                <th>Qty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Sodium</th>
                <th>]]..massPureSodium..[[KL]]..[[</th>
                <th>]]..percentPureSodium..[[%</th>
                ]]..statusPureSodium..[[
            </tr>
            <tr>
                <th>Pure Chromium</th>
                <th>]]..massPureChromium..[[KL]]..[[</th>
                <th>]]..percentPureChromium..[[%</th>
                ]]..statusPureChromium..[[
            </tr>
            <tr>
                <th>Pure Copper</th>
                <th>]]..massPureCopper..[[KL]]..[[</th>
                <th>]]..percentPureCopper..[[%</th>
                ]]..statusPureCopper..[[
            </tr>
            <tr>
                <th>Pure Calcium</th>
                <th>]]..massPureCalcium..[[KL]]..[[</th>
                <th>]]..percentPureCalcium..[[%</th>
                ]]..statusPureCalcium..[[
            </tr>
            
        </table>
        </div>
        ]]
        displayT2.setHTML(html)
    end

    if displayT3 then
        html = [[
        <div class="bootstrap">
        <h1 style="
            font-size: 8em;
            text-transform: capitalize;
        ">T3 Pure Status</h1>
        <table 
        style="
            margin-top: 10px;
            margin-left: auto;
            margin-right: auto;
            width: 98%;
            font-size: 4em;
            text-transform: capitalize;
        ">
            </br>
            <tr style="
                width: 100%;
                margin-bottom: 30px;
                background-color: blue;
                color: white;
                text-transform: capitalize;
            ">
                <th>Type</th>
                <th>Qty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Nickel</th>
                <th>]]..massPureNickel..[[KL]]..[[</th>
                <th>]]..percentPureNickel..[[%</th>
                ]]..statusPureNickel..[[
            </tr>
            <tr>
                <th>Pure Lithium</th>
                <th>]]..massPureLithium..[[KL]]..[[</th>
                <th>]]..percentPureLithium..[[%</th>
                ]]..statusPureLithium..[[
            </tr>
            <tr>
                <th>Pure Sulfur</th>
                <th>]]..massPureSulfur..[[KL]]..[[</th>
                <th>]]..percentPureSulfur..[[%</th>
                ]]..statusPureSulfur..[[
            </tr>
            <tr>
                <th>Pure Silver</th>
                <th>]]..massPureSilver..[[KL]]..[[</th>
                <th>]]..percentPureSilver..[[%</th>
                ]]..statusPureSilver..[[
            </tr>
            
        </table>
        </div>
        ]]
        displayT3.setHTML(html)
    end

    if displayT4 then
        html = [[
        <div class="bootstrap">
        <h1 style="
            font-size: 8em;
            text-transform: capitalize;
        ">T4 Pure Status</h1>
        <table 
        style="
            margin-top: 10px;
            margin-left: auto;
            margin-right: auto;
            width: 98%;
            font-size: 4em;
            text-transform: capitalize;
        ">
            </br>
            <tr style="
                width: 100%;
                margin-bottom: 30px;
                background-color: blue;
                color: white;
                text-transform: capitalize;
            ">
                <th>Type</th>
                <th>Qty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Cobalt</th>
                <th>]]..massPureCobalt..[[KL]]..[[</th>
                <th>]]..percentPureCobalt..[[%</th>
                ]]..statusPureCobalt..[[
            </tr>
            <tr>
                <th>Pure Fluorine</th>
                <th>]]..massPureFluorine..[[KL]]..[[</th>
                <th>]]..percentPureFluorine..[[%</th>
                ]]..statusPureFluorine..[[
            </tr>
            <tr>
                <th>Pure Gold</th>
                <th>]]..massPureGold..[[KL]]..[[</th>
                <th>]]..percentPureGold..[[%</th>
                ]]..statusPureGold..[[
            </tr>
            <tr>
                <th>Pure Scandium</th>
                <th>]]..massPureScandium..[[KL]]..[[</th>
                <th>]]..percentPureScandium..[[%</th>
                ]]..statusPureScandium..[[
            </tr>
        </table>
        </div>
        ]]
        displayT4.setHTML(html)
    end

    if displayT5 then
        html = [[
        <div class="bootstrap">
        <h1 style="
            font-size: 8em;
            text-transform: capitalize;
        ">T5 Pure Status</h1>
        <table 
        style="
            margin-top: 10px;
            margin-left: auto;
            margin-right: auto;
            width: 98%;
            font-size: 4em;
            text-transform: capitalize;
        ">
            </br>
            <tr style="
                width: 100%;
                margin-bottom: 30px;
                background-color: blue;
                color: white;
                text-transform: capitalize;
            ">
                <th>Type</th>
                <th>Qty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Manganese</th>
                <th>]]..massPureManganese..[[KL]]..[[</th>
                <th>]]..percentPureManganese..[[%</th>
                ]]..statusPureManganese..[[
            </tr>
            <tr>
                <th>Pure Niobium</th>
                <th>]]..massPureNiobium..[[KL]]..[[</th>
                <th>]]..percentPureNiobium..[[%</th>
                ]]..statusPureNiobium..[[
            </tr>
            <tr>
                <th>Pure Titanium</th>
                <th>]]..massPureTitanium..[[KL]]..[[</th>
                <th>]]..percentPureTitanium..[[%</th>
                ]]..statusPureTitanium..[[
            </tr>
            <tr>
                <th>Pure Vanadium</th>
                <th>]]..massPureVanadium..[[KL]]..[[</th>
                <th>]]..percentPureVanadium..[[%</th>
                ]]..statusPureVanadium..[[
            </tr>
        </table>
        </div>
        ]]
        displayT5.setHTML(html)
    end
end
unit.setTimer('updateTable', 1)