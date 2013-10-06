//
//  PVEpisode.h
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVEpisode : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic) NSInteger channel;
+ (NSArray *)generateTestChannels;
@end
