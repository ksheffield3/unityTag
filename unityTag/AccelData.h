//
//  AccelData.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/4/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccelData : NSObject



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
@property NSString *timeStamp;

@end


