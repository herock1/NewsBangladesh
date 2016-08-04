//
//  CategoyTableViewController.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import "CategoyTableViewController.h"
#import "NewsCategoryDataSource.h"
#import "NBPreference.h"
#import "NewsCategory.h"
#import "HomeTableViewController.h"
#import "News.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SearchsDetailTableViewController.h"
#import "NSString+NBOptions.h"
@interface CategoyTableViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *header;
@property (nonatomic, strong) NSMutableArray *imageurl;
@property (nonatomic, strong) NSMutableArray *date;
@property (nonatomic, strong) NSMutableArray *detail;
@property (nonatomic, strong) NSMutableArray *newsid;

@property  NSInteger searchmode;

@end

@implementation CategoyTableViewController

- (void)viewDidLoad {
    _header=[[NSMutableArray alloc] init];
    _imageurl=[[NSMutableArray alloc] init];
    _date=[[NSMutableArray alloc]init];
    
    _searchmode=0;
    [super viewDidLoad];
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    [tempSearchBar setShowsCancelButton:YES];
    self.searchBar = tempSearchBar;
   // [tempSearchBar release];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    NSLog(@"Hello News: %@",_newsArray);
    [self loadCategories];
    
    //Tableview header add
}
#pragma mark SearchBar Delegate method
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     [self loadCategories];
    _searchmode=0;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
   // [searchBar setShowsCancelButton:NO animated:YES];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _categories=nil;
    [self.tableView reloadData];
    _searchmode=1;
    _header=[[NSMutableArray alloc] init];
    _imageurl=[[NSMutableArray alloc] init];
    _date=[[NSMutableArray alloc]init];
    _detail=[[NSMutableArray alloc] init];
    _newsid = [[NSMutableArray alloc] init];
    
    
    for (int i=1; i<[_newsArray count]; i++) {
        News *news = [_newsArray objectAtIndex:i];
        NSString *newsTitle=news.heading;
        
   
            NSLog(@"%@",newsTitle);
            [_header addObject:news.heading];
            [_imageurl addObject:news.thumbURL];
            [_date addObject:news.dateString];
            [_detail addObject:news.details];
        [_newsid addObject:news.shareurl];
     
        
        
    }
    
    [self.tableView reloadData];
    return  YES;
}
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    _searchmode=2;
    
    _header=[[NSMutableArray alloc] init];
    _imageurl=[[NSMutableArray alloc] init];
    _date=[[NSMutableArray alloc]init];
    _detail=[[NSMutableArray alloc] init];
    _newsid=[[NSMutableArray alloc] init];
    
    
    for (int i=1; i<[_newsArray count]; i++) {
         News *news = [_newsArray objectAtIndex:i];
        NSString *newsTitle=news.heading;
        
       // NSLog(@"%@ Test",[slug objectAtIndex:i]);
        if ([[newsTitle lowercaseString]  containsString:[searchText lowercaseString]]) {
//            NSLog(@"%@",newsTitle);
            [_header addObject:news.heading];
            [_imageurl addObject:news.thumbURL];
            [_date addObject:news.dateString];
            [_detail addObject:news.details];
            [_newsid addObject:news.shareurl];
        }
        
        
    }
    
    if (_header.count==0) {
        [_header addObject:@"Nothing Found"];
    }
    [self.tableView reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchmode==0) {
         return _categories.count;
    }
    else if(_searchmode==1)
    {
        return _newsArray.count-1;
    }
    else
    {
        return [_header count];
    }
    
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_searchmode==0)
    {
        return 50;
    }
    else
    {
        return 90;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchmode==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCellIdentifier" forIndexPath:indexPath];
        
        NewsCategory *category = [_categories objectAtIndex:indexPath.row];
        
        cell.textLabel.text = category.categoryName;
        cell.textLabel.font = [NBPreference fontForBodyLabel];
        
        cell.imageView.image = category.categoryImage;
        return cell;
    }
    else if(_searchmode==1)
    {
        UITableViewCell    *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                        reuseIdentifier:@"CategoryTableViewCellIdentifier"];
       
      
     
            
   //     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCellIdentifier" forIndexPath:indexPath];
        
      News *news = [_newsArray objectAtIndex:indexPath.row+1];
        cell.textLabel.numberOfLines=3;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.text=news.heading.stringByStrippingHTMLContent;
        cell.detailTextLabel.text=news.dateString;
        cell.imageView.image=NULL;
         NSURL *thumbImageURL = [NSURL URLWithString:news.thumbURL];
        
        UIImageView *searchimage=[[UIImageView alloc] init];
        
        [searchimage setImageWithURL:thumbImageURL placeholderImage:[UIImage imageNamed:@"tham"]];
        cell.accessoryView=searchimage;
        [cell.accessoryView setFrame:CGRectMake(0, 0, 40, 40)];
        return cell;
        
    }
    else
    {
        UITableViewCell    *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                          reuseIdentifier:@"CategoryTableViewCellIdentifier"];
        if ([[_header objectAtIndex:0] isEqualToString:@"Nothing Found"]) {
            
            
            cell.detailTextLabel.text=@"      NO Article Found On NewsBangladesh.com";
            return cell;
        }
        cell.textLabel.numberOfLines=3;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.text=[_header objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[_date objectAtIndex:indexPath.row];
        cell.imageView.image=NULL;
        NSURL *thumbImageURL = [NSURL URLWithString:[_imageurl objectAtIndex:indexPath.row]];
        
        UIImageView *searchimage=[[UIImageView alloc] init];
        
        [searchimage setImageWithURL:thumbImageURL placeholderImage:[UIImage imageNamed:@"tham"]];
        cell.accessoryView=searchimage;
        [cell.accessoryView setFrame:CGRectMake(0, 0, 50, 50)];
        return cell;
    }
    
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchmode==0) {
        
        HomeTableViewController *nextview = (HomeTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]     instantiateViewControllerWithIdentifier:@"home"];
        //[self.navigationController popToViewController:nextview animated:YES];
        nextview.catid=indexPath.row;
        [self.navigationController pushViewController:nextview animated:YES];
    }
    else
    {
        if ([[_header objectAtIndex:0] isEqualToString:@"Nothing Found"]) {
            
   
        }
        else
        {
        
         SearchsDetailTableViewController *nextview = (SearchsDetailTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]     instantiateViewControllerWithIdentifier:@"search"];
        
        NSLog(@"%@",[_detail objectAtIndex:indexPath.row]);
        
        nextview.detailnews=[_detail objectAtIndex:indexPath.row];
        nextview.headernews=[_header objectAtIndex:indexPath.row];
        nextview.imageurl=[_imageurl objectAtIndex:indexPath.row];
        nextview.datenews=[_date objectAtIndex:indexPath.row];
        nextview.searchnewsid  = [_newsid objectAtIndex:indexPath.row];
      
        
        [self.navigationController pushViewController:nextview animated:YES];
        }
    }
   
    
   

}

@end
