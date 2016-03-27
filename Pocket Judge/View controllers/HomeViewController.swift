//
//  HomeViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Colours
import RealmSwift

class HomeViewController: UIViewController {
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        view.layer.insertSublayer(CAGradientLayer.pocketJudgeBackgroundGradientLayer(view.bounds), atIndex: 0)
        print(Realm.Configuration.defaultConfiguration.path!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "NewDecisionSegue") {
            // pop up an alert asking for a name!
            let decisionViewController = segue.destinationViewController as! DecisionViewController
            decisionViewController.decision = sender as? Decision
            decisionViewController.decisionState = .OptionsState
        }
    }
    
    @IBAction func newDecisionTapped(sender: AnyObject) {
        let newDecisionAlertController = UIAlertController(title: "New Decision", message: "Enter the name of your new decision.", preferredStyle: .Alert)
        
        let saveNameAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            let nameTextField = newDecisionAlertController.textFields![0] as UITextField
            self.createNewDecision(nameTextField.text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        newDecisionAlertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Decision name"
        }
        
        newDecisionAlertController.addAction(saveNameAction)
        newDecisionAlertController.addAction(cancelAction)
        
        presentViewController(newDecisionAlertController, animated: true, completion: nil)
    }
    
    
    @IBAction func oldDecisionsTapped(sender: AnyObject) {
        guard realm.objects(Decision).count > 0 else {
            let noExistingDecisionsController = UIAlertController(title: "No decisions", message: "There are no decisions stored.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (_) in })
            noExistingDecisionsController.addAction(cancelAction)
            presentViewController(noExistingDecisionsController, animated: true, completion: nil)
            return
        }
        
        // segue here to old decisions
        
    }
    
    func createNewDecision(name: String?) {
        guard name != nil || (name?.isEmpty)! else {
            return
        }
    
        let newDecision = Decision(name: name!)
        
        do {
            try realm.write({
                self.realm.add(newDecision)
            })
        } catch {
            print("Welp. An exception.")
        }
        
        self.performSegueWithIdentifier("NewDecisionSegue", sender: newDecision)
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
