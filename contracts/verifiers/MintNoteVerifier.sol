pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract MintNoteVerifier is VerifierBase{

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x1fae4ecd413ca1398b216c0c3d4735856768fe06050310f2b24e93846e012562), uint256(0x2ca7db4aa700b0377527eac1d88bf9a5f8f842284b9c17e1a676b56d98275caa));
        vk.b = Pairing.G2Point([uint256(0x00c057ea8c869953cc2969c8f7e9e910e92cc18db1da482fc286a04a981f3fe6), uint256(0x2e446ad64062d0493cf452d08f1e34a67c5b0601703c392fc784156c95a934e0)], [uint256(0x1b239ecd6bdae68953141382d2ec8fc72f0e9e9cf11663e9007ea53f6394813f), uint256(0x19410ee6da4a8df22efd878cae356ed8698d51c33cdfffec08e0f9a6a44dbbad)]);
        vk.gamma = Pairing.G2Point([uint256(0x1dd0ecca1d7d5c5fbc7ae284e7839996f853a29973c9bd6479a55bbb2e955699), uint256(0x2110c0b3c7870541327a141bebb6378d4b18baf07e31691cec7c5a83b2f7c9fb)], [uint256(0x05527ea33e439dd3140d729ee1400c1d4bec2952935778f5f7aa6ab3348962fe), uint256(0x2fc3dd960002b28734f0c4abc84f71016ba99630778d27329be0b0b48647cce9)]);
        vk.delta = Pairing.G2Point([uint256(0x2917a9b462f23932acfedabc068db254e740748740d56f25781fd19c4fd58221), uint256(0x21dde0660f0522d7e9c0be35e560d863f1817e7751a0957996f6118182b3f797)], [uint256(0x1065a356807947b7501cbccfa75b48996889a00fe786acf3485b803c948f38bf), uint256(0x2911071bd56d7a39cde796146a347efe46b15b203d4880c51bde73503ef43055)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x2cc870366c1940584032f6b5d6611126aa4e0f959750075f3da187a359a86f71), uint256(0x2de9ff6fc1eb6a6509c4b49e200e3a34e701c47890235ce7aa38d49137cbe8b0));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1b4a4e60b75d7b8e19f247e8ff8f598b853d1e3b8038158d59eeee4f433bbee8), uint256(0x2ad88fd86e7b61b43116c6305146fa56cb95f90b46a37d1f5e3a6cb288868da5));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x09eef616aeeb3bf6fe6d17a1062adaa71dd6275d9f18e031ff0dd3d2fea46c3c), uint256(0x1d79ff41013568cc8d15a0d2af6f824d93bf5a53aac7d8e93bd838084196252a));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x18aac35ed4d8f4c829439fbd24fbff629e692081cacbb2a11706b8893e3acfb7), uint256(0x0b0955aaaba3899cf0223ea2c9e5ce2348ab4b6908261023173d4b6ba90c563b));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x0995f21c52e7bbed05a4e7d0d2917337f459780582eec68c9c4ff4ebd1b09088), uint256(0x11b86f307ff2eabd60791c5ec3b9982103e1a192603c8fa2075b01db45441692));
    }
    function mintVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = mintVerifyingKey();
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
    event MintVerified(string s);
    function mintVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[4] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (mintVerify(inputValues, proof) == 0) {
            emit MintVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
