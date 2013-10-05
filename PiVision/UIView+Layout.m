//
//  UIView+Layout.m
//  Notes
//
//  Created by Dany on 6/23/13.
//  Copyright (c) 2013 Dany. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)centerMiddle  {
    [self centerHorizontally];
    [self centerVertically];
}

- (void)centerHorizontally {
    self.frame = (CGRect) {
        roundf(self.superview.frame.size.width / 2.f - self.frame.size.width / 2.f),
        self.frame.origin.y,
        self.frame.size
    };
}

- (void)centerVertically {
    self.frame = (CGRect) {
        self.frame.origin.x,
        roundf(self.superview.frame.size.height / 2.f - self.frame.size.height / 2.f),
        self.frame.size
    };
}

@end
