//
//  PVSegmentedControl.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVSegmentedControl.h"

@interface PVSegmentedControl ()
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@end

@implementation PVSegmentedControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _segmentedControl = [UISegmentedControl new];
        [self addSubview:_segmentedControl];
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    [self.segmentedControl removeAllSegments];
    int i = 0;
    for (NSString *item in items) {
        [self.segmentedControl insertSegmentWithTitle:item atIndex:i animated:NO];
        i++;
    }
}

- (void)layoutSubviews {
    [self.segmentedControl sizeToFit];
    self.segmentedControl.frame = (CGRect) {
        roundf(self.frame.size.width/2.f - self.segmentedControl.frame.size.width/2.f),
        roundf(PVSegmentedControlHeight/2.f - self.segmentedControl.frame.size.height/2.f),
        self.segmentedControl.frame.size
    };
}

@end
