pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract MintNoteVerifier is VerifierBase{

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x07fc5876fe5dcac9ef8987c29a400f92cf3b5f21389aa8060328039959cd38eb), uint256(0x231488a94f41a2a833c7510575cf19566f8257360c2f80a2a631b60fd5ecb447));
        vk.b = Pairing.G2Point([uint256(0x131da73ab3519fb36c48b3915e8e99ccd6e24bdc5919ff22413d9cfc7723e9e3), uint256(0x11f4483676bc9d8147269c0acc2e0c4955d6349f6181d1d676cf0cfb066395c1)], [uint256(0x26625574eccf71e6a9eba76c28673e1b7bf424e4a3506fb14e989a25ffbea885), uint256(0x2f8193b7da9d94c61e7d7898677ef013fddaa1c28e5a60c22f39e52ed18b8704)]);
        vk.gamma = Pairing.G2Point([uint256(0x07d60b8e621a9edcd433d6f764e76209a09456ee4bde8b9438f799257ed84f91), uint256(0x11b17db38d7a575e9e44bfffc3f562d9f194d2fce8c9717cd62cecb74bc56ce1)], [uint256(0x120cb112d10798da931498e3f1ba869e795bf200cd8e938682b7b993b1c55fcc), uint256(0x2cf6c41cb2580184f06783a1007a02cc4e0301c1b26e7ef1f457e9ee7a218255)]);
        vk.delta = Pairing.G2Point([uint256(0x300905632636a6bafc41aa8864a638427d4fe3d5b781eb52287a18639b150e02), uint256(0x1de3e3e420a846a599f5e9a07e6e4641507f846ac911a6fb066617d945d781bd)], [uint256(0x22a97e9a453f577cc75221fb531a26f63c87dfb6e2f8eb8beaff247aebdef281), uint256(0x1e88cbad5da914abe5106b91001419f8c35d2df6ca0a58383f583590bf374c2a)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x02c37181ad32a6d21b92f33662a14653c76abdd532890587c5d25cf1633c2347), uint256(0x1afe05a145a8e21d68dcc1d2f717930461ee9cc49b6ba5be8254be01a796d52f));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1e0f388b9f55d453ede1e78673059956c2912603c571b57e715a237b7355ed1c), uint256(0x2d6e9d327b06df261ef66ddb792c21835caeaf9e635dfc596e5bc3f91bcaaf3d));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x2d805311d79becec5ac4027ca3692f65a7448d3c9958cc497f4c217f2f9abdbe), uint256(0x1f9bb0e9c24ecf18a59bd976c45494e60159e2ca6e15ae28574af0a6b55976f1));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x0c7d0cf4e39174d415301d2578e8418f9f00e95c96fc2426117bffca61b55c72), uint256(0x243fa4fa89c2b902bbb4ac0a1e4cdc8996e7132ce5347ddef44a25901c9ceceb));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x0ce5ff626308f30651eeb4d352d29d94c2cb4c7e9bf03513ebafa428962c07b0), uint256(0x21837f45bfdaf086cd421fd23d5278a8a894b9136f3b92d33ac983bc0ec8ed3b));
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
