//
//  NewsCategoryDataSource.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCategoryDataSource : NSObject

+ (NewsCategoryDataSource *)sharedInstance;
- (NSDictionary *)dataSource;

@end
