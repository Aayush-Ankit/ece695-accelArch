cd ../..
nvcc -o bin/jacobi-gpu1-coalesced jacobi-gpu-coalesced.cu

# input 256.txt with varying block sizes
nvprof --log-file logs/titan-xp/jacobi-gpu1-coalesced/i256-b64.log ./bin/jacobi-gpu1-coalesced 256.txt 64

# input 1024.txt with varying block sizes
nvprof --log-file logs/titan-xp/jacobi-gpu1-coalesced/i1024-b64.log ./bin/jacobi-gpu1-coalesced 1024.txt 64

# input 5120.txt with varying block sizes
nvprof --log-file logs/titan-xp/jacobi-gpu1-coalesced/i5120-b64.log ./bin/jacobi-gpu1-coalesced 5120.txt 64
