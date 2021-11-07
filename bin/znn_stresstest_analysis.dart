import 'package:znn_sdk_dart/znn_sdk_dart.dart';
import 'dart:io';

void main() async {

  // Set start and end time to be analysed
  const startTime = '2021-11-07 09:20:00Z'; // In UTC, remove 'Z' as last char for local time
  const endTime = '2021-11-07 09:26:00Z'; // In UTC, remove 'Z' as last char for local time
  
  // Create connection
  final zenon = Zenon();
  final client = zenon.wsClient;
  await client.initialize('ws://peers.zenon.wiki:35998', retry: false); // Or use a public available node
  if (client.isClosed()) {
    print('Could not establish connection, check connection to node.');
    exit(0);
  }
  print('Connection to Network of Momentum established...');

  // Set some variables
  final startTimeMillis = DateTime.parse(startTime).millisecondsSinceEpoch;
  final startTimeSecs = (startTimeMillis / 1000).toInt(); // Seconds since epochs needed in Zenon SDK
  final endTimeMillis = DateTime.parse(endTime).millisecondsSinceEpoch;
  final endTimeSecs = (endTimeMillis / 1000).toInt(); // Seconds since epochs needed in Zenon SDK
  
  num totalNumberOfMomentums = 0;
  num totalNumberOfTxs = 0;
  num largestMomentumNumberOfBlocks = 0;
  num largestMomentumHeight = 0;
  String largestMomentumHash = '';
  
  // Read momentums
  print(startTimeSecs);
  final lastMomentum = await client.sendRequest('ledger.getMomentumBeforeTime', [startTimeSecs]);
  var currentDetailedMomentum = await client.sendRequest('ledger.getDetailedMomentumsByHeight', [lastMomentum!['height']! + 1, 1]);
  while (true) {
    if (currentDetailedMomentum['list'][0]['momentum']['timestamp'] > endTimeSecs) {
      break;
    }
    totalNumberOfMomentums += 1;
    totalNumberOfTxs = totalNumberOfTxs + currentDetailedMomentum['list'][0]['blocks'].length; // Blocks seem to be transactions

    if (currentDetailedMomentum['list'][0]['blocks'].length > largestMomentumNumberOfBlocks) {
      largestMomentumNumberOfBlocks = currentDetailedMomentum['list'][0]['blocks'].length;
      largestMomentumHeight = currentDetailedMomentum['list'][0]['momentum']['height'];
      largestMomentumHash = currentDetailedMomentum['list'][0]['momentum']['hash'];
    }
    currentDetailedMomentum = await client.sendRequest('ledger.getDetailedMomentumsByHeight', [currentDetailedMomentum['list'][0]['momentum']['height'] + 1, 1]);
  }

  // Print results
  num avgNumberOfTxsPerMomentum = (totalNumberOfTxs / totalNumberOfMomentums);
  num avgTransactionsPerSecond = (totalNumberOfTxs / (endTimeSecs - startTimeSecs));
  print('--- RESULTS ---');
  print('>> Total number of momentums: ${totalNumberOfMomentums}');
  print('>> Total number of transactions: ${totalNumberOfTxs}');
  print('>> Average transactions per second: ${avgTransactionsPerSecond}');
  print('>> Average number of transactions per momentum: ${avgNumberOfTxsPerMomentum}');
  print('>> Largest momentum produced: Height ${largestMomentumHeight} (hash ${largestMomentumHash}) with ${largestMomentumNumberOfBlocks} transactions');
  print('---------------');

  // Close connection
  print('Closing connection to Network of Momentum...');
  zenon.wsClient.stop();

}