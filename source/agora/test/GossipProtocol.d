/*******************************************************************************

    Contains tests for Gossip Protocol.

    Copyright:
        Copyright (c) 2019 BOS Platform Foundation Korea
        All rights reserved.

    License:
        MIT License. See LICENSE for details.

*******************************************************************************/

module agora.test.GossipProtocol;

version (unittest):

import agora.common.Data;
import agora.common.Hash;
import agora.common.Transaction;
import agora.test.Base;

///
unittest
{
    import std.conv;
    import std.digest.sha;
    const NodeCount = 4;
    auto network = makeTestNetwork!TestNetworkManager(NetworkTopology.Simple, NodeCount);
    network.start();
    assert(network.getDiscoveredNodes().length == NodeCount);

    // check block height
    foreach (key, ref node; network.apis)
    {
        auto block_height = node.getBlockHeight();
        assert(block_height == 0, block_height.to!string);
    }

    Transaction tx =
    {
        [Input(hashFull("Message No. 1"))],
        [Output(100)]
    };

    Hash tx_hash = hashFull(tx);
    auto node_1 = network.apis.values[0];
    node_1.putTransaction(tx);

    // Check hasTransactionHash
    foreach (key, ref node; network.apis)
    {
        assert(node.hasTransactionHash(tx_hash));

        auto block_height = node.getBlockHeight();
        assert(block_height == 1, block_height.to!string);
    }

    tx.inputs[0].previous = hashFull("Message No. 2");
    tx_hash = hashFull(tx);
    node_1.putTransaction(tx);

    // check if the node height changed
    foreach (key, ref node; network.apis)
    {
        assert(node.hasTransactionHash(tx_hash));
        auto block_height = node.getBlockHeight();
        assert(block_height == 2, block_height.to!string);
    }
}