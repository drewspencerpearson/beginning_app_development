//
//  SoundManager.swift
//  MatchApp
//
//  Created by Drew Pearson on 5/11/20.
//  Copyright © 2020 Drew Pearson. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
            case .flip:
                soundFilename = "cardflip"
            case .match:
                soundFilename = "dingcorrect"
            case .nomatch:
                soundFilename = "dingwrong"
            case .shuffle:
                soundFilename = "shuffle"
        }
        
        // get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // Check that it's not nill
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        // trying to do something, may throw an error. If it does, we catch it
        do {
            // create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            //play the sound
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
        
        
    }
}
