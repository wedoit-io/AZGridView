//
//  AZCollectionView.m
//  CollectionTest
//
//  Created by Alessandro Zoffoli on 30/05/13.
//  Copyright (c) 2013 Apexnet. All rights reserved.
//

#import "AZFixedGridView.h"
#import "AZFixedGridLayout.h"

@implementation AZFixedGridView

#pragma mark - Class methods

/*
 * returns the actual row index, in the AZGridView logic
 */
+ (NSUInteger)actualRowIndexForRow:(NSUInteger)row gridType:(AZCollectionViewType)gridType
{
    int rowIndex = NSNotFound;
    switch (gridType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            rowIndex = row - 1;
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            rowIndex = row;
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            rowIndex = row - 1;
            break;
        }
        case AZCollectionViewTypePlain:
        {
            rowIndex = row;
            break;
        }
        default:
            break;
    }
    return rowIndex;
}

/*
 * returns the actual column index, in the AZGridView logic
 */
+ (NSUInteger)actualColumnIndexForColumn:(NSUInteger)column gridType:(AZCollectionViewType)gridType
{
    int columnIndex = NSNotFound;
    switch (gridType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            columnIndex = column - 1;
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            columnIndex = column - 1;
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            columnIndex = column;
            break;
        }
        case AZCollectionViewTypePlain:
        {
            columnIndex = column;
            break;
        }
        default:
            break;
    }
    return columnIndex;
}

/*
 * returns the original row index, in the UICollectionView logic
 */
+ (NSUInteger)rowIndexForRow:(NSUInteger)row gridType:(AZCollectionViewType)gridType
{
    int rowIndex = NSNotFound;
    switch (gridType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            rowIndex = row + 1;
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            rowIndex = row;
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            rowIndex = row + 1;
            break;
        }
        case AZCollectionViewTypePlain:
        {
            rowIndex = row;
            break;
        }
        default:
            break;
    }
    return rowIndex;
}

/*
 * returns the original column index, in the UICollectionView logic
 */
+ (NSUInteger)columnIndexForColumn:(NSUInteger)column gridType:(AZCollectionViewType)gridType
{
    int columnIndex = NSNotFound;
    switch (gridType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            columnIndex = column + 1;
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            columnIndex = column + 1;
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            columnIndex = column;
            break;
        }
        case AZCollectionViewTypePlain:
        {
            columnIndex = column;
            break;
        }
        default:
            break;
    }
    return columnIndex;
}

#pragma mark - Dequeuing methods

/*
 * Overriding dequeue methods to adjudst index path accordingly to collection view type
 */
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath
{
    AZCollectionViewType type = ((AZFixedGridLayout *)self.collectionViewLayout).collectionViewType;
    indexPath = [NSIndexPath indexPathForItem:[AZFixedGridView columnIndexForColumn:indexPath.item gridType:type]
                                    inSection:[AZFixedGridView rowIndexForRow:indexPath.section gridType:type]];
    return [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (id)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    AZCollectionViewType type = ((AZFixedGridLayout *)self.collectionViewLayout).collectionViewType;
    indexPath = [NSIndexPath indexPathForItem:[AZFixedGridView columnIndexForColumn:indexPath.item gridType:type]
                                    inSection:[AZFixedGridView rowIndexForRow:indexPath.section gridType:type]];
    return [super dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:indexPath];
}

@end
