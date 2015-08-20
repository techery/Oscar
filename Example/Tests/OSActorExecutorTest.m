#import <Kiwi/Kiwi.h>
// Class under test
#import "OSActorExecutor.h"

#import "OSActors.h"

SPEC_BEGIN(OSActorExecutorTest)
describe(@"OSActorExecutor", ^{
    __block OSActorExecutor *sut;
    
    beforeAll(^{
        id actorHandler = [KWMock mockForProtocol:@protocol(OSActorHandler)];
        [actorHandler stub:@selector(handle:) andReturn:[RXPromise new]];
        sut = [OSActorExecutor executorWithActorHandler:actorHandler];
    });
    
    it(@"should be correctly initialized", ^{
        [[sut.operationQueue shouldNot] beNil];
        [[theValue(sut.operationQueue.maxConcurrentOperationCount) should] equal:theValue(1)];
        [[(NSObject *)sut.actorHandler shouldNot] beNil];
    });
    
    context(@"handle", ^{
        it(@"should add operation to operation queue", ^{
            [[theValue(sut.operationQueue.operationCount) should] beZero];
            [sut handle:[KWMock partialMockForObject:[OSInvocation invocationWithMessage:[NSObject new] caller:self]]];
            [[theValue(sut.operationQueue.operationCount) should] equal:theValue(1)];
        });        
    });
});

SPEC_END
