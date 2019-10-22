pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract SpendNoteVerifier is VerifierBase {

    function spendVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x20b9fe1ca62313774df900438fd3830e246107902a2d25369656534a12191bdc), uint256(0x10b7a6d819cde096987d519b596a3156e5a78318e2bdbe9dbe6366dbf4d55b76));
        vk.b = Pairing.G2Point([uint256(0x2efb46a991d60da787a1e67b0e684b23d1b060147a0f6c231c9885abd96b5751), uint256(0x2d4dd1a82076e9d0c35d37ffdfd4cf7a1d68c364e39e85a538c756a86e9401cb)], [uint256(0x1a6fe1a2c4b41ee3b646e0c11ca310c4b4389f9fbd4e4d8358449cd9d9d54f30), uint256(0x1839a05a396824760a1882f5f9845778dc7812927875b820ba4233711dea10ee)]);
        vk.gamma = Pairing.G2Point([uint256(0x27707ecbc54bcc5218202d918fc336dc831e766a487b01b7b1b47d48fae0b314), uint256(0x1ed91b5ed9d9cdf33745ddf3383848f03439dfecb4072c025860bb86b49c7eac)], [uint256(0x0dae9423db56e2eb98ca49367c96d51118c1a20ccd1f9212dace3ea26489d222), uint256(0x09d0d89c6939c46b6edf5987af235d9901842955073bc729eb5b17c3c20c1887)]);
        vk.delta = Pairing.G2Point([uint256(0x01853360cbc79d837411a425becb39c31ac7e3db09f1f68e70ba4ebdaaaf3014), uint256(0x1a3feb40fac7e13d8c20eeb34fb528aa1e7bf0c86d5058f4761565ed640babea)], [uint256(0x2811cd8e2ee06c4703a138671e85084f3bc04aeaaa6c8a68fdd0ce915af0a4f2), uint256(0x20bab6a1af8a8a4472fb0797b91a733dad961d1a4842e692381a323b92b2afdd)]);
        vk.gamma_abc = new Pairing.G1Point[](8);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x07150e206e48e70277361c823f8427faf72160487ce199ddb637dd80c9f6386d), uint256(0x01e6731c6c7f91a7b37723843b25ec2b34eeb48540692f603e93199c4bc4ad47));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x0a9b09eb8246f63a99e7932e76ec7e983404711b05542634128f7b661f722327), uint256(0x273f93d079666f85238bc1dbeb5b790d80100f07112c093a998d722f68de4f98));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0bc83aa66ab8ac9a5a5a15884ea7a789c38a340627a0cf97aaf609702bdc80c3), uint256(0x0ef40285974cfbbca1669eb7f483dd63718aa27ab0dcc336a2d2278b37b18149));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x08889543490ebe4a07289f5e4729376f18587426e54e775571d7957812189555), uint256(0x20d71f616b80e28171d732a7e7d06ab3e4f18cca247ee3a87b73d2ad07bcf0f4));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x114335c365bc16a23a120a9f6a26743e1c214bdb8f44e72eb05d0b84cb5cfc59), uint256(0x0f94323442d7ca9455d13a2ec88f05a283b694504d82edf5b42ebb166e9596f8));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x1c7f95ee0a542f7f2cffe47dc8280c0796568f4c5262dd2ac52d51c6239bb139), uint256(0x2154556f2853b794b5cb1f91fb494db8c2e2a6f291e46643f64c5473a7b22e2f));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x0e69ecc6fd75a0e6b7414a692b85ca49408ec59a46521675a0ee3c5c618da1c5), uint256(0x13ecae5628e1dfcedefa9defe37e399b7aaf409ac31a8e53c670537e1644cb95));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x1bef81a94293577959b1571d755ba28f98524761e7433b39f121b200f1fac63d), uint256(0x249a736c17ba9ef08b27791d4b36898b0b6ffd8e57cf5f4c851f737a917a9735));
    }
    function spendVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = spendVerifyingKey();
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
    event SpendVerified(string s);
    function spendVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[7] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (spendVerify(inputValues, proof) == 0) {
            emit SpendVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
