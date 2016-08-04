    //
    //  NewsDetailTableViewController.m
    //  NewsBangladesh
    //
    //  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
    //  Copyright (c) 2015 DGDev. All rights reserved.
    //

    #import "SearchsDetailTableViewController.h"
    #import "News.h"
    #import "NewsDetailImageTableViewCell.h"
    #import "NewsDetailHeadingTableViewCell.h"
    #import "NewsDetailBodyTableViewCell.h"
    #import "UIImageView+AFNetworking.h"
    #import "NSString+NBOptions.h"
    #import "NBPreference.h"
    #import "AFNetworking.h"
    #import "MBProgressHUD.h"


    @interface SearchsDetailTableViewController ()<UIPopoverControllerDelegate>

    @property (strong, nonatomic) UIActivityViewController *activityViewController;
    @property (strong, nonatomic) NSString *pushnotificationURL;

    @end

    @implementation SearchsDetailTableViewController


    - (void)viewDidLoad {
        
        if (_newsid !=NULL) {
            _headernews=@"";
            _detailnews=@"";
            _datenews=@"";

        MBProgressHUD *mb=  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mb.labelText = @"Loading...";
        
            UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
            self.navigationItem.rightBarButtonItem=add;
            NSLog(@"Hello NewsID: %@",_newsid);
            
            if ([_languagemode isEqualToString:@"0"]) { //For Bangla URL
                _pushnotificationURL=   [NSString stringWithFormat:@"http://www.newsbangladesh.com/api/details/%@",_newsid];
                
           
                
            }
            else
            {
                _pushnotificationURL=   [NSString stringWithFormat:@"http://www.newsbangladesh.com/english/api/details/%@",_newsid];
            }
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:_pushnotificationURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
              
                [self.tableView layoutIfNeeded];
                
                NSDictionary *newsDictionay = (NSDictionary *) responseObject;
                NSLog(@"Hello Nes Dictionary: %@",newsDictionay);
                    
                    News *news = [News new];
                    
                    news.newsID = [newsDictionay objectForKey:@"ID"];
                    news.subHeading = [newsDictionay objectForKey:@"SubHead"];
                    _headernews = [newsDictionay objectForKey:@"Head"];
                    news.writer = [newsDictionay objectForKey:@"Writers"];
                    news.brief = [newsDictionay objectForKey:@"Brief"];
                   _detailnews = [newsDictionay objectForKey:@"Details"];
                    news.thumbURL = [NSString stringWithFormat:@"%@%@%@", NBBaseURL, NBNewsImageBaseURL, [newsDictionay objectForKey:@"Thumb"]];
                    news.thumbCaption = [newsDictionay objectForKey:@"ThumbCaption"];
                    _imageurl = [NSString stringWithFormat:@"%@%@%@", NBBaseURL, NBNewsImageBaseURL, [newsDictionay objectForKey:@"Thumb"]];
                    news.imageCaption = [newsDictionay objectForKey:@"ImgBGCaption"];
                    news.dateString = [newsDictionay objectForKey:@"DateTimeInsert"];
                   _datenews=news.dateString;
                    news.readCount = [[newsDictionay objectForKey:@"Read"] intValue];
                    news.emailCount = [[newsDictionay objectForKey:@"Email"] intValue];
                    news.shareCount = [[newsDictionay objectForKey:@"Share"] intValue];
                news.shareurl = [newsDictionay objectForKey:@"url"];
                _pushshare=news.shareurl;
                
                    [_newsArray addObject:news];
             
                
                // We're inserting the first object at the first index again,
                // because the first two row of the table shows the first
                // news item as combined group. The First row shows the image
                // and the second row shows the title and the brief.
                
               
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView reloadData];
                
              
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
             
                [self.tableView layoutIfNeeded];
                
            }];
            
            
        }
        else
        {
            UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareActionsearch:)];
            self.navigationItem.rightBarButtonItem=add;
        }
        [super viewDidLoad];
        self.tableView.estimatedRowHeight = 215.0f;
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
        
        //News *detailnews = [_newsArray objectAtIndex:0];
       
        
        NSString *urlString;
     
            if([_languagemode isEqualToString:@"0"]) {
                urlString=_pushshare;
            }
            else{
            
              urlString=_pushshare;
            NSLog(@"Base URL: %@",urlString);
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

- (IBAction)shareActionsearch:(id)sender {
    
  
    NSString *urlString;
    if ([NBPreference languageMode] == LanguageModeBangla) {
      
//            urlString = [NSString stringWithFormat:@"%@%@/%@", NBBaseURL, @"details", _searchnewsid];
//            NSLog(@"Base URL: %@",urlString);
        urlString = _searchnewsid;
        NSLog(@"Base URL: %@",urlString);
        
        
    } else {

//            urlString = [NSString stringWithFormat:@"%@english/%@/%@", NBBaseURL, @"details", _searchnewsid];
//            NSLog(@"Base URL: %@",urlString);
         urlString = _searchnewsid;
          NSLog(@"Base URL: %@",urlString);
    }
    
    NSString *escapedString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:escapedString];
    
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    
   //
  
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:self.activityViewController];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
       
    }
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
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }

    - (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
        
        if ([cell isKindOfClass:[NewsDetailImageTableViewCell class]]) {
            
            NewsDetailImageTableViewCell *imageCell = (NewsDetailImageTableViewCell *)cell;
            
            
            
            NSURL *imageURL = [NSURL URLWithString:_imageurl];
            NSLog(@"Detail Image: %@",imageURL);
            [imageCell.newsImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
            
        } else if ([cell isKindOfClass:[NewsDetailHeadingTableViewCell class]]) {
            
            NewsDetailHeadingTableViewCell *headingCell = (NewsDetailHeadingTableViewCell *)cell;
            NSString *head=[NSString stringWithFormat:@"%@\t\t",_headernews.stringByStrippingHTMLContent];
            headingCell.newsHeadingLabel.text =head;
            
          //  headingCell.newsHeadingLabel.text =_headernews.stringByStrippingHTMLContent;
            headingCell.newsHeadingLabel.font = [NBPreference fontForHeadingLabel];
            
        } else if ([cell isKindOfClass:[NewsDetailBodyTableViewCell class]]) {
            
            NewsDetailBodyTableViewCell *bodyCell = (NewsDetailBodyTableViewCell *)cell;
           
            bodyCell.newsDetailLabel.font = [NBPreference fontForBodyLabel];
            
            NSString *breifString = [NSString stringWithFormat:@"%@ | %@\n\n\n\t", _datenews, _detailnews.stringByStrippingHTMLContent];
            breifString  = [breifString stringByReplacingOccurrencesOfString:@"\r\n"
                                                                  withString:@"\n\n"];
            NSLog(@"DateNews: %@",_datenews);
            
            NSAttributedString *breifAttributedString = [self attributedStringFromDateString:_datenews withBriefString:breifString];
            NSLog(@"Brief %@",breifAttributedString);
            
            bodyCell.newsDetailLabel.attributedText =breifAttributedString;
            bodyCell.newsDetailLabel.textAlignment=NSTextAlignmentJustified;

            bodyCell.newsDetailLabel.textAlignment=NSTextAlignmentJustified;
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
            [self.tableView reloadData];
        }
        
        
        //Do what you want here
    }

    @end
