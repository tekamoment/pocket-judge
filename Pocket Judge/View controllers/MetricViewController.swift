//
//  MetricViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/23/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import SDCAlertView

class MetricViewController: HeaderContainerViewController, UITableViewDataSource, UITableViewDelegate {
    
    // going to involve delegation
    
    var decision: Decision? {
        didSet {
            print("Decision passed in: \(decision!)")
        }
    }
    var option: Option?
    
    let possibleMetricCategories = ["Preference", "Duration", "Certainty", "Closeness", "Productiveness", "Cost", "Social"]
    
    var processedMetrics = [String: [Metric]]()
    
    var metricList: [String]? {
        get {
            return option?.metricList
        }
    }
    
    var activeMetric: Metric? = nil
    
    @IBOutlet weak var minimumTextLabel: UILabel!
    @IBOutlet weak var maximumTextLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var metricIndicatorControl: UIPageControl!

    var metricsTableController: UITableViewController?
    
    override func viewDidLoad() {
//        var buttonItems = [UIBarButtonItem]()
//        buttonItems.append(<#T##newElement: Element##Element#>)
        super.viewDidLoad()
        
        // generate all metrics
        for metric in option!.metrics {
            if let _ = processedMetrics[metric.type.metricCategory] {
                processedMetrics[metric.type.metricCategory]!.append(metric)
            } else {
                processedMetrics[metric.type.metricCategory] = [metric]
            }
        }
        
        // view stuff
        
        headerTitleView.text = decision?.name
        view.layer.insertSublayer(CAGradientLayer.pocketJudgeBackgroundGradientLayer(view.bounds), atIndex: 0)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Evaluate", style: .Plain, target: nil, action: nil)
        valueSlider.continuous = false
        
        // setting up the tableviewcontroller
        
        //// view controller containment
        metricsTableController = UITableViewController(style: .Plain)
        self.addChildViewController(metricsTableController!)
        metricsTableController!.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        containerView.addSubview(metricsTableController!.view)
        metricsTableController!.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        metricsTableController!.didMoveToParentViewController(self)
        
        //// actual view and cell usage
        metricsTableController!.tableView.registerNib(UINib(nibName: "MetricCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MetricCell")
        metricsTableController!.tableView.registerNib(UINib(nibName: "MetricHeader", bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: "MetricHeader")
        
        //// table view specifics
        metricsTableController!.tableView.rowHeight = UITableViewAutomaticDimension
        metricsTableController!.tableView.estimatedRowHeight = 100
        metricsTableController!.tableView.backgroundColor = UIColor.clearColor()
        
        //// delegate and datasouce
        metricsTableController!.tableView.dataSource = self
        metricsTableController!.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///// DATA SOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return processedMetrics[possibleMetricCategories[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MetricCell")! as! MetricTableViewCell
        
        let fetchedMetric = processedMetrics[possibleMetricCategories[indexPath.section]]![indexPath.row]
        
        cell.metricCategoryLabel.text = fetchedMetric.type.metricCategory.lowercaseString
        cell.metricNameLabel.text = fetchedMetric.type.metricDefinition.uppercaseString
        cell.informationButton.addGestureRecognizer(UITapGestureRecognizer(target: self
            , action: #selector(informationButtonTapped)))
        
        // add gesture recognizer for the information button!
        
        return cell
    }
    
    func informationButtonTapped() {
        // pull up the AlertController
        let header: String = activeMetric!.type.metricDefinition.uppercaseString
        var message: String = ""
        
        switch activeMetric!.type.metricDefinition.lowercaseString {
        case "fondness": message = "This refers to how fond you are of the choice itself, assuming it was right in front of you."
        case "permanence": message = "This refers to how long you get to enjoy this option, whether only temporarily or for longer periods of time."
        case "frequency": message = "This refers to how often you get to enjoy this option, whether frequently, or only once in a while."
        case "risk": message = "This refers to how definite you are that you actually get to enjoy this option."
        case "distance": message = "This refers to how physically far away this option is from you."
        case "time": message = "This refers to how long you have to wait before you get to enjoy this option."
        case "familiarity": message = "This refers to how familiar you are with the option, and therefore how much less hassling it would be to choose this option."
        case "opportunity": message = "This refers to the potential of pursuing this option to either lead to other desirable options or eliminate your chances of pursuing them."
        case "quality": message = "This refers to the standard of this option as measured against other things."
        case "money": message = "This refers to the cost of this option, whether cheap or expensive."
        case "effort": message = "This refers to how much work is required to attain this option."
        case "coolness": message = "This refers to how others would think of you choosing this option."
        case "thoughtfulness": message = "This refers to how you are thinking of others as you choose this option."
        default: break
        }
        
        AlertController.pocketJudgeAlertController(header, message: message).present()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of categories
        return possibleMetricCategories.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("MetricHeader") as! MetricHeaderView
        headerView.backgroundView = UIView(frame: headerView.bounds)
        headerView.backgroundView?.backgroundColor = UIColor(hex: "f3e4cc")
        headerView.imageView.image = UIImage(named: possibleMetricCategories[section])
        return headerView
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // update the active metric
        activeMetric = processedMetrics[possibleMetricCategories[indexPath.section]]![indexPath.row]
        
        let metricBounds = activeMetric!.type.maximumMinimum()
        let metricMin = metricBounds.0
        let metricMax = metricBounds.1
        
        // check if metric is not null
        // if null, then set the value to exactly halfway
        if activeMetric!.value == nil {
            activeMetric!.setMetricValue((metricMax + metricMin) / 2.0)
        }
        
        // adjust the slider to represent the value
        if metricMin > metricMax {
            valueSlider.minimumValue = metricMax
            valueSlider.maximumValue = metricMin
        } else {
            valueSlider.minimumValue = metricMin
            valueSlider.maximumValue = metricMax
        }
        
        valueSlider.value = activeMetric!.value!
        
        // change labels
        var minLabel = ""
        var maxLabel = ""
        var pageNumber = 0
        switch activeMetric!.type.metricDefinition.lowercaseString {
        case "fondness": minLabel = "dislike"; maxLabel = "like"; pageNumber = 0
        case "permanence": minLabel = "brief"; maxLabel = "continual"; pageNumber = 1
        case "frequency": minLabel = "seldom"; maxLabel = "often"; pageNumber = 2
        case "risk": minLabel = "risky"; maxLabel = "sure"; pageNumber = 3
        case "distance": minLabel = "far"; maxLabel = "near"; pageNumber = 4
        case "time": minLabel = "later"; maxLabel = "now"; pageNumber = 5
        case "familiarity": minLabel = "unfamiliar"; maxLabel = "accustomed"; pageNumber = 6
        case "opportunity": minLabel = "dead-end"; maxLabel = "prospect"; pageNumber = 7
        case "quality": minLabel = "awful"; maxLabel = "superb"; pageNumber = 8
        case "money": minLabel = "expensive"; maxLabel = "cheap"; pageNumber = 9
        case "effort": minLabel = "tiring"; maxLabel = "effortless"; pageNumber = 10
        case "coolness": minLabel = "lame"; maxLabel = "cool"; pageNumber = 11
        case "thoughtfulness": minLabel = "selfish"; maxLabel = "caring"; pageNumber = 12
        default: break
        }
        
        minimumTextLabel.text = minLabel
        maximumTextLabel.text = maxLabel
        
        // change the indicator
        metricIndicatorControl.currentPage = pageNumber
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        // fetch current metric
        var newValue = sender.value
        
        if activeMetric!.type.metricCategory == "Cost" {
            // absolute value
            newValue = (sender.value - activeMetric!.type.maximumMinimum().0) * -1.0
        }
        
        // update here
    
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
