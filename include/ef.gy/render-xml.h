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

#if !defined(EF_GY_RENDER_XML_H)
#define EF_GY_RENDER_XML_H

#include <ef.gy/render.h>
#include <ef.gy/string.h>
#include <string>

namespace efgy
{
    namespace render
    {
        template <class Q>
        std::string xml (const Q &value)
        {
            throw "no conversion to XML known";
            return "";
        }

        template <>
        std::string xml (const colour::HSL<math::fraction>::value &value)
        {
            return std::string("<colour xmlns='http://colouri.se/2012' space='hsl'")
                 + " hue='" + data::intToString<long long>(value.hue.numerator) + "'"
                 + (value.hue.denominator != math::numeric::one()
                   ? " hueDenominator='" + data::intToString<long long>(value.hue.denominator) + "'"
                   : "")
                 + " saturation='" + data::intToString<long long>(value.saturation.numerator) + "'"
                 + (value.saturation.denominator != math::numeric::one()
                   ? " saturationDenominator='" + data::intToString<long long>(value.saturation.denominator) + "'"
                   : "")
                 + " lightness='" + data::intToString<long long>(value.lightness.numerator) + "'"
                 + (value.lightness.denominator != math::numeric::one()
                   ? " lightnessDenominator='" + data::intToString<long long>(value.lightness.denominator) + "'"
                   : "")
                 + "/>";
        }

        template <>
        std::string xml (const colour::RGB<math::fraction>::value &value)
        {
            return std::string("<colour xmlns='http://colouri.se/2012' space='rgb'")
                 + " red='" + data::intToString<long long>(value.red.numerator) + "'"
                 + (value.red.denominator != math::numeric::one()
                   ? " redDenominator='" + data::intToString<long long>(value.red.denominator) + "'"
                   : "")
                 + " green='" + data::intToString<long long>(value.green.numerator) + "'"
                 + (value.green.denominator != math::numeric::one()
                   ? " greenDenominator='" + data::intToString<long long>(value.green.denominator) + "'"
                   : "")
                 + " blue='" + data::intToString<long long>(value.blue.numerator) + "'"
                 + (value.blue.denominator != math::numeric::one()
                   ? " blueDenominator='" + data::intToString<long long>(value.blue.denominator) + "'"
                   : "")
                 + "/>";
        }
    };
};

#endif
