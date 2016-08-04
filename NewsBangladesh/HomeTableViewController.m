//
//  HomeTableViewController.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import "HomeTableViewController.h"
#import "AFNetworking.h"
#import "NBPreference.h"
#import "News.h"
#import "HomeTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NewsDetailTableViewController.h"
#import "NewsDetailImageTableViewCell.h"
#import "NewsBriefTableViewCell.h"
#import "NSString+NBOptions.h"
#import "NBPreference.h"
#import "CategoyTableViewController.h"
#import "NewsCategory.h"
#import "AlertTableViewController.h"
#import "NewsCategoryDataSource.h"
#import "MBProgressHUD.h"

@interface HomeTableViewController () <CategoyTableViewControllerDelegate, AlertTableViewControllerDelegate> {
    
    NBLanguageMode preferredLanguageMode;
    
    UIAlertView *alert;
    NSString *currentURL;
    int languagemodeflag;
    BOOL languageChanged;
}

@property (nonatomic, strong) NewsCategory *currentCategory;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *navBarRightImageView;
@property (nonatomic, weak) IBOutlet UILabel *navTitleLabel;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    [self.tableView layoutIfNeeded];
    
    self.tableView.estimatedRowHeight = 125.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
  //  [NBPreference sendDeviceToken];
    _headerView.frame = CGRectZero;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        languagemodeflag=1;
        preferredLanguageMode = [NBPreference languageMode];
        _newsArray = [NSMutableArray new];
        
        
    
        
        if (preferredLanguageMode == LanguageModeBangla) {
            
            currentURL = [NSString stringWithFormat:@"%@%@", NBBaseURL, NBNews_BanglaURL];
            
        } else {
            
            currentURL = [NSString stringWithFormat:@"%@%@", NBBaseURL, NBNews_EnglishURL];
        }
        
        if (self.catid==0) {
            [self createLoadingScreen];
            [self loadCategories];
            [self loadNews];
        }
        else
        {
            
            [self createLoadingScreen];
            [self loadCategories];
            NewsCategory *presentCategory =    [_categories objectAtIndex:self.catid];
            
            [self categoryListDidDismissWithCategory:presentCategory];
            
        }
    });
    
   
     
}



-(void) viewDidAppear:(BOOL)animated
{
   
    
    NBLanguageMode currentLanguageMode = [NBPreference languageMode];
//    NSLog(@"%u",currentLanguageMode);
//    NSLog(@"%u",preferredLanguageMode);
    
    if (languageChanged==YES) {
        languageChanged=NO;
         _currentCategory=0;
        _navBarRightImageView.hidden = NO;
        _navTitleLabel.hidden=YES;

    }

    
    
//    NSLog(@"Current Category %@",_currentCategory);
    
    
}


-(NSString*)uniqueIDForDevice
{
    NSString* uniqueIdentifier = nil;
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) { // >=iOS 7
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }

return uniqueIdentifier;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createLoadingScreen {
    
    alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles: nil];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [indicator startAnimating];
    
    [alert setValue:indicator forKey:@"accessoryView"];
}

- (void)showLoadingScreen {
    
    
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[MBProgressHUD setLabelText:@"Text"];
}

- (void)dismissLoadingScreen {
    
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)refreshAction:(UIRefreshControl *)sender {
    
    [self loadNews];
    [self.refreshControl endRefreshing];
}

- (IBAction)leftSwipeAction:(id)sender {
    
    NSInteger currentCategoryIndex;
    
    if (!_currentCategory) {
        
        currentCategoryIndex = 0;
        
    }
    else {
        
        [UIView transitionWithView:self.tableView
                          duration:0.7
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            /* any other animation you want */
                        } completion:^(BOOL finished) {
                            /* hide/show the required cells*/
                        }];
        
//        NSLog(@"Current Category %@",_currentCategory);
        
        currentCategoryIndex = [_categories indexOfObject:_currentCategory];
        
    }
//      NSLog(@"Current Category index: %ld",(long)currentCategoryIndex);
    if (currentCategoryIndex == _categories.count - 1) return;
    
    NewsCategory *nextCategory = [_categories objectAtIndex:currentCategoryIndex + 1];
    
    [self loadNewsForCategory:nextCategory];
}

- (IBAction)rightSwipeAction:(id)sender {
  
    NSInteger currentCategoryIndex;
    
    if (!_currentCategory) {
        
        return;
        
    } else {
        [UIView transitionWithView:self.tableView
                          duration:0.7
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            /* any other animation you want */
                        } completion:^(BOOL finished) {
                            /* hide/show the required cells*/
                        }];
        
        currentCategoryIndex = [_categories indexOfObject:_currentCategory];
    }
  
    
    if (currentCategoryIndex == 0) return;
    
    NewsCategory *nextCategory = [_categories objectAtIndex:currentCategoryIndex - 1];
    
    [self loadNewsForCategory:nextCategory];
}

- (void)loadCategories {
    
    NSDictionary *dataSource = [[NewsCategoryDataSource sharedInstance] dataSource];
    NSArray *rawCategories;
    
    if ([NBPreference languageMode] == LanguageModeBangla) {
        
        rawCategories = [dataSource objectForKey:@"Bangla"];
        
    } else {
        
        rawCategories = [dataSource objectForKey:@"English"];
    }
    
    NSMutableArray *categoryObjects = [NSMutableArray new];
    
    for (NSDictionary *categoryDictionary in rawCategories) {
        
        NewsCategory *category = [NewsCategory new];
        
        category.categoryID = [categoryDictionary objectForKey:@"categoryID"];
        category.categoryName = [categoryDictionary objectForKey:@"categoryName"];
        
        NSString *imageName = [categoryDictionary objectForKey:@"categoryImage"];
        category.categoryImage = [UIImage imageNamed:imageName];
        
        [categoryObjects addObject:category];
    }
    
    _categories = [NSArray arrayWithArray:categoryObjects];
}

- (void)loadNews {
    
    [self showLoadingScreen];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:currentURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _headerView.frame = CGRectZero;
        [self.tableView layoutIfNeeded];
        
        NSArray *responseArray = (NSArray *) responseObject;
        
        [_newsArray removeAllObjects];
        
        for (NSDictionary *newsDictionay in responseArray) {
            
            News *news = [News new];
            
            news.newsID = [newsDictionay objectForKey:@"ID"];
            news.subHeading = [newsDictionay objectForKey:@"SubHead"];
            news.heading = [newsDictionay objectForKey:@"Head"];
            
          
            news.writer = [newsDictionay objectForKey:@"Writers"];
            news.brief = [newsDictionay objectForKey:@"Brief"];
            news.details = [newsDictionay objectForKey:@"Details"];
            news.thumbURL = [NSString stringWithFormat:@"%@%@%@", NBBaseURL, NBNewsImageBaseURL, [newsDictionay objectForKey:@"Thumb"]];
            news.thumbCaption = [newsDictionay objectForKey:@"ThumbCaption"];
            news.imageURL = [NSString stringWithFormat:@"%@%@%@", NBBaseURL, NBNewsImageBaseURL, [newsDictionay objectForKey:@"ImgBG"]];
            news.imageCaption = [newsDictionay objectForKey:@"ImgBGCaption"];
            news.dateString = [newsDictionay objectForKey:@"DateTimeInsert"];
            news.readCount = [[newsDictionay objectForKey:@"Read"] intValue];
            news.emailCount = [[newsDictionay objectForKey:@"Email"] intValue];
            news.shareCount = [[newsDictionay objectForKey:@"Share"] intValue];
            news.shareurl = [newsDictionay objectForKey:@"url"];
            [_newsArray addObject:news];
        }
        
        // We're inserting the first object at the first index again,
        // because the first two row of the table shows the first
        // news item as combined group. The First row shows the image
        // and the second row shows the title and the brief.
        
        if (_newsArray.count) {
            
            News *news = [_newsArray objectAtIndex:0];
            
            [_newsArray insertObject:news atIndex:0];
        }
       
        [self.tableView reloadData];
        
        [self dismissLoadingScreen];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"Error: %@", error);
        
        _headerView.bounds = CGRectMake(0, 0, self.tableView.frame.size.width, 21);
        [self.tableView layoutIfNeeded];
        
        [self dismissLoadingScreen];
    }];
}

- (void)loadNewsForCategory:(NewsCategory *)category {
    
    _currentCategory = category;
    
    NSString *url;
    
    _navTitleLabel.text = _currentCategory.categoryName;
    
    if (preferredLanguageMode == LanguageModeBangla) {
        
        if ([category.categoryID isEqualToString:@"0"]) {
            
            url = [NSString stringWithFormat:@"%@%@", NBBaseURL, NBNews_BanglaURL];
            
            _navBarRightImageView.hidden = NO;
            _navTitleLabel.hidden = YES;
            
        }
        else if ([category.categoryID isEqualToString:@"14"]) {
            
            url = NBMostEmailedBangla;
            
            _navBarRightImageView.hidden = YES;
            _navTitleLabel.hidden = NO;
            
        }
        else if ([category.categoryID isEqualToString:@"15"]) {
            
            url = NBMOstSharedBangla;
            
            _navBarRightImageView.hidden = YES;
            _navTitleLabel.hidden = NO;
            
        }
        else {
            
            url = [NSString stringWithFormat:@"%@%@%@", NBBaseURL, NBNewsByCategory_BanglaURL, category.categoryID];
            
            _navBarRightImageView.hidden = YES;
            _navTitleLabel.hidden = NO;
        }
        
    } else {
        
        if ([category.categoryID isEqualToString:@"0"]) {
            
            url = [NSString stringWithFormat:@"%@%@", NBBaseURL, NBNews_EnglishURL];
            
            _navBarRightImageView.hidden = NO;
            _navTitleLabel.hidden = YES;
            
        }
        else if ([category.categoryID isEqualToString:@"11"]) {
            
            url = NBMOstEmailedEnglish;
            
            _navBarRightImageView.hidden = YES;
            _navTitleLabel.hidden = NO;
            
        }
        else if ([category.categoryID isEqualToString:@"12"]) {
            
            url = NBMOstSharedEnglish;
            
            _navBarRightImageView.hidden = YES;
            _navTitleLabel.hidden = NO;
            
        }
        
        else {
            
            url = [NSString stringWithFormat:@"%@%@%@", NBBaseURL, NBNewsByCategory_EnglishURL, category.categoryID];
            
            _navBarRightImageView.hidden = YES;
            _navTitleLabel.hidden = NO;
        }
    }
    
    if (![url isEqualToString:currentURL]) {
        
        currentURL = url;
        [self loadNews];
    }
}

#pragma mark - Category delegate

- (void)categoryListDidDismissWithCategory:(NewsCategory *)category {
    
    // if the font size was changed this reload will
    // adjust the layout for adative cell design
    
    [self.tableView reloadData];
    
    // though the category returned from the category list
    // is the same present in this classes category array,
    // the hash keys are different. thus indexOfObject will not
    // found the correct index as this array does not recognize
    // the hash key for this object. This is why we have to manually
    // set the category from this classes array
//    NSLog(@"Test %@",category.categoryID);
    
    
    NewsCategory *presentCategory = nil;
    
    for (NewsCategory *cat in _categories) {
        
        if ([category.categoryID isEqualToString:cat.categoryID]) {
            
            presentCategory = cat;
            
        }
    }
    
    [self loadNewsForCategory:presentCategory];
}

#pragma mark - Alert delegate

- (void)alertTVCDidDismiss {
    languagemodeflag=0; //Used For Header Image
    
    NBLanguageMode currentLanguageMode = [NBPreference languageMode];
    
    if (currentLanguageMode != preferredLanguageMode) {
        languageChanged=YES;
        
        preferredLanguageMode = currentLanguageMode;
        
        if (preferredLanguageMode == LanguageModeBangla) {
            
            currentURL = [NSString stringWithFormat:@"%@%@", NBBaseURL, NBNews_BanglaURL];
            
        } else {
            
            currentURL = [NSString stringWithFormat:@"%@%@", NBBaseURL, NBNews_EnglishURL];
        }
        [self loadCategories];
        [self loadNews];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _newsArray.count ? _newsArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_newsArray.count) {
      
        static NSString *TableCellIdentifier;
        
        if (indexPath.row == 0) {
            
            TableCellIdentifier = @"NewsImageTableViewCellIdentifier";
            
        } else if (indexPath.row == 1) {
            
            TableCellIdentifier = @"NewsBriefTableViewCellIdentifier";
            
        } else {
            
            TableCellIdentifier = @"HomeTableCellIdentifier";
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellIdentifier forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else {
        
        static NSString *TableCellIdentifier = @"NoNewsTableVIewCellIdentifier";;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.font = [NBPreference fontForBodyLabel];
        
        if (preferredLanguageMode == LanguageModeBangla) {
            
            cell.textLabel.text = @"";
        } else {
            
            cell.textLabel.text = @"";
        }
        
        return cell;
    }
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        if ([cell isKindOfClass:[NewsDetailImageTableViewCell class]]) {
            
            NewsDetailImageTableViewCell *imageCell = (NewsDetailImageTableViewCell *)cell;
            
            News *news = [_newsArray objectAtIndex:0];
             //NSURL *thumbImageURL = [NSURL URLWithString:news.thumbURL];
            NSURL *imageURL = [NSURL URLWithString:news.thumbURL];
//            NSLog(@"Image URL: %@",imageURL);
            
            [imageCell.newsImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"banner"]];
            
        }
        
    } else if (indexPath.row == 1) {
        
        if ([cell isKindOfClass:[NewsBriefTableViewCell class]]) {
            
            NewsBriefTableViewCell *homeCell = (NewsBriefTableViewCell *)cell;
            
            News *news = [_newsArray objectAtIndex:indexPath.row];
            
            homeCell.headingLabel.text = news.heading.stringByStrippingHTMLContent;
            homeCell.headingLabel.font = [NBPreference fontForHeadingLabel];
           // homeCell.headingLabel.textAlignment=NSTextAlignmentJustified;
            
            NSString *breifString = [NSString stringWithFormat:@"%@ | %@", news.dateString, news.brief.stringByStrippingHTMLContent];
            
            NSAttributedString *breifAttributedString = [self attributedStringFromDateString:news.dateString withBriefString:breifString];
            
            homeCell.breifLabel.attributedText = breifAttributedString;
            homeCell.breifLabel.textAlignment=NSTextAlignmentJustified;
        }
        
    } else {
        
        if ([cell isKindOfClass:[HomeTableViewCell class]]) {
            
            HomeTableViewCell *homeCell = (HomeTableViewCell *)cell;
            
            News *news = [_newsArray objectAtIndex:indexPath.row];
            if (indexPath.row==2) {
//                NSLog(@"%@",news.thumbURL);
                
                
            }
            
            homeCell.headingLabel.text = news.heading.stringByStrippingHTMLContent;
            homeCell.headingLabel.font = [NBPreference fontForHeadingLabel];
            
            NSString *breifString = [NSString stringWithFormat:@"%@ | %@", news.dateString, news.brief.stringByStrippingHTMLContent];
            
            NSAttributedString *breifAttributedString = [self attributedStringFromDateString:news.dateString withBriefString:breifString];
            
            homeCell.breifLabel.attributedText = breifAttributedString;
            homeCell.breifLabel.textAlignment=NSTextAlignmentJustified;
            NSURL *thumbImageURL = [NSURL URLWithString:news.thumbURL];
            
       
                [homeCell.thumbImageView setImageWithURL:thumbImageURL placeholderImage:[UIImage imageNamed:@"tham"]];
          
           
        }
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"NewsDetailsSegueIdentifier1"] ||
        [segue.identifier isEqualToString:@"NewsDetailsSegueIdentifier2"] ||
        [segue.identifier isEqualToString:@"NewsDetailsSegueIdentifier3"]) {
        
        News *news = [_newsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        NewsDetailTableViewController *newsTVC = (NewsDetailTableViewController *) segue.destinationViewController;
        newsTVC.news = news;
        newsTVC.newsArray=_newsArray;
        newsTVC.newsindex=self.tableView.indexPathForSelectedRow.row;
        
        
    } else if ([segue.identifier isEqualToString:@"CategoryListSegueIdentifier"]) {
        
        UINavigationController *navC = (UINavigationController *)segue.destinationViewController;
        CategoyTableViewController *categoryTVC = (CategoyTableViewController *) navC.visibleViewController;
        categoryTVC.delegate = self;
        categoryTVC.newsArray=_newsArray;
        
    } else if ([segue.identifier isEqualToString:@"AlertVCSegueIdentifier"]) {
        
        UINavigationController *navC = (UINavigationController *)segue.destinationViewController;
        AlertTableViewController *alertTVC = (AlertTableViewController *) navC.visibleViewController;
        alertTVC.delegate = self;
        
    }
}

@end
