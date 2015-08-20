//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorConstants.h"


@interface DTMessageDispatcher : NSObject

- (void)on:(Class)messageType do:(DTVoidMessageBlock)handler;
- (void)on:(Class)messageType doFuture:(DTFutureMessageBlock)handler;
- (void)on:(Class)messageType doResult:(DTResultMessageBlock)handler;

- (RXPromise *)handle:(id)message;

@end