tableHasAZero = true
nrOfZerosHit = 0
maxBet = 24

class StakeEntity
  constructor: (@stakeName) ->
    @currentBetMin = 1
    @currentBetMax = 4
    @currentEarnings = 0

  roll: (result, iteration) ->
    # Set correct bet
    currentBet = @currentBetMin + @currentBetMax

    # Subtract the bet from earnings
    @currentEarnings -= currentBet

    # Check if we won
    if @stakeName in result
      @currentEarnings += 2*currentBet
      @currentBetMax++
    else
      @currentBetMin++
      @currentBetMax--

    # Check if we need to start over from the beginning the next round
    if @currentBetMin == @currentBetMax || @currentBetMin + @currentBetMax > maxBet
      @currentBetMin = 1
      @currentBetMax = 4

names = {red: 'Red', black: 'Black', even: 'Even', odd: 'Odd', low: 'Low', high: 'High'}
redNumbers = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]

stakeEntities = [new StakeEntity(names.red), new StakeEntity(names.black),
                new StakeEntity(names.even), new StakeEntity(names.odd),
                new StakeEntity(names.low), new StakeEntity(names.high)]

roll = (iteration) ->
  result = []

  # Lets roll the marble!
  hit = if tableHasAZero then Math.floor Math.random()*37 else Math.floor Math.random()*36 + 1

  # If we hit the zero, let the result array be empty
  if hit
    if hit in redNumbers then result.push names.red else result.push names.black
    if hit < 19 then result.push names.low else result.push names.high
    if hit%2 then result.push names.odd else result.push names.even
  else
    nrOfZerosHit++

  # Update all entities with the result from the roll
  for ent in stakeEntities
    do (ent) ->
      ent.roll result, iteration

# Lets roll some marbles
for i in [1..10000000]
  do (i) ->
    roll i
    if i%1000000 == 0
      totalEarnings = 0
      for ent in stakeEntities
        do (ent) ->
          totalEarnings += ent.currentEarnings
      console.log "#{i} : Total earnings: #{totalEarnings}. Nr of zeros hit: #{nrOfZerosHit}"






