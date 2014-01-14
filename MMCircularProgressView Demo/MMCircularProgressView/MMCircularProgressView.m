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
    [self setProgress];
    [self addNeedle];
}

//default configurations
-(void)setDefaultConfig{
    
    self.backgroundColor = [UIColor clearColor];
    self.trackColor = [UIColor colorWithWhite:1 alpha:0.3];
//    self.trackColor = [UIColor redColor];

    self.progressColor = [UIColor colorWithWhite:1 alpha:0.5];
//    self.progressColor = [UIColor yellowColor];

    self.needleColor = [UIColor redColor];
    self.strokeWidth = 5;
    self.progress = 0.7;
    self.duration = 2;
    self.startAngle = 170;
    self.endAngle = 45;

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

-(void)repaint{
    [self.progressLayer removeFromSuperlayer];
    [self.trackLayer removeFromSuperlayer];
    [self.needleImageView removeFromSuperview];
    
    [self setNeedsDisplay];

}

#pragma mark - Drawing Methods

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

- (void)setProgress
{
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0,0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    pathLayer.geometryFlipped = NO;
    pathLayer.path = [self createBezierPathWithProgress:self.progress].CGPath;
    pathLayer.strokeColor = [self.progressColor CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = self.strokeWidth;
    pathLayer.lineJoin = kCALineJoinBevel;
    pathLayer.strokeStart   = 0.0;
    pathLayer.strokeEnd     = 1.0;
    
    self.progressLayer = pathLayer;
    [self.layer addSublayer:self.progressLayer];
    
}


-(void)addNeedle{
    
    UIImage *img = [[UIImage imageNamed:@"needle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.needleImageView = [[UIImageView alloc] initWithImage:img];
    
    [self.needleImageView setFrame:CGRectMake(CGRectGetMidX(self.trackLayer.frame)-img.size.width/2,
                                              CGRectGetMidY(self.trackLayer.frame)-img.size.height/2,
                                              img.size.width,
                                              img.size.height)];
    
    [self addSubview:self.needleImageView];
    self.needleImageView.layer.anchorPoint = CGPointMake(0.5,1);

    [self.needleImageView setTintColor:self.needleColor];
    
    CGFloat progressOvalEndAngle = DEGREES_TO_RADIANS(-1*(270-self.startAngle)+self.progress*(360-self.startAngle+self.endAngle));
    CGAffineTransform finalTransform = CGAffineTransformMakeRotation(progressOvalEndAngle);
    [self.needleImageView setTransform:finalTransform];

}



-(void)startAnimation{
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.progressLayer removeAllAnimations];
        
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = self.duration;
        animateStrokeEnd.fromValue = @(0.0f);
        animateStrokeEnd.toValue   = @(1.0f);
        animateStrokeEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.progressLayer addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
        
        self.needleImageView.layer.anchorPoint = CGPointMake(0.5,1);
        
        CGFloat progressOvalStartAngle = DEGREES_TO_RADIANS(-1*(270-self.startAngle));
        CGFloat progressOvalEndAngle = DEGREES_TO_RADIANS(-1*(270-self.startAngle)+self.progress*(360-self.startAngle+self.endAngle));

        
        CGAffineTransform initialTransform = CGAffineTransformMakeRotation(progressOvalStartAngle);
        [self.needleImageView setTransform:initialTransform];
//        CGAffineTransform finalTransform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90+self.progress*180));
        CGAffineTransform finalTransform = CGAffineTransformMakeRotation(progressOvalEndAngle);

        [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.needleImageView setTransform:finalTransform];
        } completion:nil];
        
    });
    
}

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
    
    CGAffineTransform ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect));
    //    ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(ovalRect)/ CGRectGetWidth(ovalRect));
    [progressPath applyTransform:ovalTransform];
    
    return progressPath;
}



@end
