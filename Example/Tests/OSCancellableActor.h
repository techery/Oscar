//
//  OSCancellableActor.h
//  Oscar
//
//  Created by Petro Korienev on 4/13/16.
//  Copyright © 2016 Anastasiya Gorban. All rights reserved.
//

#import "OSActor.h"

@interface OSCancellableActor : OSActor

- (void)finishCurrentPromiseWithResult:(id)result;
- (void)finishCurrentPromiseWithError:(NSError *)error;

- (void)didSucceed:(id)result;
- (void)didFail:(NSError *)error;
- (void)didCancel;
- (void)didReceiveErrorFromErrorBlock:(NSError *)error;

@end
