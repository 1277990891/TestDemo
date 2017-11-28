//
//  CustomDefines.h
//  ConfigTest
//
//  Created by li bo on 11/7/17.
//  Copyright © 2017 li bo. All rights reserved.
//

#ifndef CustomDefines_h
#define CustomDefines_h

#define SAFE_SET_OBJECT(dictionary, key, value) if (nil != value)[dictionary setObject:value forKey:key]
#define SAFE_GET_OBJECT(dictionary, key) ([[dictionary objectForKey:key] isEqual:[NSNull null]] ? nil : [dictionary objectForKey:key])
#define SAFE_GET_STRING(stringValue) (stringValue != nil) ? stringValue : @""
#define SAFE_ADD_OBJECT(array, value) if (nil != value)[array addObject:value]
#define SAFE_ADD_STRING(array, value) if ([value length] > 0)[array addObject:value]
#define SAFE_GET_OBJECT_AT_INDEX(array, index) ([array count] > index) ? [array objectAtIndex:index] : nil


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define  iOS7 [[UIDevice currentDevice].systemVersion doubleValue]>=7.0

#define kNavBtnWidth 30
#define kNavBtnHeight 30

#define IPHONE6P [UIScreen mainScreen].bounds.size.height > 667.0
#define IPHONE6 [UIScreen mainScreen].bounds.size.height <= 667.0 && [UIScreen mainScreen].bounds.size.height >568.0
#define IPHONE5 [UIScreen mainScreen].bounds.size.height <= 568.0 && [UIScreen mainScreen].bounds.size.height >480.0
#define IPHONE4 [UIScreen mainScreen].bounds.size.height <= 480.0


// notification
#define kSettingPlanChangeNotification @"SettingPlanChangeNotification"


#endif
