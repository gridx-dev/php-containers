dist := ubuntu
hub := dev.hub.init6.com.pl
VERSION := 1.0.0

help:           
	@egrep '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

default: listrepo

#AMD64
build-amd64: ## buduj obraz dla arch. AMD64
	docker build -f Dockerfile.$(dist)  -t php-core.$(dist).amd64:dev-$(VERSION) .
	docker tag php-core.$(dist).amd64:dev-$(VERSION) $(hub):5000/php-core.$(dist).amd64:dev-$(VERSION)
push-amd64:  ## przeslij obraz dla arch. AMD64 do repozytorium
	docker push $(hub):5000/php-core.$(dist).amd64:dev-$(VERSION)
manifest-amd64: ## generuj manifest dla arch. AMD64
	docker manifest inspect --insecure $(hub):5000/php-core.$(dist).amd64:dev-$(VERSION)

#ARM64
build-arm64: ## buduj obraz dla arch. ARM64
	docker buildx build -f Dockerfile.$(dist) --platform linux/arm64  -t php-core.$(dist).arm64:dev-$(VERSION) . --load
	docker tag php-core.$(dist).arm64:dev-$(VERSION) $(hub):5000/php-core.$(dist).arm64:dev-$(VERSION)
push-arm64:  ## przeslij obraz dla arch. ARM64 do repozytorium
	docker push $(hub):5000/php-core.$(dist).arm64:dev-$(VERSION)
manifest-arm64: ## generuj manifest dla arch. ARM64
	docker manifest inspect --insecure $(hub):5000/php-core.$(dist).arm64:dev-$(VERSION)

#ARMv7
build-v7: ## buduj obraz dla arch. ARMv7
	docker buildx build -f Dockerfile.$(dist) --platform linux/arm/v7  -t php-core.$(dist).armv7:dev-$(VERSION) . --load
	docker tag php-core.$(dist).armv7:dev-$(VERSION) $(hub):5000/php-core.$(dist).armv7:dev-$(VERSION)
push-armv7: ## przeslij obraz dla arch. ARMv7 do repozytorium
	docker push $(hub):5000/php-core.$(dist).armv7:dev-$(VERSION)
manifest-v7: ## generuj manifest dla arch. ARMv7
	docker manifest inspect --insecure $(hub):5000/php-core.$(dist).armv7:dev-$(VERSION)

manifest-rocky-create: ## generuj manifest dla wszystkich architetkur dla RockyLinux
	docker manifest create --insecure  $(hub):5000/php-core.$(dist):dev-$(VERSION) \
	$(hub):5000/php-core.$(dist).amd64:dev-$(VERSION) \
	$(hub):5000/php-core.$(dist).arm64:dev-$(VERSION) 
	docker manifest push --insecure $(hub):5000/php-core.$(dist):dev-$(VERSION)
	docker manifest inspect --insecure $(hub):5000/php-core.$(dist):dev-$(VERSION)

manifest-ubuntu-create: ## generuj manifest dla wszystkich architetkur dla Ubuntu
	docker manifest create --insecure  $(hub):5000/php-core.$(dist):dev-$(VERSION) \
	$(hub):5000/php-core.$(dist).amd64:dev-$(VERSION) \
	$(hub):5000/php-core.$(dist).arm64:dev-$(VERSION) \
	$(hub):5000/php-core.$(dist).armv7:dev-$(VERSION)
	docker manifest push --insecure $(hub):5000/php-core.$(dist):dev-$(VERSION) 
	docker manifest inspect --insecure $(hub):5000/php-core.$(dist):dev-$(VERSION)

clean-man: ## Czysc manifesty
	docker manifest rm $(hub):5000/php-core.$(dist):dev-$(VERSION)


listrepo: ## Listuj obrazy w repozytorium
	curl -X GET http://gridx:shift.2020@$(hub):5000/v2/_catalog

platforms: ## Lista platform dla kompilacji
	docker buildx ls

insecrepo: ## Dodaj repozytorium dla buildx
	docker buildx create --config buildkitd.toml --name reginsect --use
	docker buildx inspect --bootstrap

clean-builder: ## Usun repozytorium dla buildx
	docker buildx rm reginsect

all: all-ubuntu
all-ubuntu: build-v7 build-amd64 build-arm64 push-amd64 push-arm64 push-armv7 manifest-amd64 manifest-arm64 manifest-v7 manifest-ubuntu-create ## Buduj obrazy dla Ubuntu, amd,arm,v7, manifesty, przeslij do repo
all-rocky: build-amd64 build-arm64 push-amd64 push-arm64 manifest-amd64 manifest-arm64 manifest-rocky-create ## Buduj obrazy dla Rocky, amd,arm,v7, manifesty, przeslij do repo
