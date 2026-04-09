Maintenance_machine() {
    log "Maintenance_machine"

    echo "=== Maintenance des machines ==="
    echo "1 - Redemarrage de la machine"
    echo "2 - Prise en main a distance"
    echo "3 - Activation de pare feu"
    echo "3 - Execution de script a distance"
    echo "3 - Liste des utilisateurs locaux"
    read -p "Votre choix : " CHOICE_rep

    case "$CHOICE_rep" in
        1) 
            Redémarrage_De_La_Machine
            ;;
        2)
            Prise_En_Main_A_Distance
            ;;
        3)
            Activation_Du_pare_Feu
            ;;
        4)
            Execution_Script_A_Distance
            ;;
        5)
            Liste_Utilisateurs_Locaux
            ;;
        *)
            echo "Choix invalide, réessayez."
            Maintenance_machine
            ;;
    esac
}
