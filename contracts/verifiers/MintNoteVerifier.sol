pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract MintNoteVerifier is VerifierBase{

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x08ca2cf8aeea404385e3d1723070f81ade491bc6956e5ad79adeaf866e1ee4de), uint256(0x04d6db3f190d3a7403b3a149543433de6144032e202aae7c6d387e7a5561974c));
        vk.b = Pairing.G2Point([uint256(0x153eeb92b0efb2d3fafc32e73ed61597bd5f30344556894ba1ca1052403bba05), uint256(0x2f39672cc60b40b6194932260de111d14db10f1b53090f08cd0603b34dc2cdfa)], [uint256(0x0aa77b38796ff0361d3fc394b049e09254bb8dd28084fa41d143b02afe655920), uint256(0x0d7bb297c623e68794304dcc2fe6d9c6aaa8c41e225ae7806466f35624b428a3)]);
        vk.gamma = Pairing.G2Point([uint256(0x0afdd7378e1e0a91180fc372da474f8821af428712bc9d40617ad61a3f7e66b7), uint256(0x2b0a3e9b7dc27f15414772a56c847110cfa2b3a250d812f52c476a3f45f67200)], [uint256(0x1aa0351f613ed9a6a991f98990491f59286dc8b2b4f3eba66aa70b4fa9e32a5a), uint256(0x0ca7fc91938d8982664be729511725caf6cd5a8547b2589db401f256eca6afe8)]);
        vk.delta = Pairing.G2Point([uint256(0x2636fe8bdaddf1840b31d2ad291a96e2edcccbead5a7f7cd85d21093d804e952), uint256(0x16287baa1fe3f3f6e4395a2ad886ef6713aba9af87992e7718981769e92dd1bf)], [uint256(0x2ac9ce2ce8e3a5fabfff83a883b077d1878b6b2bfe4239311d7708a1b0a54fda), uint256(0x303d30c35d1a3e219f3add19b9c4ce79446bf6ac4d935e330d1e07c064ccae7e)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x03216a7af4943458a4cec6aa519dda0260256deb5210d4c55f222b73e86c1c28), uint256(0x2e67ae1250aefa680eb351f160809870d494313dea77279ac344fe1247b4c89f));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1a6cfe39304fd878b6bbc7ea9da836d9341f6703f9465e603f32483ec0cb4d35), uint256(0x083e0d202930c7836d5d563b8e6c9f1ac259ef49918cc09992f1d5b42c8af0ca));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x079f0d794ad90c19815eeabb3e0ab533c30d04d26469214e04f8c304d0ddef31), uint256(0x14798a4c945e06e1d24a5e96324f02816b9cee667b3db1b729a09daddc86bc32));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x0ced057f6243652e52409038d8e10d0d4cc4212c0b2e4f43b057b48689cc61b1), uint256(0x021f7719cb93b95fe4320c1b5515526c4384ac1924061efc1cc3355fd8105783));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x04875d8c99f5f2e7a7d7c0bf8126c5dff7dfd6dc50d333565b44dfb62bdc22f8), uint256(0x141b9a4ff7954477408fdfb51c2d33b0d44713373f59f7640e14f5bb8f3f716b));
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
