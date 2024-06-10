#!/bin/bash

cd ${projectRootDir}

aws ${ecrSubCommand} get-login-password --region ${awsRegion} | docker login --username AWS --password-stdin ${ecrUrl}

pack build ${imageName}:latest --path . --builder ${builder} --env NODE_ENV="production"

imageTags=(${imageTags}) && for tag in "$${imageTags[@]}";
do
  docker tag ${imageName}:latest ${ecrUrl}/${imageName}:$tag;
  docker push ${ecrUrl}/${imageName}:$tag;
done
