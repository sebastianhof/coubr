//
//  coubrStoreMenuTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreMenuTableViewCell.h"

@interface coubrStoreMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation coubrStoreMenuTableViewCell

- (void)initCellWithStoreMenuItem:(StoreMenuItem *)menuItem
{
    [self.titleLabel setText:menuItem.title];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [self.priceLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:menuItem.price]]];
}

@end
