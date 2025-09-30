//
//  PlayingCard
//
//
//  Created by Little Shoes Software Solutions on 6/2/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class PlayingCard : Card  {
    
   // internal var frontImage: UIImage
     internal var rank: Int
     internal var suit: String
    internal var topcard: Bool
    var location: Int
   
   override init ()
   {
     // self.frontImage = UIImage(named: "newbackground")!
      self.rank = 0
      self.suit = String()
      self.location = 0
      self.topcard = false
    
      super.init()
      isFaceUp = true
      
   }
   
   init(withRank: Int, ofSuit: String )
   {
     // self.frontImage = UIImage(named: "newbackground")!
      self.rank = withRank
      self.suit = ofSuit
      self.location = 0
      self.topcard = false
      super.init()
   }
    static func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
       
        return( lhs.rank == rhs.rank && lhs.suit == rhs.suit && lhs.isFaceUp == rhs.isFaceUp)
    }
    func getRank() -> Int
    {
        return self.rank
    }
    func settopcard()
    {
        topcard = true
    }
    func setRank(rank : Int)
    {
        self.rank = rank
    }
    class func validRanks() -> [String]
    {
         return ["??","A","2","3","4","5","6","7","8","9","10","J","Q","K"]
    }
    class func validSuits() -> [String]
    {
        return ["♠️","♣️","♥️","♦️"]
    }
    class func maxRank() -> Int
    {
        validRanks().count-1
    }
    func getCardSuit() ->  (String)
    {
        return self.suit
    }
    
    func getCardRank() -> (String)
    {
        var newrank = String()
        switch rank {
        case 1:
            newrank = "A"
        case 11:
            newrank = "J"
        case 12:
            newrank = "Q"
        case 13:
            newrank = "K"
        default:
            newrank = String(rank)
        }
        return newrank
    }
   func getCardSuitAndRank() -> (suit: String, rank: Int)
   {
       return (suit, rank)
        
    }
    
    func getSuitColor() -> UIColor {
        
       
       var color: UIColor
        
       switch (suit) {
            case "♠️","♣️":
                color = .black
            case "♥️","♦️":
                color = .red
       default:
                color = .blue
        
       }
        
        return color
    }
    override func toString() -> String
    {
        let facing : String
        if self.isFaceUp
        {
            facing = "is face up"
        }
        else
        {
            facing = "is face down "
        }
        
        let description = " this Playing card has a face value of \(rank), a suit of \(suit) and is facing \(facing) is top \(topcard)"
        return description
    }

   func flipcard()
    {
        isFaceUp.toggle() 
    }
    override var isKing: Bool
    {
        return self.rank == 13
    }
    
   var isAce: Bool
    {
        return self.rank == 1
    }
   
 /*   func getCardLocation() -> Int
    {
        return self.location
    }*/
  /*  func setCardLocation(imhere: Int)
    {
        self.location = imhere
    }
  */
}


