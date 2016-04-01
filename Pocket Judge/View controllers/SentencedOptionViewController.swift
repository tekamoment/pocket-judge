//
//  SentencedOptionViewController.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/27/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class SentencedOptionViewController: UIViewController {

    @IBOutlet weak var sentencedOptionLabel: UILabel!
    
    var decision: Decision?
    var holdingController: UIViewController?
    
    // next button to dismiss this modal controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CAGradientLayer.pocketJudgeBackgroundGradientLayer(view.bounds), atIndex: 0)
        createParticles()
        let sentencedOption = decision!.options.sorted("aggregateValue", ascending: false).first!
        sentencedOptionLabel.text = sentencedOption.name.capitalizedString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        holdingController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPointMake(view.frame.size.width / 2.0, -50)
        particleEmitter.emitterShape = kCAEmitterLayerLine;
        particleEmitter.emitterSize = CGSizeMake(view.frame.size.width, 1);
        particleEmitter.renderMode = kCAEmitterLayerAdditive;
        
        let cell = CAEmitterCell()
        cell.birthRate = 40
        cell.lifetime = 7
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat(M_PI)
        cell.spinRange = 5
        cell.scale = 0.5
        cell.scaleRange = 0.25
        cell.color = UIColor(white: 0.7, alpha: 1.0).CGColor
        cell.redRange = 0.8
        cell.blueRange = 0.8
        cell.greenRange = 0.8
        cell.alphaSpeed = -0.025
        cell.contents = UIImage(named: "Confetti")?.CGImage
        particleEmitter.emitterCells = [cell]
        
        self.view.layer.addSublayer(particleEmitter)
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
