//
//  MovieTableViewCell.h
//  Flixter
//
//  Created by Amanda Wang on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *movieContentView;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;

@end

NS_ASSUME_NONNULL_END
