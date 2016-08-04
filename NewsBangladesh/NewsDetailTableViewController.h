//
//  NewsDetailTableViewController.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;
@interface NewsDetailTableViewController : UITableViewController

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property  NSInteger newsindex;
@end
