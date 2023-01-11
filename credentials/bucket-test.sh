## Create bucket
aws s3api create-bucket --bucket phd-hello-bucket

## Send file to bucket
aws s3 cp hello.txt s3://phd-hello-bucket

## Remove * files from bucket
aws s3 rm s3://phd-hello-bucket --recursive

## Delete bucket
aws s3api delete-bucket --bucket phd-hello-bucket
