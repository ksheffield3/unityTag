//
//  gyroValuesFromViewController.m
//  unityTag
//
//  Created by Kelley Sheffield on 11/6/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import "gyroValuesFromViewController.h"





@implementation gyroValuesFromViewController


-(void)PrintGyroValues:(float)xval yVal:(float)yval zVal:(float)zval
{
    
    //float gX = self.vc.gX;
    
    NSLog(@"X :% 0.1f", xval);
    NSLog(@"Y :% 0.1f", yval);
    NSLog(@"Z :% 0.1f", zval);
    
}


@end


