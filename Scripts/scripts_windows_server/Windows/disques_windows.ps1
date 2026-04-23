param(
    [string]$REMOTE_PC,
    [System.Management.Automation.PSCredential]$REMOTE_CRED
)
. "$PSScriptRoot\..\utilitaire.ps1"

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
    Write-Host "3 - La liste des lecteurs montes"
    Write-Host "4 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        "1" {
            Log "Consultation nombre de disques client"
            $nombre_disque = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                (Get-Disk | Measure-Object).Count
            }
            Write-Host "Le nombre de disques de $REMOTE_PC est de $nombre_disque"
            MenuSecondaire
        }
        "2" {
            Log "Consultation detail des partitions"
            $infos_disques = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                $disques = Get-Disk | Select-Object -ExpandProperty DiskNumber
                foreach ($disk in $disques) {
                    $partitions = Get-Partition -DiskNumber $disk
                    Write-Host "Numero du disque : $disk"
                    Write-Host "Nombre de partitions : $($partitions.Count)"
                    foreach ($partition in $partitions) {
                        $volume = $partition | Get-Volume -ErrorAction SilentlyContinue
                        Write-Host "  Partition $($partition.PartitionNumber) - FS: $($volume.FileSystemType) - Taille: $([math]::Round($volume.Size / 1GB, 2)) Go"
                    }
                }
            }
            MenuSecondaire
        }
        "3" {
            Log "Consultation lecteurs montes"
            Write-Host "La liste des lecteurs montes sur $REMOTE_PC :"
            Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                Get-Volume | Where-Object { $_.DriveLetter -ne $null } |
                Select-Object DriveLetter, FileSystemType, DriveType |
                Format-Table -AutoSize
            }
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
