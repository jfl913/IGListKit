//
//  SectionCardDecorationLayout.m
//  IGListKitExamples
//
//  Created by junfeng.li on 2019/1/10.
//  Copyright © 2019 Instagram. All rights reserved.
//

#import "JLSectionCardDecorationLayout.h"
#import "JLSectionCardDecorationReusableView.h"
#import "JLSectionCardDecorationLayoutAttributes.h"

static NSString * const kDecorationViewKind = @"SectionCardDecorationReusableView";

@interface JLSectionCardDecorationLayout ()

@property (nonatomic, strong) NSMutableDictionary *cardDecorationViewAttributeDict;

@end

@implementation JLSectionCardDecorationLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.cardDecorationViewAttributeDict = @{}.mutableCopy;
    
    [self registerClass:[JLSectionCardDecorationReusableView class] forDecorationViewOfKind:kDecorationViewKind];
    
    self.displayDecorationView = NO;
    self.decorationColor = [UIColor clearColor];
    self.decorationInset = UIEdgeInsetsZero;
    self.decorationCornerRadius = 0.0;
}

+ (Class)layoutAttributesClass {
    return [JLSectionCardDecorationLayoutAttributes class];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    
    if (!numberOfSections) {
        return;
    }
    
    [self.cardDecorationViewAttributeDict removeAllObjects];
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        BOOL displayDecorationView = [self displayDecorationViewAtSection:section];
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0 && displayDecorationView) {
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section];
            UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
            UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:lastIndexPath];
            
            // 获取该 section 的内边距。
            UIEdgeInsets sectionInset = [self sectionInsetAtSection:section];
            // 计算得到该 section 实际的位置。
            CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.origin.x -= sectionInset.left;
                sectionFrame.origin.y = 0;
                sectionFrame.size.width += (sectionInset.left + sectionInset.right);
                sectionFrame.size.height = self.collectionView.frame.size.height;
            }
            else {
                sectionFrame.origin.x = 0;
                sectionFrame.origin.y -= sectionInset.top;
                sectionFrame.size.width = self.collectionView.frame.size.width;
                sectionFrame.size.height += (sectionInset.top + sectionInset.bottom);
            }
            
            UIEdgeInsets decorationInset = [self decorationInsetAtSection:section];
            CGRect decorationFrame = sectionFrame;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                decorationFrame.origin.x += decorationInset.left;
                decorationFrame.origin.y = decorationInset.top;
            }
            else {
                decorationFrame.origin.x = decorationInset.left;
                decorationFrame.origin.y += decorationInset.top;
            }
            decorationFrame.size.width -= (decorationInset.left + decorationInset.right);
            decorationFrame.size.height -= (decorationInset.top + decorationInset.bottom);
            
            
            JLSectionCardDecorationLayoutAttributes *attributes = [JLSectionCardDecorationLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationViewKind withIndexPath:firstIndexPath];
            attributes.frame = decorationFrame;
            attributes.zIndex = -1;
            attributes.backgroundColor = [self decorationColorAtSection:section];
            attributes.cornerRadius = [self decorationCornerRadiusAtSection:section];
            
            self.cardDecorationViewAttributeDict[@(section)] = attributes;
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    for (UICollectionViewLayoutAttributes *attributes in self.cardDecorationViewAttributeDict.allValues) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if ([elementKind isEqualToString:kDecorationViewKind]) {
        return self.cardDecorationViewAttributeDict[@(section)];
    }
    else {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }
}

#pragma mark - Private Method

- (UIEdgeInsets)sectionInsetAtSection:(NSInteger)section {
    UIEdgeInsets sectionInset = self.sectionInset;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateFlowLayout> flowLayout = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        sectionInset = [flowLayout collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return sectionInset;
}

- (BOOL)displayDecorationViewAtSection:(NSInteger)section {
    BOOL displayDecorationView = self.displayDecorationView;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:decorationDisplayedForSection:)]) {
        id<JLSectionCardDecorationLayoutDelegate> decorationDelegate = (id<JLSectionCardDecorationLayoutDelegate>)self.collectionView.delegate;
        displayDecorationView = [decorationDelegate collectionView:self.collectionView layout:self decorationDisplayedForSection:section];
    }
    return displayDecorationView;
}

- (UIColor *)decorationColorAtSection:(NSInteger)section {
    UIColor *decorationColor = self.decorationColor;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:decorationColorForSection:)]) {
        id<JLSectionCardDecorationLayoutDelegate> decorationDelegate = (id<JLSectionCardDecorationLayoutDelegate>)self.collectionView.delegate;
        decorationColor = [decorationDelegate collectionView:self.collectionView layout:self decorationColorForSection:section];
    }
    return decorationColor;
}

- (UIEdgeInsets)decorationInsetAtSection:(NSInteger)section {
    UIEdgeInsets decorationInset = self.decorationInset;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:decorationInsetForSection:)]) {
        id<JLSectionCardDecorationLayoutDelegate> decorationDelegate = (id<JLSectionCardDecorationLayoutDelegate>)self.collectionView.delegate;
        decorationInset = [decorationDelegate collectionView:self.collectionView layout:self decorationInsetForSection:section];
    }
    return decorationInset;
}

- (CGFloat)decorationCornerRadiusAtSection:(NSInteger)section {
    CGFloat decorationCornerRadius = self.decorationCornerRadius;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:decorationCornerRadiusForSection:)]) {
        id<JLSectionCardDecorationLayoutDelegate> decorationDelegate = (id<JLSectionCardDecorationLayoutDelegate>)self.collectionView.delegate;
        decorationCornerRadius = [decorationDelegate collectionView:self.collectionView layout:self decorationCornerRadiusForSection:section];
    }
    return decorationCornerRadius;
}

#pragma mark - Accessor

- (void)setDisplayDecorationView:(BOOL)displayDecorationView {
    _displayDecorationView = displayDecorationView;
    [self invalidateLayout];
}

- (void)setDecorationColor:(UIColor *)decorationColor {
    _decorationColor = decorationColor;
    [self invalidateLayout];
}

- (void)setDecorationInset:(UIEdgeInsets)decorationInset {
    _decorationInset = decorationInset;
    [self invalidateLayout];
}

- (void)setDecorationCornerRadius:(CGFloat)decorationCornerRadius {
    _decorationCornerRadius = decorationCornerRadius;
    [self invalidateLayout];
}

@end
