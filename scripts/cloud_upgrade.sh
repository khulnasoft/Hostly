set -e
export IMAGE=$1
docker system prune -af
docker compose pull
read -p "Press Enter to update Hostly to $IMAGE..." </dev/tty
docker exec hostly sh -c "php artisan tinker --execute='isAnyDeploymentInprogress()'"
docker compose up --remove-orphans --force-recreate -d --wait
echo $IMAGE > last_version
docker compose logs -f
