#import "UILabel+dynamicSizeMe.h"

@implementation UILabel (dynamicSizeMe)

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];

    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font] 
                                            constrainedToSize:maximumLabelSize
                                            lineBreakMode:[self lineBreakMode]]; 
    return expectedLabelSize.height;
}

@end
