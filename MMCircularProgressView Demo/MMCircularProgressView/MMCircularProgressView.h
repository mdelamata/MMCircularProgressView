//
//  MMCircularProgressView.h
//  ihappy
//
//  Created by Manuel de la Mata Sáez on 08/01/14.
//  Copyright (c) 2014 ihappy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCircularProgressView : UIView

@property(nonatomic,retain) UIColor *progressColor;
@property(nonatomic,retain) UIColor *trackColor;
@property(nonatomic,retain) UIColor *needleColor;

@property(nonatomic,assign) CGFloat strokeWidth;
@property(nonatomic,assign) CGFloat duration;

@property(nonatomic,assign) CGFloat startAngle;
@property(nonatomic,assign) CGFloat endAngle;

@property(nonatomic,assign) float progress;

-(void)startAnimation;

@end
