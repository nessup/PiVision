//
//  PVEpisode.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVEpisode.h"

@implementation PVEpisode {
    NSTimeInterval _indexedStartTime;
    NSTimeInterval _indexedEndTime;
}

+ (NSArray *)generateTestChannels {
    NSMutableArray *channels = [NSMutableArray new];
 
    for (int i = 0; i < 3; i++) {
        NSMutableArray *episodes = [NSMutableArray new];
        
        NSTimeInterval runningTime = [[NSDate date] timeIntervalSince1970];
        
        {
            PVEpisode *e = [PVEpisode new];
            e.title = @"Best Show Ever";
            e.startTime = runningTime;
            e.endTime = runningTime + 1800;
            runningTime += 1800;
            e.channelNumber = [NSString stringWithFormat:@"%d", i];
            e.programName = @"Glee";
            [episodes addObject:e];
            

        }
        
        {
            PVEpisode *e = [PVEpisode new];
            e.title = @"Best Show Ever";
            e.startTime = runningTime;
            e.endTime = runningTime + 1800;
            runningTime += 1800;
            e.channelNumber = [NSString stringWithFormat:@"%d", i];
            e.programName = @"Glee";
            [episodes addObject:e];
        }
        
        {
            PVEpisode *e = [PVEpisode new];
            e.title = @"Best Show Ever";
            e.startTime = runningTime;
            e.endTime = runningTime + 3600;
            runningTime += 3600;
            e.channelNumber = [NSString stringWithFormat:@"%d", i];
            e.programName = @"Glee";
            [episodes addObject:e];
        }
        
        {
            PVEpisode *e = [PVEpisode new];
            e.title = @"Best Show Ever";
            e.startTime = runningTime;
            e.endTime = runningTime + 1800;
            runningTime += 1800;
            e.channelNumber = [NSString stringWithFormat:@"%d", i];
            e.programName = @"Glee";
            [episodes addObject:e];
        }
        [channels addObject:episodes];
    }

    return channels;
}

+ (PVEpisode *)generateTestEpisode {
            NSTimeInterval runningTime = [[NSDate date] timeIntervalSince1970];
    {
        PVEpisode *e = [PVEpisode new];
        e.title = @"Best Show Ever";
        e.startTime = runningTime;
        e.endTime = runningTime + 1800;
        runningTime += 1800;
        e.channelNumber = [NSString stringWithFormat:@"%d", 2];
        e.programName = @"Glee";
        return e;
    }
}

- (id)init {
    if (self = [super init]) {
        _indexedStartTime = -1;
        _indexedEndTime = -1;
    }
    return self;
}

- (NSTimeInterval)indexedStartTime {
    if (_indexedStartTime != -1)
        return _indexedStartTime;
    
    _indexedStartTime = [[self class] computeSecondsSinceMidnight:self.startTime];
    
    return _indexedStartTime;
}

- (NSTimeInterval)indexedEndTime {
    if (_indexedEndTime != -1)
        return _indexedEndTime;
    
    _indexedEndTime = [[self class] computeSecondsSinceMidnight:self.endTime];
    
    return _indexedEndTime;
}

+ (NSTimeInterval)computeSecondsSinceMidnight:(NSTimeInterval)timestamp {
    NSCalendar* curCalendar = [NSCalendar currentCalendar];
    const unsigned units    = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* comps = [curCalendar components:units fromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    int hour = [comps hour];
    int min  = [comps minute];
    int sec  = [comps second];
    
    return ((hour * 60) + min) * 60 + sec;
}

@end
