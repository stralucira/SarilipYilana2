//
//  Scoreboard.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 29/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import Foundation

class Scoreboard {
    
    private var players = [String: Int]()
    
    func addPlayer(name: String) {
        
        players[name] = 0
        
    }
    
    func addPoint(name: String) {
        
        players[name]! += 1
        
    }
    
    func getScore(name: String) -> Int {
        
        return players[name]!
    }
    
}
