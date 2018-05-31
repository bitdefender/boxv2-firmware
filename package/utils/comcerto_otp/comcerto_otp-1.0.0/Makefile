# build helloworld executable when user executes "make"
helloworld: comcerto_otp.o
	$(CC) $(LDFLAGS) comcerto_otp.o -o comcerto_otp
helloworld.o: comcerto_otp.c
	$(CC) $(CFLAGS) -c comcerto_otp.c

# remove object files and executable when user executes "make clean"
clean:
	rm *.o comcerto_otp
