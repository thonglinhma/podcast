//
//  ALDownloadButton.h
//  Podcast
//
//  Created by Mike Tran on 8/13/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALDownloadButtonDelegate;

@interface ALDownloadButton : UIControl

/**
 * The progress of the view.
 **/
@property (nonatomic, assign) CGFloat progress;

/**
 * The width of the line used to draw the progress view.
 **/
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * The color of the progress view
 */
@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, copy) NSString *pathToDownload;

@property (nonatomic, strong) NSOperationQueue* networkOperationQueue; // Default: [Nimbus networkOperationQueue]


@property (nonatomic, weak) id<ALDownloadButtonDelegate>delegate;

@end

@protocol ALDownloadButtonDelegate <NSObject>

@optional

/**
 * The file has begun an asynchronous download of the file.
 */
- (void)downloadButtonDidStartLoad:(ALDownloadButton *)downloadButton;

- (void)downloadButtonDidStopLoad:(ALDownloadButton *)downloadButton;

/**
 * The file has completed an asynchronous download of the file.
 */
- (void)downloadButton:(ALDownloadButton *)downloadButton didDownloadFile:(NSString *)filePath;

/**
 * The asynchronous download failed.
 */
- (void)downloadButton:(ALDownloadButton *)downloadButton didFailWithError:(NSError *)error;

/**
 * The progress of the download.
 */
- (void)downloadButton:(ALDownloadButton *)downloadButton readBytes:(long long)readBytes totalBytes:(long long)totalBytes;

@end
