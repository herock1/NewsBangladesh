//
//  AlertTableViewController.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertTableViewControllerDelegate <NSObject>

@required

- (void)alertTVCDidDismiss;

@end

@interface AlertTableViewController : UITableViewController

@property (nonatomic, weak) id <AlertTableViewControllerDelegate> delegate;

@end
