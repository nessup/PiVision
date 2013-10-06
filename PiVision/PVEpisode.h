//
//  PVEpisode.h
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVEpisode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *programName;
@property (nonatomic, copy) NSString *channelNumber;
@property (nonatomic, copy) NSString *episodeDescription;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;

// These accessors return startTime and endTime treating midnight as zero
- (NSTimeInterval)indexedStartTime;
- (NSTimeInterval)indexedEndTime;

+ (NSArray *)generateTestChannels;
+ (PVEpisode *)generateTestEpisode;
@end
