/*
 * This file is part of the ef.gy project.
 * See the appropriate repository at http://ef.gy/.git for exact file
 * modification records.
*/

/*
 * Copyright (c) 2012, ef.gy Project Members
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
*/

#if !defined(EF_GY_CONTINUED_FRACTIONS_H)
#define EF_GY_CONTINUED_FRACTIONS_H

#include <ef.gy/fractions.h>

namespace efgy
{
    namespace math
    {
        namespace numeric
        {
            template <typename N>
            class continuedFractional : public numeric
            {
                public:
                    typedef N integer;

                    continuedFractional ()
                        : coefficientCount(N(0)), coefficient(N(0))
                        {}
                    continuedFractional (const N &t)
                        : coefficientCount(N(1)), coefficient(N(1))
                        {
                            coefficient[0] = t;
                        }
                    continuedFractional (const fractional<N> &pF)
                        : coefficientCount(N(0)), coefficient(N(0))
                        {
                            N i = N(0);
                            N p = N(0);
                            for (fractional<N> f = pF;
                                    (f.numerator != zero())
                                 && (f.denominator != zero());
                                 f = reciprocal(f - i))
                            {
                                i = N(f);

                                p = coefficientCount;
                                coefficientCount = p + N(1);
                                coefficient.resize(coefficientCount);
                                coefficient[p] = i;

                                if (f < zero())
                                {
                                    f *= N(-1);
                                    i  = -i;
                                }
                            }

                            if ((coefficientCount > one()) && (coefficient[p] == N(1)))
                            {
                                coefficientCount = p;
                                coefficient.resize(coefficientCount);
                                coefficient[(p - N(1))] += N(1);
                            }
                        }
                    continuedFractional (const continuedFractional &cf)
                        : coefficientCount(cf.coefficientCount), coefficient(cf.coefficient)
                        {}

                    continuedFractional &operator = (const continuedFractional &b)
                    {
                        coefficientCount = b.coefficientCount;
                        coefficient = b.coefficient;
                        return *this;
                    }
                    continuedFractional &operator = (const N &b)
                    {
                        coefficientCount = N(1);
                        coefficient.resize(coefficientCount);
                        coefficient[N(0)] = b;
                        return *this;
                    }
                    continuedFractional &operator = (const fractional<N> &b)
                    {
                        return (*this = continuedFractional(b));
                    }

                    continuedFractional operator + (const continuedFractional &b) const
                    {
                        binaryOperator op = binaryOperator::addition();
                        return op (*this, b);
                    }
                    continuedFractional &operator += (const continuedFractional &b);
                    continuedFractional operator + (const N &b) const;
                    continuedFractional &operator += (const N &b);

                    continuedFractional operator - (const continuedFractional &b) const;
                    continuedFractional &operator -= (const continuedFractional &b);
                    continuedFractional operator - (const N &b) const;
                    continuedFractional &operator -= (const N &b);
                    continuedFractional operator * (const continuedFractional &b) const;
                    continuedFractional &operator *= (const continuedFractional &b);
                    continuedFractional operator * (const N &b) const;
                    continuedFractional &operator *= (const N &b);

                    // missing: %

                    continuedFractional operator ^ (const N &b) const;
                    continuedFractional &operator ^= (const N &b);

                    // missing: ^ (fraction)

                    continuedFractional operator / (const continuedFractional &b) const;
                    continuedFractional &operator /= (const continuedFractional &b);
                    continuedFractional operator / (const N &b) const;
                    continuedFractional &operator /= (const N &b);

                    // missing: >, >=, <, <=
                    //
                    bool operator > (const continuedFractional &b) const;
                    bool operator > (const zero &b) const;
                    bool operator > (const one &b) const;
                    bool operator > (const negativeOne &b) const;
                    bool operator == (const continuedFractional &b) const;
                    bool operator == (const zero &b) const;
                    bool operator == (const one &b) const;
                    bool operator == (const negativeOne &b) const;

                    continuedFractional operator , (const N &b) const
                    {
                        continuedFractional rv = *this;
                        N p = rv.coefficientCount;
                        rv.coefficientCount++;
                        rv.coefficient.resize(rv.coefficientCount);
                        rv.coefficient[p] = b;
                        return rv;
                    }

                    // missing: !

                    operator std::string (void) const
                    {
                        if (coefficientCount == N(0))
                        {
                            return std::string("[ 0 ]");
                        }

                        std::string r = "[";
                        for (N i = N(0); i < coefficientCount; i++)
                        {
                            if (i == N(0))
                            {
                                r += " " + data::intToString(coefficient[i]);
                            }
                            else if (i == N(1))
                            {
                                r += "; " + data::intToString(coefficient[i]);
                            }
                            else
                            {
                                r += ", " + data::intToString(coefficient[i]);
                            }
                        }

                        return r + " ]";
                    }

                    operator fractional<N> (void) const
                    {
                        fractional<N> rv;
                        N j = coefficientCount - N(1);
                        for (N i = j; i >= N(0); i--)
                        {
                            if (i == j)
                            {
                                rv = fractional<N>(N(coefficient[i]));
                            }
                            else
                            {
                                rv = reciprocal(rv) + coefficient[i];
                            }
                        }
                        return rv;
                    }

                    data::scratchPad<N> coefficient;
                    N coefficientCount;

                protected:
                    class binaryOperator
                    {
                        public:
                            binaryOperator(void)
                                : a(N(0)), b(N(0)), c(N(0)), d(N(0)),
                                  e(N(0)), f(N(0)), g(N(0)), h(N(0))
                                {}

                            binaryOperator
                                (N pA, N pB, N pC, N pD,
                                 N pE, N pF, N pG, N pH)
                                : a(pA), b(pB), c(pC), d(pD),
                                  e(pE), f(pF), g(pG), h(pH)
                                {}

                            continuedFractional operator ()
                                (const continuedFractional &x,
                                 const continuedFractional &y) const
                            {
                                binaryOperator op = *this;
                                continuedFractional rv;
                                N px = N(0),
                                  py = N(0);
                                bool xInf = false, yInf = false, rInf = false;
                                while (1)
                                {
                                    std::cerr << "( " << data::intToString(op.a) << " " << data::intToString(op.b) << " " << data::intToString(op.c) << " " << data::intToString(op.d) << " )\n"
                                              << "( " << data::intToString(op.e) << " " << data::intToString(op.f) << " " << data::intToString(op.g) << " " << data::intToString(op.h) << " )\n";
                                    fractional<N> ae = fractional<N>(op.a, op.e),
                                                  bf = fractional<N>(op.b, op.f),
                                                  cg = fractional<N>(op.c, op.g),
                                                  dh = fractional<N>(op.d, op.h);

                                    N rae, rbf, rcg, rdh;

                                    if (op.e != zero()) { rae = N(ae); }
                                    if (op.f != zero()) { rbf = N(bf); }
                                    if (op.g != zero()) { rcg = N(cg); }
                                    if (op.h != zero()) { rdh = N(dh); }

                                    if ((op.e != zero()) && (op.f != zero()) && (op.g != zero()) && (op.h != zero()))
                                    {
                                        if ((rae == rbf) && (rbf == rcg) && (rcg == rdh))
                                        {
                                            std::cerr << "=>" << data::intToString(rae) << "\n";
                                            op = op.output (rae);
                                            rv = (rv, rae);
                                            continue;
                                        }
                                    }

                                    if ((op.e == zero()) && (op.f == zero()) && (op.g == zero()) && (op.h == zero()))
                                    {
                                        break;
                                    }

                                    if (xInf && yInf)
                                    {
                                        if (op.h != zero())
                                        {
                                            continuedFractional<N> cfdh = dh;
                                            for (N i = N(0);
                                                 i < cfdh.coefficientCount;
                                                 i++)
                                            {
                                                rv = (rv, cfdh.coefficient[i]);
                                            }
                                        }
                                        break;
                                    }

                                    fractional<N> aecg = ae - cg;
                                    fractional<N> bfdh = bf - dh;
                                    fractional<N> aebf = ae - bf;
                                    fractional<N> cgdh = cg - dh;

                                    if (aecg < zero()) { aecg *= N(-1); }
                                    if (bfdh < zero()) { bfdh *= N(-1); }
                                    if (aebf < zero()) { aebf *= N(-1); }
                                    if (cgdh < zero()) { cgdh *= N(-1); }

                                    fractional<N> xw = (aecg > bfdh) ? aecg : bfdh;
                                    fractional<N> yw = (aebf > cgdh) ? aebf : cgdh;

                                    if ((op.f == zero()) || (op.h == zero()))
                                    {
                                        goto processY;
                                    }
                                    if ((op.e == zero()) || (op.g == zero()))
                                    {
                                        goto processX;
                                    }

                                    if ((op.g == zero()) || (xw > yw))
                                    {
                                    processX:
                                        if (px < x.coefficientCount)
                                        {
                                            std::cerr << "x() = " << x.coefficient[px] << "\n";
                                            op = op.insertX (x.coefficient[px]);
                                            px++;
                                        }
                                        else if (!xInf)
                                        {
                                            std::cerr << "x() = inf\n";
                                            op = op.insertXinf ();
                                            xInf = true;
                                        }
                                        else
                                        {
                                            goto processY;
                                        }
                                    }
                                    else
                                    {
                                    processY:
                                        if (py < y.coefficientCount)
                                        {
                                            std::cerr << "y() = " << y.coefficient[py] << "\n";
                                            op = op.insertY (y.coefficient[py]);
                                            py++;
                                        }
                                        else if (!yInf)
                                        {
                                            std::cerr << "y() = inf\n";
                                            op = op.insertYinf ();
                                            yInf = true;
                                        }
                                        else
                                        {
                                            goto processX;
                                        }
                                    }
                                }
                                return rv;
                            }

                            binaryOperator insertX (N P) const
                            {
                                return binaryOperator
                                    (b, a + b * P, d, c + d * P,
                                     f, e + f * P, h, g + h * P);
                            }

                            binaryOperator insertXinf () const
                            {
                                return binaryOperator
                                    (a, b, a, b,
                                     e, f, e, f);
                            }

                            binaryOperator insertY (N Q) const
                            {
                                return binaryOperator
                                    (c, d, a + c * Q, b + d * Q,
                                     g, h, e + g * Q, f + h * Q);
                            }

                            binaryOperator insertYinf () const
                            {
                                return binaryOperator
                                    (c, d, c, d,
                                     g, h, g, h);
                            }

                            binaryOperator output (N R) const
                            {
                                return binaryOperator
                                    (        e,         f,         g,         h,
                                     a - e * R, b - f * R, c - g * R, d - h * R);
                            }

                            static binaryOperator addition (void)
                            {
                                return binaryOperator
                                    ( 0,  1,  1,  0,
                                      1,  0,  0,  0);
                            }

                            static binaryOperator subtraction (void)
                            {
                                return binaryOperator
                                    ( 0,  1, -1,  0,
                                      1,  0,  0,  0);
                            }

                            static binaryOperator multiplication (void)
                            {
                                return binaryOperator
                                    ( 0,  0,  0,  1,
                                      1,  0,  0,  0);
                            }

                            static binaryOperator division (void)
                            {
                                return binaryOperator
                                    ( 0,  1,  0,  0,
                                      0,  0,  1,  0);
                            }

                        protected:
                            N a, b, c, d, e, f, g, h;
                    };
            };

            template <typename N>
            fractional<N> round
                (const fractional<N> &pQ,
                 const unsigned long precision = 24)
            {
                const unsigned long long maxNumerator = (1 << precision) - 1;
                const unsigned long long maxDenominator = (1 << precision) - 1;
                continuedFractional<N> cf = pQ;
                fractional<N> q = cf;
                bool negative = q < zero();
                while (   (negative
                            ? (q.numerator < -N(maxNumerator))
                            : (q.numerator > N(maxNumerator)))
                       || (q.denominator > N(maxDenominator)))
                {
                    cf.coefficientCount -= N(1);
                    cf.coefficient.resize(cf.coefficientCount);
                    q = cf;
                }
                return q;
            }
        };
    };
};

#endif
