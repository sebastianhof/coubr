//
//  coubrHistoryTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrHistoryTableViewCell.h"
#import "Store.h"
#import "coubrTypesToImage.h"
#import "UIImage+ImageEffects.h"

@interface coubrHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subcategoryImageView;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrHistoryTableViewCell

- (void)initCellWithHistory:(History *)history
{
    // name
    [self.nameLabel setText:history.store.name];
    
    // type
    // TODO at the moment we only support food establishments - do not set type - set category instead
    if (history.store.category) {
        [self.typeImageView setImage:[coubrTypesToImage imageForCategory:history.store.category]];
    }
    
    if (history.store.subcategory) {
        [self.categoryImageView setImage:[coubrTypesToImage imageForSubcategory:history.store.subcategory]];
    }
    
    // address
    [self.addressLabel setText:[NSString stringWithFormat:@"%@, %@", history.store.street, history.store.city]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.dateLabel setText:[dateFormatter stringFromDate:history.date]];
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
}

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
    
    self.notInit = YES;
}

@end
