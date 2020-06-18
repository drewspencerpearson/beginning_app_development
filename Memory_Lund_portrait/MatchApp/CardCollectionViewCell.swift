//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Drew Pearson on 5/8/20.
//  Copyright © 2020 Drew Pearson. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var FrontImageView: UIImageView!
    
    @IBOutlet weak var BackImageView: UIImageView!
    
    var card:Card?
    
    
    func configureCell(card:Card) {
        
        //keep track of the card this cell represents
        self.card = card
        
        // Set the front image view to the image that represents the card
        FrontImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        if card.isMatched == true {
            BackImageView.alpha = 0
            FrontImageView.alpha = 0
            return
        }
        else {
            BackImageView.alpha = 1
            FrontImageView.alpha = 1
        }
        if card.isFlipped == true {
            // Show the front image view
            flipUp(speed: 0)
            
        }
        else{
            // Show the back image view
            flipDown(speed: 0, delay:0)
            
        }
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        
        // flip up animation
        UIView.transition(from: BackImageView, to: FrontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        //set status of card
        card?.isFlipped = true
        
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        
            UIView.transition(from: self.FrontImageView, to: self.BackImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            
            
        }
        card?.isFlipped = false
        
    }
    
    func remove(){
        
        // make the image views invisible
        BackImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.FrontImageView.alpha = 0
            
        }, completion: nil)
    }
}
