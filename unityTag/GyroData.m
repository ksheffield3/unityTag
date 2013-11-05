//
//  GyroData.m
//  unityTag
//
//  Created by Kelley Sheffield on 11/5/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import "GyroData.h"

@implementation GyroData


@synthesize lastX,lastY,lastZ;
@synthesize calX,calY,calZ;

-(id) init {
    self = [super init];
    if (self) {
        self.calX = 0.0f;
        self.calY = 0.0f;
        self.calZ = 0.0f;
    }
    return self;
}

-(void) calibrate {
    self.calX = self.lastX;
    self.calY = self.lastY;
    self.calZ = self.lastZ;
    
}

-(float) calcXValue:(NSData *)data {
    //Orientation of sensor on board means we need to swap X (multiplying with -1)
    char scratchVal[6];
    [data getBytes:&scratchVal length:6];
    int16_t rawX = (scratchVal[0] & 0xff) | ((scratchVal[1] << 8) & 0xff00);
    self.lastX = (((float)rawX * 1.0) / ( 65536 / IMU3000_RANGE )) * -1;
    return (self.lastX - self.calX);
}
-(float) calcYValue:(NSData *)data {
    //Orientation of sensor on board means we need to swap Y (multiplying with -1)
    char scratchVal[6];
    [data getBytes:&scratchVal length:6];
    int16_t rawY = ((scratchVal[2] & 0xff) | ((scratchVal[3] << 8) & 0xff00));
    self.lastY = (((float)rawY * 1.0) / ( 65536 / IMU3000_RANGE )) * -1;
    return (self.lastY - self.calY);
}
-(float) calcZValue:(NSData *)data {
    char scratchVal[6];
    [data getBytes:&scratchVal length:6];
    int16_t rawZ = (scratchVal[4] & 0xff) | ((scratchVal[5] << 8) & 0xff00);
    self.lastZ = ((float)rawZ * 1.0) / ( 65536 / IMU3000_RANGE );
    return (self.lastZ - self.calZ);
}
+(float) getRange {
    return IMU3000_RANGE;
}



@end



@implementation gyroValues

@end
