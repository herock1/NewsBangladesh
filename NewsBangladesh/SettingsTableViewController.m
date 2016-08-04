    //
    //  SettingsTableViewController.m
    //  NewsBangladesh
    //
    //  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
    //  Copyright (c) 2015 DGDev. All rights reserved.
    //

    #import "SettingsTableViewController.h"
    #import "NBPreference.h"
    #define Rateus_link @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
    #define ITUNES_APPID @"976999982"
    @interface SettingsTableViewController ()<UIPopoverControllerDelegate>
    @property (strong, nonatomic) UIActivityViewController *activityViewController;
    @property (nonatomic, weak) IBOutlet UISwitch *automaticRefreshSwitch;

    @end

    @implementation SettingsTableViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        _automaticRefreshSwitch.on = [NBPreference automaticRefresh];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    - (IBAction)automaticRefreshAction:(UISwitch *)sender {
        
        [NBPreference setAutomaticRefresh:sender.on];
    }

    -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {

        
        if (indexPath.section==3 && indexPath.row==0) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:Rateus_link,ITUNES_APPID]]];
                     
        }
        if (indexPath.section==3 && indexPath.row==1) {
          
            NSString *urlString;
          
           urlString= @"https://itunes.apple.com/us/app/news-bangladesh/id976999982?mt=8";
            NSString *escapedString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url=[NSURL URLWithString:escapedString];
            
            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:self.activityViewController];
                popover.delegate = self;
                
                [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                [self presentViewController:self.activityViewController animated:YES completion:nil];
            }
        }
        
        
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell *staticCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        if (cell == staticCell)
        {
            //Do what you want to do.
        }
    }

    @end
