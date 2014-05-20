//
//  MyScene.m
//  Centipede
//
//  Created by DANIEL ANNIS on 5/19/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "MyScene.h"
@implementation MyScene

//Adding the Zombie to the scene
{
    SKSpriteNode *_zombie;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //Setting Background Color to White
        self.backgroundColor = [SKColor whiteColor];
        SKSpriteNode *bg =
        [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.position =
        CGPointMake(self.size.width/2, self.size.height/2);
        //Set the anchor to abs Center
        bg.position =
        CGPointMake(self.size.width / 2, self.size.height / 2);
        bg.anchorPoint = CGPointMake(0.5, 0.5); // same as default
        
        //Rotating the background image
        //bg.zRotation = M_PI / 8;
        
        //add the background to the Scene
        [self addChild:bg];
        
        //Log the size of the actual BG
        CGSize mySize = bg.size;
        NSLog(@"Size: %@", NSStringFromCGSize(mySize));
        
        
        //Add the Zombie to the screen
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"zombie1"];
        _zombie.position = CGPointMake(100, 100);
        
        //doubled the Zombie Size
        [_zombie setScale:2.0]; // SKNode method
        [self addChild:_zombie];
    }
    return self;
}
@end