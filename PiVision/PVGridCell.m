//
//  PVGridCell.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVGridCell.h"

#define TextMargin          10.f
#define BoxMargin           2.f

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
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    self.boxView.frame = (CGRect) {
        BoxMargin,
        BoxMargin,
        self.frame.size.width - 2.f*BoxMargin,
        self.frame.size.height - 2.f*BoxMargin
    };
    self.textLabel.frame = (CGRect) {
        TextMargin,
        TextMargin,
        self.frame.size.width - 2.f*TextMargin - BoxMargin,
        self.textLabel.font.lineHeight
    };
    [self.textLabel centerVertically];
}

@end
