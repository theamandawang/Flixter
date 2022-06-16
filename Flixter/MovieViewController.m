//
//  MovieViewController.m
//  Flixter
//
//  Created by Amanda Wang on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController () <UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UILabel *MyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MovieViewController
- (void) beginRefresh:(UIRefreshControl *)refreshControl {
//    [self.refreshControl beginRefreshing];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=ed1cb9dcb86fd8882bb243d387cc1f37"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.results = dataDictionary[@"results"];
               [self.tableView reloadData];
               [self.refreshControl endRefreshing];
           }
       }];
    [task resume];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=ed1cb9dcb86fd8882bb243d387cc1f37"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               self.results = dataDictionary[@"results"];
               NSLog(@"%@", self.results);
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               self.tableView.dataSource = self;
               self.tableView.rowHeight = 300;
               [self.tableView reloadData];
               self.refreshControl = [[UIRefreshControl alloc] init];
               [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
               [self.tableView insertSubview:self.refreshControl atIndex:0];

           }
       }];
    [task resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *data = self.results[indexPath.row];
    cell.movieTitle.text = data[@"title"];
    cell.movieDescription.text = data[@"overview"];
    NSString *poster_path = data[@"poster_path"];
    poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];
    NSURL *posterURL = [NSURL URLWithString: poster_path];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

    [cell.movieImage setImageWithURL:posterURL];

//    NSURLSession *posterSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [posterSession dataTaskWithRequest:posterRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//           if (error != nil) {
//               NSLog(@"%@", [error localizedDescription]);
//           }
//           else {
//               cell.movieImage.image = [UIImage imageWithData:data];
//           }
//       }];
//    [task resume];
    
    
    
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
