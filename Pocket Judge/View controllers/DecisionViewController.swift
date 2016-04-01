//
//  DecisionViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import RealmSwift

class DecisionViewController: HeaderContainerViewController, UITextViewDelegate, UITableViewDelegate, OptionTableViewCellDelegate {
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
                buttonItems.append(UIBarButtonItem(image: UIImage(named: "SliderIcon"), style: .Plain, target: self, action: #selector(DecisionViewController.sliderIconTapped)))
                break
            
            case .ExistingDecisionsState:
                buttonItems.append(UIBarButtonItem(image: UIImage(named: "InformationIcon"), style: .Plain, target: self, action: #selector(DecisionViewController.informationIconTapped)))
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
        
        if decisionState! == .OptionsState {
            headerTitleView.text = decision!.name.uppercaseString
        } else {
            headerTitleView.text = "OLD DECISIONS"
            headerTitleView.userInteractionEnabled = false
        }
        
        characterImageView.image = UIImage(named: headerImageName)!
        
        decisionsTableController = UITableViewController(style: .Plain)
        self.addChildViewController(decisionsTableController!)
        decisionsTableController!.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        containerView.addSubview(decisionsTableController!.view)
//        decisionsTableController!.view.frame = containerView.frame
        decisionsTableController!.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        decisionsTableController!.didMoveToParentViewController(self)
        decisionsTableController!.tableView.registerNib(UINib(nibName: "MetricHeader", bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: "OptionFooter")
        decisionsTableController!.tableView.registerNib(UINib(nibName: "OptionCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "OptionCell")
        
        decisionsTableController!.tableView.rowHeight = UITableViewAutomaticDimension
        decisionsTableController!.tableView.estimatedRowHeight = 50
        
        decisionsTableController!.tableView.backgroundColor = UIColor.clearColor()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Options", style: .Plain, target: nil, action: nil)
        
        headerTitleView.delegate = self
        setUpTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        headerTitleView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        decisionsTableController!.tableView.reloadData()
    }

    func setUpTableView() {
        switch decisionState! {
        case .OptionsState:
            let optionsTableSource = ContainedTableViewDataSourceList<Option>(items: decision!.options, cellIdentifier: "OptionCell", cellConfigurationHandler: { (indexPath, cell, opt) in
                let optCell = cell as! OptionTableViewCell
                optCell.optionTitleLabel.text = opt.name.uppercaseString
                optCell.decisionState = .OptionsState
                optCell.cellIndex = indexPath.row
                optCell.delegate = self
                optCell.layoutMargins = UIEdgeInsetsZero
                return optCell
            })
            tableViewDataSource = optionsTableSource
            decisionsTableController!.tableView.dataSource = tableViewDataSource!
            decisionsTableController!.tableView.separatorColor = UIColor(hex: "f3e4cc")
            break
            
        default:
            let decisionsTableSource = ContainedTableViewDataSourceResults<Decision>(items: try! Realm().objects(Decision.self), cellIdentifier: "OptionCell", cellConfigurationHandler: { (indexPath, cell, dec) in
                let decCell = cell as! OptionTableViewCell
                decCell.optionTitleLabel.text = dec.name.uppercaseString
                decCell.decisionState = .ExistingDecisionsState
                decCell.cellIndex = indexPath.row
                decCell.layoutMargins = UIEdgeInsetsZero
                decCell.delegate = self
                return decCell
            })
            tableViewDataSource = decisionsTableSource
            decisionsTableController!.tableView.dataSource = tableViewDataSource
            decisionsTableController!.tableView.separatorColor = UIColor(hex: "f6b783")
            break
        }
        
        decisionsTableController!.tableView.delegate = self
        
        decisionsTableController!.tableView.backgroundColor = UIColor.clearColor()
        
        
        decisionsTableController!.tableView.layoutMargins = UIEdgeInsetsZero
        
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
        
        let informationAlertController = UIAlertController(title: header, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (_) in }
        informationAlertController.addAction(cancelAction)
        presentViewController(informationAlertController, animated: true, completion: nil)
    }
    
    func sliderIconTapped() {
        // segue
        let source = tableViewDataSource as! ContainedTableViewDataSourceList<Option>
        performSegueWithIdentifier("showMetricsSegue", sender: source.items[0])
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text != decision!.name {
            if textView.text == "" {
                textView.text = decision!.name
            } else {
                do {
                    try realm.write({
                        decision!.name = textView.text.uppercaseString
                    })
                } catch {
                    print("Welp, an error occurred.")
                }
            }
        }
        textView.text = decision!.name
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch decisionState! {
        case .OptionsState:
            let source = tableViewDataSource as! ContainedTableViewDataSourceList<Option>
            performSegueWithIdentifier("showMetricsSegue", sender: source.items[indexPath.row])
            break
            
        default:
            let source = tableViewDataSource as! ContainedTableViewDataSourceResults<Decision>
            let destination = self.storyboard!.instantiateViewControllerWithIdentifier("DecisionViewController") as! DecisionViewController
            destination.decision = source.items[indexPath.row]
            destination.decisionState = .OptionsState
//            presentViewController(destination, animated: true, completion: nil)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Archive", style: .Plain, target: nil, action: nil)
            self.navigationController!.pushViewController(destination, animated: true)
            
            break
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard decisionState! == .OptionsState else {
            return nil
        }
        
        let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier("OptionFooter") as! MetricHeaderView
        // set background color to clear
        footer.imageView.image = UIImage(named: "PlusIcon")
        footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newOptionTapped)))
        footer.backgroundView = UIView(frame: footer.bounds)
        footer.backgroundView?.backgroundColor = UIColor.clearColor()
        return footer
    }
    
    func newOptionTapped() {
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
        if decisionState! == .OptionsState {
            return 45.0
        } else {
            return 0.0
        }
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
        var trashTitle: String
        
        switch decisionState! {
        case .OptionsState:
            // make sure mroe than 2
            let source = tableViewDataSource as! ContainedTableViewDataSourceList<Option>
            guard source.items.count > 2 else {
                let trashOption = UIAlertController(title: "Too few options", message: "You cannot delete any more options.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (_) in }
                
                trashOption.addAction(cancelAction)
                
                presentViewController(trashOption, animated: true, completion: nil)
                return
            }
            
            trashTitle = "Are you sure you want to delete this option?"
        case .ExistingDecisionsState:
            trashTitle = "Are you sure you want to delete this decision?"
        }
        
        let trashOption = UIAlertController(title: "Delete", message: trashTitle, preferredStyle: .Alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (_) in
            self.deleteAtIndex(cellIndex)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        trashOption.addAction(deleteAction)
        trashOption.addAction(cancelAction)
        
        presentViewController(trashOption, animated: true, completion: nil)
    }
    
    func deleteAtIndex(index: Int) {
        switch decisionState! {
        case .OptionsState:
            try! realm.write({ 
                realm.delete(decision!.options[index])
            })
        case .ExistingDecisionsState:
            let source = tableViewDataSource as! ContainedTableViewDataSourceResults<Decision>
            try! realm.write({ 
                realm.delete(source.items[index])
            })
            if source.items.count == 0 {
                navigationController?.popViewControllerAnimated(true)
            }
        }
        
        decisionsTableController!.tableView.reloadData()
    }
    
    func editNameButtonTapped(cellIndex: Int) {

        let editName = UIAlertController(title: "Rename", message: nil, preferredStyle: .Alert)
        
        let changeNameAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            let newNameTextField = editName.textFields![0] as UITextField
            self.changeName(newNameTextField, indexSelected: cellIndex)
        }
        changeNameAction.enabled = true
        // remember to set it to true
        
        
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
        
        try! realm.write({ 
            source.items[indexSelected].name = textField.text!
        })
        
        decisionsTableController!.tableView.reloadData()
        // update to Realm
        // reload data
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let textView = object as! UITextView
        var top = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2.0
        top = top < 0.0 ? 0.0 : top
        textView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
    }

    
    override func viewWillDisappear(animated: Bool) {
        headerTitleView.removeObserver(self, forKeyPath: "contentSize")
    }
}

enum DecisionState {
    case OptionsState, ExistingDecisionsState
}