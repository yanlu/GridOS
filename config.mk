#
#通用工程配置文件
#

#
#苹果的平台的交叉编译器
#
ifeq ($(TERM_PROGRAM),Apple_Terminal)
ifeq ($(ARCH),arm)
export GCC_PREFIX=arm-linux-gnueabi-
else ifeq ($(ARCH),mips32)
export GCC_PREFIX=mips64el-linux-
else ifeq ($(ARCH),mips64)
export GCC_PREFIX=mips64el-linux-
else
export GCC_PREFIX=i686-linux-
endif
endif

#
#工具宏
#
CC				= $(GCC_PREFIX)gcc
C++				= $(GCC_PREFIX)g++
AS				= $(GCC_PREFIX)as
AR				= $(GCC_PREFIX)ar
LD				= $(GCC_PREFIX)ld
RES				= fares
CP				= cp
RM				= rm
OBJCOPY			= $(GCC_PREFIX)objcopy

CFLAGS_arm         = -c -O2 -march=armv6k
CFLAGS_i386        = -c -O2 -m32
CFGAGS_MIPS64      = -c -O2 -mabi=64 -mips3 -EL -G0 
CFGAGS_MIPS32      = -c -O2 -mabi=32 -mips32 -EL -G0
CL_INCLUDE         = -I$(MY_BUILD_BASE)/source/libs/common/include -I$(MY_BUILD_BASE)/source/libs/common/include/arch/$(ARCH_DIR)
STD_INCLUDE        = -I$(MY_BUILD_BASE)/include -I$(MY_BUILD_BASE)/include/arch/$(ARCH_DIR)
COMMON_CC_FLAGS    += -Wimplicit-function-declaration -Wall
COMMON_CC_FLAGS    += -fvisibility=hidden

#
#连接选项
#
LDFLAGS				= -L$(SYSTEM_DIR)
ifeq ($(DLL),yes)
LDFLAGS    			+= -shared --entry=_start
COMMON_CC_FLAGS   		+= -fPIC
endif

#
#项目管理文件配置
#
SYSTEM_BUILD_TMP    = $(MY_BUILD_BASE)/build
SYSTEM_DIR          = $(MY_BUILD_BASE)/release/os/$(ARCH)
SYSTEM_DRV_DIR      = $(SYSTEM_DIR)/Drivers
SYSTEM_PACK_DIR     = $(MY_BUILD_BASE)/tools/kpck

#
#编码处理，默认为GBK字符，宽字符的是UNICODE。设置宏"CODE_ENCODE=utf8"可选择utf8的编码
#
ifeq ($(CODE_ENCODE),utf8)
COMMON_CC_FLAGS			+=
else
COMMON_CC_FLAGS			+= -fexec-charset=gbk -finput-charset=gbk -fwide-exec-charset=UCS-2LE
endif

#
#调试处理
#
ifeq ($(DEBUG),YES)
COMMON_CC_FLAGS 		+=-D__DEBUG__=1 -g
endif

#
#编译命令行合成
#
ifeq ($(ARCH),mips64)
	BITS=64
	ARCH_DIR			=mips
	ARCH_LD_FLAGS		=-melf64ltsmip
	ifeq ($(DLL),yes)
	COMMON_CC_FLAGS    += -mabicalls
	else ifeq ($(NORMAL_APP),yes)
	COMMON_CC_FLAGS    += -mabicalls
	else
	COMMON_CC_FLAGS    += -mno-abicalls
	endif
	COMMON_CC_FLAGS		+=$(CFGAGS_MIPS64) $(STD_INCLUDE)

else ifeq ($(ARCH),mips32)
	BITS=32
	ARCH_DIR=mips
	ARCH_LD_FLAGS		=-melf32ltsmip
	ifeq ($(DLL),yes)
	COMMON_CC_FLAGS    += -mabicalls
	else ifeq ($(NORMAL_APP),yes)
	COMMON_CC_FLAGS    += -mabicalls
	else
	COMMON_CC_FLAGS    += -mno-abicalls
	endif
	COMMON_CC_FLAGS +=  $(CFGAGS_MIPS32) $(STD_INCLUDE)

else ifeq ($(ARCH),arm)
	BITS=32
	COMMON_CC_FLAGS +=  $(CFLAGS_arm) $(STD_INCLUDE)
	ARCH_DIR=arm

else
	BITS=32
	ARCH=i386
	COMMON_CC_FLAGS += $(CFLAGS_i386) $(STD_INCLUDE)
	ARCH_DIR=x86
        ARCH_LD_FLAGS=-melf_i386
endif
