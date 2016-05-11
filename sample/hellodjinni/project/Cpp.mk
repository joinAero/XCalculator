MD := -mkdir -p
RD := -rm -rf
RM := -rm -f

CC := gcc
CXX := g++
CXXFLAGS := -std=c++11 -Wall

ifdef DEBUG
CXXFLAGS += -g -DDEBUG
else
CXXFLAGS += -O2 -DNDEBUG
endif

OUT_DIR ?= build
CPP_OUT ?= $(OUT_DIR)/cpp

CPP_INCLUDES := \
	../generated-src/cpp \
	../src/cpp
CPP_SOURCES := \
	../src/cpp/hello_djinni_impl.cpp \
	cpp/HelloDjinni/HelloDjinni/main.cpp
CPP_TARGET := $(CPP_OUT)/HelloDjinni


all: cpp_pro

clean:
	$(RD) $(CPP_OUT)/

cpp_pro: $(CPP_SOURCES)
	@echo "\033[1;35;47mBuild cpp project...\033[0m"
	@$(MD) $(CPP_OUT)
	$(CXX) $(CXXFLAGS) $(CPP_SOURCES) -o $(CPP_TARGET) \
		$(foreach d, $(CPP_INCLUDES), -I$d)
	@echo "\033[32mOutput:\033[0m\n$(CPP_TARGET)"
	@echo "\033[32mRunning:\033[0m"
	@$(CPP_TARGET)

.PHONY: cpp_pro clean all
