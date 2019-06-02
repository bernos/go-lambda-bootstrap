AWS_BUCKET     ?= cf-templates-blah-ap-southeast-2
AWS_REGION     ?= ap-southeast-2
AWS_STACK_NAME := golang-lambda

build:
	mkdir -p dist
	GOOS=linux go build -o dist/customresource main.go

package: build
	aws cloudformation package             \
		--template-file stack.yml          \
		--region $(AWS_REGION)             \
        --s3-bucket $(AWS_BUCKET)          \
        --output-template-file package.yml

deploy: package
	aws cloudformation deploy         \
		--template-file package.yml   \
		--region $(AWS_REGION)        \
		--capabilities CAPABILITY_IAM \
		--stack-name $(AWS_STACK_NAME)

example:
	aws cloudformation deploy         \
		--template-file example.yml   \
		--region $(AWS_REGION)        \
		--capabilities CAPABILITY_IAM \
		--stack-name example-$(AWS_STACK_NAME)
