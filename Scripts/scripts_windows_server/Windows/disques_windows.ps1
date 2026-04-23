. "$PSScriptRoot\scripts_windows_server\utilitaire.ps1"

# Variables principales - commandes PowerShell pour client Windows
$nombre_disque_client = ssh $ssh_client "powershell.exe -Command '(Get-Disk | Measure-Object).Count'"
$liste_disque_client = ssh $ssh_client "powershell.exe -Command 'Get-Disk | Select-Object -ExpandProperty DiskNumber'"
$liste_lecteur_client = ssh $ssh_client "powershell.exe -Command 'Get-Volume | Where-Object {\$_.DriveLetter -ne \$null} | Select-Object DriveLetter, FileSystemType, DriveType'"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu Disques"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        "1" {
            Log "Retour menu disque"
            Write-Host "Vous retournez au menu Disques"
            Start-Sleep 1
            return
        }
        "2" {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal"
            Start-Sleep 1
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep 1
            MenuSecondaire
        }
    }
}

Log "Demande sur disques"
Write-Host "Bienvenue dans la gestion des Disques et Lecteurs"
Start-Sleep 1
Clear-Host

while ($true) {
    Write-Host "Menu Disques"
    Write-Host "Que souhaitez-vous connaitre ?"
    Write-Host "1 - Le nombre de disques"
    Write-Host "2 - Le partitionnement par disque"
    Write-Host "3 - La liste des lecteurs montés"
    Write-Host "4 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        "1" {
            Log "Consultation nombre de disques client"
            Write-Host "Le nombre de disques de $ssh_client est de $nombre_disque_client"
            MenuSecondaire
        }
        "2" {
            Log "Consultation détail des partitions"
            Write-Host "Le poste $ssh_client contient $nombre_disque_client disques avec en détail :"

            foreach ($disk in $liste_disque_client) {
                $part_nombre = ssh $ssh_client "powershell.exe -Command '(Get-Partition -DiskNumber $disk | Measure-Object).Count'"
                Write-Host "Numéro du disque : $disk"
                Write-Host "Nombre de partitions du disque $disk : $part_nombre"

                $partitions = ssh $ssh_client "powershell.exe -Command 'Get-Partition -DiskNumber $disk | Select-Object -ExpandProperty PartitionNumber'"
                foreach ($partition in $partitions) {
                    $partition_data = ssh $ssh_client "powershell.exe -Command 'Get-Partition -DiskNumber $disk -PartitionNumber $partition | Get-Volume | Select-Object FileSystemType, Size'"
                    Write-Host "Concernant la partition $partition"
                    Write-Host "$partition_data"
                }
            }
            MenuSecondaire
        }
        "3" {
            Log "Consultation lecteurs montés"
            Write-Host "La liste des lecteurs montés sur $ssh_client est :"
            Write-Host $liste_lecteur_client
            MenuSecondaire
        }
        "4" {
            Log "Retour au menu principal"
            Write-Host "Vous revenez au menu principal"
            Start-Sleep 1
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep 1
        }
    }
}
