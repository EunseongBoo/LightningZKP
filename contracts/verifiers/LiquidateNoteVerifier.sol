pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

    function liquidateVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x08e8fd47f4f47ca3bf35d3549cc9cbc9ee4980e7555623215f325533055db984), uint256(0x00ffd309565aa419ab4d5b0b1356a42cbd79a90b7bf5842ec7d77fbc903ec48c));
        vk.b = Pairing.G2Point([uint256(0x191aea51714d75793ebce74e92140ff5b9a72b2b21db0e7d38a9a6f6ec561e27), uint256(0x125e351f64102e5ed7413e9e1ae39fcda03f94b4952ae5024c1a979032fe17a6)], [uint256(0x2a38351dc02090cf4c992e0e79c380add7cf09e2efc156ec8638c44cb2659ae5), uint256(0x2057aa937ac295a24afe5fe8f41bf3b726c1e9a747a3d82112eb6f21a7249e34)]);
        vk.gamma = Pairing.G2Point([uint256(0x1596ddc83d27b9fc3e437ecfce0cfb1183aa2ec3218fe47b0dc87260e58cec01), uint256(0x1d1caa5d4c2f3eaf4e4a1c5834a843fa144f4ee7543144ab36cbed2d295b34b4)], [uint256(0x082e72deb2bdb3f1c744d2faed40b40a8e0095857798f5271c975574e4616823), uint256(0x22da6530029c6e8b34899b20fe962bcebae94f93f737268376261dd6710badc1)]);
        vk.delta = Pairing.G2Point([uint256(0x155465dc68c4a17a3844dca002ef1b0b361552491432dff1103ef28d66548afd), uint256(0x26a9b5195a4b0a709767168cfb17ffe6b006671136407b9291f20eab14133250)], [uint256(0x15d2db06487070c5abfe868a56d6db291353a00e87a7649355e47cc04a72d943), uint256(0x2e8c476822f4f14713679e51ec81f3ecd7a4e058b0a8210792c16b9c5237de89)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x045a076654acaecf344e8d6baeac13d52868fc24c9b07a948630a01a0403307f), uint256(0x08781c8e5717b83d3841478ec85437ce512b9db47bc88e2d9deff51f4cc52335));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x030852bafbd1dca04aa84803d07f6210ab89f1b76ddecc2f530fc5bdcd9115d2), uint256(0x134807c24cc6469a59ce3ab93874d819f1e471f432bc0381ecede614c0dfc999));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x229b98cb8f8aeabfd356cd7bb196730fce607346d63bb1947fed7dabdcea5e75), uint256(0x1edebbc7d906f9fff4f4f68ac6830e02a8850468920c597e7d121b88f8cbc3df));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1396ecbae3a957f73a2becd5490d94ca78d8506c6970fb7c52b4245c3f667754), uint256(0x2667d1e395f4c72043b442b51ba566c5d690c7d4cf03f40f7ed37ae9f3b2e70e));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x10dead365b530b87ec9aadc7ac7aa5dc2501f88a9c0dcac8f23290d6f0874612), uint256(0x0ec800383d251bc69c0d9add8bd57daec637178b1a0663ef5b0362c545709c0b));
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
        if (liquidateVerify(inputValues, proof) == 0) {
            emit LiquidateVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
