# Run commands

for generating
```shell
fvm flutter packages pub run build_runner clean
fvm flutter packages pub run build_runner build
```
launch icon
```shell
fvm flutter pub run flutter_launcher_icons
```
splash
```shell
fvm flutter pub run flutter_native_splash:create
```

get sha1
```shell
cd android
./gradlew signingReport
```

change package
```shell
fvm flutter pub run change_app_package_name:main com.mo.floppybirds
```

change app name
```shell
fvm flutter pub run rename_app:main all="Mo Floppy Birds"
```
generate file that contains localization keys
```shell
fvm flutter pub run easy_localization:generate -S "assets/translations" -O "lib/core/resources/gen" -o "locale_keys.g.dart" -f keys
```
