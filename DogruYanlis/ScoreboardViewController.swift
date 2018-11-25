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

class MyButton: UIButton {
    
    var tagString: String?
    
}

class ScoreboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTable.dataSource = self
        leaderboardTable.delegate = self
        
    }
    
    let greenColor = UIColor( red: 18/255, green: 136/255, blue: 2/255, alpha: 1.0 )
    
    weak var delegate: ScoreboardDelegate? = nil
    
    var scoreData: [String: Int]? = nil
    
    @IBOutlet weak var leaderboardTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let nameLabel = UILabel(frame: CGRect(x:25, y:0, width:100, height:50))
        let scoreLabel = UILabel(frame: CGRect(x:300, y:0, width: 50, height: 50))
        
        let names = Array(scoreData!.keys)
        
        let addSinglePointButton = MyButton(frame: CGRect(x: 320, y: 0, width: 50, height: 50))
        let subtractSinglePointButton = MyButton(frame: CGRect(x: 240, y: 0, width: 50, height: 50))
        
        subtractSinglePointButton.setTitle("-", for: .normal)
        subtractSinglePointButton.setTitleColor(greenColor, for: .normal)
        subtractSinglePointButton.tagString = names[indexPath.row]
        subtractSinglePointButton.addTarget(self, action: #selector(ScoreboardViewController.minusPressed(sender:)), for: .touchUpInside)
        
        addSinglePointButton.setTitle("+", for: .normal)
        addSinglePointButton.setTitleColor(greenColor, for: .normal)
        addSinglePointButton.tagString = names[indexPath.row]
        addSinglePointButton.addTarget(self, action: #selector(ScoreboardViewController.pressed(sender:)), for: .touchUpInside)

        nameLabel.text = names[indexPath.row]
        scoreLabel.text = "\(scoreData![names[indexPath.row]]!)"
        
        cell.addSubview(scoreLabel)
        cell.addSubview(nameLabel)
        cell.addSubview(subtractSinglePointButton)
        cell.addSubview(addSinglePointButton)
       
        return cell
    }
    
    //Table height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func pressed(sender: MyButton!){
        let playerName = sender.tagString!
        scoreData![playerName]! += 1
        delegate?.increaseUserScore(name: playerName, byScore: 1)
        self.leaderboardTable.reloadData()
    }
    
    @objc func minusPressed(sender: MyButton!){
        let playerName = sender.tagString!
        if(scoreData![playerName] ?? 0 > 0 ){
            scoreData![playerName]! -= 1
        }
        delegate?.increaseUserScore(name: playerName, byScore: -1)
        self.leaderboardTable.reloadData()
    }
    
}
