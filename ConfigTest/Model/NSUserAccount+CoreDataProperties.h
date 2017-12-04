//
//  NSUserAccount+CoreDataProperties.h
//  ConfigTest
//
//  Created by li bo on 30/11/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "NSUserAccount+CoreDataProperties.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSUserAccount (CoreDataProperties)

+ (NSFetchRequest<NSUserAccount *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *aboutMe;
@property (nullable, nonatomic, copy) NSString *firstname;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSNumber *height;
@property (nullable, nonatomic, copy) NSNumber *weight;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
