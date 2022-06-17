//
//  MovieViewController.m
//  Flixter
//
//  Created by Amanda Wang on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UILabel *MyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;
//@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *filteredData;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MovieViewController
- (void) beginRefresh:(UIRefreshControl *)refreshControl {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=ed1cb9dcb86fd8882bb243d387cc1f37"];
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               //if there is no network connection
               if(error.code == -1009){
                   UIAlertController * myAlert = [UIAlertController alertControllerWithTitle:@"Cannot Access   Movies :(" message:@"Try connecting to WiFi"           preferredStyle:UIAlertControllerStyleAlert];
                   UIAlertAction * retry =  [UIAlertAction
                                            actionWithTitle:@"Try Again"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [self beginRefresh:(refreshControl)];
                                            }];
                   [myAlert addAction:retry];
                   [self presentViewController:myAlert animated:NO completion:nil];
               }
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.results = dataDictionary[@"results"];
               self.filteredData = self.results;
               [self.tableView reloadData];
               [self.refreshControl endRefreshing];
               [self.activityIndicator stopAnimating];

           }
       }];
    [task resume];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=ed1cb9dcb86fd8882bb243d387cc1f37"];
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               if(error.code == -1009){
                   UIAlertController * myAlert = [UIAlertController alertControllerWithTitle:@"Cannot Access   Movies :(" message:@"Try connecting to WiFi"           preferredStyle:UIAlertControllerStyleAlert];
                   UIAlertAction * retry =  [UIAlertAction
                                            actionWithTitle:@"Try Again"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //attempt to reload again
                                                [self viewDidLoad];
                                            }];
                   [myAlert addAction:retry];
                   [self presentViewController:myAlert animated:NO completion:nil];
               }
           }
           else {
               //get the data
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.results = dataDictionary[@"results"];
               self.filteredData = self.results;
               self.tableView.dataSource = self;
               self.tableView.rowHeight = 300;
               [self.tableView reloadData];
               self.refreshControl = [[UIRefreshControl alloc] init];
               [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
               [self.tableView insertSubview:self.refreshControl atIndex:0];
               [self.activityIndicator stopAnimating];

           }
       }];
    [task resume];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.results filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.results;
    }
    
    [self.tableView reloadData];
}


//for a cell at a specific indexPath, display the poster, title, and description

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *data = self.filteredData[indexPath.row];
    cell.movieTitle.text = data[@"title"];
    cell.movieDescription.text = data[@"overview"];
    NSString *poster_path = data[@"poster_path"];
    poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];
    NSURL *posterURL = [NSURL URLWithString: poster_path];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [cell.movieImage setImageWithURL:posterURL];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredData.count;
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //get "id" of clicked cell
     NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
     //access the data for clicked cell
     NSDictionary *dataToPass = self.filteredData[indexPath.row];
     //get view controller object for the next screen
     DetailsViewController *next = [segue destinationViewController];
     //set the public member of DetailsViewController to the data
     next.results = dataToPass;
 }

@end
