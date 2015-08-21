#import <Kiwi/Kiwi.h>
// Class under test
#import "OSSingletonActorProvider.h"

#import "OSActors.h"
#import "OSActorSystemMock.h"

SPEC_BEGIN(OSSingletonActorProviderTest)

describe(@"OSSingletonActorProvider", ^{
    __block OSSingletonActorProvider *sut = [OSSingletonActorProvider providerWithActorType:[OSActor class]];
    __block OSMainActorSystem *actorSystem = nil;
    
    beforeAll(^{
        actorSystem = actorSystemMock();
    });
    
    it(@"Should be correctly initialized", ^{
        [[(NSObject *)sut.actorHandler should] beNil];
        [[(NSObject *)sut.actorType shouldNot] beNil];
    });
    
    context(@"creating handler", ^{
        it(@"Should correctly create handler", ^{
            id handler = [sut create:actorSystem];
            [[handler shouldNot] beNil];
            [[handler should] equal:sut.actorHandler];
        });
        
        it(@"Should act like singleton and return old instance rather then create new", ^{
            id oldHandler = sut.actorHandler;
            [[oldHandler shouldNot] beNil];
            id newHandler = [sut create:actorSystem];
            [[newHandler should] equal:oldHandler];
        });
    });
});

SPEC_END
