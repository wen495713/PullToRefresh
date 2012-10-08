//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
@interface PullRefreshHeaderView : UIView{
    UILabel *textLabel;
    UIImageView *arrow;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic, retain) NSString *normalText;
@property (nonatomic, retain) NSString *releaseText;
@property (nonatomic, retain) NSString *loadingText;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImage *arrowImage;
@property (nonatomic, assign) BOOL loading;
- (void)turnArrowUp:(BOOL)animate;
- (void)turnArrowDown:(BOOL)animate;
@end


@interface PullRefreshTableViewController : UITableViewController {
    
    BOOL isDragging;
    BOOL isLoading;
    PullRefreshHeaderView *header;
    PullRefreshHeaderView *footer;
//    UIView *refreshHeaderView;
//    UILabel *refreshLabel;
//    UIImageView *refreshArrow;
//    UIActivityIndicatorView *refreshSpinner;
//    NSString *textPull;
//    NSString *textRelease;
//    NSString *textLoading;
}

//@property (nonatomic, retain) UIView *refreshHeaderView;
//@property (nonatomic, retain) UILabel *refreshLabel;
//@property (nonatomic, retain) UIImageView *refreshArrow;
//@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
//@property (nonatomic, copy) NSString *textPull;
//@property (nonatomic, copy) NSString *textRelease;
//@property (nonatomic, copy) NSString *textLoading;

//- (void)setupStrings;
//- (void)addPullToRefreshHeader;
//- (void)startLoading;
//- (void)stopLoading;
//- (void)refresh;
//- (void)getMore;

- (void)headerReflash;//重载方法
- (void)footerForMore;//重载方法
- (void)stopHeaderLoading;//下拉刷新停止方法
@end
