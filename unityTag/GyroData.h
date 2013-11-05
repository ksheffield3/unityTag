//
//  GyroData.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/5/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GyroData : NSObject


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

@interface gyroValues : NSObject

@property float gyroX;
@property float gyroY;
@property float gyroZ;

@property NSString *gyroTimeStamp;

@end