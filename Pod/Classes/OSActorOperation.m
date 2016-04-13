//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSActorOperation.h"
#import "OSActor.h"
#import <RXPromise/RXPromise.h>

#pragma mark -
#pragma mark - OSBaseOperation

@interface OSBaseOperation () {
    BOOL _executing;
    BOOL _finished;
}
@end

@implementation OSBaseOperation

#pragma mark - NSOperation

- (BOOL)isExecuting {
    return _executing;
}

- (void)setExecuting:(BOOL)executing {
    [super willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [super didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isFinished {
    return _finished;
}

- (void)setFinished:(BOOL)finished {
    [super willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [super didChangeValueForKey:@"isFinished"];
}

- (void)start {
    self.executing = YES;
}

#pragma mark - Public

- (void)finish {
    self.finished = YES;
    self.executing = NO;
//    [self cancel];
}

@end

#pragma mark -
#pragma mark - OSActorOperation

@interface OSActorOperation ()
@property(nonatomic, strong) id<OSActorHandler> handler;
@property(nonatomic, strong) OSInvocation *invocation;
@property(nonatomic, readwrite) RXPromise *promise;
@end

@implementation OSActorOperation

- (instancetype)initWithInvocation:(OSInvocation *)invocation handler:(id<OSActorHandler>)handler {
    if (self = [super init]) {
        _invocation = invocation;
        _handler = handler;
        _promise = [RXPromise new];
    }
    
    return self;
}

#pragma mark - NSOperation

- (void)start {
    if (self.executing) return;
    
    [self.invocation start];
    
    RXPromise *handlerPromise = [self.handler handle:self.invocation];
    handlerPromise.then(^id(id result) {
        [self.promise resolveWithResult:result];
        [self.invocation finish];
        [self finish];
        return nil;
    }, ^id(NSError* error) {
        [self.promise rejectWithReason:error];
        [self.invocation finishWithError:error];
        [self finish];
        return nil;
    });
    // This is done to pass cancel from client to server
    // Despite it may seem to be possible race (promise is returned in -initWithInvocation:handler:)
    // but bound to handler promise inside -start, internal implementation of RXPromise reasons
    // that there's no gap.
    // However, correct cancel processing, if promise is created and immediately cancelled is not guaranteed
    [self.promise bind:handlerPromise];
    
    [super start];
}

@end