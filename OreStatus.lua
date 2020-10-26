--[[
    Ore Status Display

    Refactored thanks to Dorian Gray

    1. Copy & paste this script into your Programming Board, into slot "unit" and filter "start()"
    2. Add a "stop()" filter and enter "display1.clear()" into the Lua editor for this filter
    3. Add a "tick()" filter and enter the parameter "updateTick, so "tick(updateTick)". In the Lua editor for the filter enter "processTick()"
    4. Link the core this setup is placed on to your Programming Board and rename the slot to "core"
    5. Link 1 screen to your Programming Board, preferably S or larger, and name the slot "display1"
    6. Rename your ore storage boxes you want this script to observe. Ores must be named "<orename> Ore", e.g. "Bauxite Ore". Any wrongly named container will not be observed.You can rename the searchString under Advanced->Edit Lua Parameters, You MUST include spaces not in the actual substance name. You can have more than one container for a single substance, if you have e.g. three large containers for Hematite, name all of them "Hematite Ore". The script does not support multiple substances in one container.
    7. On your Programming Board choose Advanced->Edit Lua Parameters and enter your Container Proficiency Bonus in percent (0 to 50) and your Container Optimization Bonus in percent (0-25)
    8. Activate the Programming Board.
]]

unit.hide()

display1.activate()


function round(number,decimals)
    local power = 10^decimals
    return math.floor((number/1000) * power) / power
end 

PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
MinimumYellowPercent = 25 --export At which percent level do you want bars to be drawn in yellow (not red anymore)
MinimumGreenPercent = 50 --export At which percent level do you want bars to be drawn in green (not yellow anymore)
searchString = " Ore" --export Your identifier for Ore Storage Containers (e.g. "Bauxite Ore"). Include the spaces if you change this!
headerFontSize = 3 --export Header font-size in em
fontSize = 2.4 --export font-size in em
font = "monospace" --export

function processTick()

    elementsIds = core.getElementIdList()
    outputData = {}

     substanceMass = {
        Bauxite=1.2808;
        Coal=1.3465;
        Quartz=2.6498;
        Hematite=5.0398;
        Chromite=4.54;
        Malachite=3.9997;
        Limestone=2.7105;
        Natron=1.5499;
        Petalite=2.4119;
        Garnierite=2.6;
        Acanthite=7.1995;
        Pyrite=5.0098;
        Cobaltite=6.33;
        Cryolite=2.9495;
        Kolbeckite=2.37;
        GoldNuggets=19.3;
        Rhodonite=3.76;
        Columbite=5.38;
        Illmenite=4.55;
        Vanadinite=6.95;
    }

    function processSubstanceContainer(_id)
        local ContainerName = core.getElementNameById(_id)
        local ContainerTotalMass = core.getElementMassById(_id)
        local ContainerMaxHP = core.getElementMaxHitPointsById(_id)
        SubstanceName=string.gsub(ContainerName, searchString, "")

        if SubstanceName~="" then
            SubstanceSingleMass=substanceMass[SubstanceName]
            if SubstanceSingleMass~=nil then
                if ContainerMaxHP > 49 and ContainerMaxHP <=123 then
                    ContainerSelfMass = 0
                    CapacityForSubstance = 0
                elseif ContainerMaxHP > 123 and ContainerMaxHP <= 998 then
                    ContainerSelfMass = 229.09
                    CapacityForSubstance = (1000+(1000*(PlayerContainerProficiency/100)))
                elseif ContainerMaxHP > 998 and ContainerMaxHP <= 7996 then
                    ContainerSelfMass = 1280
                    CapacityForSubstance = (8000+(8000*(PlayerContainerProficiency/100)))
                elseif ContainerMaxHP > 7996 and ContainerMaxHP <= 17315 then
                    ContainerSelfMass = 7420
                    CapacityForSubstance = (64000+(64000*(PlayerContainerProficiency/100)))
                elseif ContainerMaxHP > 17315 then
                    ContainerSelfMass = 14840
                    CapacityForSubstance = (128000+(128000*(PlayerContainerProficiency/100)))
                end

                local ContentMass=ContainerTotalMass-ContainerSelfMass
                local OptimizedContentMass = ContentMass+ContentMass*(PlayerContainerOptimization/100)
                local ContentAmount = round((OptimizedContentMass/SubstanceSingleMass),1)

                if outputData[SubstanceName]~=nil then
                    outputData[SubstanceName] = {
                        name = SubstanceName;
                        amount = outputData[SubstanceName]["amount"]+ContentAmount;
                        capacity = outputData[SubstanceName]["capacity"]+CapacityForSubstance;
                    }
                else
                    local entry = {
                        name = SubstanceName;
                        amount = ContentAmount;
                        capacity = CapacityForSubstance;
                    }
                    outputData[SubstanceName]=entry
                end
            end
        end
    end

    for i = 1, #elementsIds do
        if string.match(core.getElementTypeById(elementsIds[i]), "ontainer") and string.match(core.getElementNameById(elementsIds[i]), searchString) then
            processSubstanceContainer(elementsIds[i])
        end
    end

    function BarGraph(percent)
         if percent <= 25 then return [[
            background: rgb(27,0,0);
            background: linear-gradient(90deg, rgba(27,0,0,.8) 0%, rgba(129,23,23,.8) 25%, rgba(251,0,0,.8) 100%);
             ]]
        elseif percent > 25 and percent < 60 then return [[
           background: rgb(27,0,0);
            background: linear-gradient(90deg, rgba(27,0,0,.8) 0%, rgba(129,101,23,.8) 25%, rgba(251,202,0,.8) 100%);
             ]]
         else return [[
            background: rgb(5,27,0);
            background: linear-gradient(90deg, rgba(5,27,0,.8) 0%, rgba(38,129,23,.8) 25%, rgba(34,251,0,.8) 100%);
             ]]
        end
    end

    function AddHTMLEntry(_id1, _id2)
        local id1amount = 0
        local id2amount = 0
        local id1percent = 0
        local id2percent = 0
        if outputData[_id1]~=nil then 
            id1amount = outputData[_id1]["amount"]
            id1percent = (outputData[_id1]["amount"])/outputData[_id1]["capacity"]*100000
        end
        if id1amount >= 1000 then
            id1amount = id1amount/1000
            id1unit = "ML"
        else
            id1unit = "KL"
        end
        if outputData[_id2]~=nil then
            id2amount = outputData[_id2]["amount"]
            id2percent = (outputData[_id2]["amount"])/outputData[_id2]["capacity"]*100000
        end
        if id2amount >= 1000 then
            id2amount = id2amount/1000
            id2unit = "ML"
        else
            id2unit = "KL"
        end
        resHTML =
            [[<tr>
                <th align=right style="border-style:solid; border-color:blue;">]].._id1..[[:</th>
                <th align=right style="border-style:solid; border-color:blue;">]]..string.format("%02.2f", id1amount)..id1unit..[[&nbsp;</th>
                <td class="bar" style="]]..BarGraph(id1percent)..[[; background-repeat: repeat-y; background-size:]]..((12.5/100)*id1percent)..[[vw">]]..string.format("%02.1f", id1percent)..[[%</td>
                <th style="background-color: blue;">&nbsp;</th>
                <th align=right style="border-style:solid; border-color:blue;">]].._id2..[[:</th>
                <th align=right style="border-style:solid; border-color:blue;">]]..string.format("%02.2f", id2amount)..id2unit..[[&nbsp;</th>
                <td class="bar" style="]]..BarGraph(id2percent)..[[; background-repeat: repeat-y; margin-right: 1vw;border-right-width: 1vw; background-size:]]..((12/100)*id2percent)..[[vw">]]..string.format("%02.1f", id2percent)..[[%</td>
            </tr>]]
        return resHTML
    end

    htmlHeader = [[<head><style>td.bar {border-style: solid; border-color:blue; text-align: left; font-weight:bold; font-family:]]..font..[[;}</style></head>]]
    d1 = [[<div class="bootstrap" style="text-align:left; vertical-align: text-top;">]]
    d2 = [[<span style="text-transform: capitalize; font-family:]]..font..[[; font-size:]]..headerFontSize..[[em;">&nbsp;]]
    t1 = [[&nbsp;</span>
        <table style="text-transform: capitalize; font-family:]]..font..[[; font-size:]]..fontSize..[[em; table-layout: auto; width: 100vw;">
        <tr style="width:100vw; background-color: blue; color: white;">]]
    t2 = [[ <th style="width:21vw; text-align:center;">Type</th>
            <th style="width:16vw; text-align:center;">Vol</th>
            <th style="width:14vw;text-align:center;">Levels</th>
            <th style="background-color: blue;">&nbsp;</th>
            <th style="width:21vw; text-align:center;">Type</th>
            <th style="width:16vw; text-align:center;">Vol</th>
            <th style="width:14vw;text-align:center;">Levels</th>
        </tr>]]
    c1 = [[</table></div> ]]

    if display1 then
        html=htmlHeader
        html=html..d1..d2.."Tier 1"..t1..t2
        html=html..AddHTMLEntry("Bauxite", "Coal")
        html=html..AddHTMLEntry("Hematite", "Quartz")
        html=html.."<tr><td>&nbsp;</td></tr>"

        html=html..t1..d2.."Tier 2"..t1..t2
        html=html..AddHTMLEntry("Natron", "Malachite")
        html=html..AddHTMLEntry("Limestone", "Chromite")

        html=html..t1..d2.."Tier 3"..t1..t2
        html=html..AddHTMLEntry("Petalite", "Garnierite")
        html=html..AddHTMLEntry("Pyrite", "Acanthite")

        html=html..t1..d2.."Tier 4"..t1..t2
        html=html..AddHTMLEntry("Cobaltite", "Cryolite")
        html=html..AddHTMLEntry("GoldNuggets", "Kolbeckite")

        html=html..t1..d2.."Tier 5"..t1..t2
        html=html..AddHTMLEntry("Rhodonite", "Columbite")
        html=html..AddHTMLEntry("Illmenite", "Vanadinite")
        html=html..c1
        display1.setHTML(html)
    end

end

processTick()
unit.setTimer('updateTick', 5)