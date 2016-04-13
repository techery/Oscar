#import <Kiwi/Kiwi.h>
// Class under test
#import "OSActor.h"
#import "OSCancellableActor.h"
#import "OSActorSystemMock.h"

SPEC_BEGIN(OSActorRefTest)
describe(@"OSActorRef", ^{
    id<OSActorHandler> actor = [KWMock mockForProtocol:@protocol(OSActorHandler)];
    OSActorRef *sut = [[OSActorRef alloc] initWithActor:actor caller:self];

    it(@"should be correctly initialized", ^{
        [(id)sut.actor shouldNotBeNil];
    });
    
    context(@"ask", ^{
        it(@"should redirect message to actor and return Promise", ^{
            id message = any();
            RXPromise *promise = [RXPromise new];
            [promise resolveWithResult:nil];
            [[(id) actor should] receive:@selector(handle:) andReturn:promise withArguments:message];
            id result = [sut ask:message];
            [[result should] equal:promise];
        });
    });
    
    context(@"tell", ^{
        it(@"should redirect message to actor", ^{
            id message = any();
            [[(id) actor should] receive:@selector(handle:) withArguments:message];
            [sut tell:message];
        });
    });
    
    context(@"takeBackThePhrase", ^{
        let(sut, ^OSCancellableActor *(){
            return [[OSCancellableActor alloc] initWithActorSystem:actorSystemMock()];
        });
        
        let(actorRef, ^OSActorRef *(){
            return [[OSActorRef alloc] initWithActor:sut caller:self];
        });
        
        it(@"should cancel on taking phrase back", ^() {
            RXPromise *promise = [actorRef ask:[NSObject new]];
            KWCaptureSpy *spy = [promise captureArgument:@selector(cancelWithReason:) atIndex:0];
            [[sut shouldEventually] receive:@selector(didCancel)];
            [[sut shouldNotEventually] receive:@selector(didSucceed:)];
            [[sut shouldNotEventually] receive:@selector(didFail:)];
            KWBlock *block = theBlock(^{
                NSParameterAssert([spy.argument isKindOfClass:[NSError class]]);
                NSParameterAssert([((NSError *)spy.argument).domain isEqualToString:OSActorsErrorDomain]);
                NSParameterAssert(((NSError *)spy.argument).code == -1);
            });
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [actorRef takeBackThePhrase:promise];
                [block call];
            });
        });
    });
});
SPEC_END
