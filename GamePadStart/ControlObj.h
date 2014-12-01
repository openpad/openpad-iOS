//
//  ControlObj.h
//  GamePadStart
//
//  Created by Jake Saferstein on 11/10/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlObj : UIView


-(void)load:(NSDictionary *)data withParentView: (UIView*) view;


@property (nonatomic) int type;
@property (nonatomic) int idNum;



@end
