//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTMessageDispatcher.h"
#import "DTMessageHandler.h"
#import <RXPromise/RXPromise.h>

@interface DTMessageDispatcher() {
    NSMutableDictionary *_handlers;
}

@end

@implementation DTMessageDispatcher

- (instancetype)init {
    if (self = [super init]) {
        _handlers = [NSMutableDictionary new];
    }
    
    return self;
}

- (RXPromise *)handle:(id)message {
    NSString *key = NSStringFromClass([message class]);
    id<DTMessageHandler> handler = _handlers[key];
    if (handler) {
        return [handler handle:message];
    } else {
        NSError *error = [NSError errorWithDomain:DTActorsErrorDomain code:0 userInfo:@{DTActorsErrorMessageKey : [NSString stringWithFormat:@"Unknown message: %@", key]}];
        RXPromise *promise = [RXPromise new];
        [promise rejectWithReason:error];
        return promise;
    }
}

- (void)on:(Class)messageType do:(DTVoidMessageBlock)handler {
    DTVoidMessageHandler *messageHandler = [[DTVoidMessageHandler alloc] initWithHandler:handler messageType:messageType];
    [self addHandler:messageHandler forMessageType:messageType];
}

- (void)on:(Class)messageType doFuture:(DTFutureMessageBlock)handler {
    DTFutureMessageHandler *messageHandler = [[DTFutureMessageHandler alloc] initWithHandler:handler messageType:messageType];
    [self addHandler:messageHandler forMessageType:messageType];
}

- (void)on:(Class)messageType doResult:(DTResultMessageBlock)handler {
    DTResultMessageHandler *messageHandler = [[DTResultMessageHandler alloc] initWithHandler:handler messageType:messageType];
    [self addHandler:messageHandler forMessageType:messageType];
}

#pragma mark - Private

- (void)addHandler:(id<DTMessageHandler>)handler forMessageType:(Class)messageType {
    NSString *key = [self keyForMessageType:messageType];
    _handlers[key] = handler;
}

- (NSString *)keyForMessageType:(Class)messageType {
    NSString *key = NSStringFromClass(messageType);
    return key;
}


@end