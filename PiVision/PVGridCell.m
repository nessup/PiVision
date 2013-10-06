//
//  PVGridCell.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVGridCell.h"

#define TextMargin          5.f
#define BottomRightMargin   2.f

@interface PVGridCell ()
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;
@end

@implementation PVGridCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _boxView = [UIView new];
        _boxView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        _boxView.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        _boxView.layer.borderWidth = [PVUtility crispStrokeWidth];
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
        self.frame.size.width - BottomRightMargin,
        self.frame.size.height - BottomRightMargin
    };
    self.textLabel.frame = (CGRect) {
        TextMargin,
        TextMargin,
        self.frame.size.width - 2.f*TextMargin - BottomRightMargin
    };
}

@end
