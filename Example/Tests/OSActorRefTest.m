#import <Kiwi/Kiwi.h>
// Class under test
#import "OSActor.h"
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
});
SPEC_END
