/*******************************************************************************

    The set for consensus-critical constants

    This defines the class for the consensus-critical constants. Only one
    object should exist for a single node. The `class` is `immutable`, hence
    the constants need to be set at the start of the process. The
    consensus-critical constants are the protocol-level constants, so they
    shouldn't be modified outside of test environments.

    Copyright:
        Copyright (c) 2019-2020 BOS Platform Foundation Korea
        All rights reserved.

    License:
        MIT License. See LICENSE for details.

*******************************************************************************/

module agora.consensus.data.ConsensusParams;

import agora.consensus.data.Block;

/// Ditto
public immutable class ConsensusParams
{
    /// The cycle length for a validator
    public uint ValidatorCycle;

    /// Maximum number of nodes to include in an autogenerated quorum set
    public uint MaxQuorumNodes;

    /// The threshold to use for the generated quorums
    public uint QuorumThreshold;

    /// The maximum number of blocks before a quorum shuffle takes place.
    /// Note that a shuffle may occur before the cycle ends if the active
    /// validator set changes (new enrollments, expired enrollments..)
    public uint QuorumShuffleInterval;

    /// The Genesis block of the chain
    public Block Genesis;

    /***************************************************************************

        Constructor

        Params:
            genesis = Genesis block to use for this chain
            validator_cycle = cycle length for a validator
            max_quorum_nodes = max nodes to include in autogenerated quorum set
            quorum_threshold = the threshold to use for the generated quorums
            quorum_shuffle_interval = quorum shuffle block cycle length

    ***************************************************************************/

    public this (immutable(Block) genesis, uint validator_cycle = 1008,
                 uint max_quorum_nodes = 7, uint quorum_threshold = 80,
                 uint quorum_shuffle_interval = 30)
    {
        this.Genesis = genesis;
        this.ValidatorCycle = validator_cycle;
        this.MaxQuorumNodes = max_quorum_nodes;
        this.QuorumThreshold = quorum_threshold;
        this.QuorumShuffleInterval = quorum_shuffle_interval;
    }

    /// Default for unittest, uses the test genesis block
    version (unittest) public this (
        uint validator_cycle = 1008, uint max_quorum_nodes = 7,
        uint quorum_threshold = 80)
    {
        import agora.consensus.data.genesis.Test : GenesisBlock;
        this(GenesisBlock, validator_cycle, max_quorum_nodes, quorum_threshold);
    }
}
