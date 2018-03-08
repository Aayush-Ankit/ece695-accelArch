cd ..
g++ jacobi-serial.cpp -o bin/serial
./bin/serial 8.txt > logs/input-8
./bin/serial 256.txt > logs/input-256
./bin/serial 1024.txt > logs/input-1024
./bin/serial 5120.txt > logs/input-5128
