image:=registry.qingteng.cn/ms-infra/dataease/mongobi:v2.14.9

build:
	@docker build -t ${image} .

run:
	@docker run --name mongobi -td -p 3307:3307 ${image}

clean:
	@docker rm -f mongobi
	@docker image rm -f ${image}

push:
	@docker push ${image}