pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Burn4Verifier is VerifierBase {

    function liquidateVerifyingKey4() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x0a897a574dcf50c59ce041dcfc234e162d29a675d4c184350bc418431e19a945), uint256(0x189849ee0f705662ea7a57eeec90a151472e1d569dd2248333c3e3e7216a62f4));
        vk.b = Pairing.G2Point([uint256(0x2a6885ff0b6b3033778631e22c8104da5b32ea37acd1f69629756057cee65393), uint256(0x1e02658025846cd19dd2620c2213fba6eef5e56798f5cda67c3b79278f2da9c5)], [uint256(0x2c41eb28b3a474b791c66c10203d0bc5aff011a0dbcbc0925c00a5fa69a9976e), uint256(0x0cfc796207785cc08778dc6daebfe5b807422efd0eb31bce104437657d8c530c)]);
        vk.gamma = Pairing.G2Point([uint256(0x0b258b46fb5782adb4ea857cda6c5efb7bc600ed1799401b1cc1ec5b345546bc), uint256(0x2fb81150ecba5beebbb8fa3e89a69c1a559f3d98a85816b96f1c6a7b88bd2b83)], [uint256(0x145089d2f00f885db5759078756dfd9d7235c672d6a40fd09846d4948e7908ac), uint256(0x12f014f0902e5c8d93e799560951dc61de8d69b49fb3727964d41372b9922265)]);
        vk.delta = Pairing.G2Point([uint256(0x01f4fbb8685d313a96aa72bfd900081093672de9ce096e52506507485b22d85c), uint256(0x099693c811b9f62ed79197c1c5848f462d12a1b25b0e78cbc6a5975f4d17e1a1)], [uint256(0x17778b84513375791ef45adb7f144be907d9ecd6d691cfe1b9480ff61ba26965), uint256(0x0bca6f0c35456d873417b00e9764d6718aa642db2f1e7f904898154d56652b21)]);
        vk.gamma_abc = new Pairing.G1Point[](2);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x01fe204a175e4054931fd9bf0a6c3a8ff56fd5b4942aa66dd3edbc49c2285f3c), uint256(0x17801939ac5bef89e5a3b26e8ab8563fb39179951913c90ca42191d0c644ee47));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x064a6523944bad649adef60ade9d803ce9e77650ae39224d996b74c805e49237), uint256(0x0b6c8207e958998068ebfa3ade340d1f0bee137e84d043fbc0e05149fa0fe089));
    }
    function liquidateVerify4(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = liquidateVerifyingKey4();
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
    event Burn4Verified(string s);
    function burn4VerifyTx(
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
        if (liquidateVerify4(inputValues, proof) == 0) {
            emit Burn4Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
