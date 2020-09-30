--[[
Pure Status screen display

This code goes into unit -> start() filter of the programming board

    Make sure you name your screen slot: displayT1, displayT2, displayT3, displayT4, displayT5
    Make sure to link the core, and rename the slot core.
    Make sure to add a tick filter to unit slot, name the tick: updateTable
    In tick lua code, add: generateHtml()
    Add stop filter with lua code, add: displayOff()
    If you don't have a tier of containers, leave off the corresponding display
    Container Mass, and Volume can be changed individually under: Advanced > lua parameters.
    If you use Container Hubs, name the hub, don't name the containers, as that will cause issues, also Hub container weight is 0.
    Currently, all containers need to be the same size.
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
    data = {}

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
        if string.match(core.getElementTypeById(elementsIds[i]), "ontainer") and string.match(core.getElementNameById(elementsIds[i]),"Pure") then
            table.insert(containers, newContainer(elementsIds[i]))
        end
    end

    for i = 1, #containers do
        table.insert(data, {Container = containers[i].name, ContainerMass = containers[i].mass})
    end

    function round(number,decimals)
        local power = 10^decimals
        return math.floor((number/1000) * power) / power
    end 

    function Status(percent)
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

    local pureContainerSelfMass = 1280 --export: This is the mass of the container, hubs are 0
    local maxPureContainerVol = 10400 --export: This is the maximum volume allowed in the container. Update as needed
    local Error = "<th style=\"color: red;\">ERROR</th>"

--T1 Stuff

    -- PureAluminum Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Alumin") then
            local weight = 2.70
            massPureAluminum = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureAluminum = math.ceil(((math.ceil((massPureAluminum*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureAluminum = Status(percentPureAluminum)
        end
    end
    if massPureAluminum == nil then
        massPureAluminum = 0
        percentPureAluminum = 0
        statusPureAluminum = Error
    end

    -- PureCarbon Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Carbon") then
            local weight = 2.27
            massPureCarbon = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCarbon = math.ceil(((math.ceil((massPureCarbon*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureCarbon = Status(percentPureCarbon)
        end
    end
    if massPureCarbon == nil then
        massPureCarbon = 0
        percentPureCarbon = 0
        statusPureCarbon = Error
    end

    -- PureIron Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Iron") then
            local weight = 7.85
            massPureIron = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureIron = math.ceil(((math.ceil((massPureIron*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureIron = Status(percentPureIron)
        end
    end
    if massPureIron == nil then
        massPureIron = 0
        percentPureIron = 0
        statusPureIron = Error
    end

    -- Pure Silicon Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Silicon") then
            local weight = 2.33
            massPureSilicon = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSilicon = math.ceil(((math.ceil((massPureSilicon*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureSilicon = Status(percentPureSilicon)
        end
    end
    if massPureSilicon == nil then
        massPureSilicon = 0
        percentPureSilicon = 0
        statusPureSilicon = Error
    end

    -- PureOxygen Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Oxygen") then
            local weight = 1
            massPureOxygen = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureOxygen = math.ceil(((math.ceil((massPureOxygen*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureOxygen = hoStatus(percentPureOxygen)
        end
    end
    if massPureOxygen == nil then
        massPureOxygen = 0
        percentPureOxygen = 0
        statusPureOxygen = Error
    end

    -- PureHydrogen Variables 

    for k, v in pairs(data) do
        if string.match(data[k].Container, "Hydrogen") then
            local weight = 0.07
            massPureHydrogen = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureHydrogen = math.ceil(((math.ceil((massPureHydrogen*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureHydrogen = hoStatus(percentPureHydrogen)
        end
    end
    if massPureHydrogen == nil then
        massPureHydrogen = 0
        percentPureHydrogen = 0
        statusPureHydrogen = "<th style=\"color: red;\">ERROR</th>"
    end

--T2 Stuff

    -- PureCalcium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Calcium") then
            local weight = 1.55
            massPureCalcium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCalcium = math.ceil(((math.ceil((massPureCalcium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureCalcium = Status(percentPureCalcium)
        end
    end
    if massPureCalcium == nil then
        massPureCalcium = 0
        percentPureCalcium = 0
        statusPureCalcium = Error
    end

    -- PureChromium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Chromium") then
            local weight = 7.19
            massPureChromium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureChromium = math.ceil(((math.ceil((massPureChromium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureChromium = Status(percentPureChromium)
        end
    end
    if massPureChromium == nil then
        massPureChromium = 0
        percentPureChromium = 0
        statusPureChromium = Error
    end

    -- PureCopper Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Copper") then
            local weight = 8.96
            massPureCopper = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCopper = math.ceil(((math.ceil((massPureCopper*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureCopper = Status(percentPureCopper)
        end
    end
    if massPureCopper == nil then
        massPureCopper = 0
        percentPureCopper = 0
        statusPureCopper = Error
    end

    -- PureSodium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Sodium") then
            local weight = 0.97
            massPureSodium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSodium = math.ceil(((math.ceil((massPureSodium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureSodium = Status(percentPureSodium)
        end
    end
    if massPureSodium == nil then
        massPureSodium = 0
        percentPureSodium = 0
        statusPureSodium = Error
    end

--T3 Stuff

    -- PureLithium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Lithium") then
            local weight = 0.53
            massPureLithium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureLithium = math.ceil(((math.ceil((massPureLithium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureLithium = Status(percentPureLithium)
        end
    end
    if massPureLithium == nil then
        massPureLithium = 0
        percentPureLithium = 0
        statusPureLithium = Error
    end

    -- PureNickel Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Nickel") then
            local weight = 8.91
            massPureNickel = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureNickel = math.ceil(((math.ceil((massPureNickel*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureNickel = Status(percentPureNickel)
        end
    end
    if massPureNickel == nil then
        massPureNickel = 0
        percentPureNickel = 0
        statusPureNickel = Error
    end

    -- PureSilver Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Silver") then
            local weight = 10.49
            massPureSilver = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSilver = math.ceil(((math.ceil((massPureSilver*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureSilver = Status(percentPureSilver)
        end
    end
    if massPureSilver == nil then
        massPureSilver = 0
        percentPureSilver = 0
        statusPureSilver = Error
    end

    -- Pure Sulfur Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Sulfur") then
            local weight = 1.82
            massPureSulfur = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSulfur = math.ceil(((math.ceil((massPureSulfur*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureSulfur = Status(percentPureSulfur)
        end
    end
    if massPureSulfur == nil then
        massPureSulfur = 0
        percentPureSulfur = 0
        statusPureSulfur = Error
    end

--T4 Stuff

    -- PureCobalt Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Cobalt") then
            local weight = 8.90
            massPureCobalt = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCobalt = math.ceil(((math.ceil((massPureCobalt*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureCobalt = Status(percentPureCobalt)
        end
    end
    if massPureCobalt == nil then
        massPureCobalt = 0
        percentPureCobalt = 0
        statusPureCobalt = Error
    end

    -- PureFluorine Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Fluorine") then
            local weight = 1.70
            massPureFluorine = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureFluorine = math.ceil(((math.ceil((massPureFluorine*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureFluorine = Status(percentPureFluorine)
        end
    end
    if massPureFluorine == nil then
        massPureFluorine = 0
        percentPureFluorine = 0
        statusPureFluorine = Error
    end

    -- PureGold Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Gold") then
            local weight = 19.30
            massPureGold = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureGold = math.ceil(((math.ceil((massPureGold*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureGold = Status(percentPureGold)
        end
    end
    if massPureGold == nil then
        massPureGold = 0
        percentPureGold = 0
        statusPureGold = Error
    end

    -- Pure Scandium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Scandium") then
            local weight = 2.98
            massPureScandium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureScandium = math.ceil(((math.ceil((massPureScandium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureScandium = Status(percentPureScandium)
        end
    end
    if massPureScandium == nil then
        massPureScandium = 0
        percentPureScandium = 0
        statusPureScandium = Error
    end

--T5 Stuff

    -- PureManganese Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Manganese") then
            local weight = 7.21
            massPureManganese = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureManganese = math.ceil(((math.ceil((massManganeseCobalt*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureManganese = Status(percentPureManganese)
        end
    end
    if massPureManganese == nil then
        massPureManganese = 0
        percentPureManganese = 0
        statusPureManganese = Error
    end

    -- PureNiobium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Niobium") then
            local weight = 8.57
            massPureNiobium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureNiobium = math.ceil(((math.ceil((massPureNiobium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureNiobium = Status(percentPureNiobium)
        end
    end
    if massPureNiobium == nil then
        massPureNiobium = 0
        percentPureNiobium = 0
        statusPureNiobium = Error
    end

    -- PureTitanium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Titanium") then
            local weight = 4.51
            massPureTitanium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureTitanium = math.ceil(((math.ceil((massPureTitanium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureTitanium = Status(percentPureTitanium)
        end
    end
    if massPureTitanium == nil then
        massPureTitanium = 0
        percentPureTitanium = 0
        statusPureTitanium = Error
    end

    -- Pure Vanadium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Vanadium") then
            local weight = 6.0
            massPureVanadium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureVanadium = math.ceil(((math.ceil((massPureVanadium*1000) - 0.5)/maxPureContainerVol)*100))
            statusPureVanadium = Status(percentPureVanadium)
        end
    end
    if massPureVanadium == nil then
        massPureVanadium = 0
        percentPureVanadium = 0
        statusPureVanadium = Error
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
                <th>MaxQty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Aluminium</th>
                <th>]]..massPureAluminum..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureAluminum..[[%</th>
                ]]..statusPureAluminum..[[
            </tr>
            <tr>
                <th>Pure Carbon</th>
                <th>]]..massPureCarbon..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureCarbon..[[%</th>
                ]]..statusPureCarbon..[[
            </tr>
            <tr>
                <th>Pure Iron</th>
                <th>]]..massPureIron..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureIron..[[%</th>
                ]]..statusPureIron..[[
            </tr>
            <tr>
                <th>Pure Silicon</th>
                <th>]]..massPureSilicon..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureSilicon..[[%</th>
                ]]..statusPureSilicon..[[
            </tr>
            <tr>
                <th>Pure Hydrogen</th>
                <th>]]..massPureHydrogen..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureHydrogen..[[%</th>
                ]]..statusPureHydrogen..[[
            </tr>
            <tr>
                <th>Pure Oxygen</th>
                <th>]]..massPureOxygen..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
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
                <th>MaxQty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Sodium</th>
                <th>]]..massPureSodium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureSodium..[[%</th>
                ]]..statusPureSodium..[[
            </tr>
            <tr>
                <th>Pure Chromium</th>
                <th>]]..massPureChromium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureChromium..[[%</th>
                ]]..statusPureChromium..[[
            </tr>
            <tr>
                <th>Pure Copper</th>
                <th>]]..massPureCopper..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureCopper..[[%</th>
                ]]..statusPureCopper..[[
            </tr>
            <tr>
                <th>Pure Calcium</th>
                <th>]]..massPureCalcium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
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
                <th>MaxQty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Nickel</th>
                <th>]]..massPureNickel..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureNickel..[[%</th>
                ]]..statusPureNickel..[[
            </tr>
            <tr>
                <th>Pure Lithium</th>
                <th>]]..massPureLithium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureLithium..[[%</th>
                ]]..statusPureLithium..[[
            </tr>
            <tr>
                <th>Pure Sulfur</th>
                <th>]]..massPureSulfur..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureSulfur..[[%</th>
                ]]..statusPureSulfur..[[
            </tr>
            <tr>
                <th>Pure Silver</th>
                <th>]]..massPureSilver..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
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
                <th>MaxQty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Cobalt</th>
                <th>]]..massPureCobalt..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureCobalt..[[%</th>
                ]]..statusPureCobalt..[[
            </tr>
            <tr>
                <th>Pure Fluorine</th>
                <th>]]..massPureFluorine..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureFluorine..[[%</th>
                ]]..statusPureFluorine..[[
            </tr>
            <tr>
                <th>Pure Gold</th>
                <th>]]..massPureGold..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureGold..[[%</th>
                ]]..statusPureGold..[[
            </tr>
            <tr>
                <th>Pure Scandium</th>
                <th>]]..massPureScandium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
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
                <th>MaxQty</th>
                <th>Levels</th>
                <th>Status</th>
            <tr>
                <th>Pure Manganese</th>
                <th>]]..massPureManganese..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureManganese..[[%</th>
                ]]..statusPureManganese..[[
            </tr>
            <tr>
                <th>Pure Niobium</th>
                <th>]]..massPureNiobium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureNiobium..[[%</th>
                ]]..statusPureNiobium..[[
            </tr>
            <tr>
                <th>Pure Titanium</th>
                <th>]]..massPureTitanium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
                <th>]]..percentPureTitanium..[[%</th>
                ]]..statusPureTitanium..[[
            </tr>
            <tr>
                <th>Pure Vanadium</th>
                <th>]]..massPureVanadium..[[KL]]..[[</th>
                <th>]]..maxPureContainerVol/1000 ..[[KL]]..[[</th>
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