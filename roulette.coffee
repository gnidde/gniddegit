# This is a simulation of the theory presented in the book "Thirteen against the bank" by Norman Leigh.
# http://www.amazon.com/Thirteen-Against-Bank-Roulette-Unbeatable/dp/1843440326/ref=sr_1_1?ie=UTF8&qid=1332107076&sr=8-1
# The theory is as follows:
# Six friends works together at the roulette table. One person is betting Red, the second on Black, the third on Low, the fourth on High,
# the fithft on Even and the last on Odd.
# They all starts with four piles of markers with the following amounts in each pile: 1, 2, 3, 4.
# They always bet the smallest and the largest pile, e.g., the first bet will be 1+4=5 markers. If they win they add the net win as a new pile.
# Hence, if the first marble stops on Red, the person betting on red will have the following piles: 1, 2, 3, 4, 5 and the person bettting on black will
# have 2, 3.
# The next round the person betting on red bets 1+5=6 and the person betting on black bets 2+3=5. If black looses this round too, he starts
# over from the beginning with the piles 1, 2, 3, 4. A winning person continues to add a pile until he reaches the maximum bet that has been
# decided among the friends before they started. When that is reached he also starts over from the beginning with the four piles 1, 2, 3, 4,
# The maximum bet can be configured with the maxBet variable. It is also interresting to see the difference between having a zero or not on the
# roulette table which can be set with the variable tableHasAZero.
#

tableHasAZero = true
maxBet = 24
nrOfZerosHit = 0

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
    if @currentBetMin >= @currentBetMax || @currentBetMin + @currentBetMax > maxBet
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






