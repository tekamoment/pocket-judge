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

enum InfoState: Int {
    case Process = 5, Metrics = 8
}

class HomeViewController: UIViewController {
    let realm = try! Realm()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leftHomeButton: UIButton!
    @IBOutlet weak var rightHomeButton: UIButton!
    @IBOutlet weak var processMetricsControl: UISegmentedControl!
    var infoState = InfoState.Process
    var currentPresented = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        view.layer.insertSublayer(CAGradientLayer.pocketJudgeBackgroundGradientLayer(view.bounds), atIndex: 0)
        print(Realm.Configuration.defaultConfiguration.path!)
        
        textView.backgroundColor = UIColor.clearColor()
        textView.userInteractionEnabled = false
        textView.attributedText = applyTextViewAttributedMessageAndDictionary("Welcome to Pocket Judge! \nThe raddest decision-making app for the everyday indecisive. \n \nClick on the arrow to learn more about our decision-making process!")
        textView.textColor = UIColor.whiteColor()
        leftHomeButton.alpha = 0.0
        leftHomeButton.enabled = false
        
        let segmentedFont = UIFont(name: "Cassannet-Bold", size: 27.0)
        
        processMetricsControl.tintColor = UIColor.whiteColor()
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: segmentedFont!], forState: [.Normal, .Selected, .Highlighted])
        
//        processMetricsControl.setTitleTextAttributes([NSFontAttributeName: segmentedFont!], forState: [.Normal, .Selected, .Highlighted])
        
        processMetricsControl.setBackgroundImage(UIImage(named: "SegmentedButtonBackground"), forState: .Normal, barMetrics: .Default)
        processMetricsControl.setBackgroundImage(UIImage(named: "SegmentedButtonDivider"), forState: [.Selected, .Highlighted], barMetrics: .Default)
        
        
        processMetricsControl.setDividerImage(UIImage(named: "SegmentedButtonDivider"), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
        processMetricsControl.setDividerImage(UIImage(named: "SegmentedButtonDivider"), forLeftSegmentState: [.Highlighted, .Selected], rightSegmentState: .Normal, barMetrics: .Default)
        processMetricsControl.setDividerImage(UIImage(named: "SegmentedButtonDivider"), forLeftSegmentState: .Normal, rightSegmentState: [.Highlighted, .Selected], barMetrics: .Default)


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
        } else if (segue.identifier == "OldDecisionsSegue") {
            let decisionViewController = segue.destinationViewController as! DecisionViewController
            decisionViewController.decisionState = .ExistingDecisionsState
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
        
        self.performSegueWithIdentifier("OldDecisionsSegue", sender: nil)
        print("Old buttons tapped")
        
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
    
    @IBAction func leftHomeButtonTapped(sender: AnyObject) {
        if currentPresented > 1 {
            currentPresented = currentPresented - 1
            rightHomeButton.alpha = 1.0
            rightHomeButton.enabled = true
        } else {
            leftHomeButton.alpha = 0.0
            leftHomeButton.enabled = false
        }
        switchDisplayedText()
    }
    
    @IBAction func rightHomeButtonTapped(sender: AnyObject) {
        if currentPresented < infoState.rawValue {
            currentPresented = currentPresented + 1
            if currentPresented == infoState.rawValue {
                rightHomeButton.alpha = 0.0
                rightHomeButton.enabled = false
            }
            leftHomeButton.alpha = 1.0
            leftHomeButton.enabled = true
        } else {
            rightHomeButton.alpha = 0.0
            rightHomeButton.enabled = false
        }
        switchDisplayedText()
    }
    
    
    @IBAction func processMetricsSwitchPressed(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: infoState = .Process
        case 1: infoState = .Metrics
        default: break
        }
        currentPresented = 1
        leftHomeButton.alpha = 0.0
        leftHomeButton.enabled = false
        rightHomeButton.alpha = 1.0
        rightHomeButton.enabled = true
        switchDisplayedText()
    }
    
    func switchDisplayedText(){
        if self.infoState == .Process {
            switch currentPresented {
            case 1: textView.attributedText = applyTextViewAttributedMessageAndDictionary("Welcome to Pocket Judge! \nThe raddest decision-making app for the everyday indecisive. \n \nClick on the arrow to learn more about our decision-making process!")
            case 2: textView.attributedText = applyTextViewAttributedMessageAndDictionary("How does Pocket Judge work? \n \nPocket Judge is here to help you arrive at a decision by showing you which one among your options will make you most happy!")
            case 3: textView.attributedText = applyTextViewAttributedMessageAndDictionary("Begin a decision by clicking on NEW DECISION and then typing in a name. Following that, list down your options, and then rate them afterwards with the Pocket Judge happiness matrix!")
            case 4: textView.attributedText = applyTextViewAttributedMessageAndDictionary("DISCLAIMER:\n \nMatters legal, technical, or moral are not covered by this app. For such instances, please refer to common sense instead.")
            case 5: textView.attributedText = applyTextViewAttributedMessageAndDictionary("Click on METRICS to learn more about the mechanics of this app.\n \nClick on PAST DECISIONS to review or re-appraise previous decisions.")
            default: break
            }
        } else {
            switch currentPresented {
            case 1: textView.attributedText = applyTextViewAttributedMessageAndDictionary("This app uses a modified version of Utilitarianism’s hedonic calculus.\n \nBasically, what that means is it makes use of seven parameters to determine how happy something will make you.")
            case 2: textView.attributedText = applyTextViewAttributedMessageAndDictionary("The seven (modified) parameters that determine an option’s ‘utility’ or happiness are: \n \npreference, duration, certainty, closeness, productiveness, cost, and socialness")
            case 3:
                textView.attributedText = attributedMessageWithInterspersedImage("Preference + Duration, determine the magnitude of the happiness. \n\n", secondFragment: "\n\nHow happy a choice will make you, and for how long.", image: UIImage(named: "ThumbsPlusClock")!)
                
            case 4: textView.attributedText = attributedMessageWithInterspersedImage("Certainty + Closeness, determine the tendency of the happiness. \n \n", secondFragment: "\n\nHow sure and how soon it can make you happy.", image: UIImage(named: "DicePlusSeparatedDots")!)
                
            case 5: textView.attributedText = attributedMessageWithInterspersedImage("Productiveness - Cost, compute the value of the happiness.\n \n", secondFragment: "\n \nWhat you’ll gain minus what you’ll lose.", image: UIImage(named: "GearsMinusPriceTag")!)

            case 6: textView.attributedText = attributedMessageWithInterspersedImage("Finally, there’s Socialness, \n \n", secondFragment: "\n \nHow the way other people feel might affect your happiness.", image: UIImage(named: "SocialnessWhite")!)
                
            case 7: textView.attributedText = applyTextViewAttributedMessageAndDictionary("Once you're done, the app will then utilize your smart device’s cutting edge technology to perform basic math and determine the final values of each option.")
                
            case 8: textView.attributedText = attributedMessageWithInterspersedImage("", secondFragment: "\n\nAnd there you have it, the Pocket Judge happiness matrix!", image: UIImage(named: "FinalEquation")!)

            default: break
            }
        }
    }
    
    func applyTextViewAttributedMessageAndDictionary(message: String) -> NSMutableAttributedString {
        let paragraphSpacingAttribute = NSMutableParagraphStyle()
        paragraphSpacingAttribute.lineSpacing = 0.0
        paragraphSpacingAttribute.maximumLineHeight = 20.0
        paragraphSpacingAttribute.alignment = .Left
        
        let spacedMessage = "\(message)"
        let messageAttributeDictionary = [NSFontAttributeName: UIFont(name: "TeXGyreAdventor-Regular", size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(),  NSParagraphStyleAttributeName: paragraphSpacingAttribute]
       return NSMutableAttributedString(string: spacedMessage, attributes: messageAttributeDictionary)
    }
    
    func attributedMessageWithInterspersedImage(firstFragment: String, secondFragment: String?, image: UIImage) -> NSMutableAttributedString {
        let firstApplied = applyTextViewAttributedMessageAndDictionary(firstFragment)
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let imageString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        firstApplied.appendAttributedString(imageString)
        if secondFragment != nil {
            firstApplied.appendAttributedString(applyTextViewAttributedMessageAndDictionary(secondFragment!))
        }
        
        firstApplied.enumerateAttribute(NSAttachmentAttributeName, inRange: NSRange(location: 0, length: firstApplied.length), options: NSAttributedStringEnumerationOptions.Reverse) { (attribute, range, stop) -> Void in
            if (attribute as? NSTextAttachment) != nil {
                
                // this example assumes you want to center all attachments. You can provide additional logic here. For example, check for attachment.image.
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .Center
                firstApplied.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            }
        }
        return firstApplied
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
