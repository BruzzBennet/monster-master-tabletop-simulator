--Get Blue Player's Deck
Red_Player_Resources='d76c6a'

--Make a value that contains the player's deck and Master when starting
function onLoad()
    Red_Resources=getObjectFromGUID(Red_Player_Resources)
end

function drawSix()
    --if both decks are in their respective spots
    if Global.call("getDeck", Red_Resources) then
        
        --start the game!
        Global.call("drawSix", {player="Red",
                                    deck=Red_Resources,
                                    button=self})
    
    --if not, notify the players to add the cards in their spots
    else
        print("Add the Red Player's Resources (Deck) to its respective spots")
    end
end