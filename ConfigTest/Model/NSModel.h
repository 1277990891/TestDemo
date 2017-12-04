//
//  NSModel.h
//  ConfigTest
//
//  Created by li bo on 30/11/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGRequestWrapper.h"

@class NSUserAccount;

typedef void (^ NGModelRequestCompletionBlock)(id resultObject, NSError* error);


@interface NSModel : NSObject

@property (nonatomic, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;


@property (nonatomic, strong) NGObjectFillHelper* objectFillHelper;
@property (nonatomic, strong) NGRequestWrapper* requestWrapper;


- (NSUserAccount*)userWithUUID:(NSString*)uuid createNew:(BOOL)createNew;

- (NSOperation*)loginSuccessWithUUID:(NSString*)uuid login:(NSString*)login password:(NSString*)password completionBlock:(NGModelRequestCompletionBlock)completionBlock;

- (NSOperation*)updateUserProfileWithUserUUID:(NSString*)userUUID firstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email measurementUnit:(NSString*)measurementUnit gender:(NSString*)gender homeClub:(NSString*)homeclub birthday:(NSDate*)birthdayDate weight:(NSNumber*)weight height:(NSNumber*)height newPassword:(NSString*)newPassword  withCompletionBlock:(NGModelRequestCompletionBlock)completionBlock;

@end
