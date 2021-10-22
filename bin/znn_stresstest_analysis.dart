import 'package:znn_sdk_dart/znn_sdk_dart.dart';
import 'dart:io';


void main() async {

  // Set start and end time to be analysed
  const startTime = '2021-10-16 19:00:00Z'; // In UTC, remove 'Z' as last char for local time
  const endTime = '2021-10-16 20:01:00Z'; // In UTC, remove 'Z' as last char for local time
  
  // Create connection
  final zenon = Zenon();
  final client = zenon.wsClient;
  await client.initialize('ws://127.0.0.1:35998', retry: false); // Or use a public available node
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
  
  var totalNumberOfMomentums = 0;
  var totalNumberOfTxs = 0;
  var largestMomentumNumberOfBlocks = 0;
  var largestMomentumHeight = 0;
  Hash largestMomentumHash = Hash.parse('0000000000000000000000000000000000000000000000000000000000000000');
  

  // Read momentums
  final lastMomentum = await zenon.ledger.getMomentumBeforeTime(startTimeSecs); // Read last momentum before start time
  var currentDetailedMomentum = await zenon.ledger.getDetailedMomentumsByHeight(lastMomentum!.height! + 1, 1);  // Read details of first momentum within specified time frame
  while (true) {
    if (currentDetailedMomentum[0].momentum.timestamp! > endTimeSecs) {
      break;
    }
    totalNumberOfMomentums += 1;
    totalNumberOfTxs = totalNumberOfTxs + currentDetailedMomentum[0].blocks.length; // Blocks seem to be transactions

    if (currentDetailedMomentum[0].blocks.length > largestMomentumNumberOfBlocks) {
      largestMomentumNumberOfBlocks = currentDetailedMomentum[0].blocks.length;
      largestMomentumHeight = currentDetailedMomentum[0].momentum.height!;
      largestMomentumHash = currentDetailedMomentum[0].momentum.hash!;
    }
    currentDetailedMomentum = await zenon.ledger.getDetailedMomentumsByHeight(currentDetailedMomentum[0].momentum.height! + 1, 1);
  }

  // Print results
  var avgNumberOfTxsPerMomentum = (totalNumberOfTxs / totalNumberOfMomentums).toInt();
  var avgTransactionsPerSecond = (totalNumberOfTxs / (endTimeSecs - startTimeSecs)).toInt();
  print('--- RESULTS ---');
  print('>> Total number of momentums: ${totalNumberOfMomentums}');
  print('>> Total number of transactions: ${totalNumberOfTxs}');
  print('>> Average transactions per second: ${avgTransactionsPerSecond}');
  print('>> Average number of transactions per momentum: ${avgNumberOfTxsPerMomentum}');
  print('>> Largest momentum produced: Height ${largestMomentumHeight} (hash ${largestMomentumHash}) with ${largestMomentumNumberOfBlocks} transactions');
  print('---------------');
  
  // Close connection
  zenon.wsClient.stop();
  print('Connection to Network of Momentum closed...');

}