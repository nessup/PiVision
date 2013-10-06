//
//  PVGridHeaderView.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVGridHeaderView.h"

#import "AsyncImageView.h"

@implementation PVGridHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_label];
        
//        _imageView = [AsyncImageView new];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    self.label.frame = (CGRect) {
        0.f,
        roundf(self.frame.size.height/2.f - self.label.font.lineHeight/2.f),
        self.frame.size.width,
        self.label.font.lineHeight
    };
}

@end
