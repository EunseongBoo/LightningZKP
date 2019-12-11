pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract SpendNoteVerifier is VerifierBase {

    function spendVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x212988160da5fa35b427d270987b7ea751402ec590db017384160c86dab5ace0), uint256(0x097b98f18cc94cafcca9baccd349469f901b23700d129814f0cac03b5c124574));
        vk.b = Pairing.G2Point([uint256(0x1bcfef2ddceb81dbf251bb58d157e81d4e15e850fbac8f6039468df1557318db), uint256(0x1b70c0c0cdae36c3afe05d92dee32984f513f2f07c06901789b1f12c4d1e9166)], [uint256(0x2abf11f506ba0913df96d6fcf8789fc46e0dcb5f4e82f8f1f435c768f974ad8a), uint256(0x188360a71cf3163321dbc7038d57a71c050e7a5040d78a7dbfcbe752dfc62747)]);
        vk.gamma = Pairing.G2Point([uint256(0x0b56454d70fa7d0c6eef80c8a78248c4a574cf49a1cf0ebccad421f9b1bdc812), uint256(0x0701deb0679df9636aa92883083f7f3c96017ae8434547e979505bfc572b86a1)], [uint256(0x2529f4317ff863e1949271caa74a637446380bf6992ff9ddca9acd06042691d6), uint256(0x2eac5982b1129e0efcf045407a2f2d7692bc7befb149ca44237a60d56dbef2f1)]);
        vk.delta = Pairing.G2Point([uint256(0x0a03fc513cddc5141274184a387170687363eb60ca0e6d7b3cba7a244cdb598a), uint256(0x1775b3f860b090cf6e0ae6f42f74df50fac9cfa43f231fa2d2b8286add146e8f)], [uint256(0x24126cc643ae8a5a641bb75ce4cd290dc6f1ce9cd69054761e0f2e45e3267ca4), uint256(0x0aa1ef59f70dbf29e20b4605db942f726fe6d6b4f516576b3a540307828c767e)]);
        vk.gamma_abc = new Pairing.G1Point[](8);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x21591a2e84ebe8d580a4b053dce7227f7f253e867bc49f7f4860864cbc47152c), uint256(0x07e6306305fa43e54fb09be2b4666cb9518d5a8c9ee86f9224f817a64fce50dc));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x05d592ec34699e5875567ed972a0da02e8fb793f4a64f47872bc70ba6dd07d86), uint256(0x2ff051db96a2b98c399f202f7b9de3316b74fd86b6937303a996bab134e24ae3));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x26c0a85e83de2840b5505bd32c78c43566e08a140bde322768b9159f5846ef7d), uint256(0x1e4f30d1b476e9d646965f9a33655d2cede7b6d136b57a0acc4c8224d09758b3));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1b65228423c8fed542ce18420bd7f976e4a4635069027823c2d59ece4c2d0e91), uint256(0x249d65c07a21dde3f9c7aaeabb0c7363e3ff23f5d6187f9939fbe2694ce51649));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x304c264485e9e33ee412556b3b67707b4a0d5b6ccd48ef94e461747930821a10), uint256(0x003a6d73fb5482d0ae0508645559377355189fec36f09d794677d0342e186a7b));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x0f6b3b56a28bfc1ccc319709154f1402cac143c59985391c1366a050b2f03b8a), uint256(0x12a75ec4b5efb4911d6c4cf934155479666813fe2f0929f782f433751df26eab));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x157e8f512d7fb00891ab4dc57419d3d712c2dbbf413a4a1ceb0cf2a93434daab), uint256(0x16fa0882a7c270b3dae9a4d5138eca42700723bd0d83c5f7816c98cd810f8750));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x2fbadd787a8bc585ef32ff39fffd695ae6577bd8bc6722a780ea799a6405af50), uint256(0x26e5d25ba4249e3aa131cc7444c2da8ef8ab2c14f2884c2eed2f98dfaaa8fc90));
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
