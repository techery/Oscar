//
//  OSCancellableActor.m
//  Oscar
//
//  Created by Petro Korienev on 4/13/16.
//  Copyright © 2016 Anastasiya Gorban. All rights reserved.
//

#import "OSCancellableActor.h"
#import <RXPromise/RXPromise.h>

@interface OSCancellableActor ()

@property (nonatomic, strong) RXPromise *currentPromise;

@end

@implementation OSCancellableActor

- (void)setup {
    [self on:[NSObject class] doFuture:^RXPromise *(id message) {
        return [self message:message];
    }];
}

- (RXPromise *)message:(id)message {
    self.currentPromise = [RXPromise new];
    self.currentPromise.then(^id(id result) {
        [self didSucceed:result];
        return result;
    }, ^id(NSError *error) {
        if ([self.currentPromise isCancelled]) {
            [self didCancel];
        }
        else {
            [self didFail:error];
        }
        [self didReceiveErrorFromErrorBlock:error];
        return error;
    });
    return self.currentPromise;
}

- (void)finishCurrentPromiseWithResult:(id)result {
    [self.currentPromise fulfillWithValue:result];
}

- (void)finishCurrentPromiseWithError:(NSError *)error {
    [self.currentPromise rejectWithReason:error];
}

- (void)didSucceed:(id)result {
    self.currentPromise = nil;
}

- (void)didFail:(NSError *)error {
    self.currentPromise = nil;
}

- (void)didCancel {
    self.currentPromise = nil;
}

- (void)didReceiveErrorFromErrorBlock:(NSError *)error {
    
}

@end
