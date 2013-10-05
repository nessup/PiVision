//
//  PVSegmentedViewController.h
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PVSegmentedControl;

@interface PVSegmentedViewController : UIViewController
@property (nonatomic, strong, readonly) PVSegmentedControl *segmentedControlView;
@property (nonatomic) NSInteger selectedIndex;
- (void)setViewControllers:(NSArray *)controller titles:(NSArray *)titles;
- (void)selectedIndexDidChange;
@end
