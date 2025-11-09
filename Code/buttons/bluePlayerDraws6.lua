--Get Blue Player's Deck
Blue_Player_Resources='87e2b4'

--Make a value that contains the player's deck and Master when starting
function onLoad()
    Blue_Resources=getObjectFromGUID(Blue_Player_Resources)
end

function drawSix()
    --if both decks are in their respective spots
    if Global.call("getDeck", Blue_Resources) then
        
        --start the game!
        Global.call("drawSix", {player="Blue",
                                    deck=Blue_Resources,
                                    button=self})
    
    --if not, notify the players to add the cards in their spots
    else
        print("Add the Blue Player's Resources (Deck) to its respective spots")
    end
end