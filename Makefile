SALTC ?= saltc

build:
	$(SALTC) --pkg . basalt/main.salt --lib -o /tmp/basalt.mlir

test:
	$(SALTC) tests/test_kernels.salt --lib -o /dev/null

clean:
	rm -f /tmp/basalt.mlir *.mlir

.PHONY: build test clean
