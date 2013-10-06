//
//  PVGridCell.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVGridCell.h"

#define Margins          5.f
#define ExtraRightMargin 2.f

@interface PVGridCell ()
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;
@end

@implementation PVGridCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _boxView = [UIView new];
        _boxView.backgroundColor = [UIColor lightGrayColor];
        _boxView.layer.borderColor = [UIColor grayColor].CGColor;
        _boxView.layer.borderWidth = 1.f;
        [self addSubview:_boxView];
        
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.backgroundColor = _boxView.backgroundColor;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    self.boxView.frame = (CGRect) {
        CGPointZero,
        self.frame.size.width - ExtraRightMargin,
        self.frame.size.height
    };
    self.textLabel.frame = (CGRect) {
        Margins,
        Margins,
        self.frame.size.width - 2.f*Margins - ExtraRightMargin
    };
}

@end
