package main

import (
	"context"

	"github.com/aws/aws-lambda-go/cfn"
	"github.com/aws/aws-lambda-go/lambda"
)

func echoResource(ctx context.Context, event cfn.Event) (physicalResourceID string, data map[string]interface{}, err error) {
	v, _ := event.ResourceProperties["Echo"].(string)

	data = map[string]interface{}{
		"Echo": v,
	}

	return
}

func main() {
	lambda.Start(cfn.LambdaWrap(echoResource))
}
