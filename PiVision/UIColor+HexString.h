//
//  UIColor+HexString.h
//  Circle
//
//  Created by Dany Joumaa on 30/06/2012.
//  Copyright (c) 2012 Circle. All rights reserved.
//

@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;
@end
