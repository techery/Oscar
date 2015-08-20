//
//  SampleSpec.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "DTActors.h"
#import "DTActorProvider.h"
#import "ActorSystemMock.h"
#import "DTSingletonActorProvider.h"
#import "DTInstanceActorProvider.h"
#import "DTPullActorProvider.h"
#import "DTConfigs.h"

@interface DTSingletonTest: DTActor
@end

@implementation DTSingletonTest
@end

@interface DTInstanceTest: DTActor
@end

@implementation DTInstanceTest
@end

SPEC_BEGIN(DTActorSystemTest)

describe(@"DTMainActorSystem", ^{
    __block DTMainActorSystem *sut = nil;
    __block id<DTConfigs> configs = nil;
    __block DTServiceLocator *serviceLocator = nil;
    
    Class singleton = [DTSingletonTest class];
    __block DTInstanceTest *instance;
    
    beforeAll(^{
        serviceLocator =  [DTServiceLocator mock];
        configs = [KWMock mockForProtocol:@protocol(DTConfigs)];
        sut = [[DTMainActorSystem alloc] initWithConfigs:configs serviceLocator:serviceLocator builderBlock:^(DTActorSystemBuilder * builder) {
            [builder addSingleton:singleton];
            [builder addActor:^DTActor *(id<DTActorSystem> system) {
                instance = [DTInstanceTest actorWithActorSystem:system];
                return instance;
            }];
        }];
    });
    
    it(@"should be correctly initialized", ^{
        [[sut shouldNot] beNil];
        [[(NSObject *)sut.configs shouldNot] beNil];
        [[sut.serviceLocator shouldNot] beNil];
    });
    
    context(@"asking for actor", ^{
        context(@"provider wasn't added", ^{
            it(@"should return nil", ^{
                id actor = [sut actorOfClass:[NSObject class] caller:self];
                [[actor should] beNil];
            });
        });
        
        context(@"provider was added", ^{
            it(@"should returt singleton", ^{
                id actorRef = [sut actorOfClass:singleton caller:self];
                [[actorRef shouldNot] beNil];
            });
            
            it(@"should return actor instance", ^{
                DTActorRef *actorRef = [sut actorOfClass:[instance class] caller:self];
                [[actorRef shouldNot] beNil];
            });
        });
    });
});

SPEC_END

SPEC_BEGIN(DTActorSystemBuilderTest)

describe(@"DTActorSystemBuilder", ^{
    id<DTActorSystem> actorSystem = actorSystemMock();
    DTActorSystemBuilder *sut = [[DTActorSystemBuilder alloc] initWithActorSystem:actorSystem];
    
    it(@"should be correctly initialized", ^{
        [[(id)sut.actorSystem shouldNot] beNil];
        [[(id)sut.actorSystem should] equal:actorSystem];
    });
    
    context(@"adding providers", ^{
        it(@"should add singleton provider to system", ^{
            [[(id)actorSystem should] receive:@selector(addActorProvider:)];
            KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
            [sut addSingleton:[DTActor class]];
            [[spy.argument should] beKindOfClass:[DTSingletonActorProvider class]];
        });
        
        it(@"should add instance provider to system", ^{
            [[(id)actorSystem should] receive:@selector(addActorProvider:)];
            KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
            [sut addActor:^DTActor *(id<DTActorSystem> system) {
                return [DTActor actorWithActorSystem:system];
            }];
            [[spy.argument should] beKindOfClass:[DTInstanceActorProvider class]];
        });
        
        it(@"should add pull provider to system", ^{
            [[(id)actorSystem should] receive:@selector(addActorProvider:)];
            KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
            [sut addActorsPull:[DTActor class] count:3];
            [[spy.argument should] beKindOfClass:[DTPullActorProvider class]];
            [[theValue([spy.argument count]) should] equal:theValue(3)];
        });
    });
});

SPEC_END

