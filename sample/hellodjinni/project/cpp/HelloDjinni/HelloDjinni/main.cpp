//
//  main.cpp
//  HelloDjinni
//
//  Created by John on 16/5/6.
//  Copyright © 2016年 joinAero. All rights reserved.
//

#include <iostream>
#include "hello_djinni_impl.hpp"

int main(int argc, const char * argv[]) {
    typedef hellodjinni::HelloDjinni HelloDjinni;

    auto hd = HelloDjinni::create();
    auto result = hd->get_hello_djinni();
    std::cout << result << std::endl;

    return 0;
}
