//
//  GameData.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 24/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import Foundation
import UIKit

class GameData {
    
    var claimCount = 0
    var claimList: [Claim] = []
    
    struct Claim {
    
        var name: String
        var sentence: String
        var truthfulness: Bool
        
    }
    
    
    func addClaim(senderName: String, sentence: String, truthfulness: Bool){
        
        let newClaim = Claim(name: senderName, sentence: sentence, truthfulness: truthfulness)
        
        claimList.append(newClaim)
        
        claimCount += 1
    }
    
    func randomClaim() -> Claim {
        
        let dice = diceRoll()
        
        claimCount -= 1
        
        return claimList.removeAtIndex(dice)
        
    }
    
    func diceRoll() -> Int {
        
        return Int(arc4random_uniform(UInt32(claimCount)))
    }
    

}