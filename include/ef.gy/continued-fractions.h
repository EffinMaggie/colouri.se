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
                                i = f.numerator;
                                i /= f.denominator;

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

                    continuedFractional &operator = (const continuedFractional &b);
                    continuedFractional &operator = (const N &b);

                    continuedFractional operator + (const continuedFractional &b) const;
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

                    // missing: !

                    operator std::string (void) const
                    {
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
            };

            template <typename N>
            fractional<N> round
                (const fractional<N> &pQ,
                 const unsigned long long maxNumerator = ((1 << 24) - 1),
                 const unsigned long long maxDenominator = ((1 << 24) - 1))
            {
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
