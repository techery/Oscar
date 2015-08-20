#import <Kiwi/Kiwi.h>
// Class under test
#import "OSServiceLocator.h"

@protocol OSServiceLocatorTestProtocol
@end

SPEC_BEGIN(OSServiceLocatorTests)
describe(@"OSServiceLocator", ^{
    __block id classService;
    __block id<OSServiceLocatorTestProtocol> protocolService;
    __block OSServiceLocator *sut;

    beforeAll(^{
        classService = any();
        protocolService = any();
        sut = [[OSServiceLocator alloc] initWithBuilderBlock:^(OSServiceLocator *locator) {
            [locator registerService:classService];
            [locator registerService:protocolService forProtocol:@protocol(OSServiceLocatorTestProtocol)];
        }];
    });
    
    describe(@"ask service for class", ^{
        context(@"class is registered", ^{
            it(@"should return service", ^{
                id service = [sut serviceForClass:[classService class]];
                [[service shouldNot] beNil];
                [[service should] beKindOfClass:[classService class]];
            });
        });
        
        context(@"class isn't registered", ^{
            it(@"should return nil", ^{
                id service = [sut serviceForClass:[NSObject class]];
                [[service should] beNil];
            });
        });
    });
    
    describe(@"ask service for protocol", ^{
        context(@"instance for protocol is regirstered", ^{
            it(@"should return service for protocol", ^{
                id service = [sut serviceForProtocol:@protocol(OSServiceLocatorTestProtocol)];
                [[service shouldNot] beNil];
            });
        });
        
        context(@"instance for protocol isn't registered", ^{
            it(@"should return nil", ^{
                id service = [sut serviceForProtocol:@protocol(NSObject)];
                [[service should] beNil];
            });
        });
    });
});
SPEC_END
