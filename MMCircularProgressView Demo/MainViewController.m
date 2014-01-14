//
//  MainViewController.m
//  MMCircularProgressView Demo
//
//  Created by Manuel de la Mata Sáez on 08/01/14.
//  Copyright (c) 2014 mms. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.circularProgressView setStrokeWidth:20];
    [self.circularProgressView setProgress:self.progressSlider.value];
    [self.circularProgressView startAnimation];
    
    [self.progressLabel setText:[NSString stringWithFormat:@"%d%%",(int)(self.progressSlider.value*100)]];
    [self.startAngleLabel setText:[NSString stringWithFormat:@"%dº",(int)self.startAngleSlide.value]];
    [self.endAngleLabel setText:[NSString stringWithFormat:@"%dº",(int)self.endAngleSlide.value]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animateButtonPressed:(id)sender {
    [self.circularProgressView startAnimation];

}

- (IBAction)startAngleValueChanged:(id)sender {
    float progress = [(UISlider *)sender value];
    
    [self.circularProgressView setStartAngle:progress];
    [self.startAngleLabel setText:[NSString stringWithFormat:@"%dº",(int)progress]];
}

- (IBAction)endAngleValueChanged:(id)sender {
    float progress = [(UISlider *)sender value];
    
    [self.circularProgressView setEndAngle:progress];
    [self.endAngleLabel setText:[NSString stringWithFormat:@"%dº",(int)progress]];
}

- (IBAction)progressValueChanged:(id)sender {

    float progress = [(UISlider *)sender value];
    
    [self.circularProgressView setProgress:progress];
    [self.progressLabel setText:[NSString stringWithFormat:@"%d%%",(int)(progress*100)]];
}

@end
