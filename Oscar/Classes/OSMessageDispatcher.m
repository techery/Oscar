//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSMessageDispatcher.h"
#import "OSMessageHandler.h"
#import <RXPromise/RXPromise.h>

@interface OSMessageDispatcher() {
    NSMutableDictionary *_handlers;
}

@end

@implementation OSMessageDispatcher

- (instancetype)init {
    if (self = [super init]) {
        _handlers = [NSMutableDictionary new];
    }
    
    return self;
}

- (RXPromise *)handle:(id)message {
    NSString *key = NSStringFromClass([message class]);
    id<OSMessageHandler> handler = _handlers[key];
    if (handler) {
        return [handler handle:message];
    } else {
        NSError *error = [NSError errorWithDomain:OSActorsErrorDomain code:0 userInfo:@{OSActorsErrorMessageKey : [NSString stringWithFormat:@"Unknown message: %@", key]}];
        RXPromise *promise = [RXPromise new];
        [promise rejectWithReason:error];
        return promise;
    }
}

- (void)on:(Class)messageType do:(OSVoidMessageBlock)handler {
    OSVoidMessageHandler *messageHandler = [[OSVoidMessageHandler alloc] initWithHandler:handler messageType:messageType];
    [self addHandler:messageHandler forMessageType:messageType];
}

- (void)on:(Class)messageType doFuture:(OSFutureMessageBlock)handler {
    OSFutureMessageHandler *messageHandler = [[OSFutureMessageHandler alloc] initWithHandler:handler messageType:messageType];
    [self addHandler:messageHandler forMessageType:messageType];
}

- (void)on:(Class)messageType doResult:(OSResultMessageBlock)handler {
    OSResultMessageHandler *messageHandler = [[OSResultMessageHandler alloc] initWithHandler:handler messageType:messageType];
    [self addHandler:messageHandler forMessageType:messageType];
}

#pragma mark - Private

- (void)addHandler:(id<OSMessageHandler>)handler forMessageType:(Class)messageType {
    NSString *key = [self keyForMessageType:messageType];
    _handlers[key] = handler;
}

- (NSString *)keyForMessageType:(Class)messageType {
    NSString *key = NSStringFromClass(messageType);
    return key;
}


@end