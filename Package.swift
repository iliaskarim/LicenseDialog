// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "LicenseDialog",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "LicenseDialog",
      targets: ["LicenseDialog"]),
  ],
  targets: [
    .target(
      name: "LicenseDialog",
      resources: [
        .process("Resources/Licenses")
      ]),
    .testTarget(
      name: "LicenseDialogTests",
      dependencies: ["LicenseDialog"])
  ]
)
