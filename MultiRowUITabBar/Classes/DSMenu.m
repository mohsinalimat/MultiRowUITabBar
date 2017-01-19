//
//  MRMenu.m
//
//  Created by Srinivasan Dodda on 15/03/16.
//

#import "DSMenu.h"
#import "DSMenuItem.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface DSMenu()

@property int columns;
@property int menuItemHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMenuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCloseWidth;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;

-(IBAction)clickedOut:(id)sender;
-(IBAction)closeMenu:(id)sender;

@end

@implementation DSMenu

#pragma mark - UI utils
-(void)updateShadow{
    self.constraintCloseWidth.constant = SCREEN_WIDTH/(float)self.columns;
    self.viewShadow.layer.shadowColor = [UIColor grayColor].CGColor;
    self.viewShadow.layer.shadowOffset = CGSizeMake(0, -3);
    self.viewShadow.layer.shadowOpacity = 0.5;
    self.viewShadow.layer.shadowRadius = 1.0;
}

-(void)setColumns:(int)columns{
    _columns = columns;
    self.constraintMenuHeight.constant = (([_delegate numberOfMenuItems]+1)/columns)*_menuItemHeight;
}

-(void)setMenuItemHeight:(int)height{
    _menuItemHeight = height;
    self.constraintMenuHeight.constant = (([_delegate numberOfMenuItems]+1)/_columns)*height;
}

#pragma mark - Click Handlers
- (IBAction)clickedOut:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(hideMenu)]){
        [self.delegate hideMenu];
    }
}

- (IBAction)closeMenu:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(hideMenu)]){
        [self.delegate hideMenu];
    }
}

#pragma mark - UICollectionView methods.

-(void)reloadData{
    [self.menuCollectionView reloadData];
}

-(void)registerNib:(UINib *)nib withReuseIdentifier:(NSString *)reuseIdentifier{
    [self.menuCollectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self updateShadow];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_delegate numberOfMenuItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSMenuItem *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSMenuItem" forIndexPath:indexPath];
    [_delegate setMenuItem:menuCell forIndex:indexPath.row];
    return menuCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectTab:)]){
        [self.delegate selectTab:(int)indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat menuItemWidth = [[UIScreen mainScreen] bounds].size.width/(float)self.columns;
    return CGSizeMake(menuItemWidth, self.menuItemHeight);
}

@end
