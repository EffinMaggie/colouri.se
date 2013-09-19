<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:xhtml="http://www.w3.org/1999/xhtml"
              xmlns:colour="http://colouri.se/2012"
              xmlns="http://www.w3.org/1999/xhtml"
              version="1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8"
              doctype-public="-//W3C//DTD XHTML 1.1//EN"
              doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
              indent="no"
              media-type="application/xhtml+xml" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="precision">
    <xsl:param name="precision"/>
    <ul id="precision">
      <li>Precision: <xsl:value-of select="$precision"/></li>
    </ul>
  </xsl:template>

  <xsl:template match="colour:precision">
    <xsl:call-template name="precision">
      <xsl:with-param name="precision" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/colour:set[colour:colour[1][@space='hsl']]">
    <xsl:variable name="hueDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@hueDenominator"><xsl:value-of select="colour:colour[1]/@hueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="saturationDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@saturationDenominator"><xsl:value-of select="colour:colour[1]/@saturationDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="lightnessDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@lightnessDenominator"><xsl:value-of select="colour:colour[1]/@lightnessDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <html style="background: hsl({colour:colour[1]/@hue div $hueDenominator * 360},{colour:colour[1]/@saturation div $saturationDenominator * 100}%,{colour:colour[1]/@lightness div $lightnessDenominator * 100}%)">
      <head>
        <title>Colour</title>
      </head>
      <body>
        <ul class="set">
          <xsl:for-each select="colour:colour">
            <li><xsl:apply-templates select="."/></li>
          </xsl:for-each>
        </ul>
        <xsl:apply-templates select="colour:picker"/>
        <xsl:choose>
          <xsl:when test="colour:precision">
            <xsl:apply-templates select="colour:precision"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="precision">
              <xsl:with-param name="precision">24</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/colour:set[colour:colour[1][@space='rgb']]">
    <xsl:variable name="redDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@redDenominator"><xsl:value-of select="colour:colour[1]/@redDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="greenDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@greenDenominator"><xsl:value-of select="colour:colour[1]/@greenDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="blueDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@blueDenominator"><xsl:value-of select="colour:colour[1]/@blueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <html style="background: rgb({colour:colour[1]/@red div $redDenominator * 100}%,{colour:colour[1]/@green div $greenDenominator * 100}%,{colour:colour[1]/@blue div $blueDenominator * 100}%)">
      <head>
        <title>Colour</title>
      </head>
      <body>
        <ul class="set">
          <xsl:for-each select="colour:colour">
            <li><xsl:apply-templates select="."/></li>
          </xsl:for-each>
        </ul>
        <xsl:apply-templates select="colour:picker"/>
        <xsl:choose>
          <xsl:when test="colour:precision">
            <xsl:apply-templates select="colour:precision"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="precision">
              <xsl:with-param name="precision">24</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="colour:colour[@space='hsl']">
    <xsl:variable name="hueDenominator"><xsl:choose>
      <xsl:when test="@hueDenominator"><xsl:value-of select="@hueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="saturationDenominator"><xsl:choose>
      <xsl:when test="@saturationDenominator"><xsl:value-of select="@saturationDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="lightnessDenominator"><xsl:choose>
      <xsl:when test="@lightnessDenominator"><xsl:value-of select="@lightnessDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="precision"><xsl:if test="preceding::colour:precision[1]">.<xsl:value-of select="preceding::colour:precision[1]"/></xsl:if></xsl:variable>
    <a style="background: hsl({@hue div $hueDenominator * 360},{@saturation div $saturationDenominator * 100}%,{@lightness div $lightnessDenominator * 100}%)"
       href="/hsl:{@hue}/{$hueDenominator}:{@saturation}/{$saturationDenominator}:{@lightness}/{$lightnessDenominator}{$precision}">
      <xsl:choose>
        <xsl:when test="@type='small'">
          <xsl:attribute name="class">colour small</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">colour</xsl:attribute>(H, S, L) = (<xsl:value-of select="@hue"/>/<xsl:value-of select="$hueDenominator"/>, <xsl:value-of select="@saturation"/>/<xsl:value-of select="$saturationDenominator"/>, <xsl:value-of select="@lightness"/>/<xsl:value-of select="$lightnessDenominator"/>)</xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="colour:colour[@space='rgb']">
    <xsl:variable name="redDenominator"><xsl:choose>
      <xsl:when test="@redDenominator"><xsl:value-of select="@redDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="greenDenominator"><xsl:choose>
      <xsl:when test="@greenDenominator"><xsl:value-of select="@greenDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="blueDenominator"><xsl:choose>
      <xsl:when test="@blueDenominator"><xsl:value-of select="@blueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="precision"><xsl:if test="preceding::colour:precision[1]">.<xsl:value-of select="preceding::colour:precision[1]"/></xsl:if></xsl:variable>
    <a style="background: rgb({@red div $redDenominator * 100}%,{@green div $greenDenominator * 100}%,{@blue div $blueDenominator * 100}%)"
       href="/rgb:{@red}/{$redDenominator}:{@green}/{$greenDenominator}:{@blue}/{$blueDenominator}{$precision}">
      <xsl:choose>
        <xsl:when test="@type='small'">
          <xsl:attribute name="class">colour small</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">colour</xsl:attribute>(R, G, B) = (<xsl:value-of select="@red"/>/<xsl:value-of select="$redDenominator"/>, <xsl:value-of select="@green"/>/<xsl:value-of select="$greenDenominator"/>, <xsl:value-of select="@blue"/>/<xsl:value-of select="$blueDenominator"/>)</xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="colour:picker">
    <table class="picker">
      <xsl:apply-templates select="colour:set"/>
    </table>
  </xsl:template>

  <xsl:template match="colour:picker/colour:set">
    <tr>
      <xsl:for-each select="colour:colour">
        <td><xsl:apply-templates select="."/></td>
      </xsl:for-each>
    </tr>
  </xsl:template>
</xsl:stylesheet>
