//
//  ScoreboardViewController.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 06/08/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

protocol ScoreboardDelegate: class {
    
    func increaseUserScore(name: String, byScore: Int)
}

class ScoreboardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    weak var scoreboardDelegate: ScoreboardDelegate? = nil

}
