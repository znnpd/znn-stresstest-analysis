# ZNN Stresstest Analysis
Simple command line tool based on Zenon Dart SDK to get insights about the load produced between a given start and end time.
* Total number of momentums
* Total number of transactions
* Average throughput (transactions per second)
* Average number of transactions per momentum
* Largest momentum (with highest number transactions)

## Prerequisits
* Dart SDK must be installed on your local machine (https://dart.dev/get-dart)
* Latest Zenon Dart SDK must be downloaded on your local machine (https://testnet.znn.space/#!downloads.md)
* Local znn node, configured to listen to websockets. Otherwise a public available node must be used.

## Installation
1. Clone the repo
```
git clone https://github.com/znnpd/znn-stresstest-analysis.git
```
2. Navigate into folder
```
cd znn-stresstest-analysis
```
3. Ensure that the `path`to Zenon Dart SDK dependency is correctly defined in `pubspec.yaml`
```yaml
dependencies:
    znn_sdk_dart:
    path: '../znn_sdk_dart'
```
4. Install dependencies
```
dart pub get
```

## Running the script
1. Open `bin/znn_stresstest_analysis.dart`
    1. Set correct start and end time
    1. Configure IP address of a valid znn node (127.0.0.1 for a local znnd, public IP address for a public node)
2. Execute `dart run bin/znn_stresstest_analysis`