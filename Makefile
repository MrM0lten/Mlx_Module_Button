# Makeconfig
MAKEFLAGS = --no-print-directory

# Compiler
CC		:=	cc
CFLAGS	:= -g

# Targets
TARGET	:= libbutton.a

# Dependencies
LIB_DEPS := libmlx42.a libglfw.a
LIB_DIRS := ../MLX42/build

# Includes
INC_DIRS = $(wildcard ../*/*/*/*/) $(wildcard ../*/*/*/) $(wildcard ../*/*/) $(wildcard ../*/)

# Directories
SRC_DIR := src
BLD_DIR	:= build

# =====DO NOT EDIT BELOW THIS LINE=====

# Sources, Objects and Includes
SRC := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*/*.c)
OBJ := $(addprefix $(BLD_DIR)/, $(SRC:.c=.o))

E_INC_DIRS	= $(foreach dir, $(INC_DIRS), $(addprefix -I./, $(dir)))
E_LIB_DIRS	= $(foreach dir, $(LIB_DIRS), $(addprefix -L./, $(dir)))
E_LIB_DEPS	:= $(foreach lib, $(LIB_DEPS), $(addprefix -l, $(subst .a, , $(subst lib, , $(lib)))))

# =======BUILD=======
all: bashscript

compile: $(TARGET)

# Linker
$(TARGET): $(OBJ)
	@ar -rcs $(TARGET) $(OBJ)

# Compiler
$(BLD_DIR)/%.o: %.c
	@make build_mlx
	@mkdir -p $(BLD_DIR)
	@mkdir -p $(@D)
	$(CC) -c $(CFLAGS) $< $(E_INC_DIRS) -o $@
	@printf "Compiling $@: $(GREEN)OK!\n$(DEF_COLOR)"

reval:
	INC = $(foreach dir, $(wildcard ../*/*/*/*/) $(wildcard ../*/*/*/) $(wildcard ../*/*/) $(wildcard ../*/), $(addprefix -I./, $(dir)))

# Commands
fclean:
	@rm -rf $(BLD_DIR) $(TARGET)
	rm -rf ../MLX42

clean:
	@rm -rf $(BLD_DIR)

re: fclean all

run: $(TARGET)
	make && ./$(TARGET)

print-%:
	@echo $* = $($*)

build_mlx:
	@if ! [ -d "../MLX42" ]; then make install_mlx; fi

install_mlx:
	cd ..; git clone -v https://github.com/codam-coding-college/MLX42.git
	cd ../MLX42; cmake -B build; cmake --build build -j4

test:
	echo $(E_INC_DIRS)

bashscript:
	@touch run.sh
	@chmod 777 run.sh
	@echo make build_mlx > run.sh
	@echo make compile >> run.sh
	@./run.sh
	@rm -f run.sh



# Colors
DEF_COLOR	=	\033[0;39m
RED			=	\033[1;31m
GREEN		=	\033[1;32m
YELLOW		=	\033[1;33m
BLUE		=	\033[1;34m
MAGENTA		=	\033[1;35m
CYAN		=	\033[1;36m
WHITE		=	\033[1;37m

