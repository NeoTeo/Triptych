//
//  TGAppDelegate.h
//  Triptych
//
//  Created by Teo Sartori on 25/09/2013.
//  Copyright (c) 2013 Teo Sartori. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TGAppDelegate : NSObject <NSApplicationDelegate, NSSplitViewDelegate>
{
    CGFloat leftExpandedWidth;
    CGFloat rightExpandedWidth;
}

@property (assign) IBOutlet NSWindow *window;

@end
