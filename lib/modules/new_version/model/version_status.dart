// class VersionStatus {
//   /// The current version of the app.
//   final String localVersion;
//   /// The most recent version of the app in the store.
//   final String storeVersion;
//   /// A link to the app store page where the app can be updated.
//   final String appStoreLink;
//   /// The release notes for the store version of the app.
//   final String? releaseNotes;
//   /// Returns `true` if the store version of the application is greater than the local version.
//   ///
//   VersionStatus({
//     required this.localVersion,
//     required this.storeVersion,
//     required this.appStoreLink,
//     this.releaseNotes,
//   });
//   bool get canUpdate {
//     final local = localVersion.split('.').map(int.parse).toList();
//     final store = storeVersion.split('.').map(int.parse).toList();
//     for (var i = 0; i < store.length; i++) {
//       if (store[i] > local[i]) {
//         return true;
//       }
//       if (local[i] > store[i]) {
//         return false;
//       }
//     }
//     return false;
//   }
//
// }