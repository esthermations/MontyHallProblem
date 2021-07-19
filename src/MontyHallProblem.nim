import random

type
  Door       = enum Car, Goat, Nothing # What can be behind a door
  DoorNumber = range[1..3]             # The range of valid door numbers
  Game       = array[DoorNumber, Door] # An array of that many doors

# doSwitch    : Should we switch our choice after the goat is revealed?
# times       : How many times to play the game
# echoResults : Print stuff out as we go? If you play like a million games you
#               may prefer just to see the final results.
proc playGame(doSwitch: bool, times: Natural = 100, echoResults: bool = false): Natural =
  var numWins = 0 # How many times we've won

  for i in 0 .. times:
    var g: Game = [Car, Goat, Nothing]
    g.shuffle() # Randomise the game

    if echoResults: echo "Game is: ", g

    # Identify the door with the goat in it
    let goatDoor: DoorNumber = (g.find(Goat) + 1) # Need to add 1 as find returns 0-based index, bleh

    # Pick a door that *isn't* the goat. There is no scenario where we open the
    # goat door first so we just make sure that's impossible.
    var firstChoice: DoorNumber = goatDoor
    while firstChoice == goatDoor:
      firstChoice = rand(DoorNumber)
      # if this random choice is the goat again, repeat until it isn't

    if echoResults: echo "Chose door ", firstChoice

    # Reveal the goat
    if echoResults: echo "Goat is in door ", goatDoor

    # If we don't switch, our first choice is our final choice
    var finalChoice = firstChoice

    if doSwitch:
      # There's only one door left to choose but I'm just figuring out which
      # one that is by "randomly" choosing doors until it isn't either the goat
      # door or our previous choice.
      var newChoice = rand(DoorNumber)
      while newChoice in [goatDoor, firstChoice]:
        newChoice = rand(DoorNumber)
        # same principle as before
      if echoResults: echo "Switched choice to ", newChoice
      finalChoice = newChoice
    else:
      if echoResults: echo "Sticking with door ", firstChoice

    # This should be impossible...
    assert g[finalChoice] != Goat

    # See if we won
    if g[finalChoice] == Car:
      if echoResults: echo "We won!"
      inc numWins # Increment number of wins
    else:
      if echoResults: echo "We lost"

    if echoResults: echo "---"

  return numWins

##############################################################################

proc main() =
  randomize() # Initialise the RNG

  let numTimes = 5_000_000
  let doEcho   = false # Set to true to print stuff out as games are played

  if doEcho: echo "-------- No  switching! --------"
  let winsWithoutSwitching = playGame(doSwitch = false, numTimes, echoResults = doEcho)
  if doEcho: echo "-------- Yes switching! --------"
  let winsWithSwitching    = playGame(doSwitch = true , numTimes, echoResults = doEcho)
  if doEcho: echo "--------"

  echo "Wins when we didn't switch: ", winsWithoutSwitching
  echo "Wins when we DID    switch: ", winsWithSwitching


# Boilerplate, ignore
when isMainModule:
  main()
