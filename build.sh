#!/bin/bash
# Build basalt from concatenated sources (matching monorepo build_basalt.sh)
set -euo pipefail
OUT=/tmp/basalt_build
mkdir -p "$OUT"
COMBINED=$OUT/basalt_combined.salt
echo "// Auto-generated build file for Basalt" > "$COMBINED"
echo "package basalt.main" >> "$COMBINED"
echo "use std.core.ptr.Ptr" >> "$COMBINED"
echo "" >> "$COMBINED"
for f in basalt/kernels.salt basalt/sampler.salt basalt/quant.salt basalt/transformer.salt basalt/model_loader.salt basalt/tokenizer.salt basalt/main.salt; do
    echo "// ---- Module: $(basename $f) ----" >> "$COMBINED"
    grep -v "^package " "$f" | grep -v "^use basalt\." >> "$COMBINED"
    echo "" >> "$COMBINED"
done
${SALTC:-saltc} ${EXTRA_FLAGS:-} "$COMBINED" --lib -o basalt 2>&1
