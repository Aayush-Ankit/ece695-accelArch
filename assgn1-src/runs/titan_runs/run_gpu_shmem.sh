cd ../..
nvcc -o bin/jacobi-gpu1-shmem jacobi-gpu-shmem.cu

# input 256.txt with varying block sizes
nvprof --log-file logs/titan-xp/jacobi-gpu1-shmem/i256-b64.log ./bin/jacobi-gpu1-shmem 256.txt 64

# input 1024.txt with varying block sizes
nvprof --log-file logs/titan-xp/jacobi-gpu1-shmem/i1024-b64.log ./bin/jacobi-gpu1-shmem 1024.txt 64

# input 5120.txt with varying block sizes
nvprof --log-file logs/titan-xp/jacobi-gpu1-shmem/i5120-b64.log ./bin/jacobi-gpu1-shmem 5120.txt 64
