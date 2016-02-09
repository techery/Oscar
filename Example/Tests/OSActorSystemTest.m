//
//  SampleSpec.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "OSActors.h"
#import "OSActorProvider.h"
#import "OSActorSystemMock.h"
#import "OSSingletonActorProvider.h"
#import "OSInstanceActorProvider.h"
#import "OSPullActorProvider.h"
#import "OSConfigs.h"

@interface OSSingletonTest: OSActor
@end

@implementation OSSingletonTest
@end

@interface OSInstanceTest: OSActor
@end

@implementation OSInstanceTest
@end

SPEC_BEGIN(OSActorSystemTest)

describe(@"OSMainActorSystem", ^{
    __block OSMainActorSystem *sut = nil;
    __block id<OSConfigs> configs = nil;
    
    Class singleton = [OSSingletonTest class];
    __block OSInstanceTest *instance;
    
    beforeAll(^{
        configs = [KWMock mockForProtocol:@protocol(OSConfigs)];
        sut = [[OSMainActorSystem alloc] initWithConfigs:configs builderBlock:^(OSActorSystemBuilder * builder) {
            [builder addSingleton:singleton];
            [builder addActor:^OSActor *(id<OSActorSystem> system) {
                instance = [OSInstanceTest actorWithActorSystem:system];
                return instance;
            }];
        }];
    });
    
    it(@"should be correctly initialized", ^{
        [[sut shouldNot] beNil];
        [[(NSObject *)sut.configs shouldNot] beNil];
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
                OSActorRef *actorRef = [sut actorOfClass:[instance class] caller:self];
                [[actorRef shouldNot] beNil];
            });
        });
    });
});

SPEC_END

SPEC_BEGIN(OSActorSystemBuilderTest)

describe(@"OSActorSystemBuilder", ^{
    id<OSActorSystem> actorSystem = actorSystemMock();
    OSActorSystemBuilder *sut = [[OSActorSystemBuilder alloc] initWithActorSystem:actorSystem];
    
    it(@"should be correctly initialized", ^{
        [[(id)sut.actorSystem shouldNot] beNil];
        [[(id)sut.actorSystem should] equal:actorSystem];
    });
    
    context(@"adding providers", ^{
        it(@"should add singleton provider to system", ^{
            [[(id)actorSystem should] receive:@selector(addActorProvider:)];
            KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
            [sut addSingleton:[OSActor class]];
            [[spy.argument should] beKindOfClass:[OSSingletonActorProvider class]];
        });
        
        it(@"should add instance provider to system", ^{
            [[(id)actorSystem should] receive:@selector(addActorProvider:)];
            KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
            [sut addActor:^OSActor *(id<OSActorSystem> system) {
                return [OSActor actorWithActorSystem:system];
            }];
            [[spy.argument should] beKindOfClass:[OSInstanceActorProvider class]];
        });
        
        it(@"should add pull provider to system", ^{
            [[(id)actorSystem should] receive:@selector(addActorProvider:)];
            KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
            [sut addActorsPull:[OSActor class] count:3];
            [[spy.argument should] beKindOfClass:[OSPullActorProvider class]];
            [[theValue([spy.argument count]) should] equal:theValue(3)];
        });
    });
});

SPEC_END

