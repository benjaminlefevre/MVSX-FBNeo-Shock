#Setup toolchain paths
BINPATH := ../toolchain-mvsx/arm-2011.09/bin

CC          := ${BINPATH}/arm-none-linux-gnueabi-gcc
CXX       := ${BINPATH}/arm-none-linux-gnueabi-g++
STRIP	:= ${BINPATH}/arm-none-linux-gnueabi-strip -s
INCS     := -I./src 
LIBS      := -static -s -lm -lpthread -lrt

MAIN_FBA_DIR               := src
FBA_BURN_DIR               := $(MAIN_FBA_DIR)/burn
FBA_BURN_DRV_DIR   := $(MAIN_FBA_DIR)/burn/drv
FBA_BURNER_DIR          := $(MAIN_FBA_DIR)/burner
FBA_CPU_DIR                   := $(MAIN_FBA_DIR)/cpu
FBA_LIB_DIR                     := $(MAIN_FBA_DIR)/dep/libs
FBA_GENERATED_DIR := $(MAIN_FBA_DIR)/dep/generated
FBA_INTF_DIR 	          := $(MAIN_FBA_DIR)/intf
FBA_INTF_AUDIO_DIR := $(FBA_INTF_DIR)/audio
FBA_INTF_CD_DIR 	  := $(FBA_INTF_DIR)/cd

BUILD_DIR := ./build

TARGET := $(BUILD_DIR)/fba029743

.PHONY: clean

all: $(TARGET)

FBA_BURN_DIRS := $(FBA_BURN_DIR) \
	$(FBA_BURN_DIR)/devices \
	$(FBA_BURN_DIR)/snd \
	$(FBA_BURN_DRV_DIR)/capcom \
	$(FBA_BURN_DRV_DIR)/cave \
	$(FBA_BURN_DRV_DIR)/cps3 \
	$(FBA_BURN_DRV_DIR)/dataeast \
	$(FBA_BURN_DRV_DIR)/galaxian\
	$(FBA_BURN_DRV_DIR)/irem \
	$(FBA_BURN_DRV_DIR)/konami \
	$(FBA_BURN_DRV_DIR)/megadrive \
	$(FBA_BURN_DRV_DIR)/neogeo\
	$(FBA_BURN_DRV_DIR)/pce \
	$(FBA_BURN_DRV_DIR)/pgm\
	$(FBA_BURN_DRV_DIR)/pre90s \
	$(FBA_BURN_DRV_DIR)/psikyo \
	$(FBA_BURN_DRV_DIR)/pst90s \
	$(FBA_BURN_DRV_DIR)/sega \
	$(FBA_BURN_DRV_DIR)/taito \
	$(FBA_BURN_DRV_DIR)/toaplan

FBA_CPU_DIRS := $(FBA_CPU_DIR) \
	$(FBA_CPU_DIR)/adsp2100 \
	$(FBA_CPU_DIR)/arm \
	$(FBA_CPU_DIR)/arm7 \
	$(FBA_CPU_DIR)/h6280 \
	$(FBA_CPU_DIR)/hd6309 \
	$(FBA_CPU_DIR)/i8039 \
	$(FBA_CPU_DIR)/i8051 \
	$(FBA_CPU_DIR)/i8x41 \
	$(FBA_CPU_DIR)/konami \
	$(FBA_CPU_DIR)/m68k \
	$(FBA_CPU_DIR)/mips3 \
	$(FBA_CPU_DIR)/m6502 \
	$(FBA_CPU_DIR)/m6800 \
	$(FBA_CPU_DIR)/m6805 \
	$(FBA_CPU_DIR)/m6809 \
	$(FBA_CPU_DIR)/nec \
	$(FBA_CPU_DIR)/pic16c5x \
	$(FBA_CPU_DIR)/s2650 \
	$(FBA_CPU_DIR)/sh2 \
	$(FBA_CPU_DIR)/tlcs90 \
	$(FBA_CPU_DIR)/tms32010 \
	$(FBA_CPU_DIR)/tms34010 \
	$(FBA_CPU_DIR)/upd7725 \
	$(FBA_CPU_DIR)/upd7810 \
	$(FBA_CPU_DIR)/v60 \
	$(FBA_CPU_DIR)/z180 \
	$(FBA_CPU_DIR)/z80

FBA_ZLIB_DIRS := $(FBA_LIB_DIR)/zlib

FBA_SHOCK_DIR := $(MAIN_FBA_DIR)/burner/shock
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/util
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/core
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/core/mvsx
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/font
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/ui
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/ui/render
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/ui/states
FBA_SHOCK_DIR += $(MAIN_FBA_DIR)/burner/shock/input

FBA_SRC_DIRS := $(FBA_BURNER_DIR) $(FBA_BURN_DIRS) $(FBA_CPU_DIRS) $(FBA_BURNER_DIRS)
FBA_SRC_DIRS += $(FBA_INTF_DIR)
FBA_SRC_DIRS += $(FBA_INTF_AUDIO_DIR)
FBA_SRC_DIRS += $(FBA_INTF_CD_DIR)
FBA_SRC_DIRS += $(FBA_ZLIB_DIRS)
FBA_SRC_DIRS += $(FBA_SHOCK_DIR)

FBA_CXXSRCS := $(filter-out $(BURN_BLACKLIST),$(foreach dir,$(FBA_SRC_DIRS),$(wildcard $(dir)/*.cpp)))
FBA_CXXOBJ   := $(FBA_CXXSRCS:%=$(BUILD_DIR)/%.o)

FBA_CSRCS      := $(filter-out $(BURN_BLACKLIST),$(foreach dir,$(FBA_SRC_DIRS),$(wildcard $(dir)/*.c)))
FBA_COBJ   := $(FBA_CSRCS:%=$(BUILD_DIR)/%.o)

OBJS := $(FBA_COBJ) $(FBA_CXXOBJ)

FBA_DEFINES := -DUSE_SPEEDHACKS \
	-DLSB_FIRST\
	-DINLINE="static inline" \
	-DSH2_INLINE="static inline"\
	-DMVSX

INCDIRS := \
	-I$(FBA_BURNER_DIR) \
	-I$(FBA_BURN_DIR) \
	-I$(FBA_BURN_DIR)/snd \
	-I$(FBA_BURN_DIR)/devices \
	-I$(FBA_CPU_DIR) \
	-I$(FBA_CPU_DIR)/i8039 \
	-I$(FBA_CPU_DIR)/i8051 \
	-I$(FBA_CPU_DIR)/tms32010 \
	-I$(FBA_CPU_DIR)/i8x41 \
	-I$(FBA_CPU_DIR)/m6805 \
	-I$(FBA_CPU_DIR)/v60 \
	-I$(FBA_CPU_DIR)/upd7810 \
	-I$(FBA_CPU_DIR)/upd7725 \
	-I$(FBA_CPU_DIR)/z180 \
	-I$(FBA_CPU_DIR)/z80 \
	-I$(FBA_LIB_DIR)/zlib \
	-I$(FBA_BURN_DRV_DIR)/capcom \
	-I$(FBA_BURN_DRV_DIR)/dataeast \
	-I$(FBA_BURN_DRV_DIR)/cave \
	-I$(FBA_BURN_DRV_DIR)/neogeo \
	-I$(FBA_BURN_DRV_DIR)/psikyo \
	-I$(FBA_BURN_DRV_DIR)/sega \
	-I$(FBA_BURN_DRV_DIR)/toaplan \
	-I$(FBA_BURN_DRV_DIR)/taito \
	-I$(FBA_BURN_DRV_DIR)/konami \
	-I$(FBA_GENERATED_DIR) \
	-I$(FBA_LIB_DIR) \
	-I$(INCS) \
	-iquote $(FBA_INTF_DIR) \
	-iquote $(FBA_INTF_AUDIO_DIR) \
	-iquote $(FBA_INTF_CD_DIR)

CFLAGS += -O3
CXXFLAGS += -O3

CFLAGS += -fsigned-char
CXXFLAGS += -fsigned-char

WARNINGS_DEFINES = -Wno-write-strings
C_STD_DEFINES = -std=gnu99

CFLAGS += $(C_STD_DEFINES) $(WARNINGS_DEFINES) $(FBA_DEFINES)
CXXFLAGS += $(CXX_STD_DEFINES) $(WARNINGS_DEFINES) $(FBA_DEFINES)

$(TARGET): $(OBJS)
	@echo "LD $@"
	@$(CXX) -o $@ $(OBJS) $(LDFLAGS) $(LIBS)

$(BUILD_DIR)/%.cpp.o: %.cpp
	@echo "CXX $<"
	@mkdir -p $(dir $@)
	@$(CXX) -c -o $@ $< $(CXXFLAGS) $(INCDIRS)

$(BUILD_DIR)/%.c.o: %.c
	@echo "CC $<"
	@mkdir -p $(dir $@)
	@$(CC) -c -o $@ $< $(CFLAGS) $(INCDIRS)

clean:
	rm -f $(TARGET)
	rm -f $(OBJS)