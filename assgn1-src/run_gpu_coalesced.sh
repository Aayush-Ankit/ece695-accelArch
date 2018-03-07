nvcc -o bin/jacobi-gpu1-coalesced jacobi-gpu-coalesced.cu

# input 8.txt with varying block sizes
nvprof --log-file logs/jacobi-gpu1-coalesced/i8-b64.log ./bin/jacobi-gpu1-coalesced 8.txt 64
nvprof --log-file logs/jacobi-gpu1-coalesced/i8-b128.log ./bin/jacobi-gpu1-coalesced 8.txt 128
nvprof --log-file logs/jacobi-gpu1-coalesced/i8-b256.log ./bin/jacobi-gpu1-coalesced 8.txt 256
nvprof --log-file logs/jacobi-gpu1-coalesced/i8-b512.log ./bin/jacobi-gpu1-coalesced 8.txt 512
nvprof --log-file logs/jacobi-gpu1-coalesced/i8-b1024.log ./bin/jacobi-gpu1-coalesced 8.txt 1024

# input 256.txt with varying block sizes
nvprof --log-file logs/jacobi-gpu1-coalesced/i256-b64.log ./bin/jacobi-gpu1-coalesced 256.txt 64
nvprof --log-file logs/jacobi-gpu1-coalesced/i256-b128.log ./bin/jacobi-gpu1-coalesced 256.txt 128
nvprof --log-file logs/jacobi-gpu1-coalesced/i256-b256.log ./bin/jacobi-gpu1-coalesced 256.txt 256
nvprof --log-file logs/jacobi-gpu1-coalesced/i256-b512.log ./bin/jacobi-gpu1-coalesced 256.txt 512
nvprof --log-file logs/jacobi-gpu1-coalesced/i256-b1024.log ./bin/jacobi-gpu1-coalesced 256.txt 1024

# input 1024.txt with varying block sizes
nvprof --log-file logs/jacobi-gpu1-coalesced/i1024-b64.log ./bin/jacobi-gpu1-coalesced 1024.txt 64
nvprof --log-file logs/jacobi-gpu1-coalesced/i1024-b128.log ./bin/jacobi-gpu1-coalesced 1024.txt 128
nvprof --log-file logs/jacobi-gpu1-coalesced/i1024-b256.log ./bin/jacobi-gpu1-coalesced 1024.txt 256
nvprof --log-file logs/jacobi-gpu1-coalesced/i1024-b512.log ./bin/jacobi-gpu1-coalesced 1024.txt 512
nvprof --log-file logs/jacobi-gpu1-coalesced/i1024-b1024.log ./jacobi-gpu1-coalesced 1024.txt 1024

# input 5120.txt with varying block sizes
nvprof --log-file logs/jacobi-gpu1-coalesced/i5120-b64.log ./bin/jacobi-gpu1-coalesced 5120.txt 64
nvprof --log-file logs/jacobi-gpu1-coalesced/i5120-b128.log ./bin/jacobi-gpu1-coalesced 5120.txt 128
nvprof --log-file logs/jacobi-gpu1-coalesced/i5120-b256.log ./bin/jacobi-gpu1-coalesced 5120.txt 256
nvprof --log-file logs/jacobi-gpu1-coalesced/i5120-b512.log ./bin/jacobi-gpu1-coalesced 5120.txt 512
nvprof --log-file logs/jacobi-gpu1-coalesced/i5120-b1024.log ./bin/jacobi-gpu1-coalesced 5120.txt 1024
