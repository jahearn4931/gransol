//
//  Card
//
//
//  Created by Little Shoes Softwar Solutions on 6/2/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class Card : ObservableObject, Equatable  {
    static func == (lhs: Card, rhs: Card) -> Bool {
      
        return (false)
    }
    
    
    
    internal var value: UIImage
    @Published var isFaceUp: Bool
    
   init()
   {
       value = UIImage(named: "PlayingCard-back")!
       isFaceUp = false
    
   }
    
    func toString() -> String
    {
        let description = "The card is \(isFaceUp)"
        return description
    }
    
    var isKing: Bool {
        return false //self.value % numberOfCardsInSuit == 12
    }
    
  
 
}
