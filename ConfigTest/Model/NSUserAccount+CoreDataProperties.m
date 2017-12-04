//
//  NSUserAccount+CoreDataProperties.m
//  ConfigTest
//
//  Created by li bo on 30/11/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "NSUserAccount+CoreDataProperties.h"

@implementation NSUserAccount (CoreDataProperties)

+ (NSFetchRequest<NSUserAccount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NSUserAccount"];
}

@dynamic password;
@dynamic aboutMe;
@dynamic firstname;
@dynamic email;
@dynamic gender;
@dynamic height;
@dynamic weight;
@dynamic uuid;

@end
