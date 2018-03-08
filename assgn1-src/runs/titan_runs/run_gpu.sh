cd ../..
nvcc -o bin/jacobi-gpu1-2kernel jacobi-gpu.cu

# input 256.txt with varying block sizes
nvprof --log-file logs/titan-xp/gpu-1-2kernel/i256-b64.log ./bin/jacobi-gpu1-2kernel 256.txt 64

# input 1024.txt with varying block sizes
nvprof --log-file logs/titan-xp/gpu-1-2kernel/i1024-b64.log ./bin/jacobi-gpu1-2kernel 1024.txt 64

# input 5120.txt with varying block sizes
nvprof --log-file logs/titan-xp/gpu-1-2kernel/i5120-b64.log ./bin/jacobi-gpu1-2kernel 5120.txt 64
