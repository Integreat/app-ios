//
//  IGLanguagePickerVC.m
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import "IGLanguagePickerVC.h"
#import "IGCustomCollectionViewCell.h"
#import "IGPagesListVC.h"
@interface IGLanguagePickerVC ()
@property (strong, nonatomic, nonnull) NSArray<Language *> *languages;
@end

@implementation IGLanguagePickerVC

static NSString * const reuseIdentifier = @"Cell";

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.languages = @[];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    typeof(self) weakSelf = self;
    [self.apiService fetchLanguagesForLocation:self.selectedLocation withCompletionHandler:^(NSArray<Language *> * _Nullable languages, NSError * _Nullable error) {
        weakSelf.languages = languages;
        [weakSelf.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"pagesSeg"])
    {
        // Get reference to the destination view controller
        IGPagesListVC *vc = [segue destinationViewController];
        IGCustomCollectionViewCell* selectedCell=(IGCustomCollectionViewCell*)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:selectedCell];
        vc.selectedLocation= self.selectedLocation;
        vc.selectedLanguage= self.languages[indexPath.item];
        vc.apiService = self.apiService;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.languages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IGCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Language *language = self.languages[indexPath.row];
    
    cell.cellTitle.text=[language nativeName];
    
    [language getImageWithCompletionHandler:^(UIImage * _Nonnull image) {
        cell.cellImage.image = image;
    }];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat dimens = collectionView.bounds.size.width * 0.4;
    return CGSizeMake(dimens, dimens);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
