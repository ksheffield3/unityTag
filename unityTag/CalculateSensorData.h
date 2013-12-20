//
//  AccelData.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/4/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccelData : NSObject

/***
 Calculates data from the sensors
 This is from the TI app
 ****/

#define KXTJ9_RANGE 4.0

+(float) calcXValue:(NSData *)data;
+(float) calcYValue:(NSData *)data;
+(float) calcZValue:(NSData *)data;
+(float) getRange;

@end

@interface sensorTagValues : NSObject
@property float accX;
@property float accY;
@property float accZ;


@property float gyroX;
@property float gyroY;
@property float gyroZ;


@property NSString *timeStamp;

@end

@interface GyroscopeData : NSObject


@property float lastX,lastY,lastZ;
@property float calX,calY,calZ;

#define IMU3000_RANGE 500.0

-(id) init;

-(void) calibrate;
-(float) calcXValue:(NSData *)data;
-(float) calcYValue:(NSData *)data;
-(float) calcZValue:(NSData *)data;
+(float) getRange;




@end




