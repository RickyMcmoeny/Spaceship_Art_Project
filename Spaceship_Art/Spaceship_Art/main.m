//
//  main.m
//  Spaceship_Art
//
//  Created by Jacob on 7/1/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, const char * argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
