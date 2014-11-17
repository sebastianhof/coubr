//
//  coubrHistoryTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrHistoryTableViewCell.h"

#import "Store.h"

#import "coubrCategoryToText.h"

#import "UIImage+ImageEffects.h"

@interface coubrHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *offersImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView3;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrHistoryTableViewCell

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHistory)];
    }
    return _tapRecognizer;
}

- (void)initCellWithHistory:(History *)history
{
    [self.nameLabel setText:history.store.name];
    
    [self.categoryLabel setText:[coubrCategoryToText textFromCategory:history.store.category andSubcategory:history.store.subcategory]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.dateLabel setText:[dateFormatter stringFromDate:history.date]];
    
    [self.offersImageView1 setImage:nil];
    [self.offersImageView2 setImage:nil];
    [self.offersImageView3 setImage:nil];
    
    if (history.coupons.count > 0) {
        
        // rightImageView
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_Coupon"]];
        
        if (history.stampCards.count > 0) {
            
            [self.offersImageView2 setImage:[UIImage imageNamed:@"Explore_StampCard"]];
            
            if (history.specialOffers.count > 0) {
                [self.offersImageView3 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
            }
            
        }
        
    } else if (history.stampCards.count > 0) {
        
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_StampCard"]];
        
        if (history.specialOffers.count > 0) {
            [self.offersImageView2 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
        }
        
    } else if (history.specialOffers.count > 0) {
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
    }
    
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
    [self.foregroundImageView addGestureRecognizer:self.tapRecognizer];
}

- (void)showHistory
{
    
}

- (void)blurBackgroundImage
{
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundImageView setClipsToBounds:YES];
    
    NSInteger randomNumber = arc4random() % 3;
    UIImage *image;
    if (randomNumber == 0) {
        image = [UIImage imageNamed:@"Explore_Image1"];
    } else if (randomNumber == 1) {
        image = [UIImage imageNamed:@"Explore_Image2"];
    } else if (randomNumber == 2) {
        image = [UIImage imageNamed:@"Explore_Image3"];
    } else {
        image = [UIImage imageNamed:@"Explore_Image1"];
    }
    [self.backgroundImageView setImage:image];
    
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
