pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNote2Verifier is VerifierBase {

    function depositVerifyingKey_2() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x292d0823f235ad3aaabb4e9425f810e9698e137c7c95e13cfdadf7f4f7a971ee), uint256(0x0eee766fa931cc13effc8d2ea4425d1cd5fe894d8a043183c343caf41fadf466));
        vk.b = Pairing.G2Point([uint256(0x1a7a3038ca13b84173759c796b17b95ae33045514fd3832e8568bf44cb42b5e9), uint256(0x008becb714cd12f56f90c64fadebcc27fbe783eafe626f0a08a2e719d889cb2a)], [uint256(0x28c1f8291eb08fec9d0c7cf7a7b57a42392e303f715e1f3cdfc90cd5cbc4a03a), uint256(0x22d524df4750713b23d7e5b65487aa1f33f5b41d27f1ccf289b67e2d663c138b)]);
        vk.gamma = Pairing.G2Point([uint256(0x05ba6c17ba9ab8e9c4c0a45929b079da214b75cafad34f5a6f84693d110fd2e8), uint256(0x21575da48fd6b3e2c26c7ee0f52243420692f810e2a3ef75a54dead63af2fa13)], [uint256(0x200ff607073992addf65208c8125fb53d0701fef2762a87fad146710ea90a2a6), uint256(0x1789c3335f49bbcb0a65a3697c245808614bd3ddee0313c658bc6155d337631a)]);
        vk.delta = Pairing.G2Point([uint256(0x216a32ac33384153bb6d873c11362b055151b848bd10a7a5b57223d12a206e7b), uint256(0x0323df4abda932d3a77c2306a98862b797efb0662603d58475df5648a53989d9)], [uint256(0x1d8d7b4008c05fd9b368a2110f3c4c47774d908313c26d96f56ad0784a87b572), uint256(0x02a14ba6e70986fa2f842b5614c55d45c9ea6310311b8acbbe3c152c2e444e2a)]);
        vk.gamma_abc = new Pairing.G1Point[](20);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x12f70de0c6742b7b97d12c73e58513dcdeb6e0e4f489aacc151cdd9c3a13af03), uint256(0x0245568de95cff40941e83e9c429de291ba0766f52b2b96ac9b1ab9213d08d1c));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1ee181bef2ae26f2f6d92a49607215f318884a6495f0342af396e00baf4a6e9b), uint256(0x2e57294209cb98d4cee7d250dae0d515264528790eefb73bbeec89a04c343971));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0a04c85b74071e4c9f4d113c980a4dc43e72defcaa3b130f3006373c1f9fbbad), uint256(0x08e1841ef6b88f5361c91e832207d3bf93f8f34db40b87ff25391105adc38808));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x2297c4420f33cac8064c77b1879ce8ba4fbb96693add7230eb038aad05394416), uint256(0x156b159a8bc8eb02727b68c796b212cbcac6fb042b04af3e62a0b9aa8f72ddff));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x08d13cbe2cfc2136141699aa9fdd7400a030f3f0394dd936d3ef5a0551987a04), uint256(0x1dc7c2d99c3c53e3a8760ade994695e9bab0f779f07fb57a17bbf340ea109faf));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2a46445858a0837774298c382462638bda690f13472e88f84103bd48c1dce160), uint256(0x19ce570ef4b7593afd0e2a7a29d7432e083d584f1e4826520562cffefa8c08f5));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x00c2427337c9b5032b2658a06fc6356273fe5031e3af949cb857d483ab25a492), uint256(0x0e19941913e7d6350ee5dd8ce012b74bda39a9b0df0a76229a2abe72e2beb3c4));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x1c5ca00896469365dea326cad67f77912c17e3649fe514d1460cc749cc61ef03), uint256(0x0812c611edf68279d8520c2a86a959416566ee41c4b51fe372ebf3eb31c5946a));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x14782c2efd1d3059793073ed226b42f6d025454e98c189193abbe7e4a52fe801), uint256(0x0a7a86d1af5d14d05ca3cbdd883738e358fca698215ea141676e8a4cfe87ed40));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x26f92df730100fa4abe901815c9eefdf3354e36a44e1e56d2c6468b1cd901c7d), uint256(0x24cf04f8c01d9a0dd73ec89d0aac98e372c52d0b930d7c2fc8a06a012ff31a00));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x20451e9a417b99699423f8560e62d89a656dde1e4938af7820d438c1a9cd7f6d), uint256(0x1450d7d13415bd3abfda245d507b0ac481a5f3e44e7fc78c4b71e68fd731ceaf));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x0de37408a93e53d9f34bc805742c11d9e73255a684ea764aaad1902a924ef0e7), uint256(0x300aec663d6bb510ffb89a75c24410d267b23714ba88c3e1b1678e85b846d9af));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x09824957b03b8bc204c32a9d55f08f701747af2b94f4ecc515141101e8236147), uint256(0x010131724415964b04e22b7b9cfcdd4d1b93231ad748d18aed6d27b62648ffff));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x24bcd7261f5fef3a877a1154d1e8cb386e3c461d8d032ff3ea2ffa4589810659), uint256(0x1c3d9076fa8193cd947cb768cd7d0f14cce6084e0956c3b81db7a59c7cef4066));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x2b1e0971eb71d9c17e280e6e0e7aab6028dbac112aacaeb11ec310800413b7ad), uint256(0x1407fd000d0b6f91584b7eafe8efd16b4e16d22bfc15c0af64707130a522ae13));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x113b4d7fc31b4b5adbcc40058628b00ab804715b78dc076ef0d7afdf1038da95), uint256(0x0023cdd30c80d0de3332dabbd56345f4b52599d0aea5cc65eeb74101f35ae867));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x14bbfa4fa7b1d07b41b5e059640b5943e9b9ce2d0ca57252e304439fff0cef8d), uint256(0x12028d051a3ab3c7710d98d36d60968b15395102b9dd50e486249352f340aa39));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x25ac1c93d7432217501a081bf63b2008dc56e9dbe22062885912ca437d001f6c), uint256(0x01a2a8a83ae0e355b9988c62bd70c3ae3a2fbf4e91d4cb2e2bc14abba4458f1b));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x0b280d075ff8077e0a3d75e52f72d5d1967d78bbb070ddf99650d96f63fa2f9d), uint256(0x11b667026998eff21058c083765a5c5d4836d464f47ba01aeb6830e2195923ab));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x254458888b06137cc43e4c6ea0c46870d6b10f3f166af963b8fbca87216c7e6d), uint256(0x13e372bbe1bc75fb55adfa840b3994ce8c0567c6b326f51a296cd2476f040b30));

    }
    function depositVerify_2(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = depositVerifyingKey_2();
        require(input.length + 1 == vk.gamma_abc.length, "error occcurs in deposit in DepositNote2Verifier.sol");
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
    event DepositVerified_2(string s);
    function depositVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[19] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (depositVerify_2(inputValues, proof) == 0)
        {
            emit DepositVerified_2("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
