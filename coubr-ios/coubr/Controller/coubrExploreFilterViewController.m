//
//  coubrExploreFilterViewController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrExploreFilterViewController.h"
#import "coubrExploreFilterCategoryCollectionViewCell.h"

#import "coubrConstants.h"
#import "coubrCategoryToText.h"

#import <MapKit/MapKit.h>

@interface coubrExploreFilterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;

@property (weak, nonatomic) IBOutlet UIButton *specialOfferButton;
@property (weak, nonatomic) IBOutlet UIButton *stampCardButton;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;

@property (strong, nonatomic) NSArray *categories;

@property (nonatomic) BOOL isMetric;

#define MILES_IN_KILOMETER 1.609344

@end

@implementation coubrExploreFilterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _currentDistance = EXPLORE_DEFAULT_DISTANCE;
    _showSpecialOffers = NO;
    _showStampCards = NO;
    _showCoupons = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initSlider];
    [self initButtons];
}

#pragma mark - Init

- (BOOL)isMetric
{
    if (!_isMetric) {
        NSLocale *locale = [NSLocale currentLocale];
        _isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    }
    return _isMetric;
}

@synthesize selectedCategories = _selectedCategories;
@synthesize selectedSubcategories = _selectedSubcategories;

- (NSSet *)selectedCategories
{
    if (!_selectedCategories) {
        _selectedCategories = [[NSMutableSet alloc] initWithArray:self.categories];
    }
    return _selectedCategories;
}

- (NSSet *)selectedSubcategories
{
    if (!_selectedSubcategories) {
        _selectedSubcategories = [[NSMutableSet alloc] init];
    }
    return _selectedSubcategories;
}


#pragma mark - Slider

- (void)initSlider
{
    [self.distanceSlider setContinuous:NO];
    
    if (self.isMetric) {
        
        [self.distanceSlider setMinimumValue:1000.0];
        [self.distanceSlider setMaximumValue:50000.0];
        [self.distanceSlider setValue:10000.0];
        
    } else {
        
        [self.distanceSlider setMaximumValue:(1000.0 * MILES_IN_KILOMETER)];
        [self.distanceSlider setMaximumValue:(30000.0 * MILES_IN_KILOMETER)];
        [self.distanceSlider setValue:(5000.0 * MILES_IN_KILOMETER)];
        
    }
    
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
    [self.distanceLabel setText:[distanceFormatter stringFromDistance:self.distanceSlider.value]];
}


- (IBAction)changeSliderPosition:(UISlider *)sender {
    
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
    [self.distanceLabel setText:[distanceFormatter stringFromDistance:sender.value]];
    
    if (self.isMetric) {
        _currentDistance = sender.value;
    } else {
        _currentDistance = sender.value / MILES_IN_KILOMETER;
    }
    
    [self.parentController updateFetchedResultsControllerRequest];
    [self.parentController updateFetchedResultsController];
}

#pragma mark - Offers, Stamps, Coupons

- (void)initButtons
{
    [self.specialOfferButton setImage:[[UIImage imageNamed:@"Store_SpecialOffer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.stampCardButton setImage:[[UIImage imageNamed:@"Store_StampCard"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.couponButton setImage:[[UIImage imageNamed:@"Store_Coupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.specialOfferButton setSelected:self.showSpecialOffers];
    [self.stampCardButton setSelected:self.showStampCards];
    [self.couponButton setSelected:self.showCoupons];
}

- (IBAction)toggleSpecialOffers:(id)sender {
    
    [self.specialOfferButton setSelected:!self.specialOfferButton.selected];
    _showSpecialOffers = self.specialOfferButton.selected;
    
    if (_showSpecialOffers) {
        [self.specialOfferButton setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
    } else {
        [self.specialOfferButton setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
    }

    [self.parentController updateFetchedResultsControllerRequest];
}

- (IBAction)toggleStampCards:(id)sender {
    
    [self.stampCardButton setSelected:!self.stampCardButton.selected];
    _showStampCards = self.stampCardButton.selected;
    
    if (_showStampCards) {
        [self.stampCardButton setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
    } else {
        [self.stampCardButton setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
    }
    
    [self.parentController updateFetchedResultsControllerRequest];
}


- (IBAction)toggleCoupons:(id)sender {
    
    [self.couponButton setSelected:!self.couponButton.selected];
    _showCoupons = self.couponButton.selected;
    
    if (_showCoupons) {
        [self.couponButton setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
    } else {
        [self.couponButton setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
    }
    
    [self.parentController updateFetchedResultsControllerRequest];
}

#pragma mark - Category

- (NSArray *)categories
{
    if (!_categories) {
        _categories = @[ @"bakery", @"bar", @"brewery", @"cafe", @"fastfood", @"ice", @"restaurant", @"winery" ];
        _categories = [_categories sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

            return [[coubrCategoryToText textFromCategory:obj1 andSubcategory:nil] compare:[coubrCategoryToText textFromCategory:obj2 andSubcategory:nil]];
            
        }];
    }
    return _categories;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.categories.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"coubrExploreFilterCategoryCollectionViewCell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[coubrExploreFilterCategoryCollectionViewCell class]]) {
        coubrExploreFilterCategoryCollectionViewCell *categoryCell = (coubrExploreFilterCategoryCollectionViewCell *)cell;
        [categoryCell setParentController:self];
        [categoryCell setCategory:[self.categories objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)addCategory:(NSString *)category
{
    if (self.selectedCategories.count == self.categories.count) {
        [self.selectedCategories removeAllObjects];
    }
    
    [self.selectedCategories addObject:category];
    [self.parentController updateFetchedResultsControllerRequest];
}

- (void)removeCategory:(NSString *)category
{
    [self.selectedCategories removeObject:category];
    if (self.selectedCategories.count == 0) {
        [self.selectedCategories addObjectsFromArray:self.categories];
    }
    
    [self.parentController updateFetchedResultsControllerRequest];
}




@end
