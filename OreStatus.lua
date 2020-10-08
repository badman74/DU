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
    8. If you want to use hubs, please note that all hubs must have the same volume in order for the display to work correctly, and you must enter the total volume of a hub as "DefaultHubVolume" as in (7).
    9. Activate the Programming Board.
]]

unit.hide()

display1.activate()


function round(number,decimals)
    local power = 10^decimals
    return math.floor((number/1000) * power) / power
end 

PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
DefaultHubVolume = 166400 --export The total volume of your hubs (note: all hubs must have same volume!)
MinimumYellowPercent = 25 --export At which percent level do you want bars to be drawn in yellow (not red anymore)
MinimumGreenPercent = 50 --export At which percent level do you want bars to be drawn in green (not yellow anymore)
searchString = " Ore Hub" --export Your identifier for Ore Storage Containers (e.g. "Bauxite Ore"). Include the spaces if you change this!

function processTick()

    elementsIds = core.getElementIdList()
    outputData = {}

     substanceMass = {
        Bauxite=1.28;
        Coal=1.35;
        Quartz=2.65;
        Hematite=5.04;
        Chromite=4.54;
        Malachite=4;
        Limestone=2.71;
        Natron=1.55;
        Petalite=2.41;
        Garnierite=2.6;
        Acanthite=7.2;
        Pyrite=5.01;
        Cobaltite=6.33;
        Cryolite=2.95;
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
                    CapacityForSubstance = DefaultHubVolume
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
                local ContentAmount = round(math.floor(OptimizedContentMass/SubstanceSingleMass),1)

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
        if percent <= 0 then barcolour = "red"
        elseif percent > 0 and percent <= MinimumYellowPercent then barcolour = "red"
        elseif percent > MinimumYellowPercent and percent <= MinimumGreenPercent then barcolour = "orange"
        elseif percent > MinimumGreenPercent then  barcolour = "green"
        else  barcolour = "green"
        end 
        return "<td class=\"bar\" valign=top>"..
                    "<svg>"..
                        "<rect x=\"0vw\" y=\".4vw\" rx=\".6vw\" ry=\".6vw\" height=\"2vw\" width=\"12.2vw\" stroke=\"white\" stroke-width=\".1vw\" rx=\"0vw\" />"..
                        "<rect x=\".1vw\" y=\".5vw\" rx=\".4vw\" ry=\".4vw\" height=\"1.8vw\" width=\"" .. (12/100*percent) .. "vw\"  fill=\"" .. barcolour .. "\" opacity=\"1.0\" rx=\"0vw\"/>"..
                    "</svg>"..
                "</td>"        
    end

    function AddHTMLEntry(_id1, _id2)
        local id1amount = 0
        local id2amount = 0
        local id1percent = 0
        local id2percent = 0
        if outputData[_id1]~=nil then 
            id1amount = outputData[_id1]["amount"]
            id1percent = (outputData[_id1]["amount"]*1000)/outputData[_id1]["capacity"]*100

        end
        if outputData[_id2]~=nil then
            id2amount = outputData[_id2]["amount"]
            id2percent = (outputData[_id2]["amount"]*1000)/outputData[_id2]["capacity"]*100
        end
        resHTML =
            [[<tr>
                <th align=right>]].._id1..[[:&nbsp;</th>
                <th align=right>]]..id1amount..[[&nbsp;</th>
                <th align=right>]]..string.format("%02.1f", id1percent)..[[%&nbsp;</th>
                ]]..BarGraph(id1percent)..[[
                <th style="background-color: blue;">&nbsp;</th>
                <th align=right>]].._id2..[[:&nbsp;</th>
                <th align=right>]]..id2amount..[[&nbsp;</th>
                <th align=right>]]..string.format("%02.1f", id2percent)..[[%&nbsp;</th>
                ]]..BarGraph(id2percent)..[[
            </tr>]]
        return resHTML
    end

    htmlHeader = [[<head><style>.bar { text-align: left; vertical-align: top; border-radius: 0 0em 0em 0; }</style></head>]]
    d1 = [[<div class="bootstrap" style="text-align:left; vertical-align: text-top;">]]
    d2 = [[<span style="text-transform: capitalize; font-size: 2.5em;">&nbsp;]]
    t1 = [[&nbsp;</span>
        <table style="text-transform: capitalize; font-size: 2em; table-layout: auto; width: 100vw;">
        <tr style="width:100vw; background-color: blue; color: white;">]]
    t2 = [[ <th style="width:16vw; text-align:right;">Type</th>
            <th style="width:10vw; text-align:right;">KL</th>
            <th style="width:9vw;">&nbsp;</th>
            <th style="width:15vw;text-align:left;">Levels</th>
            <th style="background-color: blue;">&nbsp;</th>
            <th style="width:16vw; text-align:right;">Type</th>
            <th style="width:10vw; text-align:right;">KL</th>
            <th style="width:9vw;">&nbsp;</th>
            <th style="width:15vw;text-align:left;">Levels</th>
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