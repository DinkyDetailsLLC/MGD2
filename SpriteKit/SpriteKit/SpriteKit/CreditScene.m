//
//  CreditScene.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/28/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//
#import "CreditScene.h"
#import "MainScene.h"

@implementation CreditsScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        [self createBackground];
        //        [self createTitleAndText];
        [self createBackButton];
        
    }
    return self;
}


-(void) createBackground {
    
    SKTexture * bgTexture = [SKTexture textureWithImageNamed:@"commonBG"];
    self.background = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    self.background.position = (CGPoint){CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)
    };
    [self addChild: self.background];
}

//-(void) createTitleAndText {
//    self.title = [SKLabelNode labelNodeWithFontNamed:@"HoboStd"];
//    self.title.text = @"Credits";
//    self.title.fontSize = 30;
//    self.title.fontColor = [SKColor blackColor];
//    self.title.position = (CGPoint){CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-50};
//    [self addChild:self.title];
//}

-(void)createBackButton{
    self.backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    [self.backButton setScale:1.15f];
    self.backButton.position = (CGPoint) {CGRectGetMidX(self.frame),70};
    [self addChild:self.backButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // Get the touch
    UITouch *touch = [touches anyObject];
    
    // Get the position in the scene
    CGPoint positionInScene = [touch locationInNode:self];
    
    // Check if the Back button is tapped
    if (CGRectContainsPoint(self.backButton.frame, positionInScene))
    {
#ifdef DEBUG
        NSLog(@"Back button tapped");
#endif
        
        // Set an action to the button
        [self.backButton runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1f]]] completion:^{
            
            SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
            MainScene *mainScene = [[MainScene alloc] initWithSize:self.size];
            [self.scene.view presentScene:mainScene transition:reveal];
        }];
    } // End Back button tapped
}

@end