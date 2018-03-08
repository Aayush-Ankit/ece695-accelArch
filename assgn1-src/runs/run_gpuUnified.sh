cd ..

nvcc -o bin/jacobi-gpu-unified jacobi-gpuUnified.cu

# input 8.txt with varying block sizes
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i8-b64.log ./bin/jacobi-gpu-unified 8.txt 64
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i8-b128.log ./bin/jacobi-gpu-unified 8.txt 128
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i8-b256.log ./bin/jacobi-gpu-unified 8.txt 256
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i8-b512.log ./bin/jacobi-gpu-unified 8.txt 512
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i8-b1024.log ./bin/jacobi-gpu-unified 8.txt 1024

# input 256.txt with varying block sizes
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i256-b64.log ./bin/jacobi-gpu-unified 256.txt 64
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i256-b128.log ./bin/jacobi-gpu-unified 256.txt 128
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i256-b256.log ./bin/jacobi-gpu-unified 256.txt 256
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i256-b512.log ./bin/jacobi-gpu-unified 256.txt 512
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i256-b1024.log ./bin/jacobi-gpu-unified 256.txt 1024

# input 1024.txt with varying block sizes
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i1024-b64.log ./bin/jacobi-gpu-unified 1024.txt 64
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i1024-b128.log ./bin/jacobi-gpu-unified 1024.txt 128
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i1024-b256.log ./bin/jacobi-gpu-unified 1024.txt 256
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i1024-b512.log ./bin/jacobi-gpu-unified 1024.txt 512
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i1024-b1024.log ./bin/jacobi-gpu-unified 1024.txt 1024

# input 5120.txt with varying block sizes
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i5120-b64.log ./bin/jacobi-gpu-unified 5120.txt 64
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i5120-b128.log ./bin/jacobi-gpu-unified 5120.txt 128
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i5120-b256.log ./bin/jacobi-gpu-unified 5120.txt 256
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i5120-b512.log ./bin/jacobi-gpu-unified 5120.txt 512
nvprof --unified-memory-profiling off --log-file logs/gpu-1-2kernel-Unified/i5120-b1024.log ./bin/jacobi-gpu-unified 5120.txt 1024
