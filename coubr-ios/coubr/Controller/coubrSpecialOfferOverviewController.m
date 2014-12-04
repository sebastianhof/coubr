//
//  coubrSpecialOfferOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 12/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrSpecialOfferOverviewController.h"

#import "coubrLocale.h"

#import "UIImage+ImageEffects.h"

@interface coubrSpecialOfferOverviewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation coubrSpecialOfferOverviewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initTableView];
    [self blurBackgroundImage];
}

#pragma mark - Init

- (void)initTableView
{
    // Header
    [self.titleLabel setText:self.specialOffer.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validOnLabel setText:[NSString stringWithFormat:@"%@ %@ %@ %@", LOCALE_SPECIAL_OFFER_VALID_FROM, [dateFormatter stringFromDate:self.specialOffer.validFrom], LOCALE_SPECIAL_OFFER_VALID_UNTIL, [dateFormatter stringFromDate:self.specialOffer.validTo]]];
    [self.shortDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.shortDescriptionLabel setText:[NSString stringWithFormat:@"%@", self.specialOffer.specialOfferShortDescription]];
    
    // Description
    [self.descriptionLabel setText:self.specialOffer.specialOfferDescription];
    
    [self.tableView reloadData];
    [self scrollToOffset];
}

#define TABLE_VIEW_TOP_OFFSET 36.0

- (void)scrollToOffset
{
    [self.tableView setContentOffset:CGPointMake(0, TABLE_VIEW_TOP_OFFSET) animated:NO];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.specialOffer.specialOfferDescription.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.specialOffer.specialOfferDescription.length > 0) {
        return LOCALE_SPECIAL_OFFER_DESCRIPTION;
    }
    return nil;
}

#define DEFAULT_HEADER_HEIGHT 150.0
#define DEFAULT_FOOTER_HEIGHT 99.0

#define DESCRIPTION_ROW_HEIGHT_MARGIN 16.0
#define DESCRIPTION_ROW_WIDTH_MARGIN 32.0

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return DEFAULT_HEADER_HEIGHT;
    } else if (indexPath.section == 1) {
        
        if (self.specialOffer.specialOfferDescription.length > 0) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = [self.specialOffer.specialOfferDescription boundingRectWithSize:CGSizeMake(cell.frame.size.width - DESCRIPTION_ROW_WIDTH_MARGIN, CGFLOAT_MAX)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                                                      context:nil];
            return rect.size.height + DESCRIPTION_ROW_HEIGHT_MARGIN;
        }
        
    } else if (indexPath.section == 2) {
        return DEFAULT_FOOTER_HEIGHT;
    }
    
    return 0;
}

#pragma mark - Blur

- (void)blurBackgroundImage
{
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

@end
