Liste_Utilisateurs_Locaux() {
    log "Liste_Utilisateurs_Locaux"

liste=$(cat /etc/passwd | cut -d: -f1)

if [ $? -eq 0 ]; then
    echo "Les 5 derniers utilisateurs locaux :"
    echo "$liste" | tail -10
else
    echo "Récupération impossible"
fi
}
