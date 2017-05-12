$(shell mkdir ./obj 2>/dev/null )

include ./makefile.common

SRCDIR = ./STM32F4xx_StdPeriph_Driver/src 
SRCDIR += ./CMSIS/Device/ST/STM32F4xx/Source/Templates
INCDIR = ./STM32F4xx_StdPeriph_Driver/inc 
INCDIR += ./CMSIS/Device/ST/STM32F4xx/Include
INCDIR += ./CMSIS/Include

VPATH = $(SRCDIR) $(INCDIR)

# vpath %.h ./STM32F4xx_StdPeriph_Driver/inc
# vpath %.c ./STM32F4xx_StdPeriph_Driver/src
# vpath %.h ./CMSIS/Device/ST/STM32F4xx/Include
# vpath %.c ./CMSIS/Device/ST/STM32F4xx/Source
vpath %.a ./obj
vpath %.o ./obj

# INCLUDEDIR += -I ./STM32F4xx_StdPeriph_Driver/inc
# INCLUDEDIR += -I ./CMSIS/Device/ST/STM32F4xx/Include

INCLUDEDIR = $(addprefix -I,$(INCDIR))

SRC = $(shell ls $(SRCDIR))
SRC := $(filter %.c,$(SRC))
SRC := $(filter-out %fmc.c,$(SRC))
STOBJ = $(subst .c,.o,$(SRC))

# test:
# 	@echo $(STOBJ)

libst.a:$(STOBJ)
	$(AR) rcs ./obj/$@ ./obj/*.o 
$(STOBJ):%.o:%.c 
	$(CC)  $(STFLAGS) $^ -o ./obj/$@

# # %.d:%.c 
# # 	$(CC) $(INCLUDEDIR) -M $< >./obj/$@

.PHONY:clean
# #.INTERMEDIATE:./obj/*.o ./obj/*d

clean:
	-rm -rf obj

