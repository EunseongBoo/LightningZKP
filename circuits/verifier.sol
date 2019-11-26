// This file is LGPL3 Licensed

/**
 * @title Elliptic curve operations on twist points for alt_bn128
 * @author Mustafa Al-Bassam (mus@musalbas.com)
 * @dev Homepage: https://github.com/musalbas/solidity-BN256G2
 */

library BN256G2 {
    uint256 internal constant FIELD_MODULUS = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47;
    uint256 internal constant TWISTBX = 0x2b149d40ceb8aaae81be18991be06ac3b5b4c5e559dbefa33267e6dc24a138e5;
    uint256 internal constant TWISTBY = 0x9713b03af0fed4cd2cafadeed8fdf4a74fa084e52d1852e4a2bd0685c315d2;
    uint internal constant PTXX = 0;
    uint internal constant PTXY = 1;
    uint internal constant PTYX = 2;
    uint internal constant PTYY = 3;
    uint internal constant PTZX = 4;
    uint internal constant PTZY = 5;

    /**
     * @notice Add two twist points
     * @param pt1xx Coefficient 1 of x on point 1
     * @param pt1xy Coefficient 2 of x on point 1
     * @param pt1yx Coefficient 1 of y on point 1
     * @param pt1yy Coefficient 2 of y on point 1
     * @param pt2xx Coefficient 1 of x on point 2
     * @param pt2xy Coefficient 2 of x on point 2
     * @param pt2yx Coefficient 1 of y on point 2
     * @param pt2yy Coefficient 2 of y on point 2
     * @return (pt3xx, pt3xy, pt3yx, pt3yy)
     */
    function ECTwistAdd(
        uint256 pt1xx, uint256 pt1xy,
        uint256 pt1yx, uint256 pt1yy,
        uint256 pt2xx, uint256 pt2xy,
        uint256 pt2yx, uint256 pt2yy
    ) public view returns (
        uint256, uint256,
        uint256, uint256
    ) {
        if (
            pt1xx == 0 && pt1xy == 0 &&
            pt1yx == 0 && pt1yy == 0
        ) {
            if (!(
                pt2xx == 0 && pt2xy == 0 &&
                pt2yx == 0 && pt2yy == 0
            )) {
                assert(_isOnCurve(
                    pt2xx, pt2xy,
                    pt2yx, pt2yy
                ));
            }
            return (
                pt2xx, pt2xy,
                pt2yx, pt2yy
            );
        } else if (
            pt2xx == 0 && pt2xy == 0 &&
            pt2yx == 0 && pt2yy == 0
        ) {
            assert(_isOnCurve(
                pt1xx, pt1xy,
                pt1yx, pt1yy
            ));
            return (
                pt1xx, pt1xy,
                pt1yx, pt1yy
            );
        }

        assert(_isOnCurve(
            pt1xx, pt1xy,
            pt1yx, pt1yy
        ));
        assert(_isOnCurve(
            pt2xx, pt2xy,
            pt2yx, pt2yy
        ));

        uint256[6] memory pt3 = _ECTwistAddJacobian(
            pt1xx, pt1xy,
            pt1yx, pt1yy,
            1,     0,
            pt2xx, pt2xy,
            pt2yx, pt2yy,
            1,     0
        );

        return _fromJacobian(
            pt3[PTXX], pt3[PTXY],
            pt3[PTYX], pt3[PTYY],
            pt3[PTZX], pt3[PTZY]
        );
    }

    /**
     * @notice Multiply a twist point by a scalar
     * @param s     Scalar to multiply by
     * @param pt1xx Coefficient 1 of x
     * @param pt1xy Coefficient 2 of x
     * @param pt1yx Coefficient 1 of y
     * @param pt1yy Coefficient 2 of y
     * @return (pt2xx, pt2xy, pt2yx, pt2yy)
     */
    function ECTwistMul(
        uint256 s,
        uint256 pt1xx, uint256 pt1xy,
        uint256 pt1yx, uint256 pt1yy
    ) public view returns (
        uint256, uint256,
        uint256, uint256
    ) {
        uint256 pt1zx = 1;
        if (
            pt1xx == 0 && pt1xy == 0 &&
            pt1yx == 0 && pt1yy == 0
        ) {
            pt1xx = 1;
            pt1yx = 1;
            pt1zx = 0;
        } else {
            assert(_isOnCurve(
                pt1xx, pt1xy,
                pt1yx, pt1yy
            ));
        }

        uint256[6] memory pt2 = _ECTwistMulJacobian(
            s,
            pt1xx, pt1xy,
            pt1yx, pt1yy,
            pt1zx, 0
        );

        return _fromJacobian(
            pt2[PTXX], pt2[PTXY],
            pt2[PTYX], pt2[PTYY],
            pt2[PTZX], pt2[PTZY]
        );
    }

    /**
     * @notice Get the field modulus
     * @return The field modulus
     */
    function GetFieldModulus() public pure returns (uint256) {
        return FIELD_MODULUS;
    }

    function submod(uint256 a, uint256 b, uint256 n) internal pure returns (uint256) {
        return addmod(a, n - b, n);
    }

    function _FQ2Mul(
        uint256 xx, uint256 xy,
        uint256 yx, uint256 yy
    ) internal pure returns (uint256, uint256) {
        return (
            submod(mulmod(xx, yx, FIELD_MODULUS), mulmod(xy, yy, FIELD_MODULUS), FIELD_MODULUS),
            addmod(mulmod(xx, yy, FIELD_MODULUS), mulmod(xy, yx, FIELD_MODULUS), FIELD_MODULUS)
        );
    }

    function _FQ2Muc(
        uint256 xx, uint256 xy,
        uint256 c
    ) internal pure returns (uint256, uint256) {
        return (
            mulmod(xx, c, FIELD_MODULUS),
            mulmod(xy, c, FIELD_MODULUS)
        );
    }

    function _FQ2Add(
        uint256 xx, uint256 xy,
        uint256 yx, uint256 yy
    ) internal pure returns (uint256, uint256) {
        return (
            addmod(xx, yx, FIELD_MODULUS),
            addmod(xy, yy, FIELD_MODULUS)
        );
    }

    function _FQ2Sub(
        uint256 xx, uint256 xy,
        uint256 yx, uint256 yy
    ) internal pure returns (uint256 rx, uint256 ry) {
        return (
            submod(xx, yx, FIELD_MODULUS),
            submod(xy, yy, FIELD_MODULUS)
        );
    }

    function _FQ2Div(
        uint256 xx, uint256 xy,
        uint256 yx, uint256 yy
    ) internal view returns (uint256, uint256) {
        (yx, yy) = _FQ2Inv(yx, yy);
        return _FQ2Mul(xx, xy, yx, yy);
    }

    function _FQ2Inv(uint256 x, uint256 y) internal view returns (uint256, uint256) {
        uint256 inv = _modInv(addmod(mulmod(y, y, FIELD_MODULUS), mulmod(x, x, FIELD_MODULUS), FIELD_MODULUS), FIELD_MODULUS);
        return (
            mulmod(x, inv, FIELD_MODULUS),
            FIELD_MODULUS - mulmod(y, inv, FIELD_MODULUS)
        );
    }

    function _isOnCurve(
        uint256 xx, uint256 xy,
        uint256 yx, uint256 yy
    ) internal pure returns (bool) {
        uint256 yyx;
        uint256 yyy;
        uint256 xxxx;
        uint256 xxxy;
        (yyx, yyy) = _FQ2Mul(yx, yy, yx, yy);
        (xxxx, xxxy) = _FQ2Mul(xx, xy, xx, xy);
        (xxxx, xxxy) = _FQ2Mul(xxxx, xxxy, xx, xy);
        (yyx, yyy) = _FQ2Sub(yyx, yyy, xxxx, xxxy);
        (yyx, yyy) = _FQ2Sub(yyx, yyy, TWISTBX, TWISTBY);
        return yyx == 0 && yyy == 0;
    }

    function _modInv(uint256 a, uint256 n) internal view returns (uint256 result) {
        bool success;
        assembly {
            let freemem := mload(0x40)
            mstore(freemem, 0x20)
            mstore(add(freemem,0x20), 0x20)
            mstore(add(freemem,0x40), 0x20)
            mstore(add(freemem,0x60), a)
            mstore(add(freemem,0x80), sub(n, 2))
            mstore(add(freemem,0xA0), n)
            success := staticcall(sub(gas, 2000), 5, freemem, 0xC0, freemem, 0x20)
            result := mload(freemem)
        }
        require(success);
    }

    function _fromJacobian(
        uint256 pt1xx, uint256 pt1xy,
        uint256 pt1yx, uint256 pt1yy,
        uint256 pt1zx, uint256 pt1zy
    ) internal view returns (
        uint256 pt2xx, uint256 pt2xy,
        uint256 pt2yx, uint256 pt2yy
    ) {
        uint256 invzx;
        uint256 invzy;
        (invzx, invzy) = _FQ2Inv(pt1zx, pt1zy);
        (pt2xx, pt2xy) = _FQ2Mul(pt1xx, pt1xy, invzx, invzy);
        (pt2yx, pt2yy) = _FQ2Mul(pt1yx, pt1yy, invzx, invzy);
    }

    function _ECTwistAddJacobian(
        uint256 pt1xx, uint256 pt1xy,
        uint256 pt1yx, uint256 pt1yy,
        uint256 pt1zx, uint256 pt1zy,
        uint256 pt2xx, uint256 pt2xy,
        uint256 pt2yx, uint256 pt2yy,
        uint256 pt2zx, uint256 pt2zy) internal pure returns (uint256[6] memory pt3) {
            if (pt1zx == 0 && pt1zy == 0) {
                (
                    pt3[PTXX], pt3[PTXY],
                    pt3[PTYX], pt3[PTYY],
                    pt3[PTZX], pt3[PTZY]
                ) = (
                    pt2xx, pt2xy,
                    pt2yx, pt2yy,
                    pt2zx, pt2zy
                );
                return pt3;
            } else if (pt2zx == 0 && pt2zy == 0) {
                (
                    pt3[PTXX], pt3[PTXY],
                    pt3[PTYX], pt3[PTYY],
                    pt3[PTZX], pt3[PTZY]
                ) = (
                    pt1xx, pt1xy,
                    pt1yx, pt1yy,
                    pt1zx, pt1zy
                );
                return pt3;
            }

            (pt2yx,     pt2yy)     = _FQ2Mul(pt2yx, pt2yy, pt1zx, pt1zy); // U1 = y2 * z1
            (pt3[PTYX], pt3[PTYY]) = _FQ2Mul(pt1yx, pt1yy, pt2zx, pt2zy); // U2 = y1 * z2
            (pt2xx,     pt2xy)     = _FQ2Mul(pt2xx, pt2xy, pt1zx, pt1zy); // V1 = x2 * z1
            (pt3[PTZX], pt3[PTZY]) = _FQ2Mul(pt1xx, pt1xy, pt2zx, pt2zy); // V2 = x1 * z2

            if (pt2xx == pt3[PTZX] && pt2xy == pt3[PTZY]) {
                if (pt2yx == pt3[PTYX] && pt2yy == pt3[PTYY]) {
                    (
                        pt3[PTXX], pt3[PTXY],
                        pt3[PTYX], pt3[PTYY],
                        pt3[PTZX], pt3[PTZY]
                    ) = _ECTwistDoubleJacobian(pt1xx, pt1xy, pt1yx, pt1yy, pt1zx, pt1zy);
                    return pt3;
                }
                (
                    pt3[PTXX], pt3[PTXY],
                    pt3[PTYX], pt3[PTYY],
                    pt3[PTZX], pt3[PTZY]
                ) = (
                    1, 0,
                    1, 0,
                    0, 0
                );
                return pt3;
            }

            (pt2zx,     pt2zy)     = _FQ2Mul(pt1zx, pt1zy, pt2zx,     pt2zy);     // W = z1 * z2
            (pt1xx,     pt1xy)     = _FQ2Sub(pt2yx, pt2yy, pt3[PTYX], pt3[PTYY]); // U = U1 - U2
            (pt1yx,     pt1yy)     = _FQ2Sub(pt2xx, pt2xy, pt3[PTZX], pt3[PTZY]); // V = V1 - V2
            (pt1zx,     pt1zy)     = _FQ2Mul(pt1yx, pt1yy, pt1yx,     pt1yy);     // V_squared = V * V
            (pt2yx,     pt2yy)     = _FQ2Mul(pt1zx, pt1zy, pt3[PTZX], pt3[PTZY]); // V_squared_times_V2 = V_squared * V2
            (pt1zx,     pt1zy)     = _FQ2Mul(pt1zx, pt1zy, pt1yx,     pt1yy);     // V_cubed = V * V_squared
            (pt3[PTZX], pt3[PTZY]) = _FQ2Mul(pt1zx, pt1zy, pt2zx,     pt2zy);     // newz = V_cubed * W
            (pt2xx,     pt2xy)     = _FQ2Mul(pt1xx, pt1xy, pt1xx,     pt1xy);     // U * U
            (pt2xx,     pt2xy)     = _FQ2Mul(pt2xx, pt2xy, pt2zx,     pt2zy);     // U * U * W
            (pt2xx,     pt2xy)     = _FQ2Sub(pt2xx, pt2xy, pt1zx,     pt1zy);     // U * U * W - V_cubed
            (pt2zx,     pt2zy)     = _FQ2Muc(pt2yx, pt2yy, 2);                    // 2 * V_squared_times_V2
            (pt2xx,     pt2xy)     = _FQ2Sub(pt2xx, pt2xy, pt2zx,     pt2zy);     // A = U * U * W - V_cubed - 2 * V_squared_times_V2
            (pt3[PTXX], pt3[PTXY]) = _FQ2Mul(pt1yx, pt1yy, pt2xx,     pt2xy);     // newx = V * A
            (pt1yx,     pt1yy)     = _FQ2Sub(pt2yx, pt2yy, pt2xx,     pt2xy);     // V_squared_times_V2 - A
            (pt1yx,     pt1yy)     = _FQ2Mul(pt1xx, pt1xy, pt1yx,     pt1yy);     // U * (V_squared_times_V2 - A)
            (pt1xx,     pt1xy)     = _FQ2Mul(pt1zx, pt1zy, pt3[PTYX], pt3[PTYY]); // V_cubed * U2
            (pt3[PTYX], pt3[PTYY]) = _FQ2Sub(pt1yx, pt1yy, pt1xx,     pt1xy);     // newy = U * (V_squared_times_V2 - A) - V_cubed * U2
    }

    function _ECTwistDoubleJacobian(
        uint256 pt1xx, uint256 pt1xy,
        uint256 pt1yx, uint256 pt1yy,
        uint256 pt1zx, uint256 pt1zy
    ) internal pure returns (
        uint256 pt2xx, uint256 pt2xy,
        uint256 pt2yx, uint256 pt2yy,
        uint256 pt2zx, uint256 pt2zy
    ) {
        (pt2xx, pt2xy) = _FQ2Muc(pt1xx, pt1xy, 3);            // 3 * x
        (pt2xx, pt2xy) = _FQ2Mul(pt2xx, pt2xy, pt1xx, pt1xy); // W = 3 * x * x
        (pt1zx, pt1zy) = _FQ2Mul(pt1yx, pt1yy, pt1zx, pt1zy); // S = y * z
        (pt2yx, pt2yy) = _FQ2Mul(pt1xx, pt1xy, pt1yx, pt1yy); // x * y
        (pt2yx, pt2yy) = _FQ2Mul(pt2yx, pt2yy, pt1zx, pt1zy); // B = x * y * S
        (pt1xx, pt1xy) = _FQ2Mul(pt2xx, pt2xy, pt2xx, pt2xy); // W * W
        (pt2zx, pt2zy) = _FQ2Muc(pt2yx, pt2yy, 8);            // 8 * B
        (pt1xx, pt1xy) = _FQ2Sub(pt1xx, pt1xy, pt2zx, pt2zy); // H = W * W - 8 * B
        (pt2zx, pt2zy) = _FQ2Mul(pt1zx, pt1zy, pt1zx, pt1zy); // S_squared = S * S
        (pt2yx, pt2yy) = _FQ2Muc(pt2yx, pt2yy, 4);            // 4 * B
        (pt2yx, pt2yy) = _FQ2Sub(pt2yx, pt2yy, pt1xx, pt1xy); // 4 * B - H
        (pt2yx, pt2yy) = _FQ2Mul(pt2yx, pt2yy, pt2xx, pt2xy); // W * (4 * B - H)
        (pt2xx, pt2xy) = _FQ2Muc(pt1yx, pt1yy, 8);            // 8 * y
        (pt2xx, pt2xy) = _FQ2Mul(pt2xx, pt2xy, pt1yx, pt1yy); // 8 * y * y
        (pt2xx, pt2xy) = _FQ2Mul(pt2xx, pt2xy, pt2zx, pt2zy); // 8 * y * y * S_squared
        (pt2yx, pt2yy) = _FQ2Sub(pt2yx, pt2yy, pt2xx, pt2xy); // newy = W * (4 * B - H) - 8 * y * y * S_squared
        (pt2xx, pt2xy) = _FQ2Muc(pt1xx, pt1xy, 2);            // 2 * H
        (pt2xx, pt2xy) = _FQ2Mul(pt2xx, pt2xy, pt1zx, pt1zy); // newx = 2 * H * S
        (pt2zx, pt2zy) = _FQ2Mul(pt1zx, pt1zy, pt2zx, pt2zy); // S * S_squared
        (pt2zx, pt2zy) = _FQ2Muc(pt2zx, pt2zy, 8);            // newz = 8 * S * S_squared
    }

    function _ECTwistMulJacobian(
        uint256 d,
        uint256 pt1xx, uint256 pt1xy,
        uint256 pt1yx, uint256 pt1yy,
        uint256 pt1zx, uint256 pt1zy
    ) internal pure returns (uint256[6] memory pt2) {
        while (d != 0) {
            if ((d & 1) != 0) {
                pt2 = _ECTwistAddJacobian(
                    pt2[PTXX], pt2[PTXY],
                    pt2[PTYX], pt2[PTYY],
                    pt2[PTZX], pt2[PTZY],
                    pt1xx, pt1xy,
                    pt1yx, pt1yy,
                    pt1zx, pt1zy);
            }
            (
                pt1xx, pt1xy,
                pt1yx, pt1yy,
                pt1zx, pt1zy
            ) = _ECTwistDoubleJacobian(
                pt1xx, pt1xy,
                pt1yx, pt1yy,
                pt1zx, pt1zy
            );

            d = d / 2;
        }
    }
}
// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.5.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }
    /// @return the sum of two points of G2
    function addition(G2Point memory p1, G2Point memory p2) internal returns (G2Point memory r) {
        (r.X[1], r.X[0], r.Y[1], r.Y[0]) = BN256G2.ECTwistAdd(p1.X[1],p1.X[0],p1.Y[1],p1.Y[0],p2.X[1],p2.X[0],p2.Y[1],p2.Y[0]);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x04acfcc098503568c270ce128b8cbec5bb47ae1a71257f307527b173791d8dd9), uint256(0x1a79025842c875f374020bfc37bf9de9b56bac24a8ffd570005b51ea0e3fb355));
        vk.b = Pairing.G2Point([uint256(0x2b496324b49c2d149d62de8a3aae65642b04f6dff24952ff425b2445ff20c6c2), uint256(0x27ee0655dd6e3d377ded0fd765031bc78b2d7859ab83f29091db8182b9cbfe0e)], [uint256(0x00b8c5469da3082c2d2d19bbee0c61caa5c783ed38c2fae4eb50314a6e850f4f), uint256(0x05fb1c3971f90cfcd0069c328869d46a3a2a6aeee2c64a92d865835168d6ee31)]);
        vk.gamma = Pairing.G2Point([uint256(0x14dbcb922286b8a1b59f5320d377fbc0554bcbceab4e215a0a5ef121d75972b9), uint256(0x039b07822af9ca309becdd28fbcdb3b7865ef9a1d64778714cba92ca1352112c)], [uint256(0x200f0c478ee459cc80a8ca8fe5aef71e42e2e46ed5d11aebf08bd2c5def2e979), uint256(0x1bc40e34b32747be8b49ad3412a0996fe9a4d3a5403a86003069aeadbbc13271)]);
        vk.delta = Pairing.G2Point([uint256(0x02b7be099d6e7cdc795ce2ce4b63b4b88b930abd31951ad9c87a5492d96c222f), uint256(0x17ba98d36e020aaffe059d8d6bb2bf0dd0514b2d0b325851853eb84ef90b207c)], [uint256(0x0b588e8487e36a36c6742733e5addb9fa779aefc8159830d181ba5cc33fd6a85), uint256(0x29d237d5924743ff5275b3a1b628edf46ae21df447c01124e08a6be45ba92d8a)]);
        vk.gamma_abc = new Pairing.G1Point[](92);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x214bb6d91d9db3089144ca8aff8efc242574456151bee7a6b388f4fe3f09b910), uint256(0x12ab447d4f3db3bd88e31fecc2f75bbd1af61e50d14bfd805b463d3fd5ed379a));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x04c200125b578e95a59583b994c8742ceaf0ca5a0f5fe0594f7305d74d570968), uint256(0x2928ccf311999d9d5387bd82fdd6790def844be23a8955859d12d2e79bc0250b));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0f7cf463dc44434fb4958b8e044d349672cace6b6135a20c0b8ce0e7a0e75bb1), uint256(0x0940afcf6fb76370ec73ca4566a32164109656955b48b7f35ddb159c9df8d9e0));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x2e350646d1e43ce3c6063edf38ecd822806d6529d449496a5231d426e74e6a73), uint256(0x1671162c76afd08c5f38e36a8e46645aff46a971a52fcb77468190d51b9f1a45));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x12eb8da7f14fe53bcb2a19aef44f6e9ccc8bf6497c8896b480257c8449a000b2), uint256(0x1edf3ac0294b298feefc969da55210f6429c87db0e9575f972903bac3b7173f3));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2107b3d9540371cc49816bc5d24019a67d34691d45f9c1f70d21707f4ca6ee79), uint256(0x0981b3481a42a050e1ea9d964b2abc6094a094f508e1a308fddabbb20a284dcc));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x1e23f40a167494b78543de717afc9a446e2cada312e7883b60fc8fb508125b35), uint256(0x2cb60100f3d4cff4287c0e547bf25ff4839b9f12bc7e0ba804bd90529e075a85));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x08738d4651a31cfd3a5ea8068c9409982b2fc916b33dfbd211763b6c30dc34b9), uint256(0x1513b0c4dff7c9ba97b5a72d15e6752bca6d17ec4b32f35af713257c55aca85c));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x220be717946b3dcf634f79733877714933f706aee1c6ea2aa6b242782595fdf7), uint256(0x0d981598a1f369c8e5a60d40af53eeca70684e0513dda59bfa430720f56c5893));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x26014eb4a149aff2929fd3383b5959286d95dea39f3691f6548fc87d99ea7b6e), uint256(0x0117a33a483c276ace90b06348371394f124667168a9989dfd9606628d1d0610));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x0648b9fd39e31796a6e0d368210190b719b721722989563ee3f597eb86e60f53), uint256(0x2c3671744a4bd31d07abbea76a5825d91455ed9e6f43d0eb08e93b7472ac7824));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x20ab58d063d66239012df602f64582b7010d7a55dd6f542609e0c60520b82428), uint256(0x0f4cb7b8068fb1b6944b909b76b33cbc732a572ec1fed222ad33f045ec2d70b3));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x2e81bc4faf44cf2e291fe558a8e40fb5a3c5d3644bacf4b4308c0818e5c5a10d), uint256(0x274c1203d5f96d16b28b053796268a06af39f28629fba2e140030f9781f95a05));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x248668ecad9f4b74eafcba25131ac1bc2037523aa25175a31f38ef5136ecc35a), uint256(0x2031e1537e22e2ff978c0787cdfa2e949e6ec4fa750c8e9ac43dca2fcd6249f3));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x2b3b32dd73285ffd8513518ae48f4a877fb91a6d014fedef17f3358169e050da), uint256(0x2e8c759b274b2446582fb361a0ac8218e18cceda94b0cac01019967815f5f401));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x0713fde3b889ee6960ca1be2ba1ad8822fab7bb9964b133a64663f70e2b1f8b2), uint256(0x0145c0beaec39132d60c10e1d4f94141a8bf7d01ec0e19ad1e21b2fefcf0fae4));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x1029988add099e8337f1e825ac3ed24a7239dd8e7ae9cad608d0ddd68c44b645), uint256(0x04087767c71403f838d6a96af84b2f2f7a277679b338c6b22315e1772d85ae35));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x10a473d41872b881e9885f22f37a4446d182508217f75c89f00df667f8a5af93), uint256(0x25e7d3a11f99f2e8ab590c6f71a5205a81357d2a6711376540b1a7b7e6c2dbf9));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x085a6c4375efbc30af6cf802810751e9d75ac88ad1552934c1a209a9e474f926), uint256(0x2b98e0259384e472d23da41c3e3eab76a7076c38f5632f9ffacd55953eb6d0f2));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x00020618d4ba1d7686a88cef80f3578946af95203bc166b1f5c00afb90b51f3b), uint256(0x017472c1cf942ae16b74f75fb0d1b8430e15b80cd381de216a6bb2c955108c5d));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x0e820ef34f2961ed3464a12891eac02eee8a512df473e7542bf4308b69787e1a), uint256(0x0ea2f8b0b5b4e173298da792ceb3067467b89fc4ea9c848e90fe8354cb969cab));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x1ced3d9ad75ab8da46d57fa72b45d6e396ebcccd4d18384e07d4cba50e17492b), uint256(0x009fd9fdac34d5d4525ac121c8c852fbb48874668f4de3c6a662034f7c6e4ae6));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x1bce8ca762625f0156eadc3ca3b6fdb4a4a1bbe5bc51e7d37c51195067cdf97c), uint256(0x25d30e6a5197e5adfff57f558269d4c8361eb0bb2a71612e85483987c4ee166d));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x10317d72a5e8f63d05bc0426860ca379d46362507824aec0b0c1312a603bdcc2), uint256(0x008023db98b5da9a0da270f60e30a0f9a479ee408f659a288301747da57f0ddc));
        vk.gamma_abc[24] = Pairing.G1Point(uint256(0x0829ed4e9c1363d15b3fe4399296f201eff300319bd0b664a8e5096d062e1a01), uint256(0x18182324c9e1d63cea1c2c5c45c575c8745206fb3a5a8570ca85e4ebeb7c7425));
        vk.gamma_abc[25] = Pairing.G1Point(uint256(0x1d994126942d2eef0dd55cfdb8dbd20535ab366d8b872ddaec5b70a657b504a9), uint256(0x0cb3f45ae918fa2b13d2db6731d88957363f7b2d7bcd24c1454b6ca4d44d049d));
        vk.gamma_abc[26] = Pairing.G1Point(uint256(0x286be089d8d51e18e9fef236707b4033d1ccd50535d4954317b246abfaad134e), uint256(0x19c51990d753e4bf2378c39c159a8fc85948a4e50f2360795a7b92a823921ba4));
        vk.gamma_abc[27] = Pairing.G1Point(uint256(0x208bb9e6d24731ff1d1e4a6efbbb11c692da797ce118d9d93a96b40246f5b8ab), uint256(0x12a6a7eb12799f5124b78a172c8ba5ff83f6c42d42df15b5ab93516e2120db24));
        vk.gamma_abc[28] = Pairing.G1Point(uint256(0x215bfdc12e90d304f7e8c3c811801f64e86dc9ef86a529597572e4452ea00525), uint256(0x2cb7eda68576b99b95bbdae90b6ec8b5cded9a927692a5329667f7705a2bf676));
        vk.gamma_abc[29] = Pairing.G1Point(uint256(0x063c05d43a4454a8a1942d17de72356f6648c0172d40eced4d34e2cb0baa0890), uint256(0x0505d4bd85f23941b9a054aefcaa767f07e8cc02ae029d5fc8775d2d190ad8cd));
        vk.gamma_abc[30] = Pairing.G1Point(uint256(0x1168b2957a383b5e2722fe7166c7afbce00bfee01fc44a5c4181e5b404cf4b06), uint256(0x0de6f609004f570cb1417337f7738a3855b515717da0c565f723be4c8af9e6c9));
        vk.gamma_abc[31] = Pairing.G1Point(uint256(0x1df14d9771b790acd58e29c5713a999b926b9abcab92f919688074297dc3ac9b), uint256(0x0a38a8a65551f2a42b8410bb7fb3957b92c2a4a8a545dd581d471e284114f1ec));
        vk.gamma_abc[32] = Pairing.G1Point(uint256(0x21db41e5ae92167384da47ac668dfa4fece44791124d2fc1fc21fe7431152587), uint256(0x1a3c700cc4ab4d0917fa734778a04a1954addb86669c94fcad1ee805105f763a));
        vk.gamma_abc[33] = Pairing.G1Point(uint256(0x182ee6ca05169a3760bec6adcdb3950bbf619588486b076048b7d27c4be4c62a), uint256(0x13c7a985805bb5313d6044a679d52d9e3e8b927e7f0aea93d279f3bfc171aa57));
        vk.gamma_abc[34] = Pairing.G1Point(uint256(0x1e3857aeda12523d8c4c895f6d5e56f229ac0b06226dc9404a60511f1b813c43), uint256(0x187a9f7bad5aee31727fcf6bd269de8f5e81f01974b7ca7bcd0ae2f85c49f462));
        vk.gamma_abc[35] = Pairing.G1Point(uint256(0x2c637f4d7eccd2bc40aab24fb4dd6c3aefce4fd5201b31a60473ce20eecc0ce8), uint256(0x0f02109aef91116db3a7deb678af7a4138f47c0c62393fda1facaaff5e539ad2));
        vk.gamma_abc[36] = Pairing.G1Point(uint256(0x12f90c6691427a07578515bd12525bd1fc9014731410c5201f3bf3260aac7674), uint256(0x255a246e127d93d598a572684555c4613792b00d68656d5f501cc292205b7448));
        vk.gamma_abc[37] = Pairing.G1Point(uint256(0x2e45c7fca21c89a28572010d55874d0383bbd22d517cb4c567f00ee07b06524b), uint256(0x0b94f438524ae567ad2b5753e41a1ca9ddbde2b743513aeaafd18bd36d898da1));
        vk.gamma_abc[38] = Pairing.G1Point(uint256(0x1817d81fb646b658735685692eecadb9414d77873b5380ce858b597b26f9287b), uint256(0x02d236688f596f9350802764e5f9735d522cfdcbea360628e953d1cef0a31282));
        vk.gamma_abc[39] = Pairing.G1Point(uint256(0x02168b44ed8026fdca1134156ae490afdcb0e21a4cc6ada5ebc765c0234daa12), uint256(0x2a8d63408d83836494375deec08a0ebf268ade6cdc4b875073bb1423bfe385f0));
        vk.gamma_abc[40] = Pairing.G1Point(uint256(0x18aca9a7b6a8ec3fde13269cf9781dd9fe8cbead5d70c75be566a0f3f005b8b2), uint256(0x010a5251189a38a3fcf06ab8caf9143462b7cae0d0db571dc46ca42b259c673a));
        vk.gamma_abc[41] = Pairing.G1Point(uint256(0x22718e048f6b4203ea986e2a4dd2f658558379e357b8fe13b1f26326942fa841), uint256(0x17520bcd19014f29cd14d1bdb58bb598aa40905f44fab18dfc6a358a2a18ad8f));
        vk.gamma_abc[42] = Pairing.G1Point(uint256(0x0da8f727c297c5d58799e563c84693e2d443a18dc757cd22781b617ab876e716), uint256(0x182c044751c5288afc99d3a98409b698cfeed225a7c5ece44fb98fc04d04dfb7));
        vk.gamma_abc[43] = Pairing.G1Point(uint256(0x0f5aa46f960980e6ba4124068c5959320fabe7610c703d85b63bda7545b67f32), uint256(0x0be8f1c1846d9851766be733f669321a3e8884b63c264ded53a59cda2e366434));
        vk.gamma_abc[44] = Pairing.G1Point(uint256(0x1b301d2e8fa2799d9ae0c87dc1c43f4fa9b4cdd584f2c57675d4fda7ad10808d), uint256(0x2504b4985001c1717b4b35d7a9a1051d9b61049b0b65eb9540f35adfba185605));
        vk.gamma_abc[45] = Pairing.G1Point(uint256(0x2ac7ae0cdfd59688e6390d05f3e1ee1fc2c7ef7c537a92369ca781536afe49bb), uint256(0x00d3a9a36e781f29f02452f31edf00314e2873274d786653d9f91a0e3f65abcf));
        vk.gamma_abc[46] = Pairing.G1Point(uint256(0x2c10c7c52ca51071f4eadb0f21649154d0960568105c51d16c0073f351e3bd88), uint256(0x0948466ba101a8162dbf0bde523e5562c54be85efef724f577a18b30a1e69feb));
        vk.gamma_abc[47] = Pairing.G1Point(uint256(0x24307c2d23fd2c2d80e768c17a700b91bffa55b3fd63f351950285a9b2c235e6), uint256(0x2c3cfa7898681cbfabf537b165cb98267589650475f0634607ad126131b150fa));
        vk.gamma_abc[48] = Pairing.G1Point(uint256(0x2cac970a12285424924fa142f16a120c8918a7c30c9b8b1913926c8a91d7960d), uint256(0x1c35c120539aa8b67ce0c0bd09c26e9e7664cbfba36c6122406d9d5dfc9140ea));
        vk.gamma_abc[49] = Pairing.G1Point(uint256(0x25fd90812fad3676bb823daa4a78a9d2d68e60affc1415e34cff208394f9e61b), uint256(0x176b79f08eeea7863114a41928d050cd979e53ed2fb6fb70567dd011d73766a7));
        vk.gamma_abc[50] = Pairing.G1Point(uint256(0x2570fce8bd1c5feb245d57ac2e7fa9b8370fb572daec3fa3a43a917d6614f4e9), uint256(0x1bc61bb27f32ba9b9413bb16ab5d9518364e1ab0fb88fbbdfdf730e80ef072e4));
        vk.gamma_abc[51] = Pairing.G1Point(uint256(0x158ace3de9097fe6f0a0c359f2c1f75d7cdf63cd5a1ad49e0d489c80a5bad608), uint256(0x287668d425a3e7635733ee3ba57d22514a390baaa562063359ab33059bd5f902));
        vk.gamma_abc[52] = Pairing.G1Point(uint256(0x19cf5946e9149c987331e8dc88cf55a45ce66a4d9ac13f127d3c76c9dec14a54), uint256(0x1ce5eb5f63f2619fdcdfd5d976612ec3ddc7b5adbce814bebc24be03f527f934));
        vk.gamma_abc[53] = Pairing.G1Point(uint256(0x1e3a2fcdf44a2d0f25d000e0f128779d6767423775466be85349b8b1c775a8a9), uint256(0x059cf4df07b5f1e190090be560a849d191023ee40deb1cc061f4a2806d4391ce));
        vk.gamma_abc[54] = Pairing.G1Point(uint256(0x287356aacb8be0e0f2d27be1622d2f3416cae9ee39808839fd295844cc6b6605), uint256(0x288abbd02041c36ed0fe183b0acc149b3dac6388e403a115a7fe218b112f41be));
        vk.gamma_abc[55] = Pairing.G1Point(uint256(0x1083ec95792b02dfc0fa02c7e430a7f9e227cbfcd9e36b1925c553a492bed7d3), uint256(0x2eb729f80d2fa0b3f44181e1636e2fcf171a5c1fa9967db8224ab9ae289812d2));
        vk.gamma_abc[56] = Pairing.G1Point(uint256(0x1afa9aba648dc60a0eaa74d03399b5b4194ab2373ca831590acce41a512ca1c5), uint256(0x14c6161ef747fb8176af92a88825beb67d3e358af54c3b54ec0ad5b10239f169));
        vk.gamma_abc[57] = Pairing.G1Point(uint256(0x10ddd8d8672938bb6506433668586dafff99648d92631b7aba0df1b84310e977), uint256(0x12432aa7de04df773bfa28888ec6980cc8fd341173d568260a7b9393f8ec4c70));
        vk.gamma_abc[58] = Pairing.G1Point(uint256(0x14e4100a5a9227c1bb54495b704108ac3a0f4c7f2d7375168b9a6bd779682269), uint256(0x08ea820ece77692aeb0c2a42c92ebddbf51b4cbc09562ab7c1772c1a6cf5bc5f));
        vk.gamma_abc[59] = Pairing.G1Point(uint256(0x2bb3476946a7f210db8bbf17ef78dfc1ad883d69563187e4ab6935482e0b4dc3), uint256(0x2fd9ac3ca44154ff3b448ac83fd711e7a4f0d17583cda23b4296424da9e610da));
        vk.gamma_abc[60] = Pairing.G1Point(uint256(0x17670073e770d5f95728dbbf516003a60609c0078efd35854183d056c7ebd694), uint256(0x2d4afc331f0979cdb93cba80b5f1e923a95d26336ab0300e1421c922e92d4c87));
        vk.gamma_abc[61] = Pairing.G1Point(uint256(0x087c13832b859a9d61479b3817f5e437da28903ff0265f61ee38dcf4247d2b79), uint256(0x2b9ad56f3242fc511d26ba4e1999ed89bcc373767160192f529acb5878dcf75f));
        vk.gamma_abc[62] = Pairing.G1Point(uint256(0x1fcda0fd9130665e86d5b140f7928143ab22b60fa6eb268809df3fddbb7fbfdd), uint256(0x15b7e956894b357a1893ec6be018a92b98b17143273c87409c3410d3e1af784e));
        vk.gamma_abc[63] = Pairing.G1Point(uint256(0x0f2aa908fddb71d078c0dfbb0f8c1fd8af750c4b7c4d3a1e23b032a5683f70d8), uint256(0x0fad159e91790a6c60b2ef7e54e835a288ced9fead474fa232e4013f8113ed42));
        vk.gamma_abc[64] = Pairing.G1Point(uint256(0x1a87fadb04584f3c218142be6a11a4c44c356427a2271f55cb88b90b572f8fd6), uint256(0x0a51034845ecda59a19bd14d852839cfc8166f819388127c121e7fee71f9f87a));
        vk.gamma_abc[65] = Pairing.G1Point(uint256(0x05bdfa4cded293efbecb8e1732099e9b0c9b55f3e3a164a9751acea351823fba), uint256(0x195804190e145f4b9118d9731a5bff76b1cf55016cff4581472f77ab33151772));
        vk.gamma_abc[66] = Pairing.G1Point(uint256(0x20d814f45c02e53685ff2d43aa003933b490aa7e18048d8d3a3db941152ce241), uint256(0x0e8343a07445dc3d824aed129651b16b355f7e650410f13918b9c8d15a22e26c));
        vk.gamma_abc[67] = Pairing.G1Point(uint256(0x04442b573224e4aae7f504d6054ffb6ea0d50fb184c0d851fe2ffe9fe459d348), uint256(0x269876ae50c59147db90cb3c16cf2d362964844c78a6116b0a40ddf10060eaef));
        vk.gamma_abc[68] = Pairing.G1Point(uint256(0x2877114ecea667cd72ac5fb2eea4f54fdaf58f703f6a434fd1fa6f277818f349), uint256(0x0327c888bf1eb3f18cfb7f116cba99171140b63bf4c5c404dfb2aac913a0461d));
        vk.gamma_abc[69] = Pairing.G1Point(uint256(0x08810d49c49c630ae2075cf923afeb74cb684343b9fb3ba6da0d7b468f047e12), uint256(0x029a15dc9aa6241beab24010e7c2a92afcaab8e2d0b775443faaffb479a48b71));
        vk.gamma_abc[70] = Pairing.G1Point(uint256(0x0d10ab01bd5e121ddff9d41fcbfa28249d7e5ab8a70abcf26807477e9a473797), uint256(0x1f1ff739ec4ba9f2ec195e52ecfcf7d93dfe2effed07b4da0b40000f73c27462));
        vk.gamma_abc[71] = Pairing.G1Point(uint256(0x0180104459ca94ecdc19e5b101b0fa5efca4d22fa68818cbfe85fa760171c595), uint256(0x0634097bc910e7fa7557f86d11b5a32ea12d217960cc82982bbdee3a4afd657e));
        vk.gamma_abc[72] = Pairing.G1Point(uint256(0x07ce05cb2f35b5dc9974289ccd5ef460db1ddd8a81b48c2811c1813354b4409c), uint256(0x0ac1d5b87b550f1c4ccd35cb7cd048f0da8f4cf005489063bd26f94a729c9a18));
        vk.gamma_abc[73] = Pairing.G1Point(uint256(0x1e2370f3563fd6aa78070952064374f10b529d6cd681df130480c028f12f9c82), uint256(0x1d18f012abb8bb6b0f913def267c0a05b4e094a4624ed6a75ac807bea93a678a));
        vk.gamma_abc[74] = Pairing.G1Point(uint256(0x100d8314df03777d94fadda789dfc9aa7548e6209333575bf663add7e272f7a7), uint256(0x136e9abe4c04ce87a2ba466da19c2f708ebc988d3a0d9ec54b56c7db936c6390));
        vk.gamma_abc[75] = Pairing.G1Point(uint256(0x16824a7b0ef48b2ed5f1b960fc9e72c1cdcd39cb9d93fdb2900705c4d5923589), uint256(0x121786ce78f64be36f34bea3e4165c4702313e6e8852c87e7fd85a1e12c52b1d));
        vk.gamma_abc[76] = Pairing.G1Point(uint256(0x22357109164a60937765c12d5d065130cf15265f5ea95a17a0bbfa05bad39f76), uint256(0x1991f9bd27f91bac84fa7a7b1f5085b45be04731917b5cd6eddfeff6f17eb3a5));
        vk.gamma_abc[77] = Pairing.G1Point(uint256(0x1f469b78493c575226b2727b0ca10b416304b17d866564215d498c2cdb666cf6), uint256(0x11cc43c0153f61837ad198a9636f00edc9e531240ebb1e6bcd490eaca29dc285));
        vk.gamma_abc[78] = Pairing.G1Point(uint256(0x0cfce757cccd5365087a6b3beafc8e0062db1ec348de643a15a6a8a308450b0c), uint256(0x07995e50ba34a453e49ff01a4652e2bf59750c6fd2454b477c63e25d1fbeff85));
        vk.gamma_abc[79] = Pairing.G1Point(uint256(0x076f55ff46187b3fbf700416bf1b0eca6f90fa8a1cc468f5e0150d87e8f8da9b), uint256(0x2b22ede22911d0c76a43573f8409816f063ab7db2ddbb87ab02e1bfccb019890));
        vk.gamma_abc[80] = Pairing.G1Point(uint256(0x14d6eef71bb7698c976c993e4961f9352f638b354d172940ccb39c2427ce00d2), uint256(0x261b0ccfe50e903dc8324456c873b3028bf3b598dcb437d2893ed59299121e1b));
        vk.gamma_abc[81] = Pairing.G1Point(uint256(0x0d7667bb5d03b0691278527e4da57d7ca8b00a40039e53806cb9e5a57afdd705), uint256(0x1b92f66a63d006b280924f3b02d34484a7ea495609ac4f65810f754dae0f348d));
        vk.gamma_abc[82] = Pairing.G1Point(uint256(0x22152dee28da39f3cc9793b574a0e110475b2d1c9a1ef8d79b3c9a1bbb681cfa), uint256(0x0ae528454d3acdcecc357301315d513617cf813be37ec9fe3bfc52ace44c8ff6));
        vk.gamma_abc[83] = Pairing.G1Point(uint256(0x27ecc8c2d6b2eb3e8d50a547395ef66c26890c53b0d08ca16b8c7257932a7827), uint256(0x0d68102b8d2b317adacc87759a4e14ea12b5f516465f735d728b80b0e95025b4));
        vk.gamma_abc[84] = Pairing.G1Point(uint256(0x0cdd31bff8d3bd34e22aaae9a473600b3870c264b81b1e35f5a1590451e9a560), uint256(0x2d848c017fc03273a6e31e0786cf025e73e2d7bc9297470b22241b7099c18d65));
        vk.gamma_abc[85] = Pairing.G1Point(uint256(0x09999451c59b1bfa5aca4fdb5901406b6110937a13232aff6ee4a6378f832501), uint256(0x1f44890bd888e703925121c42c0f180b02cd377f75dc35194f2a4d761b1a9c92));
        vk.gamma_abc[86] = Pairing.G1Point(uint256(0x09d1dc5e05fa6e0d0152290a69c6c6f45ad73c7cc3674576c8fca5ac69ff4110), uint256(0x173732b34dd1f50f897b6547513388bbc363245d99685399bac27dee6d3ef764));
        vk.gamma_abc[87] = Pairing.G1Point(uint256(0x2cd542ec837c4443545cec6553edfc0e8a0d09252dd743205295d5ed26f46170), uint256(0x2205c75d6e059a35d4d09b19290bb39e2475d0f9c19c8ca9aa1f7af480040bec));
        vk.gamma_abc[88] = Pairing.G1Point(uint256(0x294a76c6b3a1a0ac1d89fc0e51f6ce7eb2d8e519c08914c2f45540428a327244), uint256(0x1df2a8dbe3590f8e6a924e3dd19e07e8c001b0b3ff3d516d843f8ab32131f755));
        vk.gamma_abc[89] = Pairing.G1Point(uint256(0x1195b8ccc9ee12504bbefa9b62631176cdf99c1178f53048e1b23e5f2d2ed6c0), uint256(0x053ab003d32a1777f173748130c46b7ce0f37b38fa625ef97a58bc3dfae5844d));
        vk.gamma_abc[90] = Pairing.G1Point(uint256(0x0c12cc31d6722b28b75fa20308c1243d5b086e1abfea8221a3b02a32d02ca4b1), uint256(0x2164463ffb3c229f17c61a3ea5ff0a5e73ddfc45cb665b71e7a73d3d0b370dae));
        vk.gamma_abc[91] = Pairing.G1Point(uint256(0x06ce837b7d3f3ca9283cedd30797bc93b3b849ac60a34dfa1b9a261be53d7bd7), uint256(0x2a7cf10cd5923377e6dacdce979f966f2ed5245d62fea1e70743176c3e1b57b1));
    }
    function verify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
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
    event Verified(string s);
    function verifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[91] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
