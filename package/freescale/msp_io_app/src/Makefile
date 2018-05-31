#Target file name.
TARGET	:= msp_io_app

#Compiler path.
CC=$(CROSS_COMPILE)gcc

#Include path.
INCLUDE +=  -I staging_dir_arm/usr/include

#Link path (libargp.a).
LIB :=  -largp
#Library path (libz.a).
LIB +=  -lz

all: $(TARGET) 
$(TARGET): msp_io_app.c sw_uart.c
	$(CC) msp_io_app.c $(INCLUDE) $(EXTRA_CFLAGS) $(EXTRA_LDFLAGS) $(LIB) -o $(TARGET) sw_uart.c -lpthread

install:$(TARGET)
	cp $(TARGET) $(PKG_INSTALL_DIR)

clean:
	rm -f $(TARGET)
