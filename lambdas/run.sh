# 1- criar arquivo de politicas de segurança
# 2- attach rolê para a lambda
ROLE_NAME=lambda-example
NODEJS_VERSION=nodejs18.x
FUNCTION_NAME=hello-cli
mkdir -p logs

aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://polices.json \
    | tee logs/1.role.log

POLICY_ARN=$(cat logs/1.role.log | jq -r .Role.Arn)

# 3- Criar o arquivo
# 4- zipar o projeto

zip function.zip index.js

aws lambda create-function \
  --function-name $FUNCTION_NAME  \
  --zip-file fileb://function.zip  \
  --handler index.handler  \
  --runtime $NODEJS_VERSION  \
  --role $POLICY_ARN  \
    | tee logs/2.labmda-create.log

slep 1

aws lambda invoke \
    --function-name $FUNCTION_NAME logs/3.lambda-exec.log \
    --log-type Tail \
    --query 'LogResult' \
    --output text | base64 -d


# Atualizar lambda
zip function.zip index.js
aws lambda update-function-code \
    --zip-file fileb://function.zip \
    --function-name $FUNCTION_NAME  \
    --publish \
     | tee logs/4.labmda-update.log

# Chamar lambda de novo
aws lambda invoke \
    --function-name $FUNCTION_NAME logs/5.lambda-update.log \
    --log-type Tail \
    --query 'LogResult' \
    --cli-binary-format raw-in-base64-out \
    --payload '{"name":"Pedro Darde"}' \
    --output text | base64 -d



#Deletar lambda

aws lambda delete-function  \
    --function-name $FUNCTION_NAME  \