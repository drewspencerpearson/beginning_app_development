//
//  CardModel.swift
//  MatchApp
//
//  Created by Drew Pearson on 5/8/20.
//  Copyright © 2020 Drew Pearson. All rights reserved.
//

import Foundation


class CardModel {
    
    func getCards() -> [Card] {
        //Declare an empyty array
        var generatedCards = [Card]()
        var generatedNumbers = [Int]()
        //randomly generate 8 pairs of cards
        for _ in 1...8 {
            //Generate a random number
            var randomNumber = Int.random(in: 1...8)
            //ensure the random number was not already chosen
            while generatedNumbers.contains(randomNumber){
                
                randomNumber = Int.random(in: 1...8)
            }
            
            //create a two new card objects
            let cardOne = Card()
            let cardTwo = Card()
            
            //set their imagenames
            cardOne.imageName = "card\(randomNumber)"
            cardTwo.imageName = "card\(randomNumber)"
            
            //add them to the array
            generatedCards += [cardOne, cardTwo]
            generatedNumbers.append(randomNumber)
            
            print (randomNumber)
        }
        //Randomize the cards within the array
        generatedCards.shuffle()
        
        //Return the Array
        return generatedCards
    }
    
}
