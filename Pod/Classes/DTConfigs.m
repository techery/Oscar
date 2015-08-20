//
//  DTConfigs.m
//  Pods
//
//  Created by Anastasiya Gorban on 8/20/15.
//
//

#import "DTConfigs.h"

@interface DTPlistConfigs()

@property (nonatomic, strong) NSDictionary *configs;

@end

@implementation DTPlistConfigs

- (instancetype)initWithFileName:(NSString *)fileName {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        if (path) {
            self.configs = [NSDictionary dictionaryWithContentsOfFile:path];
        }
    }
    
    return self;
}

- (nullable id)objectForKey:(NSString *)key {
    return self.configs[key];
}

@end
