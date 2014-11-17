//
//  coubrStampCardTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStampCardTableViewCell.h"
#import "coubrStampCardOverviewController.h"

#import "coubrLocale.h"
#import "UIImage+ImageEffects.h"

@interface coubrStampCardTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *stampsCollectedLabel;

@property (nonatomic) BOOL notInit;

@property (weak, nonatomic) StampCard *stampCard;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation coubrStampCardTableViewCell

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStampCard)];
    }
    return _tapRecognizer;
}

- (void)initCellWithStampCard:(StampCard *)stampCard
{
    self.stampCard = stampCard;
    
    [self.titleLabel setText:stampCard.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_STAMP_CARD_VALID_UNTIL, [dateFormatter stringFromDate:stampCard.validTo]]];
    
    [self.stampsCollectedLabel setText:[NSString stringWithFormat:@"%lu %@ %lu %@", [stampCard.stampsCollected longValue], LOCALE_STAMP_CARD_COLLECTED_OF ,[stampCard.stamps longValue], LOCALE_STAMP_CARD_COLLECTED]];
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
    [self.foregroundImageView addGestureRecognizer:self.tapRecognizer];

}

#pragma mark - Navigation

- (void)showStampCard
{
    coubrStampCardOverviewController *scovc = [[UIStoryboard storyboardWithName:@"Store" bundle:nil]  instantiateViewControllerWithIdentifier:@"coubrStampCardOverviewController"];
    [scovc setStampCard:self.stampCard];
    [self.parentController.navigationController pushViewController:scovc animated:YES];
}

#pragma mark - Blur

- (void)blurBackgroundImage
{
//    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.backgroundImageView setClipsToBounds:YES];
//    [self.backgroundImageView setImage:[UIImage imageNamed:@"Stamp_Card_Tile"]];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
    
    [self.foregroundImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.foregroundImageView.layer setBorderWidth: 4.0];
    [self.backgroundImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.backgroundImageView.layer setBorderWidth: 4.0];
    
    
    [self.foregroundImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.foregroundImageView.layer setShadowRadius:3.0];
    [self.foregroundImageView.layer setShadowOpacity:0.05];
    
    self.notInit = YES;
}

@end
