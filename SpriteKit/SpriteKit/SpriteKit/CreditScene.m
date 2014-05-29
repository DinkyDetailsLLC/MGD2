//
//  CreditScene.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/28/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "CreditScene.h"

@implementation CreditScene

-(id) initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        //setup your scene
        
        [self createBackground];
        
    }return self;
}

//create background
-(void) createBackground{
    SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"commonBG"];
    self.background = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    self.background.position = (CGPoint) {CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)};
    [self addChild:self.background];
}

-(void) createTitleAndText{
    self.title = [SKLabellNode labelNodeWithFontNamed:@"hobo"];
    self.title.text =@"Credits";
    self.title.fontSize = 30;
    self.title.fontColor = [SKColor blackColor];
    self.title.position = (CGPoint) {CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-50};
    [self.addChild:self.title];
    
    }

-(void) createBackButton{
}
@end
