//
//  OSInvocation.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/18/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSInvocation.h"
#import "OSActor.h"


@interface OSInvocation()

@property (nonatomic, strong) NSDate *started;
@property (nonatomic, strong) NSDate *finished;
@property (nonatomic, strong) NSError *error;

@end

@implementation OSInvocation

- (instancetype)initWithMessage:(id)message caller:(id)caller {
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

+ (instancetype)invocationWithMessage:(id)message caller:(id)caller {
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
    DDLogVerbose(@"\n>Invocation started\nmessage: %@\ncaller: %@\nparent: %@", self.message, self.caller, self.parent);
}

- (void)logFinished {
    NSTimeInterval time = [self.finished timeIntervalSinceDate:self.started];
    if (self.error) {
        DDLogError(@"\n>Invocation finished\nmessage: %@\ntime:%.3fs\nerror: %@", self.message, time, self.error);
    } else {
        DDLogVerbose(@"\n>Invocation finished\nmessage: %@\ntime:%.3fs", self.message, time);
    }
}

@end
