#!/usr/bin/env bash


set -euo pipefail

PROJECT=$(basename "$PWD")
SNAPSHOT_DIR="./snapshots"
TIMESTAMP=$(date +%F_%H-%M-%S)
CURRENT_SNAP="${SNAPSHOT_DIR}/${TIMESTAMP}"

mkdir -p "$CURRENT_SNAP/images" "$CURRENT_SNAP/volumes"

docker compose stop

echo "[*] Tworzenie snapshotu w $CURRENT_SNAP"

# 1. Zapisz compose config
cp docker-compose.yml "$CURRENT_SNAP/compose.yml"

# 2. Snapshot obrazów
echo "[*] Snapshot obrazów..."
docker compose images > "$CURRENT_SNAP/images.txt"
for img in $(docker compose images -q | sort -u); do
    safe_name=$(echo "$img" | tr '/:' '__')
    docker save "$img" -o "$CURRENT_SNAP/images/${safe_name}.tar"
done

# 3. Snapshot wolumenów (tylko tego projektu)
echo "[*] Snapshot wolumenów..."
for vol in $(docker volume ls --format '{{.Name}}' | grep "^${PROJECT}_"); do
    echo "  -> $vol"
    docker run --rm -v $vol:/vol -v "$CURRENT_SNAP/volumes:/backup" alpine \
        tar czf /backup/${vol}.tar.gz /vol
done

# 4. Aktualizacja
echo "[*] Aktualizacja usług..."
if ! docker compose pull || ! docker compose up --build -d; then
    echo "[!] Aktualizacja nieudana. Użyj rollback.sh aby przywrócić snapshot."
    exit 1
fi

# 5. Utrzymuj max 2 snapshoty
SNAPSHOTS=( $(ls -1t "$SNAPSHOT_DIR") )
if [ ${#SNAPSHOTS[@]} -gt 2 ]; then
    for old in "${SNAPSHOTS[@]:2}"; do
        echo "[*] Usuwam stary snapshot: $old"
        rm -rf "$SNAPSHOT_DIR/$old"
    done
fi
yes | docker system prune

echo "[✓] Update zakończony pomyślnie. Snapshot: $CURRENT_SNAP"


###########################3
# ROLLBACK
# #!/usr/bin/env bash
# set -euo pipefail

# SNAPSHOT_DIR="./snapshots"

# LATEST=$(ls -1t "$SNAPSHOT_DIR" | sed -n '2p')  # drugi najnowszy = poprzedni
# if [ -z "$LATEST" ]; then
#     echo "[!] Brak snapshotów do rollbacku."
#     exit 1
# fi

# SNAP="$SNAPSHOT_DIR/$LATEST"
# echo "[*] Rollback do snapshotu: $SNAP"

# # 1. Przywróć obrazy
# echo "[*] Przywracanie obrazów..."
# for tar in "$SNAP/images/"*.tar; do
#     docker load -i "$tar"
# done

# # 2. Przywróć wolumeny
# echo "[*] Przywracanie wolumenów..."
# for tar in "$SNAP/volumes/"*.tar.gz; do
#     volname=$(basename "$tar" .tar.gz)
#     docker volume rm -f "$volname" || true
#     docker volume create "$volname"
#     docker run --rm -v $volname:/vol -v "$SNAP/volumes:/backup" alpine \
#         sh -c "cd /vol && tar xzf /backup/${volname}.tar.gz --strip 1"
# done

# # 3. Przywróć compose config
# echo "[*] Uruchamianie usług z poprzedniego compose.yml..."
# docker compose -f "$SNAP/compose.yml" up -d

# echo "[✓] Rollback zakończony."


# docker compose pull
# docker compose up --force-recreate --build -d
# docker image prune -f


# # albo
# docker compose pull
# docker compose stop
# # docker compose up --build -d
# socker system prune
# docker image prune -f



