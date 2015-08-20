//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActorConstants.h"


@interface OSMessageDispatcher : NSObject

- (void)on:(Class)messageType do:(OSVoidMessageBlock)handler;
- (void)on:(Class)messageType doFuture:(OSFutureMessageBlock)handler;
- (void)on:(Class)messageType doResult:(OSResultMessageBlock)handler;

- (RXPromise *)handle:(id)message;

@end