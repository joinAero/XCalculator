#include "hello_djinni_impl.hpp"
#include <string>

using namespace hellodjinni;

std::shared_ptr<HelloDjinni> HelloDjinni::create() {
    return std::make_shared<HelloDjinniImpl>();
}

HelloDjinniImpl::HelloDjinniImpl() {
}

std::string HelloDjinniImpl::get_hello_djinni() {
    std::string result = "Hello Djinni! ";

    time_t t = time(0);
    tm now = *localtime(&t);

    char tm_desc[200] = {0};
    if (strftime(tm_desc, sizeof(tm_desc)-1, "%r", &now)>0) {
        result += tm_desc;
    }

    return result;
}
