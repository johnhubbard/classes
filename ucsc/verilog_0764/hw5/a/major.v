// File: major.v
// John Hubbard, 18 Oct 2014
// hw5a assignment for Verilog 0764 class: Problem 4.4.1: Majority Circuit
//

module major(a, f);
    input [4:0] a;
    output f;

    wire na0, na1, na2, na3, na4;
    wire x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf;

    not notA4(na4, a[4]);
    not notA3(na3, a[3]);
    not notA2(na2, a[2]);
    not notA1(na1, a[1]);
    not notA0(na0, a[0]);

    and x0(x0,    na4,  na3,     a[2],    a[1],   a[0]); // 00111
    and x1(x1,    na4,   a[3],  na2,      a[1],   a[0]); // 01011
    and x2(x2,    na4,   a[3],   a[2],   na1,     a[0]); // 01101
    and x3(x3,    na4,   a[3],   a[2],    a[1],  na0);   // 01110

    and x4(x4,    na4, a3,    a[2],      a[1],      a[0]); // 01111
    and x5(x5,    a4, na3,   na2,        a[1],      a[0]); // 10011
    and x6(x6,    a4, na3,    a[2],     na1,        a[0]); // 10101
    and x7(x7,    a4, na3,    a[2],      a[1],     na0);   // 10110

    and x8(x8,    a4, na3,   a[2],     a[1],      a[0]); // 10111
    and x9(x9,    a4, a3,   na2,      na1,      a[0]);   // 11001
    and xa(xa,    a4, a3,   na2,       a[1],     na0);   // 11010
    and xb(xb,    a4, a3,   na2,       a[1],      a[0]); // 11011

    and xc(xc,    a4, a3,   a[2],     na1,     na0);   // 11100
    and xd(xd,    a4, a3,   a[2],     na1,      a[0]); // 11101
    and xe(xe,    a4, a3,   a[2],      a[1],   na0);   // 11110
    and xf(xf,    a4, a3,   a[2],      a[1],    a[0]); // 11111

    or f0(f, x0, x1, x2, x3, x4, x5, x6, x7,
             x8, x9, xa, xb, xc, xd, xe, xf);

endmodule

