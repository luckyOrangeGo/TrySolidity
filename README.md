docker pull remixproject/remix-ide:latest
docker run -p 8080:80 remixproject/remix-ide:latest

npm install -g @remix-project/remixd
remixd -s ./ --remix-ide http://localhost:8080

1. Ganache
2. Truffle (global installation)
3. Metamask.io (hooked up on the browser)
