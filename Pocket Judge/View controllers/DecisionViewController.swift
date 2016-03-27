//
//  DecisionViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import RealmSwift

import SDCAlertView

class DecisionViewController: HeaderContainerViewController, UITextViewDelegate, UITableViewDelegate {
    let realm = try! Realm()
    var decision: Decision?
    var decisionState: DecisionState? {
        willSet(newDecisionState) {
            var buttonItems = [UIBarButtonItem]()
            
            guard newDecisionState != nil else {
                fatalError("Decision state cannot be set to nil")
            }
            
            switch newDecisionState! {
            case .OptionsState:
                buttonItems.append(UIBarButtonItem(image: UIImage(named: "InformationIcon"), style: .Plain, target: self, action: #selector(DecisionViewController.informationIconTapped)))
                fallthrough
            
            case .ExistingDecisionsState:
                buttonItems.append(UIBarButtonItem(image: UIImage(named: "SliderIcon"), style: .Plain, target: self, action: #selector(DecisionViewController.sliderIconTapped)))
            }
            
            self.navigationItem.rightBarButtonItems = buttonItems
        }
    }
    var headerImageName: String {
        get {
            switch decisionState! {
            case .OptionsState:
                return "JudgeProfile"
                
            case .ExistingDecisionsState:
                return "StenographerProfile"
            }
        }
    }
    var decisionsTableController: UITableViewController?
    var tableViewDataSource: UITableViewDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(decision: Decision?) {
        if decision != nil {
            self.decision = decision!
            decisionState = .ExistingDecisionsState
        } else {
            decisionState = .OptionsState
        }
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerTitleView.text = decision!.name.uppercaseString
        characterImageView.image = UIImage(named: headerImageName)!
        
        decisionsTableController = UITableViewController(style: .Plain)
        self.addChildViewController(decisionsTableController!)
        decisionsTableController!.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        containerView.addSubview(decisionsTableController!.view)
//        decisionsTableController!.view.frame = containerView.frame
        decisionsTableController!.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        decisionsTableController!.didMoveToParentViewController(self)
        
        decisionsTableController!.tableView.registerNib(UINib(nibName: "OptionCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "OptionCell")
        decisionsTableController!.tableView.registerNib(UINib(nibName: "MetricHeader", bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: "OptionFooter")
        
        decisionsTableController!.tableView.rowHeight = UITableViewAutomaticDimension
        decisionsTableController!.tableView.estimatedRowHeight = 50
        
        decisionsTableController!.tableView.backgroundColor = UIColor.clearColor()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Options", style: .Plain, target: nil, action: nil)
        
        headerTitleView.delegate = self
        setUpTableView()
    }
    

    func setUpTableView() {
        switch decisionState! {
        case .OptionsState:
            let optionsTableSource = ContainedTableViewDataSourceList<Option>(items: decision!.options, cellIdentifier: "OptionCell", cellConfigurationHandler: { (indexPath, cell, opt) in
                let optCell = cell as! OptionTableViewCell
                optCell.optionTitleLabel.text = opt.name.uppercaseString
                optCell.decisionState = .OptionsState
                optCell.cellIndex = indexPath.row
                optCell.editNameButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.editOptionNameButtonTapped)))
                return optCell
            })
            tableViewDataSource = optionsTableSource
            decisionsTableController!.tableView.dataSource = tableViewDataSource!
            break
            
        default:
            let decisionsTableSource = ContainedTableViewDataSourceResults<Decision>(items: try! Realm().objects(Decision.self), cellIdentifier: "OptionCell", cellConfigurationHandler: { (indexPath, cell, dec) in
                let decCell = cell as! OptionTableViewCell
                decCell.optionTitleLabel.text = dec.name.uppercaseString
                decCell.decisionState = .ExistingDecisionsState
                decCell.cellIndex = indexPath.row
                return decCell
            })
            tableViewDataSource = decisionsTableSource
            decisionsTableController!.tableView.dataSource = tableViewDataSource
            break
        }
        
        decisionsTableController!.tableView.delegate = self
        
        guard decisionsTableController!.tableView.dataSource != nil else {
            print("datasource was not assigned.")
            return
        }
        
        decisionsTableController!.tableView.separatorColor = UIColor.clearColor()
        
        decisionsTableController!.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func editOptionNameButtonTapped() {
        print("Option name edit button tapped")
    }
    
    func informationIconTapped() {
        var header: String
        var message: String
        
        switch decisionState! {
        case .OptionsState:
            header = "OPTIONS!"
            message = "Before you can start deciding, you’ve got to know what options you can choose from. \n \n Don’t worry about forgetting to add an option; you can always come back to this page!"
            break
            
        case .ExistingDecisionsState:
            header = "DECISIONS"
            message = "Click on any decision to view the results or to re-appraise a previous decision!"
        }
        
        AlertController.pocketJudgeAlertController(header, message: message).present()
    }
    
    func sliderIconTapped() {
        // segue
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text != decision!.name {
            if textView.text == "" {
                textView.text = decision!.name
            } else {
                decision!.name = textView.text.uppercaseString
            }
        }
        print("Decision name changed. Name is now \(decision!.name)")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row: \(indexPath)")
        
        switch decisionState! {
        case .OptionsState:
            let source = tableViewDataSource as! ContainedTableViewDataSourceList<Option>
            performSegueWithIdentifier("showMetricsSegue", sender: source.items[indexPath.row])
            break
            
        default:
            let source = tableViewDataSource as! ContainedTableViewDataSourceResults<Decision>
            performSegueWithIdentifier("showMetricsSegue", sender: source.items[indexPath.row])
            // WRONG SEGUE
            break
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier("OptionFooter") as! MetricHeaderView
        // set background color to clear
        footer.imageView.image = UIImage(named: "PlusIcon")
        footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newOptionTapped)))
        footer.backgroundView = UIView(frame: footer.bounds)
        footer.backgroundView?.backgroundColor = UIColor.clearColor()
        return footer
    }
    
    func newOptionTapped() {
        print("WOOH NEW OPTION")
        
        let newOptionAlertController = UIAlertController(title: "New Decision", message: "Enter the name of your decision's new option.", preferredStyle: .Alert)
        
        let saveNameAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            let nameTextField = newOptionAlertController.textFields![0] as UITextField
            self.createNewOption(nameTextField.text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        newOptionAlertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Decision name"
        }
        
        newOptionAlertController.addAction(saveNameAction)
        newOptionAlertController.addAction(cancelAction)
        
        presentViewController(newOptionAlertController, animated: true, completion: nil)
        
    }
    
    func createNewOption(name: String?) {
        guard name != nil || (name?.isEmpty)! else {
            return
        }
        
        // save to realm here
        let newOption = Option(name: name!)
        
        do {
            try realm.write({
                self.decision!.addOption(newOption)
            })
        } catch {
            print("Welp. An exception.")
        }
        
        decisionsTableController!.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMetricsSegue" {
            let destCont = segue.destinationViewController as! MetricViewController
            destCont.decision = decision!
            destCont.option = sender as? Option
            // also, save to realm asynchronously
            // allow for segue to happen when cell is selected
        } else if segue.identifier == "" {
            
        }
    }

    
    // OptionTableViewCellDelegate methods
    func trashButtonTapped(cellIndex: Int) {
        // trash a decision/option
        
        // are you sure you want to delete?
    }
    
    func editNameButtonTapped(cellIndex: Int) {

        let editName = UIAlertController(title: "Rename", message: nil, preferredStyle: .Alert)
        
        let changeNameAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            let newNameTextField = editName.textFields![0] as UITextField
            self.changeName(newNameTextField, indexSelected: cellIndex)
        }
        changeNameAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        editName.addTextFieldWithConfigurationHandler { (textField) in
            let source = self.tableViewDataSource as! ContainedTableViewDataSourceList<Option>
            textField.text = source.items[cellIndex].name
        }
        
        editName.addAction(changeNameAction)
        editName.addAction(cancelAction)
        
        presentViewController(editName, animated: true, completion: nil)
    }
    
    func changeName(textField: UITextField, indexSelected: Int) {
        let source = self.tableViewDataSource as! ContainedTableViewDataSourceList<Option>
        
        guard textField.text != nil && source.items[indexSelected].name != textField.text else {
            return
        }
        
        // update to Realm
        // reload data
    }

}

enum DecisionState {
    case OptionsState, ExistingDecisionsState
}