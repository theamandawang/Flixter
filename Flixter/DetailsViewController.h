//
//  DetailsViewController.h
//  Flixter
//
//  Created by Amanda Wang on 6/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (nonatomic, strong) NSDictionary *results;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *details;

@end

NS_ASSUME_NONNULL_END
