pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

    function liquidateVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x07228d8d2c430348e41b17b99e48de85948d5cf68891cae0355533d8446221c8), uint256(0x113d49c6178f8717443e0a22f70c630ae1f80aecfd6c3a3d9768ffd6d8622ad9));
        vk.b = Pairing.G2Point([uint256(0x2c3e4135708c16658fd46b536256d885ded04801f89a85cd1f583fcf99fe4792), uint256(0x062883351999f151997ba27e1d3dbc321c3401436621a79f1546a7a7227bcd33)], [uint256(0x2479e642231574384a33d16f074de81c384e7a90f6b6a55bb1cd93e8c87ab624), uint256(0x295538f8047e031214f85810467131804be42f5c7164c0f2f4b50e4733853f7d)]);
        vk.gamma = Pairing.G2Point([uint256(0x0a493a8d2f77e56ce68c99b215b740cd55fd9d58f4c606015a44744e16312db9), uint256(0x062c9e4a5cd1b188462c3f77aea7c443657f0591a53a2cef9672be9e9355819d)], [uint256(0x04daeede238d081a559f6976f002c3c7fc35ec0587db49e1f85190cd2bb7f902), uint256(0x0b1538daa0cdfd8fcf2831737f18a0e9605f4c71716cc527d6dfc7bc511a4315)]);
        vk.delta = Pairing.G2Point([uint256(0x09237146a4c041f4a7cb30969e13310c40e078158cda7dcdafe6f581805274d9), uint256(0x0d82aabcde7383fc8ff15f1d49782bfa9a2bcd5aa25668721ad5a49d2e6df20e)], [uint256(0x1bd11c35ada60bc67c990893d52a88c121cc69006e9a806280d8f5fdd613c8c7), uint256(0x14594d48fd55e5f2c7dc779b9d4a0aab04991ac89c0cbb08ca69671d5eda9862)]);
        vk.gamma_abc = new Pairing.G1Point[](9);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x228c640e2c18ad42834fbe47728c9ec4863c47516c301957e765892655955cc6), uint256(0x24203f7a39c43eb4aca781ab9722e2cd26d5c2e35ae447af45f302894a31556a));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x26d0249d81b194d201205f11828cef2c7c6d67ffea41c7942aa3e27b01af98ca), uint256(0x2e57ccdc382d9544d6ce12003dd189ca0af042ea017f6924061e32597c2caad3));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x061065c0b0de30b8a0899ee973ee4e4865be981c678049707fa5f725d858aa43), uint256(0x081d264454abb6424be12f333edc32582e0ad30d0c36f46bc2935c1654612634));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x273f16485a68a1233f589b335c93a5f0696387bd51e8327b7fb957f34604b689), uint256(0x2c28e7dd791b8c2be0134f69a9e5601df437ad211a721a321a830b1188bf97b7));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x185bde914aa245feca620490a523920add58cb26deaf7da87a8cff0f58236cc3), uint256(0x2ac59f529de4f3c6d2d732c3b803e3d8a6708c8641ec39c8232d52a5a75908c6));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x0daef6aa74099560ba58c23a3c51fcd5304f39cbf9e98e51be9075bd9edae4d2), uint256(0x12fa632f29911200161a089fef124a0961fef7edfba64a43e6c445c4360358b6));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x13aadf32e96e599d04a7d9635005db13bb82b75056bf5d3d90cab9c4a009c970), uint256(0x11069ef25b8957e7cf1bae2ea79f1b64d50e0cf1fdeac44218a6dec2fe3f8d69));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x217abd8d4efff170ccf3bd5ba7daa03ece267fe54862b84666ccc023d2542fd8), uint256(0x25ba7f2f5c1670808b10908598574055c0a5cd1e69d9bb4080dc27ab3cfeb575));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x0d4641ccf502f852549b9be6d9c2007190fc77f29a53eac7b685dc0f3514fdfb), uint256(0x19428071f0e6b6025397cca1a440b75e95d09a68e83aacb4bc98181317639c29));
    }
    function liquidateVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = liquidateVerifyingKey();
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
    event LiquidateVerified(string s);
    function liquidateVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[8] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (liquidateVerify(inputValues, proof) == 0) {
            emit LiquidateVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
