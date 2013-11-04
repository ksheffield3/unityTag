//
//  findSensor.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//
//  Search for available sensor tags
//  Following along with the TI Sensor Tag application to communicate with the tag

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "sensorTag.h"
//#import "ViewController.h"

@interface findSensor : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
-(void)startSearching;
@property (strong,nonatomic) CBCentralManager *centralManager; //central manager object from corebluetooth
@property (strong,nonatomic) NSMutableArray *foundDevices;     //array of found devices
@property (strong,nonatomic) NSMutableArray *sensorTags;       //sensor tags discovered
@property (nonatomic) BOOL found;

@property CBPeripheral *periph;




@end
