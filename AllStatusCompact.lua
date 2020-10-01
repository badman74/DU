--[[
    Status screen display

    This code goes into unit -> start() filter of the programming board

    Make sure you name your screen slot: display1, display2, display3
    Display's can be left off if you dont have any of that tier ie: T5(display3)
    Make sure to link the core, and rename the slot core.
    Make sure to add a tick filter to unit slot, name the tick: updateTable
    In tick lua code, add: generateHtml()
    Add stop filter with lua code, add: displayOff()
    Container Mass, and Volume can be changed individually under: Advanced > lua parameters.
    Containers should be named such as Pure Aluminum and Bauxite Ore to be properly indexed.
    If you use Container Hubs, name the hub, don't name the containers, as that will cause issues, also Hub container weight is 0.
]]

unit.hide()
if display1 then display1.activate() end
if display2 then display2.activate() end
if display3 then display3.activate() end

function displayOff()
    if display1 then display1.clear() end
    if display2 then display2.clear() end
    if display3 then display3.clear() end
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
        if string.match(core.getElementTypeById(elementsIds[i]), "ontainer") and string.match(core.getElementNameById(elementsIds[i]),"Ore") or string.match(core.getElementNameById(elementsIds[i]),"Pure") then
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

    function BarGraph(percent)
        if percent <= 0 then barcolour = "red"
        elseif percent > 0 and percent <=25 then barcolour = "red"
        elseif percent > 25 and percent <= 50 then barcolour = "orange"
        elseif percent > 50 and percent <= 99 then  barcolour = "green"
        else  barcolour = "green"
        end 
        return "<td class=\"bar\" > <svg ><rect x=\"0\" y=\"5\" height=\"30\" width=\"140\" stroke=\"white\" stroke-width=\"1\"  rx=\"4\" /><rect x=\"0\" y=\"5\" height=\"30\" width=\"" .. percent * 1.4 .. "\"  fill=\"" .. barcolour .. "\" opacity=\"0.8\" rx=\"2\"/><text x=\"5\" y=\"30\" fill=\"white\" text-align=\"center\" margin-left=\"5\">" .. percent .. "%</text> </svg></td>"        
    end

    local oreContainerSelfMass = 0 --export: This is the mass of the container, hubs are 0
    local maxOreContainerVol = 166400 --export: This is the maximum volume allowed in the container. Update as needed
    local pureContainerSelfMass = 1280 --export: This is the mass of the container, hubs are 0
    local maxPureContainerVol = 10400 --export: This is the maximum volume allowed in the container. Update as needed
--T1 Stuff
    -- Bauxite Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Bauxite") then
            local weight = 1.28
            massBauxiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentBauxiteOre = math.ceil(((math.ceil((massBauxiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massBauxiteOre == nil then
        massBauxiteOre = 0
        percentBauxite = 0
    end

    -- CoalOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Coal") then
            local weight = 1.35
            massCoalOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentCoalOre = math.ceil(((math.ceil((massCoalOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massCoalOre == nil then
        massCoalOre = 0
        percentCoalOre = 0
    end

    -- HematiteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Hematite") then
            local weight = 5.04
            massHematiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentHematiteOre = math.ceil(((math.ceil((massHematiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massHematiteOre == nil then
        massHematiteOre = 0
        percentHematiteOre = 0
    end

    -- QuartzOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Quartz") then
            local weight = 2.65
            massQuartzOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentQuartzOre = math.ceil(((math.ceil((massQuartzOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massQuartzOre == nil then
        massQuartzOre= 0
        percentQuartzOre = 0
    end

    -- PureAluminum Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Alumin") then
            local weight = 2.70
            massPureAluminum = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureAluminum = math.ceil(((math.ceil((massPureAluminum*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureAluminum == nil then
        massPureAluminum = 0
        percentPureAluminum = 0
    end

    -- PureCarbon Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Carbon") then
            local weight = 2.27
            massPureCarbon = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCarbon = math.ceil(((math.ceil((massPureCarbon*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureCarbon == nil then
        massPureCarbon = 0
        percentPureCarbon = 0
    end

    -- PureIron Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container,"Iron") then
            local weight = 7.85
            massPureIron = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureIron = math.ceil(((math.ceil((massPureIron*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureIron == nil then
        massPureIron = 0
        percentPureIron = 0
    end

    -- PureSilicon Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Silicon") then
            local weight = 2.33
            massPureSilicon = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSilicon = math.ceil(((math.ceil((massPureSilicon*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureSilicon == nil then
        massPureSilicon = 0
        percentPureSilicon = 0
    end

    -- PureOxygen Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Oxygen") then
            local weight = 1
            massPureOxygen = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureOxygen = math.ceil(((math.ceil((massPureOxygen*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureOxygen == nil then
        massPureOxygen = 0
        percentPureOxygen = 0
    end

    -- PureHydrogen Variables 

    for k, v in pairs(data) do
        if string.match(data[k].Container, "Hydrogen") then
            local weight = 0.07
            massPureHydrogen = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureHydrogen = math.ceil(((math.ceil((massPureHydrogen*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureHydrogen == nil then
        massPureHydrogen = 0
        percentPureHydrogen = 0
    end

--T2 Stuff

    -- ChromiteOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Chromite") then
            local weight = 4.54
            massChromiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentChromiteOre = math.ceil(((math.ceil((massChromiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massChromiteOre == nil then
        massChromiteOre = 0
        percentChromiteOre = 0
    end

    -- MalachiteOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Malachite") then
            local weight = 4.00
            massMalachiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentMalachiteOre = math.ceil(((math.ceil((massMalachiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massMalachiteOre == nil then
        massMalachiteOre = 0
        percentMalachiteOre = 0
    end

    -- LimestoneOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Limestone") then
            local weight = 2.71
            massLimestoneOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentLimestoneOre = math.ceil(((math.ceil((massLimestoneOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massLimestoneOre == nil then
        massLimestoneOre = 0
        percentLimestoneOre = 0
    end

    -- NatronOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Natron") then
            local weight = 1.55
            massNatronOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentNatronOre = math.ceil(((math.ceil((massNatronOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massNatronOre == nil then
        massNatronOre = 0
        percentNatronOre = 0
    end

    -- PureCalcium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Calcium") then
            local weight = 1.55
            massPureCalcium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCalcium = math.ceil(((math.ceil((massPureCalcium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureCalcium == nil then
        massPureCalcium = 0
        percentPureCalcium = 0
    end

    -- PureChromium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Chromium") then
            local weight = 7.19
            massPureChromium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureChromium = math.ceil(((math.ceil((massPureChromium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureChromium == nil then
        massPureChromium = 0
        percentPureChromium = 0
    end

    -- PureCopper Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Copper") then
            local weight = 8.96
            massPureCopper = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCopper = math.ceil(((math.ceil((massPureCopper*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureCopper == nil then
        massPureCopper = 0
        percentPureCopper = 0
    end

    -- PureSodium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Sodium") then
            local weight = 0.97
            massPureSodium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSodium = math.ceil(((math.ceil((massPureSodium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureSodium == nil then
        massPureSodium = 0
        percentPureSodium = 0
    end

--T3 Stuff

    -- GarnieriteOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Garnierite") then
            local weight = 2.60
            massGarnieriteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentGarnieriteOre = math.ceil(((math.ceil((massGarnieriteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massGarnieriteOre == nil then
        massGarnieriteOre = 0
        percentGarnieriteOre = 0
    end

    -- PetaliteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Petalite") then
            local weight = 2.41
            massPetaliteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentPetaliteOre = math.ceil(((math.ceil((massPetaliteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massPetaliteOre == nil then
        massPetaliteOre = 0
        percentPetaliteOre = 0
    end

    -- AcanthiteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Acanthite") then
            local weight = 7.20
            massAcanthiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentAcanthiteOre = math.ceil(((math.ceil((massAcanthiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massAcanthiteOre == nil then
        massAcanthiteOre = 0
        percentAcanthiteOre = 0
    end

    -- PyriteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Pyrite") then
            local weight = 5.01
            massPyriteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentPyriteOre = math.ceil(((math.ceil((massPyriteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massPyriteOre == nil then
        massPyriteOre = 0
        percentPyriteOre = 0
    end

    -- PureLithium Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Lithium") then
            local weight = 0.53
            massPureLithium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureLithium = math.ceil(((math.ceil((massPureLithium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureLithium == nil then
        massPureLithium = 0
        percentPureLithium = 0
    end

    -- PureNickel Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Nickel") then
            local weight = 8.91
            massPureNickel = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureNickel = math.ceil(((math.ceil((massPureNickel*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureNickel == nil then
        massPureNickel = 0
        percentPureNickel = 0
    end

    -- PureSilver Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Silver") then
            local weight = 10.49
            massPureSilver = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSilver = math.ceil(((math.ceil((massPureSilver*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureSilver == nil then
        massPureSilver = 0
        percentPureSilver = 0
    end

    -- Pure Sulfur Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Sulfur") then
            local weight = 1.82
            massPureSulfur = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureSulfur = math.ceil(((math.ceil((massPureSulfur*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureSulfur == nil then
        massPureSulfur = 0
        percentPureSulfur = 0
    end

--T4 Stuff

    -- CobaltiteOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Cobaltite") then
            local weight = 6.33
            massCobaltiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentCobaltiteOre = math.ceil(((math.ceil((massCobaltiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massCobaltiteOre == nil then
        massCobaltiteOre = 0
        percentCobaltiteOre = 0
    end

    -- CryoliteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Cryolite") then
            local weight = 2.95
            massCryoliteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentCryoliteOre = math.ceil(((math.ceil((massCryoliteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massCryoliteOre == nil then
        massCryoliteOre = 0
        percentCryoliteOre = 0
    end

    -- GoldOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Gold Ore") then
            local weight = 19.30
            massGoldOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentGoldOre = math.ceil(((math.ceil((massGoldOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massGoldOre == nil then
        massGoldOre = 0
        percentGoldOre = 0
    end

    -- KolbeckiteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Kolbeckite") then
            local weight = 2.37
            massKolbeckiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentKolbeckiteOre = math.ceil(((math.ceil((massKolbeckiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massKolbeckiteOre == nil then
        massKolbeckiteOre = 0
        percentKolbeckiteOre = 0
    end

    -- PureCobalt Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Pure Cobalt") then
            local weight = 8.90
            massPureCobalt = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureCobalt = math.ceil(((math.ceil((massPureCobalt*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureCobalt == nil then
        massPureCobalt = 0
        percentPureCobalt = 0
    end

    -- PureFluorine Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Fluorine") then
            local weight = 1.70
            massPureFluorine = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureFluorine = math.ceil(((math.ceil((massPureFluorine*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureFluorine == nil then
        massPureFluorine = 0
        percentPureFluorine = 0
    end

    -- PureGold Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Pure Gold") then
            local weight = 19.30
            massPureGold = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureGold = math.ceil(((math.ceil((massPureGold*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureGold == nil then
        massPureGold = 0
        percentPureGold = 0
    end

    -- Pure Scandium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Scandium") then
            local weight = 2.98
            massPureScandium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureScandium = math.ceil(((math.ceil((massPureScandium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureScandium == nil then
        massPureScandium = 0
        percentPureScandium = 0
    end

--T5 Stuff

    -- RhodoniteOre Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Rhodonite") then
            local weight = 3.76
            massRhodoniteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentRhodoniteOre = math.ceil(((math.ceil((massRhodoniteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massRhodoniteOre == nil then
        massRhodoniteOre = 0
        percentRhodoniteOre = 0
    end

    -- ColumbiteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Columbite") then
            local weight = 5.38
            massColumbiteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentColumbiteOre = math.ceil(((math.ceil((massColumbiteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massColumbiteOre == nil then
        massColumbiteOre = 0
        percentColumbiteOre = 0
    end

    -- IllmeniteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Illmenite") then
            local weight = 4.55
            massIllmeniteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentIllmeniteOre = math.ceil(((math.ceil((massIllmeniteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massIllmeniteOre == nil then
        massIllmeniteOre = 0
        percentIllmeniteOre = 0
    end

    -- VanadiniteOre Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Vanadinite") then
            local weight = 6.95
            massVanadiniteOre = round(math.ceil((data[k].ContainerMass - oreContainerSelfMass) / weight),1)
            percentVanadiniteOre = math.ceil(((math.ceil((massVanadiniteOre*1000) - 0.5)/maxOreContainerVol)*100))
        end
    end
    if massVanadiniteOre == nil then
        massVanadiniteOre = 0
        percentVanadiniteOre = 0
    end

    -- PureManganese Variables 
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Manganese") then
            local weight = 7.21
            massPureManganese = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureManganese = math.ceil(((math.ceil((massManganeseCobalt*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureManganese == nil then
        massPureManganese = 0
        percentPureManganese = 0
    end

    -- PureNiobium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Niobium") then
            local weight = 8.57
            massPureNiobium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureNiobium = math.ceil(((math.ceil((massPureNiobium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureNiobium == nil then
        massPureNiobium = 0
        percentPureNiobium = 0
    end

    -- PureTitanium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Titanium") then
            local weight = 4.51
            massPureTitanium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureTitanium = math.ceil(((math.ceil((massPureTitanium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureTitanium == nil then
        massPureTitanium = 0
        percentPureTitanium = 0
    end

    -- Pure Vanadium Variables
    for k, v in pairs(data) do
        if string.match(data[k].Container, "Vanadium") then
            local weight = 6.0
            massPureVanadium = round(math.ceil((data[k].ContainerMass - pureContainerSelfMass) / weight),1)
            percentPureVanadium = math.ceil(((math.ceil((massPureVanadium*1000) - 0.5)/maxPureContainerVol)*100))
        end
    end
    if massPureVanadium == nil then
        massPureVanadium = 0
        percentPureVanadium = 0
    end

    maxOCV = maxOreContainerVol/1000
    maxPCV = maxPureContainerVol/1000

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
            <div class="bootstrap">]]
    d2 = [[<h1 style="font-size: 6em;">]]
    t1 = [[</h1>
        <table style="
            text-transform: capitalize;
            font-size: 3em;
            table-layout: auto;
            width: 99%;
        ">
        </br>
        <tr style="
            width:100%;
            background-color: blue;
            color: white;
        ">]]
    t2 = [[
            <th>Type</th>
            <th>Qty</th>
            <th>Levels</th>
            <th>Type</th>
            <th>Qty</th>
            <th>Levels</th>
        </tr>
        ]]
    c1 = [[
            </table>
            </div>
         ]]

    if display1 then
        html = d1..d2..[[T1 Basic Status]]..t1..t2..
            [[<tr>
                <th>Bauxite</th>
                <th>]]..massBauxiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentBauxiteOre)..[[
                <th>Aluminium</th>
                <th>]]..massPureAluminum..[[KL]]..[[</th>
                ]]..BarGraph(percentPureAluminum)..[[
            </tr>
            <tr>
                <th>Coal</th>
                <th>]]..massCoalOre..[[KL]]..[[</th>
                ]]..BarGraph(percentCoalOre)..[[
                <th>Carbon</th>
                <th>]]..massPureCarbon..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCarbon)..[[
            </tr>
            <tr>
                <th>Hematite</th>
                <th>]]..massHematiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentHematiteOre)..[[
                <th>Iron</th>
                <th>]]..massPureIron..[[KL]]..[[</th>
                ]]..BarGraph(percentPureIron)..[[
            </tr>
            <tr>
                <th>Quartz</th>
                <th>]]..massQuartzOre..[[KL]]..[[</th>
                ]]..BarGraph(percentQuartzOre)..[[
                <th>Silicon</th>
                <th>]]..massPureSilicon..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSilicon)..[[
            </tr>
            <tr>
                <th>Hydrogen</th>
                <th>]]..massPureHydrogen..[[KL]]..[[</th>
                ]]..BarGraph(percentPureHydrogen)..[[
                <th>Oxygen</th>
                <th>]]..massPureOxygen..[[KL]]..[[</th>
                ]]..BarGraph(percentPureOxygen)..[[
            </tr>
            ]]..t1..d2..[[T2 Uncommon Status]]..t1..t2..[[
            <tr>
                <th>Natron</th>
                <th>]]..massNatronOre..[[KL]]..[[</th>
                ]]..BarGraph(percentNatronOre)..[[
                <th>Sodium</th>
                <th>]]..massPureSodium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSodium)..[[
            </tr>
            <tr>
                <th>Malachite</th>
                <th>]]..massMalachiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentMalachiteOre)..[[
                <th>Copper</th>
                <th>]]..massPureCopper..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCopper)..[[
            </tr>
            <tr>
                <th>Limestone</th>
                <th>]]..massLimestoneOre..[[KL]]..[[</th>
                ]]..BarGraph(percentLimestoneOre)..[[
                <th>Calcium</th>
                <th>]]..massPureCalcium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCalcium)..[[
            </tr>
            <tr>
                <th>Chromite</th>
                <th>]]..massChromiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentChromiteOre)..[[
                <th>Chromium</th>
                <th>]]..massPureChromium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureChromium)..
                c1
        display1.setHTML(html)
    end

    if display2 then
        html = d1..d2..[[T3 Advanced Status]]..t1..t2..
            [[<tr>
                <th>Petalite</th>
                <th>]]..massPetaliteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentPetaliteOre)..[[
                <th>Lithium</th>
                <th>]]..massPureLithium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureLithium)..[[
            </tr>
            <tr>
                <th>Garnierite</th>
                <th>]]..massGarnieriteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentGarnieriteOre)..[[
                <th>Nickel</th>
                <th>]]..massPureNickel..[[KL]]..[[</th>
                ]]..BarGraph(percentPureNickel)..[[
            </tr>
            <tr>
                <th>Pyrite</th>
                <th>]]..massPyriteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentPyriteOre)..[[
                <th>Sulfur</th>
                <th>]]..massPureSulfur..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSulfur)..[[
            </tr>
            <tr>
                <th>Acanthite</th>
                <th>]]..massAcanthiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentAcanthiteOre)..[[
                <th>Silver</th>
                <th>]]..massPureSilver..[[KL]]..[[</th>
                ]]..BarGraph(percentPureSilver)..[[
            </tr>
            ]]..t1..d2..[[T4 Rare Status]]..t1..t2..[[
            <tr>
                <th>Cobaltite</th>
                <th>]]..massCobaltiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentCobaltiteOre)..[[
                <th>Cobalt</th>
                <th>]]..massPureCobalt..[[KL]]..[[</th>
                ]]..BarGraph(percentPureCobalt)..[[
            </tr>
            <tr>
                <th>Cryolite</th>
                <th>]]..massCryoliteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentCryoliteOre)..[[
                <th>Fluorine</th>
                <th>]]..massPureFluorine..[[KL]]..[[</th>
                ]]..BarGraph(percentPureFluorine)..[[
            </tr>
            <tr>
                <th>Gold Nuggets</th>
                <th>]]..massGoldOre..[[KL]]..[[</th>
                ]]..BarGraph(percentGoldOre)..[[
                <th>Gold</th>
                <th>]]..massPureGold..[[KL]]..[[</th>
                ]]..BarGraph(percentPureGold)..[[
            </tr>
            <tr>
                <th>Kolbeckite</th>
                <th>]]..massKolbeckiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentKolbeckiteOre)..[[
                <th>Scandium</th>
                <th>]]..massPureScandium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureScandium)..
                c1
        display2.setHTML(html)
    end

    if display3 then
        html = d1..d2..[[T5 Exotic Status]]..t1..t2..[[
            <tr>
                <th>Rhodonite</th>
                <th>]]..massRhodoniteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentRhodoniteOre)..[[
                <th>Manganese</th>
                <th>]]..massPureManganese..[[KL]]..[[</th>
                ]]..BarGraph(percentPureManganese)..[[
            </tr>
            <tr>
                <th>Columbite</th>
                <th>]]..massColumbiteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentColumbiteOre)..[[
                <th>Niobium</th>
                <th>]]..massPureNiobium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureNiobium)..[[
            </tr>
            <tr>
                <th>Illmenite</th>
                <th>]]..massIllmeniteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentIllmeniteOre)..[[
                <th>Titanium</th>
                <th>]]..massPureTitanium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureTitanium)..[[
            </tr>
            <tr>
                <th>Vanadinite</th>
                <th>]]..massVanadiniteOre..[[KL]]..[[</th>
                ]]..BarGraph(percentVanadiniteOre)..[[
                <th>Vanadium</th>
                <th>]]..massPureVanadium..[[KL]]..[[</th>
                ]]..BarGraph(percentPureVanadium)..
                c1
        display3.setHTML(html)
    end
end
unit.setTimer('updateTable', 1)