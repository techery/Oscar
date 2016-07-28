//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActorConstants.h"

@protocol OSMessageHandler
- (RXPromise *)handle:(id)message;
@end

@interface OSBaseMessageHandler: NSObject <OSMessageHandler>

@property(nonatomic, readonly) Class messageType;

- (instancetype)initWithMessageType:(Class)messageType;

@end

@interface OSVoidMessageHandler : OSBaseMessageHandler<OSMessageHandler>
- (instancetype)initWithHandler:(OSVoidMessageBlock)handler messageType:(Class)messageType;
@end

@interface OSFutureMessageHandler : OSBaseMessageHandler<OSMessageHandler>
- (instancetype)initWithHandler:(OSFutureMessageBlock)handler messageType:(Class)messageType;;
@end

@interface OSResultMessageHandler : OSBaseMessageHandler<OSMessageHandler>
- (instancetype)initWithHandler:(OSResultMessageBlock)handler messageType:(Class)messageType;;
@end