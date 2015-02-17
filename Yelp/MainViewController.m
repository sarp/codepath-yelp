//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"msoreE5hy5AYOnfx5IZN2w";
NSString * const kYelpConsumerSecret = @"ezapqrAJFpdt2Jwc96RJPx__jZ0";
NSString * const kYelpToken = @"5kkSkntscwI0LvaiE_efZk0ZtL2ipiBP";
NSString * const kYelpTokenSecret = @"xQAmvDB3DqguX85wwIitZs_PfbU";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *filterParams;
@property (nonatomic, strong) UISearchBar *searchBar;

- (void) fetchBusinessesWithParams:(NSDictionary *) params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.delegate = self;
        self.navigationItem.titleView = self.searchBar;
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithParams:self.filterParams];
    }
    return self;
}

#pragma mark - Filter delegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Filters: %@", filters);
    self.filterParams = filters;
    [self fetchBusinessesWithParams:self.filterParams];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.title = @"Yelp";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search bar methods

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO];
    [self fetchBusinessesWithParams:self.filterParams];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar endEditing:YES];
}

#pragma mark - Private methods

- (void) fetchBusinessesWithParams:(NSDictionary *)params {
    NSDictionary *defaults = @{@"category_filter" : @"restaurants", @"ll" : @"37.774866,-122.394556"};
    NSMutableDictionary *allParameters = [defaults mutableCopy];
    if (params) {
        [allParameters addEntriesFromDictionary:params];
    }
    if (![self.searchBar.text isEqualToString:@""]) {
        allParameters[@"term"] = self.searchBar.text;
    }
    
    [self.client searchWithParams:allParameters success:^(AFHTTPRequestOperation *operation, id response) {
     NSArray *businessesDictionaries = response[@"businesses"];
     self.businesses = [Business businessesWithDictionaries:businessesDictionaries];
     
     [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}

- (void) onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.translucent = NO;
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    nvc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:164.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];
    [self presentViewController:nvc animated:YES completion:nil];
}


@end
