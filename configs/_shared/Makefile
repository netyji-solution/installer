.PHONY: help watch dev prod db-reset db-load-data

help:
	@echo "Commandes npm"
	@echo "-----------------"
	@echo "make watch   Exécute npm run host"
	@echo "make build   Exécute npm run build"
	@echo ""
	@echo "Commandes de la base de données"
	@echo "----------------------------------"
	@echo "db-reset         Supprime toutes les tables, applique les migrations, les données de test"

watch:
	docker compose exec node npm run host

build:
	docker compose exec node npm run build

db-reset:
	docker compose exec php php artisan dev --User=1 --Contact=10 --Client=10 --Site=10 --BillingEntity=10 --SellingAccount=10
	docker compose exec php php artisan save:analytics
	docker compose exec php php artisan fetch:public-holidays --all_zones --year=2024