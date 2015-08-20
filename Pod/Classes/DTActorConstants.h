//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

typedef void (^DTVoidMessageBlock)(id message);
typedef RXPromise *(^DTFutureMessageBlock)(id message);
typedef id (^DTResultMessageBlock)(id message);

extern NSString * const DTActorsErrorDomain;
extern NSString * const DTActorsErrorMessageKey;