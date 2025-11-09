--Get the Player A's Deck
Blue_Player_Resources='87e2b4'
Red_Player_Resources='d76c6a'
Blue_Player_Master='5c464c'
Red_Player_Master='313018'

--Make a value that contains the player's deck and Master when starting
function onLoad()
    Blue_Resources=getObjectFromGUID(Blue_Player_Resources)
    Red_Resources=getObjectFromGUID(Red_Player_Resources)
    Blue_Master=getObjectFromGUID(Blue_Player_Master)
    Red_Master=getObjectFromGUID(Red_Player_Master)
end

function pressToStart()
    --if both decks are in their respective spots
    if Global.call("getDeck", Blue_Resources) and 
        Global.call("getDeck", Red_Resources) and
        Global.call("getDeck", Blue_Master) and 
        Global.call("getDeck", Red_Master) then
        
        --start the game!
        Global.call("startGameA", {player="Blue",
                                    deck=Blue_Resources, 
                                    Master=Blue_Master})
        Global.call("startGameA", {player="Red",
                                    deck=Red_Resources,
                                    Master=Red_Master})
    
    --if not, notify the players to add the cards in their spots
    else
        print("Add Decks (Resources) and Masters to their respective spots")
    end
end