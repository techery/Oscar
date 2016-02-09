#import <Kiwi/Kiwi.h>
// Class under test
#import "OSActorOperation.h"

#import "OSActor.h"
#import "OSPromiseMatcher.h"
#import "OSActorSystemMock.h"

SPEC_BEGIN(OSActorOperationTest)
registerMatchers(@"OS");

describe(@"OSActorOperation", ^{
    __block id handler;
    __block OSInvocation *invocation;
    __block OSActorOperation *sut;
    
    beforeEach(^{
        invocation = [OSInvocation invocationWithMessage:[NSObject new] caller:self];
        handler = [KWMock mockForProtocol:@protocol(OSActorHandler)];
        RXPromise *failedPromise = [RXPromise new];
        [failedPromise rejectWithReason:nil];
        [failedPromise wait];
        [handler stub:@selector(handle:) andReturn:failedPromise withArguments:invocation];
        sut = [[OSActorOperation alloc] initWithInvocation:invocation handler:handler];
    });
    
    it(@"should be correctly initialized", ^{
        [[sut.promise shouldNot] beNil];
    });
    
    context(@"start", ^{
        it(@"should send message to handler", ^{
            [[handler should] receive:@selector(handle:) withArguments:invocation];
            [sut start];
        });
        
        context(@"already started", ^{
            beforeEach(^{

            });
            
            it(@"shouldn't send message to handler", ^{
                [[handler should] receive:@selector(handle:) andReturn:[RXPromise new] withCountAtMost:1 arguments:invocation];
                [sut start];
                [sut start];
            });
        });
        
        context(@"handler fails", ^{
            it(@"should return failed result", ^{
                [sut start];
                [[sut.promise shouldEventually] beRejected];
            });
            
            it(@"should finish", ^{
                [[sut shouldEventually] receive:@selector(finish)];
                [sut start];
            });
        });
        
        context(@"handler succeeded", ^{
            RXPromise *successPromise = [RXPromise new];
            id result = any();
            
            beforeAll(^{
                [successPromise resolveWithResult:result];
                [handler stub:@selector(handle:) andReturn:successPromise withArguments:invocation];
            });
            
            it(@"should return success result", ^{
                [sut start];
                [[sut.promise shouldEventually] beFulfilled];
                [[sut.promise.get shouldEventually] equal:result];
            });
            
            it(@"should finish", ^{
                [[sut shouldEventually] receive:@selector(finish)];
                [sut start];                
            });
            
        });
    });
});
SPEC_END
