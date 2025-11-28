#!/bin/bash

cd ${projectRootDir}

aws ${ecrSubCommand} get-login-password --region ${awsRegion} | docker login --username AWS --password-stdin ${ecrUrl}

if [[ -n "$${DOCKERHUB_PASSWORD}" && -n "$${DOCKERHUB_USERNAME}" ]]; then
  echo $${DOCKERHUB_PASSWORD} | docker login --username $${DOCKERHUB_USERNAME} --password-stdin
fi

if [ "${useDockerfile}" = "true" ]; then
  docker build --platform linux/amd64 -t ${imageName}:latest .
else
  pack build ${imageName}:latest --path . --builder ${builder} --env NODE_ENV="production"
fi

imageTags=(${imageTags}) && for tag in "$${imageTags[@]}";
do
  docker tag ${imageName}:latest ${ecrUrl}/${imageName}:$tag;
  docker push ${ecrUrl}/${imageName}:$tag;
done
