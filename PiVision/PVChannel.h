//
//  PVChannel.h
//  PiVision
//
//  Created by Ari on 10/6/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVChannel : NSObject

@property (nonatomic, copy) NSString *channelNumber;
@property (nonatomic, copy) NSString *callLetters;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *longName;

@end
