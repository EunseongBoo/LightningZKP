pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x08355b3d065dfbb9624e326a2e2f0f3f46d03c764e7bab886ac04b58baec76d3), uint256(0x14e51c4e9d67b30020275a8894b33494a7576024fcfc936de1f41723b30715b8));
        vk.b = Pairing.G2Point([uint256(0x188d28d2c16f59475d2a90c4d44b0d63c47ac7feae0c0629a555aa1ca452f960), uint256(0x28caa50da784de9e4f1db05209bb8c72a4717d1ccf36ebf424a11b843ea8a886)], [uint256(0x116aeced947d887ed053c43508518bac9ed21ac5826ca5060d14836ca2519d16), uint256(0x2c807c4a7f6547e60dc22dd964e551e0f24f6e211d0e58d491c2d37a4b09d758)]);
        vk.gamma = Pairing.G2Point([uint256(0x1e4d559312520227259978c98eb176f77a7d9f47f0b5a180b4e6e43815c2a55f), uint256(0x19a2896bd3b81448b1c2ee880e3e54399251cadb755d16f73d6068c1e556c806)], [uint256(0x21abc544c278d045e9aecefdab7de03ef6273b84c768b580f3c8dffb7a85f2cc), uint256(0x2c9db18636aef6434344db20a0919e32e35a73802b1bce6b3ba58daa2ac4c97b)]);
        vk.delta = Pairing.G2Point([uint256(0x03c4184424abad74d268cf5f1f495a8c6dd42552cf4fb966e44519e82cea4c6b), uint256(0x2e9e290fc11abf4ee12f9ab4326b5fbe0cce3a7edf0873246d5e66dc8c4220a2)], [uint256(0x1e6a295e147bf049331512ef9777e0258dd472db058f86e02428f9dee86d635b), uint256(0x033fbc383ba3cde056d766e7bcb402e33d8a51c435c2362a104ad762151c3171)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x23e75180d258bea032b2786ff65cfcc9fea0d3ec80d41ad0f8fcc00a9f7e99c9), uint256(0x113ed1d5e901624d1bd2e35e50758dbec9585c9194ef0b02399d756ec3b4a2ba));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x02348e5e1cbfaffca63202016004f73c165e68d1eed2e4fa9920a1d4f9f71e90), uint256(0x148aa797000e24de203e4d261f82c0b650545d6ab33a1615a83ce7ad189520c4));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x010612dd2cbd547111aa3208cceb96c9f13e47bd9880855588b4b0b1dd46a7d2), uint256(0x1a7308de25396b809c17bd3fa685c8b37d06e32c4a33a2d0fe99ab667225eb78));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x27ede1c53da903ee1576d254f167cb249efae8b703072a8652c63b2333dbc461), uint256(0x1c2afc39feb8aae5ddef07ac10c4b98045df0deabb745d6fa25066878719e1e9));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x07be509466155d348e63a0d2822339cb798ecc0318be2c1fb41463fe6dd27da8), uint256(0x27c3f27568ca1d1cb995e62a51425f7a91e341924a36373fc7610c8fda501569));
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
