// swift-tools-version: 5.9

import PackageDescription

let package: Package = Package(
  name: "Carift",
  targets: [
    .executableTarget(
      name: "Carift"),
    .testTarget(name: "Carift-Tests", dependencies: ["Carift"]),
  ]
)
