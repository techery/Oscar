//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

typedef void (^OSVoidMessageBlock)(id message);
typedef RXPromise *(^OSFutureMessageBlock)(id message);
typedef id (^OSResultMessageBlock)(id message);

extern NSString * const OSActorsErrorDomain;
extern NSString * const OSActorsErrorMessageKey;