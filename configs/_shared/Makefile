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
	docker compose exec php php artisan dev --User=1 --SellingAccount=10 --Product=10 --EmployeeContractTemplate=2 --Contact=2 --Client=2 --BillingEntity=2 --Site=2 --Contract=1 --ContractProduct=1 --Job=10 --Employee=2 --JobFrequency=10 --JobFrequencyItem=10 --EmployeeJobAffectation=10 --Intervention=20 --InterventionStaff=20
	docker compose exec php php artisan save:analytics
	docker compose exec php php artisan fetch:public-holidays --all_zones --year=2024