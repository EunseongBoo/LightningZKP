pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract MintNoteVerifier is VerifierBase {

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x1ca7596b7c378375879ce5a307dba3eb5eb14238832ca22ecfda87bfd6ef0635), uint256(0x18b7d07cd90b924ebbff0d2fc795ebcf9604bc08b91c751d12b5910423a240f4));
        vk.b = Pairing.G2Point([uint256(0x1e9fd5802c0a992eef5dd8f39716eaa9eae802204e60fdf94b36fd1ab557b913), uint256(0x118373b3bd5bc0390deb97af8fbe7f61a67c15ccb00d1e86bfd8d74ed6fe5c65)], [uint256(0x2b134542ec651d9ecc0795f325ddb04c9e24cc4abac9311c37943081c10a1cea), uint256(0x01a7eeb8f03195bb3674151d63fe3c68968cf2185c719e767b009ca3ab45f35f)]);
        vk.gamma = Pairing.G2Point([uint256(0x2400291c15edfcf8ed3d62c1c2e360a435fe809c825388a21479b3d0b20d86f4), uint256(0x16457b31ce37aaa6d3842e5b95c8890cc8e9d4d5a0692b0a83b3ba5d3c83ece0)], [uint256(0x21574025160c618bc92c4aa4c542a04b2fbddcd7119880de57a0d8d85bd3e6e4), uint256(0x233dfe7fa4d83108353fd695b73074a2b36d0a952f2f2c0dcabec29d12615867)]);
        vk.delta = Pairing.G2Point([uint256(0x249c6318f4fe54a127b1d9ea059fba4550e1b6e1def54441b96c1f1442439d76), uint256(0x1657095e1ecd5536d29d4070d957bb2eebb1bdbd7fa4cd1dcf80eceac8febbe7)], [uint256(0x01cc4147ffb4d4e96da04d441e00ec0b8b1ffe1337b8f7c7b47bd54c8cc63c6f), uint256(0x1df0e56aaf02fc3106160e62c17c92f0e2cd1395def3594be59bbb34aed62685)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x11925cb22821aeed7e10c5aa194b073730c92b69614df20e870dcd337b8f687b), uint256(0x170155368828586c0c23e82bf43582bad39b84249f18b7221c19f1934cb8d33d));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x13562fbeb26a5aac7921552bb6470e79adc17566aa79c3e731c56fb61886ca6c), uint256(0x023466d44a2cd74820778c47794f511f324b72dd26f88901ecbf8ff2a6c7314e));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x06a86a6c0d81699fd1b2112dbe4b8d50ab013f1514016047208529a36fa295f4), uint256(0x23feb67778a2db9c484a8fef77016666ba3ea3f934e4f990b7ff8a8a844219f8));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x06a5111dc6046d4d5857f0e1d19032e1579ee390a1cb556a78468b9e0aa65bd1), uint256(0x11d4868a261cadf0231ff0ac9d6e66cb7fb9a71c61ff517d9b3d3e47a29dae25));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x21fd3c45aacdb78a57b86e5ca80554ca5f9f0c8c8a285071bd53d86796c9afb3), uint256(0x216735bcf67a79f8d50ac05465a2b2f6f0bd4a5f417c352ad55ae761450403f2));
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
