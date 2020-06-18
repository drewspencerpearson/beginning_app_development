//
//  ViewController.swift
//  MatchApp
//
//  Created by Drew Pearson on 5/8/20.
//  Copyright © 2020 Drew Pearson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
        
    @IBOutlet weak var timerLabel: UILabel!
    
   
    
    
    let alert = UIAlertController(title: "How many Seconds do you want on the clock?", message: nil, preferredStyle: .alert)
    
    
    
    var model = CardModel()
    var cardsArray = [Card]()
    
    //self.test:String = "test"
    
    var timer:Timer?
    var milliseconds:Int = 5 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer:SoundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(milliseconds)
        
        // Get the cards
        cardsArray = model.getCards()
        
        // Set view controller as datasource and delegate of collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let seconds = self.alert.textFields?.first?.text {
                print("Seconds: \(seconds)")
            }
        }))
        
        //present(alert, animated: true, completion: nil)
        
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        // Decrement the counter
        self.milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches 0
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
        }
        
        // TODO: check if the user has cleared all the pairs
        checkForGameEnd()
        
    }
    
    // MARK: - Collection view Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //return the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties on the card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // get the card from the cardsArray
        let card = cardsArray[indexPath.row]
        
        // configure cell
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        // Check if there's any time remaining. Don't let the user interact if there is no time
        if milliseconds <= 0 {
            return
        }
        
        // get a  reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // if the cell turns up to be nill and not be a card collection view, we don't flip.
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card or second card flipped
            if firstFlippedCardIndex == nil {
                // THis is the first card flipped over
                
                firstFlippedCardIndex = indexPath
            }
            else {
                // second flipped card
                
                // run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }

    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //compare the two
        if cardOne.imageName == cardTwo.imageName {
            // It is a match.
            
            // Play sound
            soundPlayer.playSound(effect: .match)
            //set the statues and remove
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was that the last pair?
            checkForGameEnd()
            
        }
            
        else {
            // It's not a match
            
            // Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    

    func checkForGameEnd() {
        
        // Check if there's any card that is unmatched
        // Assume user has won, loop through all cards to see if all are matched
        var hasWon = true
        
        for card in cardsArray{
            if card.isMatched == false{
                // we found an unmatched card
                hasWon = false
                break
            }
        }
        
        if hasWon == true{
            
            // user has won, show an alert
            showAlert(title: "Congratulations!", message: "You have won the game!")
            timerLabel.textColor = UIColor.blue
            timer?.invalidate()
        }
        else{
            // user hasn't won yet, check if there's any time left
            if milliseconds <= 0 {
                showAlert(title: "Time's up!", message: "Better luck next time")
            }
            
        }
        
    }
    
    func showAlert(title:String, message:String) {
        //creat the alert
        let alert = UIAlertController(title: title, message: "Do you want to play again?", preferredStyle: .alert)
        
        // add a button for the user to dismiss the alert
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.replay()
            
            
            
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        // add the button and show the alert
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func replay() {
        //let storyboard = UIStoryboard(name:"Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        //var viewcontrollers = self.navigationController?.viewControllers
        //self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        //viewcontrollers?.removeLast()
        //viewcontrollers?.append(vc)
        //self.navigationController?.viewControllers = [self]
        //ViewController.init()
        self.timer?.invalidate()
        print (self.milliseconds)
        self.milliseconds = 5 * 1000
        print (self.milliseconds)
        self.model = CardModel()
        self.cardsArray = [Card]()
        //firstFlippedCardIndex:IndexPath?
        viewDidLoad()
        
        
        
        //print ("test")
        //
        //let model = CardModel()
        //var cardsArray = [Card]()
        
        //self.timer:Timer?
        //var milliseconds:Int = 5 * 1000
        
        //var firstFlippedCardIndex:IndexPath?
        // Get the cards
        cardsArray = model.getCards()
        //viewDidLoad()
        
        // Initialize the timer
        //self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        //RunLoop.main.add(timer!, forMode: .common)
        
    }
}

