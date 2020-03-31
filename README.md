# README

## Running up project
```bash
foreman start -f Procfile.dev
```
## How to test out
- Create product

```bash
curl --request POST \
  --url http://localhost:3000/clients \
  --header 'content-type: application/json' \
  --data '{
	"name": "iPhone 11",
	"price": 4444
}'
```

- Get products

```bash
curl --request GET \
  --url http://localhost:3000/clients
```

- Get product

```bash
curl --request GET \
  --url http://localhost:3000/clients/1
```

## Build your own one

- Create a normal rails project by:
```bash
rails new <project_name>
```

- Add proto file

In my case it is `app/proto/Products.proto`

- Generate gRPC services code

```bash
./bin/generate_protos.sh
```

- Create gRPC Server controller
Checkout `app/rpc/products_controller.rb`

- How to run up gRPC server?
```bash
bundle exec gruf --host=localhost:9003
```
and your gRPC server will run on port 9003

- Implement Client controller
Checkout `app/controllers/clients_controller.rb`

- Run up client as normal rails application
```bash
rails s
```
Your client app will run on port 3000, and we can send a normal HTTP request to this port
