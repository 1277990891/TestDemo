//
//  UIImage+NGMethods.m
//  Galaxy
//
//  Created by Roman Kapshuk on 2/13/14.
//  Copyright (c) 2014 Netpulse. All rights reserved.
//

#import "UIImage+NGMethods.h"

@implementation UIImage (NGMethods)

- (UIImage*)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetAlpha(context, alpha);
    
    CGContextDrawImage(context, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//+ (UIImage*)imageWithColor:(UIColor*)color
//{
//    return [color image];
//}

+ (UIImage*)imageNamed:(NSString*)name withTintColor:(UIColor*)tintColor
{
    return [UIImage tintImage:[UIImage imageNamed:name] withColor:tintColor];
}

- (UIImage*)imageWithTintColor:(UIColor*)tintColor
{
    return [UIImage tintImage:self withColor:tintColor];
}

+ (UIImage*)composeImageWithImages:(NSArray<UIImage*>*)images alphaValues:(NSArray<NSNumber*>*)alphaValues
{
    UIImage* result = nil;

    if (images.count > 0)
    {
        CGSize dimensions = CGSizeZero;

        for (UIImage* image in images)
        {
            CGSize size = image.size;

            if (dimensions.width < size.width)
            {
                dimensions.width = size.width;
            }

            if (dimensions.height < size.height)
            {
                dimensions.height = size.height;
            }
        }

        if (!CGSizeEqualToSize(dimensions, CGSizeZero))
        {
            UIGraphicsBeginImageContextWithOptions(dimensions, NO, 0);

            CGContextRef context = UIGraphicsGetCurrentContext();

            CGContextScaleCTM(context, 1, -1);
            CGContextTranslateCTM(context, 0, -dimensions.height);

            BOOL shouldApplyAlpha = alphaValues.count == images.count;

            for (NSUInteger index = 0; index < images.count; index++)
            {
                UIImage* image = images[index];

                CGPoint origin = CGPointZero;
                CGSize size = image.size;

                CGFloat diff = dimensions.width - size.width;
                if (diff > FLT_EPSILON)
                {
                    origin.x = round(diff / 2);
                }

                diff = dimensions.height - size.height;
                if (diff > FLT_EPSILON)
                {
                    origin.y = round(diff / 2);
                }

                CGRect imageRect = CGRectMake(origin.x, origin.y, size.width, size.height);

                if (shouldApplyAlpha)
                {
                    CGContextSetAlpha(context, [alphaValues[index] floatValue]);
                }

                CGContextDrawImage(context, imageRect, image.CGImage);
            }

            result = UIGraphicsGetImageFromCurrentImageContext();

            UIGraphicsEndImageContext();
        }
    }

    return result;
}


+ (UIImage*)searchBarBackgroundImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(7.0f, 24.0f), NO, 0.0f);
    
    [[UIColor grayColor] setStroke];
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1.f, 1.f, 5.0f, 22.0f) cornerRadius:2.0f];
    path.lineWidth = 1.0f;
    [path stroke];
    
    UIImage* searchBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [searchBarBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f)];
}


#pragma mark - Private

+ (UIImage*)tintImage:(UIImage*)image withColor:(UIColor*)tintColor
{
    UIGraphicsBeginImageContextWithOptions (image.size, NO, [[UIScreen mainScreen] scale]); // for correct resolution on retina, thanks @MobileVet
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // draw tint color
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, rect, image.CGImage);
    
    UIImage* coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

@end
