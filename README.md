# ![lumi icon](./web/icons/icon-20.png) lumi

Philips Hue desktop app to control lights and sensors.

> ⚠️ This app won't work in your web browser because it needs a local environment to communicate with Hue API. A working desktop app will be released when [Flutter](https://flutter.dev) will be more mature for desktop. In the meantime, you can run this app locally in your web browser with the command `flutter run -d chrome`.

[https://lumi.rootasjey.dev](https://lumi.rootasjey.dev)

![lumi screenshot](./screenshot.png)

## Features

The features are pretty basic for now.

* Control lights
  * Change hue, brightness, saturation
  * Use random palette colors
* Control sensors
  * Switch ON/OFF
* Control groups (& rooms)
  * Switch ON/OFF

## Limitations

lumi does not have all features of the mobile app like
sensors' rules edit or Hue Labs. Instead, it focuses on
lights and sensors' control.

Also, it is not possible to delete users in third party apps.

## Develop

1. Install [Fluter](https://fluter.dev)
2. Clone this project `git clone https://github.com/rootasjey/lumi.git`
3. Navigate inside the local folder with `cd lumi`
4. Inside the local folder, run `flutter pub get`
5. Run the app with `flutter run -d chrome`

## License

MIT
