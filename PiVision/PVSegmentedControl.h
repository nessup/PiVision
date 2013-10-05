//
//  PVSegmentedControl.h
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PVSegmentedControlHeight          56.f

@interface PVSegmentedControl : UIView
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;
- (void)setItems:(NSArray *)items;
@end
