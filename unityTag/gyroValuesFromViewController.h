//
//  gyroValuesFromViewController.h
//  unityTag
//
//  Created by Kelley Sheffield on 11/6/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface gyroValuesFromViewController : NSObject


@property ViewController *vc;

-(void)PrintGyroValues:(float)xval yVal:(float)yval zVal:(float)zval;

@end
