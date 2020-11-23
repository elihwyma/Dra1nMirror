export ARCHS = arm64 arm64e
export TARGET=iphone:clang:13.3:13.3
 
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = libdra1n
libdra1n_FILES = lib.xm
libdra1n_LIBRARIES = MobileGestalt rocketbootstrap
libdra1n_FRAMEWORKS = UIKit Foundation IOKit
libdra1n_CFLAGS = -fobjc-arc 
libdra1n_EXTRA_FRAMEWORKS = Cephei 
libdra1n_CODESIGN_FLAGS = -Sent.plist
libdra1n_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
