//
//  SectionCardDecorationReusableView.m
//  IGListKitExamples
//
//  Created by junfeng.li on 2019/1/10.
//  Copyright © 2019 Instagram. All rights reserved.
//

#import "JLSectionCardDecorationReusableView.h"
#import "JLSectionCardDecorationLayoutAttributes.h"

@implementation JLSectionCardDecorationReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[JLSectionCardDecorationLayoutAttributes class]]) {
        JLSectionCardDecorationLayoutAttributes *attributes = (JLSectionCardDecorationLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attributes.backgroundColor;
        self.layer.cornerRadius = attributes.cornerRadius;
        self.layer.masksToBounds = YES;
    }
}

@end
