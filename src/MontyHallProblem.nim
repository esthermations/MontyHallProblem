import random
import cligen

type
  Door       = enum Car, Goat          # What can be behind a door
  DoorNumber = range[1..3]             # The range of valid door numbers
  Game       = array[DoorNumber, Door] # An array of that many doors

# times       : How many times to play the game
# echoResults : Print stuff out as we go? If you play like a million games you
#               may prefer just to see the final results.
proc playGame(times: Natural, echoResults: bool = false) =
  var
    stayWins   = 0
    changeWins = 0

  for i in 0 .. times:
    var g: Game = [Car, Goat, Goat]
    g.shuffle() # Randomise the game

    if echoResults: echo "Game is: ", g

    # Pick a door
    let firstChoice: DoorNumber = rand(DoorNumber)

    if echoResults: echo "Chose door ", firstChoice

    var goatDoor: DoorNumber = firstChoice

    # Reveal a goat that isn't our first choice (if that is a goat)
    while goatDoor == firstChoice and g[goatDoor] != Goat:
      goatDoor = rand(DoorNumber)

    # Reveal the goat
    if echoResults: echo "Goat is in door ", goatDoor

    # See if we won
    if g[firstChoice] == Car:
      inc stayWins # Sticking with our first choice would have won
      if echoResults: echo "Staying  would have won"
    else:
      inc changeWins # After the goat was revealed, if we chose the other door, we would have won
      if echoResults: echo "Changing would have won"

    if echoResults: echo "---"

  echo "Change won ", changeWins, " times"
  echo "Stay   won ", stayWins, " times"


##############################################################################

proc main(numTimes: Natural = 10, silent: bool = false) =
  randomize() # Initialise the RNG
  playGame(numTimes, not silent)

# Generate command-line interface
cligen.dispatch(main)
