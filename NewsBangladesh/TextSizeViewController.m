    //
    //  TextSizeViewController.m
    //  NewsBangladesh
    //
    //  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
    //  Copyright (c) 2015 DGDev. All rights reserved.
    //

    #import "TextSizeViewController.h"
    #import "NBPreference.h"

    @interface TextSizeViewController ()

    @property (nonatomic, weak) IBOutlet UILabel *textSizeSampleLabel;
    @property (nonatomic, weak) IBOutlet UISlider *slider;

    @end

    @implementation TextSizeViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        _textSizeSampleLabel.font = [NBPreference fontForBodyLabel];
        _slider.value = [NBPreference fontSize];
        
        if ([NBPreference languageMode] == LanguageModeBangla) {
            
            _textSizeSampleLabel.text = @"টেকনাফে পৃথক দুটি অভিযানে এক লাখ পিছ ইয়াবা উদ্ধার করেছে বর্ডার গার্ড বাংলাদেশের (বিজিবি)। অভিযানে মায়ানমারের এক নাগরিককে আটক করেছে বিজিবি।";
        } else {
            
            _textSizeSampleLabel.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        }
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    - (IBAction)updateFontSizeAction:(UISlider *)slider {
        
        [NBPreference setFontSize:slider.value];
        
        _textSizeSampleLabel.font = [NBPreference fontForBodyLabel];
        
        [self.view layoutIfNeeded];
    }

    @end
