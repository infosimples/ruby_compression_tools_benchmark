# Ruby compression algorithms benchmark

This repo provides a comparison between different implementations of compression
algorithms for Ruby.

The compared algorithms are:
- Zlib (used in gzip, present in Ruby Zlib class)
- bzip2 (https://github.com/chewi/bzip2-ruby)
- LZ4 (https://github.com/komiya-atsushi/lz4-ruby)
- Facebook Zstandard (https://github.com/SpringMT/zstd-ruby)
- Google Snappy (https://github.com/miyucy/snappy)
- Google Brotli (https://github.com/miyucy/brotli)

## Usage
1. `bundle install`
2. `bundle exec ruby benchmark.rb path_to_directory_containing_many_files`


## Results
Ruby 2.5.1 was used.

Using ~2200 json files, the following result was obtained:
```
The selected files use 24364998 bytes while uncompressed

Time to compress the files
                                          user     system      total        real
GZip (speed mode)                     0.214544   0.010289   0.224833 (  0.225351)
GZip (normal mode)                    0.366193   0.010186   0.376379 (  0.377600)
GZip (best compression mode)          0.631542   0.006784   0.638326 (  0.638841)
bzip2                                 2.523179   0.008748   2.531927 (  2.534006)
LZ4                                   0.057346   0.003333   0.060679 (  0.060926)
Zstandard (speed mode)                0.108911   0.003164   0.112075 (  0.112458)
Zstandard (normal mode)               0.592184   0.009943   0.602127 (  0.602553)
Zstandard (best compression mode)     8.428290   0.022141   8.450431 (  8.455273)
Snappy                                0.065599   0.005470   0.071069 (  0.071243)
Brotli                               31.406081   0.103673  31.509754 ( 31.525019)

Memory used by the compressed files
GZip (speed mode)                     5061936 bytes (20.78 %)
GZip (normal mode)                    4414613 bytes (18.12 %)
GZip (best compression mode)          4357155 bytes (17.88 %)
LZ4                                   6636072 bytes (27.24 %)
bzip2                                 4358347 bytes (17.89 %)
Zstandard (speed mode)                4637062 bytes (19.03 %)
Zstandard (normal mode)               4297081 bytes (17.64 %)
Zstandard (compression mode)          4199845 bytes (17.24 %)
Snappy                                6779059 bytes (27.82 %)
Brotli                                3786120 bytes (15.54 %)

Time to decompress the files
                                          user     system      total        real
GZip (speed mode)                     0.109329   0.009088   0.118417 (  0.118505)
GZip (normal mode)                    0.101224   0.015791   0.117015 (  0.117107)
GZip (best compression mode)          0.097965   0.005228   0.103193 (  0.103320)
bzip2                                 0.607900   0.007855   0.615755 (  0.616035)
LZ4                                   0.026262   0.002489   0.028751 (  0.028802)
Zstandard (speed mode)                0.060795   0.006725   0.067520 (  0.067669)
Zstandard (normal mode)               0.051863   0.007084   0.058947 (  0.059125)
Zstandard (best compression mode)     0.055526   0.007335   0.062861 (  0.062973)
Snappy                                0.034343   0.017605   0.051948 (  0.052048)
Brotli                                0.114347   0.006263   0.120610 (  0.120759)
```
