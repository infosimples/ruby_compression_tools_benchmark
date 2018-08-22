require 'benchmark'
require 'zlib'
require 'bzip2'
require 'lz4-ruby'
require 'zstd-ruby'
require 'snappy'
require 'brotli'

# Load all files to memory to avoid disk usage during benchmark
files = []
Dir.glob("#{ARGV.first}/**/*.json").each do |path|
  files << File.read(path)
end

# Prints current memory use
uncompressed_memory_usage = files.join.bytesize
puts
puts "The selected files use #{uncompressed_memory_usage} bytes while uncompressed"
puts

# Each compression algorithm has its own array of compressed files
gzip_best_speed = []
gzip_normal = []
gzip_best_compression = []
bzip2 = []
lz4 = []
zstd_best_speed = []
zstd_normal = []
zstd_best_compression = []
snappy = []
brotli = []

# Compress time benchmark
puts 'Time to compress the files'
Benchmark.bm(35) do |x|
  x.report('GZip (speed mode)') do
    files.each do |file_string|
      gzip_best_speed << Zlib::Deflate.deflate(file_string.dup, Zlib::BEST_SPEED)
    end
  end

  x.report('GZip (normal mode)') do
    files.each do |file_string|
      gzip_normal << Zlib::Deflate.deflate(file_string.dup)
    end
  end

  x.report('GZip (best compression mode)') do
    files.each do |file_string|
      gzip_best_compression << Zlib::Deflate.deflate(file_string.dup, Zlib::BEST_COMPRESSION)
    end
  end

  x.report('bzip2') do
    files.each do |file_string|
      bzip2 << Bzip2.compress(file_string)
    end
  end

  x.report('LZ4') do
    files.each do |file_string|
      lz4 << LZ4::compress(file_string.dup)
    end
  end

  x.report('Zstandard (speed mode)') do
    files.each do |file_string|
      zstd_best_speed << Zstd.compress(file_string.dup, 0)
    end
  end

  x.report('Zstandard (normal mode)') do
    files.each do |file_string|
      zstd_normal << Zstd.compress(file_string.dup, 10)
    end
  end

  x.report('Zstandard (best compression mode)') do
    files.each do |file_string|
      zstd_best_compression << Zstd.compress(file_string.dup, 22)
    end
  end

  x.report('Snappy') do
    files.each do |file_string|
      snappy << Snappy.deflate(file_string.dup)
    end
  end

  x.report('Brotli') do
    files.each do |file_string|
      brotli << Brotli.deflate(file_string.dup)
    end
  end
end
puts

# Gets the memory size (in bytes) of each compressed array
gzip_best_speed_compressed_size = gzip_best_speed.join.bytesize
gzip_normal_compressed_size = gzip_normal.join.bytesize
gzip_best_compression_compressed_size = gzip_best_compression.join.bytesize
lz4_compressed_size = lz4.join.bytesize
bzip2_compressed_size = bzip2.join.bytesize
zstd_best_speed_compressed_size = zstd_best_speed.join.bytesize
zstd_normal_compressed_size = zstd_normal.join.bytesize
zstd_best_compression_compressed_size = zstd_best_compression.join.bytesize
brotli_compressed_size = brotli.join.bytesize
snappy_compressed_size = snappy.join.bytesize

# Prints the memory used after compression on each algorithm
puts 'Memory used by the compressed files'
puts "GZip (speed mode)                     #{gzip_best_speed_compressed_size} bytes (#{(100.0 * gzip_best_speed_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "GZip (normal mode)                    #{gzip_normal_compressed_size} bytes (#{(100.0 * gzip_normal_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "GZip (best compression mode)          #{gzip_best_compression_compressed_size} bytes (#{(100.0 * gzip_best_compression_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "LZ4                                   #{lz4_compressed_size} bytes (#{(100.0 * lz4_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "bzip2                                 #{bzip2_compressed_size} bytes (#{(100.0 * bzip2_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "Zstandard (speed mode)                #{zstd_best_speed_compressed_size} bytes (#{(100.0 * zstd_best_speed_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "Zstandard (normal mode)               #{zstd_normal_compressed_size} bytes (#{(100.0 * zstd_normal_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "Zstandard (compression mode)          #{zstd_best_compression_compressed_size} bytes (#{(100.0 * zstd_best_compression_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "Snappy                                #{snappy_compressed_size} bytes (#{(100.0 * snappy_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts "Brotli                                #{brotli_compressed_size} bytes (#{(100.0 * brotli_compressed_size / uncompressed_memory_usage).round(2)} %)"
puts

# Decompress time benchmark
puts 'Time to decompress the files'
Benchmark.bm(35) do |x|
  x.report('GZip (speed mode)') do
    gzip_best_speed.each do |compressed_data|
      Zlib::Inflate.inflate(compressed_data)
    end
  end

  x.report('GZip (normal mode)') do
    gzip_normal.each do |compressed_data|
      Zlib::Inflate.inflate(compressed_data)
    end
  end

  x.report('GZip (best compression mode)') do
    gzip_best_compression.each do |compressed_data|
      Zlib::Inflate.inflate(compressed_data)
    end
  end

  x.report('bzip2') do
    bzip2.each do |compressed_data|
      Bzip2.uncompress(compressed_data)
    end
  end

  x.report('LZ4') do
    lz4.each do |compressed_data|
      LZ4::uncompress(compressed_data)
    end
  end

  x.report('Zstandard (speed mode)') do
    zstd_best_speed.each do |compressed_data|
      Zstd.decompress(compressed_data)
    end
  end

  x.report('Zstandard (normal mode)') do
    zstd_normal.each do |compressed_data|
      Zstd.decompress(compressed_data)
    end
  end

  x.report('Zstandard (best compression mode)') do
    zstd_best_compression.each do |compressed_data|
      Zstd.decompress(compressed_data)
    end
  end

  x.report('Snappy') do
    snappy.each do |compressed_data|
      Snappy.inflate(compressed_data)
    end
  end

  x.report('Brotli') do
    brotli.each do |compressed_data|
      Brotli.inflate(compressed_data)
    end
  end
end
puts
