//
//  coubrExploreFilterCategoryCollectionViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 17/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrExploreFilterCategoryCollectionViewCell.h"

#import "coubrCategoryToImage.h"
#import "coubrCategoryToText.h"

@interface coubrExploreFilterCategoryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryLabelButton;

@end

@implementation coubrExploreFilterCategoryCollectionViewCell

- (void)setCategory:(NSString *)category
{
    _category = category;
    
    [self.categoryButton setImage:[coubrCategoryToImage imageForCategory:category] forState:UIControlStateNormal];
    [self.categoryLabelButton setTitle:[coubrCategoryToText textFromStoreCategory:category andStoreSubcategory:nil] forState:UIControlStateNormal];

}

- (IBAction)toggleCategory:(id)sender {

    [self.categoryButton setSelected:!self.categoryButton.selected];
    //[self.categoryButton setHighlighted:NO];
    
    if (self.categoryButton.selected) {
        [self.categoryButton setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
        [self.categoryLabelButton setTitleColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1] forState:UIControlStateNormal];
        [self.parentController addCategory:self.category];
    } else {
        [self.categoryButton setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
        [self.categoryLabelButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
        [self.parentController removeCategory:self.category];

    }

}

@end
