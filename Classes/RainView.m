//
//  RainView.m
//  RainEffect
//
//  Created by Yan Wang on 10-12-15.
//  Copyright 2010 YuanTu NetWork. All rights reserved.
//

#import "RainView.h"


@implementation RainView
@synthesize backgroundImageView;

- (id)initWithOrientation:(UIInterfaceOrientation)orientation{
    if ((self = [super init])) {
        // Initialization code

		[self setBackgroundColor:[UIColor blackColor]];
		screenOrientation = orientation;
		
		UIImage * image = [UIImage imageNamed:RAIN_NAME];
		backgroundImageView = [[UIImageView alloc] initWithImage:image];

		if (UIInterfaceOrientationIsPortrait(screenOrientation)){
			[backgroundImageView setFrame:CGRectMake(0, 0, backgroundImageView.image.size.width, SCREEN_FRAME.size.height)];
			[self setFrame:SCREEN_FRAME];
		}
		else{
			[backgroundImageView setFrame:CGRectMake(0, 0, backgroundImageView.image.size.width*0.75, SCREEN_FRAME.size.width)];
			[self setFrame:CGRectMake(0, 0, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width)];
		}
		//1536*1024

		[self addSubview:backgroundImageView];

		[self bgMoveAnimation];
		
		
		[self startRain];

   
}
	
	 return self;
}
	
- (void)resetWithOrientation:(UIInterfaceOrientation)orientation;{
	//NSLog(@"resetori");
	screenOrientation = orientation;
	if (UIInterfaceOrientationIsPortrait(screenOrientation)){
		//NSLog(@"before Set Portait--> :backimage.frame=%f,%f",backgroundImageView.frame.size.width,backgroundImageView.frame.size.height);
		[backgroundImageView setFrame:CGRectMake(0, 0, backgroundImageView.image.size.width, SCREEN_FRAME.size.height)];
		[self setFrame:SCREEN_FRAME];
		
	}
	else{
		//NSLog(@"before Set Landscap--> backimage.frame=%f,%f",backgroundImageView.frame.size.width,backgroundImageView.frame.size.height);
		[backgroundImageView setFrame:CGRectMake(0, 0, backgroundImageView.image.size.width*0.75, SCREEN_FRAME.size.width)];
		[self setFrame:CGRectMake(0, 0, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width)];
	}
	
	[self bgMoveAnimation];
	
}
	
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)bgMoveAnimation{
	//NSLog(@"animationBegin");
		[UIView beginAnimations:@"bgMoveAnimation" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:FLT_MAX];
	//竖屏横移 横屏纵移
		if (UIInterfaceOrientationIsPortrait(screenOrientation)){
			[UIView setAnimationDuration:MOVE_CYCLE];
			[backgroundImageView setFrame:CGRectMake(768-backgroundImageView.frame.size.width, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];
		}
		else{
			
			[UIView setAnimationDuration:MOVE_CYCLE*0.2];
			[backgroundImageView setFrame:CGRectMake(1024-backgroundImageView.frame.size.width, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];
		}
	
		[UIView commitAnimations];
	}
	



//开启整个雨天效果
-(void)startRain;
{
	
	//rainLineFlag = TRUE;
/*	
	[self initRainLine];
	
	for (int i =0 ; i<RAINLINE_COUNT; i++) {
		[self setRianLineWith:i];
	}
*/	
	for (int i=0; i<RAIN_COUNT; i++) {
		rainView[i]  = [[UIImageView alloc]init];
		[rainView[i] setUserInteractionEnabled:YES];
		touchFlag[i] = FALSE;
		[self addSubview:rainView[i]];
		[rainView[i] release];
		[self setRainWith:i];
	}	
	
	
	[self performSelector:@selector(startTimer) withObject:nil  afterDelay:1.5f];
	
}


#pragma mark touch-----------------
#if 0
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch * touch = [touches anyObject];
	for (int i =0; i<RAIN_COUNT; i++) {
		if ([touch view]==rainView[i]) {
			touchFlag[i] = TRUE;
			rainTouchedID = i;
			[self touchesAnimation];
		}
	}
	
	//NSLog(@"width=%f,height=%f",self.frame.size.width,self.frame.size.height);
	
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
//	UITouch * touch = [touches anyObject];
//	moveToPoint = [touch locationInView:self];
//	[rainView[rainTouchedID] setCenter:moveToPoint];
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	touchFlag[rainTouchedID]=FALSE;
	
}
#endif
-(void)touchesAnimation;
{
	int ii = arc4random()%4 +1 ;
	
	moveToPoint = [self touchMoveEndPointWith:ii];
	
	//NSLog(@"moveToPoint = %f,%f",moveToPoint.x,moveToPoint.y);
	
	CGFloat time = sqrt(pow((rainView[rainTouchedID].center.y - moveToPoint.y),2)+
	pow((rainView[rainTouchedID].center.x - moveToPoint.x),2))/1500 ;
	
	//NSLog(@"time=%f",time);
	
	[UIView beginAnimations:@"animation" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(touchesAnimationDidStop)];
	[UIView setAnimationDuration:time];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[rainView[rainTouchedID] setCenter:moveToPoint];
	[UIView commitAnimations];
	
}

-(void)touchesAnimationDidStop;
{
	touchFlag[rainTouchedID]=FALSE;
}

-(CGPoint)touchMoveEndPointWith:(int)type;
{
	
	CGPoint endPoint;
	if (type ==1) {
		endPoint.x = -100;
		endPoint.y = arc4random()%1024;
	}
	
	if (type ==2) {
		endPoint.x = 1100;
		endPoint.y = arc4random()%1024;
	}
	
	if (type ==3) {
		endPoint.x = arc4random()%1024;
		endPoint.y =-100;
	}
	
	if (type ==4) {
		endPoint.x = arc4random()%1024;
		endPoint.y = 1100;
	}
	
	return endPoint;
}


#pragma mark SetRain---------------

-(void)startTimer;
{
	rainTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(searchForReset) userInfo:nil repeats:YES];
}

-(void)stopTimer;{
	[rainTimer invalidate];
	rainTimer = nil;
	//rainLineFlag = FALSE;
}
	

-(void)searchForReset;
{
	
	for (int i=0; i<RAIN_COUNT; i++) {
		
		CGFloat yy = rainView[i].frame.origin.y;
		int tt = rainView[i].tag;
		CGFloat bb =1/(CGFloat)tt ;
		yy += bb * bb;
		
		CGSize size = rainView[i].frame.size;
		size.width -= 0.2;
		size.height -= 0.2;
		
	    if (touchFlag[i] == FALSE) {
		    if (size.width<4 || size.height<4) {
			    [self setRainWith:i];
		    }
			
		    else {
			    [rainView[i] setFrame:CGRectMake(rainView[i].frame.origin.x, yy, size.width,size.height)];
				
		    }
			
	    }	
		
	}
	
}



-(void)setRainWith:(int)imageViewID;
{
	int rainPicID = [self getRainID];
	CGPoint rainsOffset = [self getRainOffset];
	[rainView[imageViewID] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rain%d.png",rainPicID]]];
	[rainView[imageViewID] setTag:rainPicID];
	[rainView[imageViewID] setFrame:CGRectMake(rainsOffset.x, rainsOffset.y, rainView[imageViewID].image.size.width, rainView[imageViewID].image.size.height)];
	
}


-(int)getRainID;
{
	int rainsID = arc4random()%RAIN_TYPE +1;
	return rainsID;
}

-(CGPoint)getRainOffset;
{		
	CGPoint rainsOffset;
	if (UIInterfaceOrientationIsPortrait(screenOrientation)){
		rainsOffset = CGPointMake(arc4random()%768, arc4random()%1024);
	}
	else {
		rainsOffset = CGPointMake(arc4random()%1024, arc4random()%768);
	}
	
	return rainsOffset;
}


#pragma mark SetRainLine------------
/*
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
	
	int imageTag = [[anim valueForKey:@"animateTransform"] intValue];
	[self setRianLineWith:imageTag];
	
}

-(void)doAnimationOn:(int)imageTag;
{
	
	//if (rainLineFlag == TRUE) {
		NSString * aa=[NSString stringWithFormat:@"%d",imageTag];
		CAKeyframeAnimation * animation3D = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
		int temp = arc4random()%10 + 10;
		[animation3D setValue:aa forKey:@"animateTransform"];
		[animation3D setDuration:20/pow(temp, 2)];
		[animation3D setDelegate:self];
		[rainLineView[imageTag].layer addAnimation:animation3D forKey:@"animateTransform"];
	//	NSLog(@"rainLine");
	//}
}



-(void)setRianLineWith:(int)imageTag;
{
	
	CGPoint rainsOffset = [self getRainLineOffset];
	[rainLineView[imageTag] setFrame:CGRectMake(rainsOffset.x, rainsOffset.y, 0.9*rainLineView[imageTag].image.size.width, rainLineView[imageTag].image.size.height)];
	[self doAnimationOn:imageTag];
	
}



-(void)initRainLine;
{
	for (int i = 0; i< RAINLINE_COUNT; i++) {		
		rainLineView[i] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rain_line.png"]];
		rainLineView[i].tag = i;
		[rainLineView[i] setAlpha:0.35];
		[self addSubview:rainLineView[i]];
		[rainLineView[i] release];
	}	
	
}



-(CGPoint)getRainLineOffset;
{
	CGPoint rainsOffset;
     if (UIInterfaceOrientationIsPortrait(screenOrientation)){
     rainsOffset = CGPointMake(arc4random()%768, arc4random()%1024);
     }
     else {
	rainsOffset = CGPointMake(arc4random()%1024, arc4random()%768);
     }
	return rainsOffset;
}
*/
#pragma mark ----------------------





- (void)dealloc {
	[backgroundImageView release];
	if (rainTimer != nil) {
		[rainTimer invalidate];
	}
	[rainTimer release];
    [super dealloc];
}


@end
