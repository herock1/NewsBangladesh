//
//  NewsDetailTableViewController.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;
@interface SearchsDetailTableViewController : UITableViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) NSString *detailnews;
@property (nonatomic, strong) NSString *headernews;
@property (nonatomic, strong) NSString *datenews;
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *newsid;
@property (nonatomic, strong) NSString *searchnewsid;
@property (nonatomic, strong) NSString *languagemode;
@property (nonatomic, strong) NSString *pushshare;
@property  NSInteger newsindex;
@end
