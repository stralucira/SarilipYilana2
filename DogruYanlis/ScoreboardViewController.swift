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
    
    weak var delegate: ScoreboardDelegate? = nil
    
    var scoreData: [String: Int]? = nil
    
    @IBOutlet weak var leaderboardTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreData!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        
        let cell = UITableViewCell()
        let nameLabel = UILabel(frame: CGRect(x:25, y:0, width:100, height:50))
        let scoreLabel = UILabel(frame: CGRect(x:300, y:0, width: 50, height: 50))
        
        let names = Array(scoreData!.keys)
        
        let addSinglePointButton = MyButton(frame: CGRect(x: 320, y: 0, width: 50, height: 50))
        let subtractSinglePointButton = MyButton(frame: CGRect(x: 240, y: 0, width: 50, height: 50))
        
        subtractSinglePointButton.setTitle("-", forState: .Normal)
        subtractSinglePointButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        subtractSinglePointButton.tagString = names[indexPath.row]
        subtractSinglePointButton.addTarget(self, action: #selector(ScoreboardViewController.minusPressed(_:)), forControlEvents: .TouchUpInside)

        
        addSinglePointButton.setTitle("+", forState: .Normal)
        addSinglePointButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addSinglePointButton.tagString = names[indexPath.row]
        addSinglePointButton.addTarget(self, action: #selector(ScoreboardViewController.pressed(_:)), forControlEvents: .TouchUpInside)

        nameLabel.text = names[indexPath.row]
        scoreLabel.text = "\(scoreData![names[indexPath.row]]!)"
        
        cell.addSubview(scoreLabel)
        cell.addSubview(nameLabel)
        cell.addSubview(subtractSinglePointButton)
        cell.addSubview(addSinglePointButton)
       
        return cell
    }
    
    //Table height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func pressed(sender: MyButton!){
        let playerName = sender.tagString!
        scoreData![playerName]! += 1
        delegate?.increaseUserScore(playerName, byScore: 1)
        self.leaderboardTable.reloadData()
    }
    
    func minusPressed(sender: MyButton!){
        let playerName = sender.tagString!
        if(scoreData![playerName] > 0 ){
            scoreData![playerName]! -= 1
        }
        delegate?.increaseUserScore(playerName, byScore: -1)
        self.leaderboardTable.reloadData()
    }
    
}
