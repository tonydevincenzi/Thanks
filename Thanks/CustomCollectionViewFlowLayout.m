//
//  CustomCollectionViewFlowLayout.m
//  CollectionViewDemo
//
//  Created by Jan Senderek on 3/16/16.
//  Copyright © 2016 Jan Senderek. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout


//Manually set cell attributes
- (void)awakeFromNib
{
    self.itemSize = CGSizeMake(330.0, 438.0);
    self.itemSize = CGSizeMake(360, 438.0);
//    self.estimatedItemSize = CGSizeMake(330.0, 438.0);
    self.minimumInteritemSpacing = 25.0;
    self.minimumLineSpacing = 10.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


//Enable pagination for cells
- (CGFloat)pageWidth {
    // 330 x 438 for iPhone 6
    CGFloat aspectRatio = 330.0 / 438;
    
    CGFloat width = self.collectionView.frame.size.width * 0.87;
    CGFloat height = width / aspectRatio;
    
    CGSize size = CGSizeMake(width, height);
    
    return size.width + self.minimumLineSpacing;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat rawPageValue = self.collectionView.contentOffset.x / self.pageWidth;
    CGFloat currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.x = nextPage * self.pageWidth;
    } else {
        proposedContentOffset.x = round(rawPageValue) * self.pageWidth;
    }
    
    NSLog(@"Proposed content offset: %@", NSStringFromCGPoint(proposedContentOffset));
    
    return proposedContentOffset;
}

- (CGFloat)flickVelocity {
    return 0.3;
}



@end
