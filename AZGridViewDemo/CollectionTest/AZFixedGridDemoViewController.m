//
//  AZFixedGridDemoViewController.m
//  CollectionTest
//
//  Created by Alessandro Zoffoli on 31/05/13.
//  Copyright (c) 2013 Apexnet. All rights reserved.
//

#import "AZFixedGridDemoViewController.h"

#import "AZFixedGridLayout.h"

#import <QuartzCore/QuartzCore.h>

static NSString *NormalCellIdentifier = @"ItemCell";
static NSString *RowHeaderCellIdentifier = @"RowHeaderCell";
static NSString *ColumnHeaderCellIdentifier = @"ColumnHeaderCell";
static NSString *EmptyHeaderCellIdentifier = @"EmptyHeaderCell";

@interface AZFixedGridDemoViewController () <AZCollectionViewDataSource, AZCollectionViewDelegate>

@property (nonatomic, strong) NSArray *columnHeaders;
@property (nonatomic, strong) NSArray *rowHeaders;

@property (nonatomic, strong) NSArray *rows;

@end

@implementation AZFixedGridDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.collectionViewDataSource = self;
        self.collectionViewDelegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.collectionViewDataSource = self;
        self.collectionViewDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.columnHeaders = @[@"", @"Product", @"Price", @"Quantity" ];
    
    self.rows = @[
                  @[@"", @"iPhone 5", @"700.00", @"0" ],
                  @[@"", @"Nexus 4", @"350.00", @"1" ],
                  @[@"", @"Galaxy S4", @"500.00", @"1" ],
                  @[@"", @"HTC One", @"500.00", @"2" ],
                  @[@"", @"iPad 4", @"450.00", @"1" ],
                  @[@"", @"iPad Mini", @"350.00", @"0" ],
                  @[@"", @"Nexus 10", @"350.00", @"1" ],
                  @[@"", @"Nexus 7", @"200.00", @"0" ]
                  ];
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.bounces = NO;
    
    self.collectionViewType = AZCollectionViewTypeColumnHeader;
//    self.collectionViewType = AZCollectionViewTypeRowColumnHeader;
    
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.layer.cornerRadius = 3;
}


#pragma mark - AZCollectionViewDataSource

- (UICollectionViewCell *)collectionViewCellForEmptyItem:(AZFixedGridView *)cv
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:EmptyHeaderCellIdentifier forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    if (lbl == nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 100;
        
        [cell addSubview:lbl];
    }
    
    // label for empty cell
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowColor = [UIColor blackColor];
    lbl.shadowOffset = CGSizeMake(0, 1);
    lbl.font = [UIFont boldSystemFontOfSize:15];
    
    cell.backgroundColor = [UIColor grayColor];
    cell.backgroundColor = [UIColor redColor];
    
    [lbl setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
//    lbl.text = [NSString stringWithFormat:@"Empty Cell"];
    
    cell.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    return cell;
}

- (UICollectionViewCell *)collectionView:(AZFixedGridView *)cv cellForItemAtActualIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NormalCellIdentifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        // adding an image only on first column
        UIImageView *img = (UIImageView *)[cell viewWithTag:200];
        if (img == nil) {
            img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            img.image = [UIImage imageNamed:@"13-plus"];
            img.tag = 200;
            img.contentMode = UIViewContentModeCenter;
            
            [cell addSubview:img];
        }
        
        UILabel *lbl = (UILabel *)[cell viewWithTag:100];
        if (lbl != nil) [lbl removeFromSuperview];
        
    }
    else {
        // adding a label..
        UILabel *lbl = (UILabel *)[cell viewWithTag:100];
        if (lbl == nil) {
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.tag = 100;
            
            [cell addSubview:lbl];
        }
        
        lbl.textColor = [UIColor whiteColor];
        lbl.shadowColor = [UIColor blackColor];
        lbl.shadowOffset = CGSizeMake(0, 1);
        lbl.font = [UIFont systemFontOfSize:15];
        
        [lbl setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        //        NSLog(@"%f, %f, %f, %f", 0.0, 0.0, cell.frame.size.width, cell.frame.size.height);
        
        lbl.text = [NSString stringWithFormat:@"%@", self.rows[indexPath.section][indexPath.item]];
//        lbl.text = [NSString stringWithFormat:@"s %d i %d", indexPath.section, indexPath.item];
        
        UILabel *img = (UILabel *)[cell viewWithTag:200];
        if (img != nil) [img removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    cell.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    return cell;
}

- (UICollectionViewCell *)collectionView:(AZFixedGridView *)cv cellForRowHeaderItemAtIndexPath:(NSUInteger)row
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:RowHeaderCellIdentifier forIndexPath:[NSIndexPath indexPathForItem:0 inSection:row]];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    if (lbl == nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 100;
        
        [cell addSubview:lbl];
    }
    
    // label for row header
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowColor = [UIColor blackColor];
    lbl.shadowOffset = CGSizeMake(0, 1);
    lbl.font = [UIFont boldSystemFontOfSize:15];
    
    cell.backgroundColor = [UIColor grayColor];
    
    [lbl setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    lbl.text = [NSString stringWithFormat:@"%@", self.rowHeaders[row]];
//    lbl.text = [NSString stringWithFormat:@"hr %d", row];
    
    cell.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    return cell;
}

- (UICollectionViewCell *)collectionView:(AZFixedGridView *)cv cellForColumnHeaderItemAtIndexPath:(NSUInteger)column
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:ColumnHeaderCellIdentifier forIndexPath:[NSIndexPath indexPathForItem:column inSection:0]];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    if (lbl == nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 100;
        
        [cell addSubview:lbl];
    }
    
    // label for column header
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowColor = [UIColor blackColor];
    lbl.shadowOffset = CGSizeMake(0, 1);
    lbl.font = [UIFont boldSystemFontOfSize:15];
    
    cell.backgroundColor = [UIColor grayColor];
    
    [lbl setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    lbl.text = [NSString stringWithFormat:@"%@", self.columnHeaders[column]];
//    lbl.text = [NSString stringWithFormat:@"hc %d", column];
    
    cell.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    return cell;
}

- (NSUInteger)collectionViewNumberOfActualRow:(AZFixedGridView *)collectionView
{
    return self.rows.count;
}

- (NSUInteger)collectionViewNumberOfActualColumn:(AZFixedGridView *)collectionView
{
    return ((NSArray *)self.rows[0]).count;
}

- (CGFloat)collectionView:(AZFixedGridView *)collectionView heightForRow:(NSUInteger)row
{
    return 40.0f;
}

- (CGFloat)collectionView:(AZFixedGridView *)collectionView widthForColumn:(NSUInteger)column
{
    if (column == 0) {
        return 60;
    }
    return 130.0f;
}

- (CGFloat)collectionViewHeightForHeaderRow:(AZFixedGridView *)collectionView
{
    return 50.0f;
}

- (CGFloat)collectionViewWidthForHeaderColumn:(AZFixedGridView *)collectionView
{
    return 200.0f;
}

#pragma mark - AZCollectionViewDelegate

- (void)collectionView:(AZFixedGridView *)collectionView didSelectItemAtActualRow:(NSUInteger)row column:(NSUInteger)column
{
    NSLog(@"Selected r %d c %d", row, column);
}

- (void)collectionView:(AZFixedGridView *)collectionView didSelectHeaderAtRow:(NSUInteger)row
{
    NSLog(@"Selected header r %d", row);
}

- (void)collectionView:(AZFixedGridView *)collectionView didSelectHeaderAtColumn:(NSUInteger)column
{
    NSLog(@"Selected header c %d", column);
}

- (void)collectionViewDidSelectEmptyCell:(AZFixedGridView *)collectionView
{
    NSLog(@"Selected Empty cell");
}

@end
