# Dygma Defy : backup Bazecor

`defy-backup.json` est un backup complet du Neuron (keymap toutes layers,
superkeys, couleurs, réglages qukeys/wireless) pris depuis Bazecor.

Pas un module Stow : le layout vit dans l'EEPROM du clavier, ce fichier ne
sert qu'à la restauration.

- Restaurer : Bazecor > Backups (ou Preferences selon la version) > Restore,
  choisir ce fichier.
- Mettre à jour : Bazecor sauvegarde automatiquement dans
  `~/Dygma/Backups/Defy/<id>/` à chaque save ; copier le plus récent ici
  et committer.

Layout courant (2026-08-19) : base QWERTY US-Intl, pouce gauche avec
Layer Shift 4 (fenêtres yabai, chords alt+) et 5 (libre), grosse touche
en cours de refonte dual ⌘/Backspace, superkey 1 copier/coller.
