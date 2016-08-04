//
//  NewsCategory.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsCategory : NSObject

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) UIImage *categoryImage;

@end
