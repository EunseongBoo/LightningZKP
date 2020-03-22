pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNoteVerifier is VerifierBase {

    function depositVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x02a14da7979f937c7837f0f9f62637e6bee44d72a864cd478840f323269040ad), uint256(0x1ae09f6c33b91b1324e45285b4110d469d21e137d60c391c76cbe93e80dc9f12));
        vk.b = Pairing.G2Point([uint256(0x08a6d8e172e0bfa03ddec649513b16921d4a9f3076a689e35503dccccf2a95fa), uint256(0x2ef403562137b4f0d81b29a36b2965a3f9fbbb27f83b539ce8c16565cb129b69)], [uint256(0x2bde02eaebe2bef7ec7b20f436bc47a6599ce00ce637258680791e1daea1fc6f), uint256(0x28625ec194313e6ab9cc4981e718ed3399d2ac613b143f36343a432cdca6b508)]);
        vk.gamma = Pairing.G2Point([uint256(0x01ac0ed03c156d253cf760d74ed842df95b05f35ef3ffa61c8a18e49a2e842f6), uint256(0x1f5f49f67759b3da5fbfc0f9ae9d6e1a3811a88e0959510941dec7cad467f919)], [uint256(0x0c63d9b6eac17e573cdd91cbb152319d8f5053dd058f9d83ed3960946ba6ddc5), uint256(0x2471251d4ddb354a8330761d71de4176c1310402a3ef1f3bcc5caa5153ccb598)]);
        vk.delta = Pairing.G2Point([uint256(0x0eddea05866813c13af1825214e3dba50b476ccb07639877a46354cf030d077a), uint256(0x14d4ccd43eb2ad456d8f99876d210269794503e0fc8085965369610ecaee4da3)], [uint256(0x1ed64122b7ecbb44906d8db0fbf9915cdfb34884615d50ce43438ed08200887b), uint256(0x15e7790f65e84499fdc38867d0ac02c94782e030fc483f9e3c9b001a26b34d19)]);
        vk.gamma_abc = new Pairing.G1Point[](24);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x2d837adf013bf31dc915b6e927315416c3f6981efe57b6351d0ad6820cafdcb9), uint256(0x1f14916cefa7dbb581bfcf0395696dd71d4a60f52639849b34de93404b604774));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x00ab24a4de5770474745990183ae38651eea9dc472467a3756645e996c92cb8d), uint256(0x11bcd245ee0cfe092d86873975fc3e97d52b9d58fdbe1eb89523a93f09314fc4));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x1ba35bc7108584c68316a63f4c1391eecfb67480d4a9f6a5df6bdb58a6fee1dc), uint256(0x095d6d96579b8ea3cfda9c3ebc405c410a3333b99ff5c4bf86c869cb5f583cc7));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1be416d18cd826a8d597d604e032cc625449135a9c4e8ec62e3e6fb0473db19e), uint256(0x036cbfa7d8c7e5245ace3676e9a2e9f9928c59e7bd019ae53149a527bbb78c9c));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x1ffd833fa6f8021609ccf66bc869671c235c8d0542311317aec45e8002c66cd2), uint256(0x14bbd01616007bb58aaba3a90778338603412af7db5c31e2ff90d5b04090f02a));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x24a2714615842435231743c183133f05623dc7608ce198a2917fc9bfba470600), uint256(0x0e9e2a8af04f7d2281051558fcc6c6118b6f952d212abf513bcb4d7442aef229));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x29c85c6e152e4e5b00f8f6e72c937d66485df7730aae09cb14ef6290df550fca), uint256(0x08d1445c42167c7d09902918f6408bb2560e1a0f54ae7a2a018626991fd90af3));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x15ef67c23051d972ca4e6d51555720d50588dd3946de3227ef958a6aa430f7c0), uint256(0x1da5b70738ae0a7addcd768138c3821837f8cc599add907f7f644b83173427ef));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x07c1dd1affafcae5f3416c95615138d4ae63adc83984fa9b6afa989b1cf98324), uint256(0x22f484bd5082da7b540068b1c2073d361172adb3c5ec402a4c5f7154e960e894));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x14dd8a4c5d9eff171fc2fbd0ffcaa90cce4923848649083fa626f699638927cf), uint256(0x1dc524e2606e9f94bc6241f66b384fcbef5b212a1027259ab0f1847d3de76642));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x003ec71f95411ab91a7248a7029abd51c6928a2d113b9e42019119f2d877b814), uint256(0x19fd6bd0408740f3cf1142a9377ee35baf16c26010282539622562f2313181bd));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x06ef686de6889acfc119032867e9d2faaa1a427fab6e72f080573496cae30137), uint256(0x238139780149f6b5508ec5e1b8513918427e7081b67eba3c75790309a32176c7));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x27a9189386a71b2894c5062f169e4d3a4e086842183f157a6ca3d8c6d30a71e7), uint256(0x019dc6512bf919627360184e34747363b0957c45170a7f12de4dbb72051ffacc));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x0080b668f992aaa0ca5a778fa0b2ee6bba2e7b659c52b7cd5d5948ef75a2018d), uint256(0x1edab5626ed68c5ea28a4926507e5ae5b8e3444433bb987292fb46da2aff5f09));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x1f67b5dad6c5b09aebbf81dbf6669a90e5ad8bc5dbd41e6b18aaa2da032c8a96), uint256(0x1e9efde27f6fb629fc5848543298b9c5919233d0cf0881fb1c002b0d7e5d2624));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x11c1c6ef192f7e3e7dc455c7fc43d6d8c8a8b738cbc5dbf603700e3314d59647), uint256(0x1822b1c5dc829b24276b29d32b1e937266cbfad1ba98bf0c89bf646391b38f89));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x13b4e508bd598d18505c93844af655ef6464b301195966f344f379cbf6f94869), uint256(0x16ecc896f84a05d1791f304ab5e1826746f4c235e8c498e00a3ea8b497e71374));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x0a3c95eb9ba18c49954b9466ac3ed682472781fbb69be11e8afeb229962d1513), uint256(0x29be0c6b9aabd44874fdefa99fb757ed6c69bed58153560dbe91c386e33e7a10));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x27af10b75acbc55137bf790a9ca49272fee6a9777022741d9209aa14a3a84eaf), uint256(0x0ae84faf5c5615e70bd0d81f79f1c6f3e2096b8d4daea4cd956c17f86dc6ce41));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x1b1c808401896423b83530b32de2582ed75a549a907b19e42869597c64e6d2ee), uint256(0x09caab853096205f16a1124ee34337650961a0392230488379217e13f0f0abfb));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x134aaa20bdd7311ba4187ae2d5254f30166d343afa37791397df42ade6ac3eb5), uint256(0x26dab6200b2918fdaf8c5c163fe9fa164d58f74e1f43f2114a04633a35c061aa));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x14252a0dc175918eac7b3e55d830d44b011b5f4ac8d6f32a99f947751bfbb678), uint256(0x2e25a4f7c118413d099c79f4894f39d70a05722fb9d0bf828d3f11c33b0d15f4));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x0b69be3d950e88890f7eccd31ee8775a99229ed21ce7a616efd3a66203a0a8b3), uint256(0x2111ec1c7098add05ceed8686324523f2970b46a423f931fa156f5be8d9cb522));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x1a21f7d25954a117a3a933d4214316ff0b1a64d9259bf65443550e8d6676005c), uint256(0x26be9bb77610ee0ca718f56293ffc68a3d8a16bea3434f78fdd27b4912563d0d));
    }
    function depositVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = depositVerifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.a), vk.b)) return 1;
        return 0;
    }
    event LzkpVerified(string s);
    function depositVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[23] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (depositVerify(inputValues, proof) == 0) {
            emit LzkpVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
