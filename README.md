## vscode for docker

环境变量配置：
```shell
# CS_HASHED_PASSWORD: '$argon2i$v=19$m=4096,t=3,p=1$ndQZbJFPeeuSm8wbq8k8Mg$W1C5cXmuSoQD8f/vJQyujytoZEoG5DdJN1c8LUH9Ldo'
# CS_SERVER_PORT: '0.0.0.0:80'
# CS_DISABLE_UPDATE_CHECK: false
# CS_DISABLE_FILE_DOWNLOADS=false
# CS_CONFIG: "~/.config/code-server/config.yaml"
# CS_USER_DATA_DIR: "~/.local/share/code-server"
# CS_EXTENSIONS_DIR: ""
# CS_APP_NAME: ""
# CS_WELCOME_TEXT: ""
```


启动命令
```yaml
docker-compose up -d
```