//
//  TGAppDelegate.m
//  Triptych
//
//  Created by Teo Sartori on 25/09/2013.
//  Copyright (c) 2013 Teo Sartori. All rights reserved.
//

#import "TGAppDelegate.h"

// Constant definitions
static NSString * const kRightLabel =    @"rightView";
static NSString * const kLeftLabel =     @"leftView";

@implementation TGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    NSView * theView = [[self window] contentView];
    NSSplitView *theSplitView = [[theView subviews] objectAtIndex:0] ;

    NSAssert([[theSplitView subviews] count] == 3, @"The splitview does not have the expected number of subviews.");
    
    // Keep track of the expanded width of the panels before we collapse them.
    leftExpandedWidth = NSWidth([theSplitView.subviews[0] frame]);
    rightExpandedWidth = NSWidth([theSplitView.subviews[2] frame]);
}


- (IBAction)toggleLeft:(NSButton *)sender {

    NSRect windowFrame = [[self window] frame];
    NSView * theView = [[self window] contentView];
    NSSplitView *theSplitView = [[theView subviews] objectAtIndex:0];
    NSView *leftSubview = theSplitView.subviews[0];
    
    NSLayoutPriority priorityLeftSubview = [theSplitView holdingPriorityForSubviewAtIndex:0];
    NSLayoutPriority priorityMidSubview = [theSplitView holdingPriorityForSubviewAtIndex:1];

    CGFloat dividerThickness = [theSplitView dividerThickness];
    
    BOOL isCollapsed = [theSplitView isSubviewCollapsed:leftSubview];


    // Temporarily change the holding priorities to ensure the left subview is affected by frame changes.
    [theSplitView setHoldingPriority:1 forSubviewAtIndex:0];
    [theSplitView setHoldingPriority:NSLayoutPriorityDefaultHigh forSubviewAtIndex:1];
    
    if (isCollapsed) {
        // First uncollapse the view by setting the divider position to the its thickness.
        [theSplitView setPosition:1 ofDividerAtIndex:0];
        
        // Then make room for it to get pushed by the width constraint of the middle view.
        windowFrame.size.width += dividerThickness;
        windowFrame.origin.x -= dividerThickness;
        [self.window setFrame:windowFrame display:YES animate:NO];

        // ...then grow the window and let the left view expand into the space as per splitview holding priorities.
        windowFrame.size.width += leftExpandedWidth;
        windowFrame.origin.x -= leftExpandedWidth;
        [self.window setFrame:windowFrame display:YES animate:YES];
        
    } else {
        // First shrink the window by the width of the left subview.
        windowFrame.size.width -= NSWidth(leftSubview.frame);
        windowFrame.origin.x += NSWidth(leftSubview.frame);
        [self.window setFrame:windowFrame display:YES animate:YES];

        // ...then collapse the adjoining view by setting the divider to the view's minimum possible position,
        // which will necessarily be past half its width and in turn will trigger the view's collapse (as long as splitview:canCollapseSubview returns YES).
        [theSplitView setPosition:[theSplitView minPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];

        // and reduce frame the last bit of the thickness of the divider.
        windowFrame.size.width -= dividerThickness;
        windowFrame.origin.x += dividerThickness;
        [self.window setFrame:windowFrame display:YES animate:NO];
    }

    // Restore the holding priorites to what they were before the toggle.
    [theSplitView setHoldingPriority:priorityLeftSubview forSubviewAtIndex:0];
    [theSplitView setHoldingPriority:priorityMidSubview forSubviewAtIndex:1];
    
}


- (IBAction)toggleRight:(NSButton *)sender {
    
    NSRect windowFrame = [[self window] frame];
    NSView * theView = [[self window] contentView];
    NSSplitView *theSplitView = [[theView subviews] objectAtIndex:0] ;
    
    NSView *rightSubview = theSplitView.subviews[2];
    
    NSLayoutPriority priorityMidSubview = [theSplitView holdingPriorityForSubviewAtIndex:1];
    NSLayoutPriority priorityRightSubview = [theSplitView holdingPriorityForSubviewAtIndex:2];

    CGFloat dividerThickness = [theSplitView dividerThickness];
    
    BOOL isCollapsed = [theSplitView isSubviewCollapsed:rightSubview];

    
    // Temporarily weaken the holding priority for the info view and strengthen the song view.
    [theSplitView setHoldingPriority:1 forSubviewAtIndex:2];
    [theSplitView setHoldingPriority:NSLayoutPriorityDefaultHigh forSubviewAtIndex:1];
    
    if (isCollapsed) {
        // First uncollapse the view...
        [theSplitView setPosition:NSWidth(windowFrame)-dividerThickness ofDividerAtIndex:1];
        windowFrame.size.width += dividerThickness;
        
        [self.window setFrame:windowFrame display:YES animate:NO];

        // ...then grow the window.
        windowFrame.size.width += rightExpandedWidth;
        [self.window setFrame:windowFrame display:YES animate:YES];
        
    } else {
        // First shrink the window by the width of the info panel.
        windowFrame.size.width -= NSWidth(rightSubview.frame);

        [self.window setFrame:windowFrame display:YES animate:YES];
        
        // ...then collapse the view.
        [theSplitView setPosition:NSWidth(windowFrame) ofDividerAtIndex:1];
        windowFrame.size.width -= dividerThickness;
        
        [self.window setFrame:windowFrame display:YES animate:NO];
    }
    
    [theSplitView setHoldingPriority:priorityMidSubview forSubviewAtIndex:1];
    [theSplitView setHoldingPriority:priorityRightSubview forSubviewAtIndex:2];
    
}


// This disables dragging of dividers in such a way that not even the drag cursors appear.
-(NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
    return NSZeroRect;
}


-(BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return [[subview identifier] isEqualToString:kLeftLabel] || [[subview identifier] isEqualToString:kRightLabel];
}


-(BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}

@end
