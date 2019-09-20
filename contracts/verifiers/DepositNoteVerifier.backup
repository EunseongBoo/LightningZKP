pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

  function depositVerifyingKey() pure internal returns (VerifyingKey memory vk) {
      vk.a = Pairing.G1Point(uint256(0x05f5bbf5bdacf492a5c442be4ffe3fe282a00aa34318dbb9abaeae5489ad1c36), uint256(0x2348723fcb46ffe9e020fa4a5d0ed3c4925fac542692d4b0bae928067c20c475));
      vk.b = Pairing.G2Point([uint256(0x1bec2455f4f1aa1b8d9a1d65fb7db7d75fe48c335266071077f4b38e5d0dda93), uint256(0x2ce148beba2d4935c476a0d113eb5c8e8d743e1277936735566aa2f6acf47813)], [uint256(0x2239a59700cc63464eb07b93e01310163e2bc17ac343be5cb7270e2399e7365f), uint256(0x0b63e18dc45a734b94108c3f62b50a3316d341dd421bc330681c2ea73fc312e2)]);
      vk.gamma = Pairing.G2Point([uint256(0x1c02ccbda818180be058aecbe6e01a9e21585a00668a04b4c878c1127a2df431), uint256(0x2137cfa2cab615878ef631d6bbb3e2610088b68617a079ceb1a48749419213d1)], [uint256(0x019607e7c142904d00eec5e3ace7717276dde9b8a14b9bb7fa98e6e787c47f7a), uint256(0x0796fb242c773689c0c82abaf22bb0ec2f8283325951312dc54b041afdbc563e)]);
      vk.delta = Pairing.G2Point([uint256(0x0d92f74517577f13b64a49d349b8916123724e17b7b9da8483870d44a03ea9d7), uint256(0x27377557a56a6ad40fb36f59f03aa6c7cce0f8e9370139027e283967c7a3bab2)], [uint256(0x153aaad3c1a5208b82e40729b4fcaa578f49cc815db5a880d55cbdacf84ca731), uint256(0x2fa42c5a9edb6c9af5e55b591a89761e39ec616485cf0652451b4aaf018bc5b6)]);
      vk.gamma_abc = new Pairing.G1Point[](16);
      vk.gamma_abc[0] = Pairing.G1Point(uint256(0x1625e2b4fde8683daca58e8c319daaf9ab491d858e75dbe8be21e269de40fe6d), uint256(0x0f4068bcdd11cc7cbb7cb2cbaee94b922b5a58bfe087d5b0e6642ddfc84cf3f6));
      vk.gamma_abc[1] = Pairing.G1Point(uint256(0x0e9ab233de64a1216a296558a5a34b11af08a933689a27a734e4f5c102f6a677), uint256(0x281d5a2fc48e9dd4782a452a5aa9a7ab0cc61dc1db411b42ea53b2614061cec8));
      vk.gamma_abc[2] = Pairing.G1Point(uint256(0x038874106c80c972d3e0f717bddc248a79272d33c4a24c50fb3adbef9a9ee979), uint256(0x033c7a3f17de321a2e5b2ef9a70d56e40b4ec983d7247ddef5ba0a467a8c788f));
      vk.gamma_abc[3] = Pairing.G1Point(uint256(0x0828d06200caa0c31215ceabcedfdb5de980cc7ee4e56912dd59503fd1e5081e), uint256(0x0b4114fdd634e242acd8c23405eb08e18aba4266908f3ef17835f276f9340551));
      vk.gamma_abc[4] = Pairing.G1Point(uint256(0x2ed57b6474a3555070b822ffef12bfeab4e47e6a66915333cca39aa7a8662965), uint256(0x0f1578586e8449a77b204f2362d26249347ccd126212c027d0db6631bd4638aa));
      vk.gamma_abc[5] = Pairing.G1Point(uint256(0x0e63fe0bcd1d6fd48fe3d13ef7c0b3623a55acc1b1297df6f2e59066ee7ea268), uint256(0x2e0cc629326dceebb1e391802e14a79efda0b7d0d43a5e29da144e6d61122ad1));
      vk.gamma_abc[6] = Pairing.G1Point(uint256(0x0278667b486000af1abf2040bd0663d1701bb8a5905c970e89a504a8840a17a0), uint256(0x07995b1e4158024f1a01e074f6c05e421dad81b69405dca53ade121b057ed6d0));
      vk.gamma_abc[7] = Pairing.G1Point(uint256(0x0f16b71e8075454f7097fd9b85c4e26feb9fec0c487db96f71b5c8a262ce1bab), uint256(0x0e772e76a9bd7e592ca1cf7d2198e00e41f43522964687007eb11967d23eb4e6));
      vk.gamma_abc[8] = Pairing.G1Point(uint256(0x10abf815e94837deb129deaa828cb127c1714d4a5ba2f1fae1d4c30f86b63817), uint256(0x1c16ce86d2ad7a307aedcdd6a0c70f387e269f20d32c0f1b4071c6280e0f9c56));
      vk.gamma_abc[9] = Pairing.G1Point(uint256(0x0f5107c23478b9318657a2152cf5b5c0e5c825fb7d3800ca8cea8131e35c6850), uint256(0x0152de71475f393cc604663c625897b46cb362e96255eb214cf0cfc2b1eabb13));
      vk.gamma_abc[10] = Pairing.G1Point(uint256(0x0d4d99ea8269fd6737c4a9374904b37f6455623969a7ef42d83d549da065d3a5), uint256(0x0695a585c5398f583b0ea3845a0403cd2ba33b52e86e63a3fd73a41aeae06061));
      vk.gamma_abc[11] = Pairing.G1Point(uint256(0x0dad9f729996b16d0647b6ee6af92eef037d116f091ab460c2109df603089f34), uint256(0x1223a547df4d3f0120e4e336b075bbaae9b53a0037beb38b1622bc0b9b89f373));
      vk.gamma_abc[12] = Pairing.G1Point(uint256(0x015ffc15c659b30cc3cab24c6b8aac91a3a5b438b2dd860587cc38c1e8607074), uint256(0x08776fd25154bc245efb6a5b597ffccd73ef12ecbabbeab7fbc0aa24ef8fa028));
      vk.gamma_abc[13] = Pairing.G1Point(uint256(0x13f58f2fb6b98169df57aa6cd99d44929f7a0bc3f42b8a52f82d3ffbb068998d), uint256(0x1444431cc27b6c3b73e5c541756790ca5f46a5cb59e22530e33881ce9e009133));
      vk.gamma_abc[14] = Pairing.G1Point(uint256(0x0dcf196a04bbcc3992ca2fadcb8c44443f048939221db10c6b87bb91e3a91620), uint256(0x0430669af959bdd410ed0de26fc8ee33d55801d03fa423142a273e142c19d1ca));
      vk.gamma_abc[15] = Pairing.G1Point(uint256(0x1a67f5ecfbe0500318853585b6b308f45bad115cf829bf26a05100655b35bcbe), uint256(0x0570b6a5cc3baff7f61057358408106f03bfc74944a42277486a825750ca7cfb));
  }
  function depositVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
      uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
      VerifyingKey memory vk = depositVerifyingKey();
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
  event DepositVerified(string s);
  function depositVerifyTx(
          uint[2] memory a,
          uint[2][2] memory b,
          uint[2] memory c,
          uint[15] memory input
      ) public returns (bool r) {
      Proof memory proof;
      proof.a = Pairing.G1Point(a[0], a[1]);
      proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
      proof.c = Pairing.G1Point(c[0], c[1]);
      uint[] memory inputValues = new uint[](input.length);
      for(uint i = 0; i < input.length; i++){
          inputValues[i] = input[i];
      }
      if (depositVerify(inputValues, proof) == 0) {
          emit DepositVerified("Transaction successfully verified.");
          return true;
      } else {
          return false;
      }
  }
}
