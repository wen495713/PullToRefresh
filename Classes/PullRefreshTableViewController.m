//
//  PullRefreshTableViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f



@implementation PullRefreshHeaderView
@synthesize loading = _loading;
- (id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor darkGrayColor];
        
        self.normalText = @"下拉刷新";
        self.releaseText = @"释放刷新";
        self.loadingText = @"下载中,请稍后";
        
        arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        arrow.center = CGPointMake(arrow.center.x+arrow.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:arrow];
        [arrow release];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(arrow.frame.size.width, 0, self.frame.size.width-2*arrow.frame.size.width, self.frame.size.height)];
        textLabel.text = self.normalText;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:12.0f];
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.text = self.normalText;
        [self addSubview:textLabel];
        [textLabel release];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = arrow.center;
        [spinner setHidesWhenStopped:YES];
        [spinner stopAnimating];
        [self addSubview:spinner];
        [spinner release];
    }
    return self;
}

- (void)setLoading:(BOOL)loading{
    _loading = loading;
    _loading?[spinner startAnimating]:[spinner stopAnimating];
    arrow.hidden = _loading;
    textLabel.text = _loading?self.loadingText:self.normalText;
}

- (void)turnArrowUp:(BOOL)animate{
    textLabel.text = self.normalText;
    if (animate) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             arrow.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                         }];
    }else{
        arrow.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
}

- (void)turnArrowDown:(BOOL)animate{
    textLabel.text = self.releaseText;
    if (animate) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             arrow.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                         }];
    }else{
        arrow.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
}

@end

@implementation PullRefreshTableViewController

- (void)addPullToRefreshHeader{
    header = [[PullRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    [self.tableView addSubview:header];
    [header release];
    [header turnArrowUp:YES];
}

- (void)addPullForMoreFooter{
    footer = [[PullRefreshHeaderView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, 320, REFRESH_HEADER_HEIGHT)];
    footer.normalText = @"释放获取更多";
    footer.releaseText = @"上拉获取更多";
    [self.tableView addSubview:footer];
    [footer release];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addPullToRefreshHeader];
    [self addPullForMoreFooter];
}

- (void)stopHeaderLoading{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
    }];
    isLoading = NO;
    header.loading = NO;
    [header turnArrowUp:YES];
    [self reSetFooterLocation];
}

- (void)stopFooterLoading{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
    }];
    isLoading = NO;
    footer.loading = NO;
    [footer turnArrowDown:YES];
    [self reSetFooterLocation];
}

- (void)reSetFooterLocation{
    CGRect rct = footer.frame;
    rct.origin.y = self.tableView.contentSize.height;
    footer.frame = rct;
}

- (void)headerReflash{
    [self performSelector:@selector(stopHeaderLoading) withObject:nil afterDelay:2.0];//此处作测试用
}

- (void)footerForMore{
    [self performSelector:@selector(stopFooterLoading) withObject:nil afterDelay:2.0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isLoading) {
        
    }else if (isDragging && scrollView.contentOffset.y < 0){
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            [header turnArrowDown:YES];
        }else{
            [header turnArrowUp:YES];
        }
    }else if (isDragging && scrollView.contentOffset.y >scrollView.contentSize.height-scrollView.frame.size.height){
        if (scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height+REFRESH_HEADER_HEIGHT) {
            [footer turnArrowUp:YES];
        }else{
            [footer turnArrowDown:YES];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        isLoading = YES;
        header.loading = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        }];
        [self headerReflash];
    }else if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height +REFRESH_HEADER_HEIGHT){
        isLoading = YES;
        footer.loading = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
        }];
        [self footerForMore];
    }
}

- (void)dealloc {
    [header release];
    [super dealloc];
    //    [refreshHeaderView release];
    //    [refreshLabel release];
    //    [refreshArrow release];
    //    [refreshSpinner release];
    //    [textPull release];
    //    [textRelease release];
    //    [textLoading release];
    
}

//@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

//- (id)initWithStyle:(UITableViewStyle)style {
//  self = [super initWithStyle:style];
//  if (self != nil) {
//    [self setupStrings];
//  }
//  return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//  self = [super initWithCoder:aDecoder];
//  if (self != nil) {
//    [self setupStrings];
//  }
//  return self;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//  if (self != nil) {
//    [self setupStrings];
//  }
//  return self;
//}

//- (void)addPullToRefreshHeader {
//    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
//    refreshHeaderView.backgroundColor = [UIColor clearColor];
//
//    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
//    refreshLabel.backgroundColor = [UIColor clearColor];
//    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
//    refreshLabel.textAlignment = UITextAlignmentCenter;
//
//    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
//    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
//                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
//                                    27, 44);
//
//    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
//    refreshSpinner.hidesWhenStopped = YES;
//
//    [refreshHeaderView addSubview:refreshLabel];
//    [refreshHeaderView addSubview:refreshArrow];
//    [refreshHeaderView addSubview:refreshSpinner];
//    [self.tableView addSubview:refreshHeaderView];
//}

//- (void)setupStrings{
//  textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
//  textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
//  textLoading = [[NSString alloc] initWithString:@"Loading..."];
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (isLoading) {
//        // Update the content inset, good for section headers
//        if (scrollView.contentOffset.y > 0)
//            self.tableView.contentInset = UIEdgeInsetsZero;
//        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
//            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (isDragging && scrollView.contentOffset.y < 0) {
//        // Update the arrow direction and label
//        [UIView animateWithDuration:0.25 animations:^{
//            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
//                // User is scrolling above the header
//                refreshLabel.text = self.textRelease;
//                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//            } else {
//                // User is scrolling somewhere within the header
//                refreshLabel.text = self.textPull;
//                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
//            }
//        }];
//    }
//}

//- (void)startLoading {
//    isLoading = YES;
//    
//    // Show the header
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
//        refreshLabel.text = self.textLoading;
//        refreshArrow.hidden = YES;
//        [refreshSpinner startAnimating];
//    }];
//    
//    // Refresh action!
//    [self refresh];
//}

//- (void)stopLoading {
//    isLoading = NO;
//    
//    // Hide the header
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.contentInset = UIEdgeInsetsZero;
//        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
//    } 
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(stopLoadingComplete)];
//                     }];
//}

//- (void)stopLoadingComplete {
//    // Reset the header
//    refreshLabel.text = self.textPull;
//    refreshArrow.hidden = NO;
//    [refreshSpinner stopAnimating];
//}

//- (void)getMore{
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
//}

//- (void)refresh {
//    // This is just a demo. Override this method with your custom reload action.
//    // Don't forget to call stopLoading at the end.
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
//}



@end
