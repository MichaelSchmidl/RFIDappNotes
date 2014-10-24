//
//  ViewController.h
//  simpleReaderApp
//
//  Created by Michael Schmidl on 16.10.14.
//  Copyright (c) 2014 Your Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>

@interface ViewController : UIViewController
{
    NSMutableArray *_accessoryList;
    EAAccessory *_accessory;
    EAAccessory *_selectedAccessory;
}


@end

