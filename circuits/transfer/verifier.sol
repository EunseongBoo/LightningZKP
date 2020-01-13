pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract SpendNoteVerifier is VerifierBase {

    function spendVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x29bbf8c989d3f354491f312d968ba698369c019ef78c35005a4e55778cc0951a), uint256(0x18dd1b75561887c524043ee7167c95d0761711781a14fe7e126be2f98a4db56f));
        vk.b = Pairing.G2Point([uint256(0x11b455d54a08745b7fa6565cc05f88064f72320b6af42cb28a2a7441fdb238af), uint256(0x06433bfecc5980714d365c1e53d01c2d20e4d4ee4653baafdb2d38dd9fcf406f)], [uint256(0x2f14e320cb1e818dec8c49b57e20139f1b5a9939adb3b59300b58e6614aa7b2b), uint256(0x05afbd7e96c49fbf55ed81abc203daa274e1aa59de81af1c7d1448e90da9292d)]);
        vk.gamma = Pairing.G2Point([uint256(0x0291c1d98a592fc9e6a25f71d34b3dc3cd32f5a76bdc9876ed80e5c6e5245382), uint256(0x08dd1d41aad49f2d2f20706c7dd2bbcda6b976cb3121892d098dd169f340af17)], [uint256(0x09a5f698db8b4bab166e4930410c8bed688296835035f96fe8657724a060672d), uint256(0x03e664e5212ea7d74b9db607f1d5d1161105484b6f71dbd507616fc68c7b5e22)]);
        vk.delta = Pairing.G2Point([uint256(0x082c8bb9b96f02a59729b9193141bee147b234bbe52323c7a635092b6e650ba4), uint256(0x04fffaa885a18e1b1dcfcc6756aafc704780d67eb374245d31abb0552ec6bb24)], [uint256(0x0b5c7b0786cf8a544fea4f030135c3aebfc7e60ce6d2a9df653f9210d4c5e432), uint256(0x08022fbcf41484093ccaf5fc236bb9358b839c4214570d239b5e8ed3b81ce33e)]);
        vk.gamma_abc = new Pairing.G1Point[](8);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x0812cc5c9ce9b11f5c99d917a93a25bacd4ad701a76143ba41ac43e21b8be53a), uint256(0x2db77b19c29b4a6145e5de91e3f99c60ec98ce46f5563ce24d147f25a886557b));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x0ebe82e75ad2951dcda89d6d0de0e1182756b2613b1b9928b9b6269bb1859b2d), uint256(0x18e8cbfa77824008b17714ba22a034d026476481bd0a2fce684ae2335b494f7d));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x28495bf7b79b71a33b2d0e91a1fd4ca292e56869f8b3b5d5fb25da4338e64ff1), uint256(0x2ea86eda9778e74383ab286593e90ad9452b5acf20014792a816efbd6a0c6c09));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x24173f1f0aa27e31e0b1645d0e716518a4bcaec7f39bbe734d6fa52734138115), uint256(0x0f3103776ff68c676b1eace59a0d84cb6e5d29d7437a5342c21ce2eb9ef47cb5));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x04dc77ae700c7c0f91aa23c55018d0a073fab788c74f5f37c2143d1d7a6937e5), uint256(0x099f599d345e3381d277c8c4059547916bfcd8dc8040b1db73061fa1f95d459a));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2ca30589bab371825607a4988e381cce3e67b83ac5c9c60f7e392017368dcb63), uint256(0x27d61cff326a0165e2cb4ebdeedaa294d8e49fcbdf94d531ecdb57f00c3a9c05));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x2668e2d6883062a87376d292a5b4b1f703c0e62a4f01b07e324d018896a736da), uint256(0x008d915eaf9bf997bb317d4665957f05cb528ca39220d2eb210a5e81d6890634));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x030f7a8a4876d1e142d32fb39e6cc5f38847432dc8335674f97b7598f88fce32), uint256(0x25fdf1fa0032d3d8986b0769fd72b8ed2e05cd805066724e6a8263f14f8e1054));
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
