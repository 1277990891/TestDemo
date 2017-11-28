//
//  NGCascadeRequestOperation.h
//  Galaxy
//
//  Created by Roman Kapshuk on 13/12/13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@interface NGCascadeRequestOperation : AFJSONRequestOperation

- (void)addChildOperation:(NSOperation*)childOperation;
- (void)cancel;

@end
