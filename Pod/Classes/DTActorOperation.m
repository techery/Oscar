//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActorOperation.h"
#import "DTActor.h"
#import <RXPromise/RXPromise.h>

#pragma mark -
#pragma mark - DTBaseOperation

@interface DTBaseOperation () {
    BOOL _executing;
    BOOL _finished;
}
@end

@implementation DTBaseOperation

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
#pragma mark - DTActorOperation

@interface DTActorOperation ()
@property(nonatomic, strong) id<DTActorHandler> handler;
@property(nonatomic, strong) DTInvocation *invocation;
@property(nonatomic, readwrite) RXPromise *promise;
@end

@implementation DTActorOperation

- (instancetype)initWithInvocation:(DTInvocation *)invocation handler:(id<DTActorHandler>)handler {
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

    [self.handler handle:self.invocation].then(^id(id result) {
        [self.promise resolveWithResult:result];
        [self.invocation finish];
        [self finish];
        return nil;
    }, ^id(NSError* error){
        [self.promise rejectWithReason:error];
        [self.invocation finishWithError:error];
        [self finish];
        return nil;
    });
    
    [super start];
}

@end