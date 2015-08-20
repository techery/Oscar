//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorConstants.h"

@protocol DTMessageHandler
- (RXPromise *)handle:(id)message;
@end

@interface DTBaseMessageHandler: NSObject <DTMessageHandler>

@property(nonatomic, readonly) Class messageType;

- (instancetype)initWithMessageType:(Class)messageType;

@end

@interface DTVoidMessageHandler : DTBaseMessageHandler<DTMessageHandler>
- (instancetype)initWithHandler:(DTVoidMessageBlock)handler messageType:(Class)messageType;
@end

@interface DTFutureMessageHandler : DTBaseMessageHandler<DTMessageHandler>
- (instancetype)initWithHandler:(DTFutureMessageBlock)handler messageType:(Class)messageType;;
@end

@interface DTResultMessageHandler : DTBaseMessageHandler<DTMessageHandler>
- (instancetype)initWithHandler:(DTResultMessageBlock)handler messageType:(Class)messageType;;
@end