# Run benchmark with different rfc configs
source ../../../gpgpu-sim/setup_environment debug

# config - RFC with 1 entry per warp
printf "Running config 1.....\n\n"
cp configs/gpgpusim_rfc1entry.config gpgpusim.config
./BFS2 graph4096.txt > results/trace_1entry.txt

# config - RFC with 2 entry per warp
printf "Running config 2.....\n\n"
cp configs/gpgpusim_rfc2entry.config gpgpusim.config
./BFS2 graph4096.txt > results/trace_2entry.txt

# config - RFC with 4 entry per warp
printf "Running config 3.....\n\n"
cp configs/gpgpusim_rfc4entry.config gpgpusim.config
./BFS2 graph4096.txt > results/trace_4entry.txt

# config - RFC with 6 entry per warp
printf "Running config 4.....\n\n"
cp configs/gpgpusim_rfc6entry.config gpgpusim.config
./BFS2 graph4096.txt > results/trace_6entry.txt

# config - RFC with 8 entry per warp
printf "Running config 5.....\n\n"
cp configs/gpgpusim_rfc8entry.config gpgpusim.config
./BFS2 graph4096.txt > results/trace_8entry.txt

# cleanup
rm _cuobjdump_*
rm *log
