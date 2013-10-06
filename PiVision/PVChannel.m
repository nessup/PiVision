//
//  PVChannel.m
//  PiVision
//
//  Created by Ari on 10/6/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVChannel.h"

@implementation PVChannel

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", [super description], self.displayName];
}

@end
