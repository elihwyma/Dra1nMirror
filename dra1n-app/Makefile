export TARGET = iphone:13.3:10.0
export ARCHS = arm64

INSTALL_TARGET_PROCESSES = Dra1n

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = dra1n

dra1n_XCODEFLAGS = SWIFT_OLD_RPATH=/usr/lib/libswift/stable
dra1n_XCODE_SCHEME = dra1n
dra1n_CODESIGN_FLAGS = -Sdra1nEntitlements.xml

include $(THEOS_MAKE_PATH)/xcodeproj.mk