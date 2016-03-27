//
//  HomeViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Colours

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        view.layer.insertSublayer(CAGradientLayer.pocketJudgeBackgroundGradientLayer(view.bounds), atIndex: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "NewDecisionSegue") {
            let decisionViewController = segue.destinationViewController as! DecisionViewController
            decisionViewController.decision = Decision(name: "DECISION NAME")
            decisionViewController.decisionState = .OptionsState
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
