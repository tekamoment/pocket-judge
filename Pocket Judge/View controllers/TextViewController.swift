//
//  TextViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/29/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        textView.userInteractionEnabled = false
        // Do any additional setup after loading the view.
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
