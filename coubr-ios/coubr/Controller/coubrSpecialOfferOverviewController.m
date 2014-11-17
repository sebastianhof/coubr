//
//  coubrSpecialOfferOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 12/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrSpecialOfferOverviewController.h"
#import "coubrSpecialOfferDescriptionTableViewCell.h"

#import "coubrLocale.h"

#import "UIImage+ImageEffects.h"

@interface coubrSpecialOfferOverviewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;

@property (weak, nonatomic) IBOutlet UITableView *specialOfferTableView;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrSpecialOfferOverviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.titleLabel setText:self.specialOffer.title];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validOnLabel setText:[NSString stringWithFormat:@"%@ %@ %@ %@", LOCALE_SPECIAL_OFFER_VALID_FROM, [dateFormatter stringFromDate:self.specialOffer.validFrom], LOCALE_SPECIAL_OFFER_VALID_UNTIL, [dateFormatter stringFromDate:self.specialOffer.validTo]]];
    [self.shortDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.shortDescriptionLabel setText:[NSString stringWithFormat:@"%@", self.specialOffer.specialOfferShortDescription]];
    
    [self blurBackgroundImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_notInit) {
        [self blurTableViewBackground];
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.specialOffer.specialOfferDescription) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.specialOffer.specialOfferDescription) {
        return 1;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return LOCALE_SPECIAL_OFFER_DESCRIPTION;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.specialOffer.specialOfferDescription) {
            return [self initializeDescriptionTableViewCell];
        }
        
    }
    return nil;
}

- (UITableViewCell *)initializeDescriptionTableViewCell
{
    
    UITableViewCell *cell = [self.specialOfferTableView dequeueReusableCellWithIdentifier:@"coubrSpecialOfferDescriptionTableViewCell"];
    if ([cell isKindOfClass:[coubrSpecialOfferDescriptionTableViewCell class]]) {
        
        [((coubrSpecialOfferDescriptionTableViewCell *)cell).descriptionTextView setText:self.specialOffer.specialOfferDescription];
    }
    return cell;
}

#pragma mark - Blur

- (void)blurBackgroundImage
{
    //    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    //    [self.backgroundImageView setClipsToBounds:YES];
    //    [self.backgroundImageView setImage:[UIImage imageNamed:@"Coupon_Tile"]];
    
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
    [self.foregroundImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.foregroundImageView.layer setShadowRadius:3.0];
    [self.foregroundImageView.layer setShadowOpacity:0.05];
}

- (void)blurTableViewBackground
{
    UIGraphicsBeginImageContext(self.specialOfferTableView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.specialOfferTableView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.specialOfferTableView.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
    self.notInit = YES;
}

@end
