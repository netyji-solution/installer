include .env
export

.PHONY: help install_netyji_solution install_factur_x_pdf install_factur_x_xml install_compta_export stop kill delete-all refresh-makefile

help:
	@echo "Gestion des projets NETYJI"
	@echo ""
	@echo "1) Installation des projets"
	@echo "---------------------------"
	@echo "install_netyji_solution    Lance l'installation complète du projet netyji_solution"
	@echo "install_factur_x_pdf       Lance l'installation complète du projet factur_x_pdf"
	@echo "install_factur_x_xml       Lance l'installation complète du projet factur_x_xml"
	@echo "install_compta_export      Lance l'installation complète du projet compta_export"
	@echo ""
	@echo "3) Manipulation globale des conteneurs Docker"
	@echo "---------------------------------------------"
	@echo "stop                       Force l'arrêt de tous les conteneurs lancés"
	@echo "kill                       Force l'arrêt et la suppression de tous les conteneurs lancés"
	@echo "delete-all                 Force la suppression de toutes les images"
	@echo ""
	@echo "4) Actualiser les contenus"
	@echo "---------------------------------------------"
	@echo "refresh-makefile           Force la mise à jour de tous les fichiers Makefile à la racine des projets installés"

install_netyji_solution:
	git pull
	$(MAKE) kill
	mkdir -p netyji_solution
	sudo chown -R ${USER}:${USER} netyji_solution
	cp -TR configs/netyji_solution/docker netyji_solution
	mv netyji_solution/.env.bak netyji_solution/.env
	cp configs/_shared/Makefile netyji_solution/Makefile
	mkdir -p netyji_solution/docker/nginx
	sudo chown -R ${USER}:${USER} netyji_solution/docker/nginx
	cp configs/_shared/nginx.conf netyji_solution/docker/nginx/nginx.conf
	cd netyji_solution && mkdir -p app
	cd netyji_solution && mkdir -p database
	cd netyji_solution && mkdir -p mail
	sudo chown -R ${USER}:${USER} netyji_solution/app
	sudo chown -R ${USER}:${USER} netyji_solution/database
	sudo chown -R ${USER}:${USER} netyji_solution/mail
	cd netyji_solution && docker compose build --build-arg GITHUB_TOKEN=${GITHUB_TOKEN}
	cd netyji_solution && docker compose down
	sleep 1
	cd netyji_solution/app && git clone --branch develop git@github.com:netyji-solution/netyji_solution.git .
	cp configs/netyji_solution/dev.env netyji_solution/app/.env
	cd netyji_solution/app && rm composer.lock
	sudo chown -R ${USER}:www-data netyji_solution/app/storage
	sudo chown -R ${USER}:www-data netyji_solution/app/bootstrap/cache
	sudo chmod -R 775 netyji_solution/app/storage
	sudo chmod -R 775 netyji_solution/app/bootstrap/cache
	cd netyji_solution && docker compose up -d
	sleep 1
	cd netyji_solution && docker compose exec php composer install
	cd netyji_solution && docker compose exec node npm install
	cd netyji_solution && docker compose exec php php artisan key:generate
	cd netyji_solution && docker compose exec php php artisan matice:generate
	cd netyji_solution && docker compose exec php php artisan storage:link
	cd netyji_solution && docker compose exec php php artisan dev --User=1 --Contact=10 --Client=10 --Site=10 --BillingEntity=10 --SellingAccount=10
	cd netyji_solution && docker compose exec php php artisan fetch:public-holidays --all_zones --year=2024
	cd netyji_solution && docker compose exec php php artisan save:analytics
	@echo "projet netyji-solution installé !"

install_factur_x_pdf:
	git pull
	$(MAKE) kill
	mkdir -p factur_x_pdf
	sudo chown -R ${USER}:${USER} factur_x_pdf
	cp -TR configs/factur_x_pdf/docker factur_x_pdf
	cp configs/_shared/Makefile factur_x_pdf/Makefile
	cd factur_x_pdf && mkdir -p app
	sudo chown -R ${USER}:${USER} factur_x_pdf/app
	cd factur_x_pdf && docker compose build
	cd factur_x_pdf && docker compose down
	sleep 1
	cd factur_x_pdf/app && git clone --branch develop git@github.com:netyji-solution/factur-x_pdf.git .
	cd factur_x_pdf && docker compose up -d
	sleep 1
	cd factur_x_pdf && docker compose exec php composer install
	@echo "projet factur_x_pdf installé !"

install_factur_x_xml:
	git pull
	$(MAKE) kill
	mkdir -p factur_x_xml
	sudo chown -R ${USER}:${USER} factur_x_xml
	cp -TR configs/factur_x_xml/docker factur_x_xml
	cp configs/_shared/Makefile factur_x_xml/Makefile
	cd factur_x_xml && mkdir -p app
	sudo chown -R ${USER}:${USER} factur_x_xml/app
	cd factur_x_xml && docker compose build
	cd factur_x_xml && docker compose down
	sleep 1
	cd factur_x_xml/app && git clone --branch develop git@github.com:netyji-solution/factur-x_xml.git .
	cd factur_x_xml && docker compose up -d
	sleep 1
	cd factur_x_xml && docker compose exec php composer install
	@echo "projet factur_x_xml installé !"

install_compta_export:
	git pull
	$(MAKE) kill
	mkdir -p compta_export
	sudo chown -R ${USER}:${USER} compta_export
	cp -TR configs/compta_export/docker compta_export
	cp configs/_shared/Makefile compta_export/Makefile
	cd compta_export && mkdir -p app
	sudo chown -R ${USER}:${USER} compta_export/app
	cd compta_export && docker compose build
	cd compta_export && docker compose down
	sleep 1
	cd compta_export/app && git clone --branch develop git@github.com:netyji-solution/compta_export.git .
	cd compta_export && docker compose up -d
	sleep 1
	cd compta_export && docker compose exec php composer install
	@echo "projet compta_export installé !"

stop:
	-CONTAINERS="$(shell docker ps -a -q)"; docker stop $$CONTAINERS

kill:
	$(MAKE) stop
	-CONTAINERS="$(shell docker ps -a -q)"; docker rm $$CONTAINERS

delete-all:
	$(MAKE) kill
	-CONTAINERS="$(shell docker images -a -q)"; docker rmi $$CONTAINERS

refresh-makefile:
	git pull
	find . -maxdepth 1 -type d \( ! -name . \) -and \( ! -name .git \) -and \( ! -name configs \) -exec bash -c "cd '{}' && cp ../configs/_shared/Makefile Makefile" \;