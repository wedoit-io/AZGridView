//
//  AZCollectionViewController.h
//  CollectionTest
//
//  Created by Alessandro Zoffoli on 21/05/13.
//  Copyright (c) 2013 Apexnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AZFixedGridView.h"

@interface AZFixedGridViewController : UICollectionViewController

@property (nonatomic, weak) id<AZCollectionViewDataSource> collectionViewDataSource;
@property (nonatomic, weak) id<AZCollectionViewDelegate> collectionViewDelegate;

@property (nonatomic, assign) AZCollectionViewType collectionViewType;

@end
