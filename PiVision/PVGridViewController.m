//
//  PVScheduleViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVGridViewController.h"

#import "PVEpisode.h"
#import "PVGridCell.h"
#import "PVEpisodeGridLayout.h"
#import "PVGridHeaderView.h"

#define PVGridViewControllerDayWidth        2400.f
#define PVGridViewControllerDayHeight       60.f

@interface PVGridViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *channels;
@end

@implementation PVGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _channels = [PVEpisode generateTestChannels];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Collection view

- (UICollectionView *)collectionView {
    if (_collectionView)
        return _collectionView;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[PVEpisodeGridLayout new]];
    _collectionView.frame = self.view.bounds;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor greenColor];
    [_collectionView registerClass:[PVGridCell class] forCellWithReuseIdentifier:@"GridCell"];
    [self.collectionView registerClass:[PVGridHeaderView class] forSupplementaryViewOfKind:@"DayHeaderView" withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerClass:[PVGridHeaderView class] forSupplementaryViewOfKind:@"HourHeaderView" withReuseIdentifier:@"HeaderView"];
    
    return _collectionView;
}

// This is useless for PVEpisodeGridLayout.
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self numberOfChannels];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.channels[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PVGridHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    if ([kind isEqualToString:@"DayHeaderView"]) {
        NSInteger hour = (indexPath.item + 1) % 12;
        NSString *amPm = nil;
        if (indexPath.item > 11) {
            amPm = @"pm";
        }
        else {
            amPm = @"am";
        }
        headerView.label.text = [NSString stringWithFormat:@"%2d:00 %@", hour, amPm];
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        headerView.label.text = [NSString stringWithFormat:@"Channel %d", indexPath.section + 1];
    }
    return headerView;
}

#pragma mark - PVEpisode data source

- (NSInteger)numberOfChannels {
    return self.channels.count;
}

- (PVEpisode *)episodeAtIndexPath:(NSIndexPath *)indexPath {
    return self.channels[indexPath.section][indexPath.item];
}

- (NSArray *)indexPathsOfEpisodesBetweenMinChannel:(NSInteger)minChannel maxChannel:(NSInteger)maxChannel minStartTime:(NSTimeInterval)minStartTime maxEndTime:(NSTimeInterval)maxEndTime {
    NSMutableArray *indexPaths = [NSMutableArray new];
    
    // This is inefficient -- we should be using a for loop here.
    for (NSArray *episodes in self.channels) {
        for (PVEpisode *episode in episodes) {
            if (episode.channel < minChannel)
                continue;
            
            if (episode.channel > maxChannel)
                continue;
            
            if (episode.startTime < minStartTime)
                continue;
            
            if (episode.endTime > maxEndTime)
                continue;
            
            [indexPaths addObject:[NSIndexPath indexPathForItem:[episodes indexOfObject:episode] inSection:episode.channel]];
        }
    }
    
    return indexPaths;
}

@end
