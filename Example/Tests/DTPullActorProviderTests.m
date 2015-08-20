#import <Kiwi/Kiwi.h>
// Class under test
#import "DTPullActorProvider.h"

#import "DTActor.h"
#import "ActorSystemMock.h"

@interface DTPullActorProviderTestActor: DTActor
@end

@implementation DTPullActorProviderTestActor

- (void)setup {
    [self on:[NSObject class] doFuture:^RXPromise *(id o) {
        return [RXPromise new];
    }];
}

@end

SPEC_BEGIN(DTPullActorProviderTests)
describe(@"DTPullActorProvider", ^{
    Class actorType = [DTPullActorProviderTestActor class];
    id<DTActorSystem> actorSystem = actorSystemMock();
    DTPullActorProvider *sut = [DTPullActorProvider providerWithActorType:actorType count:3];

    it(@"should return correct actor type", ^{
        [[(id)[sut actorType] should] equal:actorType];
    });

    context(@"on create", ^{
        __block id<DTActorHandler> handler1;
        __block id<DTActorHandler> handler2;
        __block id<DTActorHandler> handler3;
        DTInvocation *invocation = [DTInvocation invocationWithMessage:[NSObject new] caller:self];

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
