//
//  Deck
//
//
//  Created by Little Shoes Softwar Solutions on 6/2/2023.
//  Copyright © 2023 All rights reserved.
//
import Foundation
import UIKit

class Deck  {
     var cards = [Card]()
   
    var counter = 0
    
    func shuffleDeck()
   {
       
        cards.shuffle()
     
      }
 
}
