//
//  ViewController.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "findSensor.h"

@interface ViewController : UIViewController
@property (nonatomic, copy) findSensor *sensor;

@end
