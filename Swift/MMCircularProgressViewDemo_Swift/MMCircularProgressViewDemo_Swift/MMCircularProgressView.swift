//
//  MMCircularProgressView.swift
//  MMCircularProgressViewDemo_Swift
//
//  Created by Manuel de la Mata Sáez on 28/01/2016.
//  Copyright © 2016 White Squadron Ltd. All rights reserved.
//

import UIKit

class MMCircularProgressView: UIView {
    
    var progressColor: UIColor!
    var trackColor: UIColor!
    var needleColor: UIColor!

    var strokeWidth: CGFloat!
    var duration: CGFloat!

    var startAngle: CGFloat! {
        didSet {
            self.repaint()
        }
    }
    var endAngle: CGFloat! {
        didSet {
            self.repaint()
        }
    }

    var initialProgress: CGFloat!
    var progress: CGFloat! {
        didSet {
            self.repaint()
        }
    }
    var displayNeedle = false

    var kCAMediaTimingFunction: String!
    var lineCap: String!

    private var trackLayer: CAShapeLayer?
    private var progressLayer: CAShapeLayer?
    private var needleImageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        self.setDefaultConfiguration()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.setTrack()
        self.setProgressTrack()
        
        if self.displayNeedle {
            self.addNeedle()
        }
    }
    
    func setDefaultConfiguration() {
        
        self.backgroundColor = UIColor.clearColor()
        self.trackColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        self.progressColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        self.needleColor = UIColor.redColor()
        self.strokeWidth = 5
        self.displayNeedle = true
        
        self.duration = 2
        
        self.startAngle = 170
        self.endAngle = 45
        
        self.kCAMediaTimingFunction = kCAMediaTimingFunctionEaseInEaseOut
        self.lineCap = kCALineCapRound
        
        self.initialProgress = 0.0
        self.progress = 1
    }
    
    //MARK: - Drawing Methods
    
    //defines and draws the track stroke
    func setTrack() {
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        pathLayer.geometryFlipped = false
        pathLayer.path = self.createBezierPathWithProgress(1).CGPath
        pathLayer.strokeColor = self.trackColor.CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = self.strokeWidth
        pathLayer.lineJoin = kCALineJoinBevel
        pathLayer.strokeStart = 0.0
        pathLayer.strokeEnd = 1
        pathLayer.lineCap = self.lineCap
        
        self.trackLayer = pathLayer
        self.layer.addSublayer(self.trackLayer!)
    }

    //defines and draws the progress track stroke
    func setProgressTrack() {
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        pathLayer.geometryFlipped = false
        pathLayer.path = self.createBezierPathWithProgress(self.progress).CGPath
        pathLayer.strokeColor = self.progressColor.CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = self.strokeWidth
        pathLayer.lineJoin = kCALineJoinBevel
        pathLayer.strokeStart = 0.0
        pathLayer.strokeEnd = 1.0
        pathLayer.lineCap = self.lineCap
    
        self.progressLayer = pathLayer
        self.layer.addSublayer(self.progressLayer!)
    }
    
    
    //defines and draws the needle stroke
    func addNeedle() {
        
        if let img = UIImage(named: "needle")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), let trackLayer = self.trackLayer {
            
            self.needleImageView = UIImageView(image: img)
            
            self.needleImageView?.frame = CGRectMake( trackLayer.frame.midX - img.size.width/2,
                CGRectGetMidY(trackLayer.frame)-img.size.height/2,
                img.size.width,
                img.size.height)
            
            self.addSubview(self.needleImageView!)
            
            //sets the anchor point in the bottom side
            self.needleImageView?.layer.anchorPoint = CGPointMake(0.5,1)

            //tints the image with the desired color
            self.needleImageView?.tintColor = self.needleColor

            
            //rotates it to the progress position
            let progressOvalEndAngle = self.degreesToRadians(Double(self.startAngle + self.progress*(self.endAngle)-270))
            let finalTransform = CGAffineTransformMakeRotation(CGFloat(progressOvalEndAngle))
            self.needleImageView?.transform = finalTransform
        }
    }
    
    //method that clears and requests to repaint everything
    func repaint() {
        self.progressLayer?.removeFromSuperlayer()
        self.trackLayer?.removeFromSuperlayer()
        self.needleImageView?.removeFromSuperview()
        
        self.setNeedsDisplay()
    }
    
    
    
    //auxiliar method to create Bezier paths to the desired progress
    func createBezierPathWithProgress(progress: CGFloat) -> UIBezierPath {
        
        // Drawing code
        let progressOvalStartAngle = self.degreesToRadians(Double(self.startAngle))
        let progressOvalEndAngle = self.degreesToRadians(Double(self.endAngle))
        let progressOvalWidth = self.strokeWidth
        
        //oval drawing
        let ovalRect = self.bounds
        let progressPath = UIBezierPath()
        progressPath.addArcWithCenter(CGPoint(x: 0, y: 0), radius: CGRectGetWidth(ovalRect)/2 - progressOvalWidth, startAngle: CGFloat(progressOvalStartAngle), endAngle: (CGFloat(progressOvalStartAngle) + (progress * CGFloat(progressOvalEndAngle))), clockwise: true)
        
        //this centers the beziers in the rect
        let ovalTransform = CGAffineTransformMakeTranslation(ovalRect.midX, CGRectGetMidY(ovalRect))
        //    ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(ovalRect)/ CGRectGetWidth(ovalRect));
        progressPath.applyTransform(ovalTransform)
        
        return progressPath
    }
    
    
    //MARK:- Auxiliar Methods
    func degreesToRadians(angle : Double) -> Double {
        return M_PI * angle / 180.0
    }
    
    func radiansToDegrees (angle:Double) -> Double {
        return angle / 180.0 * M_PI
    }
    
    //MARK:- Animating Methods
    
    //method to start the animation.
    func startAnimation() {
        
        self.progressLayer?.removeAllAnimations()
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration  = Double(self.duration)
        animateStrokeEnd.fromValue = self.initialProgress
        animateStrokeEnd.toValue   = 1.0
        animateStrokeEnd.timingFunction = CAMediaTimingFunction(name: self.kCAMediaTimingFunction)
        self.progressLayer?.addAnimation(animateStrokeEnd, forKey: "strokeEndAnimation")
        
        if self.displayNeedle == true {
            
            self.needleImageView?.layer.removeAllAnimations()
            
            let progressOvalStartAngle = degreesToRadians(Double(self.startAngle-270))
            let progressOvalEndAngle = degreesToRadians(Double(self.startAngle + self.progress*(self.endAngle)-270))
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.fromValue = progressOvalStartAngle
            rotationAnimation.toValue = progressOvalEndAngle
            rotationAnimation.duration = Double(self.duration)
            rotationAnimation.removedOnCompletion = true
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: self.kCAMediaTimingFunction)
            
            self.needleImageView?.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        }
        
    }
}