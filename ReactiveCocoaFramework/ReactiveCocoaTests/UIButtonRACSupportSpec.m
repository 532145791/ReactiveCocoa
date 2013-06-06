//
//  UIButtonRACSupportSpec.m
//  ReactiveCocoa
//
//  Created by Ash Furrow on 2013-06-06.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import <objc/message.h>
#import "UIButton+RACCommandSupport.h"
#import "RACCommand.h"
#import "RACDisposable.h"

SpecBegin(UIButtonRACSupport)

describe(@"UIButton", ^{
	__block UIButton *button;
	
	beforeEach(^{
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0, 100, 100);
		expect(button).notTo.beNil();
	});
	
	it(@"should bind the button's enabledness to the command's canExecute", ^{
		button.rac_command = [RACCommand commandWithCanExecuteSignal:[RACSignal return:@NO]];
		expect([button isEnabled]).to.beFalsy();
		
		button.rac_command = [RACCommand commandWithCanExecuteSignal:[RACSignal return:@YES]];
		expect([button isEnabled]).to.beTruthy();
	});
	
	it(@"should execute the button's command when touched", ^{
		RACCommand *command = [RACCommand command];
		
		__block BOOL executed = NO;
		[command subscribeNext:^(id sender) {
			expect(sender).to.equal(button);
			executed = YES;
		}];
		
		button.rac_command = command;
		
		[button sendActionsForControlEvents:UIControlEventTouchUpInside];
		
		expect(executed).to.beTruthy();
	});
});

SpecEnd
