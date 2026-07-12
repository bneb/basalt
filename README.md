# Basalt

Llama 2 inference in 1,600 lines of [Salt](https://github.com/bneb/salt).
920 tok/s on Apple M4. Z3-verified compute kernels. Compiles to native and WASM.

## Quick Start

```bash
cargo install saltc --git https://github.com/bneb/salt
git clone https://github.com/bneb/basalt.git
cd basalt
make
# Download a model: https://huggingface.co/karpathy/tinyllamas
./basalt stories15M.bin -p "Once upon a time"
```

## Architecture

| Module | Lines | What |
|--------|------|------|
| main.salt | ~450 | CLI, mmap, RoPE, generation loop |
| transformer.salt | ~330 | Llama 2: dual f32/q8 forward pass, on-the-fly dequant |
| kernels.salt | ~230 | Z3-verified compute: RMS norm, softmax, tiled matmul |
| quant.salt | ~150 | q8_0 dequantization (3.77x memory reduction) |
| sampler.salt | ~80 | Token selection: argmax, top-p |
| tokenizer.salt | 179 | BPE tokenizer: load, encode, decode |
| model_loader.salt | ~210 | Binary weight parsing, q8_0 detection |

## Performance

Measured on Apple M4 Pro with `stories15M.bin` (Karpathy's TinyLlama).

| Model | Tok/s | Size |
|-------|-------|------|
| f32 | ~920 | 60.8 MB |
| q8_0 | ~300 | 16.2 MB |

Salt's `@` operator provides automatic cache-tiled matmul beating hand-tuned C
by 3-6% at 2K-4K sizes. See [benchmarks](https://github.com/bneb/salt/blob/main/docs/benchmarks/science-of-measurement.md).

## License

MIT

## Performance Benchmarks

See [Salt Benchmarks](https://github.com/bneb/salt-benchmarks) for Salt vs C/Rust across 36 algorithm problems.

## Built With

[Salt](https://github.com/bneb/salt) — a systems language with Z3-powered compile-time verification.
