/**
 Copyright (c) Facebook, Inc. and its affiliates.

 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "PostSectionController.h"

#import "Post.h"
#import "PhotoCell.h"
#import "InteractiveCell.h"
#import "CommentCell.h"
#import "UserInfoCell.h"

static NSInteger cellsBeforeComments = 3;

@interface PostSectionController ()

@property (nonatomic, assign) BOOL expanded;

@end

@implementation PostSectionController {
    Post *_post;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

#pragma mark - IGListSectionController Overrides

- (NSInteger)numberOfItems {
    if (self.expanded) {
        return cellsBeforeComments + _post.comments.count;
    }
    else {
        return cellsBeforeComments;
    }
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    const CGFloat width = self.collectionContext.containerSize.width - (self.inset.left + self.inset.right);
    CGFloat height;
    if (index == 0 || index == 2) {
        height = 41.0;
    } else if (index == 1) {
        height = width; // square
    } else {
        height = 25.0;
    }
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass;
    if (index == 0) {
        cellClass = [UserInfoCell class];
    } else if (index == 1) {
        cellClass = [PhotoCell class];
    } else if (index == 2) {
        cellClass = [InteractiveCell class];
    } else {
        cellClass = [CommentCell class];
    }
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    if ([cell isKindOfClass:[CommentCell class]]) {
        [(CommentCell *)cell setComment:_post.comments[index - cellsBeforeComments]];
    } else if ([cell isKindOfClass:[UserInfoCell class]]) {
        [(UserInfoCell *)cell setName:_post.username];
    }
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _post = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    if (index == 2) {
        self.expanded = !self.expanded;
        
        [self.collectionContext performBatchAnimated:YES updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
            [batchContext reloadSectionController:self];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
