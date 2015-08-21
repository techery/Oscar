//
//  OSInvocation.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/18/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSInvocation.h"
#import "OSActorSystem.h"
#import "OSActor.h"

@interface OSInvocation()

@property (nonatomic, strong) NSDate *started;
@property (nonatomic, strong) NSDate *finished;
@property (nonatomic, strong) NSError *error;

@end

@implementation OSInvocation

- (instancetype)initWithMessage:(id)message caller:(nullable id)caller {
    self = [super init];
    if (self) {
        _message = message;
        _caller = caller;

        if ([caller isKindOfClass:[OSActor class]]) {
            _parent = [caller currentInvocation];
        }
    }

    return self;
}

+ (instancetype)invocationWithMessage:(id)message caller:(nullable id)caller {
    return [[self alloc] initWithMessage:message caller:caller];
}

- (void)start {
    self.started = [NSDate new];
    [self logStart];
}

- (void)finish {
    [self finishWithError:nil];
}

- (void)finishWithError:(NSError *)error {
    self.finished = [NSDate new];
    self.error = error;
    [self logFinished];
}

#pragma mark - Private

- (void)logStart {
    int spaces = [self parentLevel] * 10;
    NSLog(@">Invocation started\n%*smessage: %@\n%*scaller: %@\n%*sparrent: %@", spaces, " ",self.message,  spaces, " ",self.caller,  spaces, " ",self.parent.message);
}

- (void)logFinished {
    double time = [self.finished timeIntervalSinceDate:self.started];
    int spaces = [self parentLevel] * 10;
    NSLog(@">Invocation finished\n%*smessage: %@\n%*stime:%.3fs\n%*serror: %@", spaces, " ",self.message, spaces, " ", time, spaces, " ", self.error.localizedDescription);
}

- (int)parentLevel {
    __block int(^level)(OSInvocation *) = ^int(OSInvocation *p) {
        if (!p) {
            return 0;
        }
        return level(p.parent) + 1;
    };
    
    return level(self.parent);
}

@end
