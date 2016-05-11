#pragma once

#include "hello_djinni.hpp"

namespace hellodjinni {

class HelloDjinniImpl : public HelloDjinni {
public:
    // Constructor
    HelloDjinniImpl();

    // Our method that returns a string
    std::string get_hello_djinni();
};

}  // namespace hellodjinni
