//
//  GameData.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 24/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import Foundation
import UIKit

struct Claim {
    var name: String
    var sentence: String
    var truthfulness: Bool
}

class GameData {
    
    var gameID = ""
    
    var userName = ""
    
    var claimCount = 0
    var claimList: [Claim] = []
    
    var scores: [String: Int] = [:]
    
    var players: [String] {
        get{
            return Array(scores.keys)
        }
    }
    
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
        
        return claimList.remove(at: dice)
        
    }
    
    func diceRoll() -> Int {
        
        return Int(arc4random_uniform(UInt32(claimCount)))
    }
    
    func populateScoresArrayWithNames(claimList: [Claim]){
        
        for claim in claimList {
            scores[claim.name] = 0
        }
    }
    
    func addPoint(name: String){
        if let score = scores[name]{
            scores[name] = score + 1
        }
    }
    
    func addYilanPoint(name: String){
        if let score = scores[name]{
            scores[name] = score + 2
        }
    }
    
    func subtractPoint(name: String){
        if let score = scores[name]{
            scores[name] = score - 1
        }
    }
    
    
    func addPlayer(name: String) {
        scores[name] = 0
    }
    
    func clear() {
        scores = [:]
        claimList = []
        claimCount = 0
    }
    
    
}
