//
//  DetailsViewController.m
//  Flixter
//
//  Created by Amanda Wang on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTitle.text = self.results[@"title"];
    self.details.text = self.results[@"overview"];
    self.rating.text = [ NSString stringWithFormat:@"%@%@", @"Rating: ", self.results[@"vote_average"]];
    NSString *poster_path = self.results[@"poster_path"];
    poster_path = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString: poster_path];
    NSURL *posterURL = [NSURL URLWithString: poster_path];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [self.poster setImageWithURL:posterURL];
//
    // Do any additional setup after loading the view.
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
