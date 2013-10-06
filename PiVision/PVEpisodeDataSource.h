//
//  PVEpisodeDataSource.h
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVEpisode;

@protocol PVEpisodeDataSource <NSObject>

- (NSInteger)numberOfChannels;
- (PVEpisode *)episodeAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)indexPathsOfEpisodesBetweenMinChannel:(NSInteger)minChannel maxChannel:(NSInteger)maxChannel minStartTime:(NSTimeInterval)minStartTime maxEndTime:(NSTimeInterval)maxEndTime;

@end