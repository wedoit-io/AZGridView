//
//  AZCollectionViewController.m
//  CollectionTest
//
//  Created by Alessandro Zoffoli on 21/05/13.
//  Copyright (c) 2013 Apexnet. All rights reserved.
//

#import "AZFixedGridViewController.h"

#import "AZFixedGridView.h"
#import "AZFixedGridLayout.h"

@interface AZFixedGridViewController () <AZCollectionViewDelegateFixedGridLayout>

@property (nonatomic, strong) AZFixedGridLayout *layout;

@end

@implementation AZFixedGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
            
    // layout
    self.layout = [[AZFixedGridLayout alloc] init];
    self.layout.dataSource = self;
    self.collectionView.collectionViewLayout = self.layout;
}

#pragma  mark - Properties

- (void)setCollectionViewType:(AZCollectionViewType)collectionViewType{
    if (self.layout.collectionViewType != collectionViewType) {
        _collectionViewType = collectionViewType;
        self.layout.collectionViewType = _collectionViewType;
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewNumberOfActualColumn:)];
    NSInteger columns = [AZFixedGridView actualColumnIndexForColumn:[self.collectionViewDataSource collectionViewNumberOfActualColumn:((AZFixedGridView *)self.collectionView)] gridType:self.layout.collectionViewType];
    return columns;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{   
    [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewNumberOfActualRow:)];
    NSInteger sections = [AZFixedGridView actualColumnIndexForColumn:[self.collectionViewDataSource collectionViewNumberOfActualRow:((AZFixedGridView *)self.collectionView)] gridType:self.layout.collectionViewType];
    return sections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int rowIndex = indexPath.section;
    int columnIndex = indexPath.item;
    
    int actualRow = [AZFixedGridView actualRowIndexForRow:rowIndex gridType:self.layout.collectionViewType];
    int actualColumn = [AZFixedGridView actualColumnIndexForColumn:columnIndex gridType:self.layout.collectionViewType];
        
    switch (self.layout.collectionViewType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            if (rowIndex == 0 && columnIndex == 0) {
                // header empty cell
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewCellForEmptyItem:)];
                return [self.collectionViewDataSource collectionViewCellForEmptyItem:((AZFixedGridView *)self.collectionView)];
            }
            else if (rowIndex == 0 && columnIndex != 0) {
                // column header
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForColumnHeaderItemAtIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForColumnHeaderItemAtIndexPath:actualColumn];
            }
            else if (rowIndex != 0 && columnIndex == 0) {
                // row header
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForRowHeaderItemAtIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForRowHeaderItemAtIndexPath:actualRow];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForItemAtActualIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForItemAtActualIndexPath:[NSIndexPath indexPathForItem:actualColumn inSection:actualRow]];
            }
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            
            if (columnIndex == 0) {
                // row header
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForRowHeaderItemAtIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForRowHeaderItemAtIndexPath:actualRow];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForItemAtActualIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForItemAtActualIndexPath:[NSIndexPath indexPathForItem:actualColumn inSection:actualRow]];
            }
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            
            if (rowIndex == 0) {
                // column header
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForColumnHeaderItemAtIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForColumnHeaderItemAtIndexPath:actualColumn];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForItemAtActualIndexPath:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForItemAtActualIndexPath:[NSIndexPath indexPathForItem:actualColumn inSection:actualRow]];
            }
            break;
        }
        case AZCollectionViewTypePlain:
        {
            [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:cellForItemAtActualIndexPath:)];
            return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) cellForItemAtActualIndexPath:[NSIndexPath indexPathForItem:actualColumn inSection:actualRow]];
            
            break;
        }
        default:
            break;
    }
        
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(AZFixedGridView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionViewDelegate != nil) {
        
        int rowIndex = indexPath.section;
        int columnIndex = indexPath.item;
        
        int actualRow = [AZFixedGridView actualRowIndexForRow:indexPath.section gridType:self.collectionViewType];
        int actualColumn = [AZFixedGridView actualColumnIndexForColumn:indexPath.item gridType:self.collectionViewType];
        
        switch (self.layout.collectionViewType) {
            case AZCollectionViewTypeRowColumnHeader:
            {
                if (rowIndex == 0 && columnIndex == 0) {
                    // header empty cell
                    [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewDidSelectEmptyCell:)];
                    return [self.collectionViewDelegate collectionViewDidSelectEmptyCell:((AZFixedGridView *)self.collectionView)];
                }
                else if (rowIndex == 0 && columnIndex != 0) {
                    // column header
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectHeaderAtColumn:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectHeaderAtColumn:actualColumn];
                }
                else if (rowIndex != 0 && columnIndex == 0) {
                    // row header
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectHeaderAtRow:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectHeaderAtRow:actualRow];
                }
                else{
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectItemAtActualRow:column:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectItemAtActualRow:actualRow column:actualColumn];
                }
                break;
            }
            case AZCollectionViewTypeRowHeader:
            {
                if (columnIndex == 0) {
                    // row header
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectHeaderAtRow:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectHeaderAtRow:actualRow];
                }
                else{
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectItemAtActualRow:column:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectItemAtActualRow:actualRow column:actualColumn];
                }
                break;
            }
            case AZCollectionViewTypeColumnHeader:
            {
                if (rowIndex == 0) {
                    // column header
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectItemAtActualRow:column:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectHeaderAtColumn:actualColumn];
                }
                else{
                    [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectItemAtActualRow:column:)];
                    [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectItemAtActualRow:actualRow column:actualColumn];
                }
                break;
            }
            case AZCollectionViewTypePlain:
            {
                [self assertObject:self.collectionViewDelegate respondToSelector:@selector(collectionView:didSelectItemAtActualRow:column:)];
                [self.collectionViewDelegate collectionView:((AZFixedGridView *)self.collectionView) didSelectItemAtActualRow:actualRow column:actualColumn];
                
                break;
            }
            default:
                break;
        }
    }
}

- (void)collectionView:(AZFixedGridView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - AZCollectionViewDelegateFixedGridLayout

- (CGFloat)collectionView:(AZFixedGridView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForRow:(NSUInteger)row
{
    int actualRow = [AZFixedGridView actualRowIndexForRow:row gridType:self.layout.collectionViewType];
    switch (self.layout.collectionViewType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            if (row == 0) {
                // height for header row
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewHeightForHeaderRow:)];
                return [self.collectionViewDataSource collectionViewHeightForHeaderRow:((AZFixedGridView *)self.collectionView)];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:heightForRow:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) heightForRow:actualRow];
            }
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:heightForRow:)];
            return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) heightForRow:actualRow];
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            
            if (row == 0) {
                // height for header row
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewHeightForHeaderRow:)];
                return [self.collectionViewDataSource collectionViewHeightForHeaderRow:((AZFixedGridView *)self.collectionView)];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:heightForRow:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) heightForRow:actualRow];
            }
            break;
        }
        case AZCollectionViewTypePlain:
        {
            [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:heightForRow:)];
            return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) heightForRow:actualRow];
            break;
        }
        default:
            break;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(AZFixedGridView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout widthForColumn:(NSUInteger)column
{
    int actualColumn = [AZFixedGridView actualColumnIndexForColumn:column gridType:self.layout.collectionViewType];
    switch (self.layout.collectionViewType) {
        case AZCollectionViewTypeRowColumnHeader:
        {
            if (column == 0) {
                // width for header column
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewWidthForHeaderColumn:)];
                return [self.collectionViewDataSource collectionViewWidthForHeaderColumn:((AZFixedGridView *)self.collectionView)];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:widthForColumn:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) widthForColumn:actualColumn];
            }
            break;
        }
        case AZCollectionViewTypeRowHeader:
        {
            if (column == 0) {
                // width for header column
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionViewWidthForHeaderColumn:)];
                return [self.collectionViewDataSource collectionViewWidthForHeaderColumn:((AZFixedGridView *)self.collectionView)];
            }
            else{
                [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:widthForColumn:)];
                return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) widthForColumn:actualColumn];
            }
            break;
        }
        case AZCollectionViewTypeColumnHeader:
        {
            [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:widthForColumn:)];
            return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) widthForColumn:actualColumn];
            break;
        }
        case AZCollectionViewTypePlain:
        {
            [self assertObject:self.collectionViewDataSource respondToSelector:@selector(collectionView:widthForColumn:)];
            return [self.collectionViewDataSource collectionView:((AZFixedGridView *)self.collectionView) widthForColumn:actualColumn];
            break;
        }
        default:
            break;
    }
    
    return 0.0f;
}

#pragma mark - NSAssert utility

- (void)assertObject:(NSObject *)obj respondToSelector:(SEL)selector
{
    BOOL cond = [obj respondsToSelector:selector];
    NSAssert( cond, ([NSString stringWithFormat:@"Class %@ must respond to selector %@",NSStringFromClass([obj class]),NSStringFromSelector(selector)]));
}

@end
