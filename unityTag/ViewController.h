//
//  ViewController.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import "findSensor.h"
#import "AccelData.h"
#import "sensorTag.h"
#import "BLEUtility.h"


//#import "GyroData.h"

@interface ViewController : UIViewController
//@property (nonatomic, copy) findSensor *sensor;

@property(strong) CBPeripheral *connectingPeripheral;

@property (strong,nonatomic) sensorTag *d;
@property NSMutableArray *sensorsEnabled;

//@property (strong, nonatomic) GyroData *gData;

@property (strong, nonatomic) GyroscopeData *gData;

@property (strong,nonatomic) sensorTagValues *currentVal;
@property (strong,nonatomic) NSMutableArray *vals;
@property (strong,nonatomic) NSTimer *logTimer;

@property(nonatomic) float *gX;

@property float logInterval;




@end
