//
//  PVUtility.m
//  PiVision
//
//  Created by Dany on 10/6/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVUtility.h"

@implementation PVUtility

+ (CGFloat)crispStrokeWidth {
    return [[UIScreen mainScreen] scale] == 2 ? 0.5f : 1.f;
}

@end
