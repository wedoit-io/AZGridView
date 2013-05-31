//
//  AZMyFirstLayout.h
//  CollectionTest
//
//  Created by Alessandro Zoffoli on 21/05/13.
//  Copyright (c) 2013 Apexnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZFixedGridViewController.h"
#import "AZFixedGridView.h"

@class AZFixedGridViewController;

@protocol AZCollectionViewDelegateFixedGridLayout <NSObject>

- (CGFloat)collectionView:(AZFixedGridView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForRow:(NSUInteger)row;
- (CGFloat)collectionView:(AZFixedGridView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout widthForColumn:(NSUInteger)column;

@optional

@end

@interface AZFixedGridLayout : UICollectionViewLayout

@property (nonatomic) AZCollectionViewType collectionViewType;
@property (nonatomic, weak) id<AZCollectionViewDelegateFixedGridLayout> dataSource;

- (void)refreshLayout;

@end
