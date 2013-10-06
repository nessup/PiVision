//
//  PVGridHeaderView.h
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface PVGridHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) AsyncImageView *imageView;
@end
