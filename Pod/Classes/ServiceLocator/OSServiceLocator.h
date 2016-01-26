//
// Created by Anastasiya Gorban on 8/6/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSServiceLocator : NSObject

- (instancetype)initWithBuilderBlock:(void (^)(OSServiceLocator *))builderBlock;

- (void)registerService:(id)service forProtocol:(Protocol *)protocol;
- (id)serviceForProtocol:(Protocol *)protocol;

- (void)registerService:(id)service;
- (id)serviceForClass:(Class)aClass;

@end
