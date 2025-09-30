//
//  GameModel.swift
//  gransol
//
//  Created by LittleShoes Software Solutions on 6/22/23.

//  Copyright © 2023 All rights reserved.

import Foundation
import SwiftUI

var theDeck = PlayingCardDeck()
var Score: Int = 0


 
class  GameModel : ObservableObject, Equatable
{
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        
        return false
    }
    
  
    
    // all are published
     @Published var stack1: cardstack
    @Published var stack2 : cardstack
   @Published var stack3 : cardstack
   @Published var stack4 : cardstack
    @Published var stack5 : cardstack
    @Published var stack6 : cardstack
    @Published var stack7 : cardstack
    @ObservedObject var extrastack : cardstack
    @Published var collect1: accumStack
    @Published var collect2: accumStack
    @Published var collect3: accumStack
    @Published var collect4: accumStack
    @Published var didWin: Bool
   
    
   init() {
      
        stack1 = cardstack(stacknum: 1, myDeck: theDeck)
        stack2 = cardstack(stacknum: 2, myDeck: theDeck)
        stack3 = cardstack(stacknum: 3, myDeck: theDeck)
        stack4 = cardstack(stacknum: 4, myDeck: theDeck)
        stack5 = cardstack(stacknum: 5, myDeck: theDeck)
        stack6 = cardstack(stacknum: 6, myDeck: theDeck)
        stack7 = cardstack(stacknum: 7, myDeck: theDeck)
        extrastack = cardstack(stacknum: 8, myDeck: theDeck)
    
        collect1 =  accumStack(stacknum: 1)
        collect2 = accumStack(stacknum: 2)
        collect3 = accumStack(stacknum: 3)
        collect4 = accumStack(stacknum: 4)
    
        didWin = false
        deal()
    }
    
    func accumulate(fromStack: Int) -> Bool
    {
        //fromstack is really the card location now
        //change this to the card instead of the stack to simplify
        //find stack.\
        
        let locstack = fromStack/100
        //fix this for extra cards
        let fromcardstack = getStack(stacknum: fromStack/100)
        var topcard : PlayingCard
        
            topcard = fromcardstack.thestack[fromStack%100]
      
        var collectionstack = collect1
        var canAdd = false
        
        if (isTopCard(cardLoc: fromStack))
        {
            
            if (topcard.isAce)
            {
                
                //find empty collection stack and move to
                collectionstack = getCollectionStack()
                canAdd = true
                topcard.isFaceUp = true
                collectionstack.setSuit(stackSuit: topcard.getCardSuit())
            }
            else
            {
                //find the proper collection stack for the suit then checkto see if can be added
                collectionstack = findaccumulationstack(topcard: topcard)
                //check stacks to see if the move is allowed
                canAdd = collectionstack.canAddtostack(newcard: topcard)
            }
            if (canAdd){
                collectionstack.accumstackcards.append( topcard)
                
                if (locstack == 8)
                {
                    //need to reset stack8 card numbers
                    fromcardstack.thestack.remove(at: (fromStack%100))
                    reorderExtras()
                
                }
                else
                {
                    fromcardstack.thestack.removeLast()
                    //set the new last card as the top card
                    if (fromcardstack.thestack.count > 0)
                    {
                        fromcardstack.thestack[(fromStack%100)-1].topcard = true
                    }
                }
                
                
                
                return true
            }
            else
            {
                return false
            }
           
        }
       
        
        return false
    }
    func isTopCard(cardLoc:Int) -> Bool
    {
        let locstack = cardLoc/100
        if (locstack < 8)
        {
            let cardstack = getStack(stacknum: locstack)
            let cardnum = cardLoc % 100
            
            if (cardstack.thestack.count-1 == cardnum)
            {
                return true
            }
            return false
        }
        else
        {
            
            return true
            
        }
        
    }
    func checkForWin() -> Void
    {
        
       
        if ((collect1.accumstackcards.count == 13 )  && (collect2.accumstackcards.count == 13)  &&
                (collect3.accumstackcards.count == 13 )  && (collect4.accumstackcards.count == 13 ))
        {
            didWin = true
        }
        //can make this a void return
        //return ( (collect1.accumstackcards.count == 13 )  && (collect2.accumstackcards.count == 13)  &&
        //        (collect3.accumstackcards.count == 13 )  && (collect4.accumstackcards.count == 13 ))
        
    }
    func findCard(cardLoc:Int) -> PlayingCard
    {
        
        let locstack = cardLoc/100
       
        let  fromcardstack = getStack(stacknum: locstack)
        let cardnum = cardLoc % 100
        
        var card = PlayingCard()
        if (locstack < 9 && locstack > 0)
        {
            card = fromcardstack.thestack[cardnum]
        }
        
        return card
    }
    func getCollectionStack() -> accumStack
    {
        if (collect1.accumstackcards.isEmpty)
        {
            return collect1
        }
        else if (collect2.accumstackcards.isEmpty)
        {
            return collect2
        }
        else if (collect3.accumstackcards.isEmpty)
        {
            return collect3
        }
        else
        {
            return collect4
        }
    }
    func findaccumulationstack(topcard: PlayingCard) -> accumStack
    {
        let  checkSuit = topcard.getCardSuit()
        switch checkSuit {
        case collect1.suit:
            return collect1
        case collect2.suit:
            return collect2
        case collect3.suit:
            return collect3
        default:
            return collect4
        }
    }
    
    
    func checkForMove(initialCard: PlayingCard, stack: Int) -> Int
    {
        var maybetostack = getStack(stacknum: 7)
        if(maybetostack.thestack.count > 0 )
        {
            let  lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 7
            }
        }
        maybetostack = getStack(stacknum: 6)
        if(maybetostack.thestack.count > 0 )
        {
            let lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 6
            }
        }
        maybetostack = getStack(stacknum: 5)
        if(maybetostack.thestack.count > 0 )
        {
            let lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 5
            }
        }
        maybetostack = getStack(stacknum: 4)
        if(maybetostack.thestack.count > 0 )
        {
           let  lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 4
            }
        }
        maybetostack = getStack(stacknum: 3)
        if(maybetostack.thestack.count > 0 )
        {
            let lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 3
            }
        }
        maybetostack = getStack(stacknum: 2)
        if(maybetostack.thestack.count > 0 )
        {
            let lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 2
            }
        }
        maybetostack = getStack(stacknum: 1)
        if(maybetostack.thestack.count > 0 )
        {
            let lastcard = maybetostack.thestack[maybetostack.thestack.count-1]
            if ( lastcard.getRank() == initialCard.getRank()+1 && lastcard.suit == initialCard.getCardSuit())
            {
                return 1
            }
        }
        return 0
        
    }
   
    func flipExtras()
    {
        var extraIt = extrastack.thestack.makeIterator()
        var card = extraIt.next()
        while (card  != nil)
        {
            card?.isFaceUp = true
            card = extraIt.next()
        }
    }
    
  
    
    func findkingstack() -> Int
    {
        if (stack1.thestack.isEmpty)
        {
            return 1
        }
        else if(stack2.thestack.isEmpty)
        {
            return 2
        }
        else if(stack3.thestack.isEmpty)
        {
            return 3
        }else if(stack4.thestack.isEmpty)
        {
            return 4
        }else if(stack5.thestack.isEmpty)
        {
            return 5
        }else if(stack6.thestack.isEmpty)
        {
            return 6
        }
        else if(stack7.thestack.isEmpty)
        {
            return 7
        }
        else
        {
            return 0
        }
    }
    
    func moveKing(_ moveCardloc: Int, moveCard: PlayingCard)
    {
        
        
        //change this to return the stack number vice teh stack or 0 for no stack.
        //var toStack = findEmptyStack()
        let emptyStack = findkingstack()
        if emptyStack > 0
        {
            let toStack = getStack(stacknum: emptyStack)
            
            let locstack = moveCardloc/100
            
            if (locstack < 9)
            {
                let fromcardstack = getStack(stacknum: locstack)
                
                let card = findCard(cardLoc: moveCardloc)
                
                var it = fromcardstack.thestack.makeIterator()
                
                if (locstack == 8)
                {
                    //just move one card only
                    card.location = toStack.stacknumber*100 + toStack.thestack.count
                    
                    toStack.thestack.append(moveCard)
                    
                   var fromIt = fromcardstack.thestack.makeIterator()
                    var loopcard = fromIt.next()
                    var loopcount = 0
                    
                    while (loopcard != nil)
                    {
                        
                        if (loopcard! == moveCard )
                        {
                            fromcardstack.thestack.remove(at: loopcount)
                            //  print("removing loopcount ")
                        }
                        
                        loopcount += 1
                        loopcard = fromIt.next()
                    }
                    reorderExtras()
                }
                else
                {
                    var fromCard = it.next()
                    var cardcount = 0
                    var removecount = 0
                    while (fromCard != nil)
                    {
                           
                            //find the element
                            if (moveCardloc%100 <= cardcount)
                        {
                            fromCard!.location = toStack.stacknumber*100 + toStack.thestack.count
                            toStack.thestack.append(fromCard!)
                            removecount += 1
                            
                            //find number to remove
                            
                        }
                        fromCard = it.next()
                        cardcount += 1
                    }
                    fromcardstack.thestack.removeLast(removecount)
                
                
                    if( fromcardstack.thestack.count > 0)
                    {
                        fromcardstack.thestack[fromcardstack.thestack.count-1].topcard = true
                        
                    }
                }
            }//end else
       }
    }
    
    func reorderExtras()
    {
        var fromIt = extrastack.thestack.makeIterator()
        var loopcard = fromIt.next()
        
        var cardloc = 800
        while (loopcard != nil)
        {
            
                loopcard?.location = cardloc
                cardloc += 1
            
            loopcard = fromIt.next()
        }
    }
    
    func moveCard(_ moveCardloc : Int , moveCard: PlayingCard)
    {
        //check to see if card can move
        let locstack = moveCardloc/100
        //fix this for extra cards
        if (locstack < 9)
        {
            let fromcardstack = getStack(stacknum: locstack)
           
            //check all the top cards to see if card can be moved
            let moveStack = checkForMove(initialCard: moveCard, stack: moveCardloc)
           
            if (moveStack > 0 && moveStack != locstack)
            {
                let toStack = getStack(stacknum: moveStack)
                toStack.thestack[toStack.thestack.count-1].topcard = false
                if (locstack == 8)
                {
                    //just move one card only
                    moveCard.topcard=true
                    moveCard.location = toStack.thestack[toStack.thestack.count-1].location + 1
                    toStack.thestack.append(moveCard)
                    
                    var fromIt = fromcardstack.thestack.makeIterator()
                    var loopcard = fromIt.next()
                    var loopcount = 0
                    
                    while (loopcard != nil)
                    {
                        //print ("looking for extra card match")
                        if (loopcard! == moveCard )
                        {
                            fromcardstack.thestack.remove(at: loopcount)
                          //  print("removing loopcount ")
                        }
                        
                        loopcount += 1
                        loopcard = fromIt.next()
                    }
                    reorderExtras()
                }
                else
                {
                    var it = fromcardstack.thestack.makeIterator()
                   
                    var fromCard = it.next()
                    var cardcount = 0
                    var removecount = 0
                    while (fromCard != nil)
                    {
                       
                        //find the element
                        if (moveCardloc%100 <= cardcount)
                        {
                            fromCard!.location = moveStack*100 + toStack.thestack.count //added this line
                            toStack.thestack.append(fromCard!)
                            removecount += 1
                            
                            //find number to remove
                            
                        }
                        fromCard = it.next()
                        cardcount += 1
                    }
                    fromcardstack.thestack.removeLast(removecount)
                   
                    
                    if( fromcardstack.thestack.count > 0)
                    {
                        fromcardstack.thestack[fromcardstack.thestack.count-1].topcard = true
                       // print("setting topcard " + String(fromcardstack.thestack[fromcardstack.thestack.count-1].location))
                    }
                }
                
            }
        }
        
        //
        //TODO maybe keep the last move for an undo?
    }
    
    
    
    func getStack(stacknum:Int) -> cardstack
    {
       switch stacknum {
            case 1:
                return stack1
            case 2:
                return stack2
            case 3:
                return stack3
            case 4:
                return stack4
           case 5:
                return stack5
           case 6:
                return stack6
           case 7:
                return stack7
            case 8:
                return extrastack
            default:
                return stack1
    
        }
        
    }
    func deal()
    {
        
        theDeck.counter=0
        
        theDeck.shuffleDeck()
        
        stack1 = cardstack(stacknum: 1, myDeck: theDeck)
        stack2 = cardstack(stacknum: 2, myDeck: theDeck)
        stack3 = cardstack(stacknum: 3, myDeck: theDeck)
        stack4 = cardstack(stacknum: 4, myDeck: theDeck)
        stack5 = cardstack(stacknum: 5, myDeck: theDeck)
        stack6 = cardstack(stacknum: 6, myDeck: theDeck)
        stack7 = cardstack(stacknum: 7, myDeck: theDeck)
         dealExtras()
       
        collect1.accumstackcards.removeAll()
        collect2.accumstackcards.removeAll()
        collect3.accumstackcards.removeAll()
        collect4.accumstackcards.removeAll()
        
        didWin = false
    }
    func dealExtras()
    {
   
        extrastack.thestack.removeAll()
        extrastack.thestack.append( theDeck.nextCard())
        extrastack.thestack[0].isFaceUp = false
        extrastack.thestack[0].location = 800
        extrastack.thestack[0].topcard = true
       
        extrastack.thestack.append( theDeck.nextCard())
        extrastack.thestack[1].isFaceUp = false
        extrastack.thestack[1].location = 801
        extrastack.thestack[1].topcard = true
        
        extrastack.thestack.append( theDeck.nextCard())
        extrastack.thestack[2].isFaceUp = false
        extrastack.thestack[2].location = 802
        extrastack.thestack[2].topcard = true
        
    }
}



// card stacks  - will have face down cards and face up cards on top.. 7 stacks total. can have 0 cards in the stack
public class  cardstack: ObservableObject  {
    //let id = UUID()
     @Published var thestack :[PlayingCard] = []
     @Published var acard:PlayingCard
 
    
    var stacknumber = 0
  
    
    init(stacknum:Int, myDeck: PlayingCardDeck) {
        var cardcount = 1
        var location = 0
        stacknumber = stacknum
        acard = PlayingCard()
        
        //print("creating stack " + String(stacknumber))
        if (stacknum < 8)
        {
            while cardcount < stacknumber {
                acard = myDeck.nextCard()
                acard.location = stacknum*100 + location
                addfacedowncard(acard: acard)
                cardcount += 1
                location += 1
            }
            cardcount = 0
            while cardcount < stacknumber {
                acard = myDeck.nextCard()
                acard.location = stacknum*100 + location
                addfaceupcard(acard: acard)
                //print("faceup card" + acard.toString())
                cardcount += 1
                location+=1
            }
            thestack[location-1].topcard=true
        }
        else
        {
            //3 extra cards
            acard = myDeck.nextCard()
            acard.topcard = true
            acard.location = 800
            thestack.append(acard)
            acard = myDeck.nextCard()
            acard.topcard = true
            acard.location = 801
            thestack.append(acard)
            acard = myDeck.nextCard()
            acard.topcard = true
            acard.location = 802
            thestack.append(acard)
        }
        
    }
    
    
 /*   public static func == (lhs: cardstack, rhs: cardstack) -> Bool {
        print("checking cardstack ==")
        return( false)
    }
  */
 
    func flipcard() {
        self.acard.flipcard()
    }
    func addfaceupcard(acard :PlayingCard )
    {
        
        acard.isFaceUp = true
        acard.topcard = false
        thestack.append(self.acard)
    }
  func addfacedowncard(acard:PlayingCard )
    {
        
        acard.isFaceUp = false
        acard.topcard = false
     
        thestack.append(self.acard)
    }
 /*   func getstack() -> [PlayingCard]
    {
        return thestack
    }*/
}

// Accumulation stacks for collecting cards in sequencial order lowest to highest by suit
class accumStack :ObservableObject, Equatable
{
     @Published var accumstackcards :[PlayingCard] = []
    @State var stackcard:PlayingCard
    var accStackNum = 0
    var suit:String
  
    init(stacknum:Int )
    {
        //var cardcount = 1
        accStackNum = stacknum
        stackcard = PlayingCard()
        suit = ""

    }
    
    static func == (lhs: accumStack, rhs: accumStack) -> Bool {
      
        return (  lhs.accumstackcards.count == rhs.accumstackcards.count)
       
    }
    func setSuit(stackSuit: String)
    {
        suit = stackSuit
    }
    func canAddtostack(newcard:PlayingCard) -> Bool
    {
       
        if (accumstackcards.isEmpty)
        {
            if( newcard.isAce && newcard.isFaceUp)
            {
                return true
            }
        } else if ( accumstackcards.count == newcard.getRank()-1 && self.suit == newcard.getCardSuit() && newcard.isFaceUp)
        {
            return true
        }
        
        return false
    }
    func addCard(newcard: PlayingCard)
    {
    
        if (canAddtostack(newcard: newcard))
        {
            newcard.isFaceUp = true
            accumstackcards.append(newcard)
        }
    }
}

