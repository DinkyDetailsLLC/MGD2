//
//  MyScene.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/7/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "MyScene.h"
#import "GameOver.h"
@import AVFoundation;


@implementation MyScene
AVAudioPlayer *_backgroundAudioPlayer;

-(id)initWithSize:(CGSize)size {
      [self startBackgroundMusic];
    if (self = [super initWithSize:size]) {
        /* define variables */
        
        isDamaged = NO; //by default damage is no
        speed = 10;
        
        /* Setup your scene here */
        
        //Adding Landscape -- Background Image
        SKSpriteNode *landscape = [SKSpriteNode spriteNodeWithImageNamed:@"landscape"];
        //Sets the image to absolute center
        landscape.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        //Scaling down the image
        landscape.xScale= .5;
        landscape.yScale= .5;
        [self addChild:landscape];
        
        //Creating a function to add a Node/Character
        [self addChild: [self createCharacter] ];
        
        //Setting up action code
        [self setUpActions];
        
        //Delaying the function (same as above, just with a delay)
        [self performSelector:@selector(createBoulder) withObject:nil afterDelay:2.0];
        
        
        //Adding railing
        //SKSpriteNode *railing = [SKSpriteNode spriteNodeWithImageNamed:@"railing"];
        //Sets the image to absolute center
        //railing.position = CGPointMake(200 ,300);
        //railing.zPosition = 50;
        //[self addChild:railing];
        
        
        
       
    }
    return self;
}

//Function to call the Character Node
-(SKSpriteNode*) createCharacter{
    
    SKSpriteNode *character = [SKSpriteNode spriteNodeWithImageNamed:@"character_base"];
    
    //Set the location to an actual position
    character.position = CGPointMake(120 ,50);
    //character.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    //Giving the Character a name
    character.name =@"character";
    
    //Scaling down the image
    character.xScale= .5;
    character.yScale= .5;
    
    
    //Not sure what this was
    character.zPosition = 100;
    
    return character;
    
}

//Actions Function
-(void) setUpActions{
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"character"]; //no need to have the .atlas folder
                            //setting up the other images
                             SKTexture *jumpTex1 = [atlas textureNamed:@"character_jump1.png"];
                             SKTexture *jumpTex2 = [atlas textureNamed:@"character_jump2.png"];
                             SKTexture *jumpTex3 = [atlas textureNamed:@"character_jump3.png"];
                             
                             //putting the images into an array
                             NSArray *atlasTexture = @[jumpTex1, jumpTex2, jumpTex3];
                             NSArray *atlasTexture2 = @[jumpTex2, jumpTex1,];
    
                             //Setting the action of the character/animation
                             SKAction *atlasAnimation =[SKAction animateWithTextures:atlasTexture timePerFrame: 0.1];
                             SKAction *wait = [SKAction waitForDuration:0.5];
                             SKAction *atlasAnimation2 =[SKAction animateWithTextures:atlasTexture2 timePerFrame: 0.1];
                             SKAction *resetTexture = [SKAction setTexture: [SKTexture textureWithImageNamed:@"character_base.png"]];
    
                             //This is the action(s) all together in an Array
    
    jumpAnimation = [SKAction sequence:@[atlasAnimation, wait, atlasAnimation2,resetTexture]];
  
    //Creating a second set of actions
    SKAction* moveUp = [SKAction moveByX:0 y:150 duration:0.3];
    SKAction* moveUp2 = [SKAction moveByX:0 y:40 duration:0.3];
    SKAction* moveDown = [SKAction moveByX:0 y:-190 duration:0.4];
    SKAction* done = [SKAction performSelector:@selector(jumpDone) onTarget:self];
    
    jumpMovement =[SKAction sequence:@[moveUp, moveUp2, moveDown,done]];

}

-(void) jumpDone{
   //Check to see if jumping is occuring
    isJumping = NO;
    
    NSLog(@"Jump Done");
    
}


//Function to call the Boulder
-(void) createBoulder{
    
    //set up the starting point of the object(s)
    CGPoint startPoint = CGPointMake(360,145);
    
    //Set up the shadow location
    SKSpriteNode *shadow = [SKSpriteNode spriteNodeWithImageNamed:@"shadow"];
    shadow.position = CGPointMake(startPoint.x, startPoint.y-122);
    shadow.name = @"shadow";
    
    //stretching the item by 1.5
    shadow.xScale= 1 ;
    shadow.zPosition = 1;
    
    //add the shadow to the board
    [self addChild:shadow];
    
    SKSpriteNode *boulder = [SKSpriteNode spriteNodeWithImageNamed:@"boulder"];
    boulder.position = CGPointMake(startPoint.x, startPoint.y-90);
    boulder.name = @"boulder";
    boulder.zPosition = 2 ;
    boulder.xScale= .5;
    boulder.yScale = .5;
    [self addChild:boulder];
    
    //after adding the children, we want to cal this function again at some random interval
    float randomNum = arc4random_uniform(3)+3; //Random number 0-3 but adding 3 to each random number
    
    //delaying the object at the random float noted above
    [self performSelector:@selector(createBoulder) withObject:nil afterDelay:randomNum];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    //Running the Jump Actions
    
    if (isJumping == NO){
    
        isJumping = YES;
        
    //Actually set the actions to the nodes
    SKSpriteNode* character = (SKSpriteNode*)[self childNodeWithName:@"character"];
    [character runAction:jumpAnimation];
    [character runAction:jumpMovement];
        
    
    }
    
   
    
}


//Time stuff is in here
-(void)update:(CFTimeInterval)currentTime {
    
    SKNode* someNode = [self childNodeWithName:@"character"];
    
    //We may or may not use this.. so lets define it
    SKSpriteNode* character;
    
    //making sure the node is not nol
    if(someNode !=nil){
    //Testing for the node to make sure it is a sprite node so things can happen
    if( [someNode isKindOfClass:[SKSpriteNode class]]){
        
        //using the character
        character = (SKSpriteNode*)someNode;
        
        //NSLog(@"Character is a SKSpriteNode");
        }
    }
    
    /* Called before each frame is rendered */
    
    [self enumerateChildNodesWithName:@"boulder" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Do something if the boulder is found
        //If node is 0 or 0 then do something
        if(node.position.x<0 || node.position.y<0 ){
            //if the node is out of the visible area,
            [node removeFromParent];
        }
        //If node hits the end of the cliff, drop the node to the ground
        
        //move it on the x and the y to make it fall
        else if (node.position.x <-30) {
            node.position = CGPointMake(node.position.x-(speed*.25), node.position.y-20);
            
        } else{
            //Move the node on the X axis by 10
            node.position = CGPointMake(node.position.x-speed ,node.position.y);
            
        }
        
        //Test for a collision
        if( [character intersectsNode:node] && isDamaged == NO){
            
            [self doDamage:character];
            
            NSLog(@"Intersectiong Occured");
        }
        
        
    }];
    
    //handling the shadow positioning
    [self enumerateChildNodesWithName:@"shadow" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Move the node on the X axis by 10
        node.position = CGPointMake(node.position.x-speed,node.position.y);
        
        //remove the node when the boulder falls off the cliff
        if(node.position.x<70   ){
            [node removeFromParent];
            //start making the node disappear using alpha settings
        }else if (node.position.x<90){
            node.alpha = node.alpha *.25;
        }
        
        
        
    }];
}

//testing damage to the character
-(void) doDamage: (SKSpriteNode*)character{
    
    isDamaged = YES;
    
    //adding a +1 on the hitcount
    hitCount ++;
    
    //Push the character back on the hit
    SKAction *push = [SKAction  moveByX:-15 y:0 duration:0.2];
    [character runAction:push];
    
    //Make him red
    SKAction *pulseRed = [SKAction sequence:@[
                                              [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.5],
                                              [SKAction colorizeWithColorBlendFactor:0.0 duration:0.5 ],
                                              [SKAction performSelector:@selector(damageDone) onTarget:self]
                                              ]];
    
        [character runAction:pulseRed];
                      
    
    //Play sound when he is hit
    [self runAction:[SKAction playSoundFileNamed:@"ow.mp3" waitForCompletion:NO]];
    
    // After 1 second we are putting damage back to none
    [self performSelector:@selector(damageDone) withObject:nil afterDelay:1.0];
    
}

//turning damage off
-(void) damageDone{
    
     isDamaged =NO;
    
    if(hitCount == 3){
     
        [self gameOver];
        
    }
}

-(void) gameOver{
    
    NSLog(@"GAME OVER");
    
    //Play the new Scene
    SKScene *game = [[GameOver alloc] initWithSize:self.size lose:game];
    SKTransition *doors = [SKTransition doorwayWithDuration:0.5];
    [self.view presentScene:game transition:doors];
}

- (void)startBackgroundMusic
{
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Training-Mixed.mp3" ofType:nil]];
    _backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [_backgroundAudioPlayer prepareToPlay];
    
    // this will play the music infinitely
    _backgroundAudioPlayer.numberOfLoops = -1;
    [_backgroundAudioPlayer setVolume:.25];
    [_backgroundAudioPlayer play];
}
@end
































