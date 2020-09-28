--[[
Ore Status screen display

This code goes into unit -> start() filter of the programming board

    Make sure you name your screen slot: displayT1, displayT2, displayT3, displayT4, displayT5
    Make sure to link the core, and rename the slot core.
    Make sure to add a tick filter to unit slot, name the tick: updateTable
    In tick lua code, add: generateHtml()
    Add stop filter with lua code, add: displayOff()
    If you don't have a tier of pure containers, leave off the corresponding display
    Container Mass, and Volume can be changed individually under: Advanced > lua parameters.
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
    oreData = {}

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
        if core.getElementTypeById(elementsIds[i]) == "container" or core.getElementTypeById(elementsIds[i]) == "Container Hub" and string.match(core.getElementNameById(elementsIds[i]),"Ore") then
            table.insert(containers, newContainer(elementsIds[i]))
        end
    end

    for i = 1, #containers do
        table.insert(oreData, {oreContainer = containers[i].name, oreContainerMass = containers[i].mass})
    end

    function round(number,decimals)
        local power = 10^decimals
        return math.floor((number/1000) * power) / power
    end 

    function oreStatus(percent)
        if percent <= 0 then return "<th style=\"color: red;\">EMPTY</th>"
        elseif percent > 0 and percent <=25 then return "<th style=\"color: red;\">LOW</th>"
        elseif percent > 25 and percent <= 50 then return "<th style=\"color: orange;\">LOW</th>"
        elseif percent > 50 and percent <= 99 then return "<th style=\"color: green;\">GOOD</th>"
        else return "<th style=\"color: green;\">FULL</th>"
        end 
    end


--T1 Stuff

    -- Bauxite Variables 
    local maxBauxiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightBauxiteOre = 1.28
    local BauxiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer,"Bauxite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massBauxiteOre = round(math.ceil((OreContainerMass - BauxiteOreContainerMass) / weightBauxiteOre),1)
            percentBauxiteOre = math.ceil(((math.ceil((massBauxiteOre*1000) - 0.5)/maxBauxiteOre)*100))
            statusBauxiteOre = oreStatus(percentBauxiteOre)
        end
    end
    if massBauxiteOre == nil then
        massBauxiteOre = 0
        percentBauxite = 0
        statusBauxiteOre = 0
    end



    -- CoalOre Variables
    local maxCoalOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightCoalOre = 1.35
    local CoalOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer,"Coal") then
            local OreContainerMass = oreData[k].oreContainerMass
            massCoalOre = round(math.ceil((OreContainerMass - CoalOreContainerMass) / weightCoalOre),1)
            percentCoalOre = math.ceil(((math.ceil((massCoalOre*1000) - 0.5)/maxCoalOre)*100))
            statusCoalOre = oreStatus(percentCoalOre)
        end
    end
    if massCoalOre == nil then
        massCoalOre = 0
        percentCoalOre = 0
        statusCoalOre = 0
    end


    -- HematiteOre Variables
    local maxHematiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightHematiteOre = 5.04
    local HematiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer,"Hematite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massHematiteOre = round(math.ceil((OreContainerMass - HematiteOreContainerMass) / weightHematiteOre),1)
            percentHematiteOre = math.ceil(((math.ceil((massHematiteOre*1000) - 0.5)/maxHematiteOre)*100))
            statusHematiteOre = oreStatus(percentHematiteOre)
        end
    end
    if massHematiteOre == nil then
        massHematiteOre = 0
        percentHematiteOre = 0
        statusHematiteOre = 0
    end


    -- QuartzOre Variables
    local maxQuartzOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightQuartzOre = 2.65
    local QuartzOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Quartz") then
            local OreContainerMass = oreData[k].oreContainerMass
            massQuartzOre = round(math.ceil((OreContainerMass - QuartzOreContainerMass) / weightQuartzOre),1)
            percentQuartzOre = math.ceil(((math.ceil((massQuartzOre*1000) - 0.5)/maxQuartzOre)*100))
            statusQuartzOre = oreStatus(percentQuartzOre)
        end
    end
    if massQuartzOre == nil then
        massQuartzOre= 0
        percentQuartzOre = 0
        statusQuartzOre = 0
    end


--T2 Stuff

    -- ChromiteOre Variables 
    local maxChromiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightChromiteOre = 4.54
    local ChromiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Chromite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massChromiteOre = round(math.ceil((OreContainerMass - ChromiteOreContainerMass) / weightChromiteOre),1)
            percentChromiteOre = math.ceil(((math.ceil((massChromiteOre*1000) - 0.5)/maxChromiteOre)*100))
            statusChromiteOre = oreStatus(percentChromiteOre)
        end
    end
    if massChromiteOre == nil then
        massChromiteOre = 0
        percentChromiteOre = 0
        statusChromiteOre = 0
    end

    -- MalachiteOre Variables 
    local maxMalachiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightMalachiteOre = 4.00
    local MalachiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Malachite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massMalachiteOre = round(math.ceil((OreContainerMass - MalachiteOreContainerMass) / weightMalachiteOre),1)
            percentMalachiteOre = math.ceil(((math.ceil((massMalachiteOre*1000) - 0.5)/maxMalachiteOre)*100))
            statusMalachiteOre = oreStatus(percentMalachiteOre)
        end
    end
    if massMalachiteOre == nil then
        massMalachiteOre = 0
        percentMalachiteOre = 0
        statusMalachiteOre = 0
    end

    -- LimestoneOre Variables 
    local maxLimestoneOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightLimestoneOre = 2.71
    local LimestoneOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Limestone") then
            local OreContainerMass = oreData[k].oreContainerMass
            massLimestoneOre = round(math.ceil((OreContainerMass - LimestoneOreContainerMass) / weightLimestoneOre),1)
            percentLimestoneOre = math.ceil(((math.ceil((massLimestoneOre*1000) - 0.5)/maxLimestoneOre)*100))
            statusLimestoneOre = oreStatus(percentLimestoneOre)
        end
    end
    if massLimestoneOre == nil then
        massLimestoneOre = 0
        percentLimestoneOre = 0
        statusLimestoneOre = 0
    end

    -- NatronOre Variables 
    local maxNatronOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightNatronOre = 1.55
    local NatronOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Natron") then
            local OreContainerMass = oreData[k].oreContainerMass
            massNatronOre = round(math.ceil((OreContainerMass - NatronOreContainerMass) / weightNatronOre),1)
            percentNatronOre = math.ceil(((math.ceil((massNatronOre*1000) - 0.5)/maxNatronOre)*100))
            statusNatronOre = oreStatus(percentNatronOre)
        end
    end
    if massNatronOre == nil then
        massNatronOre = 0
        percentNatronOre = 0
        statusNatronOre = 0
    end

--T3 Stuff

    -- GarnieriteOre Variables 
    local maxGarnieriteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightGarnieriteOre = 2.60
    local GarnieriteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Garnierite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massGarnieriteOre = round(math.ceil((OreContainerMass - GarnieriteOreContainerMass) / weightGarnieriteOre),1)
            percentGarnieriteOre = math.ceil(((math.ceil((massGarnieriteOre*1000) - 0.5)/maxGarnieriteOre)*100))
            statusGarnieriteOre = oreStatus(percentGarnieriteOre)
        end
    end
    if massGarnieriteOre == nil then
        massGarnieriteOre = 0
        percentGarnieriteOre = 0
        statusGarnieriteOre = 0
    end

    -- PetaliteOre Variables
    local maxPetaliteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPetaliteOre = 2.41
    local PetaliteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Petalite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massPetaliteOre = round(math.ceil((OreContainerMass - PetaliteOreContainerMass) / weightPetaliteOre),1)
            percentPetaliteOre = math.ceil(((math.ceil((massPetaliteOre*1000) - 0.5)/maxPetaliteOre)*100))
            statusPetaliteOre = oreStatus(percentPetaliteOre)
        end
    end
    if massPetaliteOre == nil then
        massPetaliteOre = 0
        percentPetaliteOre = 0
        statusPetaliteOre = 0
    end

    -- AcanthiteOre Variables
    local maxAcanthiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightAcanthiteOre = 7.20
    local AcanthiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Acanthite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massAcanthiteOre = round(math.ceil((OreContainerMass - AcanthiteOreContainerMass) / weightAcanthiteOre),1)
            percentAcanthiteOre = math.ceil(((math.ceil((massAcanthiteOre*1000) - 0.5)/maxAcanthiteOre)*100))
            statusAcanthiteOre = oreStatus(percentAcanthiteOre)
        end
    end
    if massAcanthiteOre == nil then
        massAcanthiteOre = 0
        percentAcanthiteOre = 0
        statusAcanthiteOre = 0
    end

    -- PyriteOre Variables
    local maxPyriteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightPyriteOre = 5.01
    local PyriteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Pyrite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massPyriteOre = round(math.ceil((OreContainerMass - PyriteOreContainerMass) / weightPyriteOre),1)
            percentPyriteOre = math.ceil(((math.ceil((massPyriteOre*1000) - 0.5)/maxPyriteOre)*100))
            statusPyriteOre = oreStatus(percentPyriteOre)
        end
    end
    if massPyriteOre == nil then
        massPyriteOre = 0
        percentPyriteOre = 0
        statusPyriteOre = 0
    end

--T4 Stuff

    -- CobaltiteOre Variables 
    local maxCobaltiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightCobaltiteOre = 6.33
    local CobaltiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Cobaltite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massCobaltiteOre = round(math.ceil((OreContainerMass - CobaltiteOreContainerMass) / weightCobaltiteOre),1)
            percentCobaltiteOre = math.ceil(((math.ceil((massCobaltiteOre*1000) - 0.5)/maxCobaltiteOre)*100))
            statusCobaltiteOre = oreStatus(percentCobaltiteOre)
        end
    end
    if massCobaltiteOre == nil then
        massCobaltiteOre = 0
        percentCobaltiteOre = 0
        statusCobaltiteOre = 0
    end

    -- CryoliteOre Variables
    local maxCryoliteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightCryoliteOre = 2.95
    local CryoliteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Cryolite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massCryoliteOre = round(math.ceil((OreContainerMass - CryoliteOreContainerMass) / weightCryoliteOre),1)
            percentCryoliteOre = math.ceil(((math.ceil((massCryoliteOre*1000) - 0.5)/maxCryoliteOre)*100))
            statusCryoliteOre = oreStatus(percentCryoliteOre)
        end
    end
    if massCryoliteOre == nil then
        massCryoliteOre = 0
        percentCryoliteOre = 0
        statusCryoliteOre = 0
    end

    -- GoldOre Variables
    local maxGoldOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightGoldOre = 19.30
    local GoldOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Gold") then
            local OreContainerMass = oreData[k].oreContainerMass
            massGoldOre = round(math.ceil((OreContainerMass - GoldOreContainerMass) / weightGoldOre),1)
            percentGoldOre = math.ceil(((math.ceil((massGoldOre*1000) - 0.5)/maxGoldOre)*100))
            statusGoldOre = oreStatus(percentGoldOre)
        end
    end
    if massGoldOre == nil then
        massGoldOre = 0
        percentGoldOre = 0
        statusGoldOre = 0
    end

    -- KolbeckiteOre Variables
    local maxKolbeckiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightKolbeckiteOre = 2.37
    local KolbeckiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Kolbeckite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massKolbeckiteOre = round(math.ceil((OreContainerMass - KolbeckiteOreContainerMass) / weightKolbeckiteOre),1)
            percentKolbeckiteOre = math.ceil(((math.ceil((massKolbeckiteOre*1000) - 0.5)/maxKolbeckiteOre)*100))
            statusKolbeckiteOre = oreStatus(percentKolbeckiteOre)
        end
    end
    if massKolbeckiteOre == nil then
        massKolbeckiteOre = 0
        percentKolbeckiteOre = 0
        statusKolbeckiteOre = 0
    end

--T5 Stuff

    -- RhodoniteOre Variables 
    local maxRhodoniteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightRhodoniteOre = 3.76
    local RhodoniteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Rhodonite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massRhodoniteOre = round(math.ceil((OreContainerMass - RhodoniteOreContainerMass) / weightRhodoniteOre),1)
            percentRhodoniteOre = math.ceil(((math.ceil((massManganeseCobalt*1000) - 0.5)/maxRhodoniteOre)*100))
            statusRhodoniteOre = oreStatus(percentRhodoniteOre)
        end
    end
    if massRhodoniteOre == nil then
        massRhodoniteOre = 0
        percentRhodoniteOre = 0
        statusRhodoniteOre = 0
    end

    -- ColumbiteOre Variables
    local maxColumbiteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightColumbiteOre = 5.38
    local ColumbiteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Columbite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massColumbiteOre = round(math.ceil((OreContainerMass - ColumbiteOreContainerMass) / weightColumbiteOre),1)
            percentColumbiteOre = math.ceil(((math.ceil((massColumbiteOre*1000) - 0.5)/maxColumbiteOre)*100))
            statusColumbiteOre = oreStatus(percentColumbiteOre)
        end
    end
    if massColumbiteOre == nil then
        massColumbiteOre = 0
        percentColumbiteOre = 0
        statusColumbiteOre = 0
    end

    -- IllmeniteOre Variables
    local maxIllmeniteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightIllmeniteOre = 4.55
    local IllmeniteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Illmenite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massIllmeniteOre = round(math.ceil((OreContainerMass - IllmeniteOreContainerMass) / weightIllmeniteOre),1)
            percentIllmeniteOre = math.ceil(((math.ceil((massIllmeniteOre*1000) - 0.5)/maxIllmeniteOre)*100))
            statusIllmeniteOre = oreStatus(percentIllmeniteOre)
        end
    end
    if massIllmeniteOre == nil then
        massIllmeniteOre = 0
        percentIllmeniteOre = 0
        statusIllmeniteOre = 0
    end

    -- VanadiniteOre Variables
    local maxVanadiniteOre = 166400 --export: This is the maximum mass allowed in container. Update as needed
    local weightVanadiniteOre = 6.95
    local VanadiniteOreContainerMass = 0 --export: This is the mass of the container.
    for k, v in pairs(oreData) do
        if string.match(oreData[k].oreContainer, "Vanadinite") then
            local OreContainerMass = oreData[k].oreContainerMass
            massVanadiniteOre = round(math.ceil((OreContainerMass - VanadiniteOreContainerMass) / weightVanadiniteOre),1)
            percentVanadiniteOre = math.ceil(((math.ceil((massVanadiniteOre*1000) - 0.5)/maxVanadiniteOre)*100))
            statusVanadiniteOre = oreStatus(percentVanadiniteOre)
        end
    end
    if massVanadiniteOre == nil then
        massVanadiniteOre = 0
        percentVanadiniteOre = 0
        statusVanadiniteOre = 0
    end

    if displayT1 then
        html = [[
        <div class="bootstrap">
        <h1 style="
            font-size: 8em;
            text-transform: capitalize;
        ">T1 Ore Status</h1>
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
                <th>Bauxite</th>
                <th>]]..massBauxiteOre..[[KL]]..[[</th>
                <th>]]..percentBauxiteOre..[[%</th>
                ]]..statusBauxiteOre..[[
            </tr>
            <tr>
                <th>Coal</th>
                <th>]]..massCoalOre..[[KL]]..[[</th>
                <th>]]..percentCoalOre..[[%</th>
                ]]..statusCoalOre..[[
            </tr>
            <tr>
                <th>Hematite</th>
                <th>]]..massHematiteOre..[[KL]]..[[</th>
                <th>]]..percentHematiteOre..[[%</th>
                ]]..statusHematiteOre..[[
            </tr>
            <tr>
                <th>Quartz</th>
                <th>]]..massQuartzOre..[[KL]]..[[</th>
                <th>]]..percentQuartzOre..[[%</th>
                ]]..statusQuartzOre..[[
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
        ">T2 Ore Status</h1>
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
                <th>Natron</th>
                <th>]]..massNatronOre..[[KL]]..[[</th>
                <th>]]..percentNatronOre..[[%</th>
                ]]..statusNatronOre..[[
            </tr>
            <tr>
                <th>Malachite</th>
                <th>]]..massMalachiteOre..[[KL]]..[[</th>
                <th>]]..percentMalachiteOre..[[%</th>
                ]]..statusMalachiteOre..[[
            </tr>
            <tr>
                <th>Limestone</th>
                <th>]]..massLimestoneOre..[[KL]]..[[</th>
                <th>]]..percentLimestoneOre..[[%</th>
                ]]..statusLimestoneOre..[[
            </tr>
            <tr>
                <th>Chromite</th>
                <th>]]..massChromiteOre..[[KL]]..[[</th>
                <th>]]..percentChromiteOre..[[%</th>
                ]]..statusChromiteOre..[[
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
        ">T3 Ore Status</h1>
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
                <th>Petalite</th>
                <th>]]..massPetaliteOre..[[KL]]..[[</th>
                <th>]]..percentPetaliteOre..[[%</th>
                ]]..statusPetaliteOre..[[
            </tr>
            <tr>
                <th>Garnierite</th>
                <th>]]..massGarnieriteOre..[[KL]]..[[</th>
                <th>]]..percentGarnieriteOre..[[%</th>
                ]]..statusGarnieriteOre..[[
            </tr>
            <tr>
                <th>Pyrite</th>
                <th>]]..massPyriteOre..[[KL]]..[[</th>
                <th>]]..percentPyriteOre..[[%</th>
                ]]..statusPyriteOre..[[
            </tr>
            <tr>
                <th>Acanthite</th>
                <th>]]..massAcanthiteOre..[[KL]]..[[</th>
                <th>]]..percentAcanthiteOre..[[%</th>
                ]]..statusAcanthiteOre..[[
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
        ">T4 Ore Status</h1>
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
                <th>Cobaltite</th>
                <th>]]..massCobaltiteOre..[[KL]]..[[</th>
                <th>]]..percentCobaltiteOre..[[%</th>
                ]]..statusCobaltiteOre..[[
            </tr>
            <tr>
                <th>Cryolite</th>
                <th>]]..massCryoliteOre..[[KL]]..[[</th>
                <th>]]..percentCryoliteOre..[[%</th>
                ]]..statusCryoliteOre..[[
            </tr>
            <tr>
                <th>Gold Nuggets</th>
                <th>]]..massGoldOre..[[KL]]..[[</th>
                <th>]]..percentGoldOre..[[%</th>
                ]]..statusGoldOre..[[
            </tr>
            <tr>
                <th>Kolbeckite</th>
                <th>]]..massKolbeckiteOre..[[KL]]..[[</th>
                <th>]]..percentKolbeckiteOre..[[%</th>
                ]]..statusKolbeckiteOre..[[
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
        ">T5 Ore Status</h1>
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
                <th>Rhodonite</th>
                <th>]]..massRhodoniteOre..[[KL]]..[[</th>
                <th>]]..percentRhodoniteOre..[[%</th>
                ]]..statusRhodoniteOre..[[
            </tr>
            <tr>
                <th>Columbite</th>
                <th>]]..massColumbiteOre..[[KL]]..[[</th>
                <th>]]..percentColumbiteOre..[[%</th>
                ]]..statusColumbiteOre..[[
            </tr>
            <tr>
                <th>Illmenite</th>
                <th>]]..massIllmeniteOre..[[KL]]..[[</th>
                <th>]]..percentIllmeniteOre..[[%</th>
                ]]..statusIllmeniteOre..[[
            </tr>
            <tr>
                <th>Vanadinite</th>
                <th>]]..massVanadiniteOre..[[KL]]..[[</th>
                <th>]]..percentVanadiniteOre..[[%</th>
                ]]..statusVanadiniteOre..[[
            </tr>
        </table>
        </div>
        ]]
        displayT5.setHTML(html)
    end
end
unit.setTimer('updateTable', 1)