# tech_test

Test App for reactor team

## Getting Started

Min Android Api version - 21
Min iOS version - 8.0

The app has additional dependencies:
- [http](https://pub.dartlang.org/packages/http)
- [tuple](https://pub.dartlang.org/packages/tuple)

    To deploy the app on Android device, you have to have Android studio(3.3.2) 
with installed flutter plugin and connect device with enabled developers mode (or open emulator). 
Just choose your device in the list of available devices in studio and click on "Run".

    To deploy the app on iOS device, you need to do same things as for Android, but you need
to install iOS simulator(or use default with XCode).

    Also, in debug mode, app can show unsuitable performance (its fine for flutter for now).
To see real performance you can make release versions of the apk via "flutter build apk --release" command.
Or use [instruction for iOS](https://flutter.dev/docs/deployment/ios).