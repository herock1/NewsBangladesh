    //
    //  NewsDetailTableViewController.m
    //  NewsBangladesh
    //
    //  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
    //  Copyright (c) 2015 DGDev. All rights reserved.
    //

    #import "NewsDetailTableViewController.h"
    #import "News.h"
    #import "NewsDetailImageTableViewCell.h"
    #import "NewsDetailHeadingTableViewCell.h"
    #import "NewsDetailBodyTableViewCell.h"
    #import "UIImageView+AFNetworking.h"
    #import "NSString+NBOptions.h"
    #import "NBPreference.h"

    @interface NewsDetailTableViewController ()<UIPopoverControllerDelegate>

    @property (strong, nonatomic) UIActivityViewController *activityViewController;

    @end

    @implementation NewsDetailTableViewController


    - (void)viewDidLoad {
        [super viewDidLoad];
        
        self.tableView.estimatedRowHeight = 1500;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeleft];
        
        UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swiperight.direction=UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swiperight];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    - (IBAction)shareAction:(id)sender {
        News *detailnews = [_newsArray objectAtIndex:_newsindex];
        
        NSString *urlString;
        if ([NBPreference languageMode] == LanguageModeBangla) {
            
            urlString = urlString = detailnews.shareurl;
            
        } else {
            
            urlString = detailnews.shareurl;
        }
        
        NSString *escapedString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:escapedString];
        
        self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:self.activityViewController];
            popover.delegate = self;
            [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];    }
        else
        {
            [self presentViewController:self.activityViewController animated:YES completion:nil];
        }
        
    }

    #pragma mark - Table view data source

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
        return 1;
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        return 3;
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        static NSString *NewsCellIdentifier;
        
        if (indexPath.row == 0) {
            
            NewsCellIdentifier = @"NewDetailImageCellIdentifier";
            
        } else if (indexPath.row == 1) {
            
            NewsCellIdentifier = @"NewsDetailHeadingCellIdentifier";
            
        } else if (indexPath.row == 2) {
            
            NewsCellIdentifier = @"NewsDetailBodyCellIdentifier";
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NewsCellIdentifier];
        }
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }

    - (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
        News *detailnews = [_newsArray objectAtIndex:_newsindex];
        if ([cell isKindOfClass:[NewsDetailImageTableViewCell class]]) {
            
            NewsDetailImageTableViewCell *imageCell = (NewsDetailImageTableViewCell *)cell;
            
            
            
            NSURL *imageURL = [NSURL URLWithString:detailnews.thumbURL];
//            NSLog(@"Detail Image: %@",imageURL);
            [imageCell.newsImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"banner"]];
            
        } else if ([cell isKindOfClass:[NewsDetailHeadingTableViewCell class]]) {
            
            NewsDetailHeadingTableViewCell *headingCell = (NewsDetailHeadingTableViewCell *)cell;
            NSString *head=[NSString stringWithFormat:@"%@\t\t",detailnews.heading.stringByStrippingHTMLContent];
            headingCell.newsHeadingLabel.text =head;
            headingCell.newsHeadingLabel.font = [NBPreference fontForHeadingLabel];
            //headingCell.newsHeadingLabel.textAlignment=NSTextAlignmentJustified;
            
        } else if ([cell isKindOfClass:[NewsDetailBodyTableViewCell class]]) {
            
            
            NewsDetailBodyTableViewCell *bodyCell = (NewsDetailBodyTableViewCell *)cell;
            
            bodyCell.newsDetailLabel.font = [NBPreference fontForBodyLabel];
            
            NSString *breifString = [NSString stringWithFormat:@"%@ | %@\n\n\n\n\n\n\n\n\t", detailnews.dateString, detailnews.details.stringByStrippingHTMLContent];
            breifString  = [breifString stringByReplacingOccurrencesOfString:@"\r\n"
                                                                  withString:@"\n\n"];
            
            NSAttributedString *breifAttributedString = [self attributedStringFromDateString:detailnews.dateString withBriefString:breifString];
            bodyCell.newsDetailLabel.textAlignment=NSTextAlignmentJustified;
            bodyCell.newsDetailLabel.attributedText =breifAttributedString;
            
            
            
            
            
        }
    }



    - (NSAttributedString *) attributedStringFromDateString:(NSString *)dateString withBriefString:(NSString *)breifString {
        
        NSMutableAttributedString *breifAttributedString = [[NSMutableAttributedString alloc] initWithString:breifString];
        
        NSRange range = NSMakeRange(0, dateString.length);
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1], NSForegroundColorAttributeName:[UIColor redColor]};
        
        [breifAttributedString setAttributes:attributes range:range];
        
        range = NSMakeRange(dateString.length, breifString.length - dateString.length);
        
        attributes = @{NSFontAttributeName:[NBPreference fontForBodyLabel], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        
        [breifAttributedString setAttributes:attributes range:range];
        
        return breifAttributedString;
    }

    #pragma mark - Left Right Swipe

    -(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
    {
        
        //    NSLog(@"%d",_newsindex);
        if ([_newsArray count]>_newsindex) {
            [UIView transitionWithView:self.tableView
                              duration:0.7
                               options:UIViewAnimationOptionTransitionCurlUp
                            animations:^{
                                /* any other animation you want */
                            } completion:^(BOOL finished) {
                                /* hide/show the required cells*/
                            }];
            _newsindex++;
            [self.tableView reloadData];
        }
        
        //Do what you want here
    }

    -(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
    {
        
        //      NSLog(@"%d",_newsindex);
        if (_newsindex>0) {
            
            _newsindex--;
            [UIView transitionWithView:self.tableView
                              duration:0.7
                               options:UIViewAnimationOptionTransitionCurlDown
                            animations:^{
                                /* any other animation you want */
                            } completion:^(BOOL finished) {
                                /* hide/show the required cells*/
                            }];
            [self.tableView reloadData];
        }
        
        
        //Do what you want here
    }

    @end
