//
//  GridViewController.m
//  Flixter
//
//  Created by Amanda Wang on 6/17/22.
//

#import "GridViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
@interface GridViewController ()
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation GridViewController

static NSString * const reuseIdentifier = @"Cell";
- (void) beginRefresh:(UIRefreshControl *)refreshControl {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=ed1cb9dcb86fd8882bb243d387cc1f37"];
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
               [self.collectionView reloadData];
               self.results = dataDictionary[@"results"];
               [self.refreshControl endRefreshing];

           }
       }];
    [task resume];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=ed1cb9dcb86fd8882bb243d387cc1f37"];
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
                                                [self viewDidLoad];
                                            }];
                   [myAlert addAction:retry];
                   [self presentViewController:myAlert animated:NO completion:nil];
               }
           }
           else {
               //get results from api call
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.results = dataDictionary[@"results"];
               NSLog(@"%@", self.results);

               [self.collectionView reloadData];
               self.refreshControl = [[UIRefreshControl alloc] init];
               [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
               [self.collectionView insertSubview:self.refreshControl atIndex:0];
           }
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.results.count;
}

//for a specific indexPath for a cell, load the poster image
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PosterCell" forIndexPath:indexPath];
    NSDictionary *data = self.results[indexPath.row];
    NSString *poster_path = data[@"poster_path"];
    poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];
    NSURL *posterURL = [NSURL URLWithString: poster_path];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [cell.poster setImageWithURL:posterURL];
    return cell;
}
@end
