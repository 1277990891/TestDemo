//
//  UIImage+NGMethods.h
//  Galaxy
//
//  Created by Roman Kapshuk on 2/13/14.
//  Copyright (c) 2014 Netpulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NGMethods)

- (UIImage*)imageWithAlpha:(CGFloat)alpha;

+ (UIImage*)imageNamed:(NSString*)name withTintColor:(UIColor*)tintColor;

- (UIImage*)imageWithTintColor:(UIColor*)tintColor;

// Composes images successively into one image. Array of alpha values if provided should correspond to array of images.
+ (/*nullable*/ UIImage*)composeImageWithImages:(/*nullable*/ NSArray<UIImage*>*)images alphaValues:(/*nullable*/ NSArray<NSNumber*>*)alphaValues;

+ (UIImage*)dashboardBackgroundImage;
+ (UIImage*)searchBarBackgroundImage;

@end
