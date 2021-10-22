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

## Installation
### Using GIT (standard)
1. Clone the repo
`git clone https://github.com/znnpd/znn-stresstest-analysis.git`
1. Navigate into folder `znn-stresstest-analysis`
1. Ensure that dependency to Zenon Dart SDK is correctly defined
    Check path in `pubspec.yaml`
    ```yaml
    dependencies:
      znn_sdk_dart:
        path: '../znn_sdk_dart'
    ```
1. Install dependencies
    `dart pub get`
