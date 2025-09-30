//
//  PlayingCardDeck
//
//
//  Created by Little Shoes Software Solutions on 6/2/2023.
//  Copyright © 2023 All rights reserved.
//
import Foundation


class PlayingCardDeck : Deck
{
    
    override init()
    {
        super.init()
        // create all 4 suits 2 - Ace = 52 cards
        for suit in PlayingCard.validSuits()
        {
            var rank = 1
            while rank <= PlayingCard.maxRank()
           {
                
                let currentCard = PlayingCard(withRank: rank, ofSuit: suit)
               self.cards.append(currentCard)
                rank = rank + 1
            }
        }
       // print("created new deck")
    }
    func orderDeck() -> Void
    {
    
    }

   // override func nextCard() -> PlayingCard
    func nextCard() -> PlayingCard
    {
        if counter > 51
        {
            counter = 0
            
        }
        let retcard = self.cards[counter]
        counter = counter + 1
        return retcard as! PlayingCard
    }

     func getcard (cardnum:Int) -> PlayingCard
    {
        let retcard = self.cards[cardnum]
        return retcard as! PlayingCard
    }
   
 /*   func shuffleDeck() -> PlayingCardDeck
    {
       // let suit = Suit(rawValue: self.value / numberOfCardsInSuit)!
       // let rank = (self.value % numberOfCardsInSuit)
        return cards.shuffled()
      }*/
 
}

