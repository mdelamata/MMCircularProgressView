//
//  MMCircularProgressView.m
//  ihappy
//
//  Created by Manuel de la Mata Sáez on 08/01/14.
//  Copyright (c) 2014 ihappy. All rights reserved.
//

#import "MMCircularProgressView.h"

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@import QuartzCore;
@import CoreGraphics;

@interface MMCircularProgressView()

@property (nonatomic, retain) CAShapeLayer *trackLayer;
@property (nonatomic, retain) CAShapeLayer *progressLayer;
@property (nonatomic, retain) UIImageView *needleImageView;

- (void)setDefaultConfig;

@end

@implementation MMCircularProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultConfig];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setDefaultConfig];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setTrack];
    [self setProgressTrack];
    
    if (self.displayNeedle) {
        [self addNeedle];
    }
}

//default configurations
-(void)setDefaultConfig{
    
    self.backgroundColor = [UIColor clearColor];
    self.trackColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.progressColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.needleColor = [UIColor redColor];
    self.strokeWidth = 5;
    self.displayNeedle = YES; //yes by default

    self.duration = 2;
    
    self.startAngle = 170;
    self.endAngle = 45;
    
    self.kCAMediaTimingFunction = kCAMediaTimingFunctionEaseInEaseOut;
    
    self.progress = 0.7;
}

-(void)setProgress:(float)progress{
    _progress = progress;
    [self repaint];
}

-(void)setStartAngle:(CGFloat)startAngle{
    _startAngle = startAngle;
    [self repaint];
}

-(void)setEndAngle:(CGFloat)endAngle{
    _endAngle = endAngle;
    [self repaint];
}


#pragma mark - Drawing Methods

//defines and draws the track stroke
- (void)setTrack
{
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0,0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    pathLayer.geometryFlipped = NO;
    pathLayer.path = [self createBezierPathWithProgress:1].CGPath;
    pathLayer.strokeColor = [self.trackColor CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = self.strokeWidth;
    pathLayer.lineJoin = kCALineJoinBevel;
    pathLayer.strokeStart = 0.0;
    pathLayer.strokeEnd = 1;
    
    self.trackLayer = pathLayer;
    [self.layer addSublayer:self.trackLayer];
}

//defines and draws the progress track stroke
- (void)setProgressTrack
{
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0,0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    pathLayer.geometryFlipped = NO;
    pathLayer.path = [self createBezierPathWithProgress:self.progress].CGPath;
    pathLayer.strokeColor = [self.progressColor CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = self.strokeWidth;
    pathLayer.lineJoin = kCALineJoinBevel;
    pathLayer.strokeStart = 0.0;
    pathLayer.strokeEnd = 1.0;
    
    self.progressLayer = pathLayer;
    [self.layer addSublayer:self.progressLayer];
    
}

//defines and draws the needle stroke
-(void)addNeedle{
    
    UIImage *img = [[UIImage imageNamed:@"needle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; //with this, the tinting is easy!
    self.needleImageView = [[UIImageView alloc] initWithImage:img];
    
    [self.needleImageView setFrame:CGRectMake(CGRectGetMidX(self.trackLayer.frame)-img.size.width/2,
                                              CGRectGetMidY(self.trackLayer.frame)-img.size.height/2,
                                              img.size.width,
                                              img.size.height)];
    
    [self addSubview:self.needleImageView];
    
    //sets the anchor point in the bottom side
    self.needleImageView.layer.anchorPoint = CGPointMake(0.5,1);

    //tints the image with the desired color
    [self.needleImageView setTintColor:self.needleColor];
    
    
    //rotates it to the progress position
    CGFloat progressOvalEndAngle = DEGREES_TO_RADIANS(-1*(270-self.startAngle)+self.progress*(360-self.startAngle+self.endAngle));
    CGAffineTransform finalTransform = CGAffineTransformMakeRotation(progressOvalEndAngle);
    [self.needleImageView setTransform:finalTransform];

}


//method that clears and request repaint everything
-(void)repaint{
    [self.progressLayer removeFromSuperlayer];
    [self.trackLayer removeFromSuperlayer];
    [self.needleImageView removeFromSuperview];
    
    [self setNeedsDisplay];
}

//auxiliar method to create Bezier paths to the desired progress
-(UIBezierPath*)createBezierPathWithProgress:(CGFloat)progress{
    
    // Drawing code
    CGFloat progressOvalStartAngle = DEGREES_TO_RADIANS(self.startAngle);
    CGFloat progressOvalEndAngle = DEGREES_TO_RADIANS(360-self.startAngle+self.endAngle);
    CGFloat progressOvalWidth = self.strokeWidth;
    
    //oval drawing
    CGRect ovalRect = self.bounds;
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath addArcWithCenter:CGPointMake(0, 0)
                            radius:CGRectGetWidth(ovalRect)/2 - progressOvalWidth
                        startAngle:progressOvalStartAngle
                          endAngle:(progressOvalStartAngle + (progress * progressOvalEndAngle))
                         clockwise:YES];
    
    //this centers the beziers in the rect
    CGAffineTransform ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect));
    //    ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(ovalRect)/ CGRectGetWidth(ovalRect));
    [progressPath applyTransform:ovalTransform];
    
    return progressPath;
}


#pragma mark - Animating Methods

//method to start the animation.
-(void)startAnimation{
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.progressLayer removeAllAnimations];
        
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = self.duration;
        animateStrokeEnd.fromValue = @(0.0f);
        animateStrokeEnd.toValue   = @(1.0f);
        animateStrokeEnd.timingFunction = [CAMediaTimingFunction functionWithName:self.kCAMediaTimingFunction];
        [self.progressLayer addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
        
        
        if (self.displayNeedle) {
            
            [self.progressLayer removeAllAnimations];

            CGFloat progressOvalStartAngle = DEGREES_TO_RADIANS(-1*(270-self.startAngle));
            CGFloat progressOvalEndAngle = DEGREES_TO_RADIANS(-1*(270-self.startAngle)+self.progress*(360-self.startAngle+self.endAngle));
            
            CABasicAnimation *rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.fromValue = [NSNumber numberWithFloat:progressOvalStartAngle];
            rotationAnimation.toValue = [NSNumber numberWithFloat:progressOvalEndAngle];
            rotationAnimation.duration = self.duration;
            rotationAnimation.removedOnCompletion = YES;
            rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:self.kCAMediaTimingFunction];
            
            
            [self.needleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        }


    });
    
}

@end
