--[[
    Ore Status Display

    Refactored thanks to Dorian Gray

    1. Copy & paste this script into your Programming Board, into slot "unit" and filter "start()"
    2. Add a "stop()" filter and enter "displayOff()" into the Lua editor for this filter
    3. Add a "tick()" filter and enter the parameter "updateTick, so "tick(updateTick)". In the Lua editor for the filter enter "processTick()"
    4. Link the core this setup is placed on to your Programming Board and rename the slot to "core"
    5. Link up to 5 screens to your Programming Board, preferably S or larger, and name the slots "displayT1", "displayT2", etc. Tiers you don't have can be ommited by leaving that screen out.
    6. Rename your ore storage boxes you want this script to observe. Ores must be named "<orename> Ore", e.g. "Bauxite Ore". Any wrongly named container will not be observed.You can rename the searchString under Advanced->Edit Lua Parameters, You MUST include spaces not in the actual substance name. You can have more than one container for a single substance, if you have e.g. three large containers for Hematite, name all of them "Hematite Ore". The script does not support multiple substances in one container.
    7. On your Programming Board choose Advanced->Edit Lua Parameters and enter your Container Proficiency Bonus in percent (0 to 50) and your Container Optimization Bonus in percent (0-25)
    8. Activate the Programming Board.
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


function round(number,decimals)
    local power = 10^decimals
    return math.floor((number/1000) * power) / power
end 

PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
MinimumYellowPercent = 25 --export At which percent level do you want bars to be drawn in yellow (not red anymore)
MinimumGreenPercent = 50 --export At which percent level do you want bars to be drawn in green (not yellow anymore)
searchString = " Ore" --export Your identifier for Ore Storage Containers (e.g. "Bauxite Ore"). Include the spaces if you change this!
headerFontSize = 8 --export Header font-size in em
fontSize = 5 --export font-size in em
font = "monospace" --export font-family Must be in "". Capitalization matters.

function processTick()

    elementsIds = core.getElementIdList()
    outputData = {}

     substanceMass = {
        Bauxite=1.2812;
        Coal=1.3459;
        Quartz=2.6504;
        Hematite=5.0401;
        Chromite=4.54;
        Malachite=4.0005;
        Limestone=2.7105;
        Natron=1.5499;
        Petalite=2.4122;
        Garnierite=2.6;
        Acanthite=7.2;
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
            SubstanceColor=substanceMass[SubstanceName]*15
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
    

    function AddHTMLEntry(_id1)
        local id1amount = 0
        local id1percent = 0
        if outputData[_id1]~=nil then 
            id1amount = outputData[_id1]["amount"]
            id1percent = (outputData[_id1]["amount"])/outputData[_id1]["capacity"]*100000
        end

        if id1amount >= 1000 then
            id1amount = id1amount/1000
            id1unit = "ML"
        else
            id1amount = id1amount
            id1unit = "KL"
        end

        resHTML =
            [[<tr>
                <th align=right>]].._id1..[[:</th>
                <th align=right>]]..string.format("%02.2f", id1amount)..id1unit..[[&nbsp;</th>
                <td class="bar" style="]]..BarGraph(id1percent)..[[; background-repeat: repeat-y; background-size:]]..((30/100)*id1percent)..[[vw">]]..string.format("%02.2f", id1percent)..[[%</td>
            </tr>]]
        return resHTML
    end

    htmlHeader = [[<head><style>td.bar {border-style: solid; border-right-width: 1vw; text-align: left; vertical-align: top; font-weight:bold; font-family:]]..font..[[;}</style></head>]]
    d1 = [[<div class="bootstrap" style="text-align:left; vertical-align: text-top;">]]
    d2 = [[<span style="text-transform: capitalize; font-family:]]..font..[[; font-size:]]..headerFontSize..[[em;">&nbsp;]]
    t1 = [[&nbsp;</span>
        <table style="text-transform: capitalize; font-family:]]..font..[[; font-size:]]..fontSize..[[em; table-layout: auto; width: 100vw;">
        <tr style="width:100vw; background-color: blue; color: white;">]]
    t2 = [[ <th style="width:35vw; text-align:right;">Type</th>
            <th style="width:25vw; text-align:center;">Vol</th>
            <th style="width:30vw;text-align:left;">Levels</th>
        </tr>]]
    c1 = [[</table></div> ]]

    if displayT1 then
        html=htmlHeader
        html=html..d1..d2.."Tier 1"..t1..t2
        html=html..AddHTMLEntry("Bauxite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Coal")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Hematite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Quartz")
        html=html..c1
        displayT1.setHTML(html)
    end
    if displayT2 then
        html=htmlHeader
        html=html..d1..d2.."Tier 2"..t1..t2
        html=html..AddHTMLEntry("Natron")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Malachite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Limestone")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Chromite")
        html=html..c1
        displayT2.setHTML(html)
    end
    if displayT3 then
        html=htmlHeader
        html=html..d1..d2.."Tier 3"..t1..t2
        html=html..AddHTMLEntry("Petalite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Garnierite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Pyrite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Acanthite")
        html=html..c1
        displayT3.setHTML(html)
    end
    if displayT4 then
        html=htmlHeader
        html=html..d1..d2.."Tier 4"..t1..t2
        html=html..AddHTMLEntry("Cobaltite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Cryolite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("GoldNuggets")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Kolbeckite")
        html=html..c1
        displayT4.setHTML(html)
    end
    if displayT5 then
        html=htmlHeader
        html=html..d1..d2.."Tier 5"..t1..t2
        html=html..AddHTMLEntry("Rhodonite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Columbite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Illmenite")
        html=html.."<tr><td>&nbsp;</td></tr>"
        html=html..AddHTMLEntry("Vanadinite")
        html=html..c1
        displayT5.setHTML(html)
    end

end

processTick()
unit.setTimer('updateTick', 5)