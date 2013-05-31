//
//  AZMyFirstLayout.m
//  CollectionTest
//
//  Created by Alessandro Zoffoli on 21/05/13.
//  Copyright (c) 2013 Apexnet. All rights reserved.
//

#import "AZFixedGridLayout.h"

static NSString * const NormalCell = @"Cell";

@interface AZFixedGridLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

// number of actual rows (rows + header row)
@property (nonatomic, assign) NSUInteger rows;

// number of actual columns (columns + header column)
@property (nonatomic, assign) NSUInteger columns;

@property (nonatomic, strong) NSMutableArray *widths;
@property (nonatomic, strong) NSMutableArray *heigths;

@end

@implementation AZFixedGridLayout

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.rows = 0;
    self.heigths = [[NSMutableArray alloc] init];
    
    self.columns = 0;
    self.widths =  [[NSMutableArray alloc] init];
    
    self.collectionViewType = AZCollectionViewTypePlain;
}

#pragma mark - Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    self.rows = self.collectionView.numberOfSections;
    self.columns = [self.collectionView numberOfItemsInSection:0];
    
    for (NSUInteger row = 0; row < self.rows; row++) {
        
        for (NSUInteger column = 0; column < self.columns; column++) {
            indexPath = [NSIndexPath indexPathForItem:column inSection:row];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForNormalCellAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }

    newLayoutInfo[NormalCell] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (CGSize)collectionViewContentSize
{
    CGFloat width = [[self.widths valueForKeyPath:@"@sum.self"] floatValue];
    CGFloat height = [[self.heigths valueForKeyPath:@"@sum.self"] floatValue];
    
//    NSLog(@"content size: w %f h %f", self.collectionView.bounds.size.width, height);
    return CGSizeMake(width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[NormalCell][indexPath];
}

- (void)refreshLayout
{
    [self invalidateLayout];
}

#pragma mark - Properties

- (void)setCollectionViewType:(AZCollectionViewType)collectionViewType
{
    if (_collectionViewType == collectionViewType) return;
    
    _collectionViewType = collectionViewType;
    
    [self invalidateLayout];
}

#pragma mark - Private

- (CGRect)frameForNormalCellAtIndexPath:(NSIndexPath *)indexPath
{    
    NSUInteger row = indexPath.section;
    NSUInteger column = indexPath.item;
    
    NSArray *subWidths = [self.widths subarrayWithRange:NSMakeRange(0, column)];
    NSArray *subHeights = [self.heigths subarrayWithRange:NSMakeRange(0, row)];
    
    CGFloat originX = [[subWidths valueForKeyPath:@"@sum.self"] floatValue];
    CGFloat originY = [[subHeights valueForKeyPath:@"@sum.self"] floatValue];
    
    // request width,height only if necessary (every column/row has the same width/height)
    CGFloat width = 0;
    if (column == self.widths.count) {
        width = [self.dataSource collectionView:((AZFixedGridView *)self.collectionView) layout:self widthForColumn:column];
//        NSLog(@"col %d w %f", column, width);
        [self.widths addObject:@(width)];
    }
    else {
        width = [self.widths[indexPath.item] floatValue];
    }
    
    CGFloat height = 0;
    if (row == self.heigths.count) {
        height = [self.dataSource collectionView:((AZFixedGridView *)self.collectionView) layout:self heightForRow:row];
//        NSLog(@"row %d h %f", row, height);
        [self.heigths addObject:@(height)];
    }
    else {
        height = [self.heigths[indexPath.section] floatValue];
    }
        
//    NSLog(@"Cell %d %d origin %f %f size %f %f", row, column, originX, originY, [self.widths[indexPath.item] floatValue], [self.heigths[indexPath.section] floatValue]);
    
    return CGRectMake(originX, originY, [self.widths[indexPath.item] floatValue], [self.heigths[indexPath.section] floatValue]);
}

@end
