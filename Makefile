AWS_BUCKET     ?= cf-templates-blah-ap-southeast-2
AWS_REGION     ?= ap-southeast-2
AWS_STACK_NAME := golang-lambda

DIST_DIR := dist
BIN      := $(DIST_DIR)/handler
SRC      := $(shell find . -type f \( -name '*.go' -o -name 'go.*' \))

TEMPLATE_FILE     := stack.yml
PACKAGED_TEMPLATE := $(DIST_DIR)/package.yml

clean:
	rm -rf $(DIST_DIR)

test: $(SRC)
	go test ./...

deploy: $(PACKAGED_TEMPLATE)
	aws cloudformation deploy         \
		--template-file $<            \
		--region $(AWS_REGION)        \
		--capabilities CAPABILITY_IAM \
		--stack-name $(AWS_STACK_NAME)

delete:
	aws cloudformation delete-stack   \
		--region $(AWS_REGION)        \
		--stack-name $(AWS_STACK_NAME)

$(PACKAGED_TEMPLATE): $(BIN)
	aws cloudformation package             \
		--template-file $(TEMPLATE_FILE)   \
		--region $(AWS_REGION)             \
        --s3-bucket $(AWS_BUCKET)          \
        --output-template $@

$(BIN): test
	mkdir -p $(@D)
	GOOS=linux go build -o $@ main.go

.PHONY: clean deploy delete test
