Activation_Du_pare_Feu() {
log "Activation du pare-feu"

read -p "Voulez vous vraiment activer les pare-feu ? (O/N) " reponse
    if [ "$reponse" = "O" ] || [ "$reponse" = "o" ]; then
        ufw enable
            if ufw status | grep -q "Status: active"; then
                echo "Vos Pare-Feu ont bien été activé"
            else
                echo "Activation Pare-Feu impossible"
            fi
    else
        echo "Activation Pare-feu annulé"
    fi
    Menu_Operateur_Maintenance
}
