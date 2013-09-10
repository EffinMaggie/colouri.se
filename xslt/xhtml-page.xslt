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
          <xsl:apply-templates select="node()"/>
        </ul>
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
          <xsl:apply-templates select="node()"/>
        </ul>
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
    <li class="colour" style="background: hsl({@hue div $hueDenominator * 360},{@saturation div $saturationDenominator * 100}%,{@lightness div $lightnessDenominator * 100}%)">(H, S, L) = (<xsl:value-of select="@hue"/>/<xsl:value-of select="$hueDenominator"/>, <xsl:value-of select="@saturation"/>/<xsl:value-of select="$saturationDenominator"/>, <xsl:value-of select="@lightness"/>/<xsl:value-of select="$lightnessDenominator"/>)</li>
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
    <li class="colour" style="background: rgb({@red div $redDenominator * 100}%,{@green div $greenDenominator * 100}%,{@blue div $blueDenominator * 100}%)">(R, G, B) = (<xsl:value-of select="@red"/>/<xsl:value-of select="$redDenominator"/>, <xsl:value-of select="@green"/>/<xsl:value-of select="$greenDenominator"/>, <xsl:value-of select="@blue"/>/<xsl:value-of select="$blueDenominator"/>)</li>
  </xsl:template>
</xsl:stylesheet>
