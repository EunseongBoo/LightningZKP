pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract BurnVerifier is VerifierBase {
    function liquidateVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x1841adc1eec251ca605cb1f079d52f2c67724ce921c79cf5d3ef0d50d45a6087), uint256(0x04128140feec216a94186b21826ed7bbfa5618b65705499b5d8f7d1c9060baf4));
        vk.b = Pairing.G2Point([uint256(0x15f4db17f7075bd063f12595f786960936d79314cb90b4ba76a36b4b44d224c8), uint256(0x1006916fe071a6158226e21690a8487b243e0f87986dd8d2eac48341881fc870)], [uint256(0x2b0e9b575c42eda813481e2c5b8e59aa2593160ef31098b1a170e614ddc048f2), uint256(0x2936765562e1709525b7228d054c9bd67e295cb003b567a1cf33fc363ba548b5)]);
        vk.gamma = Pairing.G2Point([uint256(0x0a61452028764d84ad62b632e66c74da3b97a5485af703ee4e815dbf6849a2d5), uint256(0x2b2efc192ba4b5704d35168f0e3d50c176be24dd4ec3539247dcc2f888d576c3)], [uint256(0x04a24ec33689a6535d644af6bf163493580d55d940d5e924d8b82b0a96c2d0e7), uint256(0x08dd4c624b6cb9a5a7394eb99f37325605820e982b66fd0b1d9716777b8d8ba7)]);
        vk.delta = Pairing.G2Point([uint256(0x29100141c1ad2163cb4af0e13997de720cc32379b1b75e0229b9d25108ba04c8), uint256(0x1aa6a5fea2fea73ce01ae9484e7bf246e98e3ffedecc8a974d4be0e97aeb6f2e)], [uint256(0x22538e0f59e0070574dd2ec13bf3da29a6e885533489fdd2c616173dd3db2126), uint256(0x02f2eb6a80f19792876debdeb6a3984640d8d3ef5db80d86c490309d8b81c438)]);
        vk.gamma_abc = new Pairing.G1Point[](2);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x0f426f56caf53e49c7e7c2ebf08331195fd56082e8a4ebf7851254bf876c1a68), uint256(0x0e6987b5dd9d045c86beba73842bef90de39e3efe4b0b020b8a7e3c0f3b8991c));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x2158d862bb6408729c801e97fba32a866f91ff2e7d56470928b10a12945a337b), uint256(0x05ec5c0af04eccdd521d36a815ebe615062bf12941f8d95009dc6eb30216fcdc));
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
            uint[1] memory input
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
