# Requirements

## Add libraries
```
cd ~/.local/share/OpenSCAD/libraries
git clone https://github.com/nophead/NopSCADlib.git
git clone https://github.com/Irev-Dev/Round-Anything.git
```

## Add NopSCADlib scripts dir to PATH in ~/.profile file
```
export PATH="$PATH:$HOME/.local/share/OpenSCAD/libraries/NopSCADlib/scripts"
```

## Python environment
```
mkvirtualenv --python /usr/bin/python2.7 scadlib
pip install colorama
pip install codespell
pip install markdown
```
