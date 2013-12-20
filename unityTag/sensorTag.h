//
//  sensorTag.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//
//  Sensor tag related info, BTLE related functionality
//  Following along with the TI Sensor Tag application to communicate with the tag

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


/**
 Representation of the sensor tag
 Holds properties necessary
 to connect to a BTLE device
 **/

@interface sensorTag : NSObject

@property (strong,nonatomic) CBPeripheral *p; //peripheral for CoreBluetooth
@property (strong,nonatomic) CBCentralManager *central; //central looking for peripherals
//@property NSMutableDictionary *initialData;  //initialized data
@property NSMutableDictionary *setupData;

@end
