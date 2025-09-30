//
//  ContentView.swift
//  gransol
//
//  Created by Little Shoes Software Solutions on 6/14/23.

//  Copyright © 2023 All rights reserved.

import SwiftUI
import UIKit

struct ContentView: View ,CardDelegate{
    
   @StateObject var gm = GameModel()
    @State var screenSize: CGSize = .zero
    
    
    var body: some View {
        
        // determine the type of device
        GeometryReader { proxy in
            ZStack
            {
                Image( "newbackground")
                    .resizable()
                    .scaledToFill()
                //.edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                // collections and extras
                
                VStack
                {
                    Spacer().frame(height: 10, alignment: .top) // avoiding the safe area to stop background bleedthrough
                    HStack
                    {
                        Spacer().frame(width: 75, height:25)
                        HStack
                        {
                            
                            
                            CollectionView( bstack: gm.collect1, screenSize: screenSize)
                                .onChange(of: gm.collect1, {gm.checkForWin()})
                                
                            
                            
                            CollectionView( bstack: gm.collect2, screenSize: screenSize)
                                .onChange(of: gm.collect2,  {gm.checkForWin()
                                })
                            CollectionView(bstack: gm.collect3, screenSize: screenSize)
                                .onChange(of: gm.collect3, {gm.checkForWin()
                                })
                            CollectionView(bstack: gm.collect4, screenSize: screenSize)
                                .onChange(of: gm.collect4, { gm.checkForWin()
                                })
                        }
                        .alignmentGuide(VerticalAlignment.top) { _ in 10}
                        .frame(width: (screenSize.width / 7.7)  , height: 25, alignment: .trailing)
                        
                        Spacer().frame(width: 15, height:75)
                        HStack
                        {
                            ExtraView(bstack: gm.extrastack, delegate: self, screenSize: screenSize)//.background(Color.clear)
                            
                        }.background(Color.clear)
                            .onTapGesture{
                                gm.flipExtras()
                            }.alignmentGuide(VerticalAlignment.top) { _ in 10}//.background(Color.clear)
                            .frame(width: screenSize.width / 7.7 , height:25, alignment: .leading )
                        
                        Spacer().frame( width: 15, height:75)
                        
                    }.frame( width: screenSize.width , height:screenSize.width / 8.0 + 30, alignment: .top)
                    .alignmentGuide(VerticalAlignment.top) { _ in 10}
                    
                  
                    
                    HStack{
                        
                        if (gm.didWin)
                        {
                            Spacer()
                            VStack
                            {
                                WinnerView()
                            }
                            
                            Spacer()
                        }
                        else
                        // stack 1 position
                        {
                            //  Spacer()
                            
                            VStack
                            {
                                StackView(
                                    bstack: gm.stack1, delegate:self , screenSize: screenSize)
                            }.frame(width: screenSize.width / 8.0 , height: 150 , alignment: .topLeading )
                                .alignmentGuide(VerticalAlignment.top, computeValue: { dimension in
                                    150.0
                                })
                            
                            //stack 2
                            VStack {
                                StackView(bstack: gm.stack2,delegate:self, screenSize: screenSize)
                                
                            }.frame(width: screenSize.width / 8.0 ,
                                    height:150, alignment: .topLeading )
                            
                            //stack 3
                            VStack {
                                
                                StackView( bstack: gm.stack3, delegate:self , screenSize: screenSize)
                                
                            }
                            .frame(width: screenSize.width / 8.0 , height:150, alignment: .topLeading )
                            
                            //stack4
                            VStack{
                                // StackView(astack: cardstack4.thestack)
                                StackView( bstack: gm.stack4,delegate:self, screenSize: screenSize)
                                
                            }.frame(width: screenSize.width / 8.0 , height:150, alignment: .topLeading )
                            
                            //stack 5
                            VStack{
                                
                                StackView(bstack: gm.stack5,delegate:self, screenSize: screenSize)
                                
                                    .frame(width: screenSize.width / 8.0 , height:150, alignment: .topLeading )
                            }
                            
                            //stack 6
                            VStack{
                                
                                
                                StackView( bstack: gm.stack6,delegate:self, screenSize: screenSize)
                                
                                
                                    .frame(width: screenSize.width / 8.0 , height:150, alignment: .topLeading )
                            }
                            //stack7
                            VStack{
                                StackView(bstack: gm.stack7,delegate:self, screenSize: screenSize)
                                
                                    .frame(width: screenSize.width / 8.0 , height:150, alignment: .topLeading )
                            }
                            
                        }
                        
                        
                    }
                    .frame(width: screenSize.width, height:150, alignment: .topLeading )
                    
                    
                    Spacer().frame(height: 450)
                    
                    // stack for the buttons
                    VStack{
                        
                        
                        HStack{
                            Button(action: {
                                gm.deal()
                                
                            }) {
                                Text("Start Game")
                                    .padding()
                                    .foregroundColor(.red)
                                    .font(.system(size: 25)
                                    )
                                    .background(Color.yellow)
                            }
                            
                            .border(Color.black, width: 1)
                            
                            
                        }
                        
                    }.alignmentGuide(VerticalAlignment.bottom, computeValue: { dimension in
                        30.0
                    })
                    .frame(width: screenSize.width, height:01, alignment: .bottomLeading)
                    
                    
                    Spacer().frame( height: 10) //bottom edge after button
                }
                
                
            }.frame(width : proxy.size.width, height: proxy.size.height, alignment: .top)
                .overlay( GeometryReader { proxy in
                    Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)})
                .onPreferenceChange(SizePreferenceKey.self) { value in screenSize = value }
            //Spacer().frame( height: 30) //bottom edge after button
        }  //end zstack
        
        .ignoresSafeArea(.all)
    }
    



    struct SizePreferenceKey:PreferenceKey
    {
        static var defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue:() -> CGSize)
        {
            value = nextValue()
        }
    }

    func cardtapped(cardloc:Int)
    {
       
        let card = gm.findCard(cardLoc: cardloc)
      
        var location = cardloc
        var didAccum = gm.accumulate(fromStack: location)
        if (didAccum)
        {
               
            while ( (location % 100 != 0) && didAccum  )
            {
                location -= 1
                didAccum = gm.accumulate(fromStack: location)
                
              
                
            }
            
             gm.checkForWin()
        }
        
           else if (card.isKing)
            {
               
                gm.moveKing(cardloc, moveCard: card)
            }
            else
            {
                gm.moveCard(cardloc, moveCard: card)
            }
        }
        
      
    
}

struct ExtraView : View , CardDelegate{
    
  
    @ObservedObject var bstack: cardstack
  
    
    var delegate : CardDelegate?
    var screenSize: CGSize
    
    var body: some View {
        //need to get the state monitor on the stack....
        
        HStack {
           
            ForEach(bstack.thestack.indices, id: \.self)
            {
           
                // check for topcard and flip
                CardView(card: bstack.thestack[($0)], delegate:self,front: bstack.thestack[($0)].isFaceUp, screenSize: screenSize )
            
           }
            
        }

    }
    func cardtapped(cardloc:Int)
    {
       
        delegate?.cardtapped(cardloc: cardloc)
    }

}

protocol CardDelegate{
    func cardtapped(cardloc:Int)
}

struct StackView : View , CardDelegate{
    
    @ObservedObject var bstack: cardstack
   
    
    var delegate : CardDelegate?
    var screenSize: CGSize
    
    var body: some View {
        
        
        VStack {
           
            ForEach(bstack.thestack.indices, id: \.self)
            {
           
                //  check for topcard and flip
                if(bstack.thestack[($0)].isFaceUp )
                {
                    CardView(card: bstack.thestack[($0)], delegate:self,front: bstack.thestack[($0)].isFaceUp, screenSize: screenSize ).frame(width: screenSize.width / 7.7 , height:25, alignment: .topLeading )
                    
            
                }
                else
                {
                   
                    CardView(card: bstack.thestack[($0)], delegate:self,front: bstack.thestack[($0)].isFaceUp, screenSize: screenSize ).frame(width: screenSize.width / 7.7 , height:1, alignment: .topLeading )
                       
                    }
   
           }
            
        }
      
    }
  
    func cardtapped(cardloc:Int)
    {
       
        delegate?.cardtapped(cardloc: cardloc)
    }
   
}
 
struct CollectionView : View {
   
    @ObservedObject var bstack : accumStack
    var screenSize: CGSize
    var body: some View {
         
            ZStack{
                if (bstack.accumstackcards.isEmpty){
                Text("Collections")
        
                }
                else
                {
                    ForEach(bstack.accumstackcards.indices,id: \.self)
                    {
                        CardView(card: bstack.accumstackcards[($0)], front: true , screenSize: screenSize)
                      
                    }
                }
            }
            .frame(width: screenSize.width / 7.7 , height: screenSize.width / 7.7 + 30.0, alignment: .center)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
        }
}


struct WinnerView: View {
   
    
    var body: some View {
        
        ZStack{
            Text("Congratulations\n\n")
                
            Text("You are a WINNER!")
        }
        .font(.title)
        .frame(width: 350, height: 150, alignment: .center)
        .background(Color.purple)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
   
    }
}

// Display a card
struct CardView:  View {
     @ObservedObject var card:PlayingCard //needs to be observed object
    @State var suit : String = " " //@State
    @State  var theSuit = "" //@State
   
    var delegate : CardDelegate?
    
    @State var front : Bool
    var screenSize: CGSize
    
    var body: some View {
    
        
       let theRank =  card.getCardRank()
       let  theSuit = card.getCardSuit()
        
        if ( card.isFaceUp )
        {
          
            VStack
            {
                if (screenSize.width < 420.0 )
                {
                    
                        Text( " " +  theRank + "  " + theSuit)
                            .font(.subheadline).frame(width: screenSize.width / 7.7, height:12.0, alignment: .center)
                }
                else
                {
                    Text(" " +  theRank + "  " + theSuit)
                        .font(.subheadline).frame(width: screenSize.width / 7.7, height:12.0, alignment: .center)
                }
                  
            
                Text(  theRank )
                    
                   
                    //.font(.title )
                    .font(.system(size: 20))                    .frame(width: screenSize.width / 7.7, height: screenSize.width > CGFloat(800.0) ? screenSize.width / 10.0 : screenSize.width / 14.0 , alignment: .center)
                                      
                  
                  
                if (screenSize.width < 420.0 )
                {
                    Text(theSuit + "  " + theRank )
                       // .font(.subheadline)
                        .font(.system(size: 15))
                        .frame(width: screenSize.width / 7.7, height:12.0, alignment: .center)
                }
                else
                {
                    Text(theSuit + "  " + theRank )
                        .font(.subheadline).frame(width: screenSize.width / 7.7, height:12.0, alignment: .center)
                }
              
            }
            .frame(width: screenSize.width / 7.7, height:  screenSize.width / 7.7 + 30.0)
                .background(Color.white)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(card.getSuitColor()))
                .onTapGesture {
                delegate?.cardtapped(cardloc: card.location)
               }
            
         }
        
        else
        {
            VStack{
                Image ("PlayingCard-back")
                 .resizable()// check that I want this
                    .frame(width: screenSize.width / 7.7, height: screenSize.width / 8.0 + 25.0)
            }
            .onChange(of: card.topcard,  {
                card.isFaceUp = true
            })
        }
    }
        
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        
            ContentView()
   
        }
    }
}

