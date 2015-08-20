#import <Kiwi/Kiwi.h>
// Class under test
#import "DTActorExecutor.h"

#import "DTActors.h"

SPEC_BEGIN(DTActorExecutorTest)
describe(@"DTActorExecutor", ^{
    __block DTActorExecutor *sut;
    
    beforeAll(^{
        id actorHandler = [KWMock mockForProtocol:@protocol(DTActorHandler)];
        [actorHandler stub:@selector(handle:) andReturn:[RXPromise new]];
        sut = [DTActorExecutor executorWithActorHandler:actorHandler];
    });
    
    it(@"should be correctly initialized", ^{
        [[sut.operationQueue shouldNot] beNil];
        [[theValue(sut.operationQueue.maxConcurrentOperationCount) should] equal:theValue(1)];
        [[(NSObject *)sut.actorHandler shouldNot] beNil];
    });
    
    context(@"handle", ^{
        it(@"should add operation to operation queue", ^{
            [[theValue(sut.operationQueue.operationCount) should] beZero];
            [sut handle:[KWMock partialMockForObject:[DTInvocation invocationWithMessage:[NSObject new] caller:self]]];
            [[theValue(sut.operationQueue.operationCount) should] equal:theValue(1)];
        });        
    });
});

SPEC_END
