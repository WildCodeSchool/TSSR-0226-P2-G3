Redémarrage_De_La_Machine() {

read -p "Voulez-vous vraiment faire un redémarrage de la machine ? (O/N) : " repo

    if [ "$repo" = "O" ] || [ "$repo" = "o" ]; then
        echo "Le pc redémarre..."
        sleep 3
        reboot
    else
        echo "Redémarrage annulé."
        Menu_Operateur_Maintenance
    fi
}
