//
//  MyScene.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/7/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "MyScene.h"
#import "GameOver.h"
#import "MainScene.h"
#import "WinScene.h"
@import AVFoundation;


@implementation MyScene

//SKNode *_hudLayerNode;
AVAudioPlayer *_backgroundAudioPlayer;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* define variables */
        // Play background music
        [self startBackgroundMusic];
        
        isDamaged = NO; //by default damage is no
        isGrounded = NO;
        isGameOver = NO;
        isPaused = NO;
        isScoreOn = YES;
        
        
        speed = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10 : 5;
        lifeSpeed = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 3 : 1;
        score=0;
        life = 3;
        
        
        /* Setup your scene here */
        
        //Adding Landscape -- Background Image
        SKSpriteNode *landscape = [SKSpriteNode spriteNodeWithImageNamed:@"landscape"];
        //Sets the image to absolute center
        
        landscape.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:landscape];
        
        //Creating a function to add a Node/Land
        [self performSelector:@selector(createGround) withObject:nil ];
        
        //Creating a function to add a Node/Character
        [self addChild: [self createCharacter] ];
        
        //Setting up action code
        [self setUpActions];
        
        //Delaying the function (same as above, just with a delay)
        [self performSelector:@selector(createBoulder) withObject:nil afterDelay:2.0];
        
        //        [self setupSceneLayers];
        //        [self setupUI];
        
        // Add Pause button
        [self addChild:[self pauseButton]];
        
        // Create Score label
        [self createScoreLabel];
        
        // Create Life stutus
        [self createLifeStatus];
        
        boulderTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addBoulder) userInfo:nil repeats:YES];
        
        lifeTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(createLives) userInfo:nil repeats:YES];
        
    }
    return self;
}

//- (void)setupSceneLayers
//{
//    _hudLayerNode = [SKNode node];
//    [self addChild:_hudLayerNode];
//}


// Create the score label
- (SKSpriteNode *)pauseButton
{
    pauseNode = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
    pauseNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-pauseNode.size.height/1.5);
    pauseNode.name = @"pauseButton";//how the node is identified later
    [pauseNode setScale:0.7];
    pauseNode.zPosition = 0.1;
    
    return pauseNode;
}

// Create the score label
- (void)createScoreLabel {
    SSBitmapFont *bitmapFont = [self bitmapFontForFile:@"hobo"];
    scoreLabel = [bitmapFont nodeFromString:[NSString stringWithFormat:@"Score: %@", [NSNumber numberWithInteger:score]]];
    scoreLabel.position =((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                          CGPointMake(CGRectGetMaxX(self.frame)-130,pauseNode.position.y):
                          CGPointMake(CGRectGetMaxX(self.frame)-50,pauseNode.position.y));
    scoreLabel.zPosition = 0.1;
    [self addChild:scoreLabel];
}


-(void)createLifeStatus{
    lifeImage1 = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    lifeImage1.alpha = 1.0f;
    lifeImage1.zPosition = 0.1;
    [lifeImage1 setScale:0.6];
    lifeImage1.position=((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                         CGPointMake(50, pauseNode.position.y):
                         CGPointMake(20, pauseNode.position.y));
    [self addChild:lifeImage1];
    
    lifeImage2 = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    lifeImage2.zPosition=0.1;
    lifeImage2.alpha = 1.0f;
    [lifeImage2 setScale:0.6];
    lifeImage2.position = CGPointMake(lifeImage1.position.x + lifeImage2.size.width+10, lifeImage1.position.y);
    [self addChild:lifeImage2];
    
    
    lifeImage3 = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    lifeImage3.zPosition=0.1;
    lifeImage3.alpha = 1.0f;
    [lifeImage3 setScale:0.6];
    lifeImage3.position = CGPointMake(lifeImage1.position.x + lifeImage3.size.width*2+20, lifeImage1.position.y);
    [self addChild:lifeImage3];
    
    
    lifeImage4 = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    lifeImage4.zPosition=0.1;
    lifeImage4.alpha = 0.0f;
    [lifeImage4 setScale:0.6];
    lifeImage4.position = CGPointMake(lifeImage1.position.x + lifeImage3.size.width*3+30, lifeImage1.position.y);
    [self addChild:lifeImage4];
    
    
    lifeImage5 = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    lifeImage5.zPosition=0.1;
    lifeImage5.alpha = 0.0f;
    [lifeImage5 setScale:0.6];
    lifeImage5.position = CGPointMake(lifeImage1.position.x + lifeImage3.size.width*4+40, lifeImage1.position.y);
    [self addChild:lifeImage5];
    
}


//- (void)setupUI
//{
//    int barHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
//                     45 : 100);
//    CGSize backgroundSize =
//    CGSizeMake(self.size.width, barHeight);
//    SKColor *backgroundColor =
//    [SKColor colorWithRed:0 green:0 blue:0.05 alpha:0.0];
//    SKSpriteNode *hudBarBackground =
//    [SKSpriteNode spriteNodeWithColor:backgroundColor
//                                 size:backgroundSize];
//    hudBarBackground.position =
//    CGPointMake(0, self.size.height - barHeight);
//    hudBarBackground.anchorPoint = CGPointZero;
//    [_hudLayerNode addChild:hudBarBackground];
//
//}


//Function to call the Character Node
-(SKSpriteNode*) createCharacter{
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"character_base"];
    
    //Set the location to an actual position
    player.position =((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                      CGPointMake(160,100):
                      CGPointMake(80, 50));
    //Giving the Character a name
    player.name =@"character";
    
    //Not sure what this was
    [player setScale:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.5f : 0.6)];
    return player;
    
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
    SKAction* moveUp = [SKAction moveByX:0 y:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                              400 : 190) duration:0.6];
    SKAction* moveDown = [SKAction moveByX:0 y:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                                -400 : -190) duration:0.4];
    SKAction* done = [SKAction performSelector:@selector(jumpDone) onTarget:self];
    
    jumpMovement =[SKAction sequence:@[moveUp,moveDown, done]];
    
}

//Collision on Ground
-(void) jumpDone{
    //Check to see if jumping is occuring
    isJumping = NO;
    
    //Play sound when he is hit
    [self runAction:[SKAction playSoundFileNamed:@"thump.mp3" waitForCompletion:NO]];
    
    NSLog(@"Character hit ground -- Jump Done");
    
}

//Set up the ground so we can test collisions when ground is hit
-(void) createGround{
    //Adding Landscape -- Background Image
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    //Sets the image to absolute center
    
    ground.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                       CGPointMake(0, 25) : CGPointMake(0, 25));
    //Scaling down the image
    
    [ground setScale: ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.5f)];
        ground.xScale= .5;
        ground.yScale= .5;
    [self addChild:ground];
    
}


//Function to call the Boulder
-(void) createBoulder{
    
    //set up the starting point of the object(s)
    //    CGPoint startPoint = CGPointMake(360,145);
    
    //Set up the shadow location
    SKSpriteNode *shadow = [SKSpriteNode spriteNodeWithImageNamed:@"shadow"];
    shadow.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                       CGPointMake(CGRectGetMaxX(self.frame)+80, 50) : CGPointMake(CGRectGetMaxX(self.frame)+40, 23));
    //     shadow.position = CGPointMake(startPoint.x, startPoint.y-122);
    shadow.name = @"shadow";
    
    //stretching the item by 1.5
    shadow.xScale= 1 ;
    //    shadow.zPosition = 1;
    
    //add the shadow to the board
    [self addChild:shadow];
    
    SKSpriteNode *boulder = [SKSpriteNode spriteNodeWithImageNamed:@"boulder"];
    boulder.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                        CGPointMake(CGRectGetMaxX(self.frame)+80, 94) : CGPointMake(CGRectGetMaxX(self.frame)+40, 45));
    
    //    boulder.position = CGPointMake(startPoint.x, startPoint.y-90);
    boulder.name = @"boulder";
    //    boulder.zPosition = 2 ;
    [boulder setScale:((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.5f)];
    
    [self addChild:boulder];
    
    //after adding the children, we want to cal this function again at some random interval
    float randomNum = arc4random_uniform(3)+3; //Random number 0-3 but adding 3 to each random number
    
    //delaying the object at the random float noted above
    [self performSelector:@selector(createBoulder) withObject:nil afterDelay:randomNum];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    
    if (CGRectContainsPoint(pauseNode.frame, positionInScene)) {
#ifdef DEBUG
        NSLog(@"pause Button Tapped");
#endif
        
        // Set an action to the button
        [pauseNode runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1]]]completion:^{
            
            if (!isPaused || isGameOver) {
                isPaused = YES;
                
                [scoreLabel setHidden:YES];
                
                [pauseNode setHidden:YES];
                
                [lifeImage1 setHidden:YES];
                [lifeImage2 setHidden:YES];
                [lifeImage3 setHidden:YES];
                [lifeImage4 setHidden:YES];
                [lifeImage5 setHidden:YES];
                
                [boulderTimer pause];
                [player setPaused:YES];
                
                // add pause screen
                pauseBG = [SKSpriteNode spriteNodeWithImageNamed:@"pauseBG"];
                pauseBG.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
                pauseBG.alpha = 0.0f;
                pauseBG.zPosition = 0.2;
                [self addChild:pauseBG];
                
                [pauseBG runAction:[SKAction fadeAlphaTo:1.0f duration:0.5f]completion:^{
                    
                    SSBitmapFont *bitmapFont = [self bitmapFontForFile:@"ScorePanelFont"];
                    pausedLabel = [bitmapFont nodeFromString:@"PAUSED"];
                    pausedLabel.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                            CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+200) :
                                            CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+90));
                    pausedLabel.zPosition = 0.3;
                    [self addChild:pausedLabel];
                    
                    pauseScoreLabel = [bitmapFont nodeFromString:[NSString stringWithFormat:@"Score: %d", score]];
                    pauseScoreLabel.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                                CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+80) :
                                                CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+40));
                    pauseScoreLabel.zPosition = 0.3;
                    [self addChild:pauseScoreLabel];
                    
                    
                    menu = [SKSpriteNode spriteNodeWithImageNamed:@"menu"];
                    menu.position =  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                      CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-40) :
                                      CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20));
                    menu.zPosition = 0.3;
                    [self addChild:menu];
                    
                    
                    resume = [SKSpriteNode spriteNodeWithImageNamed:@"resume"];
                    resume.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                       CGPointMake(CGRectGetMidX(self.frame), menu.position.y - (resume.size.height+30)) :
                                       CGPointMake(CGRectGetMidX(self.frame), menu.position.y - (resume.size.height+15)));
                    resume.zPosition = 0.3;
                    [self addChild:resume];
                    
                    
                    retry = [SKSpriteNode spriteNodeWithImageNamed:@"retry"];
                    retry.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                      CGPointMake(CGRectGetMidX(self.frame), resume.position.y - (retry.size.height+30)) :
                                      CGPointMake(CGRectGetMidX(self.frame), resume.position.y - (retry.size.height+15)));
                    retry.zPosition = 0.3;
                    [self addChild:retry];
                    
                }];
                
            }
            
        }];
    } else if (CGRectContainsPoint(resume.frame, positionInScene)) {
        
#ifdef DEBUG
        NSLog(@"resume Button Tapped");
#endif
        
        // Set an action to the button
        [resume runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1]]]completion:^{
            isPaused = NO;
            
            [boulderTimer resume];
            [player setPaused:NO];
            
            [pauseBG runAction:[SKAction fadeAlphaTo:0.0f duration:0.5]];
            [menu removeFromParent];
            [resume removeFromParent];
            [retry removeFromParent];
            [pauseScoreLabel removeFromParent];
            [pausedLabel removeFromParent];
            
            [pauseNode setHidden:NO];
            [scoreLabel setHidden:NO];
            
            [lifeImage1 setHidden:NO];
            [lifeImage2 setHidden:NO];
            [lifeImage3 setHidden:NO];
            [lifeImage4 setHidden:NO];
            [lifeImage5 setHidden:NO];
            
        }];
    } else if (CGRectContainsPoint(retry.frame, positionInScene)) {
        
#ifdef DEBUG
        NSLog(@"retry Button Tapped");
#endif
        
        // Set an action to the button
        [retry runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1]]]completion:^{
            
            SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
            MyScene *gameScene = [[MyScene alloc] initWithSize:self.size];
            [self.scene.view presentScene:gameScene transition:reveal];
            
        }];
    } else if (CGRectContainsPoint(menu.frame, positionInScene)) {
        
#ifdef DEBUG
        NSLog(@"menu Button Tapped");
#endif
        
        // Set an action to the button
        [menu runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1]]]completion:^{
            
            SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
            MainScene *mainScene = [[MainScene alloc] initWithSize:self.size];
            [self.scene.view presentScene:mainScene transition:reveal];
            
        }];
    } else if (!isPaused){
        
        
        //Running the Jump Actions
        
        if (isJumping == NO){
            
            isJumping = YES;
            
            //Actually set the actions to the nodes
            SKSpriteNode* character = (SKSpriteNode*)[self childNodeWithName:@"character"];
            [character runAction:jumpAnimation];
            [character runAction:jumpMovement];
            
            
        }
    }
}

-(void)gameStarted{
    boulderTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addBoulder) userInfo:nil repeats:YES];}

-(void)addBoulder{
    /* Called before each frame is rendered */
    
    [self enumerateChildNodesWithName:@"boulder" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Do something if the boulder is found
        //If node is 0 or 0 then do something
        if(node.position.x<0 || node.position.y<0 ){
            //if the node is out of the visible area,
            isScoreOn = YES;
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

-(void)createLives{
    //Set up the shadow location
    SKSpriteNode *lives = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    lives.position =  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                       CGPointMake(CGRectGetMaxX(self.frame)+(lives.size.width/2), 380) :
                       CGPointMake(CGRectGetMaxX(self.frame)+(lives.size.width/2), 180));
    lives.name = @"getLife";
    [self addChild:lives];
    
    //after adding the children, we want to cal this function again at some random interval
    //    randomNumLife = arc4random_uniform(3)+3; //Random number 0-3 but adding 3 to each random number
}

//Time stuff is in here
-(void)update:(CFTimeInterval)currentTime {
    
    SKNode* someNode = [self childNodeWithName:@"character"];
    
    //We may or may not use this.. so lets define it
    SKSpriteNode* character;
    
    //making sure the node is not nil
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
        
        //Test for a collision
        
        if( [character intersectsNode:node] && isDamaged == NO){
            
            [self doDamage:character];
            //            bool scoreCount = NO;
            
            NSLog(@"Intersectiong Occured");
        } else if (node.position.x <= character.position.x && isDamaged==NO && isScoreOn==YES) {
            [self increamentScore];
        }
        
    }];
    
    
    
    [self enumerateChildNodesWithName:@"getLife" usingBlock:^(SKNode *node, BOOL *stop) {
        
        //Do something if the boulder is found
        //If node is 0 or 0 then do something
        if(node.position.x<0 || node.position.y<0 ){
            //if the node is out of the visible area,
            isLifeAvailable = YES;
            [node removeFromParent];
        }
        //If node hits the end of the cliff, drop the node to the ground
        
        //move it on the x and the y to make it fall
        else if (node.position.x <-30) {
            node.position = CGPointMake(node.position.x-(lifeSpeed*.25), node.position.y-20);
        } else{
            //Move the node on the X axis by 10
            node.position = CGPointMake(node.position.x-lifeSpeed ,node.position.y);
            
        }
        
        if( [character intersectsNode:node] && life < 5){
            [node removeFromParent];
            [self gainedLife];
            
            NSLog(@"Intersectiong Occured");
        }
    }];
}

-(void)increamentScore{
    score++;
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %@", [NSNumber numberWithInteger:score]]];
    isScoreOn = NO;
    if (score==8) {
        [self gameWon];
    }
}

-(void)gameWon{
    WinScene *gameWin = [[WinScene alloc] initWithSize:self.size win:score];
    SKTransition *flip = [SKTransition flipHorizontalWithDuration:0.5f];
    [self.view presentScene:gameWin transition:flip];
    
}

-(void) meetsGround: (SKSpriteNode*)ground{
    isGrounded = YES;
}

-(void)gainedLife{
    life++;
    
    if (life==0) {
        [lifeImage1 setAlpha:0.0f];
        [lifeImage2 setAlpha:0.0f];
        [lifeImage3 setAlpha:0.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==1) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:0.0f];
        [lifeImage3 setAlpha:0.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==2) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:0.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==3) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:1.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==4) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:1.0f];
        [lifeImage4 setAlpha:1.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life == 5) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:1.0f];
        [lifeImage4 setAlpha:1.0f];
        [lifeImage5 setAlpha:1.0f];
    }
}

//testing damage to the character
-(void) doDamage: (SKSpriteNode*)character{
    
    isDamaged = YES;
    
    //adding a +1 on the hitcount
    life--;
    if (life==0) {
        [lifeImage1 setAlpha:0.0f];
        [lifeImage2 setAlpha:0.0f];
        [lifeImage3 setAlpha:0.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==1) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:0.0f];
        [lifeImage3 setAlpha:0.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==2) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:0.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==3) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:1.0f];
        [lifeImage4 setAlpha:0.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life==4) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:1.0f];
        [lifeImage4 setAlpha:1.0f];
        [lifeImage5 setAlpha:0.0f];
    }
    if (life == 5) {
        [lifeImage1 setAlpha:1.0f];
        [lifeImage2 setAlpha:1.0f];
        [lifeImage3 setAlpha:1.0f];
        [lifeImage4 setAlpha:1.0f];
        [lifeImage5 setAlpha:1.0f];
    }
    
    
    //Push the character back on the hit
    //    SKAction *push = [SKAction  moveByX:-15 y:0 duration:0.2];
    //    [character runAction:push];
    
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
    
    if(life == 0){
        
        [self gameOver];
        
    }
}

-(void) gameOver{
    
    NSLog(@"GAME OVER");
    
    //Play the new Scene
    GameOver *game = [[GameOver alloc] initWithSize:self.size lose:score];
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



//
//    - (SKSpriteNode *)playButton
//    {
//        SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"play.png"];
//        playNode.position = CGPointMake(20 ,520);
//        playNode.name = @"playButton";//how the node is identified later
//        playNode.zPosition = 2.;
//
//        return playNode;
//    }


- (SSBitmapFont *)bitmapFontForFile:(NSString *)filename
{
    // Generate a path to the font file
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"skf"];
    
    NSAssert(path, @"Could not find font file");
    
    // Create a new instance of SSBitmapFont using the font file and check for errors
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:path];
    SSBitmapFont *bitmapFont = [[SSBitmapFont alloc] initWithFile:url error:&error];
    
    NSAssert(!error, @"%@: %@", error.domain, error.localizedDescription);
    
    return bitmapFont;
}

@end







