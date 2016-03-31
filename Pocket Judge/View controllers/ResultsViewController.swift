//
//  ResultsViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/28/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import SDCAlertView

class ResultsViewController: HeaderContainerViewController, UITableViewDelegate {

    var decision: Decision?
    let headerImageName = "StenographerProfile"
    var resultsTableController: UITableViewController?
    var resultsTableSource: ContainedTableViewDataSourceResults<Option>?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableSource = ContainedTableViewDataSourceResults<Option>(items: decision!.options.sorted("aggregateValue", ascending: false), cellIdentifier: "ResultSliderCell", cellConfigurationHandler: { (_, cell, opt) -> UITableViewCell in
            let resultCell = cell as! ResultSliderTableViewCell
            resultCell.optionNameLabel.text = opt.name.uppercaseString
            let percentageValue: Float = opt.aggregateValue.value! / 5.333333 * 100
            resultCell.percentageLabel.text = String(format: "%.2f%", percentageValue)
            resultCell.percentageSlider.minimumValue = 0
            resultCell.percentageSlider.maximumValue = 5.333333
            resultCell.percentageSlider.value = opt.aggregateValue.value!
            return resultCell
        })
        
        var buttonItems = [UIBarButtonItem]()
        buttonItems.append(UIBarButtonItem(image: UIImage(named: "InformationIcon"), style: .Plain, target: self, action: #selector(ResultsViewController.informationIconTapped)))
        self.navigationItem.rightBarButtonItems = buttonItems
        
        headerTitleView.text = "RESULTS"
        headerTitleView.userInteractionEnabled = false
        
        characterImageView.image = UIImage(named: headerImageName)!
        
        resultsTableController = UITableViewController(style: .Plain)
        resultsTableController!.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        containerView.addSubview(resultsTableController!.view)
        resultsTableController!.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        resultsTableController!.didMoveToParentViewController(self)
        resultsTableController!.tableView.registerNib(UINib(nibName: "ResultSliderCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ResultSliderCell")
        
        resultsTableController!.tableView.rowHeight = UITableViewAutomaticDimension
        resultsTableController!.tableView.estimatedRowHeight = 50
        resultsTableController!.tableView.dataSource = resultsTableSource
        
        resultsTableController!.tableView.backgroundColor = UIColor.clearColor()
        resultsTableController!.tableView.userInteractionEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        headerTitleView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
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
    
    func informationIconTapped() {
        let header = "RESULTS"
        let message = "Here are the results of the ratings! While it is highly encourage that you go with the highest rated option, what you end up choosing is still up to your discretion. Happy choosing!"
        
        let informationAlertController = UIAlertController(title: header, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (_) in }
        informationAlertController.addAction(cancelAction)
        presentViewController(informationAlertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
