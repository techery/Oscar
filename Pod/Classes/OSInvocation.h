//
//  OSInvocation.h
//  Actors
//
//  Created by Anastasiya Gorban on 8/18/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSInvocation : NSObject

@property (nonatomic, readonly) id message;
@property (nonatomic, readonly) id caller;
@property (nonatomic, readonly) OSInvocation *parent;

- (instancetype)initWithMessage:(id)message caller:(nullable id)caller;
+ (instancetype)invocationWithMessage:(id)message caller:(nullable id)caller;

- (void)start;
- (void)finish;
- (void)finishWithError:(nullable NSError *)error;

@end
