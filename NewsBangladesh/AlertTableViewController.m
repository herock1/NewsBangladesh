    //
    //  AlertTableViewController.m
    //  NewsBangladesh
    //
    //  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
    //  Copyright (c) 2015 DGDev. All rights reserved.
    //

    #import "AlertTableViewController.h"
    #import "NBPreference.h"
    #import "MBProgressHUD.h"

    @interface AlertTableViewController ()

    @property (nonatomic, weak) IBOutlet UISegmentedControl *languageModeSegment;
    @property (nonatomic, weak) IBOutlet UISwitch *breakingNewsAlertSwitch;

    @end

    @implementation AlertTableViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        _breakingNewsAlertSwitch.on = [NBPreference breakingNewsAlert];
        _languageModeSegment.selectedSegmentIndex = [NBPreference languageMode];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    - (IBAction)dismissAlertTableViewController:(id)sender {
        
        if (_delegate && [_delegate respondsToSelector:@selector(alertTVCDidDismiss)]) {
            
            [_delegate alertTVCDidDismiss];
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

    - (IBAction)languageModeSegmentAction:(UISegmentedControl *)sender {
        
        NBLanguageMode mode = (NBLanguageMode)sender.selectedSegmentIndex;
        NSLog(@"%d",mode);
          [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NBPreference setLanguageMode:mode];
        [NBPreference sendDeviceToken];
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }

    - (IBAction)breakingNewsAlertSwitchAction:(UISwitch *)sender {
        
        [NBPreference setBreakingNewsAlert:sender.on];
    }

    @end
