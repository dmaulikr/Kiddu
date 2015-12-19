//
//  AnswersViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 26/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit

extension AnswersViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        return self.tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        let cell : AnswerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AnswerTableViewCELL", forIndexPath: indexPath) as! AnswerTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.answeredBy.text = self.tableViewDataSource[indexPath.row].answer_userName
        cell.answerLabel.text = self.tableViewDataSource[indexPath.row].answer
        cell.totalUpVotes.text = "\(self.tableViewDataSource[indexPath.row].totalUpVote)"
        
        return cell
    }
}

extension AnswersViewController : UITableViewDelegate {
    
}

struct AnswerTableViewDatSource {
    
    var answer_userID : String = String()
    var answer_userName : String = String()
    var answer : String = String()
    var totalUpVote : Int = Int()
    var questionID : String = String()
}

class AnswersViewController : UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAnswers: UILabel!
    @IBOutlet weak var addAnAswer: UIButton!
    
    //MARK: Local Variables
    
    let parseAnswerHelperObject : ParseAnswersHelper = ParseAnswersHelper()
    var tableViewDataSource : [AnswerTableViewDatSource] = []
    
    var questionID : String = String()
    var question : String = String()

    override func viewWillAppear(animated: Bool) {
        
        self.parseAnswerHelperObject.getUpdatedQuestionsForTheQuestion(self.questionID) { success, objects in
            
            if success
            {
                self.tableViewDataSource = objects.reverse()
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableView.reloadData()
                })
            }
            else
            {
                self.tableViewDataSource = []
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAnAswer.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.addAnAswer.titleLabel?.textAlignment = NSTextAlignment.Center
        self.addAnAswer.setTitle("\u{f067}", forState: UIControlState.Normal)
        self.addAnAswer.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        self.questionLabel.text = self.question
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Outlets
    
    @IBAction func AddAnAnswerClicked(sender: UIButton) {
       
    }
}














