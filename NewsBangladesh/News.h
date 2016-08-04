//
//  News.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSString *newsID;
@property (nonatomic, strong) NSString *subHeading;
@property (nonatomic, strong) NSString *heading;
@property (nonatomic, strong) NSString *writer;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *thumbURL;
@property (nonatomic, strong) NSString *thumbCaption;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *imageCaption;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, assign) int readCount;
@property (nonatomic, assign) int emailCount;
@property (nonatomic, assign) int shareCount;
@property (nonatomic, strong) NSString *shareurl;
@end
