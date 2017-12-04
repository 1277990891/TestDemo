//
//  NSModel.m
//  ConfigTest
//
//  Created by li bo on 30/11/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "NSModel.h"
#import "NSUserAccount+CoreDataProperties.h"

@interface NSModel ()
@property (nonatomic) NSString* sessionCookie;
@property (nonatomic) NSString* currentUserUUID;
@property (nonatomic, strong)NSUserAccount* userAccount;

@property (nonatomic, strong) NSMutableSet* runningOperations;


@end
@implementation NSModel

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id)initWithUserUUID:(NSString*)userUUID sessionCookie:(NSString*)sessionCookie
{
    self = [self init];

    self.currentUserUUID = userUUID;
    self.sessionCookie = sessionCookie;

    return self;
}
- (id)init
{
    if (nil != (self = [super init]))
    {
        self.objectFillHelper = [[NGObjectFillHelper alloc] init];
        self.runningOperations = [NSMutableSet set];
        self.requestWrapper = [NGRequestWrapper sharedInstance];

        [self createCoreDataStack];
    }
    return self;
}
- (void)reset
{
    [self.runningOperations makeObjectsPerformSelector:@selector(cancel)];
    [self.runningOperations removeAllObjects];
    self.userAccount = nil;
    self.sessionCookie = nil;
    [self.requestWrapper setSessionToken:nil];
}
- (void)createCoreDataStack
{
    //managed object model
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"CurrentModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    //persistent store
    NSError* error = nil;
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CurrentModel.sqlite"];

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
        [[NSFileManager defaultManager] removeItemAtURL:[self externalResourcesDirectoryURL] error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtURL:[storeURL URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];

        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    //managed object context
    if (_persistentStoreCoordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
}
- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}
- (NSURL*)externalResourcesDirectoryURL
{
    NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
    return [url URLByAppendingPathComponent:@"CurrentModel"];
}
- (void)operationDidStart:(NSOperation*)operation
{
    if (operation != nil)
    {
        [self.runningOperations addObject:operation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationFinished:) name:AFNetworkingOperationDidFinishNotification object:operation];
    }
}
- (void)operationFinished:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingOperationDidFinishNotification object:[notification object]];
    [self.runningOperations removeObject:[notification object]];
}

//- (void)loadCurrentUserWithUUID:(NSString*)uuid authenticationData:(NSDictionary*)authData sessionToken:(NSString*)sessionToken createNew:(BOOL)createNew
//{
//    self.currentUserUUID = uuid;
//    self.sessionCookie = sessionToken;
//
//    [self.requestWrapper setSessionToken:sessionToken];
//
//    NSUserAccount* user = [self userWithUUID:uuid createNew:createNew];
//
//    if ([authData count] > 0)
//    {
////        [self.objectFillHelper fillCurrentUser:user withAuthResponse:authData isSignInResponce:YES];
//    }
//
//    NSError* error = nil;
//    [self.managedObjectContext save:&error];
//    if (nil != error)
//    {
//        NSLog(@"Failed to save context. Error:%@", error);
//    }
//    else
//    {
//        self.userAccount = user;
//    }
//}

- (NSUserAccount*)userWithUUID:(NSString*)uuid createNew:(BOOL)createNew;
{
    NSUserAccount* resultUser = [self fetchUserWithUUID:uuid templateName:@"UserWithUUID"];

    if (nil == resultUser && createNew)
    {
        resultUser = [self createUserWithUUID:uuid entityName:@"NSUserAccount"];
    }

    return resultUser;
}
- (id)fetchUserWithUUID:(NSString*)uuid templateName:(NSString*)templateName
{
    NSUserAccount* resultUser = nil;
    NSFetchRequest* fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:templateName substitutionVariables:@{@"UUID": uuid}];
    NSError* error = nil;
    NSArray* fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (nil != error)
    {
        NSLog(@"Failed to fetch user with UUID: %@. Error: %@", uuid, error);
    }
    else
    {
        resultUser = [fetchResults lastObject];
    }

    return resultUser;
}
- (id)createUserWithUUID:(NSString*)uuid entityName:(NSString*)entityName
{
    NSUserAccount* newUser = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    newUser.uuid = uuid;
    return newUser;
}

#pragma ---- login ---

- (NSOperation*)loginSuccessWithUUID:(NSString*)uuid login:(NSString*)login password:(NSString*)password completionBlock:(NGModelRequestCompletionBlock)completionBlock
{
    NSOperation* operation = [self.requestWrapper signInWithUsername:login password:password newHomeClubUUID:nil memberID:uuid success:^(id responseObject, NSString* cookie, NSDictionary* statusDescription)
    {
        NSError* error = nil;
        if (nil == error)
        {
            self.currentUserUUID = [responseObject objectForKey:@"uuid"];
            self.userAccount = [self userWithUUID:self.currentUserUUID createNew:YES];

            completionBlock(responseObject, nil);
        }
        else
        {
            completionBlock(nil, error);
        }
    } failure:^(NSError* error) {
        completionBlock(nil, error);
    }];

    [self operationDidStart:operation];
    return operation;
}

#pragma ---- update profile ---

- (NSOperation*)updateUserProfileWithUserUUID:(NSString*)userUUID firstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email measurementUnit:(NSString*)measurementUnit gender:(NSString*)gender homeClub:(NSString*)homeclub birthday:(NSDate*)birthdayDate weight:(NSNumber*)weight height:(NSNumber*)height newPassword:(NSString*)newPassword  withCompletionBlock:(NGModelRequestCompletionBlock)completionBlock
{
    __block NGCascadeRequestOperation* operation = nil;
    __weak NSModel* weakSelf = self;

    operation = (NGCascadeRequestOperation*)[self.requestWrapper updateUserProfileWithUserUUID:userUUID firstName:firstName lastName:lastName email:email measurementUnit:measurementUnit gender:gender birthday:birthdayDate weight:weight height:height aboutMe:nil homeClub:homeclub profilePhoto:nil street1:nil street2:nil city:nil country:nil stateOrProvince:nil postalCode:nil phoneNumber:nil clientLoginId:nil picturePassword:nil privacy:nil timezone:nil passcode:nil oldPassword:nil newPassword:newPassword confirmPassword:newPassword successBlock:^(id responseObject, NSString *cookie, NSDictionary *statusDescription) {

        // update profile
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSOperation* loadUserProfileOperation = [strongSelf updateUserProfileWithCompletionBlock:^(id resultObject, NSError* error) {
            completionBlock(resultObject, error);
        }];
        [operation addChildOperation:loadUserProfileOperation];
    } failure:^(NSError* error) {
        completionBlock(nil, error);
    }];

    [self operationDidStart:operation];
    return operation;
}
- (NSOperation*)updateUserProfileWithCompletionBlock:(NGModelRequestCompletionBlock)completionBlock
{
    NSOperation* operation = [self.requestWrapper loadUserProfileWithUserUUID:self.currentUserUUID successBlock:^(id responseObject) {

        // ----- 更新数据库----- //
        [self.objectFillHelper fillProfileForUser:self.userAccount fromResponse:responseObject];

        NSError* error = nil;
        [self.managedObjectContext save:&error];
        if (nil != error)
        {
            completionBlock(nil, error);
        }
        else
        {
            completionBlock(self.userAccount, nil);
        }
    } failure:^(NSError* error) {
        completionBlock(nil, error);

    }];
    [self operationDidStart:operation];
    return operation;
}


@end
