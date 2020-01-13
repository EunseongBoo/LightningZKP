pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

    function liquidateVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x18ca723e4b06cf47f2abc780fea6a42d27a1bd8d60e31b50015b7f6ad9cd24b1), uint256(0x02810f30d975218260cbf950d949aa4ac18aa67395d0aef67535a4a2dfc7bee8));
        vk.b = Pairing.G2Point([uint256(0x2b5225b2c7339c7f17097b6e0256d44a023e8122b393dfcb3ed08eb49cc92d4c), uint256(0x1b939790aa325a62ba8869f0972e0465dae855124368601c2c3a5b07724abe28)], [uint256(0x08a9d22d5d7b56ca408a557e53885d585e31965d2104c18f1ad644184279dc9e), uint256(0x074b7d4d12f4bbaf1e681a35c75ad89452cc143691a03da2d3e5079064380b03)]);
        vk.gamma = Pairing.G2Point([uint256(0x14b77b1ca5ca534b5ef4d309fa6aad9ffd2d06f0df93db546e2581914abdeb5f), uint256(0x2aff4fc27b6df6b0a19fb66122febd7799d98cfbe03d3d5e8560ce58dd90f28b)], [uint256(0x0dc0a5a4c5eb941507959364d4ea744ae89c812526b02fa57444549a26c67678), uint256(0x24d0eded34d117246373f3a7b71048e971971c6d04ee30a93150421dc06a9a49)]);
        vk.delta = Pairing.G2Point([uint256(0x1c8e56f8558aba0e5aff051de66710cd1063123b50527a0d837021f38eb6089e), uint256(0x1479a4f92c06be91aae81edc9136cdba1cf6196711696ab2d7d9621ef803b865)], [uint256(0x2714ff7f9a31e4231b6f325f74318b5b0e52d1e48802753b688298940dcfd475), uint256(0x11c80a881cd37b2f971bf3a76c5e57c6d035c0d5a0e3e008589e4add52e0f852)]);
        vk.gamma_abc = new Pairing.G1Point[](9);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x09028bc0511f327ae5e10df562dc7b36bec8798fc76dde0ac39bef1d2a0020ae), uint256(0x1eb3683914e45d0a09fd13d08895648282b07f3fe500361d39f04a2b892efb4a));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x2530d6dfd8a6c10160521b39fe2ddad2d225cf549469086955844c2b9d1247e1), uint256(0x2a7532ac3e885aef2aa556fb65d416694196208a965570ea6f1cdc9b33a0ca6a));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x063f4e1f185961528d72631439faab2ecc350f305ccc22449f71b5aea9a21b7d), uint256(0x063e19c7b4c0354d5e81112ad610acd72072a7254173ee85873f3ea05f209559));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x247b9db0fb8bb08c8fdace53b96b60dc4dbabaceb3b153b6d0076b949afd0c4a), uint256(0x223e9ae4f8c83e69f1f13968ef907393ddb7aa7912b527a0201430c8a86cbef0));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x156d1ccd2ad6bb7ee1ca234549273eb9fbc6d6f5f41cb855c799273eba0a6953), uint256(0x197d9f082043784d8a053bfad2a6b360ffd558e0cd3dee562b8a0480dbf0951f));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2ded5427383c0b491bef91c8b0074de43ced146e70d5347c191be4a71dd8f935), uint256(0x2d90ecabe2743edcdf2e9dc71655c884089a7f6d42a7bafa5842cc3da0807c3b));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x1939a56de9851da6612eddbfee2d9f5be4fb4eb6d08f6ffeb42bf3a30fb7ffa0), uint256(0x175c73f86311effaf7c1553e6015888816b826bce4e78908a98634f90cf4fd3e));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x0ed2690d6ba0f9ec3a76552fee641d95008659bccee235502cbde3fed33f5fec), uint256(0x29131f90e65dbc0d030762d283f31db65d6528489df4f8b46e8fe336db6e1db0));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x2bbdba9b4f6420b5ccd7f4dc00f0e50065e9ce685c91f8eaab857c6f0ddcc0a5), uint256(0x1b6be5056b9aafa641a66cffa4b43f546451b5f55dc359820c39d08d666dad35));
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
