//
//  NGCascadeRequestOperation.m
//  Galaxy
//
//  Created by Roman Kapshuk on 13/12/13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "NGCascadeRequestOperation.h"

@interface NGCascadeRequestOperation ()

@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, strong) NSMutableArray* childOperations;

@end

@implementation NGCascadeRequestOperation

@dynamic lock;

- (void)addChildOperation:(NSOperation*)childOperation
{
    if (childOperation != nil)
    {
        [self.lock lock];
        if (!self.isCancelled)
        {
            if (self.childOperations == nil)
            {
                self.childOperations = [[NSMutableArray alloc] init];
            }
            [self.childOperations addObject:childOperation];
        }
        else
        {
            [childOperation cancel];
        }
        [self.lock unlock];
    }
}

- (void)cancel
{
    [self.lock lock];
    [self.childOperations enumerateObjectsUsingBlock:^(NSOperation* operation, NSUInteger idx, BOOL* stop) {
        [operation cancel];
    }];
    [super cancel];
    [self.lock unlock];
}

@end
