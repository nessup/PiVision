//
//  PVEpisode.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVEpisode.h"

@implementation PVEpisode

+ (NSArray *)generateTestChannels {
    NSMutableArray *channels = [NSMutableArray new];
 
    for (int i = 0; i < 3; i++) {
        NSMutableArray *episodes = [NSMutableArray new];
        {
            PVEpisode *e = [PVEpisode new];
            e.startTime = 0;
            e.endTime = 1800;
            e.channel = i;
            [episodes addObject:e];
        }
        
        {
            PVEpisode *e = [PVEpisode new];
            e.startTime = 1800;
            e.endTime = 3600;
            e.channel = i;
            [episodes addObject:e];
        }
        
        {
            PVEpisode *e = [PVEpisode new];
            e.startTime = 3600;
            e.endTime = 7200;
            e.channel = i;
            [episodes addObject:e];
        }
        
        {
            PVEpisode *e = [PVEpisode new];
            e.startTime = 7200;
            e.endTime = 10800;
            e.channel = i;
            [episodes addObject:e];
        }
        [channels addObject:episodes];
    }

    return channels;
}

@end
