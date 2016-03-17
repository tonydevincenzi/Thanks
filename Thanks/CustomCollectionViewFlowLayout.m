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
    self.itemSize = CGSizeMake(305.0, 407.0);
    self.minimumInteritemSpacing = 20.0;
    self.minimumLineSpacing = 10.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 35.0, 0.0, 35.0);
}


//Enable pagination for cells
- (CGFloat)pageWidth {
    return self.itemSize.width + self.minimumLineSpacing;
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
    
    return proposedContentOffset;
}

- (CGFloat)flickVelocity {
    return 0.3;
}



@end
