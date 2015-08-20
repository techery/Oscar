//
// Created by Anastasiya Gorban on 8/13/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTPromiseMatcher.h"
#import "RXPromise.h"

typedef NS_ENUM(NSUInteger, MatchType) {
    MatchTypeRejected,
    MatchTypeFulfilled,
};

@interface DTPromiseMatcher ()
@property(nonatomic) MatchType matchType;
@end

@implementation DTPromiseMatcher

#pragma mark - Public

- (void)beFulfilled {
    self.matchType = MatchTypeFulfilled;
}

- (void)beRejected {
    self.matchType = MatchTypeRejected;
}

#pragma mark  - Matching

+ (NSArray *)matcherStrings {
    return @[@"beRejected", @"beFulfilled"];
}

- (BOOL)evaluate {
    switch(self.matchType) {
        case MatchTypeFulfilled:
            return [self.subject isFulfilled];
        case MatchTypeRejected:
            return [self.subject isRejected];
    }

    NSAssert(TRUE, @"Should not get here");
    return NO;
}

- (NSString *)failureMessageForShould {
    NSString *string = self.matchType == MatchTypeRejected ? @"rejected" : @"fulfilled";
    return [NSString stringWithFormat:@"expected subject to be %@", string];
}

- (NSString *)failureMessageForShouldNot {
    NSString *string = self.matchType == MatchTypeRejected ? @"rejected" : @"fulfilled";
    return [NSString stringWithFormat:@"expected subject not to be %@", string];
}

@end