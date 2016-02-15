//
//  ViewController.swift
//  MMCircularProgressViewDemo_Swift
//
//  Created by Manuel de la Mata Sáez on 28/01/2016.
//  Copyright © 2016 White Squadron Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circularProgressView: MMCircularProgressView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var startAngleSlide: UISlider!
    @IBOutlet weak var startAngleLabel: UILabel!
    @IBOutlet weak var endAngleSlide: UISlider!
    @IBOutlet weak var endAngleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.circularProgressView.strokeWidth = 20
        self.circularProgressView.progress = CGFloat(self.progressSlider.value)
        self.circularProgressView.startAnimation()
        
        self.progressLabel.text = "\(self.progressSlider.value*100)%"
        self.startAngleLabel.text = "\(self.startAngleSlide.value)º"
        self.endAngleLabel.text = "\(self.endAngleSlide.value)º"
        
        //updates the circle
        self.circularProgressView.startAngle = CGFloat(self.startAngleSlide.value)
        self.circularProgressView.endAngle = CGFloat(self.endAngleSlide.value)
    }
    
    
    //MARK:- IBAction methods
    
    @IBAction func progressValueChanged(sender: AnyObject) {
        let progress = CGFloat(((sender as? UISlider)?.value)!)
        
        self.circularProgressView.progress = progress
        self.progressLabel.text = "\(progress*100)%"
    }
    
    @IBAction func startAngleValueChanged(sender: AnyObject) {

        let progress = CGFloat(((sender as? UISlider)?.value)!)
        
        self.circularProgressView.startAngle = progress
        self.startAngleLabel.text = "\(progress)º"
    }

    
    @IBAction func endAngleValueChanged(slider: UISlider) {
        
        let progress = slider.value
        
        self.circularProgressView.endAngle = CGFloat(progress)
        self.endAngleLabel.text = "\(progress)º"
    }

    
    @IBAction func animateButtonPressed(sender: AnyObject) {
        self.circularProgressView.startAnimation()
    }

    
    

}

