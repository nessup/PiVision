//
//  PVRoviManager.h
//  PiVision
//
//  Created by Ari on 10/6/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVRoviManager : NSObject

@property (nonatomic, strong, readonly) NSArray *channels;

+ (instancetype)sharedManager;

@end
