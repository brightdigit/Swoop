#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PACKAGE_DIR="${SCRIPT_DIR}/.."

export MINT_PATH="$PWD/.mint"
MINT_ARGS="-n -m ../../Mintfile --silent"
MINT_RUN="/opt/homebrew/bin/mint run $MINT_ARGS"

pushd $PACKAGE_DIR

$MINT_RUN swift-openapi-generator generate \
	--output-directory Sources/DockerOpenAPITypes --access-modifier package \
	--mode types \
	OpenAPI/Docker/openapi.yaml

$MINT_RUN swift-openapi-generator generate \
	--output-directory Sources/DockerOpenAPIClient --access-modifier package \
	--additional-import DockerOpenAPITypes \
	--mode client \
	OpenAPI/Docker/openapi.yaml
	
	
#protoc --swift_opt=Visibility=package --swift_out=Sources/BitnessOpenAPITypes ProtoBuf/*

popd 
# protoc --plugin=node_modules/ts-proto/protoc-gen-ts_proto --ts_proto_out=./src/protobuf --ts_proto_opt=esModuleInterop=true -I=../Packages/Bitness/ProtoBuf/  ../Packages/Bitness/ProtoBuf/StreamData.proto
