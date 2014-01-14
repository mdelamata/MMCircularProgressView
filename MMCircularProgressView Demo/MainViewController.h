//
//  MainViewController.h
//  MMCircularProgressView Demo
//
//  Created by Manuel de la Mata Sáez on 08/01/14.
//  Copyright (c) 2014 mms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCircularProgressView.h"

@interface MainViewController : UIViewController

@property(nonatomic,strong) IBOutlet MMCircularProgressView *circularProgressView;
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UISlider *startAngleSlide;
@property (strong, nonatomic) IBOutlet UISlider *endAngleSlide;
@property (strong, nonatomic) IBOutlet UILabel *startAngleLabel;
@property (strong, nonatomic) IBOutlet UILabel *endAngleLabel;

- (IBAction)progressValueChanged:(id)sender;
- (IBAction)startAngleValueChanged:(id)sender;
- (IBAction)endAngleValueChanged:(id)sender;
- (IBAction)animateButtonPressed:(id)sender;

@end
