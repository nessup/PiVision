//
//  PVGridLayout.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVEpisodeGridLayout.h"

#import "PVEpisodeDataSource.h"
#import "PVEpisode.h"

#define SecondsPerDay                       (60.f*60.f*24.f)
#define SecondsPerHour                      (60.f*60.f)
#define PVGridViewControllerDayHeight       50.f
#define PVGridViewControllerDayWidth        4000.f
#define PixelsPerSecond                     (PVGridViewControllerDayWidth / SecondsPerDay)
#define WidthPerHour                        (SecondsPerHour * PixelsPerSecond)
#define FirstColumnWidth                    WidthPerHour

@implementation PVEpisodeGridLayout

- (CGSize)collectionViewContentSize {
    return (CGSize) {
        PVGridViewControllerDayWidth + FirstColumnWidth,
        self.collectionView.frame.size.height // * rows
    };
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // Cells
    // We call a custom helper method -indexPathsOfItemsInRect: here
    // which computes the index paths of the cells that should be included
    // in rect.
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    // Supplementary views
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes =
        [self layoutAttributesForSupplementaryViewOfKind:@"DayHeaderView"
                                             atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    NSArray *hourHeaderViewIndexPaths = [self indexPathsOfHourHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in hourHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes =
        [self layoutAttributesForSupplementaryViewOfKind:@"HourHeaderView"
                                             atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<PVEpisodeDataSource> dataSource = (id<PVEpisodeDataSource>)self.collectionView.dataSource;
    PVEpisode *episode = [dataSource episodeAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForEpisode:episode atIndexPath:indexPath];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGRect frame;
        
        if (indexPath.section == 0 && indexPath.item == 0) {
            frame = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + self.collectionView.contentInset.top, FirstColumnWidth, PVGridViewControllerDayHeight);
            attributes.zIndex = 20;
        }
        else {
            frame = CGRectMake( WidthPerHour * indexPath.item, self.collectionView.contentOffset.y + self.collectionView.contentInset.top, WidthPerHour, PVGridViewControllerDayHeight);
            attributes.zIndex = 10;
        }
        attributes.frame = frame;
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        CGRect frame = CGRectMake(self.collectionView.contentOffset.x, PVGridViewControllerDayHeight + PVGridViewControllerDayHeight * indexPath.section, FirstColumnWidth, PVGridViewControllerDayHeight);
        attributes.frame = frame;
        attributes.zIndex = 10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
//    CGRect oldBounds = self.collectionView.bounds;
//    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
//        return YES;
//    }
//    return NO;
    return YES;
}

#pragma mark - Utility

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    NSInteger minChannel = [self channelFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxChannel = [self channelFromYCoordinate:CGRectGetMaxY(rect)];
    NSInteger minStartTime = [self secondsFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxEndTime = [self secondsFromXCoordinate:CGRectGetMaxX(rect)];
    
//    NSLog(@"minStart = %d, maxEnd %d", minStartTime, maxEndTime);
    
    id<PVEpisodeDataSource> dataSource = (id<PVEpisodeDataSource>)self.collectionView.dataSource;
    NSArray *indexPaths = [dataSource indexPathsOfEpisodesBetweenMinChannel:minChannel maxChannel:maxChannel minStartTime:minStartTime maxEndTime:maxEndTime];
    return indexPaths;
}

- (NSInteger)secondsFromXCoordinate:(CGFloat)xPosition
{
    CGFloat contentWidth = [self collectionViewContentSize].width;
    NSLog(@"xpos = %f", xPosition);
    return MAX((xPosition) * (SecondsPerDay / contentWidth), 0);
}

- (NSInteger)channelFromYCoordinate:(CGFloat)yPosition
{
    return MAX(yPosition * (1 / PVGridViewControllerDayHeight), 0);
}

- (NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect
{
    NSInteger minDayIndex = [self secondsFromXCoordinate:CGRectGetMinX(rect)] / SecondsPerHour;
    NSInteger maxDayIndex = [self secondsFromXCoordinate:CGRectGetMaxX(rect)] / SecondsPerHour;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minDayIndex; idx <= maxDayIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    // hack to make sure supplemental view at 0,0 is always visible
    if (minDayIndex != 0) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    
    return indexPaths;
}

- (NSArray *)indexPathsOfHourHeaderViewsInRect:(CGRect)rect
{
    NSInteger minHourIndex = [self channelFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self channelFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minHourIndex; idx < self.collectionView.numberOfSections && idx <= maxHourIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (CGRect)frameForEpisode:(PVEpisode *)episode atIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectZero;
    frame.origin.x = FirstColumnWidth + episode.indexedStartTime * (PVGridViewControllerDayWidth / SecondsPerDay);
    frame.origin.y = PVGridViewControllerDayHeight + indexPath.section * PVGridViewControllerDayHeight;
    frame.size.width = (episode.endTime - episode.startTime) * (PVGridViewControllerDayWidth / SecondsPerDay);
    frame.size.height = PVGridViewControllerDayHeight;
    
    return frame;
}

- (CGFloat)xOffsetForDate:(NSDate *)date {
    NSDateComponents *hourComponents = [[[NSCalendar alloc]
                                        initWithCalendarIdentifier:NSGregorianCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    NSInteger hourInteger = [hourComponents hour];
    CGFloat lol = FirstColumnWidth;
    return FirstColumnWidth + WidthPerHour * (hourInteger - 1);
}

@end
