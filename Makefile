$(shell mkdir ./obj 2>/dev/null )
# built-in rules variable ------------------------------------------------------------
CC = arm-none-eabi-gcc
AR = arm-none-eabi-ar

ifneq "$(origin CFLAGS)" "environment"
CFLAGS = -g -mtune=cortex-m4 -mthumb -std=c99 -fdata-sections -mfloat-abi=soft \
 -march=armv7-m -mthumb-interwork -mapcs-frame
endif
ifneq "$(origin CPPFLAGS)" "environment"
CPPFLAGS = -DUSE_STDPERIPH_DRIVER -DSTM32F40XX -DSTM32F407xx
endif

TARGET_ARCH = 
OUTPUT_OPTION = -o ./obj/$@
ARFLAGS = rcs
CPPFLAGS += $(INCLUDEDIR)
# ------------------------------------------------------------------------------------

SRCDIR = ./STM32F4xx_StdPeriph_Driver/src 
SRCDIR += ./CMSIS/Device/ST/STM32F4xx/Source/Templates

INCDIR = $(shell find -name *stm32f4*.h)
INCDIR += $(shell find -name core*.h)
INCDIR :=$(dir $(INCDIR))
INCDIR :=$(sort $(INCDIR))


VPATH = $(SRCDIR) $(INCDIR)

vpath %.a ./obj
vpath %.o ./obj
vpath %.d ./obj


INCLUDEDIR = $(addprefix -I,$(INCDIR))

SRC = $(shell ls $(SRCDIR))
SRC := $(filter %.c,$(SRC))
SRC := $(filter-out %fmc.c,$(SRC))
STOBJ = $(subst .c,.o,$(SRC))
DEPENDS = $(subst .c,.d,$(SRC))

all:libst.a

sinclude $(SRC:%.c=obj/%.d)


libst.a:$(STOBJ)
	$(AR) $(ARFLAGS) ./obj/$@ ./obj/*.o 

obj/%.d:%.c 
	$(CC) -M $(CPPFLAGS) $< >> $@

.PHONY:clean all distclean

clean:
	@-rm -rf obj/*.o obj/*.a
	@echo "clean stlib"
distclean:
	@-rm -rf obj
	@echo "clean stlib"