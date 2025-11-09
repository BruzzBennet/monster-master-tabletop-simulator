PlayerBlue_Resources='87e2b4'
PlayerRed_Resources='d76c6a'
StartButtonGUID='b002c9'

function onLoad()
    startButton=getObjectFromGUID(StartButtonGUID)
end

-------------------------START GAME --------------------------
--Function to find if the Deck is in its spot
function getDeck(deck)
    local zoneObject = deck.getObjects() 
    for _, item in ipairs(zoneObject) do 
        if item.tag=='Deck' then 
            --print("Hello!") 
            return item 
        end 
    end 
    for _, item in ipairs(zoneObject) do 
        if item.tag=='Card' then 
            --print("Bye") 
            return item
        end 
    end 
    return nil 
end

function flipMaster(deck)
    local Master = getDeck(deck)

    if Master == nil then
        print("Please, add a CARD to the Master Deck")
        return
    end

    local currentRotation = Master.getRotation()

    Master.setRotationSmooth({
        x = currentRotation.x, 
        y = currentRotation.y, 
        z = 0
    })
end


--Deal 6 cards to the player
function drawSix(params)
        --Shuffle the Deck
        getDeck(params.deck).randomize()

        local currentDelay = 0
        for i=1,6 do
            Wait.time(function() 
                getDeck(params.deck).deal(1, params.player)
            end, currentDelay)
            
            --"currentDelay" ads a 0.25 sec delay between 
            --cards drawn
            currentDelay = currentDelay+0.25
        end

        destroyObject(params.button)
end

function startGameA(params)

        --Flip the Master
        flipMaster(params.Master)

        
        --Add LP by moving the top 4 cards upside down to another spot
        local currentDelay = 0
        for i=1,4 do
            Wait.time(function() 
                add3LP(params.player)
            end, currentDelay)
            
            --"currentDelay" ads a 0.6 sec delay between 
            --cards drawn
            currentDelay = currentDelay+0.5
        end

        --remove the button that was used
        destroyObject(startButton)
end

-------------------------LP COORDINATES--------------------------

Blue_Players_LP={
	    [1]={
		        x=-2.60,
		        y=1,
		        z=-8
	    },
	    [2]={
		        x=-3.90,
		        y=1,
		        z=-8
	    },
	    [3]={
		        x=-5.20,
		        y=1,
		        z=-8
	    },
	    [4]={
		        x=-6.50,
		        y=1,
		        z=-8
	    },
    	[5]={
		        x=-7.80,
		        y=1,
		        z=-8
	    },
	    [6]={
		        x=-2.60,
		        y=1,
        		z=-9
	    },
    	[7]={
		        x=-3.90,
		        y=1,
		        z=-9
	    },
    	[8]={
		        x=-5.20,
		        y=1,
		        z=-9
	    },
    	[9]={
		        x=-6.50,
		        y=1,
		        z=-9
	    },
    	[10]={
		        x=-7.80,
		        y=1,
		        z=-9
	    }
}

Red_Players_LP={
	    [1]={
		        x=3,
		        y=1,
		        z=8
	    },
	    [2]={
		        x=4.3,
		        y=1,
		        z=8
	    },
	    [3]={
		        x=5.6,
		        y=1,
		        z=8
	    },
	    [4]={
		        x=6.9,
		        y=1,
		        z=8
	    },
    	[5]={
		        x=8.2,
		        y=1,
		        z=8
	    },
	    [6]={
		        x=3,
		        y=1,
        		z=9
	    },
    	[7]={
		        x=4.3,
		        y=1,
		        z=9
	    },
    	[8]={
		        x=5.6,
		        y=1,
		        z=9
	    },
    	[9]={
		        x=6.9,
		        y=1,
		        z=9
	    },
    	[10]={
		        x=8.2,
		        y=1,
		        z=9
	    }
}

--------------------------LP WORK----------------------------

--function to get the card to make changes from. 
--either in actions to gain or lose LP
function getLastLP(player)
    if player=="Blue" then
        playerTable=Blue_Players_LP
    elseif player=="Red" then
        playerTable=Red_Players_LP
    else
        --print("(getLastLP())⚠️ Unknown player:", player)
        return nil
    end

    	--Search FILO style in the player's LP
	    for i=10, 1, -1 do
		    
        --get the card's expected coordinates according to the player 
		        local getX= playerTable[i].x
		        local getY= playerTable[i].y
    		    local getZ= playerTable[i].z		

        		--If a card is located close to those coordinates, tell me which card it is
		        local found, guid = isCardAtCoordinate(
                getX, 
                getY, 
                getZ, 
                0.5)
        if found and guid then
            --print(guid)

            return guid, i
        end
    end

    --print("(getLastLP())❌ No card found for player:", player)
    return nil

end


--find if card is close enough to a coordinate
function isCardAtCoordinate(targetX, targetY, targetZ, tolerance)

    	--get all Objects on the board
	    local allObjects = getObjects()	
	
    	--Search by each object
	    for _, object in ipairs(allObjects) do
		
    		--if the object is a card
		    if object.type == "Card" then
			        
        --get its position
			        local cardPosition = object.getPosition()

        			--if it's located in the close coordinate, return its GUID
			        if math.abs(cardPosition.x - targetX) < tolerance and
 
            			math.abs(cardPosition.y - targetY) < tolerance and
            			math.abs(cardPosition.z - targetZ) < tolerance then
                		return true, object.guid
            		end
        	end
    	end
    return false, nil
end


--function to find if there are any blank spaces where 
--no card is in
function getBlankSpaceInLP(player)
    if player=="Blue" then
        playerTable=Blue_Players_LP
    elseif player=="Red" then
        playerTable=Red_Players_LP
    else
        print("⚠️ Unknown player:", player)
        return nil
    end

    	--Search FIFO style in the player's LP
	    for i=1, 10 do
		    
        --get the card's expected coordinates according 
        --to the player 
		        local getX= playerTable[i].x
		        local getY= playerTable[i].y
    		    local getZ= playerTable[i].z		

        		--If a card is NOT located close to those coordinates, 
        --tell me, and which coordinates are they 
		        local found, guid = isCardAtCoordinate(
                getX, 
                getY, 
                getZ, 
                0.5)
        if not found then

            return true, getX ,getY, getZ
        end
    end

    print("(getBlankSpaceInLP())❌ No card found for player:", player)
    return nil

end


---------------------LOSE LP FUNCTIONS-----------------------------

function lose1LP(player)

    	--get the LP to edit
	    local LPtoChange, i=getLastLP(player)


    if not LPtoChange then
        print("⚠️ No LP card found to modify for player:", player)
        return
    --else
        --print("LP To Change:", LPtoChange)
    end

    local LPtoGo = getObjectFromGUID(LPtoChange)
    if not LPtoGo then
        print("⚠️ Object not found for GUID:", LPtoChange)
        return
    --else
        --print("LP To Go:", LPtoGo)
    end

    	--get its Rotation      
    	LProtation = LPtoGo.getRotation()
    
    --get its Y-Rotation and normalize it 
    --to avoid weird 370° cases.	
    LPleft = (LProtation.y % 360)

    --add tolerace to the Rotation search
    local tolerance = 10
    	
	    --Move it according to player
	    if player=="Blue" then

        		--if it's upside down, put it horizontally
    		    if (LPleft <= 0 + tolerance or 
            LPleft>=360 - tolerance) then
            		LPtoGo.setRotationSmooth({x = 0, y = 90, z = 180})

        		--if it's put horizontaly, put it upright
        	elseif (LPleft <= 90 + tolerance and 
                LPleft >=  90 - tolerance) then
            	LPtoGo.setRotationSmooth({x = 0, y = 180, z = 180})
            	
		        --if it's upright, draw it
		        elseif (LPleft >= 180 - tolerance and 
                LPleft<=180 + tolerance) then
            LPtoGo.deal(1,player)
        end

    	--Same as "Blue" player but in "Red" player's perspective
    	elseif player=="Red" then
        	if (LPleft >= 180 - tolerance and 
            LPleft<=180 + tolerance) then
            	LPtoGo.setRotationSmooth({x = 0, y = 90, z = 180})
        	elseif (LPleft <= 90 + tolerance and 
                LPleft >=  90 - tolerance) then
	            LPtoGo.setRotationSmooth({x = 0, y = 0, z = 180})
        elseif (LPleft <= 0 + tolerance or 
                LPleft>=360 - tolerance) then
            LPtoGo.deal(1,player)
        end    
    	end
end

function lose3LP(player)
    	local turn, playerTable

    	--get the correct coordinates
 according to the player
	    if player=="Blue" then

	        	playerTable=Blue_Players_LP
	    elseif player=="Red" then	

		        playerTable=Red_Players_LP
	    else
        	print("⚠️ Unknown player:", player)
        	return nil
	    end


    	--get the coordinates and guid of the LP card to Move
    	local cardGUID, i = getLastLP(player) 

    	--Move the LP card ONLY IF there is any
    	if i~=nil then   

        		--get the last LP card to draw or move
		        local LPtoDraw = getObjectFromGUID(cardGUID)
        local LPtoMove = getObjectFromGUID(cardGUID)


        --if is at the first LP point, draw it no matter
 it
        --rotation
        if i==1 then
            	LPtoDraw.deal(1, player)
            		return

	        else

            --check if there is a card before it first
            local isBefore,LPBeforeGUID = isCardAtCoordinate(
				                    playerTable[i-1].x, 
				                    playerTable[i-1].y, 
				                    playerTable[i-1].z,
				                    0.5)


            	--if there isn't a car before nor after, 
            --also draw it
 regardless
            if i>1 and not isBefore then
			                LPtoDraw.deal(1, player)
			                return
            end


            --If none of those conditions are met,				
            		--we'll check its Rotation      
            		LProtation = LPtoMove.getRotation()
    
            		--get its Y-Rotation and normalize it 
            		--to avoid weird 370° cases.	
            		LPturn = (LProtation.y % 360)
		
        		    --get the coordinates of the spot 
        		    --the card will be moved at if the card
            --isn't upside down
        		    local getX=playerTable[i-1].x
    		        local getY=playerTable[i-1].y
        		    local getZ=playerTable[i-1].z
        
            	--If it isn't upside down, draw the card before it

            --first get that card
            local LPtoDraw = getObjectFromGUID(LPBeforeGUID)

            --Check that condition
	            if player=="Blue" and not 
                (LPturn <= 10 or LPturn>=350) 
                or
               player=="Red" and not 
                (LPturn >= 170  and LPturn<=190) 
                then

            	    --If it's true, draw the card before, 
                LPtoDraw.deal(1, player)

        		        --and move the card
                LPtoMove.setPositionSmooth({x=getX,
                                        y=getY,
                                        z=getZ})
            
            else
                --if it is upside down, 
draw it
                LPtoMove.deal(1, player)
            end


    	    end  
    else
        print("No LP left to lose")
        return

    end  

end


----------------------Gain LP Functions------------------------

function add1LP(player)
    local deck,turn,playerTable

    	--get the correct deck, added-card rotation, and coordinates
	    --according to the player
	    if player=="Blue" then
		        deck=getObjectFromGUID(PlayerBlue_Resources)
	        turn=180
        		playerTable=Blue_Players_LP
	    elseif player=="Red" then	
		        deck=getObjectFromGUID(PlayerRed_Resources)
		        turn=0
		        playerTable=Red_Players_LP
	    else
        	print("⚠️ Unknown player:", player)
        	return nil
	    end

    --don't do anything if the Deck isn't in its spot
    if not getDeck(deck) then
        print("Please put a deck in its spot")
        return
    end

    	--get the coordinates of the LP card that changed
	    local deckGuid, i = getLastLP(player)
    
    --if there isn't an LP card, put it in the first spot
    if i==nil then
        i=0
    end    


    --get the coordinates of the next spot the card will be 
    --added in
	    local getX=playerTable[i+1].x
	    local getY=playerTable[i+1].y
	    local getZ=playerTable[i+1].z

    local deckObj=
getDeck(deck)
    
    deckObj.takeObject({
                    smooth = true,
                    fast=true,
                    rotation = {x = 0, 
                                y = turn, 
                                z = 180},
                    position = {getX, 
                                getY, 
                                getZ}
                    })

end

function gain1LP(player)
    	--get the LP to edit
	    local LPtoChange, i=getLastLP(player)

    if not LPtoChange then
        add1LP(player)
        print("No LPtoChange!")
        return
    --else
        --print("LP To Change:", LPtoChange)
        --print("LP i:",i)
    end

    	--get the LP card to interact with
    local LPtoGo = getObjectFromGUID(LPtoChange)
    if not LPtoGo then
        print("⚠️ Object not found for GUID:", LPtoChange)
        return
    --else
        --print("LP To Go:", LPtoChange)
    end

    	--get its Rotation      
    	LProtation = LPtoGo.getRotation()
    
    --get its Y-Rotation and normalize it 
    --to avoid weird 370° cases.	
    LPleft = (LProtation.y % 360)

    --add tolerace to the Rotation search
    local tolerance = 10
    	
	    --Move it according to player
	    if player=="Red" then

        		--if it's upside down, put it horizontally
    		    if (LPleft <= 0 + tolerance or 
                LPleft>=360 - tolerance) then
            		LPtoGo.setRotationSmooth({x = 0, y = 90, z = 180})

        		--if it's put horizontaly, put it upright
        	elseif (LPleft <= 90 + tolerance and 
                LPleft >=  90 - tolerance) then
            	LPtoGo.setRotationSmooth({x = 0, y = 180, z = 180})
                	
		        --if it's upright, draw it
		        elseif (LPleft >= 180 - tolerance and 
                LPleft<=180 + tolerance) then
            if i~=10 then
                add1LP(player)
            else
                print("Add card to blank zone!")
            end
        end

    	--Same as "Red" player but in "Red" player's perspective
    	elseif player=="Blue" then
        	if (LPleft >= 180 - tolerance and 
                LPleft<=180 + tolerance) then
            	LPtoGo.setRotationSmooth({x = 0, y = 90, z = 180})
        	elseif (LPleft <= 90 + tolerance and 
                LPleft >=  90 - tolerance) then
	            LPtoGo.setRotationSmooth({x = 0, y = 0, z = 180})
        elseif (LPleft <= 0 + tolerance or 
                LPleft>=360 - tolerance) then
            if i~=10 then
                add1LP(player)
            else
                print("Add card to blank zone!")
            end
        end    
    	end
end


function add3LP(player)
    	local deck, turn, playerTable

    	--get the correct deck, added-card rotation, and coordinates
    	--according to the player
	    if player=="Blue" then
		        deck=getObjectFromGUID(PlayerBlue_Resources)
	        turn=0
	        	playerTable=Blue_Players_LP
	    elseif player=="Red" then	
		        deck=getObjectFromGUID(PlayerRed_Resources)
		        turn=180
		        playerTable=Red_Players_LP
	    else
        	print("⚠️ Unknown player:", player)
        	return nil
	    end
    
    --don't do anything if the Deck isn't in its spot
    if not getDeck(deck) then
        print("Please put a deck in its spot")
        return
    end

    	--get the coordinates and guid of the LP card to Move
    	local cardGUID, i = getLastLP(player) 
    
    --print(i)

    	--Move the LP card ONLY IF there is any
    	if i~=nil then   

        --if at the last LP point
        if i==10 then
            --check if there are any blank spaces
            local thereIsABlankSpace, blankX, blankY, blankZ
                    = getBlankSpaceInLP(player)

            --if there are any, put a card there
            if thereIsABlankSpace then

                	--get the Deck
                	local deckObj=getDeck(deck)

                --put its top card in the blank space
                moveCard({cardToMove=deckObj,
    		                turn=turn,
		                    posX=blankX,
		                    posY=blankY,
		                    posZ=blankZ})          
                 return

            --if not, just give full health
            else            
                for j=1,2 do
                    onButtonPress({player=player,
                                functionToDo="gain1LP"})
                end
                return
            end
        end        
		
        --get the card
		        local LPtoMove = getObjectFromGUID(cardGUID)
		
        		--get its turn value
    		    --get its Rotation      
        		LProtation = LPtoMove.getRotation()
    
        		--get its Y-Rotation and normalize it 
        		--to avoid weird 370° cases.	
        		LPturn = (LProtation.y % 360)
		
        		--get the coordinates of the spot 
        		--the card will be moved at
        		local getX=playerTable[i+1].x
    		    local getY=playerTable[i+1].y
    		    local getZ=playerTable[i+1].z
        
        	--Move it ONLY if it isn't upside down
	        if player=="Blue" and not 
            (LPturn <= 10 or LPturn>=350) 
            or
           player=="Red" and not 
            (LPturn >= 170  and LPturn<=190) 
            then

        		    --move the card
            LPtoMove.setPositionSmooth({x=getX,
                                        y=getY,
                                        z=getZ})
        else
            --if it is upside down, 
            --put a card next to it instead
            i=i+1
        end

    else
        i=1
	    end    


	
    	--get the coordinates of the LP card  
    	--to add from the player's Resources
    	local add3X=playerTable[i].x
	    local add3Y=playerTable[i].y
	    local add3Z=playerTable[i].z

    	--get the Deck
    	local deckObj=getDeck(deck)

    	--move its top card
    moveCard({cardToMove=deckObj,
		            turn=turn,
		            posX=add3X,
		            posY=add3Y,
		            posZ=add3Z})

end


function moveCard(params)
    if params.cardToMove.tag=='Deck' then
        params.	cardToMove.takeObject({
                    fast=true,
                    smooth = true,
                    rotation = {x = 0, 
                                y = params.turn, 
                                z = 180},
                    position = {params.posX, 
                                params.posY, 
                                params.posZ}
                    })
    elseif params.cardToMove.tag=='Card' then
        params.	cardToMove.setPositionSmooth(
                    {params.posX, 
                    params.posY, 
                    params.posZ},
                    false,
                    false)
        params.	cardToMove.setRotationSmooth(
                    {x = 0, 
                    y = params.turn, 
                    z = 180})
    end
end

----------------------LP Tasks Queue-------------------------
----------------To avoid function overflow-------------------

--FIFO Queue for functions involving LP
LPQueue = {}
LPQueueSize=0
doingLPFunction = false

function processQueue()
    	
    	--if it's doing a function right now, 
	    --don't run until it to finishes
	    if doingLPFunction then 
		        return 
	    end      
    	
	    --if there is nothing in the Gueue, do nothing
	    if #LPQueue == 0 then 
        LPQueueSize=0
		        return 	
	    end 

    	-- get first function on the Queue
	    local task = table.remove(LPQueue, 1)

    --print(task.player)
    --print(task.functionToDo) 
	
    	-- Do the function right now
    	doingLPFunction = true

    -- run your function (example: gain1LP)
    _G[task.functionToDo](task.player)

    	--Allow space for another function
    LPQueueSize=LPQueueSize+1

    -- do next task after 1 seconds
    Wait.time(function()

        	--allow to do next task
        doingLPFunction = false


        	-- do next task in queue
        processQueue()

    --wait 0.5 seconds  
    end, 0.5)  
end

function onButtonPress(params)

    	--if the buttons were pressed less than 3 times 
	    --(to avoid overflowing with functions)
	    --Do this
	    if LPQueueSize<=3 then

        		-- add the function to the Queue
   		    table.insert(LPQueue, {player=params.player, 
                            functionToDo=params.functionToDo})
		
    		    --Add the function
		        processQueue() 
	    else
        		print(player, " Player: DENIED! Wait for your buttons to complete their actions")
	    end
end