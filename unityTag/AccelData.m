//
//  AccelData.m
//  unityTag
//
//  Created by Kelley Sheffield on 11/4/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import "AccelData.h"

@implementation AccelData


+(float) calcXValue:(NSData *)data {
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:3];
    return ((scratchVal[0] * 1.0) / (256 / KXTJ9_RANGE));
}
+(float) calcYValue:(NSData *)data {
    //Orientation of sensor on board means we need to swap Y (multiplying with -1)
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:3];
    return ((scratchVal[1] * 1.0) / (256 / KXTJ9_RANGE)) * -1;
}
+(float) calcZValue:(NSData *)data {
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:3];
    return ((scratchVal[2] * 1.0) / (256 / KXTJ9_RANGE));
}
+(float) getRange {
    return KXTJ9_RANGE;
}


@end

@implementation sensorTagValues

@end