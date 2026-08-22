# Neovim : ta config et ton plan d'apprentissage

Config posée le 2026-08-22, basée sur [LazyVim](https://www.lazyvim.org).
Tout vit dans `~/dotfiles/nvim/.config/nvim/`, symlinke par Stow vers
`~/.config/nvim`. Ce document est ton manuel : garde-le ouvert dans un onglet
les deux premières semaines.

## 1. Ce qui est installé

### La base : LazyVim

LazyVim est une distribution Neovim maintenue par folke (l'auteur des plugins
les plus utilisés de l'écosystème). Elle assemble et pré-configure une
cinquantaine de plugins qui font consensus. Les défauts 2026 :

| Rôle | Plugin | Ce que ça fait |
|---|---|---|
| Gestion plugins | lazy.nvim | installe, lock, lazy-load |
| Picker | snacks.picker | fichiers, grep, buffers, tout |
| Explorateur | snacks.explorer | arbre de fichiers |
| Complétion | blink.cmp | complétion LSP ultra-rapide |
| Syntaxe | nvim-treesitter | parsing réel, pas de regex |
| Formatage | conform.nvim | format on save |
| Git | gitsigns + lazygit | hunks dans la marge + TUI complet |
| Sauts | flash.nvim | saut à 2 lettres n'importe où |
| Aide | which-key | affiche les suites de touches possibles |

### Extras activés (ta stack)

- `lang.typescript` : vtsls (le LSP TS le plus capable, celui de VSCode)
- `lang.typescript.biome` : Biome en LSP (lint + format, tes repos ultracite)
- `lang.tailwind` : tailwindcss-language-server (Tailwind 4 OK)
- `lang.json` / `lang.yaml` / `lang.markdown` / `lang.docker` / `lang.git`
- `lang.php` : phpactor (Symfony, archibald)
- `formatting.prettier` : SEULEMENT si le projet a une config prettier
  (Biome reste le formateur maison, pas de conflit)
- `editor.harpoon2` : marque-pages de fichiers façon ThePrimeagen
- `coding.mini-surround` : manipuler guillemets/parenthèses/balises
- `util.dot` : support des dotfiles (shellcheck, stylua)
- `util.mini-hipatterns` : couleurs Tailwind affichées inline

### Nos ajouts maison

- Thème **night-owl** (cohérent avec Ghostty et herdr, fond #011627)
- `Ctrl-d` / `Ctrl-u` / `n` / `N` : le curseur reste centré à l'écran
- `<espace>p` (en visuel) : coller SANS écraser le registre de copie
- `<espace>U` : undotree, l'historique d'annulation en arbre
- Clipboard système par défaut (y et p parlent au presse-papier macOS)

### LSP et outils (Mason)

vtsls, biome, tailwindcss-language-server, json-lsp, yaml-language-server,
marksman, dockerfile-language-server, hadolint, phpactor, php-cs-fixer,
lua-language-server, stylua, shfmt, shellcheck, markdownlint-cli2, prettier.
Tout est déjà installé : `:Mason` pour voir la liste.

## 2. Le concept central : la grammaire

Vim n'est pas une liste de raccourcis à mémoriser, c'est une langue :
**verbe + cible**. Tu apprends 5 verbes et 8 cibles, tu sais faire 40 choses.

Verbes : `d` (delete), `c` (change = delete + insertion), `y` (yank = copier),
`v` (sélectionner), `>` (indenter).

Cibles : `w` (mot), `iw` (dans le mot), `i"` (dans les guillemets),
`i(` (dans les parenthèses), `it` (dans la balise JSX), `ip` (paragraphe),
`$` (fin de ligne), `G` (fin de fichier).

Exemples à lire à voix haute :
- `ciw` : change inside word. Remplace le mot sous le curseur.
- `di(` : delete inside parens. Vide l'appel de fonction.
- `yi"` : yank inside quotes. Copie la string.
- `cit` : change inside tag. Vide le contenu d'un JSX `<div>...</div>`.
- `dap` : delete around paragraph. Supprime le bloc.

Double le verbe pour agir sur la ligne : `dd` supprime la ligne, `yy` la
copie, `cc` la remplace.

## 3. Plan d'apprentissage : 5 paliers

Un palier par période de 3-5 jours. Ne passe au suivant que quand le
précédent est réflexe. Interdiction d'utiliser la souris dans nvim, elle
marche mais elle t'empêche d'apprendre.

### Palier 1 : survie (jour 1-3)

- `i` insérer, `Esc` retour normal, `:w` sauver, `:q` quitter
- `h j k l` : gauche bas haut droite. Force-toi, pas les flèches.
- `w` / `b` : mot suivant / précédent. `0` / `$` : début / fin de ligne.
- `u` annuler, `Ctrl-r` refaire
- `o` : nouvelle ligne dessous + insertion. `O` : dessus.
- Fais `:Tutor` une fois en entier (30 min, intégré à Neovim).

### Palier 2 : la grammaire (jour 4-8)

- Tout le chapitre 2 ci-dessus : `ciw`, `di(`, `yi"`, `cit`, `dd`, `yy`
- `p` / `P` : coller après / avant
- `.` : LE raccourci sous-coté, répète la dernière modification
- `/truc` puis `n` / `N` : chercher dans le fichier (curseur centré chez toi)
- `*` : chercher le mot sous le curseur

### Palier 3 : naviguer dans le projet (jour 9-12)

Leader = `<espace>`. Appuie sur espace et LIS le menu which-key qui apparaît.

- `<espace><espace>` : trouver un fichier (tape 3 lettres du nom)
- `<espace>/` : grep dans tout le repo
- `<espace>,` : basculer entre buffers ouverts
- `<espace>e` : explorateur de fichiers
- `s` + 2 lettres : flash, saute n'importe où à l'écran
- `Ctrl-o` / `Ctrl-i` : revenir / avancer dans l'historique des sauts

### Palier 4 : le LSP, ton IDE (jour 13-17)

- `gd` : go to definition. `gr` : références. `K` : doc au survol.
- `<espace>cr` : renommer le symbole partout
- `<espace>ca` : code actions (import manquant, fix Biome...)
- `]d` / `[d` : diagnostic suivant / précédent
- `<espace>xx` : Trouble, la liste de tous les problèmes
- Le format on save est automatique (Biome). Rien à faire.

### Palier 5 : la vitesse (jour 18+)

- Harpoon : `<espace>H` ajoute le fichier courant, `<espace>1` à `<espace>4`
  sautent vers tes 4 fichiers marqués. Le combo qui remplace les onglets.
- `<espace>gg` : lazygit plein écran (stage, commit, push sans quitter nvim)
- mini-surround : `gsa"` entoure de guillemets, `gsd"` les enlève,
  `gsr"'` remplace doubles par simples
- `<espace>U` : undotree quand tu as trop annulé
- `gcc` : commenter / décommenter la ligne. `gc` + mouvement en visuel.

## 4. Entretien de la config

- `:LazyHealth` : diagnostic complet (à lancer si quelque chose cloche)
- `:Lazy` : état des plugins. `:Lazy sync` : mise à jour + lock.
- `:LazyExtras` : activer / désactiver des extras (écrit dans lazyvim.json)
- `:Mason` : gérer les LSP / formatters
- Après un `:Lazy sync` : committer `lazy-lock.json` dans les dotfiles
  (c'est le bun.lock des plugins, il garantit une config reproductible)
- Nouveau Mac : `./install.sh` des dotfiles suffit, nvim installera tout
  au premier lancement

## 5. Dygma Defy : rien d'obligatoire, 3 pistes

Ta base QWERTY US-Intl est LE bon layout pour Vim (tous les symboles vim
`: ; / [ ] { }` sont à portée directe, contrairement à l'AZERTY). Rien à
changer pour commencer. Quand les paliers 1-3 seront des réflexes :

1. **Esc sur un pouce** : c'est la touche la plus frappée en Vim. Si ton
   Esc est encore en coin de clavier, mets-le en tap sur une touche pouce
   (garde la version dual-function : tap = Esc, hold = layer/modif).
2. **Layer 5 (libre) en layer symboles de code** : `{ } ( ) [ ] < > = !`
   sur la home row, ça évite les Shift+chiffre en TSX.
3. **Superkey `:w`** : une superkey qui envoie `Esc :w Entrée` ferait une
   sauvegarde en un geste. Gadget mais agréable.

Configure ça dans Bazecor et recopie le backup dans `~/dotfiles/bazecor/`.

## 6. Workflow wibeo recommandé

```
cd ~/Developer/414Aptitudes/wibeo && nvim
```

1. `<espace><espace>` pour ouvrir le fichier du chantier
2. `<espace>H` sur les 3-4 fichiers du chantier (harpoon), puis `<espace>1-4`
3. `<espace>/` pour retrouver un symbole, `gd` pour plonger, `Ctrl-o` pour
   remonter
4. `<espace>gg` pour committer en fin de session

Objectif réaliste : à J+15 tu es aussi rapide qu'avant ; à J+30 tu ne
reviens plus en arrière.

## 7. Références

- Keymaps LazyVim complets : https://www.lazyvim.org/keymaps
- `:Tutor` intégré, et which-key : appuie sur `<espace>` et lis
- ThePrimeagen "Vim As Your Editor" (playlist YouTube, 6 vidéos courtes) :
  la meilleure intro vidéo, c'est elle qui a inspiré les paliers
- typecraft "Neovim for Newbs" : alternative plus douce
