//
//  coubrSpecialOfferTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrSpecialOfferTableViewCell.h"
#import "coubrSpecialOfferOverviewController.h"

#import "coubrLocale.h"
#import "UIImage+ImageEffects.h"

@interface coubrSpecialOfferTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;

@property (nonatomic) BOOL notInit;

@property (weak, nonatomic) SpecialOffer *specialOffer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation coubrSpecialOfferTableViewCell

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSpecialOffer)];
    }
    return _tapRecognizer;
}

- (void)initCellWithSpecialOffer:(SpecialOffer *)specialOffer
{
    self.specialOffer = specialOffer;
    
    [self.titleLabel setText:specialOffer.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validOnLabel setText:[NSString stringWithFormat:@"%@ %@ %@ %@", LOCALE_SPECIAL_OFFER_VALID_FROM, [dateFormatter stringFromDate:specialOffer.validFrom], LOCALE_SPECIAL_OFFER_VALID_UNTIL, [dateFormatter stringFromDate:specialOffer.validTo]]];
    [self.shortDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.shortDescriptionLabel setText:[NSString stringWithFormat:@"%@", specialOffer.specialOfferShortDescription]];
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
    [self.foregroundImageView addGestureRecognizer:self.tapRecognizer];
    
}

#pragma mark - Navigation

- (void)showSpecialOffer
{
    coubrSpecialOfferOverviewController *soovc = [[UIStoryboard storyboardWithName:@"Store" bundle:nil]  instantiateViewControllerWithIdentifier:@"coubrSpecialOfferOverviewController"];
    [soovc setSpecialOffer:self.specialOffer];
    [self.parentController.navigationController pushViewController:soovc animated:YES];
}

#pragma mark - Blur

- (void)blurBackgroundImage
{
//    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.backgroundImageView setClipsToBounds:YES];
//    [self.backgroundImageView setImage:[UIImage imageNamed:@"Special_Offer_Tile"]];
    
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
