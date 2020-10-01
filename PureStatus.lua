--[[
    Status screen display

    This code goes into unit -> start() filter of the programming board

    Make sure you name your screen slot: displayT1, displayT2, displayT3, displayT4, displayT5
    Make sure to link the core, and rename the slot core.
    Make sure to add a tick filter to unit slot, name the tick: updateTable
    In tick lua code, add: generateHtml()
    Add stop filter with lua code, add: displayOff()
    If you don't have a tier of containers, leave off the corresponding display.
    Container Mass, and Volume are now autocalculated, ecxept for hubs.
    Enter your Hub Volume, Container Proficiency % and Container Optimization % (without the -) in advanced > lua parameters.
    Containers should be named such as Pure Aluminum and Bauxite Ore to be properly indexed.
    If you use Container Hubs, name the hub, don't name the containers, as that will cause issues.
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
            maxHp = core.getElementMaxHitPointsById(_id);
        }
        return container
    end


    for i = 1, #elementsIds do
        if string.match(core.getElementTypeById(elementsIds[i]), "ontainer") and string.match(core.getElementNameById(elementsIds[i]),"Pure") then
            table.insert(containers, newContainer(elementsIds[i]))
        end
    end

    for i = 1, #containers do
        table.insert(data, {Container = containers[i].name, ContainerMass = containers[i].mass, maxHp = containers[i].maxHp})
    end

    function round(number,decimals)
        local power = 10^decimals
        return math.floor((number/1000) * power) / power
    end 

    function ContainerMaxVol(hp)
        if hp > 49 and hp <=123 then vol = hub
        elseif hp > 123 and hp <= 998 then vol = (1000+(1000*(containerProficiency/100)))
        elseif hp > 998 and hp <= 7996 then vol = (8000+(8000*(containerProficiency/100)))
        elseif hp > 7996 and hp <= 17315 then vol = (64000+(64000*(containerProficiency/100)))
        elseif hp > 17315 then vol = (128000+(128000*(containerProficiency/100)))
        end
        return vol
    end

    function ContainerSelfMass(hp)
        if hp > 49 and hp <=123 then sm = 0
        elseif hp > 123 and hp <= 998 then sm = 229.09
        elseif hp > 998 and hp <= 7996 then sm = 1280
        elseif hp > 7996 and hp <= 17315 then sm = 7420
        elseif hp > 17315 then sm = 14840
        end
        return sm
    end

    function OptimizedContainerMass(mass)
        oMass = (mass+(mass*(containerOptimization/100)))
        return oMass
    end

    function Status(percent)
        if percent <= 0 then return "<th style=\"color: red;\">EMPTY</th>"
        elseif percent > 0 and percent <=25 then return "<th style=\"color: red;\">LOW</th>"
        elseif percent > 25 and percent <= 50 then return "<th style=\"color: orange;\">LOW</th>"
        elseif percent > 50 and percent <= 99 then return "<th style=\"color: green;\">GOOD</th>"
        else return "<th style=\"color: green;\">FULL</th>"
        end 
    end

    function hoStatus(percent)
        if percent <= 10 then return "<th style=\"color: orange;\">LOW</th>"
        elseif percent > 10 and percent < 70 then return "<th style=\"color: green;\">GOOD</th>"
        else return "<th style=\"color: red;\">PLEASE EMPTY</th>"
        end 
    end

    function BarGraph(percent)
        if percent <= 0 then barcolour = "red"
        elseif percent > 0 and percent <=25 then barcolour = "red"
        elseif percent > 25 and percent <= 50 then barcolour = "orange"
        elseif percent > 50 and percent <= 99 then  barcolour = "green"
        else  barcolour = "green"
        end 
        return "<td class=\"bar\" > <svg ><rect x=\"0\" y=\"5\" height=\"30\" width=\"140\" stroke=\"white\" stroke-width=\"1\"  rx=\"4\" /><rect x=\"0\" y=\"5\" height=\"30\" width=\"" .. percent * 1.4 .. "\"  fill=\"" .. barcolour .. "\" opacity=\"0.8\" rx=\"2\"/><text x=\"5\" y=\"30\" fill=\"white\" text-align=\"center\" margin-left=\"5\">" .. percent .. "%</text> </svg></td>"        
    end

    hub = 166400 --export: This is the total volume of your hub, at present, all hubs need to be the same
    containerProficiency = 30 --export: This is the % voume increase of your Container Proficiency talent
    containerOptimization = 0 --export: This is the % mass decrease of your Container Optimization talent
    local Error = "<th style=\"color: red;\">ERROR</th>"

--T1 Stuff

    -- PureAluminum Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Alumin") then
            local weight = 2.70
            massPureAluminum = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureAluminum = math.ceil(((math.ceil((massPureAluminum*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureAluminum = Status(percentPureAluminum)
            maxVolPureAluminum = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureAluminum == nil then
        massPureAluminum = 0
        percentPureAluminum = 0
        statusPureAluminum = Error
        maxVolPureAluminum = 0
    end

    -- PureCarbon Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Carbon") then
            local weight = 2.27
            massPureCarbon = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureCarbon = math.ceil(((math.ceil((massPureCarbon*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureCarbon = Status(percentPureCarbon)
            maxVolPureCarbon = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureCarbon == nil then
        massPureCarbon = 0
        percentPureCarbon = 0
        statusPureCarbon = Error
        maxVolPureCarbon = 0
    end

    -- PureIron Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Iron") then
            local weight = 7.85
            massPureIron = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureIron = math.ceil(((math.ceil((massPureIron*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureIron = Status(percentPureIron)
            maxVolPureIron = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureIron == nil then
        massPureIron = 0
        percentPureIron = 0
        statusPureIron = Error
        maxVolPureIron = 0
    end

    -- PureSilicon Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Silicon") then
            local weight = 2.33
            massPureSilicon = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureSilicon = math.ceil(((math.ceil((massPureSilicon*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureSilicon = Status(percentPureSilicon)
            maxVolPureSilicon = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureSilicon == nil then
        massPureSilicon = 0
        percentPureSilicon = 0
        statusPureSilicon = Error
        maxVolPureSilicon = 0
    end

    -- PureOxygen Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Oxygen") then
            local weight = 1
            massPureOxygen = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureOxygen = math.ceil(((math.ceil((massPureOxygen*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureOxygen = hoStatus(percentPureOxygen)
            maxVolPureOxygen = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureOxygen == nil then
        massPureOxygen = 0
        percentPureOxygen = 0
        statusPureOxygen = Error
        maxVolPureOxygen = 0
    end

    -- PureHydrogen Variables 

    for k, v in pairs(data) do
        if string.match(data[k].Container, "Hydrogen") then
            local weight = 0.07
            massPureHydrogen = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureHydrogen = math.ceil(((math.ceil((massPureHydrogen*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureHydrogen = hoStatus(percentPureHydrogen)
            maxVolPureHydrogen = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureHydrogen == nil then
        massPureHydrogen = 0
        percentPureHydrogen = 0
        statusPureHydrogen = Error
        maxVolPureHydrogen = 0
    end

--T2 Stuff

    -- PureCalcium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Calcium") then
            local weight = 1.55
            massPureCalcium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureCalcium = math.ceil(((math.ceil((massPureCalcium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureCalcium = Status(percentPureCalcium)
            maxVolPureCalcium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureCalcium == nil then
        massPureCalcium = 0
        percentPureCalcium = 0
        statusPureCalcium = Error
        maxVolPureCalcium = 0
    end

    -- PureChromium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Chromium") then
            local weight = 7.19
            massPureChromium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureChromium = math.ceil(((math.ceil((massPureChromium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureChromium = Status(percentPureChromium)
            maxVolPureChromium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureChromium == nil then
        massPureChromium = 0
        percentPureChromium = 0
        statusPureChromium = Error
        maxVolPureChromium = 0
    end

    -- PureCopper Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Copper") then
            local weight = 8.96
            massPureCopper = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureCopper = math.ceil(((math.ceil((massPureCopper*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureCopper = Status(percentPureCopper)
            maxVolPureCopper = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureCopper == nil then
        massPureCopper = 0
        percentPureCopper = 0
        statusPureCopper = Error
        maxVolPureCopper = 0
    end

    -- PureSodium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Sodium") then
            local weight = 0.97
            massPureSodium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureSodium = math.ceil(((math.ceil((massPureSodium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureSodium = Status(percentPureSodium)
            maxVolPureSodium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureSodium == nil then
        massPureSodium = 0
        percentPureSodium = 0
        statusPureSodium = Error
        maxVolPureSodium = 0
    end

--T3 Stuff

    -- PureLithium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Lithium") then
            local weight = 0.53
            massPureLithium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureLithium = math.ceil(((math.ceil((massPureLithium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureLithium = Status(percentPureLithium)
            maxVolPureLithium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureLithium == nil then
        massPureLithium = 0
        percentPureLithium = 0
        statusPureLithium = Error
        maxVolPureLithium = 0
    end

    -- PureNickel Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Nickel") then
            local weight = 8.91
            massPureNickel = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureNickel = math.ceil(((math.ceil((massPureNickel*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureNickel = Status(percentPureNickel)
            maxVolPureNickel = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureNickel == nil then
        massPureNickel = 0
        percentPureNickel = 0
        statusPureNickel = Error
        maxVolPureNickel = 0
    end

    -- PureSilver Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Silver") then
            local weight = 10.49
            massPureSilver = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureSilver = math.ceil(((math.ceil((massPureSilver*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureSilver = Status(percentPureSilver)
            maxVolPureSilver = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureSilver == nil then
        massPureSilver = 0
        percentPureSilver = 0
        statusPureSilver = Error
        maxVolPureSilver = 0
    end

    -- Pure Sulfur Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Sulfur") then
            local weight = 1.82
            massPureSulfur = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureSulfur = math.ceil(((math.ceil((massPureSulfur*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureSulfur = Status(percentPureSulfur)
            maxVolPureSulfur = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureSulfur == nil then
        massPureSulfur = 0
        percentPureSulfur = 0
        statusPureSulfur = Error
        maxVolPureSulfur = 0
    end

--T4 Stuff

    -- PureCobalt Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Pure Cobalt") then
            local weight = 8.90
            massPureCobalt = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureCobalt = math.ceil(((math.ceil((massPureCobalt*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureCobalt = Status(percentPureCobalt)
            maxVolPureCobalt = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureCobalt == nil then
        massPureCobalt = 0
        percentPureCobalt = 0
        statusPureCobalt = Error
        maxVolPureCobalt = 0
    end

    -- PureFluorine Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Fluorine") then
            local weight = 1.70
            massPureFluorine = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureFluorine = math.ceil(((math.ceil((massPureFluorine*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureFluorine = Status(percentPureFluorine)
            maxVolPureFluorine = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureFluorine == nil then
        massPureFluorine = 0
        percentPureFluorine = 0
        statusPureFluorine = Error
        maxVolPureFluorine = 0
    end

    -- PureGold Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Pure Gold") then
            local weight = 19.30
            massPureGold = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureGold = math.ceil(((math.ceil((massPureGold*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureGold = Status(percentPureGold)
            maxVolPureGold = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureGold == nil then
        massPureGold = 0
        percentPureGold = 0
        statusPureGold = Error
        maxVolPureGold = 0
    end

    -- Pure Scandium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Scandium") then
            local weight = 2.98
            massPureScandium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureScandium = math.ceil(((math.ceil((massPureScandium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureScandium = Status(percentPureScandium)
            maxVolPureScandium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureScandium == nil then
        massPureScandium = 0
        percentPureScandium = 0
        statusPureScandium = Error
        maxVolPureScandium = 0
    end

--T5 Stuff

    -- PureManganese Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Manganese") then
            local weight = 7.21
            massPureManganese = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureManganese = math.ceil(((math.ceil((massManganeseCobalt*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureManganese = Status(percentPureManganese)
            maxVolPureManganese = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureManganese == nil then
        massPureManganese = 0
        percentPureManganese = 0
        statusPureManganese = Error
        maxVolPureManganese = 0
    end

    -- PureNiobium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Niobium") then
            local weight = 8.57
            massPureNiobium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureNiobium = math.ceil(((math.ceil((massPureNiobium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureNiobium = Status(percentPureNiobium)
            maxVolPureNiobium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureNiobium == nil then
        massPureNiobium = 0
        percentPureNiobium = 0
        statusPureNiobium = Error
        maxVolPureNiobium = 0
    end

    -- PureTitanium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Titanium") then
            local weight = 4.51
            massPureTitanium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureTitanium = math.ceil(((math.ceil((massPureTitanium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureTitanium = Status(percentPureTitanium)
            maxVolPureTitanium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureTitanium == nil then
        massPureTitanium = 0
        percentPureTitanium = 0
        statusPureTitanium = Error
        maxVolPureTitanium = 0
    end

    -- Pure Vanadium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Vanadium") then
            local weight = 6.0
            massPureVanadium = round(math.ceil((OptimizedContainerMass(data[k].ContainerMass) - ContainerSelfMass(data[k].maxHp)) / weight),1)
            percentPureVanadium = math.ceil(((math.ceil((massPureVanadium*1000) - 0.5)/(ContainerMaxVol(data[k].maxHp)))*100))
            statusPureVanadium = Status(percentPureVanadium)
            maxVolPureVandium = (ContainerMaxVol(data[k].maxHp))/1000
        end
    end
    if massPureVanadium == nil then
        massPureVanadium = 0
        percentPureVanadium = 0
        statusPureVanadium = Error
        maxVolPureVandium = 0
    end


    d1 = [[
            <head>
                <style>
                    .bar{
                        text-align: left;
                        vertical-align: top;
                        border-radius: 0 3px 3px 0;
                        }
                    }
                </style>
            </head>
            <div class="bootstrap">
            <h1 style="font-size: 6em;">]]
    t1 = [[</h1>
        <table style="
            text-transform: capitalize;
            font-size: 3em;
            table-layout: auto;
            width: 100%;
        ">
        </br>
        <tr style="
            width:100%;
            background-color: blue;
            color: white;
        ">
            <th>Type</th>
            <th>Qty</th>
            <th>MaxQty</th>
            <th>Levels</th>
            <th>Status</th>
        </tr>
        ]]
    c1 = [[
            </table>
            </div>
         ]]

    if displayT1 then
        html = d1..[[T1 Basic Status]]..t1..
            [[<tr>
                <th>Aluminium</th>
                <th>]]..massPureAluminum..[[KL]]..[[</th>
                <th>]]..maxVolPureAluminum ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureAluminum)..[[%
                ]]..statusPureAluminum..[[
            </tr>
            <tr>
                <th>Carbon</th>
                <th>]]..massPureCarbon..[[KL]]..[[</th>
                <th>]]..maxVolPureCarbon ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCarbon)..[[%
                ]]..statusPureCarbon..[[
            </tr>
            <tr>
                <th>Iron</th>
                <th>]]..massPureIron..[[KL]]..[[</th>
                <th>]]..maxVolPureIron ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureIron)..[[%
                ]]..statusPureIron..[[
            </tr>
            <tr>
                <th>Silicon</th>
                <th>]]..massPureSilicon..[[KL]]..[[</th>
                <th>]]..maxVolPureSilicon ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSilicon)..[[%
                ]]..statusPureSilicon..[[
            </tr>
            <tr>
                <th>Hydrogen</th>
                <th>]]..massPureHydrogen..[[KL]]..[[</th>
                <th>]]..maxVolPureHydrogen ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureHydrogen)..[[%
                ]]..statusPureHydrogen..[[
            </tr>
            <tr>
                <th>Oxygen</th>
                <th>]]..massPureOxygen..[[KL]]..[[</th>
                <th>]]..maxVolPureOxygen ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureOxygen)..[[%
                ]]..statusPureOxygen..
                c1
        displayT1.setHTML(html)
    end

    if displayT2 then
        html = d1..[[T2 Uncommon Status]]..t1..
            [[<tr>
                <th>Sodium</th>
                <th>]]..massPureSodium..[[KL]]..[[</th>
                <th>]]..maxVolPureSodium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSodium)..[[%
                ]]..statusPureSodium..[[
            </tr>
            <tr>
                <th>Copper</th>
                <th>]]..massPureCopper..[[KL]]..[[</th>
                <th>]]..maxVolPureCopper ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCopper)..[[%
                ]]..statusPureCopper..[[
            </tr>
            </tr>
                <th>Calcium</th>
                <th>]]..massPureCalcium..[[KL]]..[[</th>
                <th>]]..maxVolPureCalcium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCalcium)..[[%
                ]]..statusPureCalcium..[[
            </tr>
            <th>Chromium</th>
                <th>]]..massPureChromium..[[KL]]..[[</th>
                <th>]]..maxVolPureChromium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureChromium)..[[%
                ]]..statusPureChromium..
                c1
        displayT2.setHTML(html)
    end

    if displayT3 then
        html = d1..[[T3 Advanced Status]]..t1..
            [[<tr>
                <th>Lithium</th>
                <th>]]..massPureLithium..[[KL]]..[[</th>
                <th>]]..maxVolPureLithium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureLithium)..[[%
                ]]..statusPureLithium..[[
            </tr>
            <tr>
                <th>Nickel</th>
                <th>]]..massPureNickel..[[KL]]..[[</th>
                <th>]]..maxVolPureNickel ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureNickel)..[[%
                ]]..statusPureNickel..[[
            </tr>
            <tr>
                <th>Sulfur</th>
                <th>]]..massPureSulfur..[[KL]]..[[</th>
                <th>]]..maxVolPureSulfur ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSulfur)..[[%
                ]]..statusPureSulfur..[[
            </tr>
            <tr>
                <th>Silver</th>
                <th>]]..massPureSilver..[[KL]]..[[</th>
                <th>]]..maxVolPureSilver ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSilver)..[[%
                ]]..statusPureSilver..
                c1
        displayT3.setHTML(html)
    end

    if displayT4 then
        html = d1..[[T4 Rare Status]]..t1..
            [[<tr>
                <th>Cobalt</th>
                <th>]]..massPureCobalt..[[KL]]..[[</th>
                <th>]]..maxVolPureCobalt ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCobalt)..[[%
                ]]..statusPureCobalt..[[
            </tr>
            <tr>
                <th>Fluorine</th>
                <th>]]..massPureFluorine..[[KL]]..[[</th>
                <th>]]..maxVolPureFluorine ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureFluorine)..[[%
                ]]..statusPureFluorine..[[
            </tr>
            <tr>
                <th>Gold</th>
                <th>]]..massPureGold..[[KL]]..[[</th>
                <th>]]..maxVolPureGold ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureGold)..[[%
                ]]..statusPureGold..[[
            </tr>
            <tr>
                <th>Scandium</th>
                <th>]]..massPureScandium..[[KL]]..[[</th>
                <th>]]..maxVolPureScandium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureScandium)..[[%
                ]]..statusPureScandium..
                c1
        displayT4.setHTML(html)
    end

    if displayT5 then
        html = d1..[[T5 Exotic Status]]..t1..
            [[<tr>
                <th>Manganese</th>
                <th>]]..massPureManganese..[[KL]]..[[</th>
                <th>]]..maxVolPureManganese ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureManganese)..[[%
                ]]..statusPureManganese..[[
            </tr>
            <tr>
                <th>Niobium</th>
                <th>]]..massPureNiobium..[[KL]]..[[</th>
                <th>]]..maxVolPureNiobium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureNiobium)..[[%
                ]]..statusPureNiobium..[[
            </tr>
            <tr>
                <th>Titanium</th>
                <th>]]..massPureTitanium..[[KL]]..[[</th>
                <th>]]..maxVolPureTitanium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureTitanium)..[[%
                ]]..statusPureTitanium..[[
            </tr>
            <tr>
                <th>Vanadium</th>
                <th>]]..massPureVanadium..[[KL]]..[[</th>
                <th>]]..maxVolPureVandium ..[[KL]]..[[</th>
                ]]..BarGraph(percentPureVanadium)..[[%
                ]]..statusPureVanadium..
                c1
        displayT5.setHTML(html)
    end
end
unit.setTimer('updateTable', 1)