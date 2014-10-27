MMCircularProgressView
======================
[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/andresbrun/ABCustomUINavigationController/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/mdelamata/MMCircularProgressView.png?branch=master)](https://travis-ci.org/mdelamata/MMCircularProgressView)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/MMCircularProgressView/badge.png)](https://github.com/mdelamata/MMCircularProgressView)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/MMCircularProgressView/badge.png)](https://github.com/mdelamata/MMCircularProgressView)

Circular ProgressView for iOS with configuration for starting and end angle.

![alt tag](https://raw2.github.com/mdelamata/MMCircularProgressView/master/capture.png)


How to Install it
------------
#### Podfile
```ruby
platform :ios, '7.0'
pod "MMCircularProgressView", "~> 1.0.1"
```
#### Old school
Drag into your project the folder `/MMCircularProgressView`. That's all.

How to use it? 
------------

There's nothing to it! Firstly, import the .h :

    #import "MMCircularProgressView.h"

Then declare it as a property if you want to access to it properly:

    @property (nonatomic, strong) MMCircularProgressView *theProgressView;

Instantiate it and add it to the desired view as usual: (or create it through Interface Builder)

    //creates and adds the datepicker at the edge of the application frame.
    self.theProgressView = [[MMCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.theProgressView];
    
Setting the progress
------------
It will go from 0.0 to 1.0.

    [self.circularProgressView setProgress:0.5]; //this is a float value.

Animating
------------
Simple as hell!

    [self.circularProgressView startAnimation];

Customization
------------

Here you can see a bunch of parameters that you can change:

#### Track Colors
- UIColor `progressColor`: Customize te progress Color.
- UIColor `trackColor`: Customize the track Color.


#### Customize angle.
- CGFloat `startAngle`: from 0 to 360 degrees.
- CGFloat `endAngle`: from 0 to 360 degrees.

#### Progress.
- CGFloat `initialProgress`: This will help you to determine where it should start the animation.

#### Needle.
- BOOL `displayNeedle`: This will show or not the needle that you can see in the example image.
- UIColor `needleColor`: Color of the needle.

#### Other appearance settings.
- CGFloat `strokeWidth`: This is the width of the track.
- CGFloat `duration`: This is the time for the animation from 0.0 to progress value.

Hope you enjoy it!
