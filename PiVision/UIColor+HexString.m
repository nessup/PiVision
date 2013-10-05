//
//  UIColor+HexString.m
//  Circle
//
//  Created by Dany Joumaa on 30/06/2012.
//  Copyright (c) 2012 Circle. All rights reserved.
//

#import "UIColor+HexString.h"

static NSMutableDictionary *_hexColorCache;

@implementation UIColor (HexString)

+ (void)initialize {
    _hexColorCache = [NSMutableDictionary dictionary];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;

    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    UIColor *cacheResult;

    if( (cacheResult = [_hexColorCache valueForKey:hexString]) != nil ) {
        return cacheResult;
    }

    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch( [colorString length] ) {
      case 3:   // #RGB
          alpha = 1.0f;
          red   = [self colorComponentFrom:colorString start:0 length:1];
          green = [self colorComponentFrom:colorString start:1 length:1];
          blue  = [self colorComponentFrom:colorString start:2 length:1];
          break;

      case 4:   // #ARGB
          alpha = [self colorComponentFrom:colorString start:0 length:1];
          red   = [self colorComponentFrom:colorString start:1 length:1];
          green = [self colorComponentFrom:colorString start:2 length:1];
          blue  = [self colorComponentFrom:colorString start:3 length:1];
          break;

      case 6:   // #RRGGBB
          alpha = 1.0f;
          red   = [self colorComponentFrom:colorString start:0 length:2];
          green = [self colorComponentFrom:colorString start:2 length:2];
          blue  = [self colorComponentFrom:colorString start:4 length:2];
          break;

      case 8:   // #AARRGGBB
          alpha = [self colorComponentFrom:colorString start:0 length:2];
          red   = [self colorComponentFrom:colorString start:2 length:2];
          green = [self colorComponentFrom:colorString start:4 length:2];
          blue  = [self colorComponentFrom:colorString start:6 length:2];
          break;

      default:
          @throw [NSException exceptionWithName:@"Bad color hex string" reason:[NSString stringWithFormat:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString] userInfo:nil];
          return nil;

          break;
    }

    UIColor *ret = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

    [_hexColorCache setValue:ret forKey:hexString];

    return ret;
}

@end