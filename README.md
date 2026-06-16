# Outillage, Automatisations, Documentations du projet Smart Piano

Smart Piano fonctionne sur un ordinateur mono-carte (SBC) [Raspberry Pi 4] Model
B (Rev 1.1) sous la dernière version de Raspberry Pi OS (Debian 13 Trixie).

L’interaction avec l’utilisateur se fait bien évidemment avec un clavier MIDI,
mais aussi via un écran tactile [Joy-It RB-LCD-10-2], sur lequel est directement
monté le [Raspberry Pi 4] via un [boitier-support VESA] imprimé en 3D.

Certaines étapes de configuration sont nécessaires pour une meilleure
expérience, à savoir avoir du son produit lors du jeu et une qualité d’image
optimale.

Smart Piano utilise [Raylib] qui supporte bien les
[Raspberry Pi](https://github.com/raysan5/raylib/wiki/Working-on-Raspberry-Pi).

## Configuration de Raspberry Pi OS pour Smart Piano

### Réglages Graphiques

Le moniteur tactile [RB-LCD-10-2] semble avoir été pensé pour une version
antérieure de Raspberry Pi OS. Pour que l’image soit nette ici, il faut "forcer"
sa reconnaissance par Linux en ajoutant le paramètre noyau
`video=HDMI-A-2:1280x800M@60D` à `/boot/firmware/cmdline.txt`, donnant par
exemple :

```
console=serial0,115200 console=tty1 root=PARTUUID=e2f2b425-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=FR video=HDMI-A-2:1280x800M@60D
```

Il faut aussi forcer la résolution à utiliser par le compositeur graphique Labwc
dans `~/.config/labwc/autostart`.

```shell
wlr-randr --output HDMI-A-2 --custom-mode 1280x800@60 &
```

### Réglages Audio

Smart Piano n’est pas capable de produire du son par lui-même. Cette tâche est
déléguée à un synthétiseur logiciel annexe tel que [FluidSynth], qu’il faut donc
installer avec `apt`.

```shell
sudo apt install fluidsynth -y
```

[boitier-support VESA]: https://makerworld.com/en/models/2940514-raspberry-pi-4-vesa-case
[Joy-It RB-LCD-10-2]: https://joy-it.net/en/products/RB-LCD-10-2
[RB-LCD-10-2]: https://joy-it.net/en/products/RB-LCD-10-2
[Raspberry Pi 4]: https://www.raspberrypi.com/products/raspberry-pi-4-model-b
[FluidSynth]: https://www.fluidsynth.org
[NixGL]: https://github.com/nix-community/nixGL
[Raylib]: https://www.raylib.com
