//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTMessageHandler.h"
#import <RXPromise/RXPromise.h>

@implementation DTBaseMessageHandler

- (instancetype)initWithMessageType:(Class)messageType {
    if (self = [super init]) {
        _messageType = messageType;
    }

    return self;
}

- (RXPromise *)handle:(id)message {
    if ([message isKindOfClass:self.messageType]) {
        return [RXPromise promiseWithResult:@(YES)];
    } else {
        NSError *error = [NSError errorWithDomain:DTActorsErrorDomain code:0 userInfo:@{DTActorsErrorMessageKey : @"can't convert incoming message"}];
        RXPromise *promise = [RXPromise new];
        [promise rejectWithReason:error];        
        return promise;
    }
}


@end

#pragma mark - Void

@interface DTVoidMessageHandler ()
@property(nonatomic, copy) DTVoidMessageBlock handler;
@end

@implementation DTVoidMessageHandler

- (instancetype)initWithHandler:(DTVoidMessageBlock)handler messageType:(Class)messageType {
    if (self = [super initWithMessageType:messageType]) {
        _handler = handler;
    }
    
    return self;
}


- (RXPromise *)handle:(id)message {
    return [super handle:message].then(^RXPromise *(id result){
        self.handler(message);
        return [RXPromise promiseWithResult:@(YES)];
    }, nil);
}

@end

#pragma mark - Future

@interface DTFutureMessageHandler ()
@property(nonatomic, copy) DTFutureMessageBlock handler;
@end

@implementation DTFutureMessageHandler

- (instancetype)initWithHandler:(DTFutureMessageBlock)handler messageType:(Class)messageType {
    if (self = [super initWithMessageType:messageType]) {
        _handler = handler;
    }
    
    return self;
}

- (RXPromise *)handle:(id)message {
    return [super handle:message].then(^RXPromise *(id result){
        return self.handler(message);
    }, nil);
}

@end

#pragma mark - Result

@interface DTResultMessageHandler ()
@property(nonatomic, copy) DTResultMessageBlock handler;
@end

@implementation DTResultMessageHandler

- (instancetype)initWithHandler:(DTResultMessageBlock)handler messageType:(Class)messageType {
    if (self = [super initWithMessageType:messageType]) {
        _handler = handler;
    }
    
    return self;
}

- (RXPromise *)handle:(id)message {
    return [super handle:message].then(^RXPromise *(id r){
        id result = self.handler(message);
        return [RXPromise promiseWithResult:result];
    }, nil);
}

@end