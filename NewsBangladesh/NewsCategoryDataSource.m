//
//  NewsCategoryDataSource.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import "NewsCategoryDataSource.h"

@interface NewsCategoryDataSource ()

@property (nonatomic, strong) NSDictionary *dataSource;

@end

static NewsCategoryDataSource *instance;

@implementation NewsCategoryDataSource

+ (NewsCategoryDataSource *) sharedInstance {
    
    if (!instance) {
        instance = [[NewsCategoryDataSource alloc] init];
    }
    
    return instance;
}

- (NSDictionary *)dataSource {
    
    if (!_dataSource) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NewsCategoryDataSource" ofType:@"plist"];
        _dataSource = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return _dataSource;
}

@end
