//
//  coubrFavoritesTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrFavoritesTableViewCell.h"
#import "coubrTypesToImage.h"
#import "UIImage+ImageEffects.h"

@interface coubrFavoritesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subcategoryImageView;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrFavoritesTableViewCell

- (void)initCellWithStore:(Store *)store
{
    // name
    [self.nameLabel setText:store.name];
    
    // type
    // TODO at the moment we only support food establishments - do not set type - set category instead
    if (store.category) {
        [self.typeImageView setImage:[coubrTypesToImage imageForCategory:store.category]];
    }
    
    if (store.subcategory) {
        [self.categoryImageView setImage:[coubrTypesToImage imageForSubcategory:store.subcategory]];
    }
    
    // address
    [self.addressLabel setText:[NSString stringWithFormat:@"%@, %@", store.street, store.city]];
    
    
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
