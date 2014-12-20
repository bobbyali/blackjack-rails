# ============================================================
# Deck class
# Represents a playing deck of cards, containing 40 cards
# (1-10 of each suit) which are already shuffled.
#
# To initialise, call
# 	Deck.new
#
# Public Methods:
# 	+ deal_card  	(issue a new card, remove from deck)
# 	+ output_deck   (print out whole deck to command line)
# 	+ num_cards_in_deck  (returns number of cards in deck)
#   + add_cards_to_deck  (adds array of Cards to deck)
#   + reshuffle 	(reshuffle the deck)
# ============================================================
class Deck
	attr_accessor :game_id

	def initialize(game_id)
		@game_id = game_id
		card_deck = []		
		1.upto(10) do |card_number|
			0.upto(3) do |suit_number|
				card_deck << Card.new(card_number, CARD_VALUES[suit_number])
			end
		end
		card_deck.shuffle!

		REDIS.del deck_key
		card_deck.each do |card|
			REDIS.rpush deck_key, card.to_json
		end
	end

	def deal_card		
		Card.from_json(REDIS.lpop deck_key)
	end

	def output_deck
		REDIS.lrange(deck_key, 0, -1).collect do |card|		
			Card.from_json(card).output_card
		end
	end

	def num_cards_in_deck
		REDIS.lrange(deck_key, 0, -1).count		
	end

	def add_cards_to_deck(cards)		
		cards.each {|card| REDIS.rpush deck_key, card.to_json}
	end

	def reshuffle
		#self.card_deck.shuffle!
	end

	private 

		def deck_key
			return "game/" + self.game_id.to_s
		end
end

