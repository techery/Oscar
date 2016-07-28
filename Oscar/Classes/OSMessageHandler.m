//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSMessageHandler.h"
#import <RXPromise/RXPromise.h>

@implementation OSBaseMessageHandler

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
        NSError *error = [NSError errorWithDomain:OSActorsErrorDomain code:0 userInfo:@{OSActorsErrorMessageKey : @"can't convert incoming message"}];
        RXPromise *promise = [RXPromise new];
        [promise rejectWithReason:error];        
        return promise;
    }
}


@end

#pragma mark - Void

@interface OSVoidMessageHandler ()
@property(nonatomic, copy) OSVoidMessageBlock handler;
@end

@implementation OSVoidMessageHandler

- (instancetype)initWithHandler:(OSVoidMessageBlock)handler messageType:(Class)messageType {
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

@interface OSFutureMessageHandler ()
@property(nonatomic, copy) OSFutureMessageBlock handler;
@end

@implementation OSFutureMessageHandler

- (instancetype)initWithHandler:(OSFutureMessageBlock)handler messageType:(Class)messageType {
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

@interface OSResultMessageHandler ()
@property(nonatomic, copy) OSResultMessageBlock handler;
@end

@implementation OSResultMessageHandler

- (instancetype)initWithHandler:(OSResultMessageBlock)handler messageType:(Class)messageType {
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