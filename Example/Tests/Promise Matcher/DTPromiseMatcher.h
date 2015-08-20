//
// Created by Anastasiya Gorban on 8/13/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMatcher.h"


@interface DTPromiseMatcher : KWMatcher

- (void)beRejected;
- (void)beFulfilled;

@end