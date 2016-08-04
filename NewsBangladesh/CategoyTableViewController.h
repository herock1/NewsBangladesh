//
//  CategoyTableViewController.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsCategory;

@protocol CategoyTableViewControllerDelegate <NSObject>

@required

- (void)categoryListDidDismissWithCategory:(NewsCategory *)category;

@end

@interface CategoyTableViewController : UITableViewController

@property (nonatomic, weak) id <CategoyTableViewControllerDelegate> delegate;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *newsArray;

@end
