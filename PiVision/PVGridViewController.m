//
//  PVScheduleViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVGridViewController.h"

#import "PVRoviManager.h"
#import "PVEpisode.h"
#import "PVGridCell.h"
#import "PVEpisodeGridLayout.h"
#import "PVGridHeaderView.h"
#import "PVEpisodeViewController.h"

#define PVGridViewControllerDayWidth        2400.f
#define PVGridViewControllerDayHeight       60.f

@interface PVGridViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PVEpisodeGridLayout *gridLayout;
@end

@implementation PVGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[PVRoviManager sharedManager] addObserver:self forKeyPath:@"channels" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.f animations:^{
        CGFloat xOffset = [self.gridLayout xOffsetForDate:[NSDate date]];
        self.collectionView.contentOffset = (CGPoint) {
            xOffset,
            self.collectionView.contentOffset.y
        };
    }];
}

- (void)dealloc {
    [[PVRoviManager sharedManager] removeObserver:self forKeyPath:@"channels"];
}

#pragma mark - Channels

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"channels"]) {
        [self.collectionView reloadData];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSArray *)channels {
    return [[PVRoviManager sharedManager] channels];
}

#pragma mark - Collection view

- (PVEpisodeGridLayout *)gridLayout {
    if (_gridLayout)
        return _gridLayout;
    
    _gridLayout = [PVEpisodeGridLayout new];
    
    return _gridLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView)
        return _collectionView;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridLayout];
    _collectionView.frame = self.view.bounds;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.directionalLockEnabled = YES;
    [_collectionView registerClass:[PVGridCell class] forCellWithReuseIdentifier:@"GridCell"];
    [self.collectionView registerClass:[PVGridHeaderView class] forSupplementaryViewOfKind:@"DayHeaderView" withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerClass:[PVGridHeaderView class] forSupplementaryViewOfKind:@"HourHeaderView" withReuseIdentifier:@"HeaderView"];
    
    return _collectionView;
}

// This is useless for PVEpisodeGridLayout.
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self numberOfChannels] ?: 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [[self.channels[section] episodes] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PVGridCell *cell = (PVGridCell *)[cv dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    PVEpisode *episode = [self episodeAtIndexPath:indexPath];
    cell.textLabel.text = episode.title;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PVGridHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    if ([kind isEqualToString:@"DayHeaderView"]) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            headerView.label.text = @"Today";
            headerView.label.textAlignment = NSTextAlignmentCenter;
        }
        else {
            NSInteger hour = (indexPath.item - 1) % 12;
            if (hour == 0) {
                hour = 12;
            }
            NSString *amPm = nil;
            if (indexPath.item >= 12) {
                amPm = @"pm";
            }
            else {
                amPm = @"am";
            }
            headerView.label.text = [NSString stringWithFormat:@"%2d:00 %@", hour, amPm];
            headerView.label.textAlignment = NSTextAlignmentLeft;
        }
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        PVChannel *channel = [self.channels objectAtIndex:indexPath.section + 1];
        headerView.label.text = channel.displayName;
        headerView.label.textAlignment = NSTextAlignmentCenter;
    }
    return headerView;
}

#pragma mark - PVEpisode data source

- (NSInteger)numberOfChannels {
    return self.channels.count;
}

- (PVEpisode *)episodeAtIndexPath:(NSIndexPath *)indexPath {
    return [self.channels[indexPath.section] episodes][indexPath.item];
}

- (NSArray *)indexPathsOfEpisodesBetweenMinChannel:(NSInteger)minChannel maxChannel:(NSInteger)maxChannel minStartTime:(NSTimeInterval)minStartTime maxEndTime:(NSTimeInterval)maxEndTime {
    NSMutableArray *indexPaths = [NSMutableArray new];
    
    // This is inefficient -- we should be using a for loop here.
    for (PVChannel *channel in self.channels) {
        NSInteger channelIndex = [self.channels indexOfObject:channel];
        
        for (PVEpisode *episode in channel.episodes) {
            if (channelIndex < minChannel)
                continue;
            
            if (channelIndex > maxChannel)
                continue;
            
            if (episode.indexedStartTime < minStartTime)
                continue;
            
            if (episode.indexedEndTime > maxEndTime)
                continue;
            
            [indexPaths addObject:[NSIndexPath indexPathForItem:[channel.episodes indexOfObject:episode] inSection:channelIndex]];
        }
    }
    
    return indexPaths;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PVEpisode *episode = [self episodeAtIndexPath:indexPath];
    PVEpisodeViewController *controller = [PVEpisodeViewController new];
    controller.episode = episode;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
