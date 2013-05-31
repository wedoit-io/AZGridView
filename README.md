AZGridView
==========

An implementation of a grid view based on a matrix structure (with a defined number of rows and columns), using native UICollectionView and a custom layout.

Usage
-----

Look at the demo project, or wait for some decent documentation ;)

```objecttive-c

//
//  AZCollectionView.h
//

#import <UIKit/UIKit.h>

@class AZFixedGridView;

typedef enum {
    AZCollectionViewTypeRowColumnHeader,
    AZCollectionViewTypeRowHeader,
    AZCollectionViewTypeColumnHeader,
    AZCollectionViewTypePlain
} AZCollectionViewType;

@protocol AZCollectionViewDataSource <NSObject>

- (UICollectionViewCell *)collectionView:(AZFixedGridView *)cv cellForItemAtActualIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)collectionView:(AZFixedGridView *)collectionView heightForRow:(NSUInteger)row;
- (CGFloat)collectionView:(AZFixedGridView *)collectionView widthForColumn:(NSUInteger)column;

- (NSUInteger)collectionViewNumberOfActualRow:(AZFixedGridView *)collectionView;
- (NSUInteger)collectionViewNumberOfActualColumn:(AZFixedGridView *)collectionView;

@optional

- (UICollectionViewCell *)collectionViewCellForEmptyItem:(AZFixedGridView *)cv;
- (UICollectionViewCell *)collectionView:(AZFixedGridView *)cv cellForRowHeaderItemAtIndexPath:(NSUInteger)row;
- (UICollectionViewCell *)collectionView:(AZFixedGridView *)cv cellForColumnHeaderItemAtIndexPath:(NSUInteger)column;

- (CGFloat)collectionViewHeightForHeaderRow:(AZFixedGridView *)collectionView;
- (CGFloat)collectionViewWidthForHeaderColumn:(AZFixedGridView *)collectionView;

@end

@protocol AZCollectionViewDelegate <NSObject>

- (void)collectionView:(AZFixedGridView *)collectionView didSelectItemAtActualRow:(NSUInteger)row column:(NSUInteger)column;

@optional

- (void)collectionViewDidSelectEmptyCell:(AZFixedGridView *)collectionView;
- (void)collectionView:(AZFixedGridView *)collectionView didSelectHeaderAtRow:(NSUInteger)row;
- (void)collectionView:(AZFixedGridView *)collectionView didSelectHeaderAtColumn:(NSUInteger)column;

@end

@interface AZFixedGridView : UICollectionView

// static method that return the index of rows and columns, in the AZGridView logic
+ (NSUInteger)actualRowIndexForRow:(NSUInteger)row gridType:(AZCollectionViewType)gridType;
+ (NSUInteger)actualColumnIndexForColumn:(NSUInteger)column gridType:(AZCollectionViewType)gridType;

+ (NSUInteger)rowIndexForRow:(NSUInteger)row gridType:(AZCollectionViewType)gridType;
+ (NSUInteger)columnIndexForColumn:(NSUInteger)column gridType:(AZCollectionViewType)gridType;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;

- (id)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end
```

Screenshots
-----------

![Alt text](/Screenshots/iphone.png "iPhone")
![Alt text](/Screenshots/ipad.png "iPad")
