//
//  SectionCardDecorationLayoutAttributes.m
//  IGListKitExamples
//
//  Created by junfeng.li on 2019/1/10.
//  Copyright © 2019 Instagram. All rights reserved.
//

#import "JLSectionCardDecorationLayoutAttributes.h"

@interface JLSectionCardDecorationLayoutAttributes ()


@end

@implementation JLSectionCardDecorationLayoutAttributes

- (id)copyWithZone:(nullable NSZone *)zone {
    JLSectionCardDecorationLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.backgroundColor = self.backgroundColor;
    attributes.cornerRadius = self.cornerRadius;
    return attributes;
}

- (BOOL)isEqual:(id)object {
    JLSectionCardDecorationLayoutAttributes *attributes = (JLSectionCardDecorationLayoutAttributes *)object;
    
    if (!attributes) {
        return NO;
    }
    
    if (![self.backgroundColor isEqual:attributes.backgroundColor]) {
        return NO;
    }
    
    if (self.cornerRadius != attributes.cornerRadius) {
        return NO;
    }
    
    return [super isEqual:attributes];
}

@end
