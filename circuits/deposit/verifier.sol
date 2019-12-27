pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNoteVerifier is VerifierBase {

    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x140bd8ffe03db6e693b351e1a5740958ef67784198c0ae612865bcfbf8b1dc84), uint256(0x1e893ff6fbde91ad44db2fe2f3e16bcbd389fc0f0b8e1d0ab61d2355b178748c));
        vk.b = Pairing.G2Point([uint256(0x16fc1b1a41c55922d7d8d8904383907b0778d269dabbe5fd796611b46e35b6fd), uint256(0x01e5763cdb4bee7bb660a5846f5e101bc48af40b1ed5ef90841cc007f3491c00)], [uint256(0x0e314ef332898f93720346e247afae10b33906fa105b3cd61df2bc5b48a95b42), uint256(0x197bde475771b4246752a27bb148ea66fb789b02848a36c21d84574d480a5779)]);
        vk.gamma = Pairing.G2Point([uint256(0x094fe5d3fb55457691ff2e66f9f3f40caa2f6a41cb00500eb09bda6aba0001c1), uint256(0x15ad06213c6a55b8e764c2af5f5b316606b7289397078d7121a1ece520460fe6)], [uint256(0x2ceac0fd86592a529e47efbf3135f06df3b6f359bacfe7f1efce268377f6e3ed), uint256(0x2ff73f7e45037e87c78ef609b53e4c070967b4ca70c0adc162f546e9850f4e19)]);
        vk.delta = Pairing.G2Point([uint256(0x02add3b5b01930956c09c4559e0a752bb7290f8c3a3f6b6b77328ce1aa234c7a), uint256(0x2e82e81a8d92ecb87b960026fd8b47a288ef910d703889d42d3fe896f64d9f27)], [uint256(0x2d58b469d65700c927081899144c0d6fbb654906ee1c3624a4c05b06bd8be0d5), uint256(0x1f037213db55c5ede1ababcc83050510d77e7afc6fa636564c4318c6dc68a602)]);
        vk.gamma_abc = new Pairing.G1Point[](18);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x16ab6c259f6f658ee1c6fdd12ee2b5521d17ea691362d753b5e56df5e5c96073), uint256(0x1bbfa4198b837decb6809986362676f27f93a94b9f43b52135f6bcfab0956966));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x004f276b460843c0b859680a103cd92b22951d93f2b672146db716e7e07a3f55), uint256(0x0e57497c43b31230a3c9eb27fd7c4a3849788b77254aa942c28631746d9bc260));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x2dea94fdf3a459c877c248649c800d4a6bb0d1b28cc95ac4c0a2849b3177daba), uint256(0x0d8959e97e727e40dc1795a14e5b176db9cafd9ec85fb492ddaa0c890b4b618b));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x16d14b74a5eeab6ae50c5ba464cfde39a40318f91138d3a897f9f03fe9a29c0b), uint256(0x1faca09f2e837f2304587071c7fd1f67630b7b79e87d7d40dba0d184140ada9d));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x16cd4d20508b94e701cb2a880b7d91971d46ad789c219c96439431fe3534b518), uint256(0x2fc2aeadaadaeb8384135cdbc8b87df0b70122f0b6ff6516e054584884af7f13));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x1ba8bdcbde50fab50c3546fd423faef2e199f3a1087a79b4ee13fb6289294f09), uint256(0x2de35badf3dfe91e9af21bf6c4e8216cf16705bf9f283eed08e551591c027a5f));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x2e76d3da9a61771e0211cc2d984d58f804e4430c24fe2a54155c6bb0af7bb2b1), uint256(0x1ea1f83c8c9eb9b86eee15f29479457547a3eb0889eccb463aa9fbaced210f84));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x06192a82d9f8e06aaf8df872269c8afd718a44ff0a425a969edcf340f9b350cc), uint256(0x030790245e29f29107b0347f3b95c0ddb29de79804f5dda69409ec58176c041a));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x24a17498df05cb660d267be705fbd4b52d4d30c718ec3b764080a734edc327e4), uint256(0x1dec8a2c377cf07d2cb4381dd5731e539be7da6236059dcf03f0c1ad8b3618da));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x024455a8a0fd34d4bdb2058ff210e6f6e29d661090509199a7a6b7aa25316047), uint256(0x2638a80457b3fc6fa1221b4e34c07e473e06fe391a82b5850a7b11e9f271d3e8));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x15646176e5e0cd97a9327d028c3fe33e5b1ecddcfbea7319918a639a38e457ef), uint256(0x13410b4dba5e83089dc2824d3febb65c9657353613fe90f2540ae18763bd8417));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x232bcbe945c9307f7b571b813b42d377bf4760a6dddad64d55ace5fa6d307b0e), uint256(0x12b53514201b318b0cd1ac84cf022989c8cb9c4e8058841b448cfb3b3cc2b156));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x0c172ccff97bb0a66de26a0e709ac8b757901b51f731b7eeef0ed7b989795342), uint256(0x0525c83d17c1a9d1f147749d8114af4eded743b4d67fbadce3b1598de772ccbd));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x0df317f292251b5e6141a73324b46a9c04d7eb98954b783632133b4f87747fcc), uint256(0x0027cc64e3b2c0d71b125a1b1688e0cd279156e0b09dfb90f0f79135302e017f));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x1dca3ad5b9de15ec2051b00966784927f2beabffaa537813b7ee6cd138b37fef), uint256(0x2899c604f8fcb2d6809ebc7284899234efc35bc6b46583dc7fc4cf25b57b888a));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x28c769a3c2d4f172308b7ed80db25f2bbf5d77ae60f827ea4dbc06983ed85ce3), uint256(0x2dc78f83e7ea63ec79de9dd669779b3bc3be349811c00a6366a5adfb0d114d67));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x032200361b7265a692f46e14709d35456a714704015556086e5b9c8bba9a7022), uint256(0x16ed836b4c2927755d9612fceabd05716f8ac04161b0aab505446b4f99366846));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x12e50bca3c5e68975b321ec954ba8e27acb4236cf613f63b45ca7e2c80cca4af), uint256(0x1c9690849c5f07f6c5b38eef271528697db6d0107b1cc7c7ecb760879bb30126));
    }
    function verify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
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
    event Verified(string s);
    function verifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[17] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
