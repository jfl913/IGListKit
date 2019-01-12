//
//  SectionCardDecorationLayout.h
//  IGListKitExamples
//
//  Created by junfeng.li on 2019/1/10.
//  Copyright © 2019 Instagram. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JLSectionCardDecorationLayout;

@protocol JLSectionCardDecorationLayoutDelegate <UICollectionViewDelegateFlowLayout>

// 指定 section 是否显示卡片装饰图，默认值为 NO.
- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(JLSectionCardDecorationLayout *)layout
decorationDisplayedForSection:(NSInteger)section;

// 指定 section 卡片装饰图颜色，默认为白色。
- (UIColor *)collectionView:(UICollectionView *)collectionView
                     layout:(JLSectionCardDecorationLayout *)layout
  decorationColorForSection:(NSInteger)section;

// 指定 section 卡片装饰图间距。
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(JLSectionCardDecorationLayout *)layout
     decorationInsetForSection:(NSInteger)section;

// 指定 section 卡片装饰图圆角弧度。
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(JLSectionCardDecorationLayout *)layout
decorationCornerRadiusForSection:(NSInteger)section;

@end

@interface JLSectionCardDecorationLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL displayDecorationView;
@property (nonatomic, strong) UIColor *decorationColor;
@property (nonatomic, assign) UIEdgeInsets decorationInset;
@property (nonatomic, assign) CGFloat decorationCornerRadius;

@end

NS_ASSUME_NONNULL_END
