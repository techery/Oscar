#import <Kiwi/Kiwi.h>
// Class under test
#import "OSPullActorProvider.h"

#import "OSActor.h"
#import "OSActorSystemMock.h"

@interface OSPullActorProviderTestActor: OSActor
@end

@implementation OSPullActorProviderTestActor

- (void)setup {
    [self on:[NSObject class] doFuture:^RXPromise *(id o) {
        return [RXPromise new];
    }];
}

@end

SPEC_BEGIN(OSPullActorProviderTests)
describe(@"OSPullActorProvider", ^{
    Class actorType = [OSPullActorProviderTestActor class];
    id<OSActorSystem> actorSystem = actorSystemMock();
    OSPullActorProvider *sut = [OSPullActorProvider providerWithActorType:actorType count:3];

    it(@"should return correct actor type", ^{
        [[(id)[sut actorType] should] equal:actorType];
    });

    context(@"on create", ^{
        __block id<OSActorHandler> handler1;
        __block id<OSActorHandler> handler2;
        __block id<OSActorHandler> handler3;
        OSInvocation *invocation = [OSInvocation invocationWithMessage:[NSObject new] caller:self];

        context(@"in inital state", ^{
            it(@"should create actor handler", ^{
                handler1 = [sut create:actorSystem];
                [[(id)handler1 shouldNot] beNil];
            });

            context(@"on second creation", ^{
                it(@"should not create new handler and return old", ^{
                    id secondHanlder = [sut create:actorSystem];
                    [[secondHanlder should] equal:handler1];
                });
            });
        });

        context(@"some handlers are busy", ^{
            beforeAll(^{
                [handler1 handle:invocation];
            });

            context(@"no free handlers", ^{
                it(@"should create new", ^{
                    handler2 = [sut create:actorSystem];
                    [[(id)handler2 shouldNot] equal:handler1];
                });
            });

            context(@"there is free handler", ^{
                it(@"should not create new and return one that was created before", ^{
                    id secondHanlder = [sut create:actorSystem];
                    [[secondHanlder should] equal:handler2];
                });
            });

            context(@"no free handlers ", ^{
                it(@"should create new", ^{
                    [handler2 handle:invocation];
                    handler3 = [sut create:actorSystem];
                    [[(id)handler3 shouldNot] equal:handler1];
                    [[(id)handler3 shouldNot] equal:handler2];
                });
            });
        });

        context(@"all hanlers are busy", ^{
            beforeAll(^{
                [handler3 handle:invocation];
            });

            it(@"should return existing handler", ^{
                id newHandler = [sut create:actorSystem];
                [[@[handler1, handler2, handler3] should] contain:newHandler];
            });
        });

    });
});
SPEC_END
